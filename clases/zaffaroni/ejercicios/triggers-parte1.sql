USE stores7new;

-- Ejercicio 1
IF OBJECT_ID('products_historia_precios') IS NOT NULL
	DROP TABLE products_historia_precios;

CREATE TABLE products_historia_precios(
	stock_historia_id INT IDENTITY PRIMARY KEY,
	stock_num INT,
	manu_code VARCHAR(3),
	fechaHora DATETIME,
	usuario VARCHAR(30),
	unit_price_old DECIMAL,
	unit_price_new DECIMAL,
	estado char default 'A' check (estado IN ('A', 'I'))
);

SELECT * INTO x_products FROM dbo.products;
SELECT * FROM x_products;

TRUNCATE TABLE products_historia_precios; -- vaciamos los registros

IF OBJECT_ID('auditoria_products') IS NOT NULL
	DROP TRIGGER auditoria_products;

GO
CREATE TRIGGER auditoria_products ON x_products
AFTER UPDATE AS
BEGIN
	INSERT INTO products_historia_precios 
	(stock_num, manu_code, fechaHora, usuario, unit_price_old, unit_price_new)
	SELECT i.stock_num, i.manu_code, GETDATE(), CURRENT_USER, d.unit_price, i.unit_price
	FROM inserted i
	JOIN deleted d ON (d.stock_num = i.stock_num AND d.manu_code = i.manu_code) 
END
GO

UPDATE x_products
	SET unit_price=unit_price*0.5
	WHERE unit_code < 6;

SELECT * FROM x_products WHERE unit_code = 6; 
SELECT * FROM products_historia_precios;

-- Ejercicio 2
GO
CREATE TRIGGER auditoria_products_delete ON products_historia_precios
INSTEAD OF DELETE AS
BEGIN
	DECLARE @stock_historia_id INT			-- 1. Declaramos variables donde guardamos los datos
	DECLARE item_cursor CURSOR FOR			-- 2. Declaramos el cursor
	SELECT stock_historia_id FROM deleted	-- 3. Le asociamos la query SQL (de la tabla deleted)
	OPEN item_cursor						-- 4. Abrimos el cursor (alojamos en memoria)
	FETCH NEXT FROM item_cursor INTO @stock_historia_id -- 5. Leemos el primer registro
	WHILE (@@FETCH_STATUS = 0)				-- 6. Iteramos mientras hayan registros
	BEGIN
		UPDATE products_historia_precios
		SET estado = 'I' WHERE stock_historia_id = @stock_historia_id

		FETCH NEXT FROM item_cursor INTO @stock_historia_id -- 7. Avanzamos al siguiente registro
	END
	CLOSE item_cursor		-- 8. Cerramos el cursor
	DEALLOCATE item_cursor	-- 9. Lo desalojamos de la memoria, liberamos los recursos que utilizaba				
END
GO

SELECT * FROM products_historia_precios;
DELETE FROM products_historia_precios WHERE stock_historia_id BETWEEN 1 AND 5;
SELECT * FROM products_historia_precios WHERE stock_historia_id BETWEEN 1 AND 5;

-- Ejercicio 3
SELECT * FROM x_products;

IF OBJECT_ID('auditoria_products_insert_horario') IS NOT NULL
	DROP TRIGGER auditoria_products_insert_horario;

GO
CREATE TRIGGER auditoria_products_insert_horario ON x_products
INSTEAD OF INSERT AS
BEGIN
	DECLARE @hora_actual TIME = CAST(GETDATE() AS TIME);
	IF(@hora_actual BETWEEN '08:00:00' AND '20:00:00')
		INSERT INTO x_products (stock_num, manu_code, unit_price, unit_code)
		SELECT stock_num, manu_code, unit_price, unit_code FROM inserted
	ELSE
		RAISERROR('NO podes agregar productos a esta hora, vaya a dormir!',16,1)
END
GO

--SELECT * FROM x_products WHERE manu_code = 'PHP';
--DELETE FROM x_products WHERE manu_code = 'PHP';

-- Insertamos varios registros para probar..
INSERT INTO x_products (stock_num, manu_code, unit_price, unit_code)
VALUES (100,'PHP', 500.0, 2), (101,'PHP', 600.0, 2), (102,'PHP', 900.0, 2)


