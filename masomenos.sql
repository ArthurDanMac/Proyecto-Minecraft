--Si es necesario asegurarse que la base 'INVENTARIO' no exista antes
drop database INVENTARIO
CREATE DATABASE INVENTARIO;
USE INVENTARIO
use prueba


-- Crear la función que verifica la complejidad de la contraseña
CREATE FUNCTION dbo.ValidarComplexityContraseña(@Contraseña NVARCHAR(255))
RETURNS BIT
AS
BEGIN
    DECLARE @Valido BIT = 1;

    IF LEN(@Contraseña) < 8 OR LEN(@Contraseña) > 255
        SET @Valido = 0;

    IF @Valido = 1 AND @Contraseña = LOWER(@Contraseña COLLATE Latin1_General_CS_AS)
        SET @Valido = 0;

    IF @Valido = 1 AND PATINDEX('%[0-9]%', @Contraseña) = 0
        SET @Valido = 0;

    RETURN @Valido;
END;

-- Crear la tabla Jugadores
CREATE TABLE Jugadores (
    ID_Jugador INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Jugador VARCHAR(20),
    Correo_Electronico VARCHAR(40) UNIQUE,
    ContraseñaHash VARBINARY(256), -- Almacenamiento de la contraseña como hash
    Saldo_Esmeraldas INT
);

INSERT INTO Jugadores (Nombre_Jugador, Correo_Electronico, ContraseñaHash, Saldo_Esmeraldas)
VALUES 
('Jugador1', 'jugador1@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd1') AS VARBINARY(256)), 100),
('Jugador2', 'jugador2@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd2') AS VARBINARY(256)), 200),
('Jugador3', 'jugador3@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd3') AS VARBINARY(256)), 300),
('Jugador4', 'jugador4@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd4') AS VARBINARY(256)), 400),
('Jugador5', 'jugador5@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd5') AS VARBINARY(256)), 500),
('Jugador6', 'jugador6@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd6') AS VARBINARY(256)), 600),
('Jugador7', 'jugador7@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd7') AS VARBINARY(256)), 700),
('Jugador8', 'jugador8@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd8') AS VARBINARY(256)), 800),
('Jugador9', 'jugador9@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd9') AS VARBINARY(256)), 900),
('Jugador10', 'jugador10@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd10') AS VARBINARY(256)), 1000),
('Jugador11', 'jugador11@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd11') AS VARBINARY(256)), 1100),
('Jugador12', 'jugador12@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd12') AS VARBINARY(256)), 1200),
('Jugador13', 'jugador13@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd13') AS VARBINARY(256)), 1300),
('Jugador14', 'jugador14@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd14') AS VARBINARY(256)), 1400),
('Jugador15', 'jugador15@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd15') AS VARBINARY(256)), 1500),
('Jugador16', 'jugador16@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd16') AS VARBINARY(256)), 1600),
('Jugador17', 'jugador17@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd17') AS VARBINARY(256)), 1700),
('Jugador18', 'jugador18@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd18') AS VARBINARY(256)), 1800),
('Jugador19', 'jugador19@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd19') AS VARBINARY(256)), 1900),
('Jugador20', 'jugador20@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd20') AS VARBINARY(256)), 2000),
('Jugador21', 'jugador21@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd21') AS VARBINARY(256)), 2100),
('Jugador22', 'jugador22@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd22') AS VARBINARY(256)), 2200),
('Jugador23', 'jugador23@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd23') AS VARBINARY(256)), 2300),
('Jugador24', 'jugador24@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd24') AS VARBINARY(256)), 2400),
('Jugador25', 'jugador25@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd25') AS VARBINARY(256)), 2500),
('Jugador26', 'jugador26@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd26') AS VARBINARY(256)), 2600),
('Jugador27', 'jugador27@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd27') AS VARBINARY(256)), 2700),
('Jugador28', 'jugador28@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd28') AS VARBINARY(256)), 2800),
('Jugador29', 'jugador29@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd29') AS VARBINARY(256)), 2900),
('Jugador30', 'jugador30@email.com', CAST(HASHBYTES('SHA2_256', 'P@ssw0rd30') AS VARBINARY(256)), 3000);

SELECT * FROM Jugadores;
-- Crear la tabla Aldeano
CREATE TABLE Aldeano (
    ID_Aldeano INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Aldeano VARCHAR(30),
    Salario_Esmeraldas INT,
    CONSTRAINT check_aldeano_count CHECK (ID_Aldeano BETWEEN 1 AND 9)
);
INSERT INTO Aldeano 
VALUES
    (  'Aldeano Llanura', 100),
    (  'Aldeano Desierto', 800),
    ( 'Aldeano Sabana', 120),
    (  'Aldeano Jungla', 150),
    (  'Aldeano Tundra', 200),
    (  'Aldeano Taiga', 180),
    (  'Aldeano Pantano', 150),
    ( 'Aldeano Nether', 120),
    (  'Aldeano End', 250);
