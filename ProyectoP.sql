CREATE DATABASE MINECRAFT;
USE MINECRAFT;

/*Asegurarse que la base inventario exista
USE master;
ALTER DATABASE MINECRAFT SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE IF EXISTS MINECRAFT;
CREATE DATABASE MINECRAFT;
USE MINECRAFT;
*/

-- Crear la función que verifica la complejidad de la contraseña con el uso de las tablas hash
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

-- Crear la tabla Aldeano
CREATE TABLE Aldeano (
    ID_Aldeano INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Aldeano VARCHAR(30),
    Salario_Esmeraldas INT,
    CONSTRAINT check_aldeano_count CHECK (ID_Aldeano BETWEEN 1 AND 9)
);


-- Crear la tabla Regiones
CREATE TABLE Regiones (
    ID_Region INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Region VARCHAR(40),
    ID_AldeanoR INT,
    FOREIGN KEY (ID_AldeanoR) REFERENCES Aldeano(ID_Aldeano) ON UPDATE CASCADE,
    CONSTRAINT check_region_count CHECK (ID_Region BETWEEN 1 AND 9)
);


-- Crear la tabla Productos
CREATE TABLE Productos (
    ID_Producto INT PRIMARY KEY IDENTITY(1,1),
    Precio_Esmeralda INT,
    Categoria VARCHAR(30)
);


-- Crear la tabla Materiales
CREATE TABLE Materiales (
    ID_Material INT PRIMARY KEY IDENTITY(1,1),
    Tipo_Material VARCHAR(40),
    ID_Producto INT,
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto) ON UPDATE CASCADE
);


-- Crear la tabla Herramientas
CREATE TABLE Herramientas (
    ID_Herramienta INT PRIMARY KEY IDENTITY(1,1),
    Tipo_Herramienta VARCHAR(40),
    Componente VARCHAR(30),
    ID_Producto INT,
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto) ON UPDATE CASCADE
);


-- Crear la tabla de relación AldeanoProductos (inventario de aldeanos)
CREATE TABLE AldeanoProductos (
	ID_AldeanoInventario INT PRIMARY KEY IDENTITY(1,1),
    ID_Aldeano INT,
    ID_Producto INT,
	Cantidad INT,
    FOREIGN KEY (ID_Aldeano) REFERENCES Aldeano(ID_Aldeano) ON UPDATE CASCADE,
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto) ON UPDATE CASCADE
);


-- Crear la tabla Compras (Jugador Compra a Aldeano)
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


-- Crear la tabla Ventas (Jugador Vende a Aldeano)
CREATE TABLE Ventas (
    ID_Venta INT PRIMARY KEY IDENTITY(1,1),
    ID_Jugador INT,
	ID_Producto INT,
    Cantidad INT,
    PrecioTotal INT,
    FechaVenta DATE,
    FOREIGN KEY (ID_Jugador) REFERENCES Jugadores(ID_Jugador) ON UPDATE CASCADE,
	FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto) ON UPDATE CASCADE
);


-- Crear la tabla InventarioJugadores
CREATE TABLE InventarioJugadores (
    ID_InventarioJ INT PRIMARY KEY IDENTITY(1,1),
    ID_Jugador INT,
    ID_Producto INT,
    Cantidad INT,
    FOREIGN KEY (ID_Jugador) REFERENCES Jugadores(ID_Jugador) ON UPDATE CASCADE,
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto) ON UPDATE CASCADE
);




--CREACION DE TRIGGERS

-- Crear un disparador (trigger) para validar la fecha de compra
CREATE TRIGGER ValidarFechaCompra
ON Compras
AFTER INSERT, UPDATE
AS
BEGIN
    -- Verificar la fecha de compra para el rango 2023-01-01 al 2024-12-31
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE FechaCompra < '2023-01-01' OR FechaCompra > '2024-12-31'
    )
    BEGIN
        RAISERROR('La fecha de compra debe estar en el rango del 2023 al 2024', 16, 1);
        ROLLBACK;
    END
END;

-- Crear un disparador (trigger) para validar la fecha de venta
CREATE TRIGGER ValidarFechaVenta
ON Ventas
AFTER INSERT, UPDATE
AS
BEGIN
    -- Verificar la fecha de compra para el rango 2023-01-01 al 2024-12-31
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE FechaVenta < '2023-01-01' OR FechaVenta > '2024-12-31'
    )
    BEGIN
        RAISERROR('La fecha de venta debe estar en el rango del 2023 al 2024', 16, 1);
        ROLLBACK;
    END
