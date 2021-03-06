USE GD2015C1

--------------------------------------------------------------------------------------------
--> Ejercicio (1)
SELECT clie_codigo, clie_razon_social
FROM Cliente
WHERE clie_limite_credito >= 1000
ORDER BY clie_codigo

--------------------------------------------------------------------------------------------
--> Ejercicio (2)
--
--> Nota (1): Recordar que los alias sólo actuan como una etiqueta para renombrar columnas al visualizar la tabla,
--> pero NO reemplazan las operaciones. En este caso al momento de ordenar, debemos volver a reescribir la operación.
SELECT prod_detalle, SUM(item_cantidad) cantidad_vendida --> (1)
FROM Item_Factura i
JOIN Producto p ON p.prod_codigo = i.item_producto
JOIN Factura f ON f.fact_tipo=i.item_tipo AND f.fact_sucursal=i.item_sucursal AND f.fact_numero=i.item_numero
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY prod_detalle
ORDER BY SUM(item_cantidad) --> (1)

--------------------------------------------------------------------------------------------
--> Ejercicio (3)
--
--> Nota (1): El ORDER BY por default ordena de forma Ascendente (ASC) de menor a mayor
SELECT prod_codigo, prod_detalle, SUM(stoc_cantidad) stoc_total
FROM STOCK s
JOIN Producto p ON p.prod_codigo = s.stoc_producto
GROUP BY prod_codigo, prod_detalle
ORDER BY prod_detalle --> (1)

--------------------------------------------------------------------------------------------
--> Ejercicio (4)
--
--> Nota (1): Al hacer el JOIN entre combo+componente ya podemos saber la cant. de componentes que componen al producto
--> apesar de que aparezca ese campo "comp_cantidad", que al parecer no están ok los valores.
--
--> Nota (2): Al JOINear con "STOCK" tendremos registros repetidos (los productos que componen al combo)
--> porque cada deposito puede tener muchos de esos productos, es una relación 1 a N.
--> Por tanto en las columnas de SELECT debemos agregar un DISTINCT al COUNT(p2.prod_codigo), caso contrario dará un resultado erroneo
--
--> Nota (3): NO estaría del todo ok esa subquery, porque no está filtrando los productos que están formados por componentes
-- y para que hacerlo deberías hacer un JOIN, eso implicaría un costo extra. Es mejor solo hacer un JOIN a STOCK y chequear la cant. en el HAVING
SELECT	p.prod_codigo, p.prod_detalle, AVG(stoc_cantidad),
		COUNT(DISTINCT p2.prod_codigo) cant_componentes --> (2)
		--COALESCE(comp_cantidad, 0) comp_cant --> (1)
FROM Composicion c
JOIN Producto p ON p.prod_codigo=c.comp_producto
JOIN Producto p2 ON p2.prod_codigo=c.comp_componente
JOIN STOCK s ON s.stoc_producto = p.prod_codigo --> (2)
GROUP BY p.prod_codigo, p.prod_detalle
HAVING AVG(stoc_cantidad) > 100
-- AND prod_codigo IN (SELECT stoc_producto FROM STOCK GROUP BY stoc_producto HAVING AVG(stoc_cantidad)>100) --> (3)
ORDER BY 1

/*
SELECT stoc_producto, AVG(stoc_cantidad) FROM STOCK
WHERE stoc_producto = '00001707'
GROUP BY stoc_producto
ORDER BY 1

SELECT stoc_deposito, stoc_producto, AVG(stoc_cantidad)
FROM STOCK
GROUP BY stoc_deposito , stoc_producto HAVING AVG(stoc_cantidad)>100
*/