SELECT * FROM Aldeano;

-- Crear la tabla Regiones
CREATE TABLE Regiones (
    ID_Region INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Region VARCHAR(40),
	Descripcion nvarchar(300),
    ID_AldeanoR INT,
    FOREIGN KEY (ID_AldeanoR) REFERENCES Aldeano(ID_Aldeano),
    CONSTRAINT check_region_count CHECK (ID_Region BETWEEN 1 AND 9)
);
INSERT INTO Regiones
VALUES
    ('Llanuras','Un bioma plano y herboso con pendientes suaves y unos pocos robles. Los lagos, pequeñas cuevas submarinas y aldeas son comunes.',1),
    ('Desierto','Un bioma árido e inhóspito que consiste principalmente en dunas de arena, arbustos muertos y cactus. Debajo de la arena se encuentran arenisca y, a veces, fósiles.',2),
    ('Sabana','Un bioma relativamente plano y seco con un color de hierba marrón opaco y árboles de acacia dispersos alrededor del bioma, la hierba alta cubre el paisaje',3),
    ('Jungla','Un bioma templado denso y poco común. Se caracteriza por los helechos y los grandes árboles selváticos',4),
    ('Tundra','Un bioma expansivo y plano con grandes cantidades de capas de nieve. Las fuentes de agua se convierten en hielo.',5),
    ('Taiga','Un predominante bioma plano cubierto por un bosque de abetos. Helechos, grandes helechos y arbustos de bayas creciendo comúnmente en el suelo del bosque. ',6),
    ('Pantano','Un bioma caracterizado por una mezcla de areas planas y pequeñas piscinas de agua verdosa con nenúfares.',7),
    ('Nether','Los desiertos del Nether son un bioma estéril compuesto principalmente de netherrack. Tiene extensos océanos de lava con cúmulo de piedra luminosa que cuelgan del techo.',8),
    ('End','La isla central End se genera en el centro de este círculo, y está rodeada por un vacío total hasta el borde del bioma.',9);
SELECT * from Regiones;

-- Crear la tabla Productos
CREATE TABLE Productos (
    ID_Producto INT PRIMARY KEY IDENTITY(1,1),
    Precio_Esmeralda INT,
    Categoria VARCHAR(30)
);
INSERT INTO Productos VALUES
--materiales
(5,'Madera'),
(5,'Madera'),
(6,'Piel'),
(8,'Piel'),
(3,'Construcción'),
(3,'Vegetación'),
(4,'Construcción'),
(6,'Madera'),
(4,'Artesanía'),
(7,'Madera'),
(5,'Vegetación'),
(8,'Comida'),
(3,'Comida'),
(4,'Natural'),
(5,'Construcción'),
(9,'Comida'),
(7,'Madera'),
(6,'Comida'),
(5,'Construcción'),
(2,'Vegetación'),
(6,'Vegetación'),
(8,'Recurso de creatura'),
(10,'Construcción'),
(11,'Decoración'),
(11,'Decoración'),
(7,'Crafteo'),
(11,'Vegetación'),
(13,'Decoración'),
(10,'Vegetación'),
(15,'Recurso de creatura');
SELECT * FROM Productos;
--nuevas categorias para herramientas (pa matar/defensa, pa recolectar, pa construir,herreria)
insert into Productos values
	(5,'Recolección'),--1
	(6,'Defensa'),
	(6,'Defensa'),
	(5,'Recolección'),
	(6,'Defensa'),--5
	(6,'Defensa'),
	(8,'Defensa'),
	(3,'Defensa'),
	(4,'Recolección'),
	(3,'Recolección'),--10
	(4,'Herrería'),
	(5,'Construcción'),
	(2,'Construcción'),
	(2,'Construcción'),
	(2,'Construcción'),--15
	(3,'Construcción'),
	(4,'Construcción'),
	(4,'Construcción'),
	(3,'Construcción'),
	(2,'Construcción'),--20
	(3,'Construcción'),
	(5,'Construcción'),
	(4,'Herrería'),
	(4,'Construcción'),
	(2,'Construcción'),--25
	(3,'Construcción'),
	(4,'Construcción'),
	(3,'Construccion'),
	(2,'Construcción'),
	(2,'Construcción');--30
select *from Productos