END;

-- Crear un disparador (trigger) INSTEAD OF INSERT para verificar el saldo antes de la compra
CREATE TRIGGER VerificarSaldoAnteCompra
ON Compras
INSTEAD OF INSERT
AS
BEGIN
    -- Verificar que el saldo del jugador no sea 0 para ninguna de las filas insertadas
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Jugadores j ON i.ID_Jugador = j.ID_Jugador
        WHERE j.Saldo_Esmeraldas = 0
    )
    BEGIN
        THROW 1, 'El saldo del jugador es 0. No se puede realizar la compra.', 1;
    END
    ELSE
    BEGIN
        -- Insertar los registros en la tabla Compras solo si el saldo no es 0
        INSERT INTO Compras (ID_Jugador, ID_Producto, Cantidad, PrecioTotal, FechaCompra)
        SELECT ID_Jugador, ID_Producto, Cantidad, PrecioTotal, FechaCompra
        FROM inserted;
    END
END;


-- Crear un disparador para la modificación en la tabla Compras
CREATE TRIGGER VerificacionCompraInventario
ON Compras
AFTER INSERT
AS
BEGIN
    DECLARE @ID_Jugador INT, @ID_Producto INT, @Cantidad INT, @PrecioTotal INT, @ID_Aldeano INT;

    SELECT @ID_Jugador = ID_Jugador, @ID_Producto = ID_Producto, @Cantidad = Cantidad
    FROM inserted;

    -- Obtener el ID_Aldeano directamente de la tabla AldeanoProductos
    SELECT @ID_Aldeano = AP.ID_Aldeano
    FROM AldeanoProductos AP
    WHERE AP.ID_AldeanoInventario = (SELECT ID_AldeanoInventario FROM inserted);

    -- Calcular el PrecioTotal en base al precio del producto y la cantidad comprada
    SELECT @PrecioTotal = Precio_Esmeralda * @Cantidad
    FROM Productos
    WHERE ID_Producto = @ID_Producto;

    -- Verificar que la cantidad en AldeanoProductos no sea 0
    IF @Cantidad > 0 AND @Cantidad <= (SELECT Cantidad FROM AldeanoProductos WHERE ID_Aldeano = @ID_Aldeano AND ID_Producto = @ID_Producto)
    BEGIN
        -- Insertar o actualizar el inventario del jugador
        MERGE INTO InventarioJugadores AS target
        USING (SELECT @ID_Jugador AS ID_Jugador, @ID_Producto AS ID_Producto, @Cantidad AS Cantidad) AS source
        ON (target.ID_Jugador = source.ID_Jugador AND target.ID_Producto = source.ID_Producto)
        WHEN MATCHED THEN
            UPDATE SET target.Cantidad = target.Cantidad + source.Cantidad
        WHEN NOT MATCHED THEN
            INSERT (ID_Jugador, ID_Producto, Cantidad)
            VALUES (source.ID_Jugador, source.ID_Producto, source.Cantidad);

        -- Restar la cantidad correspondiente del producto en la tabla AldeanoProductos
        UPDATE AldeanoProductos
        SET Cantidad = Cantidad - @Cantidad
        WHERE ID_Aldeano = @ID_Aldeano AND ID_Producto = @ID_Producto;

        -- Restar el PrecioTotal al saldo del jugador
        UPDATE Jugadores
        SET Saldo_Esmeraldas = Saldo_Esmeraldas - @PrecioTotal
        WHERE ID_Jugador = @ID_Jugador;

        -- Sumar el PrecioTotal al salario del aldeano
        UPDATE Aldeano
        SET Salario_Esmeraldas = Salario_Esmeraldas + @PrecioTotal
        WHERE ID_Aldeano = @ID_Aldeano;
    END
    ELSE
    BEGIN
        PRINT 'La cantidad deseada es mayor que la cantidad disponible. No se realizó la compra.';
    END
END;


