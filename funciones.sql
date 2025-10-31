USE espacios_magnificos;

-- 1. 
DELIMITER $$
CREATE FUNCTION FN_capacidadconfiguracion(id_recinto INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE capacidad_final INT;
    DECLARE tipo_configuracion VARCHAR(50);

    SELECT configuracion INTO tipo_configuracion
    FROM recinto
    WHERE id_recinto = id_recinto;

    SELECT CASE 
        WHEN tipo_configuracion = 'teatro' THEN capacidad
        WHEN tipo_configuracion = 'escuela' THEN ROUND(capacidad * 0.8)
        WHEN tipo_configuracion = 'banquete' THEN ROUND(capacidad * 0.6)
        ELSE capacidad
    END INTO capacidad_final
    FROM recinto
    WHERE id_recinto = id_recinto;

    RETURN capacidad_final;
END$$
DELIMITER ;

-- 2. 
DELIMITER $$
CREATE FUNCTION FN_Disponibilidadperiodo(id_recinto INT, fecha_inicio DATE, fecha_fin DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE disponible VARCHAR(50);

    IF EXISTS (
        SELECT 1
        FROM eventos
        WHERE id_recinto = id_recinto
        AND (
            (fecha_inicio BETWEEN fecha_inicio AND fecha_fin)
            OR (fecha_fin BETWEEN fecha_inicio AND fecha_fin)
            OR (fecha_inicio <= fecha_inicio AND fecha_fin >= fecha_fin)
        )
    ) THEN
        SET disponible = 'Ocupado';
    ELSE
        SET disponible = 'Disponible';
    END IF;

    RETURN disponible;
END$$
DELIMITER ;

-- 3. 
DELIMITER $$
CREATE FUNCTION FN_Personaldisponible(tipo_personal VARCHAR(50), fecha_evento DATE)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_disponible INT;

    SELECT COUNT(*) INTO total_disponible
    FROM personal
    WHERE especialidad = tipo_personal
    AND disponibilidad_fechas LIKE CONCAT('%', DATE_FORMAT(fecha_evento, '%W'), '%');

    RETURN total_disponible;
END$$
DELIMITER ;

-- 4. 
DELIMITER $$
CREATE FUNCTION FN_Presupuestoevento(id_evento INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(precio_base)
    INTO total
    FROM servicios
    WHERE nombre IN (
        SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(servicios_contratados, ',', n.n), ',', -1))
        FROM eventos
        JOIN (
            SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
        ) n
        ON CHAR_LENGTH(servicios_contratados)
            -CHAR_LENGTH(REPLACE(servicios_contratados, ',', '')) >= n.n-1
        WHERE id_eventos = id_evento
    );

    RETURN IFNULL(total, 0);
END$$
DELIMITER ;

-- 5. 
DELIMITER $$ 
CREATE FUNCTION FN_Ocupacionanual(id_recinto INT, anio INT)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE dias_ocupados INT;
    DECLARE total_dias INT;
    DECLARE porcentaje DECIMAL(5,2);

    SELECT SUM(DATEDIFF(fecha_fin, fecha_inicio) + 1)
    INTO dias_ocupados
    FROM eventos
    WHERE id_recinto = id_recinto
    AND YEAR(fecha_inicio) = anio;

    SET total_dias = 365;
    SET porcentaje = (dias_ocupados / total_dias) * 100;

    RETURN IFNULL(porcentaje, 0);
END$$
DELIMITER ;


SHOW FUNCTION STATUS WHERE Db = 'espacios_magnificos';

