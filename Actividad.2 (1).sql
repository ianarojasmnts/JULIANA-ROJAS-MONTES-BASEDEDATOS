DROP DATABASE espacios_magnificos;
CREATE DATABASE espacios_magnificos; 

USE espacios_magnificos;


-- RECINTO
CREATE TABLE recinto (
    id_recinto INTEGER PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM ('salón', 'auditorio', 'sala de reuniones') NOT NULL,
    ubicacion VARCHAR(100) NOT NULL,
    dimensiones VARCHAR(50) NOT NULL,
    capacidad INT (10) NOT NULL,
    configuracion ENUM ('teatro', 'escuela', 'banquete') NOT NULL,
    caracteristicas_tecnicas TEXT (50) NOT NULL, 
    tarifa DECIMAL(10,2) NOT NULL,
    disponibilidad VARCHAR(50) NOT NULL
);


DESCRIBE recinto;

SHOW TABLES;

-- EQUIPAMIENTO

CREATE TABLE equipamiento (
    id_equipamiento INTEGER PRIMARY KEY AUTO_INCREMENT,
    codigo_inventario VARCHAR(20) UNIQUE NOT NULL,
    tipo ENUM('audiovisual', 'mobiliario', 'decoración') NOT NULL,
    descripcion TEXT(50) NOT NULL,
    cantidad_disponible INT (50) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    ubicacion_almacenamiento VARCHAR(100) NOT NULL,
    valor_reposicion DECIMAL(10,2) NOT NULL,
    vida_util VARCHAR(50) NOT NULL,
    mantenimiento VARCHAR(100) NOT NULL,
    id_recinto INT (50) NULL,
    FOREIGN KEY (id_recinto) REFERENCES recinto(id_recinto)
);

DESCRIBE equipamiento;
SHOW TABLES;

-- SERVICIOS

CREATE TABLE servicios (
    id_servicios INTEGER PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    categoria ENUM('catering', 'decoración', 'técnico', 'seguridad') NOT NULL,
    descripcion TEXT(50) NOT NULL,
    proveedor VARCHAR(100) NOT NULL,
    tipo_proveedor ENUM('Interno', 'Externo') NOT NULL,
    condiciones_contratacion TEXT (100) NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    unidad_facturacion ENUM('hora', 'persona', 'evento') NOT NULL,
    plazo_minimo VARCHAR(50) NOT NULL
);

DESCRIBE servicios;
SHOW TABLES;


-- CLIENTES

CREATE TABLE clientes (
    id_clientes INTEGER PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    tipo ENUM ('corporativo', 'agencia', 'particular')NOT NULL,
    razon_social VARCHAR(100) NOT NULL,
    nombre_contacto VARCHAR(100) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    clasificacion VARCHAR(50) NOT NULL,
    condiciones_especiales TEXT NOT NULL
);

DESCRIBE clientes;
SHOW TABLES;


-- EVENTOS

CREATE TABLE eventos (
    id_eventos INTEGER PRIMARY KEY AUTO_INCREMENT,
    numero_unico VARCHAR(20) UNIQUE NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    tipo ENUM('congreso','boda','feria','concierto') NOT NULL, 
    id_cliente INT (50) NOT NULL ,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    id_recinto INT (60) NOT NULL,
    montaje_solicitado VARCHAR(100) NOT NULL,
    asistentes_estimados INT(60) NOT NULL,
    servicios_contratados TEXT (60) NOT NULL,
    presupuesto_aprobado DECIMAL(10,2) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    responsable_interno VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_clientes),
    FOREIGN KEY (id_recinto) REFERENCES recinto(id_recinto)
);

DESCRIBE eventos;
SHOW TABLES;


-- COTIZACIONES

CREATE TABLE cotizaciones (
    id_cotizaciones INTEGER PRIMARY KEY AUTO_INCREMENT,
    numero_secuencial VARCHAR(20) UNIQUE NOT NULL,
    fecha_emision DATE NOT NULL,
    validez DATE NOT NULL,
    id_cliente INT NOT NULL,
    id_evento INT NOT NULL,
    recintos_sugeridos VARCHAR(100) NOT NULL,
    servicios_incluidos VARCHAR (100) NOT NULL,
    detalle_costos VARCHAR(500) NOT NULL,
    condiciones_pago VARCHAR(100) NOT NULL,
    descuentos_aplicables VARCHAR(100) NOT NULL,
    observaciones VARCHAR(500) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_clientes),
    FOREIGN KEY (id_evento) REFERENCES eventos(id_eventos)
);

