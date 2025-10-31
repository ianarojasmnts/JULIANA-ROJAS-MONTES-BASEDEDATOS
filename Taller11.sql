-- 1.	¿Cuáles son todos los servicios contratados para un evento específico?

SELECT 
    numero_unico AS codigo_evento,
    titulo AS nombre_evento,
    servicios_contratados
FROM eventos
WHERE id_eventos = 1;


-- 2.	¿Qué eventos tienen más de 200 asistentes?

SELECT 
    numero_unico,
    titulo,
    asistentes_estimados
FROM eventos
WHERE asistentes_estimados > 200;


-- 3.	¿Cuáles son los recintos disponibles el 10 de mayo de 2024 con capacidad mínima de 100 personas?

SELECT 
    nombre,
    tipo,
    capacidad,
    tarifa,
    disponibilidad
FROM recinto
WHERE capacidad >= 100
  AND disponibilidad = 'disponible'
  AND id_recinto NOT IN (
        SELECT id_recinto
        FROM eventos
        WHERE '2024-05-10' BETWEEN fecha_inicio AND fecha_fin
    );
-- 4.	¿Qué eventos son conferencias o reuniones corporativas?

SELECT 
    numero_unico,
    titulo,
    tipo,
    estado
FROM eventos
WHERE tipo IN ('congreso', 'feria');  

-- 5.	¿Cuáles son las cotizaciones emitidas en febrero de 2024?

SELECT 
    numero_secuencial,
    fecha_emision,
    validez,
    id_cliente,
    id_evento
FROM cotizaciones
WHERE MONTH(fecha_emision) = 2
  AND YEAR(fecha_emision) = 2024;
  
-- 6.	¿Qué equipamientos son de tipo Audiovisual, Mobiliario o Iluminación?

SELECT 
    codigo_inventario,
    tipo,
    descripcion,
    estado
FROM equipamiento
WHERE tipo IN ('audiovisual', 'mobiliario', 'decoración');

-- 7.	¿Cuáles son los servicios con descripciones que contienen las palabras "premium" o "exclusivo"?

SELECT 
    codigo,
    nombre,
    categoria,
    descripcion
FROM servicios
WHERE descripcion LIKE 'premium'
   OR descripcion LIKE 'exclusivo';
   
-- 8.	¿Qué eventos pasados no tienen evaluación post-evento?

SELECT 
    numero_unico,
    titulo,
    fecha_inicio,
    estado
FROM eventos
WHERE fecha_fin < CURDATE()
  AND id_eventos NOT IN (
        SELECT id_evento
        FROM evaluaciones
    );
    
-- 9.	¿Cuáles son los recintos ordenados por capacidad descendente y tarifa ascendente?

SELECT 
    nombre,
    tipo,
    capacidad,
    tarifa
FROM recinto
ORDER BY capacidad DESC, tarifa ASC;


-- 10.	¿Cuáles son los ingresos totales por tipo de evento y mes?

SELECT 
    tipo AS tipo_evento,
    MONTH(fecha_inicio) AS mes,
    SUM(presupuesto_aprobado) AS ingresos_totales
FROM eventos
GROUP BY tipo, MONTH(fecha_inicio)
ORDER BY mes, tipo_evento;