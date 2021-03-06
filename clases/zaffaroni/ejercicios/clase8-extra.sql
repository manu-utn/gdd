-- Retornamos un resultado
IF OBJECT_ID('suma1') IS NOT NULL
	DROP PROCEDURE dbo.suma1
GO

CREATE PROCEDURE suma1 @var1 INT
AS
DECLARE @var2 INT
SET @var2 = @var1 + 1;
RETURN @var2
GO

DECLARE @resultado INT
EXECUTE @resultado = suma1 2 -- también funciona con "exec"
--PRINT @resultado
SELECT @resultado
GO

-------------------------------------------------------------------------

/*
 * Ponemos OUT cuando creamos el SP y cuando lo invocamos también
 * en el segundo parametro
 */

IF OBJECT_ID('suma2') IS NOT NULL
	DROP PROCEDURE dbo.suma2
GO

CREATE PROCEDURE suma2 @var1 INT, @var2 INT OUT
AS
SET @var2 = @var1 + 1;
GO

-- Modifico el anterior Store Procedure
ALTER PROCEDURE suma2 @var1 INT, @var2 INT OUT
AS
DECLARE @var3 INT;
SET @var3 = @var1 + 10;
SET @var2 = @var3;
GO

DECLARE @resultado INT
EXECUTE suma2 2, @resultado OUT
--PRINT @resultado
SELECT @resultado
GO

-------------------------------------------------------------------------

-- Invocamos un SP dentro de otro SP

IF OBJECT_ID('suma3') IS NOT NULL
	DROP PROCEDURE dbo.suma3
GO

CREATE PROCEDURE suma3 @var1 INT, @var2 INT OUT
AS
EXECUTE suma2 @var1, @var2 OUT -- invoco a otro SP, y me modifica @var2
GO

DECLARE @resultado INT
EXECUTE suma3 10, @resultado OUT
--PRINT @resultado
SELECT @resultado
GO

-------------------------------------------------------------------------

IF OBJECT_ID('eldoble') IS NOT NULL 
	DROP FUNCTION dbo.eldoble
GO

CREATE FUNCTION eldoble (@var1 DECIMAL(6,2))
RETURNS DECIMAL(6,2)
AS
BEGIN
	DECLARE @var2 DECIMAL(6,2);
	SET @var2 = @var1 * 2;
	RETURN @var2;
END
GO

select dbo.eldoble(2)
GO

USE stores7new

SELECT stock_num, dbo.eldoble(unit_price) FROM dbo.products p

-------------------------------------------------------------------------
-- asignacion de valores a variables

DECLARE @unavariable INT;
SET @unavariable = 5 -- alternativa: SELECT @unavariable = 5
SELECT @unavariable

-- 1. declaramos @var1 y le asignamos 'hola',
DECLARE @var1 VARCHAR(20) SET @var1='hola'
-- 2. le cambiamos el valor a @var1 por el que devuelva el select
-- (Obs: tanto el SET como SELECT sirven para cambiar el valor)
SELECT @var1 = c.lname  FROM dbo.customer c WHERE c.customer_num=101
-- 3. chequeamos el valor
PRINT @var1
GO

-------------------------------------------------------------------------

DECLARE @var1 INT
SET @var1 = 1

IF(@var1 > 3)
	BEGIN 
		PRINT 'hola'
	END
ELSE
	BEGIN
		PRINT 'chau'
	END
GO

-------------------------------------------------------------------------
-- expresiones en una sentencia IF
-- usamos IF EXISTS

DECLARE @ciudad VARCHAR(20)
SET @ciudad='Palo Alto'
SELECT c.city  FROM dbo.customer c WHERE city=@ciudad
GO

DECLARE @ciudad VARCHAR(20)
SET @ciudad='Palo Alto'


IF EXISTS(SELECT c.city  FROM dbo.customer c WHERE city=@ciudad)
	BEGIN
	PRINT 'La ciudad existe..! :)'
	END