-- Crear la tabla Materiales
CREATE TABLE Materiales (
    ID_Material INT PRIMARY KEY IDENTITY(1,1),
    Tipo_Material VARCHAR(40),
    ID_Producto INT,
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);
INSERT INTO Materiales VALUES
('Madera de roble',1),
('Madera de abedul',2),
('Lana',3),
('Cuero',4),
('Arena',5),
('Cactus',6),
('Bloques de templo',7),
('Madera de acacia',8),
('Arcilla',9),
('Madera de jungla',10),
('Bambú',11),
('Cacao',12),
('Melón',13),
('Nieve',14),
('Hielo',15),
('Pescado de lagos helados',16),
('Madera de abeto',17),
('Bayas dulces',18),
('Arcilla',19),
('Lirios',20),
('Hongos',21),
('Slime',22),
('Netherite',23),
('Piedra luminosa',24),
('Cuarzo del Nether',25),
('Varas de blaze',26),
('Endstone',27),
('Perlas de ender',28),
('Elytras',29),
('Shulker shells',30);
SELECT *FROM Materiales;

-- Crear la tabla Herramientas
CREATE TABLE Herramientas (
    ID_Herramienta INT PRIMARY KEY IDENTITY(1,1),
    Tipo_Herramienta VARCHAR(40),
    Componente VARCHAR(30),
    ID_Producto INT,
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);

INSERT INTO Herramientas VALUES
('Pico de Hierro', 'Hierro', 31),
('Espada de Madera', 'Madera de roble', 32),
('Hacha de Piedra', 'Piedra', 33),
('Pala de Oro', 'Oro', 34),
('Arco y Flecha', 'Cuerda', 35),
('Lanza de Diamante', 'Diamante', 36),
('Mazo de Acero', 'Acero', 37),
('Cuchillo de Caza', 'Hueso', 38),
('Azada de Bronce', 'Bronce', 39),
('Tijeras', 'Metal', 40),
('Martillo de Herrero', 'Hierro', 41),
('Sierra de Madera', 'Acero', 42),
('Destornillador', 'Metal', 43),
('Pinzas', 'Metal', 44),
('Cincel', 'Hierro', 45),
('Llave Inglesa', 'Acero', 46),
('Taladro Eléctrico', 'Cobre', 47),
('Soplete', 'Acero', 48),
('Escalera', 'Madera', 49),
('Cubo', 'Metal', 50),
('Cuerda', 'Fibra', 51),
('Carretilla', 'Metal', 52),
('Pulidora', 'Acero', 53),
('Pistola de Clavos', 'Metal', 54),
('Grapadora', 'Metal', 55),
('Brocha', 'Pelo', 56),
('Rodillo de Pintura', 'Espuma', 57),
('Paleta de Albañil', 'Acero', 58),
('Flexómetro', 'Metal', 59),
('Nivel', 'Metal', 60);
SELECT *FROM Herramientas;
select *from Productos
-- Crear la tabla de relación AldeanoProductos
CREATE TABLE AldeanoProductos (
    ID_Aldeano INT,
    ID_Producto INT,
    FOREIGN KEY (ID_Aldeano) REFERENCES Aldeano(ID_Aldeano),
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);

INSERT INTO AldeanoProductos (ID_Aldeano, ID_Producto) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(2, 6),
(3, 7),
(3, 8),
(3, 9),
(4, 10),
(4, 11),
(4, 12),
(5, 13),
(5, 14),
(5, 15),
(6, 16),
(6, 17),
(6, 18),
(7, 19),
(7, 20),
(7, 21),
(8, 22),
(8, 23),
(8, 24),
(9, 25),
(9, 26),
(9, 27),
(1, 28),
(1, 29),
(1, 30);
SELECT * FROM AldeanoProductos;


SELECT 
    A.Nombre_Aldeano,
    P.Categoria
FROM 
    AldeanoProductos AP
    JOIN Aldeano A ON AP.ID_Aldeano = A.ID_Aldeano
    JOIN Productos P ON AP.ID_Producto = P.ID_Producto;


-- Crear la tabla Compras
CREATE TABLE Compras (
    ID_Compra INT PRIMARY KEY IDENTITY(1,1),
    ID_Jugador INT,
    ID_Producto INT,
    Cantidad INT,
    PrecioTotal INT,
    FechaCompra DATE,
    FOREIGN KEY (ID_Jugador) REFERENCES Jugadores(ID_Jugador),
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);
INSERT INTO Compras (ID_Jugador, ID_Producto, Cantidad, PrecioTotal, FechaCompra) VALUES
(6, 16, 1, 16, '2023-01-16'),
(7, 17, 2, 34, '2023-01-17'),
(8, 18, 3, 54, '2023-01-18'),
(9, 19, 1, 19, '2023-01-19'),
(10, 20, 2, 40, '2023-01-20'),
(6, 21, 3, 63, '2023-01-21'),
(7, 22, 1, 22, '2023-01-22'),
(8, 23, 2, 46, '2023-01-23'),
(9, 24, 3, 72, '2023-01-24'),
(10, 25, 1, 25, '2023-01-25'),
(6, 26, 2, 52, '2023-01-26'),
(7, 27, 3, 81, '2023-01-27'),
(8, 28, 1, 28, '2023-01-28'),
(9, 29, 2, 58, '2023-01-29'),
(10, 30, 3, 90, '2023-01-30');
SELECT * FROM Compras;
SELECT 
    J.Nombre_Jugador,
    P.Categoria,
    C.Cantidad,
    C.PrecioTotal,
    C.FechaCompra