-- Crear un disparador (trigger) para la modificación en la tabla Ventas
CREATE TRIGGER VerificacionVentaInventario
ON Ventas
AFTER INSERT
AS
BEGIN
    DECLARE @ID_Jugador INT, @ID_Producto INT, @Cantidad INT, @PrecioTotal INT, @ID_Aldeano INT;

    SELECT @ID_Jugador = ID_Jugador, @ID_Producto = ID_Producto, @Cantidad = Cantidad
    FROM inserted;

    -- Obtener el ID_Aldeano directamente de la tabla AldeanoProductos
    SELECT @ID_Aldeano = AP.ID_Aldeano
    FROM AldeanoProductos AP
    WHERE AP.ID_AldeanoInventario = (SELECT ID_AldeanoInventario FROM inserted);

    -- Calcular el PrecioTotal en base al precio del producto y la cantidad vendida
    SELECT @PrecioTotal = Precio_Esmeralda * @Cantidad
    FROM Productos
    WHERE ID_Producto = @ID_Producto;

    -- Verificar que la cantidad en InventarioJugadores no sea 0 y la cantidad deseada no sea mayor que la cantidad en InventarioJugadores
    IF @Cantidad > 0 AND @Cantidad <= (SELECT Cantidad FROM InventarioJugadores WHERE ID_Jugador = @ID_Jugador AND ID_Producto = @ID_Producto)
    BEGIN
        -- Restar la cantidad correspondiente del producto en la tabla InventarioJugadores
        UPDATE InventarioJugadores
        SET Cantidad = Cantidad - @Cantidad
        WHERE ID_Jugador = @ID_Jugador AND ID_Producto = @ID_Producto;

        -- Sumar el PrecioTotal al saldo del jugador
        UPDATE Jugadores
        SET Saldo_Esmeraldas = Saldo_Esmeraldas + @PrecioTotal
        WHERE ID_Jugador = @ID_Jugador;

        -- Restar el PrecioTotal al salario del aldeano
        UPDATE Aldeano
        SET Salario_Esmeraldas = Salario_Esmeraldas - @PrecioTotal
        WHERE ID_Aldeano = @ID_Aldeano;

        -- Sumar la cantidad correspondiente del producto en la tabla AldeanoProductos
        MERGE INTO AldeanoProductos AS target
        USING (SELECT @ID_Aldeano AS ID_Aldeano, @ID_Producto AS ID_Producto, @Cantidad AS Cantidad) AS source
        ON (target.ID_Aldeano = source.ID_Aldeano AND target.ID_Producto = source.ID_Producto)
        WHEN MATCHED THEN
            UPDATE SET target.Cantidad = target.Cantidad + source.Cantidad
        WHEN NOT MATCHED THEN
            INSERT (ID_Aldeano, ID_Producto, Cantidad)
            VALUES (source.ID_Aldeano, source.ID_Producto, source.Cantidad);
    END
    ELSE
    BEGIN
        PRINT 'La cantidad deseada es mayor que la cantidad disponible en el inventario del jugador. No se realizó la venta.';
    END
END;





--CREACION DE VISTAS 

-- Crear vista para ver la lista de materiales con todos sus atributos
CREATE VIEW VistaMateriales AS
SELECT
    M.ID_Material,
    M.Tipo_Material,
    P.ID_Producto,
    P.Precio_Esmeralda,
    P.Categoria
FROM
    Materiales M
    JOIN Productos P ON M.ID_Producto = P.ID_Producto;


-- Crear vista para ver la lista de herramientas con todos sus atributos
CREATE VIEW VistaHerramientas AS
SELECT
    H.ID_Herramienta,
    H.Tipo_Herramienta,
    H.Componente,
    P.ID_Producto,
    P.Precio_Esmeralda,
    P.Categoria
FROM
    Herramientas H
    JOIN Productos P ON H.ID_Producto = P.ID_Producto;

-- Crear vista para ver la lista de productos por aldeano
CREATE VIEW VistaProductosPorAldeano AS
SELECT
	AP.ID_AldeanoInventario,
    A.Nombre_Aldeano,
    P.ID_Producto,
	AP.Cantidad,
    P.Precio_Esmeralda,
    P.Categoria
FROM
    AldeanoProductos AP
    JOIN Aldeano A ON AP.ID_Aldeano = A.ID_Aldeano
    JOIN Productos P ON AP.ID_Producto = P.ID_Producto;


-- Crear vista para ver la lista de regiones con su aldeano correspondiente y atributos
CREATE VIEW VistaRegionesConAldeano AS
SELECT
    R.ID_Region,
    R.Nombre_Region,
    R.ID_AldeanoR,
    A.Nombre_Aldeano,
    A.Salario_Esmeraldas
FROM
    Regiones R
    JOIN Aldeano A ON R.ID_AldeanoR = A.ID_Aldeano;