ELSE
	BEGIN
	PRINT 'La ciudad NO existe..! Me engañaste! :('
	END
GO
-------------------------------------------------------------------------
-- SENTENCIA CASE
-- DUDA: Que diferencia hay entre dejar a Fabricante con o sin comillas?
-- porque con o sin, ambas funcionan

SELECT 'Fabricante'=CASE manu_code
	WHEN 'HRO' THEN 'HERO'
	WHEN 'HSK' THEN 'HUSKY'
	ELSE 'OTRO'
	END,
unit_price, unit_code FROM dbo.products
GO

-------------------------------------------------------------------------
-- SELECT con SENTENCIA CASE de Busqueda
SELECT stock_num, manu_code,
'Criterio Precio' =
	CASE
	WHEN unit_price = 0 THEN  'SIN PRECIO'
	WHEN unit_price < 50 THEN 'SAFA'
	WHEN unit_price < 100 THEN 'ESTAFA'
	WHEN unit_price BETWEEN 150 AND 200 THEN 'NI LOCO'
	ELSE 'NI MIRO'
	END
 FROM dbo.products
 ORDER BY 'Criterio Precio', stock_num
GO

-------------------------------------------------------------------------
-- SENTENCIA CASE en un ORDER BY

SELECT stock_num, manu_code, unit_price
FROM products
WHERE manu_code IN ('HRO', 'HSK')
ORDER BY CASE WHEN manu_code='HRO' THEN stock_num END ASC,
		 CASE WHEN manu_code='HSK' THEN unit_price END DESC;

-- DUDA: en la ppt solo aparecia la anterior,
-- esta otra tambien funciona, pero NO te permite
-- ordenar por cada columna, solo despues del END.
-- La duda es, es valida?
SELECT stock_num, manu_code, unit_price 
FROM products
WHERE manu_code IN ('HRO', 'HSK')
ORDER BY CASE
		 WHEN manu_code='HRO' THEN stock_num
		 WHEN manu_code='HSK' THEN unit_price
		 END ASC;

-------------------------------------------------------------------------
-- SENTENCIA CASE en un UPDATE

-- creamos una tabla temporal, para no afectar la original
SELECT * INTO #tablaTemporal FROM products;
-- y chequeamos que exista y esten los registros
SELECT * FROM #tablaTemporal;

UPDATE #tablaTemporal
SET unit_price=(
	CASE WHEN unit_price < 100 THEN unit_price*1.10 -- aumentamos un 10%
		  WHEN unit_price < 200 THEN unit_price*1.20 -- aumentamos un 20%
	ELSE unit_price*1.50 -- aumentamos el valor un 50%
	END
) WHERE manu_code='HRO';

-- comparamos las diferencias
SELECT * FROM products WHERE manu_code='HRO';
SELECT * FROM #tablaTemporal WHERE manu_code='HRO';

-------------------------------------------------------------------------
-- SENTENCIA CASE en la instrucción SET
-- Suponiendo que tenemos varias base de datos...

DECLARE @cod_empleado INT;

SET @TipoContacto=
CASE
	WHEN EXISTS(SELECT * FROM Ventas.empleados v
				WHERE v.cod_empleado=@cod_empleado)
				THEN 'Empresario'
	WHEN EXISTS(SELECT * FROM Compras.empleados c
				WHERE c.cod_empleado=@cod_empleado
				THEN 'Vendedor')
	END;

-------------------------------------------------------------------------
-- SENTENCIAS CICLICAS

IF OBJECT_ID('TablaTemporal') IS NOT NULL
	DROP TABLE #TablaTemporal

SELECT * INTO #TablaTemporal
FROM dbo.products

SELECT * FROM #TablaTemporal