FROM 
    Compras C
    JOIN Jugadores J ON C.ID_Jugador = J.ID_Jugador
    JOIN Productos P ON C.ID_Producto = P.ID_Producto;


-- Crear la tabla Ventas
CREATE TABLE Ventas (
    ID_Venta INT PRIMARY KEY IDENTITY(1,1),
    ID_Jugador INT,
    ID_Aldeano INT,
    Cantidad INT,
    PrecioTotal INT,
    FechaVenta DATE,
    FOREIGN KEY (ID_Jugador) REFERENCES Jugadores(ID_Jugador),
    FOREIGN KEY (ID_Aldeano) REFERENCES Aldeano(ID_Aldeano)
);

INSERT INTO Compras (ID_Jugador, ID_Producto, Cantidad, PrecioTotal, FechaCompra) VALUES
(6, 16, 1, 16, '2023-01-16'),
(7, 17, 2, 34, '2023-01-17'),
(8, 18, 3, 54, '2023-01-18'),
(9, 19, 1, 19, '2023-01-19'),
(10, 20, 2, 40, '2023-01-20'),
(6, 21, 3, 63, '2023-01-21'),
(7, 22, 1, 22, '2023-01-22'),
(8, 23, 2, 46, '2023-01-23'),
(9, 24, 3, 72, '2023-01-24'),
(10, 25, 1, 25, '2023-01-25'),
(6, 26, 2, 52, '2023-01-26'),
(7, 27, 3, 81, '2023-01-27'),
(8, 28, 1, 28, '2023-01-28'),
(9, 29, 2, 58, '2023-01-29'),
(10, 30, 3, 90, '2023-01-30');
SELECT * FROM Herramientas;

-- Crear la tabla InventarioJugadores
CREATE TABLE InventarioJugadores (
    ID_Inventario INT PRIMARY KEY IDENTITY(1,1),
    ID_Jugador INT,
    ID_Producto INT,
    Cantidad INT,
    ID_Region INT,
    FOREIGN KEY (ID_Jugador) REFERENCES Jugadores(ID_Jugador),
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto),
    FOREIGN KEY (ID_Region) REFERENCES Regiones(ID_Region)
);

-- Insertar datos en la tabla InventarioJugadores (ejemplo)
INSERT INTO InventarioJugadores (ID_Jugador, ID_Producto, Cantidad, ID_Region) VALUES
(1, 1, 2, 1),
(1, 2, 3, 2),
(1, 3, 5, 3),
(2, 4, 1, 4),
(2, 5, 2, 5),
(2, 6, 6, 6),
(3, 7, 3, 7),
(3, 8, 4, 1),
(3, 9, 5, 2),
(4, 10, 2, 3),
(4, 11, 3, 4),
(4, 12, 1, 5),
(5, 13, 2, 6),
(5, 14, 1, 7),
(5, 15, 3, 1),
(6, 16, 4, 2),
(6, 17, 5, 3),
(6, 18, 2, 4),
(7, 19, 3, 5),
(7, 20, 4, 6),
(7, 21, 1, 7),
(8, 22, 2, 1),
(8, 23, 3, 2),
(8, 24, 4, 3),
(9, 25, 5, 4),
(9, 26, 1, 5),
(9, 27, 2, 6),
(10, 28, 3, 7),
(10, 29, 4, 1),
(10, 30, 5, 2);

-- Consultar el inventario de los jugadores, mostrando qué productos tienen, en qué cantidad y de qué región los compraron
SELECT 
    J.Nombre_Jugador,
    P.Categoria,
    I.Cantidad,
    R.Nombre_Region
FROM 
    InventarioJugadores I
    JOIN Jugadores J ON I.ID_Jugador = J.ID_Jugador
    JOIN Productos P ON I.ID_Producto = P.ID_Producto
    JOIN Regiones R ON I.ID_Region = R.ID_Region;


CREATE TABLE ComprasAldeanos (
    ID_Compra INT PRIMARY KEY IDENTITY(1,1),
    ID_Aldeano INT,
    ID_Producto INT,
    Cantidad INT,
    PrecioTotal INT,
    FechaCompra DATE,
    FOREIGN KEY (ID_Aldeano) REFERENCES Aldeano(ID_Aldeano),
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);