DESCRIBE cotizaciones;

SHOW TABLES;


-- CONTRATOS

CREATE TABLE contratos (
    id_contratos INTEGER PRIMARY KEY AUTO_INCREMENT,
    numero VARCHAR(20) UNIQUE NOT NULL,
    fecha_firma DATE NOT NULL,
    id_cliente INT NOT NULL,
    id_evento INT NOT NULL,
    condiciones_generales VARCHAR(60) NOT NULL,
    desglose_servicios VARCHAR(60) NOT NULL,
    cronograma_pagos VARCHAR(60) NOT NULL,
    politicas_cancelacion VARCHAR(60) NOT NULL,
    penalizaciones VARCHAR(60) NOT NULL,
    clausulas_especiales VARCHAR(60) NOT NULL,
    anexos VARCHAR (60) NOT NULL,
    firmas_autorizadas VARCHAR (60) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_clientes),
    FOREIGN KEY (id_evento) REFERENCES eventos(id_eventos)
);

DESCRIBE contratos;
SHOW TABLES;

-- PLANIFICACION

CREATE TABLE planificacion (
    id_planificacion INTEGER PRIMARY KEY AUTO_INCREMENT,
    codigo_evento INT(60) NOT NULL,
    cronograma_actividades VARCHAR(60) NOT NULL,
    horarios_especificos VARCHAR(60) NOT NULL,
    recintos_configuracion TEXT(60) NOT NULL,
    necesidades_tecnicas TEXT(60) NOT NULL,
    servicios_catering TEXT(60) NOT NULL,
    horarios_menus TEXT(60) NOT NULL,
    personal_asignado TEXT(60) NOT NULL,
    observaciones TEXT(60) NOT NULL,
    FOREIGN KEY (codigo_evento) REFERENCES eventos(id_eventos)
);

DESCRIBE planificacion;
SHOW TABLES;


-- PERSONAL

CREATE TABLE personal (
    id_personal INTEGER PRIMARY KEY AUTO_INCREMENT,
    codigo_empleado VARCHAR(20) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    especialidad ENUM('coordinador','técnico','camarero','seguridad') NOT NULL,
    disponibilidad_fechas TEXT (60) NOT NULL,
    eventos_asignados TEXT (60) NOT NULL,
    horario_asignado VARCHAR(50) NOT NULL,
    responsabilidades TEXT (50) NOT NULL,
    tarifa DECIMAL(10,2) NOT NULL
);

DESCRIBE personal;
SHOW TABLES;


-- EVALUACIONES

CREATE TABLE evaluaciones (
    id_evaluaciones INTEGER PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    id_evento INT(50) NOT NULL,
    fecha_evaluacion DATE NOT NULL,
    aspectos_valorados TEXT(60) NOT NULL,
    puntuacion DECIMAL(5,2) NOT NULL,
    comentarios_cliente TEXT (100) NOT NULL,
    incidencias TEXT (80) NOT NULL,
    lecciones_aprendidas TEXT NOT NULL,
    recomendaciones TEXT NOT NULL,
    FOREIGN KEY (id_evento) REFERENCES eventos(id_eventos)
);

DESCRIBE evaluaciones;
SHOW TABLES;

-- Usar la base de datos
USE espacios_magnificos;

