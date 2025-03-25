# TallerMySQL_GalanFabian
Este taller está diseñado para profundizar en el manejo y optimización de bases de datos MySQL. A través de ejercicios prácticos, se explorarán temas avanzados para reforzar el conocimiento en normalización, joins, consultas complejas, subconsultas, procedimientos almacenados, funciones definidas por el usuario y triggers.

## Join
´´´sql
-- 1. Pedidos con nombres de clientes
SELECT p.id as pedido_id, 
       c.nombre as cliente, 
       p.fecha, 
       p.total, 
       ep.estado
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
INNER JOIN EstadosPedido ep ON p.estado_id = ep.id;

-- 2. Productos y sus proveedores
SELECT p.nombre as producto, 
       p.precio, 
       pr.nombre as proveedor, 
       pr.contacto
FROM Productos p
INNER JOIN Proveedores pr ON p.proveedor_id = pr.id;

-- 3. Pedidos y ubicaciones de clientes
SELECT p.id as pedido_id, 
       c.nombre as cliente, 
       u.direccion, 
       u.ciudad
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
LEFT JOIN EntidadUbicacion eu ON eu.entidad_id = c.id AND eu.entidad_tipo = 'cliente'
LEFT JOIN Ubicaciones u ON eu.ubicacion_id = u.id;

-- 4. Empleados y sus pedidos
SELECT e.nombre as empleado, 
       p.id as pedido_id, 
       p.fecha
FROM Empleados e
LEFT JOIN HistorialPedidos hp ON hp.usuario_modificacion = e.id
LEFT JOIN Pedidos p ON hp.pedido_id = p.id;

-- 5. Tipos de producto y productos
SELECT tp.tipo_nombre, 
       p.nombre as producto, 
       p.precio
FROM TiposProductos tp
INNER JOIN Productos p ON p.tipo_id = tp.id;

-- 6. Clientes y número de pedidos
SELECT c.nombre, 
       COUNT(p.id) as total_pedidos
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre;

-- 7. Pedidos y empleados que los gestionaron
SELECT p.id as pedido_id, 
       e.nombre as empleado, 
       hp.fecha_modificacion, 
       hp.estado_nuevo
FROM Pedidos p
INNER JOIN HistorialPedidos hp ON p.id = hp.pedido_id
INNER JOIN Empleados e ON hp.usuario_modificacion = e.id;

-- 8. Productos sin pedidos
SELECT p.nombre as producto, 
       p.precio
FROM Productos p
LEFT JOIN DetallesPedido dp ON p.id = dp.producto_id
WHERE dp.id IS NULL;

-- 9. Total de pedidos y ubicación de clientes
SELECT c.nombre as cliente, 
       u.ciudad, 
       u.estado, 
       COUNT(p.id) as total_pedidos, 
       SUM(p.total) as monto_total
FROM Clientes c
INNER JOIN EntidadUbicacion eu ON c.id = eu.entidad_id AND eu.entidad_tipo = 'cliente'
INNER JOIN Ubicaciones u ON eu.ubicacion_id = u.id
LEFT JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, u.ciudad, u.estado;

-- 10. Listado completo de inventario
SELECT pr.nombre as proveedor, 
       p.nombre as producto, 
       tp.tipo_nombre, 
       p.precio
FROM Proveedores pr
INNER JOIN Productos p ON pr.id = p.proveedor_id
INNER JOIN TiposProductos tp ON p.tipo_id = tp.id;
´´´
## Consultas Simples

-- 1. Productos con precio mayor a $50
SELECT id, nombre, precio, proveedor_id, tipo_id
FROM Productos
WHERE precio > 50;

-- 2. Clientes en una ciudad específica (ejemplo con 'Ciudad de México')
SELECT c.id, c.nombre, c.email, u.ciudad
FROM Clientes c
INNER JOIN EntidadUbicacion eu ON c.id = eu.entidad_id AND eu.entidad_tipo = 'cliente'
INNER JOIN Ubicaciones u ON eu.ubicacion_id = u.id
WHERE u.ciudad = 'Ciudad de México';