-- Ejercicio 4
-- Dudas: Alguna otra manera en vez de 2 queries DELETE?
SELECT * INTO x_orders FROM orders;
SELECT * INTO x_items FROM items;

IF OBJECT_ID('auditoria_orders_borrar') IS NOT NULL
	DROP TRIGGER auditoria_orders_borrar;

GO
CREATE TRIGGER auditoria_orders_borrar ON x_orders
INSTEAD OF DELETE AS
BEGIN
	DECLARE @cant_ordenes INT, @orden_num INT;

	SET @cant_ordenes=(SELECT count(*) FROM deleted);

	IF (@cant_ordenes > 1)
		RAISERROR('Calmate!! Solo podés borrar una orden!', 16,1);
	ELSE
		SET @orden_num=(SELECT order_num FROM deleted); -- si seteamos antes, falla porque podrian ser muchos registros..
		DELETE FROM x_items WHERE order_num=@orden_num
		DELETE FROM x_orders WHERE order_num=@orden_num
END
GO

-- hacemos esta query relacionar las ordenes con la cant. de items,
-- y decidir cual borrar luego
SELECT o.order_num, count(*) cantidad_items FROM x_orders o 
JOIN items i ON o.order_num=i.order_num
GROUP BY o.order_num
HAVING o.order_num BETWEEN 1001 AND 1005;

DELETE FROM x_orders WHERE order_num BETWEEN 1001 AND 1005; -- esta va a arrojar un raiserror
DELETE FROM x_orders WHERE order_num=1005; -- esta sólo borra 1 orden y los 4 items asociados

-- Ejercicio 5

IF OBJECT_ID('audit_insert_items_fabricante') IS NOT NULL
	DROP TRIGGER audit_insert_items_fabricante

GO
CREATE TRIGGER audit_insert_items_fabricante ON x_items
AFTER INSERT AS
BEGIN
	INSERT INTO manufact (manu_code, manu_name, lead_time, state)
	SELECT manu_code, 'Manu Orden '+CAST(order_num as VARCHAR(5)), 1, null FROM inserted i
	WHERE manu_code NOT IN (SELECT DISTINCT manu_code FROM manufact WHERE manu_code=i.manu_code)
END
GO

-- insertamos un registro a modo de prueba
INSERT INTO x_items (item_num, order_num, stock_num, manu_code, quantity, unit_price)
VALUES (100, 2000, 100, 'FUA', 100, 500.)
-- verificamos si funcionó el trigger
SELECT * FROM manufact WHERE manu_code='FUA';


-- Ejercicio 7 (REVISAR, no se sinetaba en el manufact ni en x_products)
-- DUDAS: En la 2da query seria mejor solo un 
-- IF NOT EXIST(..) INSERT INTO manufact ?

GO
CREATE VIEW productos_x_fabricante AS
	SELECT p.stock_num, description, p.manu_code, manu_name, unit_price
	FROM products p
	JOIN product_types pt ON p.stock_num=p.stock_num
	JOIN manufact m ON m.manu_code=p.manu_code
GO

IF OBJECT_ID('audit_insert_productos_x_fabricante') IS NOT NULL
	DROP TRIGGER audit_insert_productos_x_fabricante;

GO
CREATE TRIGGER audit_insert_productos_x_fabricante ON productos_x_fabricante
INSTEAD OF INSERT AS
BEGIN
	INSERT INTO x_products (stock_num, manu_code, unit_price, unit_code)
	SELECT stock_num, manu_code, unit_price, 1 FROM inserted

	INSERT INTO manufact (manu_code, manu_name, lead_time, state)
	SELECT manu_code, manu_name, 1, null FROM inserted i
	WHERE manu_code NOT IN (SELECT DISTINCT manu_code WHERE manu_code=i.manu_code)
END
GO

INSERT INTO productos_x_fabricante (stock_num, description, manu_code, manu_name, unit_price)
VALUES (501, 'tururu', 'YOY', 'Zndo', 500.0)

SELECT * FROM productos_x_fabricante WHERE manu_code='YOY';
SELECT * FROM manufact WHERE manu_code='YOY';
SELECT * FROM x_products WHERE manu_code='YOY';