-- Mientras el promedio de todos los precios sea menor  a 900
-- segui iterando
WHILE (SELECT AVG(unit_price) FROM #TablaTemporal) < 1000
	BEGIN
		-- aumentamos todos los precios en un 10%
		UPDATE #TablaTemporal SET unit_price = unit_price*1.10
		-- si algun registro supera los 1500, cortamos
		IF (SELECT MAX(unit_price) FROM #TablaTemporal) > 4500
			BREAK
		ELSE
			PRINT 'Estamos actualizando los precios..'
	END
	PRINT 'Se actualizaron todos los precios!' -- termina el ciclo
GO

-------------------------------------------------------------------------
-- CURSORES (Ejercicio 1 de la guia)

-- creamos la tabla a modo de utilizar el SP
CREATE TABLE customerStatistics(
	customer_num INT PRIMARY KEY,
	ordersqty INT,
	maxdate Date,
	uniqueProducts INT
);
-- Chequemos que se haya creado
SELECT * FROM dbo.customerStatistics;
GO -- agregamos este GO ara que el sig. SP sea la unica instruccion del lote (tambien conocido por Batch)

CREATE PROCEDURE actualizaEstadisticas  @customer_numDESDE INT, @customer_numHASTA INT 
AS 
BEGIN 
	-- 1. Declara el cursor, le asocia la consulta SELECT (que tiene solo 1 columna)
	-- (utiliza los parametros como filtro en la clausula WHERE)
	DECLARE CustomerCursor CURSOR FOR 		
		SELECT customer_num FROM customer WHERE customer_num BETWEEN @customer_numDESDE AND @customer_numHASTA  

	DECLARE  @customer_num INT, @ordersqty INT, @maxdate DATETIME,  @uniqueManufact INT -- declara algunas variables locales
	-- 2. Abre el cursor
	OPEN CustomerCursor
	-- 3. Obtiene el primer registro del SELECT asociado al cursor, y guarda el dato de la unica columna del SELECT en la variable declarada (customer_num)
	FETCH NEXT FROM CustomerCursor INTO @customer_num 
	-- 4. Mientras hayan registros itera (la condicion de corte es cuando la variable global fetch_status sea distinto de cero)
	WHILE @@FETCH_STATUS = 0 
		-- inicia un "Bloque explicito" con BEGIN...END, para ejecutar varias queries
		BEGIN     
			-- # Consulta nro 1:
			-- obtiene de un cliente especifico (el que se paso por parametro en el SP):
			-- la fecha del ultimo pedido y lo guarda en la variable local @ordersqty
			-- y la cant. de pedidos que hizo y lo guarda en la variable local @maxDate
			SELECT @ordersqty=count(*) , @maxDate=max(order_date) FROM orders WHERE customer_num = @customer_num;  
			
			-- # Consulta nro 2:
			-- selecciona  la cantidad de fabricantes, asociando los productos que ordeno el cliente especifico en cada pedido
			-- y los guarda en la variable local @uniqueManufact
			-- Obs: Ojo...! Porque esta haciendo una query de producto cartesiano.. (NO son performantes)
			SELECT @uniqueManufact=count(distinct stock_num)  FROM items i, orders o
			WHERE o.customer_num = @customer_num  AND o.order_num = i.order_num;
 
            -- # Consulta nro 3:
			-- si el registro del cliente especifico, no aparece en la tabla,
			-- entonces inserta un registro con los datos almacenados en las variables locales  @ordersQty, @maxDate, @uniqueManufact
			-- (Obs: Ojo con el orden de los values, la tabla debe haber sido creada con las columnas en ese orden
			-- a menos que.. pongamos los nombres de las columnas previo al nombre de la tabla donde se insertan los registros)
			IF NOT EXISTS( SELECT 1 FROM CustomerStatistics WHERE customer_num = @customer_num) 
				insert into customerStatistics values (@customer_num,@ordersQty, @maxDate,@uniqueManufact);
			-- # Consulta nro 4:
			-- si el registro ya existe, osea ya fue insertado,
			-- entonces actualizamos ese registro con los valores almacenados en las variables locales @ordersQty, @maxDate, @uniqueManufact
			ELSE 
				UPDATE customerStatistics SET  ordersQty=@ordersQty,maxDate=@maxDate, uniqueProducts=@uniqueManufact 
				WHERE customer_num = @customer_num; 

		    -- 5. Avanza al siguiente registro (este FETCH debe ser identico al anterior, al que se usa para obtener el primer registro)
			FETCH NEXT FROM CustomerCursor INTO @customer_num 
		END; -- aca termina el "bloque explicito"
	-- 6. Cierra el cursor, elimina la referencia al cursor, y lo desaloja el proceso de la memoria (liberando los recursos que utilizaba)
	CLOSE CustomerCursor; 
	DEALLOCATE CustomerCursor; 
END

SELECT * FROM dbo.customer;					-- revisamos que clientes hay, para sacar el customer_num y pasar esos valores como parametro al SP
EXECUTE dbo.actualizaEstadisticas 101,110;	-- ejecutamos el (SP, store procedure) y.. deberia insertar registros y/o actualizar la tabla customerStatistics
SELECT * FROM dbo.customerStatistics;		-- verificamos que hayan habido cambios luego de ejecutar el SP

-----------------------------------
-- ejemplo cursores
CREATE TABLE #ITEMS (ITEM_ID uniqueidentifier NOT NULL, ITEM_DESCRIPTION VARCHAR(250) NOT NULL)
INSERT INTO #ITEMS
VALUES
(NEWID(), 'This is a wonderful car'),
(NEWID(), 'This is a fast bike'),
(NEWID(), 'This is a expensive aeroplane'),
(NEWID(), 'This is a cheap bicycle'),
(NEWID(), 'This is a dream holiday')

-- (Declaramos una variable que contendra el ID de cada fila)
-- (Obs #1: Tendra que haber tantas variables declaradas, como columnas de la consulta
-- asociada al cursor)
DECLARE @ITEM_ID uniqueidentifier
-- 1. Declaramos el cursor, y le asociamos la consulta SELECT con la que iterara
-- (en este ejemplo, la consulta tendrá solo 1 columna)
DECLARE ITEM_CURSOR CURSOR FOR         -- declaracion del cursor
SELECT ITEM_ID FROM #ITEMS             -- consulta SELECT asociada al cursor
-- 2. Cargamos los resultados a memoria
-- (ademas ejecuta la consulta SELECT asociada al cursor)
OPEN ITEM_CURSOR
-- 3. Obtenemos (fetch) el primer resultado
-- (Obs: Copiamos el resultado solo a 1 variable, pero si el SELECT del cursor
-- tuviera mas columnas, tendriamos que agregarlas en el INTO en el mismo orden)
FETCH NEXT FROM ITEM_CURSOR           -- FETCH: obtenemos el sig. resultado
INTO @ITEM_ID                         -- INTO: lo copiamos a una variable (podrian ser a mas)
-- 4. Si hay resultados para operar, sigue iterando
-- (Evalua si la lectura del sig. registro es valida, si es asi el valor es cero,
-- recordemos que @@ es para variables globales)
WHILE @@FETCH_STATUS = 0
	-- agregamos un bloque con BEGIN...END, con la consulta que queramos
	BEGIN
	SELECT ITEM_DESCRIPTION FROM #ITEMS
	WHERE ITEM_ID = @ITEM_ID -- In regards to our latest fetched ID
	 -- 5. Cuando terminó de ejecutar la consulta, continúa con el siguiente
	FETCH NEXT FROM ITEM_CURSOR INTO @ITEM_ID
	END
-- 6. Finaliza cuando @@FETCH_STATUS indica que no hay más esultados 
-- (se liberan los registros tomados por el cursor, no se pueden seguir usando
-- a menos que se reabra el cursor)
CLOSE ITEM_CURSOR  
-- 7. Se libera los datos de memoria y se limpia el proceso
-- (se elimina la referencia al cursor)
DEALLOCATE ITEM_CURSOR

-----------------------------------
-- Ejemplo 2 - CURSORES

USE stores7new

SELECT * FROM dbo.customer;
/*
* - Cursor: ClienteInfo
* - Variables donde guardar los datos: @Cliente
* - Query asociada al Cusor: SELECT fname+','lname FROM dbo.customer 
*/
-- 1. Declaramos las variables donde guardaremos datos de las columnas
DECLARE @ClienteCod SMALLINT, @ClienteNomApe VARCHAR(40)
-- 2. Declaramos el cursor, y le asociamos una query SELECT
DECLARE ClienteInfo CURSOR FOR
SELECT customer_num, fname+','+lname FROM dbo.customer
-- 3. Abrimos el cursor
OPEN ClienteInfo
-- 4. Obtenemos el primer registro de la consulta asociada al cursor
-- y guardamos el resultado de las columnas en la variables declaradas
-- (en el mismo orden que la consulta SELECT)
FETCH NEXT FROM ClienteInfo INTO @ClienteCod, @ClienteNomApe
-- 5. Iteramos mientras hayan registros
-- (la condicion de corte es cuando sea distinto de cero)
WHILE @@FETCH_STATUS=0
	BEGIN
		--PRINT CAST(@ClienteCod as VARCHAR(10))+ ':'+@ClienteNomApe
		PRINT CONVERT(VARCHAR(10), @ClienteCod)+ ':'+@ClienteNomApe
		-- en cada iteracion, pedimos el siguiente registro
		FETCH NEXT FROM ClienteInfo INTO @ClienteCod, @ClienteNomApe
	END
-- 6. Cerramos y desalojamos el cursor
-- (se borra la referencia al cursor, se liberan los recursos asignados al proceso, se desloja el proceso de la memoria)
CLOSE ClienteInfo
DEALLOCATE ClienteInfo
GO
-- Obs: Con GO hacemos que las instrucciones anteriores sean atomicas, y me permite volver a declarar variables con mismo nombre


-------------------------------------------------------------------------------

--- Ejemplo similar al anterior pero con STORE PROCEDURE
-- hacemos algunas tablas temporales para trabajar

IF OBJECT_ID('tmpdb..#clientes') IS NOT NULL -- NO FUNCIONA ESTE IF...!
	DROP TABLE #clientes 
SELECT c.customer_num, c.fname, c.address1  INTO #clientes FROM dbo.customer c;
SELECT * FROM #clientes

IF OBJECT_ID('tmpdb..#clientesPremium') IS NOT NULL
	DROP TABLE #clientesPremium
-- con el condicional 1=0, hacemos que se cree la tabla temporal sin registros, solo la estructura 
SELECT c.customer_num, c.fname, c.address1 INTO #clientesPremium FROM dbo.customer c WHERE 1=0;
SELECT * FROM #clientesPremium
GO

-- Descomentamos este alter y comentamos el create, en caso que no queramos borrar el SP y crearlo again
--ALTER PROCEDURE mejoresClientes @Cliente_CodDesde SMALLINT, @Cliente_CodHasta SMALLINT
CREATE PROCEDURE mejoresClientes @Cliente_CodDesde SMALLINT, @Cliente_CodHasta SMALLINT AS
	DECLARE @ClienteNum SMALLINT
	DECLARE @ClienteNom VARCHAR(20), @ClienteDir VARCHAR(20)
	DECLARE ClienteInfo CURSOR FOR SELECT customer_num, fname, address1 FROM #clientes

	OPEN ClienteInfo
	FETCH NEXT FROM ClienteInfo INTO @ClienteNum, @ClienteNom, @ClienteDir
	WHILE @@FETCH_STATUS=0
		BEGIN
			PRINT @ClienteNom+', '+@ClienteDir
			INSERT INTO #clientesPremium VALUES (@ClienteNum, @ClienteNom, @ClienteDir)
			FETCH NEXT FROM ClienteInfo INTO @ClienteNum, @ClienteNom, @ClienteDir
		END
	CLOSE ClienteInfo
	DEALLOCATE ClienteInfo
GO

EXECUTE dbo.mejoresClientes 101, 110
SELECT * FROM #clientesPremium

-------------------------------------------------------------------------------

-- IDENTITY
-- Reutilizamos el ejemplo anterior

-- modificamos la tabla, agregando una columna nueva con IDENTITY que incremente de 1 en 1
ALTER TABLE #clientesPremium
ADD idCliente INT IDENTITY(1,1) 
GO

SELECT * FROM #clientesPremium -- chequemos que se agregó la columna

INSERT INTO #clientesPremium (customer_num, fname, address1) VALUES (900, 'pedrito', 'Viamonte 955')
GO
DECLARE @idNuevoCliente INT
-- Alternativa a la variable global @@IDENTITY ...?
-- Seria usar SCOPE_IDENTITY() que obtiene obtiene la del ambito actual
SET @idNuevoCliente = @@IDENTITY 
SELECT @idNuevoCliente
GO

-- modificamos la tabla
-- y borramos la nueva la columna  que tenia IDENTITY
ALTER TABLE #clientesPremium
DROP Column idCliente  -- suponiendo si queremos borrar la columna..
GO

SELECT * FROM #clientesPremium -- chequemos que se borró la columna
GO
-------------------------------------------------------------------------------
-- TRANSACCIONES, STORE PROCEDURES

-- volvemos a reutilizar el ejemplo anterior de #clientes

IF OBJECT_ID('borrar_clientes') IS NOT NULL
	DROP PROCEDURE borrar_clientes
GO

CREATE PROCEDURE borrar_clientes @ClienteNumDesde INT, @ClienteNumHasta INT
AS
	BEGIN TRANSACTION
		UPDATE #clientes SET fname=fname+' MOROSO' 
		WHERE customer_num BETWEEN @ClienteNumDesde AND @ClienteNumHasta

		IF (MONTH(getdate()) < 12)
			COMMIT TRANSACTION			
		ELSE
			ROLLBACK TRANSACTION
GO

SELECT * FROM #clientes					-- seleccionamos antes del sp
EXECUTE dbo.borrar_clientes 101, 105	-- ejecutamos el store procedure
SELECT * FROM #clientes					-- evaluamos si hubo cambios luego de ejecutar el sp
GO

-------------------------------------------------------------------------------
-- TRANSACCIONES Y MANEJO DE EXCEPCIONES

SELECT * FROM #clientes;
-- intentamos insertar varias veces un registro con igual valor,
-- en la primera columna que "aun" no es PK, por tanto no habra problema
INSERT INTO #clientes (customer_num, fname, address1) VALUES (900, 'pedrito', 'Viamonte 955')
INSERT INTO #clientes (customer_num, fname, address1) VALUES (900, 'pedrito', 'Viamonte 955')
INSERT INTO #clientes (customer_num, fname, address1) VALUES (900, 'pedrito', 'Viamonte 955')

-- borramos los registros repetidos, porque sino no podremos 
-- hacer la primera columna como PK, dirá que hay registros repetidos
DELETE #clientes WHERE customer_num=900

-- le agregamos la constraint de PK, a la columna customer_num
ALTER TABLE #clientes 
ADD PRIMARY KEY (customer_num);

BEGIN TRY -- "intentamos" ejecutar la siguiente transaccion, que tiene varios INSERT
	BEGIN TRANSACTION
	-- ahora.. si intentamos insertar varios registros, con mismo valor en la columna que es PK, fallara..!
	INSERT INTO #clientes (customer_num, fname, address1) VALUES (900, 'pedrito', 'Viamonte 955')
	INSERT INTO #clientes (customer_num, fname, address1) VALUES (900, 'pedrito', 'Viamonte 955')
	INSERT INTO #clientes (customer_num, fname, address1) VALUES (900, 'pedrito', 'Viamonte 955')
	COMMIT TRANSACTION
END TRY
BEGIN CATCH -- capturamos la excepción
	PRINT 'ERROR..! REGISTROS CON PK REPETIDA!! >:('
END CATCH