-- 3. Empleados contratados en los últimos 2 años
SELECT e.id, e.nombre, de.fecha_contratacion, de.salario
FROM Empleados e
INNER JOIN DatosEmpleados de ON e.id = de.empleado_id
WHERE de.fecha_contratacion >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

-- 4. Proveedores que suministran más de 5 productos
SELECT p.id, p.nombre, p.contacto, COUNT(pr.id) as total_productos
FROM Proveedores p
INNER JOIN Productos pr ON p.id = pr.proveedor_id
GROUP BY p.id, p.nombre, p.contacto
HAVING COUNT(pr.id) > 5;

-- 5. Clientes sin dirección registrada
SELECT c.id, c.nombre, c.email
FROM Clientes c
LEFT JOIN EntidadUbicacion eu ON c.id = eu.entidad_id AND eu.entidad_tipo = 'cliente'
WHERE eu.id IS NULL;

-- 6. Total de ventas por cliente
SELECT c.id, c.nombre, SUM(p.total) as total_ventas
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre;

-- 7. Salario promedio de empleados
SELECT 
    ROUND(AVG(de.salario), 2) as salario_promedio,
    MIN(de.salario) as salario_minimo,
    MAX(de.salario) as salario_maximo
FROM DatosEmpleados de;

-- 8. Tipos de productos disponibles
SELECT id, tipo_nombre, descripcion
FROM TiposProductos
ORDER BY tipo_nombre;

-- 9. Los 3 productos más caros
SELECT id, nombre, precio, proveedor_id
FROM Productos
ORDER BY precio DESC
LIMIT 3;

-- 10. Cliente con mayor número de pedidos
SELECT 
    c.id, 
    c.nombre, 
    c.email,
    COUNT(p.id) as total_pedidos
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.email
ORDER BY total_pedidos DESC
LIMIT 1;

## Consultas Multitabla

-- 1. Pedidos y cliente asociado
SELECT 
    p.id AS pedido_id,
    p.fecha,
    p.total,
    c.nombre AS cliente,
    ep.estado AS estado_pedido
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
INNER JOIN EstadosPedido ep ON p.estado_id = ep.id;

-- 2. Ubicación de clientes en pedidos
SELECT 
    p.id AS pedido_id,
    c.nombre AS cliente,
    u.direccion,
    u.ciudad,
    u.estado,
    p.total
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
INNER JOIN EntidadUbicacion eu ON c.id = eu.entidad_id AND eu.entidad_tipo = 'cliente'
INNER JOIN Ubicaciones u ON eu.ubicacion_id = u.id;

-- 3. Productos con proveedor y tipo
SELECT 
    p.nombre AS producto,
    p.precio,
    pr.nombre AS proveedor,
    tp.tipo_nombre AS tipo_producto
FROM Productos p
INNER JOIN Proveedores pr ON p.proveedor_id = pr.id
INNER JOIN TiposProductos tp ON p.tipo_id = tp.id;

-- 4. Empleados que gestionan pedidos en una ciudad específica (ejemplo: 'Ciudad de México')
SELECT DISTINCT
    e.nombre AS empleado,
    p.id AS pedido_id,
    c.nombre AS cliente,
    u.ciudad
FROM Empleados e
INNER JOIN HistorialPedidos hp ON e.id = hp.usuario_modificacion
INNER JOIN Pedidos p ON hp.pedido_id = p.id
INNER JOIN Clientes c ON p.cliente_id = c.id
INNER JOIN EntidadUbicacion eu ON c.id = eu.entidad_id AND eu.entidad_tipo = 'cliente'
INNER JOIN Ubicaciones u ON eu.ubicacion_id = u.id
WHERE u.ciudad = 'Ciudad de México';

-- 5. Los 5 productos más vendidos
SELECT 
    p.nombre AS producto,
    p.precio,
    COUNT(dp.id) AS veces_vendido,
    SUM(dp.cantidad) AS cantidad_total
FROM Productos p
INNER JOIN DetallesPedido dp ON p.id = dp.producto_id
GROUP BY p.id, p.nombre, p.precio
ORDER BY cantidad_total DESC
LIMIT 5;