--------------------------------------------------------------------------------------------
--> Ejercicio (5)
--
--> Nota (1):
--> 1. NO es necesario agrupar por el año, porque el enunciado ya especifíca un valor
--> 2. Al no ser necesario agrupar, podemos filtrar en el WHERE en vez de HAVING
--
--> Nota (2):
--> 1. Similar a la Nota (1) con lo del año
--> 2. NO es necesario agrupar por producto, porque es una subquery correlacionada que le pasamos ese valor
--> 3. Por lo dicho en (1) y (2) no es necesario agrupar ni usar HAVING, por tanto dejamos el WHERE
SELECT prod_codigo, prod_detalle, SUM(item_cantidad) cant_egresos
FROM Item_Factura i
JOIN Factura f ON f.fact_tipo=i.item_tipo AND f.fact_sucursal=i.item_sucursal AND f.fact_numero=i.item_numero
JOIN Producto p ON p.prod_codigo = i.item_producto
WHERE YEAR(fact_fecha) = 2012 --> (1)
GROUP BY prod_codigo, prod_detalle --,YEAR(fact_fecha) --> (1)
HAVING SUM(item_cantidad) > (
	SELECT SUM(item_cantidad)
	FROM Item_Factura i2
	JOIN Factura f2 ON f2.fact_tipo=i2.item_tipo AND f2.fact_sucursal=i2.item_sucursal AND f2.fact_numero=i2.item_numero
	WHERE item_producto = p.prod_codigo AND YEAR(f2.fact_fecha) = 2011 --> (2)
	--GROUP BY item_producto, YEAR(f2.fact_fecha)  --> (2)
	--HAVING YEAR(f2.fact_fecha) = 2011 --> (2)

) --AND YEAR(fact_fecha) = 2012 --> (1)
ORDER BY 1


--------------------------------------------------------------------------------------------
-- Ejercicio (6) <<<<
--
--> Nota (1):
--> 1. Si JOINeamos con Stock => se ve afectado el COUNT(*) cant_productos
--> 2. Usamos un DISTINCT en el COUNT() de la columnas de SELECT, porque se repiten productos, 
--> por lo dicho antes en (1). Cada depósito puede tener muchos productos
--
--> Nota (2):
--> Si hacíamos esa subquery correlacionada como la última columna del SELECT
--> nos obligaba agregar la columna "p.prod_codigo" en el GROUP BY porque...
--> 1. porque no está como columna en el SELECT (no lo pide el enunciado)
--> 2. porque primero hace FROM (trae todo) -> WHERE (filtra) -> GROUP BY (agrupa) -> HAVING (filtra) -> SELECT columnas
--> por tanto en esa última etapa ya se perdió la referencia a la columna "p.prod_codigo"
--> además.. el agregar la columna en el GROUP BY implicaría registros duplicados, porque habrian mas combinaciones
--
--> Solución a la Nota (2):
--> Hacer el JOIN con SOCK, y agregar el DISTINCT prod_codigo en la 3ra columna que usa COUNT()
--> porque es una relación 1 a N, y rompe la atomicidad de la consulta, ya que cada deposito tiene muchos productos
--
--> Nota (3):
--> Si filtramos en el HAVING por SUM(stoc_cantidad), estaría MAL porque está agrupado por rubro...
-->
--> Al filtrar en el WHERE usando 2 subqueries 
--> 1. estamos filtrando los artículos antes de ser agrupados por rubro
--> 2. filtramos con el criterio correcto con el de "agrupar por producto"
--> y luego ahi si comparamos con el producto X del deposito Y que se indica en el enunciado
SELECT rubr_id, rubr_detalle, COUNT(DISTINCT prod_codigo) cant_prod, --> (1)
		SUM(stoc_cantidad) --> (2)
		--(SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto=p.prod_codigo) stoc_prod --> (2)
FROM Rubro r
JOIN Producto p ON r.rubr_id = p.prod_rubro
JOIN STOCK s ON s.stoc_producto = p.prod_codigo --> (1)
WHERE prod_codigo IN
		(SELECT stoc_producto FROM STOCK GROUP BY stoc_producto HAVING SUM(stoc_cantidad) > --> (3)
			(SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto = '00000000' AND stoc_deposito = '00') --> (3)
		)
GROUP BY rubr_id, rubr_detalle
--HAVING SUM(stoc_cantidad) > (SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto = '00000000' AND stoc_deposito = '00') --> (3)
order by 1


--------------------------------------------------------------------------------------------
--> Ejercicio (7) - Alternativa
--
--> Nota (1):
--> 1. Al hacer JOIN contra STOCK rompés la atomicidad por ser 1 a N la relación entre producto-stock
--> 2. El usar un WHERE + Subconsulta es la solución al (1), si se cumple lo muestra
--
--> Obs: al principio creí que era el precio de la tabla producto, pero nope
SELECT	p.prod_codigo, prod_detalle, MIN(item_precio) menor_precio, MAX(item_precio) mayor_precio,
		((MAX(item_precio) - MIN(item_precio)) * 100) promedio