-- Crear una vista del inventario de los jugadores
CREATE VIEW VistaInventarioJugadores AS
SELECT 
    J.Nombre_Jugador,
	P.ID_Producto,
    P.Categoria,
    I.Cantidad
FROM 
    InventarioJugadores I
    JOIN Jugadores J ON I.ID_Jugador = J.ID_Jugador
    JOIN Productos P ON I.ID_Producto = P.ID_Producto;
drop view VistaInventarioJugadoresselect *from VistaInventarioJugadores


-- Crear la vista de inventario de Aldeano
CREATE VIEW VistaAldeanoProductos AS
SELECT
    A.ID_AldeanoInventario,
    A.ID_Aldeano,
    A.ID_Producto,
    A.Cantidad,
    AP.Nombre_Aldeano,
    P.Categoria
FROM
    AldeanoProductos A
    INNER JOIN Aldeano AP ON A.ID_Aldeano = AP.ID_Aldeano
    INNER JOIN Productos P ON A.ID_Producto = P.ID_Producto;




 
 --PROCEDIMIENTOS ALMACENADOS
 -- ver materiales por región con ID de región
CREATE PROCEDURE ObtenerMaterialesPorRegion
    @ID_Region INT  
AS
BEGIN
    SELECT
		M.ID_Material,
		P.ID_Producto,
        M.Tipo_Material,
        P.Categoria AS Categoria_Producto,
		P.Precio_Esmeralda 
    FROM
        Materiales M
        JOIN Productos P ON M.ID_Producto = P.ID_Producto
        JOIN AldeanoProductos AP ON P.ID_Producto = AP.ID_Producto
        JOIN Aldeano A ON AP.ID_Aldeano = A.ID_Aldeano
        JOIN Regiones R ON A.ID_Aldeano = R.ID_AldeanoR
    WHERE
        R.ID_Region = @ID_Region; 
END;



--Obtener herramientas por region
CREATE PROCEDURE ObtenerHerramientasPorRegion
    @ID_Region INT  
AS
BEGIN
    SELECT
		H.ID_Herramienta,
		P.ID_Producto,
        H.Tipo_Herramienta,
		H.Componente,
        P.Categoria AS Categoria_Producto,
		P.Precio_Esmeralda 
    FROM
        Herramientas H
        JOIN Productos P ON H.ID_Producto = P.ID_Producto
        JOIN AldeanoProductos AP ON P.ID_Producto = AP.ID_Producto
        JOIN Aldeano A ON AP.ID_Aldeano = A.ID_Aldeano
        JOIN Regiones R ON A.ID_Aldeano = R.ID_AldeanoR
    WHERE
        R.ID_Region = @ID_Region; 
END;


-- Crear procedimiento almacenado con parámetro de ID de aldeano
CREATE PROCEDURE ObtenerProductosPorAldeano
    @ID_Aldeano INT 
AS
BEGIN
    SELECT
        P.ID_Producto,
        P.Precio_Esmeralda,
        P.Categoria AS Categoria_Producto
    FROM
        Productos P
        JOIN AldeanoProductos AP ON P.ID_Producto = AP.ID_Producto
        JOIN Aldeano A ON AP.ID_Aldeano = A.ID_Aldeano
    WHERE
        A.ID_Aldeano = @ID_Aldeano;  
END;


--obtener productos de acuerda a un precio minimo
CREATE PROCEDURE ObtenerProductosPorPrecio
    @Precio_Minimo DECIMAL(10, 2)
AS
BEGIN
    SELECT
        P.ID_Producto,
        P.Precio_Esmeralda,
        P.Categoria AS Categoria_Producto,
        A.Nombre_Aldeano,
        R.Nombre_Region
    FROM
        Productos P
        JOIN AldeanoProductos AP ON P.ID_Producto = AP.ID_Producto
        JOIN Aldeano A ON AP.ID_Aldeano = A.ID_Aldeano
        JOIN Regiones R ON A.ID_Aldeano = R.ID_AldeanoR
    WHERE
        P.Precio_Esmeralda >= @Precio_Minimo;
END;


--obtener informacion de una herramienta por su nombre
CREATE PROCEDURE ObtenerInformacionHerramientaPorNombre
    @Nombre_Herramienta VARCHAR(50)
