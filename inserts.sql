-- Insertar tipos de cliente
INSERT INTO TiposCliente (tipo) VALUES 
('Regular'),
('Premium'),
('Corporativo'),
('VIP');

-- Insertar ubicaciones base
INSERT INTO Ubicaciones (direccion, ciudad, estado, codigo_postal, pais) VALUES
('Av. Reforma 222', 'Ciudad de México', 'CDMX', '01000', 'México'),
('Av. Vallarta 1458', 'Guadalajara', 'Jalisco', '44100', 'México'),
('Av. Constitución 123', 'Monterrey', 'Nuevo León', '64000', 'México'),
('Paseo de la República 500', 'Querétaro', 'Querétaro', '76000', 'México'),
('Blvd. Kukulcán 55', 'Cancún', 'Quintana Roo', '77500', 'México');

-- Insertar clientes
INSERT INTO Clientes (nombre, email) VALUES
('Juan Pérez', 'juan.perez@email.com'),
('María García', 'maria.garcia@email.com'),
('Empresas XYZ', 'contacto@xyz.com'),
('Roberto Gómez', 'roberto@email.com'),
('Ana López', 'ana.lopez@email.com');

-- Insertar ubicaciones de clientes en EntidadUbicacion
INSERT INTO EntidadUbicacion (entidad_tipo, entidad_id, ubicacion_id) VALUES
('cliente', 1, 1),
('cliente', 2, 2),
('cliente', 3, 3),
('cliente', 4, 4),
('cliente', 5, 5);

-- Insertar puestos
INSERT INTO Puestos (nombre, descripcion, nivel_jerarquico) VALUES
('Director General', 'Máxima autoridad ejecutiva', 1),
('Gerente Ventas', 'Responsable del equipo de ventas', 2),
('Gerente Compras', 'Responsable de adquisiciones', 2),
('Vendedor Senior', 'Vendedor con experiencia', 3),
('Vendedor Junior', 'Vendedor en formación', 4);

-- Insertar empleados
INSERT INTO Empleados (nombre) VALUES
('Carlos Rodríguez'),
('Ana Martínez'),
('Luis Torres'),
('Patricia Sánchez'),
('Miguel Ángel Ruiz');

-- Insertar datos de empleados
INSERT INTO DatosEmpleados (empleado_id, puesto_id, salario, fecha_contratacion) VALUES
(1, 1, 80000.00, '2021-01-15'),
(2, 2, 50000.00, '2021-03-20'),
(3, 3, 50000.00, '2021-06-10'),
(4, 4, 35000.00, '2022-01-15'),
(5, 5, 25000.00, '2022-03-01');

-- Insertar proveedores
INSERT INTO Proveedores (nombre, contacto, telefono, direccion) VALUES
('Distribuidora Nacional', 'Roberto Gómez', '555-0101', 'Av. Industrial 789'),
('Importaciones del Norte', 'Laura Sánchez', '555-0202', 'Blvd. Comercial 456'),
('Mayorista Express', 'Pedro Ramírez', '555-0303', 'Calle Negocios 123'),
('Tecnología Avanzada', 'Carmen Ortiz', '555-0404', 'Av. Digital 777'),
('Suministros Rápidos', 'Jorge Díaz', '555-0505', 'Calle Proveedores 321');

-- Insertar contactos de proveedores
INSERT INTO ContactosProveedor (proveedor_id, nombre, cargo, email) VALUES
(1, 'Roberto Gómez', 'Gerente Ventas', 'roberto@distribuidor.com'),
(1, 'María Pérez', 'Ejecutiva Cuenta', 'maria@distribuidor.com'),
(2, 'Laura Sánchez', 'Directora', 'laura@importaciones.com'),
(3, 'Pedro Ramírez', 'Dueño', 'pedro@mayorista.com'),
(4, 'Carmen Ortiz', 'Gerente General', 'carmen@tecnologia.com');

-- Insertar categorías de producto
INSERT INTO CategoriasProducto (nombre, categoria_padre_id, nivel) VALUES
('Electrónicos', NULL, 1),
('Computadoras', 1, 2),
('Periféricos', 1, 2),
('Muebles', NULL, 1),
('Muebles de Oficina', 4, 2);

-- Insertar tipos de productos
INSERT INTO TiposProductos (tipo_nombre, descripcion) VALUES
('Hardware', 'Componentes físicos de computadora'),
('Software', 'Programas y aplicaciones'),
('Mobiliario', 'Muebles y accesorios'),
('Consumibles', 'Productos de uso frecuente'),
('Accesorios', 'Complementos varios');

-- Insertar productos
INSERT INTO Productos (nombre, precio, proveedor_id, tipo_id) VALUES
('Laptop HP Elite', 25000.00, 1, 1),
('Monitor Dell 27"', 5000.00, 1, 1),
('Escritorio Ejecutivo', 8500.00, 2, 3),
('Silla Ergonómica', 4500.00, 2, 3),
('Impresora Láser', 3500.00, 3, 1);

-- Insertar estados de pedido
INSERT INTO EstadosPedido (estado) VALUES
('Pendiente'),
('En proceso'),
('Enviado'),
('Entregado'),
('Cancelado');

-- Insertar pedidos
INSERT INTO Pedidos (cliente_id, fecha, total, estado_id) VALUES
(1, '2024-03-01', 25000.00, 1),
(2, '2024-03-02', 13000.00, 2),
(3, '2024-03-03', 8500.00, 3),
(4, '2024-03-04', 4500.00, 4),
(5, '2024-03-05', 3500.00, 1);

-- Insertar detalles de pedido
INSERT INTO DetallesPedido (pedido_id, producto_id, cantidad, precio, precio_historico, fecha_precio) VALUES
(1, 1, 1, 25000.00, 25000.00, '2024-03-01 10:00:00'),
(2, 2, 2, 5000.00, 5000.00, '2024-03-02 11:00:00'),
(3, 3, 1, 8500.00, 8500.00, '2024-03-03 12:00:00'),
(4, 4, 1, 4500.00, 4500.00, '2024-03-04 13:00:00'),
(5, 5, 1, 3500.00, 3500.00, '2024-03-05 14:00:00');

-- Insertar teléfonos
INSERT INTO Telefonos (entidad_tipo, entidad_id, tipo_telefono, numero) VALUES
('cliente', 1, 'Móvil', '555-1111'),
('cliente', 1, 'Oficina', '555-1112'),
('proveedor', 1, 'Principal', '555-2221'),
('empleado', 1, 'Móvil', '555-3331'),
('empleado', 2, 'Móvil', '555-3332');

-- Insertar empleados-proveedores
INSERT INTO EmpleadosProveedores (empleado_id, proveedor_id, rol, fecha_asignacion) VALUES
(1, 1, 'Supervisor', '2024-01-01'),
(2, 1, 'Contacto Principal', '2024-01-02'),
(3, 2, 'Supervisor', '2024-01-03'),
(4, 3, 'Contacto Principal', '2024-01-04'),
(5, 4, 'Supervisor', '2024-01-05');

-- Insertar historial de pedidos
INSERT INTO HistorialPedidos (pedido_id, fecha_modificacion, estado_anterior, estado_nuevo, usuario_modificacion) VALUES
(1, '2024-03-01 10:00:00', 'Pendiente', 'En proceso', 1),
(2, '2024-03-02 11:00:00', 'Pendiente', 'En proceso', 2),
(3, '2024-03-03 12:00:00', 'En proceso', 'Enviado', 3),
(4, '2024-03-04 13:00:00', 'Enviado', 'Entregado', 4),
(5, '2024-03-05 14:00:00', 'Pendiente', 'En proceso', 5); 