FROM Producto p
JOIN Item_Factura i ON i.item_producto = p.prod_codigo
WHERE prod_codigo IN (SELECT stoc_producto FROM STOCK WHERE stoc_cantidad > 0) --> (2)
--JOIN STOCK s ON s.stoc_producto = p.prod_codigo --> (1)
GROUP BY p.prod_codigo, prod_detalle
--HAVING SUM(stoc_cantidad) > 0 --> (1)


--------------------------------------------------------------------------------------------
--> Ejercicio (8)
SELECT prod_detalle, MAX(stoc_cantidad)
FROM STOCK s
JOIN Producto p ON p.prod_codigo = s.stoc_producto
WHERE stoc_cantidad > 0
GROUP BY prod_detalle, prod_codigo


--------------------------------------------------------------------------------------------
--> Ejercicio (9)
--
--> Nota (1):
--> 1. Es fundamental el OR, porque caso contrario quizás pensas en hacer un 2do JOIN
SELECT	empl_jefe, empl_codigo, empl_nombre , COUNT(*) cant_depositos_ambos
FROM Empleado e
LEFT JOIN DEPOSITO d ON d.depo_encargado=empl_jefe OR d.depo_encargado=empl_codigo --> (1)
GROUP BY empl_jefe, empl_codigo, empl_nombre

--------------------------------------------------------------------------------------------
--> Ejercicio (10)
--
--> NO es lo mismo contar la cant. de renglones de cada factura de un cliente
--> que sumar la cant. de productos en cada renglón...
--> Esto segundo representa la cant. total de productos que compró
SELECT prod_codigo,
	(
	SELECT TOP 1 fact_cliente
	FROM Item_Factura i
	JOIN Factura f ON f.fact_tipo=i.item_tipo AND f.fact_sucursal=i.item_sucursal AND f.fact_numero=i.item_numero
	WHERE i.item_producto=p.prod_codigo
	GROUP BY fact_cliente
	ORDER BY SUM(item_cantidad) DESC --> (1)
	--ORDER BY COUNT(*) DESC --> (1)
	) cliente_que_mas_compro
FROM Producto p
WHERE prod_codigo IN (
		SELECT TOP 10 item_producto FROM Item_factura i
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC
	)
	OR
	prod_codigo IN (
		SELECT TOP 10 item_producto FROM Item_factura i
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) ASC
	)
GROUP BY prod_codigo

/*
SELECT TOP 10 item_producto FROM Item_factura i
GROUP BY item_producto
ORDER BY SUM(item_cantidad) DESC
*/

--------------------------------------------------------------------------------------------
--> Ejercicio (11)
--
--> Nota (1):
--> 1. Para la cant. de productos distintos podes usar DISTINCT en el COUNT()
--> 2. Podrias utilizar 2 JOINs en caso que te pidan mostrar 2 columnas con productos diferentes
--
--> Nota (2):
--> 1. Se puede filtrar en el WHERE por una columna previo a ser agrupada
--> 2. OJO! NO conviene filtrar en el HAVING, porque te pedirá agrupar por esa columna
--> y eso implica repetir registros porque en un año pudo haber varias ventas de la misma familia
--> porque permite más combinaciones, pero la columna a mostrar se repitería
--
--> Nota (3):
--> 1. Al ORDER BY se le puede indicar el numero de cualquier columna del SELECT,
--> por más que utilice una función de de agregación como COUNT()
SELECT fami_detalle, COUNT(DISTINCT item_producto) cant_prod_dif, SUM(i.item_cantidad*i.item_precio) monto_vendido
FROM Item_Factura i
JOIN Producto p1 ON p1.prod_codigo=i.item_producto
--JOIN Producto p2 ON p2.prod_codigo=i.item_producto --AND p1.prod_codigo != p2.prod_codigo --> (1)
JOIN Familia f ON f.fami_id=p1.prod_familia
WHERE fami_id IN (
	--SELECT fami_id FROM Familia f2 JOIN Producto p ON p.prod_familia=f2.fami_id --> (1)
	SELECT prod_familia --,SUM(i2.item_cantidad*i2.item_precio) cant_vendida --> este era para probar
	FROM Producto p --> (1)
	JOIN Item_Factura i2 ON i2.item_producto=p.prod_codigo
	JOIN Factura fa ON fa.fact_tipo=i2.item_tipo AND fa.fact_sucursal=i2.item_sucursal AND fa.fact_numero=i2.item_numero
	WHERE YEAR(fa.fact_fecha) = 2012 --> (2)
	GROUP BY prod_familia --, fact_fecha --> (2)
	HAVING SUM(i2.item_cantidad*i2.item_precio) > 20000 --AND YEAR(fa.fact_fecha) = 2012 --> (2)
)
GROUP BY fami_detalle
ORDER BY 2 DESC --> (3)
--ORDER BY COUNT(DISTINCT item_producto) DESC --> (3)