AS
BEGIN
    SELECT
        P.ID_Producto,
        H.ID_Herramienta,
        H.Tipo_Herramienta,
        H.Componente,
        P.Categoria,
        P.Precio_Esmeralda,
        A.Nombre_Aldeano,
        R.Nombre_Region
    FROM
        Herramientas H
		JOIN Productos P ON H.ID_Producto = P.ID_Producto
        JOIN AldeanoProductos AP ON H.ID_Producto = AP.ID_Producto
        JOIN Aldeano A ON AP.ID_Aldeano = A.ID_Aldeano
        JOIN Regiones R ON A.ID_Aldeano = R.ID_AldeanoR
       
    WHERE
        H.Tipo_Herramienta = @Nombre_Herramienta;
END;



--Obtener la informacion por nombre del material
CREATE PROCEDURE ObtenerInformacionMaterialPorNombre
    @Nombre_Material VARCHAR(50)
AS
BEGIN
    SELECT
        P.ID_Producto,
        M.ID_Material,
		M.Tipo_Material,
        P.Categoria,
        P.Precio_Esmeralda,
        A.Nombre_Aldeano,
        R.Nombre_Region
    FROM
        Materiales M
		JOIN Productos P ON M.ID_Producto = P.ID_Producto
        JOIN AldeanoProductos AP ON M.ID_Producto = AP.ID_Producto
        JOIN Aldeano A ON AP.ID_Aldeano = A.ID_Aldeano
        JOIN Regiones R ON A.ID_Aldeano = R.ID_AldeanoR
       
    WHERE
        M.Tipo_Material = @Nombre_Material;
END;


--Materiales en el inventario de un jugador
CREATE PROCEDURE ObtenerMaterialesEnInventarioJugador
    @ID_Jugador INT
AS
BEGIN
    SELECT
        I.ID_InventarioJ,
        M.Tipo_Material,
		P.Categoria,
		P.Precio_Esmeralda,
        I.Cantidad
    FROM
       InventarioJugadores I
        JOIN Jugadores J ON I.ID_Jugador = J.ID_Jugador
        JOIN Materiales M ON I.ID_Producto = M.ID_Producto
		JOIN Productos P ON M.ID_Producto = P.ID_Producto
    WHERE
        I.ID_Jugador = @ID_Jugador;
END;

--Herramientas en el inventario de un jugador
CREATE PROCEDURE ObtenerHerramientasEnInventarioJugador
    @ID_Jugador INT
AS
BEGIN
    SELECT
        I.ID_InventarioJ,
        H.Tipo_Herramienta,
		H.Componente,
		P.Categoria,
		P.Precio_Esmeralda,
        I.Cantidad
    FROM
        InventarioJugadores I
        JOIN Jugadores J ON I.ID_Jugador = J.ID_Jugador
        JOIN Herramientas H ON I.ID_Producto = H.ID_Producto
		JOIN Productos P ON H.ID_Producto = P.ID_Producto
    WHERE
        I.ID_Jugador = @ID_Jugador;
END;


--INSERCIÓN DE DATOS

INSERT INTO Jugadores (Nombre_Jugador, Correo_Electronico, ContraseñaHash, Saldo_Esmeraldas) VALUES 
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



INSERT INTO Aldeano VALUES
    ('Aldeano Llanura', 100),
    ('Aldeano Desierto', 800),
    ('Aldeano Sabana', 120),
    ('Aldeano Jungla', 150),
    ('Aldeano Tundra', 200),
    ('Aldeano Taiga', 180),
    ('Aldeano Pantano', 150),
    ('Aldeano Nether', 120),
    ('Aldeano End', 250);

INSERT INTO Regiones VALUES
    ('Llanuras',1),
    ('Desierto',2),
    ('Sabana',3),
    ('Jungla',4),
    ('Tundra',5),
    ('Taiga',6),
    ('Pantano',7),
    ('Nether',8),
    ('End',9);
	

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
	(15,'Recurso de creatura'),
--herramientas
	(8,'Construcción'),
	(5,'Defensa'),
	(6,'Construcción'),
	(10,'Construcción'),
	(9,'Defensa'),
	(7,'Defensa'),
	(3,'Construcción'),
	(4,'Defensa'),
	(9,'Defensa'),
	(6,'Decoración'),
	(6,'Construcción'),
	(9,'Construcción'),
	(8,'Construcción'),
	(5,'Decoración'),
	(6,'Decoración'),
	(3,'Construcción'),
	(10,'Construcción'),
	(8,'Construcción'),
	(2,'Apoyo'),
	(3,'Apoyo'),
	(9,'Decoración'),
	(8,'Apoyo'),
	(10,'Decoración'),
	(9,'Construcción'),
	(7,'Decoración'),
	(4,'Decoración'),
	(7,'Decoración'),
	(3,'Construcción'),
	(5,'Apoyo'),
	(3,'Apoyo');



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
	('Tijeras de Jardinero', 'Metal', 40),
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