-- INSERTAR DATOS EN RECINTO
INSERT INTO recinto (codigo, nombre, tipo, ubicacion, dimensiones, capacidad, configuracion, caracteristicas_tecnicas, tarifa, disponibilidad) VALUES
('REC-BOG-001', 'Salón Monserrate', 'salón', 'Chapinero, Bogotá - Carrera 7 #125-30', '25x35m', 400, 'teatro', 'Sistema de sonido Yamaha, Proyector Epson 4K, Wi-Fi fibra óptica, Iluminación LED profesional, Aire acondicionado', 2800000.00, 'disponible'),
('REC-BOG-002', 'Auditorio Andino', 'auditorio', 'Usaquén, Bogotá - Calle 92 #11-52', '30x45m', 600, 'teatro', 'Escenario fijo 60m², Butacas ergonómicas, Sistema audio Bose L1, Traductoría simultánea, 4 cabinas técnicas', 4500000.00, 'disponible'),
('REC-MED-001', 'Sala Paisa Ejecutiva', 'sala de reuniones', 'El Poblado, Medellín - Carrera 43A #1-50', '12x18m', 60, 'escuela', 'Pantalla Samsung 85" 4K, Videoconferencia Cisco, Mesa ejecutiva madera, Sonido ambiental', 1200000.00, 'ocupado'),
('REC-CAL-001', 'Jardín La Flora', 'salón', 'La Flora, Cali - Avenida 6N #23-45', '35x50m', 300, 'banquete', 'Pérgola cristal, Iluminación decorativa, Fuente ornamental, Cocina industrial anexa', 2200000.00, 'disponible'),
('REC-BAR-001', 'Terraza Caribe', 'salón', 'Bocagrande, Cartagena - Carrera 1 #10-85', '20x30m', 200, 'banquete', 'Vista al mar, Bar modular, Sistema audio exterior JBL, Iluminación atmosférica', 3800000.00, 'disponible'),
('REC-BOG-003', 'Centro Empresarial 85', 'salón', 'Chapinero Alto, Bogotá - Calle 85 #12-64', '18x25m', 150, 'escuela', 'Divisores móviles, 3 pantallas interactivas, Wi-Fi empresarial, Coffee station', 1800000.00, 'mantenimiento');


-- INSERTAR DATOS EN CLIENTES 
INSERT INTO clientes (codigo, tipo, razon_social, nombre_contacto, direccion, telefono, correo, clasificacion, condiciones_especiales) VALUES
('CLI-EMP-001', 'corporativo', 'Bancolombia SA', 'Ana María Restrepo', 'Calle 50 #43-55, Medellín', '+57 604 510 5300', 'amrestrepo@bancolombia.com.co', 'A', 'Pago a 60 días, Descuento 15% por contrato anual, Factura electrónica'),
('CLI-PART-001', 'particular', 'Familia Rodríguez-García', 'Juliana Rodríguez', 'Carrera 15 #88-35, Bogotá', '+57 320 456 7890', 'boda.juliana.carlos@email.com', 'B', 'Pago 40% anticipado, 30% 30 días antes, 30% día evento'),
('CLI-AGE-001', 'agencia', 'Eventos Colombia SAS', 'Carlos Andrés López', 'Calle 72 #12-45, Bogotá', '+57 601 345 6789', 'c.lopez@eventoscolombia.com', 'A', 'Comisión 20%, Facturación mensual, Preferencia en fechas'),
('CLI-EMP-002', 'corporativo', 'Grupo Éxito', 'María Fernanda Silva', 'Carrera 48 #20-45, Medellín', '+57 604 448 0555', 'mfsilva@grupoexito.com.co', 'A', 'Contrato marco anual, Tarifa corporativa preferencial'),
('CLI-EMP-003', 'corporativo', 'Avianca Holdings', 'Roberto Carlos Díaz', 'Calle 26 #59-85, Bogotá', '+57 601 413 9511', 'rcdiaz@avianca.com', 'A', 'Pago a 45 días, Descuento por volumen de eventos'),
('CLI-PART-002', 'particular', 'Quinceañera Valentina', 'Sandra Milena Pérez', 'Carrera 7 #116-50, Bogotá', '+57 310 987 6543', 'sandramilena@email.com', 'C', 'Personalización completa, Presupuesto acordado');