INSERT INTO ComprasAldeanos (ID_Aldeano, ID_Producto, Cantidad, PrecioTotal, FechaCompra) VALUES
(1, 8, 3, 26, '2023-09-07'),
(2, 8, 2, 28, '2023-09-22'),
(3, 4, 1, 78, '2023-08-13'),
(4, 6, 3, 28, '2023-02-15'),
(5, 6, 5, 33, '2023-07-06'),
(1, 2, 1, 80, '2023-04-24'),
(6, 3, 3, 34, '2023-07-24'),
(2, 3, 4, 88, '2023-09-30'),
(3, 7, 5, 22, '2023-06-23'),
(9, 7, 2, 84, '2023-07-14'),
(8, 8, 4, 15, '2023-09-04'),
(2, 7, 5, 59, '2023-02-07'),
(5, 8, 2, 33, '2023-11-15'),
(6, 6, 4, 32, '2023-12-02'),
(3, 9, 5, 25, '2023-01-14');
SELECT * FROM ComprasAldeanos;

CREATE TABLE VentasAldeanos (
    ID_Venta INT PRIMARY KEY IDENTITY(1,1),
    ID_Jugador INT,
    ID_Aldeano INT,
    Cantidad INT,
    PrecioTotal INT,
    FechaVenta DATE,
    FOREIGN KEY (ID_Jugador) REFERENCES Jugadores(ID_Jugador),
    FOREIGN KEY (ID_Aldeano) REFERENCES Aldeano(ID_Aldeano)
);

INSERT INTO VentasAldeanos (ID_Jugador, ID_Aldeano, Cantidad, PrecioTotal, FechaVenta) VALUES
(13, 1, 1, 49, '2023-08-05'),
(1, 1, 3, 49, '2023-06-11'),
(16, 1, 4, 54, '2023-01-06'),
(24, 1, 4, 86, '2023-10-20'),
(4, 1, 2, 83, '2023-01-11'),
(17, 1, 3, 30, '2023-01-09'),
(26, 1, 3, 37, '2023-01-09'),
(18, 1, 4, 86, '2023-04-30'),
(19, 1, 2, 62, '2023-12-29'),
(2, 1, 5, 98, '2023-03-08'),
(17, 1, 1, 91, '2023-07-27'),
(6, 1, 4, 22, '2023-09-24'),
(2, 1, 1, 66, '2023-02-09'),
(26, 1, 1, 49, '2023-04-06'),
(2, 1, 5, 27, '2023-12-20');

SELECT * FROM VentasAldeanos;
-- Crear la tabla InventarioAldeanos
CREATE TABLE InventarioAldeanos (
    ID_Inventario INT PRIMARY KEY IDENTITY(1,1),
    ID_Aldeano INT,
    ID_Producto INT,
    Cantidad INT,
    ID_Region INT,
    FOREIGN KEY (ID_Aldeano) REFERENCES Aldeano(ID_Aldeano),
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto),
    FOREIGN KEY (ID_Region) REFERENCES Regiones(ID_Region)
);
ALTER TABLE InventarioAldeanos
ADD ID_Venta INT,
FOREIGN KEY (ID_Venta) REFERENCES Ventas(ID_Venta);

DROP TABLE InventarioAldeanos;

-- Insertar datos en la tabla InventarioAldeanos (ejemplo)
INSERT INTO InventarioAldeanos (ID_Aldeano, ID_Producto, Cantidad, ID_Region) VALUES
(1, 1, 5, 1),
(1, 2, 3, 2),
(1, 3, 2, 3),
(2, 4, 6, 4),
(2, 5, 4, 5),
(2, 6, 1, 6),
(3, 7, 3, 7),
(3, 8, 2, 1),
(3, 9, 5, 2),
(4, 10, 7, 3),
(4, 11, 2, 4),
(4, 12, 3, 5),
(5, 13, 4, 6),
(5, 14, 5, 7),
(5, 15, 6, 1),
(6, 16, 2, 2),
(6, 17, 1, 3),
(6, 18, 3, 4),
(7, 19, 5, 5),
(7, 20, 4, 6),
(7, 21, 2, 7),
(8, 22, 3, 1),
(8, 23, 4, 2),
(8, 24, 1, 3),
(9, 25, 5, 4),
(9, 26, 2, 5),
(9, 27, 3, 6),
(3, 28, 4, 7),
(4, 29, 5, 1),
(1, 30, 1, 3),
(1, 24, 2, 4),
(2, 23, 3, 5);


-- Consultar el inventario de los aldeanos, mostrando qué productos tienen, en qué cantidad y de qué región los compraron
SELECT 
    A.Nombre_Aldeano,
    P.Categoria,
    IA.Cantidad,
    R.Nombre_Region
