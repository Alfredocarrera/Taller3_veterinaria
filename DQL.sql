
USE T7_veterinaria;

-- 1. Procedimiento para insertar un nuevo cliente

DELIMITER //

CREATE PROCEDURE sp_insertar_cliente (
    IN p_nombre_cliente VARCHAR(100),
    IN p_direccion VARCHAR(100),
    IN p_correoElectronico VARCHAR(100)
)
BEGIN
    
    INSERT INTO clientes (nombre_cliente, direccion, correoElectronico, activo) 
    VALUES (p_nombre_cliente, p_direccion, p_correoElectronico, TRUE);
END //

DELIMITER ;

-- Prueba del procedimiento almacenado 

CALL sp_insertar_cliente(
    'Andrés Pastrana', 
    'Zona 15, Vista Hermosa', 
    'andres.p@gmail.com'
);

SELECT * FROM clientes WHERE correoElectronico = 'andres.p@gmail.com';



-- 2. Procedimiento para actualizar el estado de un cliente
USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_actualizar_estado_cliente (
    IN p_id_cliente INT,
    IN p_nuevo_estado BOOLEAN
)
BEGIN
    UPDATE clientes 
    SET activo = p_nuevo_estado 
    WHERE id_cliente = p_id_cliente;
END //

DELIMITER ;

-- Prueba del procedimiento almacenado

SELECT id_cliente, nombre_cliente, activo FROM clientes WHERE id_cliente = 5;

CALL sp_actualizar_estado_cliente(5, TRUE);

SELECT id_cliente, nombre_cliente, activo FROM clientes WHERE id_cliente = 5;



-- 3. Procedimiento para contar mascotas por cliente
USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_contar_mascotas_por_cliente (

    IN p_id_cliente INT,

    OUT p_total_mascotas INT

)

BEGIN

    SELECT COUNT(*) INTO p_total_mascotas 

    FROM mascotas 

    WHERE id_cliente = p_id_cliente;

END //

DELIMITER ;

-- Prueba del procedimiento almacenado
CALL sp_contar_mascotas_por_cliente(1, @total);

SELECT @total AS Total_Mascotas;



-- 4.Procedimiento para listar servicios por mascota
USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_listar_servicios_mascota (

    IN p_id_mascota INT

)

BEGIN

    SELECT s.id_servicio, s.nombre_servicio, s.precio, ms.fecha_servicio

    FROM servicios s

    INNER JOIN mascotas_servicios ms ON s.id_servicio = ms.id_servicio

    WHERE ms.id_mascota = p_id_mascota;

END //

DELIMITER ;

-- Prueba del procedimiento almacenado
CALL sp_listar_servicios_mascota(1);

DELIMITER //



-- 5. Procedimiento para registrar un servicio a una mascota
USE T7_veterinaria;
DELIMITER //
CREATE PROCEDURE sp_registrar_servicio_mascota (

    IN p_id_mascota INT,

    IN p_id_servicio INT,

    IN p_fecha_servicio DATE

)

BEGIN

    INSERT INTO mascotas_servicios (id_mascota, id_servicio, fecha_servicio)

    VALUES (p_id_mascota, p_id_servicio, p_fecha_servicio);

END //

DELIMITER ;

-- Prueba del procedimiento almacenado
CALL sp_registrar_servicio_mascota(1, 2, '2026-10-18');



-- 6.eliminar mascota
USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_eliminar_mascota (

    IN p_id_mascota INT

)

BEGIN

    DELETE FROM mascotas_servicios WHERE id_mascota = p_id_mascota;

    DELETE FROM mascotas WHERE id_mascota = p_id_mascota;

END //

DELIMITER ;

-- Prueba del procedimiento almacenado
CALL sp_eliminar_mascota(10);



-- 7. Procedimiento para actualizar el precio de un servicio
USE T7_veterinaria;
DELIMITER //

CREATE PROCEDURE sp_actualizar_precio_servicio (

    IN p_id_servicio INT,

    IN p_nuevo_precio DECIMAL(10,2)

)

BEGIN

    UPDATE servicios 

    SET precio = p_nuevo_precio 

    WHERE id_servicio = p_id_servicio;

END //

DELIMITER ;

-- Prueba del procedimiento almacenado
CALL sp_actualizar_precio_servicio(1, 175.00);



-- 8 procedimiento para contar servicios por mascota
USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_contar_servicios_por_mascota (
IN p_id_mascota INT,
OUT p_conteo_servicios INT
)
BEGIN
SELECT COUNT(*) INTO p_conteo_servicios
FROM mascotas_servicios
WHERE id_mascota = p_id_mascota;
END //

DELIMITER ;

-- Prueba del procedimiento almacenado
CALL sp_contar_servicios_por_mascota(1, @conteo);

SELECT @conteo AS Total_Servicios;



-- 9. procedimiento para incrementar salario y precios de servicios
DELIMITER //

CREATE PROCEDURE sp_incrementar_precio_servicios (

    IN p_porcentaje DECIMAL(5,2)

)

BEGIN

    UPDATE servicios 

    SET precio = precio * (1 + (p_porcentaje / 100));

END //

DELIMITER ;

-- Prueba del procedimiento almacenado
CALL sp_incrementar_precio_servicios(10.00);



-- 10. procedimiento para repetir registro de servicio
USE T7_veterinaria;

DELIMITER //

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

DELIMITER ;

-- Prueba del procedimiento almacenado
CALL sp_repetir_registro_servicio(2, 1, '2026-10-18', 3);