-- INSERTAR DATOS EN EVENTOS
INSERT INTO eventos (numero_unico, titulo, tipo, id_cliente, fecha_inicio, fecha_fin, hora_inicio, hora_fin, id_recinto, montaje_solicitado, asistentes_estimados, servicios_contratados, presupuesto_aprobado, estado, responsable_interno) VALUES
('EV-2024-001', 'Convención Nacional de Gerentes Bancolombia', 'congreso', 1, '2024-03-20', '2024-03-22', '07:30:00', '19:00:00', 2, 'Escenario principal + 10 salas breakouts', 550, 'Audiovisual premium, Catering ejecutivo, Traductoría', 18500000.00, 'confirmado', 'Camila Rodríguez'),
('EV-2024-002', 'Boda Juliana y Carlos', 'boda', 2, '2024-05-18', '2024-05-18', '14:00:00', '02:00:00', 4, 'Ceremonia jardín + carpa banquete + pista baile', 180, 'Decoración floral, Banquete gourmet, Música en vivo', 12500000.00, 'planificando', 'Laura Martínez'),
('EV-2024-003', 'Lanzamiento Nuevo Supermercado Éxito', 'feria', 4, '2024-04-15', '2024-04-16', '09:00:00', '20:00:00', 1, 'Stands interactivos + pasarela + zona degustación', 350, 'Montaje especial, Catering temático, Animación', 9800000.00, 'confirmado', 'Andrés Gutiérrez'),
('EV-2024-004', 'Reunión Directiva Avianca Q2', 'congreso', 5, '2024-03-12', '2024-03-12', '08:00:00', '17:00:00', 3, 'Mesa directiva + videoconferencia internacional', 45, 'Videoconferencia, Catering ejecutivo, Secretaría', 3200000.00, 'finalizado', 'Sofia Hernández'),
('EV-2024-005', 'Fiesta de 15 Años Valentina', 'boda', 6, '2024-06-22', '2024-06-22', '17:00:00', '03:00:00', 5, 'Ambientación caribeña + barra libre + show sorpresa', 120, 'Decoración temática, Banquete internacional, DJ', 8500000.00, 'cotizado', 'David Ramírez');


-- INSERTAR DATOS EN EQUIPAMIENTO
INSERT INTO equipamiento (codigo_inventario, tipo, descripcion, cantidad_disponible, estado, ubicacion_almacenamiento, valor_reposicion, vida_util, mantenimiento, id_recinto) VALUES
('EQ-AV-001', 'audiovisual', 'Proyector Laser Epson EB-L20000U 4K', 3, 'excelente', 'Bodega AV Bogotá - Estante A1', 18500000.00, '5 años', 'Calibración trimestral', 1),
('EQ-AV-002', 'audiovisual', 'Sistema Sonido Bose L1 Model II', 6, 'bueno', 'Bodega AV Bogotá - Estante B2', 12500000.00, '7 años', 'Revisión mensual', 2),
('EQ-MOB-001', 'mobiliario', 'Sillas Tiffany Doradas para Banquete', 350, 'excelente', 'Bodega Mobiliario - Zona A', 85000.00, '8 años', 'Limpieza profesional después de cada uso', 4),
('EQ-MOB-002', 'mobiliario', 'Mesas Redondas 1.80m Madera Noble', 40, 'bueno', 'Bodega Mobiliario - Zona B', 450000.00, '12 años', 'Pulido semestral', NULL),
('EQ-DEC-001', 'decoración', 'Arreglos Florales Artificiales Premium', 80, 'nuevo', 'Bodega Decoración - Estante C', 120000.00, '4 años', 'Limpieza especializada trimestral', NULL),
('EQ-AV-003', 'audiovisual', 'Sistema Traductoría Simultánea Bosch', 2, 'excelente', 'Bodega AV Bogotá - Estante C3', 38500000.00, '6 años', 'Calibración antes de cada evento', 2),
('EQ-COC-001', 'mobiliario', 'Módulos Cocina Industrial Acero Inox', 1, 'excelente', 'Bodega Cocina - Zona Especial', 12500000.00, '15 años', 'Mantenimiento preventivo mensual', 4);