-- 6. Total de pedidos por cliente y ciudad
SELECT 
    c.nombre AS cliente,
    u.ciudad,
    COUNT(p.id) AS total_pedidos,
    SUM(p.total) AS monto_total
FROM Clientes c
INNER JOIN EntidadUbicacion eu ON c.id = eu.entidad_id AND eu.entidad_tipo = 'cliente'
INNER JOIN Ubicaciones u ON eu.ubicacion_id = u.id
LEFT JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, u.ciudad;

-- 7. Clientes y proveedores en la misma ciudad
SELECT 
    c.nombre AS cliente,
    p.nombre AS proveedor,
    u1.ciudad
FROM Clientes c
INNER JOIN EntidadUbicacion eu1 ON c.id = eu1.entidad_id AND eu1.entidad_tipo = 'cliente'
INNER JOIN Ubicaciones u1 ON eu1.ubicacion_id = u1.id
INNER JOIN EntidadUbicacion eu2 ON u1.ciudad = (
    SELECT u2.ciudad 
    FROM EntidadUbicacion eu3
    INNER JOIN Ubicaciones u2 ON eu3.ubicacion_id = u2.id
    WHERE eu3.entidad_tipo = 'proveedor' AND eu3.entidad_id = p.id
)
INNER JOIN Proveedores p ON eu2.entidad_id = p.id AND eu2.entidad_tipo = 'proveedor';

-- 8. Total de ventas por tipo de producto
SELECT 
    tp.tipo_nombre,
    COUNT(dp.id) AS numero_ventas,
    SUM(dp.cantidad * dp.precio) AS total_ventas
FROM TiposProductos tp
INNER JOIN Productos p ON tp.id = p.tipo_id
INNER JOIN DetallesPedido dp ON p.id = dp.producto_id
GROUP BY tp.id, tp.tipo_nombre
ORDER BY total_ventas DESC;

-- 9. Empleados que gestionan pedidos de productos de un proveedor específico (ejemplo: 'Distribuidora Nacional')
SELECT DISTINCT
    e.nombre AS empleado,
    pr.nombre AS proveedor,
    p.nombre AS producto
FROM Empleados e
INNER JOIN HistorialPedidos hp ON e.id = hp.usuario_modificacion
INNER JOIN Pedidos ped ON hp.pedido_id = ped.id
INNER JOIN DetallesPedido dp ON ped.id = dp.pedido_id
INNER JOIN Productos p ON dp.producto_id = p.id
INNER JOIN Proveedores pr ON p.proveedor_id = pr.id
WHERE pr.nombre = 'Distribuidora Nacional';

-- 10. Ingreso total por proveedor
SELECT 
    pr.nombre AS proveedor,
    COUNT(DISTINCT dp.pedido_id) AS total_pedidos,
    SUM(dp.cantidad * dp.precio) AS ingreso_total
FROM Proveedores pr
INNER JOIN Productos p ON pr.id = p.proveedor_id
INNER JOIN DetallesPedido dp ON p.id = dp.producto_id
GROUP BY pr.id, pr.nombre
ORDER BY ingreso_total DESC;

## Subconsultas

-- 1. Producto más caro por categoría
SELECT 
    tp.tipo_nombre,
    p.nombre AS producto,
    p.precio
FROM Productos p
INNER JOIN TiposProductos tp ON p.tipo_id = tp.id
WHERE (p.tipo_id, p.precio) IN (
    SELECT tipo_id, MAX(precio)
    FROM Productos
    GROUP BY tipo_id
);

-- 2. Cliente con mayor total en pedidos
SELECT 
    c.nombre AS cliente,
    c.email,
    total_pedidos.suma_total
FROM Clientes c
INNER JOIN (
    SELECT 
        cliente_id, 
        SUM(total) as suma_total
    FROM Pedidos
    GROUP BY cliente_id
) total_pedidos ON c.id = total_pedidos.cliente_id
WHERE total_pedidos.suma_total = (
    SELECT SUM(total)
    FROM Pedidos
    GROUP BY cliente_id
    ORDER BY SUM(total) DESC
    LIMIT 1
);

