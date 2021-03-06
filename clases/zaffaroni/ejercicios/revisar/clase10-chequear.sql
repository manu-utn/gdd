use stores7new;

CREATE VIEW fabricantes_de_mas_2_prod AS
SELECT m.manu_code, m.manu_name, Count(DISTINCT p.stock_num) as cant_productos, Max(o.order_date) as ult_fecha_orden
FROM manufact m LEFT JOIN products p on m.manu_code = p.manu_code
				LEFT JOIN items i on m.manu_code = i.manu_code AND p.stock_num = i.stock_num
				LEFT JOIN orders o on i.order_num = o.order_num
GROUP BY m.manu_code, m.manu_name
HAVING Count(p.stock_num) > 2 OR Count(p.stock_num) = 0

SELECT manu_code, manu_name, cant_productos, COALESCE (CONVERT(varchar, ult_fecha_orden), 'No Posee Órdenes')
FROM fabricantes_de_mas_2_prod

/*
-- este es de otro alumno
CREATE VIEW V_fabricantes AS
SELECT m.manu_code, manu_name, COUNT(DISTINCT p.stock_num) cant_producto, CONVERT(VARCHAR, MAX(order_date)) ult_fecha_orden  FROM manufact m
LEFT JOIN products p ON (m.manu_code = p.manu_code)
LEFT JOIN items i ON (i.stock_num = p.stock_num AND i.manu_code = p.manu_code)
LEFT JOIN orders o ON (o.order_num = i.order_num)
GROUP BY m.manu_code, manu_name HAVING COUNT(DISTINCT p.stock_num) = 0 OR COUNT(DISTINCT p.stock_num) > 2

SELECT manu_code, manu_name, cant_producto, COALESCE(ult_fecha_orden, 'No posee ordenes')
FROM V_fabricantes
*/
-- ejercicio 1a

drop view v_fabricantes;
GO
-- importante el distinct en la 3ra columna (?) yo habia usado count(*)
-- el cast a varchar es necesario para el 1b
-- el left s necesario para mostrar los fabricantes q no tenian productos
CREATE VIEW v_fabricantes AS	
	SELECT m.manu_code, manu_name, count(DISTINCT p.stock_num) cant_productos, MAX(order_date) ult_fecha_orden FROM manufact m
	LEFT JOIN products p ON p.manu_code=m.manu_code
	LEFT JOIN items i ON (i.stock_num=p.stock_num AND i.manu_code=p.manu_code)
	LEFT JOIN orders o ON o.order_num = i.order_num
	GROUP BY m.manu_code, manu_name
	HAVING count(DISTINCT p.stock_num) > 2 OR count(DISTINCT p.stock_num) = 0
GO

-- ejercicio 1b
-- tiene error con el colaesce
SELECT manu_code, manu_name, cant_productos, COALESCE(CAST(ult_fecha_orden AS VARCHAR), 'No posee orden')
FROM v_fabricantes

SELECT manu_code, manu_name, cant_productos, COALESCE (CONVERT(varchar, ult_fecha_orden), 'No Posee Órdenes')
FROM v_fabricantes

-- Ejercicio 2
SELECT m.manu_code, manu_name,  count(DISTINCT i.order_num) cant_ord, SUM(i.unit_price*i.quantity)
FROM manufact m
JOIN items i ON i.manu_code=m.manu_code
JOIN product_types pt ON pt.stock_num=i.stock_num
--JOIN products p ON p.manu_code=m.manu_code
--JOIN product_types pt ON pt.stock_num=p.stock_num
--JOIN items i ON (i.stock_num=p.stock_num AND i.manu_code=p.manu_code)
--JOIN orders o ON o.order_num = i.order_num
-- importante el where 
-- deben estar aca, porque se pierden las referencias luego del GROUP BY, 
-- porque las columnas que se seleccionan al principio son manu_code y manu_name, pero NO la de description
WHERE m.manu_code LIKE '%[AN]__' AND (description LIKE '%tennis%' OR description LIKE '%ball%' )
	--description IN ('tennis', 'ball') -- no usemos IN, porque seria igualacion
GROUP BY m.manu_code, manu_name
-- importante el select en el de la derecha, porque 
HAVING  SUM(unit_price*quantity) > (SELECT SUM(quantity*unit_price)/COUNT(DISTINCT i.manu_code) FROM items i)
ORDER BY 4 DESC;

