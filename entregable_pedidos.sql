-- ===========================================
-- 1.1 DDL: CREACIÓN DEL ESQUEMA FÍSICO
-- ===========================================
DROP DATABASE IF EXISTS PEDIDOS;
CREATE DATABASE PEDIDOS CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE PEDIDOS;

CREATE TABLE Proveedores (
    idproveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_proveedor VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    mail VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Clientes (
    idcliente INT AUTO_INCREMENT PRIMARY KEY,
    apellido VARCHAR(50) NOT NULL,
    nombres VARCHAR(50) NOT NULL,
    direccion VARCHAR(200),
    mail VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Vendedor (
    idvendedor INT AUTO_INCREMENT PRIMARY KEY,
    apellido VARCHAR(50) NOT NULL,
    nombres VARCHAR(50) NOT NULL,
    mail VARCHAR(100) NOT NULL UNIQUE,
    comision DECIMAL(5,2) CHECK (comision >= 0 AND comision <= 100)
);

CREATE TABLE Productos (
    idproducto INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(200) NOT NULL,
    precio_unitario DECIMAL(10,2) CHECK (precio_unitario >= 0),
    stock INT CHECK (stock >= 0),
    stock_max INT,
    stock_min INT,
    idproveedor INT,
    origen VARCHAR(20) CHECK (origen IN ('Nacional', 'Importado')),
    FOREIGN KEY (idproveedor) REFERENCES Proveedores(idproveedor) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Pedidos (
    numero_pedido INT AUTO_INCREMENT PRIMARY KEY,
    idcliente INT,
    idvendedor INT,
    fecha DATE NOT NULL,
    estado VARCHAR(20) CHECK (estado IN ('CONFIRMADO', 'ANULADO', 'PENDIENTE')),
    FOREIGN KEY (idcliente) REFERENCES Clientes(idcliente) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (idvendedor) REFERENCES Vendedor(idvendedor) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Detalle_Pedidos (
    numero_pedido INT,
    renglon INT,
    idproducto INT,
    cantidad INT CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2),
    total DECIMAL(12,2),
    PRIMARY KEY (numero_pedido, renglon),
    FOREIGN KEY (numero_pedido) REFERENCES Pedidos(numero_pedido) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (idproducto) REFERENCES Productos(idproducto) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ===========================================
-- 1.2 DML: POBLADO MASIVO DE DATOS (INSERTs)
-- ===========================================
-- Proveedores
INSERT INTO Proveedores (nombre_proveedor, direccion, mail) VALUES ('Proveedor Tech 1 S.A.', 'Calle Proveedor 100', 'contacto@proveedortech1.com.ar');
INSERT INTO Proveedores (nombre_proveedor, direccion, mail) VALUES ('Proveedor Tech 2 S.A.', 'Calle Proveedor 200', 'contacto@proveedortech2.com.ar');
INSERT INTO Proveedores (nombre_proveedor, direccion, mail) VALUES ('Proveedor Tech 3 S.A.', 'Calle Proveedor 300', 'contacto@proveedortech3.com.ar');
INSERT INTO Proveedores (nombre_proveedor, direccion, mail) VALUES ('Proveedor Tech 4 S.A.', 'Calle Proveedor 400', 'contacto@proveedortech4.com.ar');
INSERT INTO Proveedores (nombre_proveedor, direccion, mail) VALUES ('Proveedor Tech 5 S.A.', 'Calle Proveedor 500', 'contacto@proveedortech5.com.ar');
INSERT INTO Proveedores (nombre_proveedor, direccion, mail) VALUES ('Proveedor Tech 6 S.A.', 'Calle Proveedor 600', 'contacto@proveedortech6.com.ar');
INSERT INTO Proveedores (nombre_proveedor, direccion, mail) VALUES ('Proveedor Tech 7 S.A.', 'Calle Proveedor 700', 'contacto@proveedortech7.com.ar');
INSERT INTO Proveedores (nombre_proveedor, direccion, mail) VALUES ('Proveedor Tech 8 S.A.', 'Calle Proveedor 800', 'contacto@proveedortech8.com.ar');
INSERT INTO Proveedores (nombre_proveedor, direccion, mail) VALUES ('Proveedor Tech 9 S.A.', 'Calle Proveedor 900', 'contacto@proveedortech9.com.ar');
INSERT INTO Proveedores (nombre_proveedor, direccion, mail) VALUES ('Proveedor Tech 10 S.A.', 'Calle Proveedor 1000', 'contacto@proveedortech10.com.ar');

-- Vendedores
INSERT INTO Vendedor (apellido, nombres, mail, comision) VALUES ('Gomez', 'Juan', 'juan.gomez@ventas.com', 6.27);
INSERT INTO Vendedor (apellido, nombres, mail, comision) VALUES ('Lopez', 'Maria', 'maria.lopez@ventas.com', 5.77);
INSERT INTO Vendedor (apellido, nombres, mail, comision) VALUES ('Perez', 'Pedro', 'pedro.perez@ventas.com', 1.1);
INSERT INTO Vendedor (apellido, nombres, mail, comision) VALUES ('Rodriguez', 'Ana', 'ana.rodriguez@ventas.com', 3.12);
INSERT INTO Vendedor (apellido, nombres, mail, comision) VALUES ('Fernandez', 'Luis', 'luis.fernandez@ventas.com', 3.09);
INSERT INTO Vendedor (apellido, nombres, mail, comision) VALUES ('Garcia', 'Laura', 'laura.garcia@ventas.com', 2.03);
INSERT INTO Vendedor (apellido, nombres, mail, comision) VALUES ('Martinez', 'Carlos', 'carlos.martinez@ventas.com', 3.56);
INSERT INTO Vendedor (apellido, nombres, mail, comision) VALUES ('Sanchez', 'Marta', 'marta.sanchez@ventas.com', 1.17);
INSERT INTO Vendedor (apellido, nombres, mail, comision) VALUES ('Romero', 'Diego', 'diego.romero@ventas.com', 13.22);
INSERT INTO Vendedor (apellido, nombres, mail, comision) VALUES ('Sosa', 'Sofia', 'sofia.sosa@ventas.com', 9.91);

-- Clientes
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Castro', 'Camila', 'Av. Cliente 10, CABA', 'cliente1_camilacastro@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Gimenez', 'Micaela', 'Av. Cliente 20, CABA', 'cliente2_micaelagimenez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Suarez', 'Lucia', 'Av. Cliente 30, CABA', 'cliente3_luciasuarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Ruiz', 'Micaela', 'Av. Cliente 40, CABA', 'cliente4_micaelaruiz@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Vargas', 'Julieta', 'Av. Cliente 50, CABA', 'cliente5_julietavargas@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Torres', 'Jorge', 'Av. Cliente 60, CABA', 'cliente6_jorgetorres@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Diaz', 'Nicolas', 'Av. Cliente 70, CABA', 'cliente7_nicolasdiaz@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Ramos', 'Facundo', 'Av. Cliente 80, CABA', 'cliente8_facundoramos@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Torres', 'Camila', 'Av. Cliente 90, CABA', 'cliente9_camilatorres@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Dominguez', 'Lucia', 'Av. Cliente 100, CABA', 'cliente10_luciadominguez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Dominguez', 'Jorge', 'Av. Cliente 110, CABA', 'cliente11_jorgedominguez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Ruiz', 'Camila', 'Av. Cliente 120, CABA', 'cliente12_camilaruiz@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Dominguez', 'Matias', 'Av. Cliente 130, CABA', 'cliente13_matiasdominguez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Alvarez', 'Jorge', 'Av. Cliente 140, CABA', 'cliente14_jorgealvarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Alvarez', 'Facundo', 'Av. Cliente 150, CABA', 'cliente15_facundoalvarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Suarez', 'Matias', 'Av. Cliente 160, CABA', 'cliente16_matiassuarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Torres', 'Camila', 'Av. Cliente 170, CABA', 'cliente17_camilatorres@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Torres', 'Matias', 'Av. Cliente 180, CABA', 'cliente18_matiastorres@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Ruiz', 'Jorge', 'Av. Cliente 190, CABA', 'cliente19_jorgeruiz@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Torres', 'Lucia', 'Av. Cliente 200, CABA', 'cliente20_luciatorres@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Dominguez', 'Nicolas', 'Av. Cliente 210, CABA', 'cliente21_nicolasdominguez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Gimenez', 'Matias', 'Av. Cliente 220, CABA', 'cliente22_matiasgimenez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Suarez', 'Julieta', 'Av. Cliente 230, CABA', 'cliente23_julietasuarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Ramos', 'Julieta', 'Av. Cliente 240, CABA', 'cliente24_julietaramos@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Diaz', 'Jorge', 'Av. Cliente 250, CABA', 'cliente25_jorgediaz@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Castro', 'Julieta', 'Av. Cliente 260, CABA', 'cliente26_julietacastro@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Alvarez', 'Julieta', 'Av. Cliente 270, CABA', 'cliente27_julietaalvarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Ruiz', 'Valentina', 'Av. Cliente 280, CABA', 'cliente28_valentinaruiz@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Gimenez', 'Julieta', 'Av. Cliente 290, CABA', 'cliente29_julietagimenez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Ruiz', 'Jorge', 'Av. Cliente 300, CABA', 'cliente30_jorgeruiz@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Diaz', 'Julieta', 'Av. Cliente 310, CABA', 'cliente31_julietadiaz@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Ramos', 'Lucia', 'Av. Cliente 320, CABA', 'cliente32_luciaramos@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Alvarez', 'Valentina', 'Av. Cliente 330, CABA', 'cliente33_valentinaalvarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Suarez', 'Lucia', 'Av. Cliente 340, CABA', 'cliente34_luciasuarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Diaz', 'Marcos', 'Av. Cliente 350, CABA', 'cliente35_marcosdiaz@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Suarez', 'Julieta', 'Av. Cliente 360, CABA', 'cliente36_julietasuarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Suarez', 'Camila', 'Av. Cliente 370, CABA', 'cliente37_camilasuarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Dominguez', 'Camila', 'Av. Cliente 380, CABA', 'cliente38_camiladominguez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Ramos', 'Valentina', 'Av. Cliente 390, CABA', 'cliente39_valentinaramos@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Gimenez', 'Nicolas', 'Av. Cliente 400, CABA', 'cliente40_nicolasgimenez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Castro', 'Valentina', 'Av. Cliente 410, CABA', 'cliente41_valentinacastro@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Ruiz', 'Marcos', 'Av. Cliente 420, CABA', 'cliente42_marcosruiz@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Ruiz', 'Julieta', 'Av. Cliente 430, CABA', 'cliente43_julietaruiz@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Suarez', 'Matias', 'Av. Cliente 440, CABA', 'cliente44_matiassuarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Castro', 'Marcos', 'Av. Cliente 450, CABA', 'cliente45_marcoscastro@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Suarez', 'Julieta', 'Av. Cliente 460, CABA', 'cliente46_julietasuarez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Vargas', 'Jorge', 'Av. Cliente 470, CABA', 'cliente47_jorgevargas@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Dominguez', 'Facundo', 'Av. Cliente 480, CABA', 'cliente48_facundodominguez@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Torres', 'Lucia', 'Av. Cliente 490, CABA', 'cliente49_luciatorres@ejemplo.com');
INSERT INTO Clientes (apellido, nombres, direccion, mail) VALUES ('Gimenez', 'Nicolas', 'Av. Cliente 500, CABA', 'cliente50_nicolasgimenez@ejemplo.com');

-- Productos
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Teclado Modelo 155 - Version Lite', 727604.87, 18, 142, 8, 5, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Teclado Modelo 882 - Version Gaming', 1346706.72, 59, 60, 6, 1, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 213 - Version Pro', 904886.74, 59, 91, 14, 3, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Notebook Modelo 876 - Version Office', 380968.39, 12, 86, 8, 5, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Notebook Modelo 246 - Version Office', 96616.34, 49, 75, 14, 10, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 606 - Version Lite', 210079.68, 91, 141, 11, 3, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Notebook Modelo 153 - Version Office', 1342984.06, 20, 133, 8, 5, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 238 - Version Gaming', 723305.02, 19, 112, 18, 7, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Disco Solido SSD Modelo 450 - Version Lite', 501397.02, 40, 70, 10, 3, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Placa de Video Modelo 565 - Version Office', 873944.93, 66, 96, 12, 9, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Monitor Modelo 415 - Version Office', 1358481.52, 110, 133, 10, 7, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Placa de Video Modelo 423 - Version Office', 180545.8, 31, 65, 18, 9, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 225 - Version Gaming', 1110846.25, 83, 191, 20, 2, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 973 - Version Gaming', 175477.37, 22, 91, 18, 8, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Gabinete Modelo 747 - Version Pro', 1172200.75, 29, 70, 12, 8, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 131 - Version Pro', 1004360.19, 13, 126, 8, 6, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Placa de Video Modelo 109 - Version Lite', 414416.6, 139, 184, 12, 2, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Monitor Modelo 381 - Version Office', 1298037.07, 81, 163, 5, 5, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Gabinete Modelo 103 - Version Office', 27101.7, 12, 173, 10, 3, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 495 - Version Gaming', 1315858.01, 92, 183, 9, 6, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Mouse Modelo 339 - Version Gaming', 123979.31, 36, 191, 9, 4, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Mouse Modelo 239 - Version Lite', 1427444.27, 74, 116, 11, 3, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Gabinete Modelo 661 - Version Office', 1484700.7, 169, 171, 9, 5, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Gabinete Modelo 206 - Version Lite', 500574.83, 92, 127, 17, 9, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Monitor Modelo 141 - Version Gaming', 363501.38, 52, 163, 15, 6, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Disco Solido SSD Modelo 342 - Version Gaming', 1481837.84, 63, 163, 20, 2, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Mouse Modelo 689 - Version Office', 652897.2, 50, 192, 8, 8, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Teclado Modelo 635 - Version Gaming', 482954.01, 103, 124, 7, 3, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Teclado Modelo 183 - Version Pro', 1187356.67, 42, 58, 20, 4, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Notebook Modelo 575 - Version Office', 1041128.34, 54, 146, 14, 7, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Disco Solido SSD Modelo 439 - Version Lite', 494968.52, 169, 189, 7, 1, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Auriculares Modelo 917 - Version Gaming', 846165.64, 58, 68, 20, 2, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Placa de Video Modelo 172 - Version Gaming', 388282.85, 113, 117, 14, 8, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Auriculares Modelo 680 - Version Pro', 437527.23, 61, 200, 13, 7, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Notebook Modelo 230 - Version Lite', 828988.83, 74, 157, 12, 3, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 587 - Version Pro', 926718.07, 27, 60, 9, 4, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Gabinete Modelo 859 - Version Gaming', 1232179.1, 74, 169, 5, 4, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 452 - Version Lite', 640128.85, 86, 98, 9, 5, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Disco Solido SSD Modelo 318 - Version Pro', 489243.02, 78, 136, 12, 3, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 265 - Version Pro', 805910.34, 11, 116, 10, 6, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Notebook Modelo 992 - Version Gaming', 1450086.11, 35, 108, 18, 7, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Auriculares Modelo 570 - Version Lite', 1081683.97, 72, 85, 7, 3, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Monitor Modelo 258 - Version Gaming', 322210.88, 26, 56, 9, 7, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Auriculares Modelo 842 - Version Pro', 1010593.48, 63, 170, 5, 7, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Teclado Modelo 441 - Version Gaming', 31736.58, 64, 94, 20, 8, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Auriculares Modelo 251 - Version Office', 664546.06, 51, 89, 5, 5, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 364 - Version Office', 799415.11, 78, 135, 10, 3, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Placa de Video Modelo 331 - Version Pro', 226235.69, 11, 60, 8, 6, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Disco Solido SSD Modelo 228 - Version Office', 952970.52, 70, 94, 19, 4, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 426 - Version Lite', 584763.95, 111, 148, 11, 1, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Teclado Modelo 632 - Version Pro', 1091150.53, 36, 63, 20, 8, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 998 - Version Lite', 415742.74, 49, 136, 9, 10, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Disco Solido SSD Modelo 110 - Version Pro', 781317.73, 107, 133, 9, 8, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Teclado Modelo 825 - Version Gaming', 308443.58, 66, 149, 9, 3, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 325 - Version Gaming', 876305.76, 69, 141, 6, 3, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 830 - Version Office', 734297.48, 14, 126, 9, 4, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Monitor Modelo 477 - Version Lite', 645200.0, 173, 192, 15, 3, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Auriculares Modelo 417 - Version Gaming', 201803.04, 36, 73, 20, 3, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Monitor Modelo 577 - Version Gaming', 1060026.05, 28, 134, 14, 9, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 429 - Version Lite', 154382.97, 153, 200, 12, 10, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 654 - Version Pro', 665492.7, 10, 77, 9, 10, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Mouse Modelo 854 - Version Lite', 444280.83, 26, 185, 9, 2, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Monitor Modelo 465 - Version Office', 117883.28, 25, 116, 9, 6, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Mouse Modelo 247 - Version Office', 831532.73, 50, 187, 17, 10, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Monitor Modelo 292 - Version Gaming', 113945.43, 41, 76, 13, 7, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Placa de Video Modelo 901 - Version Office', 925959.18, 126, 149, 20, 8, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 943 - Version Lite', 693863.71, 39, 56, 19, 5, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 707 - Version Pro', 1400702.71, 90, 115, 12, 5, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Auriculares Modelo 160 - Version Lite', 301913.64, 40, 103, 15, 3, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Monitor Modelo 899 - Version Office', 39550.82, 95, 184, 18, 8, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 866 - Version Office', 53999.87, 170, 199, 10, 7, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Teclado Modelo 595 - Version Office', 1191409.72, 125, 131, 20, 4, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Teclado Modelo 988 - Version Office', 727683.14, 111, 117, 8, 1, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 343 - Version Office', 1481957.69, 63, 69, 17, 5, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Disco Solido SSD Modelo 104 - Version Office', 1206503.39, 72, 93, 10, 2, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Notebook Modelo 715 - Version Pro', 1287952.58, 75, 186, 7, 10, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Teclado Modelo 526 - Version Office', 677243.44, 106, 118, 5, 5, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Gabinete Modelo 662 - Version Lite', 796310.24, 137, 138, 20, 8, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 270 - Version Office', 239399.3, 35, 111, 16, 7, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Placa de Video Modelo 865 - Version Lite', 1432810.73, 44, 68, 9, 5, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 135 - Version Pro', 1442832.21, 18, 111, 16, 10, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Gabinete Modelo 867 - Version Lite', 625409.72, 33, 71, 13, 10, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Monitor Modelo 328 - Version Lite', 565907.32, 74, 127, 5, 5, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Mouse Modelo 655 - Version Office', 1440536.54, 29, 113, 6, 10, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 292 - Version Lite', 798597.74, 161, 165, 18, 9, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 320 - Version Office', 1172486.49, 32, 154, 17, 2, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 413 - Version Office', 558808.49, 31, 87, 14, 3, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 255 - Version Pro', 970229.49, 41, 177, 11, 1, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 842 - Version Pro', 724847.83, 143, 147, 11, 7, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Disco Solido SSD Modelo 448 - Version Pro', 1071712.42, 50, 103, 16, 3, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Fuente Modelo 580 - Version Lite', 230575.61, 86, 94, 9, 1, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Mouse Modelo 845 - Version Lite', 860052.43, 143, 166, 6, 9, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Disco Solido SSD Modelo 682 - Version Pro', 698419.33, 124, 182, 20, 2, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Placa de Video Modelo 673 - Version Pro', 915926.67, 118, 173, 10, 10, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Teclado Modelo 853 - Version Pro', 994843.86, 135, 182, 5, 9, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Placa de Video Modelo 500 - Version Gaming', 1403398.38, 61, 166, 13, 4, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 585 - Version Gaming', 156078.58, 48, 117, 16, 1, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Memoria RAM Modelo 651 - Version Office', 81097.65, 136, 155, 20, 3, 'Nacional');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Disco Solido SSD Modelo 993 - Version Lite', 448917.78, 42, 186, 7, 2, 'Importado');
INSERT INTO Productos (descripcion, precio_unitario, stock, stock_max, stock_min, idproveedor, origen) VALUES ('Monitor Modelo 891 - Version Lite', 201489.82, 162, 180, 9, 1, 'Importado');

-- Pedidos
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (10, 7, '2023-10-21', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (48, 2, '2023-12-17', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (50, 6, '2023-12-14', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (24, 3, '2023-12-09', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (3, 10, '2023-11-23', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (23, 1, '2023-12-10', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (14, 7, '2023-08-20', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (21, 2, '2024-01-27', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (18, 6, '2023-10-16', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (41, 5, '2024-01-06', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (48, 3, '2023-10-27', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (6, 3, '2024-06-27', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (13, 4, '2023-09-22', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (36, 5, '2024-04-16', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (37, 1, '2023-09-04', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (23, 5, '2023-11-24', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (18, 8, '2024-02-07', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (4, 9, '2023-10-04', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (5, 9, '2024-03-13', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (29, 3, '2024-03-26', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (3, 5, '2024-06-25', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (45, 2, '2024-04-29', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (6, 8, '2023-09-29', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (44, 3, '2023-11-26', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (49, 1, '2024-03-06', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (24, 7, '2024-05-06', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (34, 9, '2024-06-15', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (11, 5, '2023-09-24', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (3, 7, '2024-03-06', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (29, 3, '2023-12-22', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (44, 6, '2023-09-30', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (18, 4, '2023-10-25', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (21, 3, '2023-08-27', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (38, 4, '2023-09-30', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (26, 9, '2024-05-11', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (8, 8, '2023-12-07', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (5, 3, '2024-03-29', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (24, 4, '2024-04-26', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (49, 9, '2023-11-18', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (14, 1, '2023-10-08', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (43, 8, '2024-01-03', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (25, 4, '2023-08-14', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (1, 9, '2024-01-31', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (48, 10, '2023-11-12', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (10, 4, '2023-12-26', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (36, 5, '2024-06-06', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (47, 7, '2023-09-27', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (6, 2, '2024-01-07', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (22, 6, '2023-11-29', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (32, 10, '2023-08-16', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (23, 2, '2024-03-30', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (8, 1, '2023-09-11', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (31, 3, '2024-04-25', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (3, 9, '2024-03-28', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (6, 8, '2023-11-07', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (9, 4, '2023-08-20', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (31, 2, '2024-01-27', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (29, 10, '2023-08-29', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (7, 8, '2023-08-27', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (3, 2, '2024-05-17', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (23, 1, '2024-05-30', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (24, 5, '2023-09-19', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (40, 10, '2024-07-26', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (20, 2, '2024-01-22', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (37, 7, '2024-07-19', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (29, 5, '2024-05-21', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (26, 6, '2023-09-23', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (21, 6, '2024-02-07', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (8, 6, '2024-01-11', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (36, 3, '2024-07-17', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (15, 8, '2023-11-28', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (15, 9, '2024-06-04', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (5, 2, '2024-02-22', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (35, 8, '2024-02-22', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (31, 1, '2023-10-14', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (42, 10, '2024-07-10', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (28, 6, '2023-10-06', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (45, 1, '2024-01-26', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (37, 4, '2024-05-20', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (33, 9, '2024-02-13', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (15, 4, '2023-08-03', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (41, 8, '2024-03-23', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (21, 3, '2023-10-07', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (34, 7, '2023-12-15', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (16, 5, '2024-04-05', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (25, 8, '2024-05-04', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (33, 9, '2024-06-28', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (35, 3, '2023-12-17', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (45, 8, '2024-02-10', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (47, 2, '2023-10-06', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (37, 7, '2023-11-08', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (44, 7, '2023-10-17', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (48, 5, '2024-02-17', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (41, 7, '2024-04-05', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (37, 10, '2023-09-02', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (3, 1, '2024-03-14', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (25, 2, '2023-12-26', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (3, 3, '2023-12-03', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (7, 4, '2024-01-22', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (27, 8, '2024-01-03', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (25, 5, '2024-06-09', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (37, 10, '2024-07-24', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (29, 8, '2023-11-13', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (4, 5, '2024-03-07', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (31, 2, '2024-01-13', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (34, 5, '2024-04-08', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (5, 7, '2023-12-19', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (31, 10, '2023-09-19', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (16, 8, '2023-12-31', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (1, 4, '2024-06-20', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (21, 4, '2024-02-26', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (13, 4, '2024-04-10', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (48, 4, '2024-04-11', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (49, 10, '2023-11-07', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (16, 5, '2024-06-07', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (44, 1, '2024-03-22', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (21, 1, '2024-01-05', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (11, 1, '2023-11-23', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (19, 4, '2023-08-15', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (46, 6, '2023-08-16', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (30, 7, '2023-11-13', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (2, 4, '2023-08-07', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (16, 10, '2023-08-01', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (6, 10, '2024-02-16', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (17, 6, '2024-05-22', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (14, 2, '2023-10-26', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (6, 1, '2024-01-09', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (8, 8, '2023-10-31', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (24, 3, '2024-06-28', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (46, 1, '2023-09-13', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (28, 8, '2024-07-20', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (20, 3, '2023-12-25', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (17, 9, '2024-01-11', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (39, 6, '2024-03-19', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (33, 8, '2023-09-15', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (33, 6, '2023-12-24', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (39, 4, '2024-05-26', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (19, 1, '2024-04-17', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (16, 2, '2024-05-07', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (14, 7, '2024-02-09', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (42, 10, '2023-08-14', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (17, 2, '2023-09-20', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (9, 8, '2023-09-29', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (12, 2, '2023-10-03', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (26, 2, '2024-01-20', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (1, 5, '2023-09-28', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (25, 3, '2024-04-14', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (7, 1, '2024-06-28', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (40, 7, '2023-08-27', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (18, 5, '2024-02-02', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (23, 4, '2024-03-25', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (1, 8, '2024-03-30', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (24, 7, '2023-12-28', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (13, 7, '2024-06-30', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (46, 1, '2024-02-03', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (2, 2, '2024-06-29', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (6, 7, '2024-07-26', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (7, 4, '2024-04-17', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (15, 3, '2024-01-17', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (21, 8, '2023-12-26', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (9, 8, '2024-04-15', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (16, 2, '2024-01-31', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (41, 6, '2024-07-07', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (27, 6, '2023-11-29', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (28, 5, '2023-08-10', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (11, 2, '2023-09-20', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (25, 4, '2024-06-25', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (41, 3, '2023-11-26', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (16, 9, '2024-02-24', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (38, 3, '2024-05-09', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (47, 7, '2023-10-21', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (49, 8, '2024-01-01', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (34, 8, '2023-12-11', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (29, 1, '2024-06-13', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (23, 7, '2023-12-03', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (42, 9, '2023-10-01', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (19, 6, '2023-08-29', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (37, 10, '2024-07-30', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (2, 7, '2024-04-22', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (32, 1, '2023-09-20', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (26, 6, '2024-02-11', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (39, 9, '2024-05-08', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (42, 9, '2023-09-29', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (34, 4, '2024-06-09', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (21, 5, '2024-02-07', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (19, 7, '2024-07-09', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (36, 9, '2024-02-02', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (30, 2, '2023-10-10', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (45, 8, '2024-06-15', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (2, 7, '2023-10-16', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (50, 8, '2024-07-02', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (3, 3, '2023-11-28', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (10, 3, '2023-09-12', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (2, 3, '2024-03-09', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (2, 7, '2024-06-27', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (18, 10, '2023-10-10', 'ANULADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (8, 8, '2023-08-03', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (28, 3, '2023-10-12', 'PENDIENTE');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (43, 5, '2023-11-08', 'CONFIRMADO');
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (34, 7, '2023-09-09', 'ANULADO');

-- Detalle_Pedidos
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (1, 1, 56, 1, 734297.48, 734297.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (1, 2, 4, 3, 380968.39, 1142905.17);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (1, 3, 8, 3, 723305.02, 2169915.06);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (1, 4, 85, 3, 798597.74, 2395793.22);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (2, 1, 80, 5, 1432810.73, 7164053.65);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (2, 2, 81, 4, 1442832.21, 5771328.84);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (2, 3, 49, 5, 952970.52, 4764852.6);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (2, 4, 54, 2, 308443.58, 616887.16);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (3, 1, 70, 5, 39550.82, 197754.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (4, 1, 91, 2, 230575.61, 461151.22);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (4, 2, 27, 5, 652897.2, 3264486.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (4, 3, 71, 4, 53999.87, 215999.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (5, 1, 28, 3, 482954.01, 1448862.03);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (6, 1, 58, 1, 201803.04, 201803.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (7, 1, 76, 5, 1287952.58, 6439762.9);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (7, 2, 39, 4, 489243.02, 1956972.08);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (8, 1, 71, 5, 53999.87, 269999.35);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (8, 2, 91, 1, 230575.61, 230575.61);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (9, 1, 20, 4, 1315858.01, 5263432.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (9, 2, 74, 3, 1481957.69, 4445873.07);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (9, 3, 46, 3, 664546.06, 1993638.18);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (9, 4, 44, 1, 1010593.48, 1010593.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (10, 1, 31, 5, 494968.52, 2474842.6);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (10, 2, 72, 4, 1191409.72, 4765638.88);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (11, 1, 27, 5, 652897.2, 3264486.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (11, 2, 55, 3, 876305.76, 2628917.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (12, 1, 89, 5, 724847.83, 3624239.15);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (12, 2, 42, 3, 1081683.97, 3245051.91);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (12, 3, 16, 5, 1004360.19, 5021800.95);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (13, 1, 74, 4, 1481957.69, 5927830.76);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (13, 2, 63, 5, 117883.28, 589416.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (13, 3, 46, 1, 664546.06, 664546.06);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (13, 4, 88, 1, 970229.49, 970229.49);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (14, 1, 87, 3, 558808.49, 1676425.47);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (15, 1, 83, 1, 565907.32, 565907.32);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (15, 2, 90, 4, 1071712.42, 4286849.68);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (15, 3, 51, 4, 1091150.53, 4364602.12);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (16, 1, 92, 1, 860052.43, 860052.43);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (17, 1, 95, 1, 994843.86, 994843.86);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (17, 2, 6, 3, 210079.68, 630239.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (17, 3, 16, 3, 1004360.19, 3013080.57);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (18, 1, 50, 3, 584763.95, 1754291.85);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (18, 2, 4, 4, 380968.39, 1523873.56);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (19, 1, 21, 5, 123979.31, 619896.55);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (20, 1, 36, 4, 926718.07, 3706872.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (20, 2, 53, 1, 781317.73, 781317.73);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (21, 1, 57, 2, 645200.0, 1290400.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (21, 2, 88, 1, 970229.49, 970229.49);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (21, 3, 36, 4, 926718.07, 3706872.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (21, 4, 54, 3, 308443.58, 925330.74);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (22, 1, 61, 1, 665492.7, 665492.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (22, 2, 75, 2, 1206503.39, 2413006.78);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (22, 3, 67, 1, 693863.71, 693863.71);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (23, 1, 84, 2, 1440536.54, 2881073.08);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (23, 2, 32, 5, 846165.64, 4230828.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (23, 3, 99, 4, 448917.78, 1795671.12);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (24, 1, 23, 2, 1484700.7, 2969401.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (24, 2, 29, 5, 1187356.67, 5936783.35);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (24, 3, 92, 2, 860052.43, 1720104.86);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (25, 1, 87, 4, 558808.49, 2235233.96);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (25, 2, 45, 1, 31736.58, 31736.58);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (25, 3, 50, 4, 584763.95, 2339055.8);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (25, 4, 38, 1, 640128.85, 640128.85);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (26, 1, 6, 4, 210079.68, 840318.72);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (26, 2, 27, 4, 652897.2, 2611588.8);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (27, 1, 62, 1, 444280.83, 444280.83);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (27, 2, 51, 5, 1091150.53, 5455752.65);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (27, 3, 57, 4, 645200.0, 2580800.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (27, 4, 71, 5, 53999.87, 269999.35);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (28, 1, 42, 2, 1081683.97, 2163367.94);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (28, 2, 96, 3, 1403398.38, 4210195.14);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (28, 3, 77, 1, 677243.44, 677243.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (29, 1, 68, 2, 1400702.71, 2801405.42);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (29, 2, 57, 3, 645200.0, 1935600.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (29, 3, 83, 3, 565907.32, 1697721.96);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (29, 4, 46, 2, 664546.06, 1329092.12);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (30, 1, 77, 3, 677243.44, 2031730.32);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (30, 2, 82, 2, 625409.72, 1250819.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (30, 3, 100, 4, 201489.82, 805959.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (30, 4, 88, 4, 970229.49, 3880917.96);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (31, 1, 16, 3, 1004360.19, 3013080.57);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (31, 2, 70, 5, 39550.82, 197754.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (31, 3, 38, 1, 640128.85, 640128.85);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (31, 4, 56, 5, 734297.48, 3671487.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (32, 1, 74, 5, 1481957.69, 7409788.45);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (32, 2, 44, 5, 1010593.48, 5052967.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (32, 3, 21, 5, 123979.31, 619896.55);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (33, 1, 84, 2, 1440536.54, 2881073.08);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (33, 2, 98, 4, 81097.65, 324390.6);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (33, 3, 99, 2, 448917.78, 897835.56);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (34, 1, 6, 4, 210079.68, 840318.72);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (34, 2, 39, 5, 489243.02, 2446215.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (34, 3, 86, 5, 1172486.49, 5862432.45);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (34, 4, 63, 4, 117883.28, 471533.12);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (35, 1, 39, 2, 489243.02, 978486.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (35, 2, 24, 5, 500574.83, 2502874.15);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (36, 1, 68, 4, 1400702.71, 5602810.84);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (36, 2, 90, 2, 1071712.42, 2143424.84);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (36, 3, 40, 4, 805910.34, 3223641.36);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (36, 4, 78, 5, 796310.24, 3981551.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (37, 1, 88, 5, 970229.49, 4851147.45);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (37, 2, 76, 5, 1287952.58, 6439762.9);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (37, 3, 62, 1, 444280.83, 444280.83);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (38, 1, 93, 1, 698419.33, 698419.33);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (39, 1, 95, 4, 994843.86, 3979375.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (39, 2, 1, 3, 727604.87, 2182814.61);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (40, 1, 53, 3, 781317.73, 2343953.19);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (40, 2, 88, 4, 970229.49, 3880917.96);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (40, 3, 58, 3, 201803.04, 605409.12);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (41, 1, 34, 2, 437527.23, 875054.46);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (41, 2, 4, 3, 380968.39, 1142905.17);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (42, 1, 28, 4, 482954.01, 1931816.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (43, 1, 59, 2, 1060026.05, 2120052.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (43, 2, 51, 4, 1091150.53, 4364602.12);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (43, 3, 44, 3, 1010593.48, 3031780.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (43, 4, 50, 5, 584763.95, 2923819.75);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (44, 1, 99, 1, 448917.78, 448917.78);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (44, 2, 41, 4, 1450086.11, 5800344.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (44, 3, 92, 2, 860052.43, 1720104.86);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (44, 4, 100, 4, 201489.82, 805959.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (45, 1, 68, 1, 1400702.71, 1400702.71);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (45, 2, 23, 4, 1484700.7, 5938802.8);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (45, 3, 54, 3, 308443.58, 925330.74);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (45, 4, 35, 1, 828988.83, 828988.83);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (46, 1, 16, 4, 1004360.19, 4017440.76);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (47, 1, 72, 1, 1191409.72, 1191409.72);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (47, 2, 6, 2, 210079.68, 420159.36);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (48, 1, 35, 2, 828988.83, 1657977.66);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (48, 2, 89, 2, 724847.83, 1449695.66);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (48, 3, 59, 1, 1060026.05, 1060026.05);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (48, 4, 80, 5, 1432810.73, 7164053.65);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (49, 1, 86, 5, 1172486.49, 5862432.45);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (49, 2, 89, 3, 724847.83, 2174543.49);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (49, 3, 32, 5, 846165.64, 4230828.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (50, 1, 77, 4, 677243.44, 2708973.76);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (50, 2, 62, 2, 444280.83, 888561.66);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (50, 3, 9, 3, 501397.02, 1504191.06);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (51, 1, 71, 4, 53999.87, 215999.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (52, 1, 39, 4, 489243.02, 1956972.08);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (53, 1, 38, 5, 640128.85, 3200644.25);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (53, 2, 50, 4, 584763.95, 2339055.8);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (54, 1, 89, 5, 724847.83, 3624239.15);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (54, 2, 60, 2, 154382.97, 308765.94);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (54, 3, 51, 5, 1091150.53, 5455752.65);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (54, 4, 16, 1, 1004360.19, 1004360.19);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (55, 1, 85, 1, 798597.74, 798597.74);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (55, 2, 27, 1, 652897.2, 652897.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (55, 3, 2, 5, 1346706.72, 6733533.6);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (55, 4, 53, 5, 781317.73, 3906588.65);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (56, 1, 26, 3, 1481837.84, 4445513.52);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (57, 1, 10, 5, 873944.93, 4369724.65);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (57, 2, 66, 4, 925959.18, 3703836.72);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (57, 3, 89, 1, 724847.83, 724847.83);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (58, 1, 41, 2, 1450086.11, 2900172.22);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (58, 2, 33, 2, 388282.85, 776565.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (58, 3, 76, 4, 1287952.58, 5151810.32);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (58, 4, 82, 2, 625409.72, 1250819.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (59, 1, 13, 2, 1110846.25, 2221692.5);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (59, 2, 8, 2, 723305.02, 1446610.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (60, 1, 10, 2, 873944.93, 1747889.86);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (60, 2, 82, 2, 625409.72, 1250819.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (61, 1, 81, 2, 1442832.21, 2885664.42);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (61, 2, 36, 1, 926718.07, 926718.07);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (61, 3, 40, 4, 805910.34, 3223641.36);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (61, 4, 80, 4, 1432810.73, 5731242.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (62, 1, 52, 1, 415742.74, 415742.74);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (63, 1, 21, 3, 123979.31, 371937.93);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (63, 2, 73, 5, 727683.14, 3638415.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (63, 3, 71, 3, 53999.87, 161999.61);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (64, 1, 86, 4, 1172486.49, 4689945.96);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (64, 2, 46, 1, 664546.06, 664546.06);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (65, 1, 37, 5, 1232179.1, 6160895.5);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (65, 2, 34, 4, 437527.23, 1750108.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (65, 3, 3, 1, 904886.74, 904886.74);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (66, 1, 9, 5, 501397.02, 2506985.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (66, 2, 30, 2, 1041128.34, 2082256.68);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (66, 3, 87, 4, 558808.49, 2235233.96);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (66, 4, 18, 1, 1298037.07, 1298037.07);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (67, 1, 94, 4, 915926.67, 3663706.68);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (67, 2, 75, 3, 1206503.39, 3619510.17);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (67, 3, 44, 5, 1010593.48, 5052967.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (68, 1, 43, 4, 322210.88, 1288843.52);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (68, 2, 38, 4, 640128.85, 2560515.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (68, 3, 18, 4, 1298037.07, 5192148.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (68, 4, 66, 4, 925959.18, 3703836.72);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (69, 1, 55, 5, 876305.76, 4381528.8);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (69, 2, 72, 5, 1191409.72, 5957048.6);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (70, 1, 65, 3, 113945.43, 341836.29);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (70, 2, 34, 4, 437527.23, 1750108.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (70, 3, 49, 4, 952970.52, 3811882.08);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (71, 1, 40, 1, 805910.34, 805910.34);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (71, 2, 61, 4, 665492.7, 2661970.8);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (71, 3, 35, 5, 828988.83, 4144944.15);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (72, 1, 3, 2, 904886.74, 1809773.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (72, 2, 79, 4, 239399.3, 957597.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (72, 3, 56, 4, 734297.48, 2937189.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (72, 4, 20, 5, 1315858.01, 6579290.05);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (73, 1, 53, 5, 781317.73, 3906588.65);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (73, 2, 1, 3, 727604.87, 2182814.61);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (73, 3, 59, 5, 1060026.05, 5300130.25);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (73, 4, 68, 5, 1400702.71, 7003513.55);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (74, 1, 93, 5, 698419.33, 3492096.65);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (74, 2, 78, 5, 796310.24, 3981551.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (74, 3, 53, 1, 781317.73, 781317.73);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (74, 4, 42, 4, 1081683.97, 4326735.88);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (75, 1, 37, 4, 1232179.1, 4928716.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (75, 2, 44, 4, 1010593.48, 4042373.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (75, 3, 19, 3, 27101.7, 81305.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (76, 1, 47, 4, 799415.11, 3197660.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (76, 2, 40, 3, 805910.34, 2417731.02);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (76, 3, 25, 1, 363501.38, 363501.38);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (77, 1, 89, 1, 724847.83, 724847.83);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (77, 2, 70, 5, 39550.82, 197754.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (77, 3, 5, 5, 96616.34, 483081.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (77, 4, 4, 1, 380968.39, 380968.39);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (78, 1, 67, 5, 693863.71, 3469318.55);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (79, 1, 32, 3, 846165.64, 2538496.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (80, 1, 23, 3, 1484700.7, 4454102.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (80, 2, 63, 5, 117883.28, 589416.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (81, 1, 97, 2, 156078.58, 312157.16);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (81, 2, 33, 4, 388282.85, 1553131.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (82, 1, 30, 5, 1041128.34, 5205641.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (82, 2, 37, 3, 1232179.1, 3696537.3);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (82, 3, 17, 5, 414416.6, 2072083.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (83, 1, 24, 3, 500574.83, 1501724.49);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (83, 2, 91, 3, 230575.61, 691726.83);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (83, 3, 80, 3, 1432810.73, 4298432.19);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (84, 1, 70, 5, 39550.82, 197754.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (85, 1, 97, 1, 156078.58, 156078.58);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (85, 2, 80, 1, 1432810.73, 1432810.73);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (86, 1, 46, 3, 664546.06, 1993638.18);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (86, 2, 80, 5, 1432810.73, 7164053.65);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (87, 1, 81, 3, 1442832.21, 4328496.63);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (87, 2, 42, 1, 1081683.97, 1081683.97);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (87, 3, 74, 3, 1481957.69, 4445873.07);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (87, 4, 19, 2, 27101.7, 54203.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (88, 1, 37, 1, 1232179.1, 1232179.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (89, 1, 26, 5, 1481837.84, 7409189.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (90, 1, 80, 1, 1432810.73, 1432810.73);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (90, 2, 30, 1, 1041128.34, 1041128.34);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (90, 3, 81, 4, 1442832.21, 5771328.84);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (90, 4, 16, 4, 1004360.19, 4017440.76);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (91, 1, 91, 5, 230575.61, 1152878.05);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (91, 2, 40, 5, 805910.34, 4029551.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (92, 1, 69, 4, 301913.64, 1207654.56);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (92, 2, 62, 2, 444280.83, 888561.66);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (92, 3, 82, 4, 625409.72, 2501638.88);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (92, 4, 99, 3, 448917.78, 1346753.34);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (93, 1, 24, 1, 500574.83, 500574.83);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (93, 2, 92, 5, 860052.43, 4300262.15);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (93, 3, 16, 5, 1004360.19, 5021800.95);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (93, 4, 97, 3, 156078.58, 468235.74);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (94, 1, 34, 3, 437527.23, 1312581.69);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (95, 1, 19, 4, 27101.7, 108406.8);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (95, 2, 77, 4, 677243.44, 2708973.76);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (95, 3, 16, 1, 1004360.19, 1004360.19);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (95, 4, 95, 4, 994843.86, 3979375.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (96, 1, 80, 2, 1432810.73, 2865621.46);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (96, 2, 18, 2, 1298037.07, 2596074.14);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (97, 1, 82, 2, 625409.72, 1250819.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (97, 2, 34, 1, 437527.23, 437527.23);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (98, 1, 18, 1, 1298037.07, 1298037.07);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (98, 2, 34, 3, 437527.23, 1312581.69);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (99, 1, 10, 3, 873944.93, 2621834.79);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (99, 2, 90, 2, 1071712.42, 2143424.84);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (100, 1, 100, 4, 201489.82, 805959.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (100, 2, 5, 1, 96616.34, 96616.34);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (100, 3, 76, 3, 1287952.58, 3863857.74);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (100, 4, 90, 1, 1071712.42, 1071712.42);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (101, 1, 95, 2, 994843.86, 1989687.72);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (101, 2, 78, 3, 796310.24, 2388930.72);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (102, 1, 53, 1, 781317.73, 781317.73);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (102, 2, 45, 2, 31736.58, 63473.16);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (103, 1, 99, 1, 448917.78, 448917.78);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (103, 2, 71, 3, 53999.87, 161999.61);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (103, 3, 82, 3, 625409.72, 1876229.16);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (104, 1, 60, 2, 154382.97, 308765.94);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (104, 2, 16, 5, 1004360.19, 5021800.95);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (105, 1, 5, 3, 96616.34, 289849.02);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (105, 2, 32, 4, 846165.64, 3384662.56);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (105, 3, 49, 4, 952970.52, 3811882.08);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (105, 4, 9, 5, 501397.02, 2506985.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (106, 1, 74, 4, 1481957.69, 5927830.76);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (106, 2, 27, 3, 652897.2, 1958691.6);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (106, 3, 15, 4, 1172200.75, 4688803.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (107, 1, 50, 5, 584763.95, 2923819.75);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (107, 2, 49, 1, 952970.52, 952970.52);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (108, 1, 48, 2, 226235.69, 452471.38);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (108, 2, 32, 4, 846165.64, 3384662.56);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (108, 3, 8, 2, 723305.02, 1446610.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (109, 1, 31, 5, 494968.52, 2474842.6);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (109, 2, 3, 1, 904886.74, 904886.74);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (109, 3, 68, 5, 1400702.71, 7003513.55);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (110, 1, 2, 4, 1346706.72, 5386826.88);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (110, 2, 70, 3, 39550.82, 118652.46);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (110, 3, 28, 2, 482954.01, 965908.02);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (110, 4, 57, 4, 645200.0, 2580800.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (111, 1, 22, 2, 1427444.27, 2854888.54);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (112, 1, 79, 5, 239399.3, 1196996.5);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (113, 1, 56, 2, 734297.48, 1468594.96);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (113, 2, 7, 3, 1342984.06, 4028952.18);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (113, 3, 37, 1, 1232179.1, 1232179.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (113, 4, 67, 3, 693863.71, 2081591.13);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (114, 1, 86, 4, 1172486.49, 4689945.96);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (114, 2, 36, 1, 926718.07, 926718.07);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (114, 3, 64, 1, 831532.73, 831532.73);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (115, 1, 48, 2, 226235.69, 452471.38);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (116, 1, 84, 4, 1440536.54, 5762146.16);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (116, 2, 17, 2, 414416.6, 828833.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (116, 3, 35, 3, 828988.83, 2486966.49);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (117, 1, 46, 1, 664546.06, 664546.06);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (118, 1, 98, 3, 81097.65, 243292.95);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (119, 1, 15, 3, 1172200.75, 3516602.25);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (119, 2, 22, 4, 1427444.27, 5709777.08);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (120, 1, 29, 1, 1187356.67, 1187356.67);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (120, 2, 65, 3, 113945.43, 341836.29);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (120, 3, 42, 2, 1081683.97, 2163367.94);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (121, 1, 52, 2, 415742.74, 831485.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (121, 2, 5, 3, 96616.34, 289849.02);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (121, 3, 6, 5, 210079.68, 1050398.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (121, 4, 72, 1, 1191409.72, 1191409.72);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (122, 1, 40, 1, 805910.34, 805910.34);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (123, 1, 67, 5, 693863.71, 3469318.55);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (123, 2, 57, 5, 645200.0, 3226000.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (123, 3, 82, 3, 625409.72, 1876229.16);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (124, 1, 17, 3, 414416.6, 1243249.8);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (124, 2, 71, 2, 53999.87, 107999.74);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (124, 3, 44, 4, 1010593.48, 4042373.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (124, 4, 93, 5, 698419.33, 3492096.65);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (125, 1, 88, 5, 970229.49, 4851147.45);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (126, 1, 3, 5, 904886.74, 4524433.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (126, 2, 32, 5, 846165.64, 4230828.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (126, 3, 99, 5, 448917.78, 2244588.9);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (126, 4, 33, 2, 388282.85, 776565.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (127, 1, 16, 5, 1004360.19, 5021800.95);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (127, 2, 71, 4, 53999.87, 215999.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (128, 1, 9, 2, 501397.02, 1002794.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (128, 2, 77, 4, 677243.44, 2708973.76);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (129, 1, 39, 5, 489243.02, 2446215.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (129, 2, 91, 4, 230575.61, 922302.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (129, 3, 57, 4, 645200.0, 2580800.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (130, 1, 72, 5, 1191409.72, 5957048.6);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (130, 2, 99, 5, 448917.78, 2244588.9);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (131, 1, 36, 5, 926718.07, 4633590.35);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (131, 2, 18, 4, 1298037.07, 5192148.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (132, 1, 88, 4, 970229.49, 3880917.96);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (133, 1, 60, 5, 154382.97, 771914.85);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (133, 2, 22, 1, 1427444.27, 1427444.27);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (133, 3, 74, 2, 1481957.69, 2963915.38);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (134, 1, 25, 3, 363501.38, 1090504.14);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (135, 1, 96, 2, 1403398.38, 2806796.76);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (135, 2, 44, 4, 1010593.48, 4042373.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (136, 1, 24, 3, 500574.83, 1501724.49);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (136, 2, 47, 3, 799415.11, 2398245.33);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (136, 3, 18, 1, 1298037.07, 1298037.07);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (136, 4, 73, 3, 727683.14, 2183049.42);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (137, 1, 88, 1, 970229.49, 970229.49);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (137, 2, 26, 3, 1481837.84, 4445513.52);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (138, 1, 78, 4, 796310.24, 3185240.96);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (139, 1, 17, 4, 414416.6, 1657666.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (139, 2, 9, 5, 501397.02, 2506985.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (140, 1, 57, 3, 645200.0, 1935600.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (140, 2, 28, 3, 482954.01, 1448862.03);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (141, 1, 76, 2, 1287952.58, 2575905.16);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (141, 2, 33, 1, 388282.85, 388282.85);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (141, 3, 7, 1, 1342984.06, 1342984.06);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (141, 4, 77, 3, 677243.44, 2031730.32);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (142, 1, 71, 5, 53999.87, 269999.35);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (143, 1, 69, 4, 301913.64, 1207654.56);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (143, 2, 2, 2, 1346706.72, 2693413.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (143, 3, 3, 2, 904886.74, 1809773.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (144, 1, 5, 5, 96616.34, 483081.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (144, 2, 95, 3, 994843.86, 2984531.58);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (144, 3, 51, 1, 1091150.53, 1091150.53);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (145, 1, 30, 3, 1041128.34, 3123385.02);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (146, 1, 37, 4, 1232179.1, 4928716.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (147, 1, 73, 3, 727683.14, 2183049.42);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (147, 2, 60, 2, 154382.97, 308765.94);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (148, 1, 44, 1, 1010593.48, 1010593.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (148, 2, 46, 3, 664546.06, 1993638.18);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (148, 3, 60, 5, 154382.97, 771914.85);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (148, 4, 4, 5, 380968.39, 1904841.95);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (149, 1, 59, 1, 1060026.05, 1060026.05);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (149, 2, 4, 3, 380968.39, 1142905.17);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (149, 3, 19, 2, 27101.7, 54203.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (150, 1, 56, 2, 734297.48, 1468594.96);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (150, 2, 27, 5, 652897.2, 3264486.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (150, 3, 63, 5, 117883.28, 589416.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (150, 4, 42, 2, 1081683.97, 2163367.94);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (151, 1, 5, 2, 96616.34, 193232.68);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (152, 1, 49, 3, 952970.52, 2858911.56);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (152, 2, 76, 4, 1287952.58, 5151810.32);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (153, 1, 15, 1, 1172200.75, 1172200.75);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (153, 2, 33, 1, 388282.85, 388282.85);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (153, 3, 63, 5, 117883.28, 589416.4);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (153, 4, 11, 4, 1358481.52, 5433926.08);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (154, 1, 6, 2, 210079.68, 420159.36);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (154, 2, 8, 2, 723305.02, 1446610.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (154, 3, 52, 5, 415742.74, 2078713.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (154, 4, 25, 1, 363501.38, 363501.38);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (155, 1, 85, 2, 798597.74, 1597195.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (155, 2, 35, 3, 828988.83, 2486966.49);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (156, 1, 37, 2, 1232179.1, 2464358.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (157, 1, 52, 1, 415742.74, 415742.74);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (158, 1, 26, 1, 1481837.84, 1481837.84);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (158, 2, 36, 2, 926718.07, 1853436.14);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (158, 3, 73, 3, 727683.14, 2183049.42);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (158, 4, 38, 5, 640128.85, 3200644.25);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (159, 1, 20, 3, 1315858.01, 3947574.03);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (160, 1, 12, 1, 180545.8, 180545.8);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (161, 1, 78, 2, 796310.24, 1592620.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (162, 1, 92, 4, 860052.43, 3440209.72);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (162, 2, 75, 4, 1206503.39, 4826013.56);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (162, 3, 96, 4, 1403398.38, 5613593.52);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (163, 1, 7, 5, 1342984.06, 6714920.3);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (163, 2, 72, 3, 1191409.72, 3574229.16);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (163, 3, 32, 2, 846165.64, 1692331.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (164, 1, 86, 1, 1172486.49, 1172486.49);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (165, 1, 82, 5, 625409.72, 3127048.6);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (165, 2, 53, 1, 781317.73, 781317.73);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (166, 1, 16, 3, 1004360.19, 3013080.57);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (167, 1, 94, 2, 915926.67, 1831853.34);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (167, 2, 95, 4, 994843.86, 3979375.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (167, 3, 35, 4, 828988.83, 3315955.32);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (168, 1, 15, 1, 1172200.75, 1172200.75);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (168, 2, 77, 4, 677243.44, 2708973.76);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (169, 1, 53, 4, 781317.73, 3125270.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (169, 2, 75, 5, 1206503.39, 6032516.95);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (169, 3, 2, 2, 1346706.72, 2693413.44);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (169, 4, 47, 3, 799415.11, 2398245.33);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (170, 1, 29, 5, 1187356.67, 5936783.35);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (171, 1, 86, 2, 1172486.49, 2344972.98);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (171, 2, 76, 3, 1287952.58, 3863857.74);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (172, 1, 53, 4, 781317.73, 3125270.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (172, 2, 43, 2, 322210.88, 644421.76);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (172, 3, 24, 4, 500574.83, 2002299.32);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (172, 4, 42, 2, 1081683.97, 2163367.94);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (173, 1, 37, 3, 1232179.1, 3696537.3);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (173, 2, 40, 5, 805910.34, 4029551.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (173, 3, 14, 4, 175477.37, 701909.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (173, 4, 90, 2, 1071712.42, 2143424.84);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (174, 1, 69, 1, 301913.64, 301913.64);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (174, 2, 90, 2, 1071712.42, 2143424.84);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (175, 1, 5, 2, 96616.34, 193232.68);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (175, 2, 58, 3, 201803.04, 605409.12);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (176, 1, 83, 4, 565907.32, 2263629.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (177, 1, 32, 1, 846165.64, 846165.64);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (177, 2, 29, 1, 1187356.67, 1187356.67);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (177, 3, 24, 2, 500574.83, 1001149.66);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (178, 1, 8, 2, 723305.02, 1446610.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (178, 2, 46, 3, 664546.06, 1993638.18);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (178, 3, 71, 5, 53999.87, 269999.35);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (178, 4, 10, 3, 873944.93, 2621834.79);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (179, 1, 83, 1, 565907.32, 565907.32);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (179, 2, 57, 4, 645200.0, 2580800.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (179, 3, 64, 4, 831532.73, 3326130.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (180, 1, 68, 1, 1400702.71, 1400702.71);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (180, 2, 49, 4, 952970.52, 3811882.08);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (180, 3, 86, 2, 1172486.49, 2344972.98);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (180, 4, 42, 5, 1081683.97, 5408419.85);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (181, 1, 28, 4, 482954.01, 1931816.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (181, 2, 10, 3, 873944.93, 2621834.79);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (182, 1, 70, 2, 39550.82, 79101.64);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (182, 2, 28, 4, 482954.01, 1931816.04);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (182, 3, 42, 4, 1081683.97, 4326735.88);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (183, 1, 27, 1, 652897.2, 652897.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (183, 2, 83, 4, 565907.32, 2263629.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (183, 3, 1, 5, 727604.87, 3638024.35);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (183, 4, 19, 3, 27101.7, 81305.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (184, 1, 81, 4, 1442832.21, 5771328.84);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (184, 2, 51, 1, 1091150.53, 1091150.53);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (184, 3, 57, 4, 645200.0, 2580800.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (184, 4, 22, 1, 1427444.27, 1427444.27);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (185, 1, 69, 4, 301913.64, 1207654.56);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (185, 2, 9, 4, 501397.02, 2005588.08);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (185, 3, 53, 1, 781317.73, 781317.73);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (186, 1, 36, 5, 926718.07, 4633590.35);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (186, 2, 66, 4, 925959.18, 3703836.72);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (187, 1, 17, 5, 414416.6, 2072083.0);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (188, 1, 12, 4, 180545.8, 722183.2);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (188, 2, 80, 2, 1432810.73, 2865621.46);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (188, 3, 94, 1, 915926.67, 915926.67);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (189, 1, 99, 5, 448917.78, 2244588.9);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (189, 2, 84, 3, 1440536.54, 4321609.62);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (189, 3, 16, 3, 1004360.19, 3013080.57);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (190, 1, 19, 3, 27101.7, 81305.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (190, 2, 43, 4, 322210.88, 1288843.52);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (191, 1, 4, 2, 380968.39, 761936.78);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (192, 1, 95, 1, 994843.86, 994843.86);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (192, 2, 65, 5, 113945.43, 569727.15);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (192, 3, 24, 5, 500574.83, 2502874.15);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (192, 4, 3, 5, 904886.74, 4524433.7);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (193, 1, 100, 4, 201489.82, 805959.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (193, 2, 61, 5, 665492.7, 3327463.5);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (193, 3, 38, 5, 640128.85, 3200644.25);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (193, 4, 29, 1, 1187356.67, 1187356.67);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (194, 1, 74, 2, 1481957.69, 2963915.38);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (194, 2, 44, 4, 1010593.48, 4042373.92);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (195, 1, 94, 4, 915926.67, 3663706.68);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (196, 1, 21, 2, 123979.31, 247958.62);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (196, 2, 75, 1, 1206503.39, 1206503.39);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (196, 3, 9, 1, 501397.02, 501397.02);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (196, 4, 52, 2, 415742.74, 831485.48);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (197, 1, 36, 4, 926718.07, 3706872.28);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (197, 2, 24, 5, 500574.83, 2502874.15);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (198, 1, 53, 2, 781317.73, 1562635.46);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (199, 1, 8, 5, 723305.02, 3616525.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (200, 1, 37, 1, 1232179.1, 1232179.1);
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total) VALUES (200, 2, 85, 3, 798597.74, 2395793.22);

-- ===========================================
-- SELECT COUNT para verificación
-- ===========================================
SELECT 'Proveedores' AS Tabla, COUNT(*) AS Total FROM Proveedores;
SELECT 'Clientes' AS Tabla, COUNT(*) AS Total FROM Clientes;
SELECT 'Vendedor' AS Tabla, COUNT(*) AS Total FROM Vendedor;
SELECT 'Productos' AS Tabla, COUNT(*) AS Total FROM Productos;
SELECT 'Pedidos' AS Tabla, COUNT(*) AS Total FROM Pedidos;
SELECT 'Detalle_Pedidos' AS Tabla, COUNT(*) AS Total FROM Detalle_Pedidos;

-- ===========================================
-- 1.3 DEFINICIÓN DE VISTAS DE NEGOCIO
-- ===========================================
CREATE OR REPLACE VIEW vw_clientes_activos AS
SELECT DISTINCT c.idcliente, c.apellido, c.nombres, c.mail, p.fecha
FROM Clientes c
JOIN Pedidos p ON c.idcliente = p.idcliente
WHERE p.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

CREATE OR REPLACE VIEW vw_rendimiento_vendedores AS
SELECT v.idvendedor, v.apellido, v.nombres, COUNT(p.numero_pedido) AS total_pedidos
FROM Vendedor v
LEFT JOIN Pedidos p ON v.idvendedor = p.idvendedor
GROUP BY v.idvendedor, v.apellido, v.nombres
ORDER BY total_pedidos DESC;

CREATE OR REPLACE VIEW vw_pedidos_alto_valor AS
SELECT p.numero_pedido, SUM(dp.total) AS importe_total
FROM Pedidos p
JOIN Detalle_Pedidos dp ON p.numero_pedido = dp.numero_pedido
GROUP BY p.numero_pedido
HAVING importe_total > 500000;

CREATE OR REPLACE VIEW vw_productos_vendidos_periodo AS
SELECT pr.origen, pr.idproducto, pr.descripcion, SUM(dp.cantidad) AS total_unidades, p.fecha
FROM Productos pr
JOIN Detalle_Pedidos dp ON pr.idproducto = dp.idproducto
JOIN Pedidos p ON dp.numero_pedido = p.numero_pedido
GROUP BY pr.origen, pr.idproducto, pr.descripcion, p.fecha;

CREATE OR REPLACE VIEW vw_clientes_sin_pedidos AS
SELECT * FROM Clientes WHERE idcliente NOT IN (SELECT idcliente FROM Pedidos);

CREATE OR REPLACE VIEW vw_clientes_ocacionales AS
SELECT c.idcliente, c.apellido, c.nombres, COUNT(p.numero_pedido) AS total_pedidos
FROM Clientes c
LEFT JOIN Pedidos p ON c.idcliente = p.idcliente
GROUP BY c.idcliente, c.apellido, c.nombres
HAVING total_pedidos < 2;

-- ===========================================
-- 1.4 SEGURIDAD Y CONTROL DE ACCESO (DCL)
-- ===========================================
DROP ROLE IF EXISTS rol_auditor, rol_vendedor, rol_admin;
CREATE ROLE rol_auditor;
CREATE ROLE rol_vendedor;
CREATE ROLE rol_admin;

GRANT SELECT ON PEDIDOS.* TO rol_auditor;
GRANT SELECT, UPDATE ON PEDIDOS.Clientes TO rol_vendedor;
GRANT SELECT, UPDATE, INSERT ON PEDIDOS.Pedidos TO rol_vendedor;
GRANT SELECT, UPDATE, INSERT ON PEDIDOS.Detalle_Pedidos TO rol_vendedor;
GRANT ALL PRIVILEGES ON PEDIDOS.* TO rol_admin;

DROP USER IF EXISTS 'usuario_auditoria'@'localhost', 'usuario_ventas1'@'localhost', 'usuario_admin1'@'localhost';
CREATE USER 'usuario_auditoria'@'localhost' IDENTIFIED BY 'Pass1234!';
CREATE USER 'usuario_ventas1'@'localhost' IDENTIFIED BY 'Pass1234!';
CREATE USER 'usuario_admin1'@'localhost' IDENTIFIED BY 'Pass1234!';

GRANT rol_auditor TO 'usuario_auditoria'@'localhost';
GRANT rol_vendedor TO 'usuario_ventas1'@'localhost';
GRANT rol_admin TO 'usuario_admin1'@'localhost';

SET DEFAULT ROLE rol_auditor TO 'usuario_auditoria'@'localhost';
SET DEFAULT ROLE rol_vendedor TO 'usuario_ventas1'@'localhost';
SET DEFAULT ROLE rol_admin TO 'usuario_admin1'@'localhost';
FLUSH PRIVILEGES;

-- ===========================================
-- 1.5 PLANES DE EJECUCIÓN E INDEXACIÓN
-- ===========================================
-- Consulta de analisis original:
EXPLAIN
SELECT p.descripcion, SUM(dp.cantidad) AS total_vendido
FROM Productos p
JOIN Detalle_Pedidos dp ON p.idproducto = dp.idproducto
JOIN Pedidos pe ON dp.numero_pedido = pe.numero_pedido
WHERE pe.fecha BETWEEN '2024-01-01' AND '2024-06-30'
 AND p.origen = 'Importado'
GROUP BY p.descripcion
ORDER BY total_vendido DESC;

-- Creación de índices secundarios para optimizar filtro por fecha y origen
CREATE INDEX idx_pedidos_fecha ON Pedidos(fecha);
CREATE INDEX idx_productos_origen ON Productos(origen);

-- Consulta con EXPLAIN después de optimización:
EXPLAIN
SELECT p.descripcion, SUM(dp.cantidad) AS total_vendido
FROM Productos p
JOIN Detalle_Pedidos dp ON p.idproducto = dp.idproducto
JOIN Pedidos pe ON dp.numero_pedido = pe.numero_pedido
WHERE pe.fecha BETWEEN '2024-01-01' AND '2024-06-30'
 AND p.origen = 'Importado'
GROUP BY p.descripcion
ORDER BY total_vendido DESC;

-- ===========================================
-- 1.6 TRANSACCIONES ACID (BLOQUES SQL DIRECTOS)
-- ===========================================
-- Escenario A (Caso Exitoso - Commit)
START TRANSACTION;
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (1, 1, CURDATE(), 'CONFIRMADO');
SET @ult_pedido = LAST_INSERT_ID();
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total)
VALUES (@ult_pedido, 1, 1, 2, (SELECT precio_unitario FROM Productos WHERE idproducto = 1), 2 * (SELECT precio_unitario FROM Productos WHERE idproducto = 1));
INSERT INTO Detalle_Pedidos (numero_pedido, renglon, idproducto, cantidad, precio_unitario, total)
VALUES (@ult_pedido, 2, 2, 1, (SELECT precio_unitario FROM Productos WHERE idproducto = 2), 1 * (SELECT precio_unitario FROM Productos WHERE idproducto = 2));
UPDATE Productos SET stock = stock - 2 WHERE idproducto = 1;
UPDATE Productos SET stock = stock - 1 WHERE idproducto = 2;
COMMIT;

-- Escenario B (Caso con Fallo e Integridad - Rollback)
START TRANSACTION;
INSERT INTO Pedidos (idcliente, idvendedor, fecha, estado) VALUES (99999, 1, CURDATE(), 'CONFIRMADO'); -- ID Cliente inexistente
-- Esto lanzara un error por FK, asi que hacemos ROLLBACK
ROLLBACK;

-- Escenario C (Puntos de Salvaguarda - Savepoint)
START TRANSACTION;
UPDATE Productos SET precio_unitario = precio_unitario * 1.10 WHERE idproducto = 3;
SAVEPOINT punto1;
UPDATE Productos SET stock = stock + 10 WHERE idproducto = 4;
ROLLBACK TO SAVEPOINT punto1;
COMMIT;