CREATE DATABASE MINECRAFT;
USE MINECRAFT;
USE MASTER;
DROP DATABASE MINECRAFT;



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


-- Crear tabla Jugadores
CREATE TABLE Jugadores (
    ID_Jugador INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Jugador VARCHAR(20),
    Correo_Electronico VARCHAR(40) UNIQUE,
    Contraseña VARCHAR(255), -- Contraseña en texto plano
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


-- Crear la tabla de relaci�n AldeanoProductos (inventario de aldeanos)
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

--compra
CREATE TRIGGER VerificacionCompraInventario
ON Compras
AFTER INSERT
AS
BEGIN
    DECLARE @ID_Jugador INT, @ID_Producto INT, @Cantidad INT, @PrecioTotal INT, @ID_Aldeano INT;
    DECLARE compraCursor CURSOR FOR 
        SELECT ID_Jugador, ID_Producto, Cantidad
        FROM inserted;

    OPEN compraCursor;
    FETCH NEXT FROM compraCursor INTO @ID_Jugador, @ID_Producto, @Cantidad;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Obtener el ID_Aldeano directamente de la tabla AldeanoProductos
        SELECT @ID_Aldeano = AP.ID_Aldeano
        FROM AldeanoProductos AP
        WHERE AP.ID_Producto = @ID_Producto;

        -- Calcular el PrecioTotal en base al precio del producto y la cantidad comprada
        SELECT @PrecioTotal = Precio_Esmeralda * @Cantidad
        FROM Productos
        WHERE ID_Producto = @ID_Producto;

        -- Actualizar el saldo del jugador restando el PrecioTotal
        UPDATE Jugadores
        SET Saldo_Esmeraldas = Saldo_Esmeraldas - @PrecioTotal
        WHERE ID_Jugador = @ID_Jugador;

        -- Actualizar el salario del aldeano sumando el PrecioTotal
        UPDATE Aldeano
        SET Salario_Esmeraldas = Salario_Esmeraldas + @PrecioTotal
        WHERE ID_Aldeano = @ID_Aldeano;

        -- Actualizar o insertar la cantidad en el inventario del jugador
        MERGE INTO InventarioJugadores AS Target
        USING (VALUES (@ID_Jugador, @ID_Producto, @Cantidad)) AS Source (ID_Jugador, ID_Producto, Cantidad)
        ON Target.ID_Jugador = Source.ID_Jugador AND Target.ID_Producto = Source.ID_Producto
        WHEN MATCHED THEN
            UPDATE SET Target.Cantidad = Target.Cantidad + Source.Cantidad
        WHEN NOT MATCHED THEN
            INSERT (ID_Jugador, ID_Producto, Cantidad)
            VALUES (Source.ID_Jugador, Source.ID_Producto, Source.Cantidad);

        -- Restar la cantidad en el inventario del aldeano
        UPDATE AldeanoProductos
        SET Cantidad = Cantidad - @Cantidad
        WHERE ID_Aldeano = @ID_Aldeano AND ID_Producto = @ID_Producto;

        FETCH NEXT FROM compraCursor INTO @ID_Jugador, @ID_Producto, @Cantidad;
    END
    CLOSE compraCursor;
    DEALLOCATE compraCursor;
END;

--venta
CREATE TRIGGER VerificacionVentaInventario
ON Ventas
AFTER INSERT
AS
BEGIN
    DECLARE @ID_Jugador INT, @ID_Producto INT, @Cantidad INT, @PrecioTotal INT, @ID_Aldeano INT;
    DECLARE ventaCursor CURSOR FOR 
        SELECT ID_Jugador, ID_Producto, Cantidad
        FROM inserted;

    OPEN ventaCursor;
    FETCH NEXT FROM ventaCursor INTO @ID_Jugador, @ID_Producto, @Cantidad;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Obtener el ID_Aldeano directamente de la tabla AldeanoProductos
        SELECT @ID_Aldeano = AP.ID_Aldeano
        FROM AldeanoProductos AP
        WHERE AP.ID_Producto = @ID_Producto;

        -- Calcular el PrecioTotal en base al precio del producto y la cantidad vendida
        SELECT @PrecioTotal = Precio_Esmeralda * @Cantidad
        FROM Productos
        WHERE ID_Producto = @ID_Producto;

        -- Verificar que hay suficientes productos en el inventario del jugador
        IF NOT EXISTS (
            SELECT 1
            FROM InventarioJugadores ij
            WHERE ij.ID_Jugador = @ID_Jugador AND ij.ID_Producto = @ID_Producto AND ij.Cantidad >= @Cantidad
        )
        BEGIN
            THROW 1, 'No hay suficientes productos en el inventario del jugador para realizar la venta.', 1;
        END;

        -- Actualizar el saldo del jugador sumando el PrecioTotal
        UPDATE Jugadores
        SET Saldo_Esmeraldas = Saldo_Esmeraldas + @PrecioTotal
        WHERE ID_Jugador = @ID_Jugador;

        -- Actualizar el salario del aldeano restando el PrecioTotal
        UPDATE Aldeano
        SET Salario_Esmeraldas = Salario_Esmeraldas - @PrecioTotal
        WHERE ID_Aldeano = @ID_Aldeano;

        -- Restar la cantidad en el inventario del jugador
        UPDATE InventarioJugadores
        SET Cantidad = Cantidad - @Cantidad
        WHERE ID_Jugador = @ID_Jugador AND ID_Producto = @ID_Producto;

        -- Aumentar la cantidad en el inventario del aldeano
        UPDATE AldeanoProductos
        SET Cantidad = Cantidad + @Cantidad
        WHERE ID_Aldeano = @ID_Aldeano AND ID_Producto = @ID_Producto;

        FETCH NEXT FROM ventaCursor INTO @ID_Jugador, @ID_Producto, @Cantidad;
    END

    CLOSE ventaCursor;
    DEALLOCATE ventaCursor;
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
 -- Procedimiento almacenado para comprar material por nombre
 drop procedure ComprarHerramientaPorNombre
CREATE PROCEDURE ComprarHerramientaPorNombre
    @Nombre_Herramienta VARCHAR(50),
    @ID_Jugador INT,
    @Cantidad INT
AS
BEGIN
    DECLARE @ID_Producto INT;
    DECLARE @Precio_Esmeralda INT;
    DECLARE @SaldoActual INT;
    DECLARE @CostoTotal INT;
    DECLARE @CantidadDisponible INT;
    DECLARE @ID_Aldeano INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Buscar el ID y el precio del producto basado en el nombre de la herramienta
        SELECT @ID_Producto = H.ID_Producto, @Precio_Esmeralda = P.Precio_Esmeralda
        FROM Herramientas H
        INNER JOIN Productos P ON H.ID_Producto = P.ID_Producto
        WHERE H.Tipo_Herramienta = @Nombre_Herramienta;

        IF @ID_Producto IS NULL
        BEGIN
            RAISERROR('Herramienta no encontrada.', 16, 1);
            RETURN;
        END

        -- Obtener el ID del Aldeano y verificar la cantidad disponible
        SELECT @ID_Aldeano = AP.ID_Aldeano, @CantidadDisponible = AP.Cantidad
        FROM AldeanoProductos AP
        WHERE AP.ID_Producto = @ID_Producto;

        IF @CantidadDisponible < @Cantidad
        BEGIN
            RAISERROR('Cantidad insuficiente en el inventario del aldeano.', 16, 1);
            RETURN;
        END

        -- Calcular el costo total de la compra
        SET @CostoTotal = @Precio_Esmeralda * @Cantidad;

        -- Verificar el saldo del jugador
        SELECT @SaldoActual = Saldo_Esmeraldas FROM Jugadores WHERE ID_Jugador = @ID_Jugador;

        IF @SaldoActual < @CostoTotal
        BEGIN
            RAISERROR('Saldo insuficiente para realizar la compra.', 16, 1);
            RETURN;
        END

        -- Realizar la compra
        INSERT INTO Compras (ID_Jugador, ID_Producto, Cantidad, PrecioTotal, FechaCompra)
        VALUES (@ID_Jugador, @ID_Producto, @Cantidad, @CostoTotal, GETDATE());

        -- Actualizar el saldo del jugador
        /*
		UPDATE Jugadores
        SET Saldo_Esmeraldas = Saldo_Esmeraldas - @CostoTotal
        WHERE ID_Jugador = @ID_Jugador;

        -- Actualizar el inventario del aldeano
        UPDATE AldeanoProductos
        SET Cantidad = Cantidad - @Cantidad
        WHERE ID_Aldeano = @ID_Aldeano AND ID_Producto = @ID_Producto;
		*/
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR('Error al realizar la compra.', 16, 1);
    END CATCH
END;

EXEC ComprarHerramientaPorNombre 
    @Nombre_Herramienta = 'Pico de Hierro', 
    @ID_Jugador = 1, 
    @Cantidad = 2;

--verificacion
SELECT * FROM Compras
WHERE ID_Jugador = 1 
AND FechaCompra = CAST(GETDATE() AS DATE);


drop procedure ComprarMaterialPorNombre
CREATE PROCEDURE ComprarMaterialPorNombre
    @Nombre_Material VARCHAR(50),
    @ID_Jugador INT,
    @Cantidad INT
AS
BEGIN
    DECLARE @ID_Producto INT;
    DECLARE @Precio_Esmeralda INT;
    DECLARE @SaldoActual INT;
    DECLARE @CostoTotal INT;

    -- Buscar el ID y el precio del producto basado en el nombre del material
    SELECT @ID_Producto = M.ID_Producto, @Precio_Esmeralda = P.Precio_Esmeralda
    FROM Materiales M
    INNER JOIN Productos P ON M.ID_Producto = P.ID_Producto
    WHERE M.Tipo_Material = @Nombre_Material;

    IF @ID_Producto IS NULL
    BEGIN
        RAISERROR('Material no encontrado.', 16, 1);
        RETURN;
    END

    -- Calcular el costo total de la compra
    SET @CostoTotal = @Precio_Esmeralda * @Cantidad;

    -- Verificar el saldo del jugador
    SELECT @SaldoActual = Saldo_Esmeraldas FROM Jugadores WHERE ID_Jugador = @ID_Jugador;

    IF @SaldoActual < @CostoTotal
    BEGIN
        RAISERROR('Saldo insuficiente para realizar la compra.', 16, 1);
        RETURN;
    END

    -- Realizar la compra
    INSERT INTO Compras (ID_Jugador, ID_Producto, Cantidad, PrecioTotal, FechaCompra)
    VALUES (@ID_Jugador, @ID_Producto, @Cantidad, @CostoTotal, GETDATE());

    -- Actualizar el saldo del jugador
    /*UPDATE Jugadores
    SET Saldo_Esmeraldas = Saldo_Esmeraldas - @CostoTotal
    WHERE ID_Jugador = @ID_Jugador;
	*/
END;

EXEC ComprarMaterialPorNombre @Nombre_Material = 'Madera de roble', @ID_Jugador = 32, @Cantidad = 5;--750 
select *from Jugadores
select *from InventarioJugadores

SELECT * FROM Compras 
WHERE ID_Jugador = 1
AND FechaCompra = CAST(GETDATE() AS DATE);


 -- ver materiales por regi�n con ID de regi�n
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


-- Crear procedimiento almacenado con par�metro de ID de aldeano
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

--modificar usuario 

CREATE PROCEDURE ModificarUsuario
    @ID_Jugador INT,
    @NuevoNombre_Jugador VARCHAR(20) = NULL,
    @NuevoCorreo_Electronico VARCHAR(40) = NULL,
    @NuevaContraseña NVARCHAR(255) = NULL,
    @NuevoSaldo_Esmeraldas INT = NULL
AS
BEGIN
    IF @NuevoNombre_Jugador IS NOT NULL
        UPDATE Jugadores SET Nombre_Jugador = @NuevoNombre_Jugador WHERE ID_Jugador = @ID_Jugador;

    IF @NuevoCorreo_Electronico IS NOT NULL
        UPDATE Jugadores SET Correo_Electronico = @NuevoCorreo_Electronico WHERE ID_Jugador = @ID_Jugador;

    IF @NuevaContraseña IS NOT NULL
    BEGIN
        IF dbo.ValidarComplexityContraseña(@NuevaContraseña) = 0
            RAISERROR('La nueva contraseña no cumple con los requisitos de complejidad.', 16, 1);
        ELSE
            UPDATE Jugadores SET Contraseña = @NuevaContraseña WHERE ID_Jugador = @ID_Jugador;
    END

    IF @NuevoSaldo_Esmeraldas IS NOT NULL
        UPDATE Jugadores SET Saldo_Esmeraldas = @NuevoSaldo_Esmeraldas WHERE ID_Jugador = @ID_Jugador;
END;

--crear usuario

CREATE PROCEDURE CrearUsuario
    @Nombre_Jugador VARCHAR(20),
    @Correo_Electronico VARCHAR(40),
    @Contraseña NVARCHAR(255),
    @Saldo_Esmeraldas INT
AS
BEGIN
    IF dbo.ValidarComplexityContraseña(@Contraseña) = 0
        RAISERROR('La contraseña no cumple con los requisitos de complejidad.', 16, 1);
    ELSE
        INSERT INTO Jugadores (Nombre_Jugador, Correo_Electronico, Contraseña, Saldo_Esmeraldas)
        VALUES (@Nombre_Jugador, @Correo_Electronico, @Contraseña, @Saldo_Esmeraldas);
END;

--INSERCI�N DE DATOS
INSERT INTO Jugadores (Nombre_Jugador, Correo_Electronico, Contraseña, Saldo_Esmeraldas) 
VALUES
('Jugador1', 'jugador1@email.com', 'Pass1word', 100),
('Jugador2', 'jugador2@email.com', 'Pass2word', 200),
('Jugador3', 'jugador3@email.com', 'Pass3word', 300),
('Jugador4', 'jugador4@email.com', 'Pass4word', 400),
('Jugador5', 'jugador5@email.com', 'Pass5word', 500),
('Jugador6', 'jugador6@email.com', 'Pass6word', 600),
('Jugador7', 'jugador7@email.com', 'Pass7word', 700),
('Jugador8', 'jugador8@email.com', 'Pass8word', 800),
('Jugador9', 'jugador9@email.com', 'Pass9word', 900),
('Jugador10', 'jugador10@email.com', 'Pass10word', 1000),
('Jugador11', 'jugador11@email.com', 'Pass11word', 1100),
('Jugador12', 'jugador12@email.com', 'Pass12word', 1200),
('Jugador13', 'jugador13@email.com', 'Pass13word', 1300),
('Jugador14', 'jugador14@email.com', 'Pass14word', 1400),
('Jugador15', 'jugador15@email.com', 'Pass15word', 1500),
('Jugador16', 'jugador16@email.com', 'Pass16word', 1600),
('Jugador17', 'jugador17@email.com', 'Pass17word', 1700),
('Jugador18', 'jugador18@email.com', 'Pass18word', 1800),
('Jugador19', 'jugador19@email.com', 'Pass19word', 1900),
('Jugador20', 'jugador20@email.com', 'Pass20word', 2000),
('Jugador21', 'jugador21@email.com', 'Pass21word', 2100),
('Jugador22', 'jugador22@email.com', 'Pass22word', 2200),
('Jugador23', 'jugador23@email.com', 'Pass23word', 2300),
('Jugador24', 'jugador24@email.com', 'Pass24word', 2400),
('Jugador25', 'jugador25@email.com', 'Pass25word', 2500),
('Jugador26', 'jugador26@email.com', 'Pass26word', 2600),
('Jugador27', 'jugador27@email.com', 'Pass27word', 2700),
('Jugador28', 'jugador28@email.com', 'Pass28word', 2800),
('Jugador29', 'jugador29@email.com', 'Pass29word', 2900),
('Jugador30', 'jugador30@email.com', 'Pass30word', 3000);

select *from Jugadores
use MINECRAFT

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

select *from Regiones
ALTER TABLE Regiones ADD Descripciones nvarchar(300)

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


INSERT INTO Productos VALUES
--materiales
	(5,'Madera'),
	(5,'Madera'),
	(6,'Piel'),
	(8,'Piel'),
	(3,'Construcci�n'),
	(3,'Vegetaci�n'),
	(4,'Construcci�n'),
	(6,'Madera'),
	(4,'Artesan�a'),
	(7,'Madera'),
	(5,'Vegetaci�n'),
	(8,'Comida'),
	(3,'Comida'),
	(4,'Natural'),
	(5,'Construcci�n'),
	(9,'Comida'),
	(7,'Madera'),
	(6,'Comida'),
	(5,'Construcci�n'),
	(2,'Vegetaci�n'),
	(6,'Vegetaci�n'),
	(8,'Recurso de creatura'),
	(10,'Construcci�n'),
	(11,'Decoraci�n'),
	(11,'Decoraci�n'),
	(7,'Crafteo'),
	(11,'Vegetaci�n'),
	(13,'Decoraci�n'),
	(10,'Vegetaci�n'),
	(15,'Recurso de creatura'),
--herramientas
	(8,'Construcci�n'),
	(5,'Defensa'),
	(6,'Construcci�n'),
	(10,'Construcci�n'),
	(9,'Defensa'),
	(7,'Defensa'),
	(3,'Construcci�n'),
	(4,'Defensa'),
	(9,'Defensa'),
	(6,'Decoraci�n'),
	(6,'Construcci�n'),
	(9,'Construcci�n'),
	(8,'Construcci�n'),
	(5,'Decoraci�n'),
	(6,'Decoraci�n'),
	(3,'Construcci�n'),
	(10,'Construcci�n'),
	(8,'Construcci�n'),
	(2,'Apoyo'),
	(3,'Apoyo'),
	(9,'Decoraci�n'),
	(8,'Apoyo'),
	(10,'Decoraci�n'),
	(9,'Construcci�n'),
	(7,'Decoraci�n'),
	(4,'Decoraci�n'),
	(7,'Decoraci�n'),
	(3,'Construcci�n'),
	(5,'Apoyo'),
	(3,'Apoyo');

SELECT *FROM Productos;

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
	('Bamb�',11),
	('Cacao',12),
	('Mel�n',13),
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
	('Taladro El�ctrico', 'Cobre', 47),
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
	('Paleta de Alba�il', 'Acero', 58),
	('Flex�metro', 'Metal', 59),
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
-- Inserciones de compras 
INSERT INTO Compras (ID_Jugador, ID_Producto, Cantidad, FechaCompra) VALUES
(29, 58, 2004, '2023-07-17'),
(7, 17, 2, '2023-01-17'),
(1, 1, 3, '2023-01-18'),
(2, 2, 4, '2023-01-19'),
(3, 3, 1, '2023-01-20'),
(4, 4, 2, '2023-01-21'),
(5, 5, 3, '2023-01-22'),
(6, 6, 4, '2023-01-23'),
(8, 8, 1, '2023-01-24'),
(9, 9, 2, '2023-01-25'),
(10, 10, 3, '2023-01-26'),
(11, 11, 4, '2023-01-27'),
(12, 12, 1, '2023-01-28'),
(13, 13, 2, '2023-01-29'),
(14, 14, 3, '2023-01-30'),
(15, 15, 4, '2023-01-31'),
(16, 16, 1, '2023-02-01'),
(17, 17, 2, '2023-02-02'),
(18, 18, 3, '2023-02-03'),
(19, 19, 4, '2023-02-04'),
(20, 20, 1, '2023-02-05'),
(21, 21, 2, '2023-02-06'),
(22, 22, 3, '2023-02-07'),
(23, 23, 4, '2023-02-08'),
(24, 24, 1, '2023-02-09'),
(25, 25, 2, '2023-02-10'),
(26, 26, 3, '2023-02-11'),
(27, 27, 4, '2023-02-12'),
(28, 28, 1, '2023-02-13'),
(30, 30, 2, '2023-02-14');

-- ventas
INSERT INTO Ventas (ID_Jugador, ID_Producto, Cantidad, FechaVenta) VALUES
(18, 58, 1, '2023-02-06'), 
(1, 1, 2, '2023-01-06'),
(2, 2, 3, '2023-01-07'),
(3, 3, 1, '2023-01-08'),
(4, 4, 2, '2023-01-09'),
(5, 5, 1, '2023-01-10'),
(6, 6, 2, '2023-01-11'),
(7, 7, 1, '2023-01-12'),
(8, 8, 2, '2023-01-13'),
(9, 9, 1, '2023-01-14'),
(10, 10, 2, '2023-01-15'),
(11, 11, 1, '2023-01-16'),
(12, 12, 2, '2023-01-17'),
(13, 13, 1, '2023-01-18'),
(14, 14, 2, '2023-01-19'),
(15, 15, 1, '2023-01-20'),
(16, 16, 2, '2023-01-21'),
(17, 17, 1, '2023-01-22'),
(19, 19, 2, '2023-01-23'),
(20, 20, 1, '2023-01-24'),
(21, 21, 2, '2023-01-25'),
(22, 22, 1, '2023-01-26'),
(23, 23, 2, '2023-01-27'),
(24, 24, 1, '2023-01-28'),
(25, 25, 2, '2023-01-29'),
(26, 26, 1, '2023-01-30'),
(27, 27, 2, '2023-01-31'),
(28, 28, 1, '2023-02-01'),
(29, 29, 2, '2023-02-02'),
(30, 30, 1, '2023-02-03');


-- Insertar 15 herramientas, cada una para un jugador diferente
INSERT INTO InventarioJugadores (ID_Jugador, ID_Producto, Cantidad) VALUES
(1, 31, 1),  -- Pico de Hierro para Jugador 1
(2, 32, 1),  -- Espada de Madera para Jugador 2
(3, 33, 1),  -- Hacha de Piedra para Jugador 3
(4, 34, 1),  -- Pala de Oro para Jugador 4
(5, 35, 1),  -- Arco y Flecha para Jugador 5
(6, 36, 1),  -- Lanza de Diamante para Jugador 6
(7, 37, 1),  -- Mazo de Acero para Jugador 7
(8, 38, 1),  -- Cuchillo de Caza para Jugador 8
(9, 39, 1),  -- Azada de Bronce para Jugador 9
(10, 40, 1), -- Tijeras de Jardinero para Jugador 10
(11, 41, 1), -- Martillo de Herrero para Jugador 11
(12, 42, 1), -- Sierra de Madera para Jugador 12
(13, 43, 1), -- Destornillador para Jugador 13
(14, 44, 1), -- Pinzas para Jugador 14
(15, 45, 1), -- Cincel para Jugador 15
-- Insertar 15 materiales, cada uno para un jugador diferente
(1, 1, 1), 
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 1),
(10, 10, 1),
(11, 11, 1),
(12, 12, 1),
(13, 13, 1),
(14, 14, 1),
(15, 15, 1);



EXEC ObtenerMaterialesPorRegion @ID_Region = 9;

EXEC ObtenerHerramientasPorRegion @ID_Region=2;

EXEC ObtenerProductosPorAldeano @ID_Aldeano=8;

EXEC ObtenerProductosPorPrecio @Precio_Minimo=10;

EXEC ObtenerInformacionHerramientaPorNombre @Nombre_Herramienta='Pulidora';

EXEC ObtenerInformacionMaterialPorNombre @Nombre_Material='Slime';

EXEC ObtenerMaterialesEnInventarioJugador @ID_Jugador=32;

EXEC ObtenerHerramientasEnInventarioJugador @ID_Jugador=32;

SELECT * FROM VistaAldeanoProductos;

SELECT * FROM VistaHerramientas;

SELECT * FROM VistaMateriales;

SELECT * FROM VistaInventarioJugadores;

SELECT * FROM VistaProductosPorAldeano;

SELECT * FROM VistaRegionesConAldeano;

select *from Jugadores
select*from Materiales
select *from Herramientas
select *from Compras
select *from AldeanoProductos
select *from Productos