FROM 
    InventarioAldeanos IA
    JOIN Aldeano A ON IA.ID_Aldeano = A.ID_Aldeano
    JOIN Productos P ON IA.ID_Producto = P.ID_Producto
    JOIN Regiones R ON IA.ID_Region = R.ID_Region;

SELECT 
    A.Nombre_Aldeano,
    P.Categoria,
    IA.Cantidad,
    R.Nombre_Region,
    J.Nombre_Jugador
FROM 
    InventarioAldeanos IA
    JOIN Aldeano A ON IA.ID_Aldeano = A.ID_Aldeano
    JOIN Productos P ON IA.ID_Producto = P.ID_Producto
    JOIN Regiones R ON IA.ID_Region = R.ID_Region
    JOIN Ventas V ON IA.ID_Venta = V.ID_Venta
    JOIN Jugadores J ON V.ID_Jugador = J.ID_Jugador;



select *from Productos
select *from Herramientas
select *from Materiales
select *from Herramientas inner join Productos on Herramientas.ID_Producto=Productos.ID_Producto
select *from Materiales inner join Productos on Materiales.ID_Producto=Productos.ID_Producto
select *from Herramientas
	inner join Productos on Herramientas.ID_Producto=Productos.ID_Producto
	inner join Materiales on Materiales.ID_Producto=Productos.ID_Producto order by Productos.ID_Producto


select distinct(Categoria) from Productos
select *from Materiales inner join Productos on Materiales.ID_Producto=Productos.ID_Producto

select *from Productos
select *from Herramientas

select *from InventarioJugadores inner join Jugadores on InventarioJugadores.ID_Jugador=Jugadores.ID_Jugador
	inner join Productos on InventarioJugadores.ID_Producto=Productos.ID_Producto
	inner join Materiales on Materiales.ID_Producto=Productos.ID_Producto

	select *from Herramientas

select * from Productos 
	inner join Herramientas on Productos.ID_Producto=Herramientas.ID_Producto
	inner join Materiales on Productos.ID_Producto = Materiales.ID_Producto

select * from Productos 
inner join Materiales on Productos.ID_Producto = Materiales.ID_Producto

select *from Materiales
	inner join Productos on Materiales.ID_Producto=Productos.ID_Producto
	inner join AldeanoProductos on AldeanoProductos.ID_Producto=Productos.ID_Producto
	inner join Aldeano on Aldeano.ID_Aldeano=AldeanoProductos.ID_Aldeano
	inner join Regiones on Regiones.ID_AldeanoR=Aldeano.ID_Aldeano


select Materiales.Tipo_Material,Productos.Precio_Esmeralda,Productos.Categoria,Aldeano.Nombre_Aldeano,Aldeano.Salario_Esmeraldas,Regiones.Nombre_Region from Materiales
	inner join Productos on Materiales.ID_Producto=Productos.ID_Producto
	inner join AldeanoProductos on AldeanoProductos.ID_Producto=Productos.ID_Producto
	inner join Aldeano on Aldeano.ID_Aldeano=AldeanoProductos.ID_Aldeano
	inner join Regiones on Regiones.ID_AldeanoR=Aldeano.ID_Aldeano order by Regiones.ID_Region


select Materiales.Tipo_Material,Productos.Precio_Esmeralda,Productos.Categoria,Aldeano.Nombre_Aldeano,Aldeano.Salario_Esmeraldas,Regiones.Nombre_Region from Materiales
	inner join Productos on Materiales.ID_Producto=Productos.ID_Producto
	inner join AldeanoProductos on AldeanoProductos.ID_Producto=Productos.ID_Producto
	inner join Aldeano on Aldeano.ID_Aldeano=AldeanoProductos.ID_Aldeano
	inner join Regiones on Regiones.ID_AldeanoR=Aldeano.ID_Aldeano order by Regiones.ID_Region where Regiones.ID_Region=1 --cambiar la egion por la que yo quiera

	select Materiales.Tipo_Material,Productos.Precio_Esmeralda,Productos.Categoria from Materiales
		inner join Productos on Materiales.ID_Producto=Productos.ID_Producto
		inner join AldeanoProductos on AldeanoProductos.ID_Producto=Productos.ID_Producto
		inner join Aldeano on Aldeano.ID_Aldeano=AldeanoProductos.ID_Aldeano
		inner join Regiones on Regiones.ID_AldeanoR=Aldeano.ID_Aldeano where Regiones.ID_Region=1 

select * from Herramientas
	inner join Productos on Herramientas.ID_Producto=Productos.ID_Producto
	inner join AldeanoProductos on AldeanoProductos.ID_Producto=Productos.ID_Producto
	inner join Aldeano on Aldeano.ID_Aldeano=AldeanoProductos.ID_Aldeano
	inner join Regiones on Regiones.ID_AldeanoR=Aldeano.ID_Aldeano order by Regiones.ID_Region where Regiones.ID_Region=8



