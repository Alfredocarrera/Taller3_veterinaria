
-- datos de prueba para la base de datos de la veterinaria
-- Inserción de datos en las tablas clientes, servicios, mascotas y mascota_servicio

-- datos de prueba para la tabla clientes

INSERT INTO clientes (nombre, direccion, correoElectronico, activo) VALUES
('Carlos López', 'Zona 10, Ciudad de Guatemala', 'carlos.lopez@gmail.com', 1),
('Ana Martínez', 'Zona 14, Ciudad de Guatemala', 'ana.martinez@hotmail.com', 1),
('Luis Hernández', 'Calzada Roosevelt, Zona 11', 'luis.h@yahoo.com', 1),
('María Rodríguez', 'Carretera a El Salvador, Km 15', 'm.rodriguez@gmail.com', 1),
('Jorge Gómez', 'Zona 1, Ciudad de Guatemala', 'jorge.gomez@outlook.com', 0),
('Sofía Pérez', 'Zona 7, Quetzaltenango', 'sofia.perez@gmail.com', 1),
('Diego Morales', 'Zona 2, Cobán', 'diego.m@gmail.com', 1),
('Lucía Castillo', 'Zona 9, Ciudad de Guatemala', 'lucia.c@hotmail.com', 1),
('Fernando Ruiz', 'San Lucas Sacatepéquez', 'fruiz@yahoo.com', 1),
('Elena Ramírez', 'Antigua Guatemala', 'elena.ramirez@gmail.com', 1);


-- datos de prueba para la tabla servicios

INSERT INTO servicios (nombre, precio) VALUES
('Baño y Peluquería', 150.00),
('Consulta Médica General', 200.00),
('Vacunación Antirrábica', 85.00),
('Desparasitación Interna', 60.00),
('Limpieza Dental', 350.00),
('Corte de Uñas', 40.00),
('Hospedaje Diario', 120.00),
('Cirugía Menor', 800.00),
('Examen de Laboratorio', 250.00),
('Microchip de Identificación', 180.00);


-- datos de prueba para la tabla mascotas
INSERT INTO mascotas (ID_Cliente, nombre, nPatas, estatura) VALUES
(1, 'Max', 4, 0.45),
(2, 'Luna', 4, 0.30),
(3, 'Rocky', 4, 0.60),
(4, 'Bella', 4, 0.25),
(5, 'Coco', 4, 0.35),
(6, 'Milo', 4, 0.50),
(7, 'Pelusa', 4, 0.20),
(8, 'Zeus', 4, 0.65),
(9, 'Nala', 4, 0.40),
(10, 'Toby', 4, 0.28);


-- datos de prueba para la tabla mascota_servicio

INSERT INTO mascota_servicio (ID_Mascota, ID_Servicio, fecha) VALUES
(1, 1, '2026-10-01'),
(1, 4, '2026-10-01'),
(2, 2, '2026-10-02'),
(3, 3, '2026-10-03'),
(4, 1, '2026-10-05'),
(5, 6, '2026-10-06'),
(6, 2, '2026-10-08'),
(7, 5, '2026-10-10'),
(8, 7, '2026-10-12'),
(9, 10, '2026-10-15');