-- 3. Empleados con salario superior al promedio
SELECT 
    e.nombre AS empleado,
    de.salario
FROM Empleados e
INNER JOIN DatosEmpleados de ON e.id = de.empleado_id
WHERE de.salario > (
    SELECT AVG(salario)
    FROM DatosEmpleados
);

-- 4. Productos pedidos más de 5 veces
SELECT 
    p.nombre AS producto,
    p.precio,
    COUNT_pedidos.total_pedidos
FROM Productos p
INNER JOIN (
    SELECT 
        producto_id, 
        COUNT(*) as total_pedidos
    FROM DetallesPedido
    GROUP BY producto_id
    HAVING COUNT(*) > 5
) COUNT_pedidos ON p.id = COUNT_pedidos.producto_id;

-- 5. Pedidos con total mayor al promedio
SELECT 
    p.id AS pedido_id,
    c.nombre AS cliente,
    p.fecha,
    p.total
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
WHERE p.total > (
    SELECT AVG(total)
    FROM Pedidos
);

-- 6. Top 3 proveedores con más productos
SELECT 
    pr.nombre AS proveedor,
    COUNT_productos.total_productos
FROM Proveedores pr
INNER JOIN (
    SELECT 
        proveedor_id, 
        COUNT(*) as total_productos
    FROM Productos
    GROUP BY proveedor_id
) COUNT_productos ON pr.id = COUNT_productos.proveedor_id
ORDER BY COUNT_productos.total_productos DESC
LIMIT 3;

-- 7. Productos con precio superior al promedio de su tipo
SELECT 
    p.nombre AS producto,
    p.precio,
    tp.tipo_nombre,
    avg_precios.precio_promedio
FROM Productos p
INNER JOIN TiposProductos tp ON p.tipo_id = tp.id
INNER JOIN (
    SELECT 
        tipo_id, 
        AVG(precio) as precio_promedio
    FROM Productos
    GROUP BY tipo_id
) avg_precios ON p.tipo_id = avg_precios.tipo_id
WHERE p.precio > avg_precios.precio_promedio;

-- 8. Clientes con más pedidos que la media
SELECT 
    c.nombre AS cliente,
    COUNT_pedidos.total_pedidos
FROM Clientes c
INNER JOIN (
    SELECT 
        cliente_id, 
        COUNT(*) as total_pedidos
    FROM Pedidos
    GROUP BY cliente_id
) COUNT_pedidos ON c.id = COUNT_pedidos.cliente_id
WHERE COUNT_pedidos.total_pedidos > (
    SELECT AVG(pedidos_por_cliente)
    FROM (
        SELECT COUNT(*) as pedidos_por_cliente
        FROM Pedidos
        GROUP BY cliente_id
    ) avg_pedidos
);

-- 9. Productos con precio mayor al promedio general
SELECT 
    p.nombre AS producto,
    p.precio,
    tp.tipo_nombre
FROM Productos p
INNER JOIN TiposProductos tp ON p.tipo_id = tp.id
WHERE p.precio > (
    SELECT AVG(precio)
    FROM Productos
)
ORDER BY p.precio DESC;

-- 10. Empleados con salario menor al promedio de su departamento
SELECT 
    e.nombre AS empleado,
    de.salario,
    p.nombre AS puesto
FROM Empleados e
INNER JOIN DatosEmpleados de ON e.id = de.empleado_id
INNER JOIN Puestos p ON de.puesto_id = p.id
WHERE de.salario < (
    SELECT AVG(de2.salario)
    FROM DatosEmpleados de2
    WHERE de2.puesto_id = de.puesto_id
);

## Procedimientos Almacenados


-- 1. Actualizar precios de productos por proveedor
DELIMITER //
CREATE PROCEDURE ActualizarPreciosProveedor(
    IN proveedor_id INT,
    IN porcentaje_incremento DECIMAL(5,2)
)
BEGIN
    UPDATE Productos
    SET precio = precio * (1 + porcentaje_incremento/100)
    WHERE proveedor_id = proveedor_id;
    
    SELECT 
        nombre AS producto,
        precio AS nuevo_precio
    FROM Productos
    WHERE proveedor_id = proveedor_id;