select Herramientas.Tipo_Herramienta ,Herramientas.Componente, Productos.Precio_Esmeralda,Productos.Categoria from Herramientas
	inner join Productos on Herramientas.ID_Producto=Productos.ID_Producto
	inner join AldeanoProductos on AldeanoProductos.ID_Producto=Productos.ID_Producto
	inner join Aldeano on Aldeano.ID_Aldeano=AldeanoProductos.ID_Aldeano
	inner join Regiones on Regiones.ID_AldeanoR=Aldeano.ID_Aldeano where Regiones.ID_Region=1

	select *from HerramientasLLanuras

select *from Productos

select *from Aldeano
select *from Herramientas
select *from AldeanoProductos order by ID_Producto -- se eesita poner mas datos a esto xd

select * from Herramientas where Componente='oro' --34

insert into AldeanoProductos values
	(7,31),
	(1, 32),
	(1, 33),
	(8,34),
	(2, 35),
	(2, 36),
	(3, 37),
	(3, 38),
	(3, 39),
	(4, 40),
	(4, 41),
	(4, 42),
	(5, 43),
	(5, 44),
	(5, 45),
	(6, 46),
	(6, 47),
	(6, 48),
	(7, 49),
	(7, 50),
	(7, 51),
	(8, 52),
	(8, 53),
	(8, 54),
	(9, 55),
	(9, 56),
	(9, 57),
	(1, 58),
	(1, 59),
	(1, 60);

select Materiales.Tipo_Material, Herramientas.Componente,Herramientas.Tipo_Herramienta,Productos.Precio_Esmeralda Productos.Categoriafrom Herramientas
	inner join Productos on Productos.ID_Producto=Herramientas.ID_Producto
	inner join Materiales on Materiales.ID_Producto=Productos.ID_Producto


select Materiales.Tipo_Material, Herramientas.Componente,Herramientas.Tipo_Herramienta,Productos.Categoria,Productos.Precio_Esmeralda from Productos
	inner join Herramientas on Productos.ID_Producto=Herramientas.ID_Producto
	inner join Materiales on Materiales.ID_Producto=Productos.ID_Producto

select * from Productos inner join Materiales on Materiales.ID_Producto=Productos.ID_Producto
	inner join Herramientas on Herramientas.ID_Producto=Productos.ID_Producto

--llanuras
create view MaterialesLLanuras as
	select Materiales.Tipo_Material,Productos.Precio_Esmeralda,Productos.Categoria from Materiales
		inner join Productos on Materiales.ID_Producto=Productos.ID_Producto
		inner join AldeanoProductos on AldeanoProductos.ID_Producto=Productos.ID_Producto
		inner join Aldeano on Aldeano.ID_Aldeano=AldeanoProductos.ID_Aldeano
		inner join Regiones on Regiones.ID_AldeanoR=Aldeano.ID_Aldeano where Regiones.ID_Region=1 
select *from MaterialesLLanuras
drop view MaterialesLLanuras


create view HerramientasLLanuras as
select Herramientas.Tipo_Herramienta ,Herramientas.Componente, Productos.Precio_Esmeralda,Productos.Categoria from Herramientas
	inner join Productos on Herramientas.ID_Producto=Productos.ID_Producto
	inner join AldeanoProductos on AldeanoProductos.ID_Producto=Productos.ID_Producto
	inner join Aldeano on Aldeano.ID_Aldeano=AldeanoProductos.ID_Aldeano
	inner join Regiones on Regiones.ID_AldeanoR=Aldeano.ID_Aldeano where Regiones.ID_Region=1

	select *from HerramientasLLanuras
drop view HerramientasLLanuras

--nether
select *from Regiones

create view MaterialesNether as
	select Materiales.Tipo_Material,Productos.Precio_Esmeralda,Productos.Categoria from Materiales
		inner join Productos on Materiales.ID_Producto=Productos.ID_Producto
		inner join AldeanoProductos on AldeanoProductos.ID_Producto=Productos.ID_Producto
		inner join Aldeano on Aldeano.ID_Aldeano=AldeanoProductos.ID_Aldeano
		inner join Regiones on Regiones.ID_AldeanoR=Aldeano.ID_Aldeano where Regiones.ID_Region=8
select *from MaterialesNether
drop view MaterialesLLanuras


create view HerramientasNether as
select Herramientas.Tipo_Herramienta ,Herramientas.Componente, Productos.Precio_Esmeralda,Productos.Categoria from Herramientas
	inner join Productos on Herramientas.ID_Producto=Productos.ID_Producto
	inner join AldeanoProductos on AldeanoProductos.ID_Producto=Productos.ID_Producto
	inner join Aldeano on Aldeano.ID_Aldeano=AldeanoProductos.ID_Aldeano
	inner join Regiones on Regiones.ID_AldeanoR=Aldeano.ID_Aldeano where Regiones.ID_Region=8

	select *from HerramientasNether