-- INSERTAR DATOS EN SERVICIOS 
INSERT INTO servicios (codigo, nombre, categoria, descripcion, proveedor, tipo_proveedor, condiciones_contratacion, precio_base, unidad_facturacion, plazo_minimo) VALUES
('SER-CAT-001', 'Catering Ejecutivo Corporativo', 'catering', 'Servicio gourmet para eventos empresariales con ingredientes premium', 'Le Gourmet SAS', 'Externo', 'Mínimo 50 personas, 5 días preaviso', 85000.00, 'persona', '5 días'),
('SER-CAT-002', 'Banquete Tradicional Colombiano', 'catering', 'Menú típico colombiano para celebraciones (Bandeja Paisa, Ajiaco, etc.)', 'Sabores de Mi Tierra', 'Externo', 'Confirmación 45 días antes, mínimo 80 personas', 65000.00, 'persona', '45 días'),
('SER-DEC-001', 'Decoración Floral Premium', 'decoración', 'Ambientación con flores frescas importadas y nacionales', 'Flores del Ande SAS', 'Externo', 'Depósito 50% al reservar, diseño personalizado', 2500000.00, 'evento', '30 días'),
('SER-TEC-001', 'Soporte Técnico AV Especializado', 'técnico', 'Técnicos certificados en sistemas audiovisuales complejos', 'Personal Interno', 'Interno', 'Mínimo 6 horas por técnico', 75000.00, 'hora', '48 horas'),
('SER-SEG-001', 'Servicio de Seguridad Privada', 'seguridad', 'Personal de seguridad certificado por Supervigilancia', 'Seguridad Total Ltda', 'Externo', 'Mínimo 4 personas por turno de 8 horas', 45000.00, 'hora/persona', '72 horas'),
('SER-MUS-001', 'Grupo Musical Vallenato', 'decoración', 'Presentación en vivo de grupo vallenato tradicional', 'Los Diablitos del Vallenato', 'Externo', 'Confirmación 60 días antes, equipo de sonido incluido', 2800000.00, 'evento', '60 días');


-- INSERTAR DATOS EN COTIZACIONES
INSERT INTO cotizaciones (numero_secuencial, fecha_emision, validez, id_cliente, id_evento, recintos_sugeridos, servicios_incluidos, detalle_costos, condiciones_pago, descuentos_aplicables, observaciones) VALUES
('COT-2024-001', '2024-01-20', '2024-02-20', 1, 1, 'Auditorio Andino', 'Catering Ejecutivo, Soporte Técnico AV, Traductoría', 'Alquiler auditorio: 4.500.000 x 3 días, Catering: 550 x 85.000 x 3 días, Técnicos: 3 x 75.000 x 10h x 3 días, Traductoría: 2.500.000', '60% anticipado, 40% 15 días antes del evento', '15% descuento por contrato anual', 'Incluye 3 coffee breaks diarios y almuerzo ejecutivo. Opción streaming disponible por 1.500.000 adicional'),
('COT-2024-002', '2024-02-15', '2024-03-15', 2, 2, 'Jardín La Flora', 'Banquete Tradicional, Decoración Floral, Grupo Musical', 'Alquiler jardín: 2.200.000, Banquete: 180 x 65.000, Decoración: 2.500.000, Música: 2.800.000, Seguridad: 4 x 45.000 x 10h', '40% reserva, 30% 30 días antes, 30% día evento', 'Pack bodas 10% descuento', 'Incluye prueba de menú gratuita, coordinador dedicado, diseño floral personalizado'),
('COT-2024-003', '2024-01-25', '2024-02-25', 4, 3, 'Salón Monserrate', 'Catering Ejecutivo, Montaje Especial, Animación', 'Alquiler salón: 2.800.000 x 2 días, Catering: 350 x 85.000, Montaje especial: 1.500.000, Animación: 800.000', '50% anticipado, 50% 7 días antes del evento', 'Evento 2 días 8% descuento', 'Incluye diseño de stands, personal promotor, material promocional');


-- INSERTAR DATOS EN CONTRATOS
INSERT INTO contratos (numero, fecha_firma, id_cliente, id_evento, condiciones_generales, desglose_servicios, cronograma_pagos, politicas_cancelacion, penalizaciones, clausulas_especiales, anexos, firmas_autorizadas) VALUES
('CONT-2024-001', '2024-02-05', 1, 1, 'Evento sujeto a reglamento interno, Horario establecido según autorización', 'Alquiler Auditorio Andino: 13.500.000, Catering ejecutivo: 140.250.000, Servicio técnico: 6.750.000, Traductoría: 2.500.000', '05/02/2024: 60% (97.800.000), 05/03/2024: 40% (65.200.000)', 'Cancelación 60+ días: 90% reembolso, 30-60 días: 50% reembolso, <30 días: 10% reembolso', 'Retraso >1h: 5% recargo, Daños: valor reparación + 20%', 'Opción extensión horaria hasta 22:00h con coste adicional del 25%', 'Anexo 1: Menús catering, Anexo 2: Planos distribución, Anexo 3: Especificaciones técnicas', 'Ana María Restrepo (Bancolombia), Camila Rodríguez (Espacios Magníficos)'),
('CONT-2024-002', '2024-03-01', 2, 2, 'Celebración sujeta a normas de convivencia, Música hasta 02:00h', 'Alquiler Jardín La Flora: 2.200.000, Banquete tradicional: 11.700.000, Decoración floral: 2.500.000, Grupo musical: 2.800.000, Seguridad: 1.800.000', '01/03/2024: 40% (8.480.000), 18/04/2024: 30% (6.360.000), 18/05/2024: 30% (6.360.000)', 'Cancelación 90+ días: 100% reembolso, 60-90 días: 80% reembolso, 30-60 días: 50% reembolso, <30 días: 20% reembolso', 'Daños decoración: coste completo, Retraso: 150.000/hora', 'Zona fumadores designada, Prohibido ingreso con alimentos externos', 'Anexo 1: Diseño decoración, Anexo 2: Planificación menú, Anexo 3: Lista musical', 'Juliana Rodríguez (Cliente), Laura Martínez (Espacios Magníficos)');