/*
	-- MAL! Devuelve 11 registros con mismo fami_id
	SELECT fami_id --,SUM(i2.item_cantidad*i2.item_precio) cant_vendida
	FROM Familia f2
	JOIN Producto p ON p.prod_familia=f2.fami_id
	JOIN Item_Factura i2 ON i2.item_producto=p.prod_codigo
	JOIN Factura fa ON fa.fact_tipo=i2.item_tipo AND fa.fact_sucursal=i2.item_sucursal AND fa.fact_numero=i2.item_numero
	GROUP BY fami_id, fact_fecha
	HAVING SUM(i2.item_cantidad*i2.item_precio) > 2000 AND YEAR(fa.fact_fecha) = 2012

	-- OK! Devuelve 5 registros con fami_id diferente
	SELECT prod_familia FROM Producto p
	JOIN Item_Factura i2 ON i2.item_producto=p.prod_codigo
	JOIN Factura fa ON fa.fact_tipo=i2.item_tipo AND fa.fact_sucursal=i2.item_sucursal AND fa.fact_numero=i2.item_numero
	WHERE YEAR(fa.fact_fecha) = 2012
	GROUP BY prod_familia
	HAVING SUM(i2.item_cantidad*i2.item_precio) > 20000
*/

--------------------------------------------------------------------------------------------
--> Ejercicio (12)
--
--> Nota (1): Ambas subqueries correlacionadas actuan como un JOIN y utilizan p.prod_codigo,
--> por tanto se debe agregar esa columna al GROUP BY de la query principal
--> porque NO está entre las columnas del SELECT, y al agrupar con GROUP se pierde la referencia a esa columna
--
--> Nota (2): Si agrupamos por fact_fecha habrán más registros, porque en un año se pudieron
--> haber hecho muchas ventas, y se repetirán los productos
--
--> Nota (3):
--> 1. Si podés evitar una subquery y usarlo un JOIN mejor
--> 2. Para saber la cant. de depositos que tienen un producto
--> es suficiente con un JOIN y usar DISTINCT en el COUNT() por id de deposito
SELECT	p.prod_detalle, COUNT(DISTINCT fa.fact_cliente), AVG(item_precio) importe_promedio_pagado,
		--(SELECT COUNT(DISTINCT stoc_deposito) FROM STOCK WHERE stoc_producto=p.prod_codigo) cant_depositos, --> (1) (3)
		COUNT(DISTINCT s.stoc_deposito) cant_depositos,
		(SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto=p.prod_codigo) total_depo_stock --> (1)
FROM Producto p
JOIN Item_Factura i ON i.item_producto = p.prod_codigo
JOIN Factura fa ON fa.fact_tipo=i.item_tipo AND fa.fact_sucursal=i.item_sucursal AND fa.fact_numero=i.item_numero
JOIN STOCK s ON s.stoc_producto=p.prod_codigo --> (3)
WHERE stoc_cantidad > 0 AND YEAR(fact_fecha) = 2012
GROUP BY p.prod_detalle, prod_codigo --,fact_fecha --> (2)
--HAVING YEAR(fact_fecha) = 2012 --> (2)
ORDER BY SUM(item_cantidad*item_precio) DESC

/*
SELECT COUNT(DISTINCT stoc_deposito)
FROM STOCK
WHERE stoc_producto = '00000102'
*/

--------------------------------------------------------------------------------------------
--> Ejercicio (13)
--
--> Nota (1): 
--> 1. Confunde un poco si la cantidad de productos la debemos asociar con comp_cant
--> o la cant. de productos que tiene asociado ya en la relación Composicion-Producto
--
SELECT	p.Prod_detalle, p.prod_precio,
		SUM(p2.prod_precio*comp_cantidad) precio --> (1)
		--,SUM(p2.prod_precio)*COUNT(*) precio --> (1)