drop view HerramientasLLanuras

select *from Productos
select *from Herramientas


select *from Herramientas
	inner join Productos on Herramientas.ID_Producto=Productos.ID_Producto
	inner join AldeanoProductos on AldeanoProductos.ID_Producto=Productos.ID_Producto
	inner join Aldeano on Aldeano.ID_Aldeano=AldeanoProductos.ID_Aldeano
	inner join Regiones on Regiones.ID_AldeanoR=Aldeano.ID_Aldeano where Regiones.ID_Region=8

select *from AldeanoProductos

select * from Jugadores
select *from InventarioJugadores 


select Regiones.Nombre_Region,Productos.Categoria,Cantidad,Productos.Precio_Esmeralda from InventarioJugadores
	inner join Jugadores on Jugadores.ID_Jugador=InventarioJugadores.ID_Jugador
	inner join Regiones on Regiones.ID_Region=InventarioJugadores.ID_Region
	inner join Productos on Productos.ID_Producto=InventarioJugadores.ID_Producto where Nombre_Jugador='Jugador9'


select Cantidad,Regiones.Nombre_Region,Productos.Categoria,Productos.Precio_Esmeralda,Materiales.Tipo_Material from InventarioJugadores
	inner join Jugadores on Jugadores.ID_Jugador=InventarioJugadores.ID_Jugador
	inner join Regiones on Regiones.ID_Region=InventarioJugadores.ID_Region
	inner join Productos on Productos.ID_Producto=InventarioJugadores.ID_Producto 
	inner join Materiales on Materiales.ID_Producto=Productos.ID_Producto
		where Nombre_Jugador='Jugador4'

--insertar datos de herramientas en Inventario Jugadores e Inventario ALdeanos

select Cantidad,Regiones.Nombre_Region,Productos.Categoria,Productos.Precio_Esmeralda,Herramientas.Componente,Herramientas.Tipo_Herramienta from InventarioJugadores
	inner join Jugadores on Jugadores.ID_Jugador=InventarioJugadores.ID_Jugador
	inner join Regiones on Regiones.ID_Region=InventarioJugadores.ID_Region
	inner join Productos on Productos.ID_Producto=InventarioJugadores.ID_Producto 
	inner join Herramientas on Herramientas.ID_Producto=Productos.ID_Producto
		where Nombre_Jugador='Jugador1'

use Inventario
select *from Regiones

select *from Aldeano inner join Regiones on Aldeano.ID_Aldeano=Regiones.ID_AldeanoR order by ID_Region

ALTER TABLE Regiones
ADD Descripciones nvarchar(300)

update  Regiones set Descripciones='Un bioma plano y herboso con pendientes suaves y unos pocos robles. Los lagos, pequeñas cuevas submarinas y aldeas son comunes.' where ID_Region=1
update  Regiones set Descripciones='Un bioma árido e inhóspito que consiste principalmente en dunas de arena, arbustos muertos y cactus. Debajo de la arena se encuentran arenisca y, a veces, fósiles.' where ID_Region=2
update  Regiones set Descripciones='Un bioma relativamente plano y seco con un color de hierba marrón opaco y árboles de acacia dispersos alrededor del bioma, la hierba alta cubre el paisaje' where ID_Region=3
update  Regiones set Descripciones='Un bioma templado denso y poco común. Se caracteriza por los helechos y los grandes árboles selváticos' where ID_Region=4
update  Regiones set Descripciones='Un bioma expansivo y plano con grandes cantidades de capas de nieve. Las fuentes de agua se convierten en hielo.'where ID_Region=5
update  Regiones set Descripciones='Un predominante bioma plano cubierto por un bosque de abetos. Helechos, grandes helechos y arbustos de bayas creciendo comúnmente en el suelo del bosque.' where ID_Region=6
update  Regiones set Descripciones='Un bioma caracterizado por una mezcla de areas planas y pequeñas piscinas de agua verdosa con nenúfares.' where ID_Region=7
update  Regiones set Descripciones='Los desiertos del Nether son un bioma estéril compuesto principalmente de netherrack. Tiene extensos océanos de lava con cúmulo de piedra luminosa que cuelgan del techo.' where ID_Region=8
update  Regiones set Descripciones='La isla central End se genera en el centro de este círculo, y está rodeada por un vacío total hasta el borde del bioma.' where ID_Region=9


create procedure DescripcionesRegiones @idRegion int 
as 
begin 
	select Descripciones from Regiones where ID_Region=@idRegion
end

execute DescripcionesRegiones @idRegion=3