CREATE DATABASE IF NOT EXISTS T7_veterinaria;

USE T7_veterinaria;

--creacion de tablas de base de datos 

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_cliente VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    correoElectronico VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT TRUE NOT NULL
);


CREATE TABLE servicios (
    id_servicio INT PRIMARY KEY AUTO_INCREMENT,
    nombre_servicio VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);


CREATE TABLE mascotas (
    id_mascota INT PRIMARY KEY AUTO_INCREMENT,
    nombre_mascota VARCHAR(20) NOT NULL,
    nPatas INT NOT NULL,
    estatura FLOAT NOT NULL,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);


CREATE TABLE mascotas_servicios (
    id_mascota_servicio INT PRIMARY KEY AUTO_INCREMENT,
    fecha_servicio DATE NOT NULL,
    id_mascota INT,
    id_servicio INT,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota),
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
);