END //
DELIMITER ;

-- 2. Obtener dirección de cliente
DELIMITER //
CREATE PROCEDURE ObtenerDireccionCliente(
    IN cliente_id INT
)
BEGIN
    SELECT 
        c.nombre AS cliente,
        u.direccion,
        u.ciudad,
        u.estado,
        u.codigo_postal,
        u.pais
    FROM Clientes c
    INNER JOIN EntidadUbicacion eu ON c.id = eu.entidad_id 
        AND eu.entidad_tipo = 'cliente'
    INNER JOIN Ubicaciones u ON eu.ubicacion_id = u.id
    WHERE c.id = cliente_id;
END //
DELIMITER ;

-- 3. Registrar nuevo pedido y detalles
DELIMITER //
CREATE PROCEDURE RegistrarPedido(
    IN p_cliente_id INT,
    IN p_producto_id INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_pedido_id INT;
    
    -- Obtener precio actual del producto
    SELECT precio INTO v_precio 
    FROM Productos 
    WHERE id = p_producto_id;
    
    -- Calcular total
    SET v_total = v_precio * p_cantidad;
    
    -- Iniciar transacción
    START TRANSACTION;
    
    -- Insertar pedido
    INSERT INTO Pedidos (cliente_id, fecha, total, estado_id)
    VALUES (p_cliente_id, CURDATE(), v_total, 1);
    
    SET v_pedido_id = LAST_INSERT_ID();
    
    -- Insertar detalle del pedido
    INSERT INTO DetallesPedido (
        pedido_id, 
        producto_id, 
        cantidad, 
        precio, 
        precio_historico, 
        fecha_precio
    )
    VALUES (
        v_pedido_id,
        p_producto_id,
        p_cantidad,
        v_precio,
        v_precio,
        NOW()
    );
    
    COMMIT;
    
    -- Retornar información del pedido creado
    SELECT 
        p.id AS pedido_id,
        c.nombre AS cliente,
        pr.nombre AS producto,
        dp.cantidad,
        p.total
    FROM Pedidos p
    INNER JOIN Clientes c ON p.cliente_id = c.id
    INNER JOIN DetallesPedido dp ON p.id = dp.pedido_id
    INNER JOIN Productos pr ON dp.producto_id = pr.id
    WHERE p.id = v_pedido_id;
END //
DELIMITER ;

-- 4. Calcular total de ventas por cliente
DELIMITER //
CREATE PROCEDURE CalcularVentasCliente(
    IN cliente_id INT
)
BEGIN
    SELECT 
        c.nombre AS cliente,
        COUNT(p.id) AS total_pedidos,
        SUM(p.total) AS monto_total,
        MIN(p.fecha) AS primera_compra,
        MAX(p.fecha) AS ultima_compra
    FROM Clientes c
    LEFT JOIN Pedidos p ON c.id = p.cliente_id
    WHERE c.id = cliente_id
    GROUP BY c.id, c.nombre;
END //
DELIMITER ;

-- 5. Obtener empleados por puesto
DELIMITER //
CREATE PROCEDURE ObtenerEmpleadosPorPuesto(
    IN puesto_nombre VARCHAR(50)
)
BEGIN
    SELECT 
        e.nombre AS empleado,
        p.nombre AS puesto,
        de.salario,
        de.fecha_contratacion
    FROM Empleados e
    INNER JOIN DatosEmpleados de ON e.id = de.empleado_id
    INNER JOIN Puestos p ON de.puesto_id = p.id
    WHERE p.nombre = puesto_nombre
    ORDER BY de.fecha_contratacion;
END //
DELIMITER ;

-- 6. Actualizar salarios por puesto
DELIMITER //
CREATE PROCEDURE ActualizarSalariosPuesto(
    IN puesto_id INT,
    IN porcentaje_incremento DECIMAL(5,2)
)
BEGIN
    UPDATE DatosEmpleados
    SET salario = salario * (1 + porcentaje_incremento/100)
    WHERE puesto_id = puesto_id;
    
    SELECT 
        e.nombre AS empleado,
        p.nombre AS puesto,
        de.salario AS nuevo_salario
    FROM Empleados e
    INNER JOIN DatosEmpleados de ON e.id = de.empleado_id
    INNER JOIN Puestos p ON de.puesto_id = p.id
    WHERE p.id = puesto_id;
END //
DELIMITER ;

-- 7. Listar pedidos entre fechas
DELIMITER //
CREATE PROCEDURE ListarPedidosEntreFechas(
    IN fecha_inicio DATE,
    IN fecha_fin DATE
)
BEGIN
    SELECT 
        p.id AS pedido_id,
        p.fecha,
        c.nombre AS cliente,
        p.total,
        ep.estado
    FROM Pedidos p
    INNER JOIN Clientes c ON p.cliente_id = c.id
    INNER JOIN EstadosPedido ep ON p.estado_id = ep.id
    WHERE p.fecha BETWEEN fecha_inicio AND fecha_fin
    ORDER BY p.fecha;
END //
DELIMITER ;

-- 8. Aplicar descuento a categoría
DELIMITER //
CREATE PROCEDURE AplicarDescuentoCategoria(
    IN categoria_id INT,
    IN porcentaje_descuento DECIMAL(5,2)
)
BEGIN
    UPDATE Productos p
    INNER JOIN CategoriasProducto cp ON p.tipo_id = cp.id
    SET p.precio = p.precio * (1 - porcentaje_descuento/100)
    WHERE cp.id = categoria_id;
    
    SELECT 
        p.nombre AS producto,
        p.precio AS nuevo_precio,
        cp.nombre AS categoria
    FROM Productos p
    INNER JOIN CategoriasProducto cp ON p.tipo_id = cp.id
    WHERE cp.id = categoria_id;
END //
DELIMITER ;

-- 9. Listar proveedores por tipo de producto
DELIMITER //
CREATE PROCEDURE ListarProveedoresPorTipoProducto(
    IN tipo_producto_id INT
)
BEGIN
    SELECT DISTINCT
        pr.nombre AS proveedor,
        pr.contacto,
        pr.telefono,
        COUNT(p.id) AS total_productos
    FROM Proveedores pr
    INNER JOIN Productos p ON pr.id = p.proveedor_id
    WHERE p.tipo_id = tipo_producto_id
    GROUP BY pr.id, pr.nombre, pr.contacto, pr.telefono;
END //
DELIMITER ;

-- 10. Obtener pedido de mayor valor
DELIMITER //
CREATE PROCEDURE ObtenerPedidoMayorValor()
BEGIN
    SELECT 
        p.id AS pedido_id,
        p.fecha,
        c.nombre AS cliente,
        p.total,
        ep.estado
    FROM Pedidos p
    INNER JOIN Clientes c ON p.cliente_id = c.id
    INNER JOIN EstadosPedido ep ON p.estado_id = ep.id
    WHERE p.total = (
        SELECT MAX(total)
        FROM Pedidos
    );
END //
DELIMITER ;

## Funciones Definidas por el Usuario

-- 1. Función para calcular días transcurridos
DELIMITER //
CREATE FUNCTION DiasTranscurridos(fecha_inicio DATE) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), fecha_inicio);
END //
DELIMITER ;

