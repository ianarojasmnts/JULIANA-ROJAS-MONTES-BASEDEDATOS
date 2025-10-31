USE espacios_magnificos;


-- 1️Crear cotizacion evento
DELIMITER //
CREATE PROCEDURE Crear_Cotizacion_Evento(
    IN id_cliente INT,
    IN id_evento INT,
    IN recintos_sugeridos VARCHAR(100),
    IN servicios_incluidos VARCHAR(200),
    IN detalle_costos VARCHAR(500),
    IN condiciones_pago VARCHAR(100),
    IN descuentos_aplicables VARCHAR(100),
    IN observaciones VARCHAR(500)
)
BEGIN
    INSERT INTO cotizaciones (
        numero_secuencial,
        fecha_emision,
        validez,
        id_cliente,
        id_evento,
        recintos_sugeridos,
        servicios_incluidos,
        detalle_costos,
        condiciones_pago,
        descuentos_aplicables,
        observaciones
    )
    VALUES (
        CONCAT('COT-', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')),
        CURDATE(),
        DATE_ADD(CURDATE(), INTERVAL 30 DAY),
        id_cliente,
        id_evento,
        recintos_sugeridos,
        servicios_incluidos,
        detalle_costos,
        condiciones_pago,
        descuentos_aplicables,
        observaciones
    );
END //
DELIMITER ;

-- 2️Reservar Recinto
DELIMITER //
CREATE PROCEDURE Reservar_recinto(
    IN id_evento INT,
    IN id_recinto INT
)
BEGIN
    DECLARE disponibilidad_actual VARCHAR(50);

    SELECT disponibilidad INTO disponibilidad_actual
    FROM recinto
    WHERE id_recinto = id_recinto;

    IF disponibilidad_actual = 'disponible' THEN
        UPDATE eventos
        SET id_recinto = id_recinto,
            estado = 'confirmado'
        WHERE id_eventos = id_evento;

        UPDATE recinto
        SET disponibilidad = 'ocupado'
        WHERE id_recinto = id_recinto;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El recinto no está disponible para reserva.';
    END IF;
END //
DELIMITER ;

-- 3️Asignar equipamiento evento
DELIMITER //
CREATE PROCEDURE Equipamiento_evento(
    IN id_evento INT,
    IN id_equipamiento INT
)
BEGIN
    UPDATE equipamiento
    SET estado = 'en uso'
    WHERE id_equipamiento = id_equipamiento;

    INSERT INTO planificacion (
        codigo_evento,
        cronograma_actividades,
        horarios_especificos,
        recintos_configuracion,
        necesidades_tecnicas,
        servicios_catering,
        horarios_menus,
        personal_asignado,
        observaciones
    )
    VALUES (
        id_evento,
        'Equipamiento asignado al evento',
        'A coordinar según horarios del evento',
        'Configuración estándar de recinto',
        CONCAT('Equipamiento ID ', id_equipamiento, ' en uso'),
        'Por definir',
        'Por definir',
        'Por definir',
        'Equipamiento marcado como en uso'
    );
END //
DELIMITER ;

-- 4️Programar personal evento
DELIMITER //
CREATE PROCEDURE Personal_evento(
    IN id_evento INT,
    IN tipo_evento VARCHAR(50)
)
BEGIN
    DECLARE tipo_personal VARCHAR(50);

    IF tipo_evento = 'boda' THEN
        SET tipo_personal = 'coordinador';
    ELSEIF tipo_evento = 'congreso' THEN
        SET tipo_personal = 'técnico';
    ELSEIF tipo_evento = 'feria' THEN
        SET tipo_personal = 'seguridad';
    ELSE
        SET tipo_personal = 'camarero';
    END IF;

    UPDATE personal
    SET eventos_asignados = CONCAT(eventos_asignados, ',EV-', id_evento)
    WHERE especialidad = tipo_personal;

    INSERT INTO planificacion (
        codigo_evento,
        cronograma_actividades,
        horarios_especificos,
        recintos_configuracion,
        necesidades_tecnicas,
        servicios_catering,
        horarios_menus,
        personal_asignado,
        observaciones
    )
    VALUES (
        id_evento,
        'Personal asignado automáticamente',
        'A definir según agenda del evento',
        'Configuración base',
        'Verificar soporte técnico',
        'Catering base',
        'Horario general del evento',
        tipo_personal,
        'Asignación generada automáticamente según tipo de evento'
    );
END //
DELIMITER ;

-- 5️Registrar evaluacion postEvento
DELIMITER //
CREATE PROCEDURE Evaluacion_Postevento(
    IN id_evento INT,
    IN aspectos_valorados TEXT,
    IN puntuacion DECIMAL(5,2),
    IN comentarios_cliente TEXT,
    IN incidencias TEXT,
    IN lecciones_aprendidas TEXT,
    IN recomendaciones TEXT
)
BEGIN
    INSERT INTO evaluaciones (
        codigo,
        id_evento,
        fecha_evaluacion,
        aspectos_valorados,
        puntuacion,
        comentarios_cliente,
        incidencias,
        lecciones_aprendidas,
        recomendaciones
    )
    VALUES (
        CONCAT('EVAL-', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')),
        id_evento,
        CURDATE(),
        aspectos_valorados,
        puntuacion,
        comentarios_cliente,
        incidencias,
        lecciones_aprendidas,
        recomendaciones
    );
END //
DELIMITER ;

SHOW PROCEDURE STATUS WHERE Db = 'espacios_magnificos';

