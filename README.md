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


