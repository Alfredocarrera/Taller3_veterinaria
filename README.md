# Sistema de Gestión de Base de Datos - Veterinaria T7

## 👨‍💻 Autor / Diseñador
* **Diseñador de la Base de Datos:** Alfredo Carrera

---

## 📌 Resumen del Problema
Este proyecto implementa una solución integral de base de datos relacional para optimizar la administración y control operativo de una clínica veterinaria (**T7_veterinaria**). El sistema resuelve la necesidad de gestionar eficientemente la información centralizada de los **clientes**, las **mascotas** registradas bajo su tutela, el catálogo de **servicios** médicos o estéticos disponibles, y el historial transaccional de atención a través de una tabla intermedia de control temporal, garantizando la integridad referencial y facilitando la automatización de procesos mediante procedimientos almacenados.

---

## 🗄️ Estructura de Tablas, Cardinalidades y Relaciones

La base de datos se compone de 4 tablas principales interconectadas de la siguiente manera:

1. **Clientes** (`clientes`):
   * **Atributos:** `id_cliente` (PK), `nombre_cliente`, `direccion`, `correoElectronico`, `activo`.
   * **Relación:** Un cliente puede tener múltiples mascotas (1 a N).
2. **Mascotas** (`mascotas`):
   * **Atributos:** `id_mascota` (PK), `nombre_mascota`, `nPatas`, `estatura`, `id_cliente` (FK).
   * **Relación:** Pertenece a un único cliente (N a 1) y puede recibir múltiples servicios a través de la tabla intermedia (N a M).
3. **Servicios** (`servicios`):
   * **Atributos:** `id_servicio` (PK), `nombre_servicio`, `precio`.
   * **Relación:** Un servicio puede ser aplicado a múltiples mascotas a lo largo del tiempo (N a M).
4. **Mascotas_Servicios** (`mascotas_servicios` - Tabla Intermedia):
   * **Atributos:** `id_mascota_servicio` (PK), `fecha_servicio`, `id_mascota` (FK), `id_servicio` (FK).

### Ejemplo de Creación de Estructura (DDL.sql)
```sql
CREATE DATABASE IF NOT EXISTS T7_veterinaria;
USE T7_veterinaria;

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_cliente VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    correoElectronico VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT TRUE NOT NULL
);

CREATE TABLE mascotas (
    id_mascota INT PRIMARY KEY AUTO_INCREMENT,
    nombre_mascota VARCHAR(20) NOT NULL,
    nPatas INT NOT NULL,
    estatura FLOAT NOT NULL,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

```
## 📥 Datos de Prueba (DML.sql)
El archivo DML.sql se encarga de carga al sistema con información inicial simulada bajo escenarios reales (por ejemplo, clientes en distintas zonas de Guatemala, servicios veterinarios estandarizados con sus respectivos precios, mascotas con características físicas y registros de atención histórica). Esto permite realizar pruebas inmediatas de consultas, reportes y ejecución de procedimientos almacenados.

Ejemplo de Inserción (DML.sql)
```SQL
INSERT INTO clientes (nombre_cliente, direccion, correoElectronico, activo) VALUES
('Carlos López', 'Zona 10, Ciudad de Guatemala', 'carlos.lopez@gmail.com', 1),
('Ana Martínez', 'Zona 14, Ciudad de Guatemala', 'ana.martinez@hotmail.com', 1);

INSERT INTO servicios (nombre_servicio, precio) VALUES
('Baño y Peluquería', 150.00),
('Consulta Médica General', 200.00);
```
## ⚙️ Procedimientos Almacenados (DQL.sql)
### 1. Insertar Cliente 
Explicación: Inserta un nuevo registro en la tabla clientes asignando el estado activo por defecto a través de los parámetros de entrada recibidos.

Código SQL:

```SQL
CREATE PROCEDURE sp_insertar_cliente (
    IN p_nombre_cliente VARCHAR(100),
    IN p_direccion VARCHAR(100),
    IN p_correoElectronico VARCHAR(100)
)
BEGIN
    INSERT INTO clientes (nombre_cliente, direccion, correoElectronico, activo) 
    VALUES (p_nombre_cliente, p_direccion, p_correoElectronico, TRUE);
END //

Forma de Probarlo:
CALL sp_insertar_cliente('Andrés Pastrana', 'Zona 15, Vista Hermosa', 'andres.p@gmail.com');
```
### 2. Actualizar Estado del Cliente
Explicación: Modifica de manera dinámica el campo booleano de estado (activo) de un cliente específico filtrando estrictamente por su identificador único (id_cliente).

Código SQL:

```SQL
CREATE PROCEDURE sp_actualizar_estado_cliente (
    IN p_id_cliente INT,
    IN p_nuevo_estado BOOLEAN
)
BEGIN
    UPDATE clientes SET activo = p_nuevo_estado WHERE id_cliente = p_id_cliente;
END //


Forma de Probarlo:
CALL sp_actualizar_estado_cliente(5, TRUE);
```

### 3. Contar Mascotas por Cliente
Explicación: Utiliza una función de agregación con un parámetro de salida (OUT) para calcular y retornar el número exacto de mascotas vinculadas a un cliente.

Código SQL:

```SQL
CREATE PROCEDURE sp_contar_mascotas_por_cliente (
    IN p_id_cliente INT,
    OUT p_total_mascotas INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_mascotas FROM mascotas WHERE id_cliente = p_id_cliente;
END //

Forma de Probarlo:

CALL sp_contar_mascotas_por_cliente(1, @total);
SELECT @total AS Total_Mascotas;
```

### 4. Listar Servicios de una Mascota
Explicación: Ejecuta una consulta multitabla empleando INNER JOIN para extraer el historial detallado de los servicios aplicados a una mascota según su ID.

Código SQL:

```SQL
CREATE PROCEDURE sp_listar_servicios_mascota (IN p_id_mascota INT)
BEGIN
    SELECT s.id_servicio, s.nombre_servicio, s.precio, ms.fecha_servicio
    FROM servicios s
    INNER JOIN mascotas_servicios ms ON s.id_servicio = ms.id_servicio
    WHERE ms.id_mascota = p_id_mascota;
END //

Forma de Probarlo:
CALL sp_listar_servicios_mascota(1);
```
### 5. Registrar Servicio a Mascota
Explicación: Inserta un nuevo registro operativo en la tabla intermedia asociando una mascota, un servicio médico y la fecha respectiva de atención.

Código SQL:

```SQL
CREATE PROCEDURE sp_registrar_servicio_mascota (
    IN p_id_mascota INT,
    IN p_id_servicio INT,
    IN p_fecha_servicio DATE
)
BEGIN
    INSERT INTO mascotas_servicios (id_mascota, id_servicio, fecha_servicio)
    VALUES (p_id_mascota, p_id_servicio, p_fecha_servicio);
END //

Forma de Probarlo:

CALL sp_registrar_servicio_mascota(1, 2, '2026-10-18');
```
### 6. Eliminar Mascota
Explicación: Garantiza la integridad referencial borrando primero las dependencias de la mascota en la tabla intermedia y posteriormente el registro principal.

Código SQL:

```SQL
CREATE PROCEDURE sp_eliminar_mascota (IN p_id_mascota INT)
BEGIN
    DELETE FROM mascotas_servicios WHERE id_mascota = p_id_mascota;
    DELETE FROM mascotas WHERE id_mascota = p_id_mascota;
END //

Forma de Probarlo:

CALL sp_eliminar_mascota(10);
```
### 7. Actualizar Precio de Servicio
Explicación: Modifica el costo monetario de un servicio en el catálogo general utilizando su identificador único como filtro de actualización.

Código SQL:

```SQL
CREATE PROCEDURE sp_actualizar_precio_servicio (
    IN p_id_servicio INT,
    IN p_nuevo_precio DECIMAL(10,2)
)
BEGIN
    UPDATE servicios SET precio = p_nuevo_precio WHERE id_servicio = p_id_servicio;
END //

Forma de Probarlo:

CALL sp_actualizar_precio_servicio(1, 175.00);
```
### 8. Contar Servicios por Mascota
Explicación: Cuenta las atenciones registradas en el historial de una mascota específica y devuelve el resultado a través de una variable de salida.

Código SQL:

```SQL
CREATE PROCEDURE sp_contar_servicios_por_mascota (
    IN p_id_mascota INT,
    OUT p_conteo_servicios INT
)
BEGIN
    SELECT COUNT(*) INTO p_conteo_servicios FROM mascotas_servicios WHERE id_mascota = p_id_mascota;
END //

Forma de Probarlo:

CALL sp_contar_servicios_por_mascota(1, @conteo);
SELECT @conteo AS Total_Servicios;
```
### 9. Incrementar Precio de Servicios
Explicación: Aplica un ajuste porcentual masivo sobre el costo de todos los servicios registrados multiplicándolos por un factor de incremento.

Código SQL:

```SQL
CREATE PROCEDURE sp_incrementar_precio_servicios (IN p_porcentaje DECIMAL(5,2))
BEGIN
    UPDATE servicios SET precio = precio * (1 + (p_porcentaje / 100));
END //

Forma de Probarlo:

CALL sp_incrementar_precio_servicios(10.00);
```
### 10. Repetir Registro de Servicio
Explicación: Emplea una estructura repetitiva REPEAT para insertar de forma automatizada un mismo servicio múltiples veces según el número de veces requerido.

Código SQL:

```SQL
CREATE PROCEDURE sp_repetir_registro_servicio (
    IN p_id_mascota INT,
    IN p_id_servicio INT,
    IN p_fecha DATE,
    IN p_veces INT
)
BEGIN
    DECLARE v_contador INT DEFAULT 0;
    REPEAT
        INSERT INTO mascotas_servicios (id_mascota, id_servicio, fecha_servicio)
        VALUES (p_id_mascota, p_id_servicio, p_fecha);
        SET v_contador = v_contador + 1;
    UNTIL v_contador >= p_veces
    END REPEAT;
END //

Forma de Probarlo:

CALL sp_repetir_registro_servicio(2, 1, '2026-10-18', 3);
```
### 11. Verificar Existencia de Correo Electrónico
Explicación: Valida si un correo ya se encuentra registrado; si existe, genera una interrupción de error con SIGNAL, de lo contrario confirma disponibilidad.

Código SQL:

```SQL
CREATE PROCEDURE sp_verificar_correo_existente (IN p_correo VARCHAR(100))
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    SELECT COUNT(*) INTO v_existe FROM clientes WHERE correoElectronico = p_correo;
    IF v_existe > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El correo electrónico ya existe.';
    ELSE
        SELECT 'El correo electrónico está disponible.' AS mensaje;
    END IF;
END //

Forma de Probarlo:

CALL sp_verificar_correo_existente('carlos.lopez@gmail.com');
```
### 12. Obtener Nombre de Cliente por Mascota
Explicación: Relaciona mediante JOIN la mascota con su propietario y almacena el nombre del dueño en un parámetro de salida OUT.

Código SQL:

```SQL
CREATE PROCEDURE sp_obtener_cliente_por_mascota (
    IN p_id_mascota INT,
    OUT p_nombre_cliente VARCHAR(100)
)
BEGIN
    SELECT c.nombre_cliente INTO p_nombre_cliente
    FROM clientes c INNER JOIN mascotas m ON c.id_cliente = m.id_cliente
    WHERE m.id_mascota = p_id_mascota;
END //

Forma de Probarlo:

CALL sp_obtener_cliente_por_mascota(1, @nombre_dueno);
SELECT @nombre_dueno AS Dueno;
```
### 13. Clasificar Mascotas por Estatura
Explicación: Utiliza una estructura condicional IF-THEN-ELSE para evaluar la estatura de una mascota y clasificarla dinámicamente como "Alta" o "Baja".

Código SQL:

```SQL
CREATE PROCEDURE sp_clasificar_mascota_estatura (IN p_id_mascota INT)
BEGIN
    DECLARE v_estatura FLOAT;
    DECLARE v_clasificacion VARCHAR(20);
    SELECT estatura INTO v_estatura FROM mascotas WHERE id_mascota = p_id_mascota;
    IF v_estatura >= 0.40 THEN
        SET v_clasificacion = 'Alta';
    ELSE
        SET v_clasificacion = 'Baja';
    END IF;
    SELECT p_id_mascota AS id_mascota, v_estatura AS estatura, v_clasificacion AS clasificacion;
END //

Forma de Probarlo:

CALL sp_clasificar_mascota_estatura(1);
```
### 14. Contar Clientes Activos
Explicación: Cuenta de forma filtrada cuántos clientes tienen su cuenta activa (activo = TRUE) y retorna la sumatoria en una variable de salida.

Código SQL:

```SQL
CREATE PROCEDURE sp_contar_clientes_activos (OUT p_total_activos INT)
BEGIN
    SELECT COUNT(*) INTO p_total_activos FROM clientes WHERE activo = TRUE;
END //

Forma de Probarlo:

CALL sp_contar_clientes_activos(@activos);
SELECT @activos AS Total_Clientes_Activos;
```
### 15. Actualizar Mascota
Explicación: Permite modificar simultáneamente atributos específicos de una mascota (nombre y estatura) basándose en su ID.

Código SQL:

```SQL
CREATE PROCEDURE sp_actualizar_mascota (
    IN p_id_mascota INT,
    IN p_nuevo_nombre VARCHAR(20),
    IN p_nueva_estatura FLOAT
)
BEGIN
    UPDATE mascotas SET nombre_mascota = p_nuevo_nombre, estatura = p_nueva_estatura WHERE id_mascota = p_id_mascota;
END //

Forma de Probarlo:

CALL sp_actualizar_mascota(1, 'Maximus', 0.48);
```
### 16. Eliminar Servicios por Nombre
Explicación: Busca un servicio por su nombre descriptivo y, si existe, elimina sus dependencias transaccionales y del catálogo principal.

Código SQL:

```SQL
CREATE PROCEDURE sp_eliminar_servicio_por_nombre (IN p_nombre_servicio VARCHAR(50))
BEGIN
    DECLARE v_id_servicio INT;
    SELECT id_servicio INTO v_id_servicio FROM servicios WHERE nombre_servicio = p_nombre_servicio LIMIT 1;
    IF v_id_servicio IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El servicio no existe.';
    ELSE
        DELETE FROM mascotas_servicios WHERE id_servicio = v_id_servicio;
        DELETE FROM servicios WHERE id_servicio = v_id_servicio;
    END IF;
END //

Forma de Probarlo:

CALL sp_eliminar_servicio_por_nombre('Corte de Uñas');
```
### 17. Listar Mascotas por Cliente
Explicación: Consulta y despliega el listado completo de mascotas que pertenecen a un cliente específico utilizando su ID como parámetro.

Código SQL:

```SQL
CREATE PROCEDURE sp_listar_mascotas_por_cliente (IN p_id_cliente INT)
BEGIN
    SELECT id_mascota, nombre_mascota, nPatas, estatura FROM mascotas WHERE id_cliente = p_id_cliente;
END //

Forma de Probarlo:

CALL sp_listar_mascotas_por_cliente(1);
```

### 18. Transferir Mascota a Otro Cliente
Explicación: Actualiza la llave foránea de propietario en la tabla mascotas para reasignar la propiedad a un cliente distinto.

Código SQL:

```SQL
CREATE PROCEDURE sp_transferir_mascota (IN p_id_mascota INT, IN p_id_nuevo_cliente INT)
BEGIN
    UPDATE mascotas SET id_cliente = p_id_nuevo_cliente WHERE id_mascota = p_id_mascota;
END //

Forma de Probarlo:

CALL sp_transferir_mascota(1, 2);
```
### 19. Registrar Múltiples Servicios
Explicación: Utiliza un bucle LOOP avanzado para fragmentar una cadena de texto con IDs separados por comas (CSV) e insertar múltiples servicios en un solo llamado.

Código SQL:

```SQL
CREATE PROCEDURE sp_registrar_multiples_servicios (
    IN p_id_mascota INT,
    IN p_servicios_csv VARCHAR(255)
)
BEGIN
    DECLARE v_id_servicio INT;
    DECLARE v_sub_cadena VARCHAR(255);
    bucle_servicios: LOOP
        SET v_sub_cadena = SUBSTRING_INDEX(p_servicios_csv, ',', 1);
        IF CHAR_LENGTH(v_sub_cadena) = 0 OR p_servicios_csv = '' THEN
            LEAVE bucle_servicios;
        END IF;
        SET v_id_servicio = CAST(v_sub_cadena AS UNSIGNED);
        INSERT INTO mascotas_servicios (id_mascota, id_servicio, fecha_servicio)
        VALUES (p_id_mascota, v_id_servicio, CURDATE());
        IF LOCATE(',', p_servicios_csv) > 0 THEN
            SET p_servicios_csv = SUBSTRING(p_servicios_csv, LOCATE(',', p_servicios_csv) + 1);
        ELSE
            SET p_servicios_csv = '';
        END IF;
    END LOOP bucle_servicios;
END //

Forma de Probarlo:

CALL sp_registrar_multiples_servicios(1, '1,3,5');
```
## 📖 Glosario de Funciones de MySQL Utilizadas
### DELIMITER: Cambia el delimitador de instrucciones predeterminado (de ; a //), permitiendo estructurar bloques complejos como procedimientos almacenados sin que el sistema interprete el punto y coma interno como el fin del proceso.

### SIGNAL SQLSTATE: Permite interrumpir la ejecución normal del código y lanzar un error personalizado controlado hacia la aplicación con un código de estado específico.

### SUBSTRING_INDEX: Extrae una subcadena de una cadena de texto basándose en el número de apariciones de un carácter delimitador específico (útil para parsear cadenas CSV).

### CHAR_LENGTH: Mide y devuelve la longitud total de una cadena de texto en caracteres.

### CAST(... AS UNSIGNED): Convierte de forma explícita un tipo de dato (por ejemplo, texto plano) en un número entero sin signo.

### CURDATE(): Función temporal que devuelve la fecha actual del sistema con formato YYYY-MM-DD.

### LOCATE: Localiza la posición de la primera ocurrencia de una subcadena o carácter específico dentro de un texto más grande.

## 📂 Estructura del Repositorio

```text
T7_Veterinaria/
├── DDL.sql        # Script de creación de base de datos y tablas relacionales
├── DML.sql        # Script de inserción de datos de prueba 
├── DQL.sql        # Script con los 19 procedimientos almacenados y pruebas
└── README.md      # Documentación técnica general del proyecto
```

## 🎥 Video Explicativo del Proyecto
🔗 Próximamente se agregará en esta sección el enlace del video explicativo y demostrativo del funcionamiento del sistema.