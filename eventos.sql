USE espacios_magnificos;

SET GLOBAL event_scheduler = ON;


-- 1. Verifica los preparativos de eventos próximos

DELIMITER $$
CREATE EVENT EVT_Preparativoseventos
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
COMMENT 'Verifica los eventos próximos y genera alertas de preparación'
DO
BEGIN
   
    INSERT INTO planificacion (codigo_evento, cronograma_actividades, horarios_especificos, recintos_configuracion, necesidades_tecnicas, servicios_catering, horarios_menus, personal_asignado, observaciones)
    SELECT 
        id_eventos,
        'Pendiente generar cronograma',
        'Por definir',
        'Por definir',
        'Verificar requerimientos técnicos',
        'Por confirmar catering',
        'Por definir menús',
        'Por asignar personal',
        'Evento próximo: pendiente de planificación'
    FROM eventos
    WHERE fecha_inicio BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 3 DAY)
      AND id_eventos NOT IN (SELECT codigo_evento FROM planificacion);
END$$
DELIMITER ;


-- 2. Genera reportes automáticos posteriores a eventos realizados

DELIMITER $$
CREATE EVENT EVT_Reportespostevento
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
COMMENT 'Genera reportes semanales de eventos finalizados'
DO
BEGIN
    CREATE TABLE IF NOT EXISTS reportes_post_evento (
        id_reporte INT PRIMARY KEY AUTO_INCREMENT,
        id_evento INT,
        titulo VARCHAR(100),
        cliente VARCHAR(100),
        recinto VARCHAR(100),
        puntuacion_promedio DECIMAL(5,2),
        fecha_reporte DATETIME
    );

    INSERT INTO reportes_post_evento (id_evento, titulo, cliente, recinto, puntuacion_promedio, fecha_reporte)
    SELECT 
        e.id_eventos,
        e.titulo,
        c.razon_social,
        r.nombre,
        IFNULL(AVG(ev.puntuacion), 0),
        NOW()
    FROM eventos e
    INNER JOIN clientes c ON e.id_cliente = c.id_clientes
    INNER JOIN recinto r ON e.id_recinto = r.id_recinto
    LEFT JOIN evaluaciones ev ON e.id_eventos = ev.id_evento
    WHERE e.estado = 'finalizado'
    GROUP BY e.id_eventos;
END$$
DELIMITER ;


-- 3. Actualiza disponibilidad temporal de recintos según eventos próximos

DELIMITER $$
CREATE EVENT EVT_Disponibilidadtemporal
ON SCHEDULE EVERY 6 HOUR
STARTS CURRENT_TIMESTAMP
COMMENT 'Actualiza disponibilidad temporal de recintos con eventos próximos'
DO
BEGIN
    UPDATE recinto
    SET disponibilidad = 'ocupado'
    WHERE id_recinto IN (
        SELECT id_recinto FROM eventos
        WHERE fecha_inicio BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 1 DAY)
        AND estado IN ('confirmado', 'planificando')
    );

    UPDATE recinto
    SET disponibilidad = 'disponible'
    WHERE id_recinto NOT IN (
        SELECT id_recinto FROM eventos
        WHERE fecha_inicio BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 1 DAY)
    );
END$$
DELIMITER ;


-- 4. Programa mantenimiento preventivo del equipamiento

DELIMITER $$
CREATE EVENT EVT_Mantenimientoequipos
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
COMMENT 'Ejecuta mantenimiento preventivo semanal en equipos con más de 6 meses de uso'
DO
BEGIN
    CREATE TABLE IF NOT EXISTS mantenimiento_log (
        id_mantenimiento INT PRIMARY KEY AUTO_INCREMENT,
        id_equipamiento INT,
        descripcion VARCHAR(200),
        fecha_mantenimiento DATETIME
    );

    INSERT INTO mantenimiento_log (id_equipamiento, descripcion, fecha_mantenimiento)
    SELECT 
        id_equipamiento,
        CONCAT('Mantenimiento preventivo realizado a equipo ', codigo_inventario),
        NOW()
    FROM equipamiento
    WHERE vida_util LIKE '%años%'
      AND estado IN ('bueno', 'excelente');
END$$
DELIMITER ;

-- 5. Analiza rendimiento y satisfacción por tipo de servicio

DELIMITER $$
CREATE EVENT EVT_Rendimientoservicios
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-11-01 00:00:00'
COMMENT 'Analiza mensualmente el rendimiento y satisfacción de servicios contratados'
DO
BEGIN
    CREATE TABLE IF NOT EXISTS rendimiento_servicios (
        id_registro INT PRIMARY KEY AUTO_INCREMENT,
        categoria_servicio VARCHAR(50),
        total_eventos INT,
        promedio_puntuacion DECIMAL(5,2),
        fecha_registro DATETIME
    );

    INSERT INTO rendimiento_servicios (categoria_servicio, total_eventos, promedio_puntuacion, fecha_registro)
    SELECT 
        s.categoria,
        COUNT(DISTINCT e.id_eventos),
        IFNULL(AVG(ev.puntuacion), 0),
        NOW()
    FROM servicios s
    LEFT JOIN eventos e ON e.servicios_contratados LIKE CONCAT('%', s.nombre, '%')
    LEFT JOIN evaluaciones ev ON ev.id_evento = e.id_eventos
    GROUP BY s.categoria;
END$$
DELIMITER ;

SHOW EVENTS;