-- 2. Función para calcular total con impuesto
DELIMITER //
CREATE FUNCTION CalcularTotalConImpuesto(monto DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE impuesto DECIMAL(10,2) DEFAULT 0.16;
    RETURN monto * (1 + impuesto);
END //
DELIMITER ;

-- 3. Función para total de pedidos de cliente
DELIMITER //
CREATE FUNCTION TotalPedidosCliente(cliente_id INT) 
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Pedidos
    WHERE cliente_id = cliente_id;
    RETURN total;
END //
DELIMITER ;

-- 4. Función para aplicar descuento
DELIMITER //
CREATE FUNCTION AplicarDescuento(
    precio DECIMAL(10,2),
    porcentaje_descuento DECIMAL(5,2)
) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN precio * (1 - porcentaje_descuento/100);
END //
DELIMITER ;

-- 5. Función para verificar dirección de cliente
DELIMITER //
CREATE FUNCTION ClienteTieneDireccion(cliente_id INT) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE tiene_direccion BOOLEAN;
    SELECT EXISTS(
        SELECT 1 
        FROM EntidadUbicacion
        WHERE entidad_id = cliente_id 
        AND entidad_tipo = 'cliente'
    ) INTO tiene_direccion;
    RETURN tiene_direccion;
END //
DELIMITER ;

-- 6. Función para calcular salario anual
DELIMITER //
CREATE FUNCTION SalarioAnualEmpleado(empleado_id INT) 
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE salario_mensual DECIMAL(10,2);
    SELECT salario INTO salario_mensual
    FROM DatosEmpleados
    WHERE empleado_id = empleado_id;
    RETURN salario_mensual * 12;
END //
DELIMITER ;

-- 7. Función para total ventas por tipo producto
DELIMITER //
CREATE FUNCTION TotalVentasTipoProducto(tipo_id INT) 
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(12,2);
    SELECT COALESCE(SUM(dp.cantidad * dp.precio), 0) INTO total
    FROM DetallesPedido dp
    INNER JOIN Productos p ON dp.producto_id = p.id
    WHERE p.tipo_id = tipo_id;
    RETURN total;
END //
DELIMITER ;

-- 8. Función para obtener nombre de cliente
DELIMITER //
CREATE FUNCTION ObtenerNombreCliente(cliente_id INT) 
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE nombre_cliente VARCHAR(100);
    SELECT nombre INTO nombre_cliente
    FROM Clientes
    WHERE id = cliente_id;
    RETURN COALESCE(nombre_cliente, 'Cliente no encontrado');
END //
DELIMITER ;

-- 9. Función para obtener total de pedido
DELIMITER //
CREATE FUNCTION ObtenerTotalPedido(pedido_id INT) 
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE total_pedido DECIMAL(10,2);
    SELECT total INTO total_pedido
    FROM Pedidos
    WHERE id = pedido_id;
    RETURN COALESCE(total_pedido, 0);
END //
DELIMITER ;

-- 10. Función para verificar producto en inventario
DELIMITER //
CREATE FUNCTION ProductoEnInventario(producto_id INT) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE existe BOOLEAN;
    SELECT EXISTS(
        SELECT 1 
        FROM Productos 
        WHERE id = producto_id
    ) INTO existe;
    RETURN existe;
END //
DELIMITER ;

## Triggers

-- 1. Trigger para registrar cambios de salario
DELIMITER //
CREATE TRIGGER trg_registrar_cambio_salario
AFTER UPDATE ON DatosEmpleados
FOR EACH ROW
BEGIN
    IF OLD.salario != NEW.salario THEN
        INSERT INTO HistorialSalarios (
            empleado_id,
            salario_anterior,
            salario_nuevo,
            usuario_modificacion
        )
        VALUES (
            NEW.empleado_id,
            OLD.salario,
            NEW.salario,
            CURRENT_USER()
        );
    END IF;
END //
DELIMITER ;

-- 2. Trigger para evitar borrar productos con pedidos
DELIMITER //
CREATE TRIGGER trg_proteger_productos_pedidos
BEFORE DELETE ON Productos
FOR EACH ROW
BEGIN
    DECLARE pedidos_activos INT;
    
    SELECT COUNT(*) INTO pedidos_activos
    FROM DetallesPedido dp
    INNER JOIN Pedidos p ON dp.pedido_id = p.id
    WHERE dp.producto_id = OLD.id
    AND p.estado_id IN (1,2,3); -- Estados activos
    
    IF pedidos_activos > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar un producto con pedidos activos';
    END IF;
END //
DELIMITER ;

-- 3. Trigger para registrar cambios en pedidos
DELIMITER //
CREATE TRIGGER trg_registrar_cambio_pedido
AFTER UPDATE ON Pedidos
FOR EACH ROW
BEGIN
    INSERT INTO HistorialPedidos (
        pedido_id,
        fecha_modificacion,
        estado_anterior,
        estado_nuevo,
        usuario_modificacion
    )
    SELECT 
        NEW.id,
        CURRENT_TIMESTAMP,
        (SELECT estado FROM EstadosPedido WHERE id = OLD.estado_id),
        (SELECT estado FROM EstadosPedido WHERE id = NEW.estado_id),
        CURRENT_USER();
END //
DELIMITER ;

-- 4. Trigger para actualizar inventario
DELIMITER //
CREATE TRIGGER trg_actualizar_inventario
AFTER INSERT ON DetallesPedido
FOR EACH ROW
BEGIN
    -- Asumiendo que existe una columna stock en Productos
    UPDATE Productos
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;
    
    -- Validar stock mínimo
    IF (SELECT stock FROM Productos WHERE id = NEW.producto_id) < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;
END //
DELIMITER ;

-- 5. Trigger para validar precio mínimo
DELIMITER //
CREATE TRIGGER trg_validar_precio_minimo
BEFORE UPDATE ON Productos
FOR EACH ROW
BEGIN
    IF NEW.precio < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio no puede ser menor a $1';
    END IF;
END //
DELIMITER ;

-- 6. Trigger para registrar creación de pedido
DELIMITER //
CREATE TRIGGER trg_registrar_nuevo_pedido
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    INSERT INTO HistorialPedidos (
        pedido_id,
        fecha_modificacion,
        estado_anterior,
        estado_nuevo,
        usuario_modificacion
    )
    VALUES (
        NEW.id,
        CURRENT_TIMESTAMP,
        NULL,
        (SELECT estado FROM EstadosPedido WHERE id = NEW.estado_id),
        CURRENT_USER()
    );
END //
DELIMITER ;

-- 7. Trigger para mantener total de pedido actualizado
DELIMITER //
CREATE TRIGGER trg_actualizar_total_pedido
AFTER INSERT ON DetallesPedido
FOR EACH ROW
BEGIN
    UPDATE Pedidos
    SET total = (
        SELECT SUM(cantidad * precio)
        FROM DetallesPedido
        WHERE pedido_id = NEW.pedido_id
    )
    WHERE id = NEW.pedido_id;
END //
DELIMITER ;

-- 8. Trigger para validar ubicación de cliente
DELIMITER //
CREATE TRIGGER trg_validar_ubicacion_cliente
AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM EntidadUbicacion 
        WHERE entidad_id = NEW.id 
        AND entidad_tipo = 'cliente'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Debe especificar una ubicación para el cliente';
    END IF;
END //
DELIMITER ;

-- 9. Trigger para registrar cambios en proveedores
DELIMITER //
CREATE TRIGGER trg_registrar_cambios_proveedor
AFTER UPDATE ON Proveedores
FOR EACH ROW
BEGIN
    INSERT INTO LogActividades (
        tabla,
        tipo_operacion,
        id_registro,
        datos_anteriores,
        datos_nuevos,
        usuario
    )
    VALUES (
        'Proveedores',
        'UPDATE',
        NEW.id,
        CONCAT('nombre: ', OLD.nombre, ', contacto: ', OLD.contacto),
        CONCAT('nombre: ', NEW.nombre, ', contacto: ', NEW.contacto),
        CURRENT_USER()
    );
END //
DELIMITER ;

-- 10. Trigger para registrar cambios en empleados
DELIMITER //
CREATE TRIGGER trg_registrar_cambios_empleado
AFTER UPDATE ON DatosEmpleados
FOR EACH ROW
BEGIN
    IF OLD.puesto_id != NEW.puesto_id THEN
        INSERT INTO HistorialContratos (
            empleado_id,
            puesto_anterior,
            puesto_nuevo
        )
        SELECT 
            NEW.empleado_id,
            (SELECT nombre FROM Puestos WHERE id = OLD.puesto_id),
            (SELECT nombre FROM Puestos WHERE id = NEW.puesto_id);
    END IF;
END //
DELIMITER ;