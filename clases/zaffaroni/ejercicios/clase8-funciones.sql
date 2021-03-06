/*
 * Clase 08 - Funciones
 *
 * Ejercicio 1:
 * 1. Al final de los CASE agregar el END
 * 2. Al cambiar e valor de una variable, usar SET ó SELECT
 *
 *
 * Ejercicio 2:
 * 1. Definir los bloques explicitos entre los IF/ELSE con BEGIN/END
 * 2. Asignarle a una variable declarada el valor de las columnas de las
 *    queries dentro de una función (si no jode que no pueden devolver resultado)
 * 4. Al concatenar valores de columnas, declara variables VARCHAR para guardarlas
 *    porque.. si es un tipo numerico, no vas a concatenar :)
 * 5. Poner un alias a las columnas de la subqueries de FROM, porque .. al tratar de agarrar las columnas
 *    estas vendran sin alias.. :(
 * 6. Solo puede haber un retorno, asi que.. si declaras tu @RETORNO te confundis menos..
 * 7. COALESCE, sirve para reemplazar el valor NULO por otro (Ej. mostrar el 0 para los productos que tengan precio NULL)
 *
 * Ejercicio 3:
 * 1. Para concatenar valores de un CURSOR, podes declararlo fuera del mismo, porque cuando se cierra y se desaloca, se pierde lo que tenga
 * */

-- Ejercicio 1
GO
SELECT o.order_num, o.order_date,
	'dia semana' = CASE
		WHEN state='CA' THEN dbo.dia_orden_no_paga(order_date, 'en')
		ELSE dbo.dia_orden_no_paga(order_date, 'es')
		end
FROM orders o
JOIN customer c ON c.customer_num=o.customer_num
WHERE paid_date IS NULL
GO

DROP FUNCTION dia_orden_no_paga

GO
CREATE FUNCTION dia_orden_no_paga (@fecha DATETIME, @idioma VARCHAR(20))
RETURNS VARCHAR(20)
BEGIN
	DECLARE @dia_semana DATETIME, @dia_semana2 VARCHAR(20)

	SET @dia_semana = datepart(weekday, @fecha);

	IF(@idioma = 'CA')
	BEGIN
		-- no olvidarse de set cuando cambias el valor
		SET @dia_semana2 = CASE @dia_semana
		WHEN 1 THEN 'SA' WHEN 2 THEN 'MO' WHEN 3 THEN 'TU'
		WHEN 4 THEN 'WE' WHEN 5 THEN 'TH' WHEN 6 THEN 'FR'
		WHEN 7 THEN 'SU'
		end -- end del case
	END
	ELSE
	BEGIN
		 -- no olvidarse de set cuando cambias el valor
		SET @dia_semana2 = CASE @dia_semana
		WHEN 1 THEN 'DO' WHEN 2 THEN 'LU' WHEN 3 THEN 'MA'
		WHEN 4 THEN 'MI' WHEN 5 THEN 'JU' WHEN 6 THEN 'VI'
		WHEN 7 THEN 'SA'
		end -- end del case
	END

	RETURN @dia_semana2
END
GO

/*
DECLARE @fecha datetime
SET @fecha = '2015-05-16 00:00:00'
SELECT DATEPART(year, @fecha)
*/

-- Ejercicio 2
GO
SELECT customer_num, orden_mayor_carga_mes(1, customer_num), orden_mayor_carga_mes(2, customer_num)
FROM orders o1 WHERE EXISTS(
	SELECT customer_num FROM orders o2
	WHERE (o2.customer_num=o1.customer_num AND o1.order_num!=o2.order_num)
)
--FROM customer c
--JOIN orders o1 ON o1.customer_num=c.customer_num
--JOIN orders o2 ON (o2.customer_num=c.customer_num AND o1.order_num!=o2.order_num)
GO
/*
SELECT TOP 1 COALESCE(MAX(ship_charge), 0) 'carga', MONTH(ship_date) 'mes'
FROM orders
GROUP BY MONTH(ship_date)
ORDER BY 2 DESC;
*/

GO
CREATE FUNCTION dbo.orden_mayor_carga_mes (@orden INT, @customer_num SMALLINT)
RETURNS VARCHAR(100) AS
BEGIN
	DECLARE @RETORNO VARCHAR(100)
	DECLARE @fecha_anio VARCHAR(4), @fecha_mes VARCHAR(10)
	DECLARE @cantidad_carga VARCHAR(50)

	IF(@orden = 1)
		BEGIN
			SELECT TOP 1 @cantidad_carga=COALESCE(MAX(ship_charge), 0), @fecha_mes=MONTH(ship_date)
			FROM orders
			WHERE customer_num=@customer_num
			GROUP BY MONTH(ship_date)
			ORDER BY MAX(ship_charge) DESC;

			SET @RETORNO = '- Total:'+@cantidad_carga+' '+@fecha_mes
		END
	ELSE
		BEGIN
			SELECT TOP 1
			@cantidad_carga=COALESCE(ship_charge, 0), @fecha_mes=MONTH(ship_date)
			FROM (
				SELECT TOP 2 MAX(ship_charge) ship_charge, MONTH(ship_date) ship_date
				FROM orders
				WHERE customer_num=@customer_num
				GROUP BY MONTH(ship_date)
				ORDER BY MAX(ship_charge) DESC
			) as t

			SET @RETORNO = '- Total:'+@cantidad_carga+' '+@fecha_mes
		END

	RETURN @RETORNO
END
GO

-- Ejercicio 3
--SELECT [dbo].[lista_fabricantes_producto] (1)

SELECT DISTINCT stock_num, dbo.lista_fabricantes_producto(stock_num)
FROM products p
WHERE EXISTS ( SELECT * FROM catalog WHERE stock_num=p.stock_num )

GO
CREATE FUNCTION dbo.lista_fabricantes_producto (@stock_num SMALLINT)
RETURNS VARCHAR(100) AS
BEGIN
	DECLARE @RETORNO VARCHAR(100)
	SET @RETORNO = ''
	DECLARE item_cursor CURSOR FOR
	SELECT manu_code FROM products WHERE stock_num=@stock_num

	DECLARE @manu_code VARCHAR(3)
	OPEN item_cursor
	FETCH item_cursor INTO @manu_code
	WHILE @@FETCH_STATUS=0
	BEGIN
		SET @RETORNO = @RETORNO + @manu_code + ' | '
		FETCH item_cursor INTO @manu_code
	END
	CLOSE item_cursor
	DEALLOCATE item_cursor
RETURN @RETORNO;
END
GO

