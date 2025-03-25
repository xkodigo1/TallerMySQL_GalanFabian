-- Creación de la base de datos
CREATE DATABASE vtaszfs;
USE vtaszfs;
-- Tabla Clientes
CREATE TABLE Clientes (
id INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100),
email VARCHAR(100) UNIQUE
);
-- Tabla UbicacionCliente
CREATE TABLE UbicacionCliente (
id INT PRIMARY KEY AUTO_INCREMENT,
cliente_id INT,
direccion VARCHAR(255),
ciudad VARCHAR(100),
estado VARCHAR(50),
codigo_postal VARCHAR(10),
pais VARCHAR(50),
FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);
-- Tabla Empleados
CREATE TABLE Empleados (
id INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100),
REVISAR LA ESTRUCTURA DE LA BASE DE DATOS PARA VALIDAR QUE SE ENCUENTRA
DEBIDAMENTE NORMALIZADA.
puesto VARCHAR(50),
salario DECIMAL(10, 2),
fecha_contratacion DATE
);
-- Tabla Proveedores
CREATE TABLE Proveedores (
id INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100),
contacto VARCHAR(100),
telefono VARCHAR(20),
direccion VARCHAR(255)
);
-- Tabla TiposProductos
CREATE TABLE TiposProductos (
id INT PRIMARY KEY AUTO_INCREMENT,
tipo_nombre VARCHAR(100),
descripcion TEXT
);
-- Tabla Productos
CREATE TABLE Productos (
id INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100),
precio DECIMAL(10, 2),
proveedor_id INT,
tipo_id INT,
FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id),
FOREIGN KEY (tipo_id) REFERENCES TiposProductos(id)
);
-- Tabla Pedidos
CREATE TABLE Pedidos (
id INT PRIMARY KEY AUTO_INCREMENT,
cliente_id INT,
fecha DATE,
total DECIMAL(10, 2),
estado_id INT,
FOREIGN KEY (cliente_id) REFERENCES Clientes(id),
FOREIGN KEY (estado_id) REFERENCES EstadosPedido(id)
);
-- Tabla DetallesPedido
CREATE TABLE DetallesPedido (
id INT PRIMARY KEY AUTO_INCREMENT,
pedido_id INT,
producto_id INT,
cantidad INT,
precio DECIMAL(10, 2),
precio_historico DECIMAL(10, 2),
fecha_precio TIMESTAMP,
FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
FOREIGN KEY (producto_id) REFERENCES Productos(id)
);
-- Tabla HistorialPedidos
CREATE TABLE HistorialPedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT,
    fecha_modificacion TIMESTAMP,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50),
    usuario_modificacion INT,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (usuario_modificacion) REFERENCES Empleados(id)
);
-- Tabla TiposCliente
CREATE TABLE TiposCliente (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50)
);
-- Tabla Puestos
CREATE TABLE Puestos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    descripcion TEXT,
    nivel_jerarquico INT
);
-- Tabla DatosEmpleados
CREATE TABLE DatosEmpleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empleado_id INT,
    puesto_id INT,
    salario DECIMAL(10, 2),
    fecha_contratacion DATE,
    FOREIGN KEY (empleado_id) REFERENCES Empleados(id),
    FOREIGN KEY (puesto_id) REFERENCES Puestos(id)
);
-- Tabla Ubicaciones
CREATE TABLE Ubicaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    estado VARCHAR(50),
    codigo_postal VARCHAR(10),
    pais VARCHAR(50)
);
-- Tabla EntidadUbicacion
CREATE TABLE EntidadUbicacion (
    id INT PRIMARY KEY AUTO_INCREMENT,
    entidad_tipo ENUM('cliente', 'proveedor', 'empleado'),
    entidad_id INT,
    ubicacion_id INT,
    FOREIGN KEY (ubicacion_id) REFERENCES Ubicaciones(id)
);
-- Tabla ContactosProveedor
CREATE TABLE ContactosProveedor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    proveedor_id INT,
    nombre VARCHAR(100),
    cargo VARCHAR(50),
    email VARCHAR(100),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id)
);
-- Tabla Telefonos
CREATE TABLE Telefonos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    entidad_tipo ENUM('cliente', 'proveedor', 'empleado'),
    entidad_id INT,
    tipo_telefono VARCHAR(20),
    numero VARCHAR(20)
);
-- Tabla CategoriasProducto
CREATE TABLE CategoriasProducto (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    categoria_padre_id INT NULL,
    nivel INT,
    FOREIGN KEY (categoria_padre_id) REFERENCES CategoriasProducto(id)
);
-- Tabla EstadosPedido
CREATE TABLE EstadosPedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(50)
);
-- Tabla EmpleadosProveedores
CREATE TABLE EmpleadosProveedores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empleado_id INT,
    proveedor_id INT,
    rol VARCHAR(50),
    fecha_asignacion DATE,
    FOREIGN KEY (empleado_id) REFERENCES Empleados(id),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id)
);

-- Tabla para historial de salarios
CREATE TABLE HistorialSalarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empleado_id INT,
    salario_anterior DECIMAL(10,2),
    salario_nuevo DECIMAL(10,2),
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion VARCHAR(50),
    FOREIGN KEY (empleado_id) REFERENCES Empleados(id)
);

-- Tabla para log de actividades
CREATE TABLE LogActividades (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tabla VARCHAR(50),
    tipo_operacion VARCHAR(20),
    id_registro INT,
    datos_anteriores TEXT,
    datos_nuevos TEXT,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50)
);

-- Tabla para historial de contratos
CREATE TABLE HistorialContratos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empleado_id INT,
    puesto_anterior VARCHAR(50),
    puesto_nuevo VARCHAR(50),
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empleado_id) REFERENCES Empleados(id)
);