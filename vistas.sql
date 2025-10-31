USE espacios_magnificos;

-- PUNTO 1: V_EventosProgramados
CREATE VIEW V_EventosProgramados AS
SELECT 
    eventos.id_eventos, eventos.numero_unico AS codigo_evento, eventos.titulo, eventos.tipo, recinto.nombre AS nombre_recinto,
    recinto.ubicacion, eventos.fecha_inicio, eventos.fecha_fin, eventos.hora_inicio, eventos.hora_fin, eventos.estado,
    eventos.responsable_interno
FROM eventos
INNER JOIN recinto ON eventos.id_recinto = recinto.id_recinto
WHERE eventos.estado IN ('confirmado', 'planificando', 'cotizado')
ORDER BY eventos.fecha_inicio, eventos.hora_inicio;

-- PUNTO 2: V_DisponibilidadRecintos
CREATE VIEW V_DisponibilidadRecintos AS
SELECT 
    recinto.id_recinto, recinto.codigo, recinto.nombre AS nombre_recinto, recinto.tipo, recinto.capacidad,
    recinto.ubicacion, recinto.disponibilidad, eventos.titulo AS evento_asociado, eventos.fecha_inicio,
    eventos.fecha_fin, eventos.hora_inicio, eventos.hora_fin, eventos.estado
FROM recinto
LEFT JOIN eventos ON recinto.id_recinto = eventos.id_recinto
ORDER BY recinto.nombre, eventos.fecha_inicio;

-- PUNTO 3: V_EquipamientoDisponible
CREATE VIEW V_EquipamientoDisponible AS
SELECT 
    equipamiento.id_equipamiento, equipamiento.codigo_inventario, equipamiento.tipo, equipamiento.descripcion,
    equipamiento.cantidad_disponible, equipamiento.estado, equipamiento.ubicacion_almacenamiento, equipamiento.valor_reposicion,
    equipamiento.vida_util
FROM equipamiento
WHERE equipamiento.estado IN ('excelente', 'bueno', 'nuevo')
ORDER BY equipamiento.tipo, equipamiento.descripcion;

-- PUNTO 4: V_CotizacionesPendientes
CREATE VIEW V_CotizacionesPendientes AS
SELECT 
    cotizaciones.id_cotizaciones, cotizaciones.numero_secuencial, clientes.razon_social AS cliente, eventos.titulo AS evento,
    cotizaciones.fecha_emision, cotizaciones.validez, cotizaciones.servicios_incluidos, cotizaciones.detalle_costos,
    cotizaciones.condiciones_pago, cotizaciones.descuentos_aplicables, eventos.estado AS estado_evento
FROM cotizaciones
INNER JOIN clientes ON cotizaciones.id_cliente = clientes.id_clientes
INNER JOIN eventos ON cotizaciones.id_evento = eventos.id_eventos
WHERE eventos.estado IN ('cotizado', 'planificando')
ORDER BY cotizaciones.fecha_emision DESC;

-- PUNTO 5: V_AsignacionPersonal
CREATE VIEW V_AsignacionPersonal AS
SELECT 
    personal.id_personal, personal.codigo_empleado, CONCAT(personal.nombres, ' ', personal.apellidos) AS nombre_completo,
    personal.especialidad, personal.eventos_asignados, eventos.titulo AS evento_relacionado, eventos.fecha_inicio,
    eventos.fecha_fin, eventos.id_recinto, recinto.nombre AS nombre_recinto, personal.horario_asignado, personal.responsabilidades,
    personal.tarifa
FROM personal
LEFT JOIN eventos ON personal.eventos_asignados LIKE CONCAT('%', eventos.numero_unico, '%')
LEFT JOIN recinto ON eventos.id_recinto = recinto.id_recinto
ORDER BY eventos.fecha_inicio, personal.especialidad;


SHOW FULL TABLES WHERE Table_type = 'VIEW';
