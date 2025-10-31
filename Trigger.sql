USE espacios_magnificos;

-- 1. Actualiza la disponibilidad del recinto al reservar o finalizar un evento
DELIMITER //
CREATE TRIGGER TR_disponibilidadrecinto
AFTER UPDATE ON eventos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'confirmado' THEN
        UPDATE recinto
        SET disponibilidad = 'ocupado'
        WHERE id_recinto = NEW.id_recinto;
    ELSEIF NEW.estado = 'finalizado' THEN
        UPDATE recinto
        SET disponibilidad = 'disponible'
        WHERE id_recinto = NEW.id_recinto;
    END IF;
END //
DELIMITER ;

-- 2. Verifica que no existan eventos en el mismo recinto y horario
DELIMITER //
CREATE TRIGGER TR_conflictoshorarios
BEFORE INSERT ON eventos
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM eventos
        WHERE id_recinto = NEW.id_recinto
        AND (
            (NEW.fecha_inicio BETWEEN fecha_inicio AND fecha_fin)
            OR (NEW.fecha_fin BETWEEN fecha_inicio AND fecha_fin)
            OR (fecha_inicio BETWEEN NEW.fecha_inicio AND NEW.fecha_fin)
        )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Conflicto de horario. El recinto ya está reservado en ese rango de fechas.';
    END IF;
END //
DELIMITER ;

-- 3. Marca el equipamiento como "en uso" cuando se asigna a un evento en la planificación
DELIMITER //
CREATE TRIGGER TR_inventarioequipamiento
AFTER INSERT ON planificacion
FOR EACH ROW
BEGIN
    UPDATE equipamiento
    SET estado = 'en uso'
    WHERE id_recinto IN (
        SELECT id_recinto
        FROM eventos
        WHERE id_eventos = NEW.codigo_evento
    );
END //
DELIMITER ;


-- 4. Recalcula automáticamente el presupuesto del evento al modificar una cotización
DELIMITER //
CREATE TRIGGER TR_costosevento
AFTER UPDATE ON cotizaciones
FOR EACH ROW
BEGIN
    UPDATE eventos
    SET presupuesto_aprobado = 
        (SELECT SUM(equipamiento.valor_reposicion * 0.05)
         FROM equipamiento
         WHERE id_recinto = eventos.id_recinto)
        + (SELECT COUNT(*) * 50000 FROM servicios)
    WHERE id_eventos = NEW.id_evento;
END //
DELIMITER ;


-- 5. Genera un registro automático en la planificación cuando un evento pasa a "confirmado"
DELIMITER //
CREATE TRIGGER TR_cronogramaactividades
AFTER UPDATE ON eventos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'confirmado' THEN
        INSERT INTO planificacion (codigo_evento, cronograma_actividades, horarios_especificos, recintos_configuracion, necesidades_tecnicas, servicios_catering, horarios_menus, personal_asignado, observaciones)
        VALUES (
            NEW.id_eventos,
            CONCAT('Cronograma generado automáticamente para el evento ', NEW.titulo),
            CONCAT('Inicio: ', NEW.hora_inicio, ' Fin: ', NEW.hora_fin),
            'Configuración estándar de recinto',
            'Verificar disponibilidad técnica general',
            'Catering básico asignado',
            'Menú estándar corporativo',
            'Personal asignado por defecto',
            'Cronograma creado automáticamente al confirmar evento'
        );
    END IF;
END //
DELIMITER ;


SHOW TRIGGERS;