-- INSERTAR DATOS EN PLANIFICACION
INSERT INTO planificacion (codigo_evento, cronograma_actividades, horarios_especificos, recintos_configuracion, necesidades_tecnicas, servicios_catering, horarios_menus, personal_asignado, observaciones) VALUES
(1, '06:30 Montaje general, 07:30 Llegada técnicos, 08:00 Registro asistentes, 09:00 Sesión inaugural, 11:00 Coffee break, 13:00 Almuerzo, 15:00 Sesiones técnicas, 17:00 Plenaria, 19:00 Cierre', '09:00-19:00 Sesiones principales, 11:00-11:30 Coffee break, 13:00-14:30 Almuerzo ejecutivo', 'Auditorio: Plenaria 550 personas, Salas anexas: 10 salas breakout 40 personas c/u', '4 proyectores, 20 micrófonos, Sistema traductoría 4 idiomas, 4 técnicos AV full-time', '3 coffee breaks diarios, Almuerzo ejecutivo buffet, Snacks tarde', 'Coffee break: Café premium + pastelería, Almuerzo: Buffet internacional + opciones vegetarianas', 'Coordinadora: Camila Rodríguez, Técnicos: 4, Hostess: 6, Personal catering: 12, Seguridad: 8', 'Verificar certificación eléctrica, Coordinar con tránsito para ingreso VIP, Preparar kits para prensa'),
(2, '12:00 Montaje decoración, 14:00 Llegada novios, 14:30 Ceremonia, 15:30 Sesión fotos, 16:30 Cóctel, 18:30 Banquete, 21:00 Brindis, 21:30 Baile, 02:00 Fin evento', '14:30-15:30 Ceremonia, 16:30-18:30 Cóctel, 18:30-21:00 Banquete, 21:30-02:00 Baile', 'Jardín: Ceremonia 180 personas, Carpa: Banquete 18 mesas, Terraza: Cóctel y baile', 'Sistema audio ceremonia, Iluminación ambiental, Micrófonos inalámbricos, Equipo musical completo', 'Cóctel bienvenida, Banquete 5 tiempos, Barra libre nacional', 'Cóctel: Canapés variados, Banquete: Entrante+Intermedio+Principal+Postre+Brindis', 'Coordinadora: Laura Martínez, Seguridad: 4, Camareros: 10, Bartenders: 3, Músicos: 5', 'Plan B por lluvia: Salón cubierto, Coordinar entrega de arras y anillos, Atención especial a padrinos');