FROM Composicion c
JOIN Producto p ON p.prod_codigo=c.comp_producto
JOIN Producto p2 ON p2.prod_codigo=c.comp_componente
GROUP BY p.prod_detalle, p.prod_precio
HAVING COUNT(*) > 2
ORDER BY COUNT(*) DESC

/*
SELECT *
FROM Composicion c
JOIN Producto p ON p.prod_codigo=c.comp_producto
ORDER BY comp_producto
*/


--------------------------------------------------------------------------------------------
--> Ejercicio (14)
--
--> Nota (1):
--> 1. Las subqueries NO son necesarias, es suficiente con un JOIN a Item_Factura
--> y usar COUNT(LA_PK_DE_FACTURA) para la cant. de compras, MAX() para conocer su mayor compra
--> y DISTINCT en el COUNT de productos
--> 
--> "suponiendo que hubiese estado ok tener las subqueries"
--> 2. Si le pasamos el ultimo año a las subqueries, no necesitamos agrupar ni ordenar en ambas
SELECT	fact_cliente, AVG(fact_total) promedio,
		COUNT(DISTINCT i.item_producto), MAX(fact_total), --> (1)
		COUNT(f.fact_tipo+f.fact_sucursal+f.fact_numero) compras_ult_anio
		--COUNT(*) compras_ult_anio,
		/*
		(
			SELECT COUNT(DISTINCT item_producto)
			FROM Item_Factura i
			JOIN Factura fa ON fa.fact_tipo=i.item_tipo AND fa.fact_sucursal=i.item_sucursal AND fa.fact_numero=i.item_numero
			WHERE fact_cliente = f.fact_cliente AND YEAR(fact_fecha) = YEAR(f.fact_fecha)
			--GROUP BY YEAR(fact_fecha) ORDER BY YEAR(fact_fecha) DESC --> (2)
		) cant_prod_ult_anio,
		(
			SELECT MAX(fact_total)
			FROM Factura
			WHERE fact_cliente = f.fact_cliente AND YEAR(fact_fecha) = YEAR(f.fact_fecha)
			--GROUP BY YEAR(fact_fecha) ORDER BY YEAR(fact_fecha) DESC --> (2)
		) monto_mayor_compra
		*/
FROM Factura f
JOIN Item_Factura i ON f.fact_tipo=i.item_tipo AND f.fact_sucursal=i.item_sucursal AND f.fact_numero=i.item_numero --> (1)
WHERE YEAR(fact_fecha) = (SELECT MAX(YEAR(fact_fecha)) FROM Factura) --> (2)
--WHERE YEAR(fact_fecha) = (SELECT YEAR(fact_fecha) FROM Factura ORDER BY YEAR(fact_fecha) DESC) --> (2)
GROUP BY fact_cliente --,YEAR(fact_fecha)
ORDER BY 5 DESC

/*
SELECT YEAR(fact_fecha), fact_cliente, COUNT(*) 
FROM Factura 
GROUP BY YEAR(fact_fecha), fact_cliente
ORDER BY YEAR(fact_fecha) DESC
*/


--------------------------------------------------------------------------------------------
--> Ejercicio (15)
--
--> Nota (1):
--> 1. Para no repetir registros usamos los operadores de desigualdad < ó > en vez del !=
--> porque el operador != no sirve para validar a!=b y b!=a
SELECT i1.item_producto, p1.prod_detalle, i2.item_producto, p2.prod_detalle, COUNT(*) veces_vendidos_juntos
FROM Item_Factura i1
JOIN Item_Factura i2 ON i2.item_tipo=i1.item_tipo AND i2.item_sucursal=i1.item_sucursal AND i2.item_numero=i1.item_numero
JOIN Producto p1 ON p1.prod_codigo=i1.item_producto
JOIN Producto p2 ON p2.prod_codigo=i2.item_producto
WHERE i1.item_producto > i2.item_producto --> (1)
--WHERE i1.item_producto != i2.item_producto --> (1)
GROUP BY i1.item_producto, p1.prod_detalle, i2.item_producto, p2.prod_detalle
HAVING COUNT(*) > 500
ORDER BY 5