-- 11. procedimiento para verificar existencia de correo electrónico de cliente

USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_verificar_correo_existente (

    IN p_correo VARCHAR(100)

)

BEGIN

    DECLARE v_existe INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_existe 

    FROM clientes 

    WHERE correoElectronico = p_correo;
    
    IF v_existe > 0 THEN

        SIGNAL SQLSTATE '45000'

        SET MESSAGE_TEXT = 'Error: El correo electrónico ya se encuentra registrado en el sistema.';

    ELSE

        SELECT 'El correo electrónico está disponible.' AS mensaje;

    END IF;

END //

DELIMITER ;

-- Prueba del procedimiento almacenado
CALL sp_verificar_correo_existente('carlos.lopez@gmail.com');



-- 12. procedimiento obtener nombre de cliente por medio de id_mascota
USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_obtener_cliente_por_mascota (

    IN p_id_mascota INT,

    OUT p_nombre_cliente VARCHAR(100)

)

BEGIN

    SELECT c.nombre_cliente INTO p_nombre_cliente

    FROM clientes c

    INNER JOIN mascotas m ON c.id_cliente = m.id_cliente

    WHERE m.id_mascota = p_id_mascota;

END //

DELIMITER ;

-- Prueba de procedimiento almacenado 
CALL sp_obtener_cliente_por_mascota(1, @nombre_dueno);

SELECT @nombre_dueno AS Dueno;



-- 13. procedimiento almacenado para clasificar mascotas por estatura

USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_clasificar_mascota_estatura (
IN p_id_mascota INT
)
BEGIN
DECLARE v_estatura FLOAT;
DECLARE v_clasificacion VARCHAR(20);SELECT estatura INTO v_estatura 

FROM mascotas 

WHERE id_mascota = p_id_mascota;

IF v_estatura >= 0.40 THEN

    SET v_clasificacion = 'Alta';

ELSE

    SET v_clasificacion = 'Baja';

END IF;

SELECT p_id_mascota AS id_mascota, v_estatura AS estatura, v_clasificacion AS clasificacion;

END //

DELIMITER ;

-- Prueba de procedimiento almacenado 
CALL sp_clasificar_mascota_estatura(1);



-- 14. procedimiento almacenamiento de contador de clientes activos 
USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_contar_clientes_activos (

    OUT p_total_activos INT

)

BEGIN

    SELECT COUNT(*) INTO p_total_activos 

    FROM clientes 

    WHERE activo = TRUE;

END //

DELIMITER ;

-- Prueva de procedimiento almacenado
CALL sp_contar_clientes_activos(@activos);

SELECT @activos AS Total_Clientes_Activos;



-- 15 procedimiento almacenado para actualizar mascotas

USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_actualizar_mascota (

    IN p_id_mascota INT,

    IN p_nuevo_nombre VARCHAR(20),

    IN p_nueva_estatura FLOAT

)

BEGIN

    UPDATE mascotas 

    SET nombre_mascota = p_nuevo_nombre,

        estatura = p_nueva_estatura

    WHERE id_mascota = p_id_mascota;

END //

DELIMITER ;

-- Prueba de procedimiento almacenado
CALL sp_actualizar_mascota(1, 'Maximus', 0.48);



-- 16. Procedimiento almacenado para eliminar servicio por nombre 
USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_eliminar_servicio_por_nombre (

    IN p_nombre_servicio VARCHAR(50)

)

BEGIN

    DECLARE v_id_servicio INT;

    

    SELECT id_servicio INTO v_id_servicio 

    FROM servicios 

    WHERE nombre_servicio = p_nombre_servicio 

    LIMIT 1;

    

    IF v_id_servicio IS NULL THEN

        SIGNAL SQLSTATE '45000'

        SET MESSAGE_TEXT = 'Error: El servicio especificado no existe.';

    ELSE

        DELETE FROM mascotas_servicios WHERE id_servicio = v_id_servicio;

        DELETE FROM servicios WHERE id_servicio = v_id_servicio;

    END IF;

END //

DELIMITER ;

--Prueba de procedimiento almacenado 
CALL sp_eliminar_servicio_por_nombre('Corte de Uñas');



-- 17. Procedimiento almacenado para listar mascotas por clientes

USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_listar_mascotas_por_cliente (

    IN p_id_cliente INT

)

BEGIN

    SELECT id_mascota, nombre_mascota, nPatas, estatura 

    FROM mascotas 

    WHERE id_cliente = p_id_cliente;

END //

DELIMITER ;

-- Prueba de procedimiento almacenado
CALL sp_listar_mascotas_por_cliente(1);



-- 18. Procedimiento almacenado para transferir mascota a otro cliente
USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_transferir_mascota (

    IN p_id_mascota INT,

    IN p_id_nuevo_cliente INT

)

BEGIN

    UPDATE mascotas 

    SET id_cliente = p_id_nuevo_cliente 

    WHERE id_mascota = p_id_mascota;

END //

DELIMITER ;

-- Prueba de procedimiento almacenado 
CALL sp_transferir_mascota(1, 2);



--19. procedimiento almacenado para registrar multiples servicios

USE T7_veterinaria;

DELIMITER //

CREATE PROCEDURE sp_registrar_multiples_servicios (

    IN p_id_mascota INT,

    IN p_servicios_csv VARCHAR(255)

)

BEGIN

    DECLARE v_pos INT DEFAULT 1;

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

DELIMITER ;

-- Prueba de procedimiento almacenado 
CALL sp_registrar_multiples_servicios(1, '1,3,5');