-- INSERTAR DATOS EN PERSONAL
INSERT INTO personal (codigo_empleado, nombres, apellidos, especialidad, disponibilidad_fechas, eventos_asignados, horario_asignado, responsabilidades, tarifa) VALUES
('EMP-001', 'Camila', 'Rodríguez', 'coordinador', 'Lunes-Viernes 07:00-19:00, Sábados bajo reserva', 'EV-2024-001, EV-2024-003', '07:00-16:00', 'Coordinación general eventos corporativos, Relación con clientes empresariales, Supervisión equipos técnicos', 85000.00),
('EMP-002', 'Laura', 'Martínez', 'coordinador', 'Martes-Domingo 12:00-22:00', 'EV-2024-002, EV-2024-005', '12:00-21:00', 'Coordinación eventos sociales, Diseño decoración, Pruebas menú, Atención a familias', 78000.00),
('EMP-003', 'Andrés', 'Gutiérrez', 'técnico', 'Lunes-Domingo turnos rotativos', 'EV-2024-001, EV-2024-003, EV-2024-004', '08:00-17:00', 'Montaje equipos AV, Soporte técnico durante eventos, Mantenimiento preventivo, Inventario técnico', 45000.00),
('EMP-004', 'Sofia', 'Hernández', 'coordinador', 'Lunes-Viernes 08:00-18:00', 'EV-2024-004', '08:00-17:00', 'Eventos corporativos ejecutivos, Reuniones directivas, Atención a alta gerencia', 82000.00),
('EMP-005', 'David', 'Ramírez', 'coordinador', 'Miércoles-Domingo 14:00-24:00', 'EV-2024-005', '14:00-23:00', 'Eventos sociales especiales, Fiestas temáticas, Coordinación con artistas', 76000.00),
('EMP-006', 'Juan Carlos', 'Gómez', 'camarero', 'Flexible según programación', 'EV-2024-001, EV-2024-002', 'Variable según evento', 'Servicio catering, Montaje mesas, Atención a invitados, Apoyo logístico', 25000.00);


-- INSERTAR DATOS EN EVALUACIONES
INSERT INTO evaluaciones (codigo, id_evento, fecha_evaluacion, aspectos_valorados, puntuacion, comentarios_cliente, incidencias, lecciones_aprendidas, recomendaciones) VALUES
('EVAL-2024-001', 4, '2024-03-13', 'Organización, Servicio técnico, Catering, Atención al cliente', 4.90, 'Excelente servicio, superó nuestras expectativas. La videoconferencia internacional funcionó perfectamente sin delays', 'Retraso de 15 minutos en servicio de café de la mañana por alta demanda', 'Programar dos estaciones de coffee break para eventos ejecutivos con más de 40 personas', 'Mantener el mismo equipo de coordinación para futuros eventos directivos'),
('EVAL-2024-002', 1, '2024-03-23', 'Coordinación, Equipamiento técnico, Espacios, Comunicación, Catering', 4.75, 'Muy contentos con el desarrollo del evento. El sonido y la traducción simultánea fueron impecables. El catering de alta calidad', 'Problema menor con el Wi-Fi durante la primera hora que se resolvió rápidamente', 'Reforzar capacidad de Internet para eventos con más de 500 dispositivos conectados simultáneamente', 'Considerar opción de Wi-Fi premium para eventos corporativos grandes'),
('EVAL-2024-003', 3, '2024-04-17', 'Montaje, Decoración, Servicio de catering, Atención al público', 4.85, 'El evento fue un éxito total. Los stands quedaron espectaculares y el servicio de atención al público excelente', 'Ninguna incidencia reportada, todo según lo planificado', 'El proveedor de montaje especial cumplió sobradamente, mantener alianza estratégica', 'Repetir esquema de trabajo para próximos lanzamientos de producto');

-- Verificar los datos insertados
SELECT 'Recintos en Colombia:' AS '';
SELECT codigo, nombre, ubicacion, capacidad, tarifa FROM recinto;

SELECT 'Clientes Colombianos:' AS '';
SELECT codigo, tipo, razon_social, nombre_contacto FROM clientes;

SELECT 'Eventos 2024:' AS '';
SELECT numero_unico, titulo, tipo, fecha_inicio, presupuesto_aprobado FROM eventos;

SELECT 'Total registros por tabla:' AS '';
SELECT 
    'recinto' AS tabla, COUNT(*) AS total FROM recinto
    UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
    UNION ALL SELECT 'eventos', COUNT(*) FROM eventos
    UNION ALL SELECT 'equipamiento', COUNT(*) FROM equipamiento
    UNION ALL SELECT 'servicios', COUNT(*) FROM servicios
    UNION ALL SELECT 'cotizaciones', COUNT(*) FROM cotizaciones
    UNION ALL SELECT 'contratos', COUNT(*) FROM contratos
    UNION ALL SELECT 'planificacion', COUNT(*) FROM planificacion
    UNION ALL SELECT 'personal', COUNT(*) FROM personal
    UNION ALL SELECT 'evaluaciones', COUNT(*) FROM evaluaciones;