INSERT INTO AldeanoProductos VALUES
	(1, 1, 20),
	(1, 2, 28),
	(1, 3, 6),
	(1, 4, 15),
	(2, 5, 45),
	(2, 6, 70),
	(2, 7, 113),
	(3, 8, 31),
	(3, 9, 48),
	(4, 10, 47),
	(4, 11, 87),
	(4, 12, 82),
	(4, 13, 58),
	(5, 14, 49),
	(5, 15, 79),
	(5, 16, 167),
	(6, 17, 181),
	(6, 18, 58),
	(7, 19, 69),
	(7, 20, 41),
	(7, 21, 96),
	(7, 22, 78),
	(8, 23, 26),
	(8, 24, 28),
	(8, 25, 68),
	(8, 26, 65),
	(9, 27, 58),
	(9, 28, 38),
	(9, 29, 39),
	(9, 30, 20),
	(1, 31, 85),
	(1, 32, 95),
	(1, 33, 110),
	(1, 34, 87),
	(2, 35, 69),
	(2, 36, 45),
	(2, 37, 58),
	(3, 38, 55),
	(3, 39, 34),
	(4, 40, 26),
	(4, 41, 79),
	(4, 42, 95),
	(4, 43, 89),
	(5, 44, 61),
	(5, 45, 84),
	(5, 46, 49),
	(6, 47, 55),
	(6, 48, 27),
	(7, 49, 68),
	(7, 50, 24),
	(7, 51, 83),
	(7, 52, 55),
	(8, 53, 22),
	(8, 54, 61),
	(8, 55, 89),
	(8, 56, 57),
	(9, 57, 23),
	(9, 58, 28),
	(9, 59, 96),
	(9, 60, 67);

--EJEMPLOS
INSERT INTO Compras (ID_Jugador, ID_Producto, Cantidad, FechaCompra) VALUES
	(29, 58, 2004,'2023-07-17'),
	(7, 17, 2,'2023-01-17');
	

INSERT INTO Ventas(ID_Jugador,ID_Producto,Cantidad,FechaVenta) values
(18,58,1,'2023-02-06');


INSERT INTO InventarioJugadores (ID_Jugador, ID_Producto, Cantidad) VALUES
	(1, 1, 2),
	(1, 2, 3),
	(10, 30, 5);

insert into InventarioJugadores values
	(7,40,5),
	(8,55,2);

insert into InventarioJugadores values
	(8,33,8);

insert into InventarioJugadores values
	(7,3,9);





EXEC ObtenerMaterialesPorRegion @ID_Region = 9;--estas 2 son de las tiendas de c region
EXEC ObtenerHerramientasPorRegion @ID_Region=2;

EXEC ObtenerProductosPorAldeano @ID_Aldeano=8;

--aqui son de busquedas
EXEC ObtenerProductosPorPrecio @Precio_Minimo=0;

EXEC ObtenerInformacionHerramientaPorNombre @Nombre_Herramienta='Pulidora';

EXEC ObtenerInformacionMaterialPorNombre @Nombre_Material='Slime';
--aca

EXEC ObtenerMaterialesEnInventarioJugador @ID_Jugador=8--estas 2 son de inventario
EXEC ObtenerHerramientasEnInventarioJugador @ID_Jugador=8;

--SELECT * FROM VistaAldeanoProductos; esta es la fea
SELECT * FROM VistaProductosPorAldeano;
SELECT * FROM VistaRegionesConAldeano;-- puede ser para sacar datos del aldeano con la region

SELECT * FROM VistaHerramientas;
SELECT * FROM VistaMateriales;

SELECT * FROM VistaInventarioJugadores;


select *from Jugadores
select *from InventarioJugadores
select *from Herramientas
select *from Compras
select *from ventas
select *from Regiones



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

--orden de lista
SELECT * FROM VistaInventarioJugadores;	--creditos, cambiar a jugadores
SELECT * FROM VistaProductosPorAldeano;	--igual en donde todos productos y herramientas
EXEC ObtenerProductosPorAldeano @ID_Aldeano=9; --igual en la tienda


SELECT * FROM VistaRegionesConAldeano;-- puede ser para sacar datos del aldeano con la region
select * from Aldeano 