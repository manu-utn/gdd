/*
* 1. Creamos las estructuras
*/
IF OBJECT_ID('test_paises') IS NOT NULL
	DROP TABLE test_paises;

CREATE TABLE test_paises(
	id_pais INT PRIMARY KEY IDENTITY (1,1),
	pais VARCHAR(30) NULL
);

IF OBJECT_ID('test_productos') IS NOT NULL
	DROP TABLE test_productos;

CREATE TABLE test_productos(
	id_producto INT PRIMARY KEY IDENTITY (1,1),
	nombre VARCHAR(30),
	cantidad INT DEFAULT 0,
	id_pais INT REFERENCES test_paises(id_pais),
	id_tipo_producto INT REFERENCES test_producto_tipo(id_tipo_producto)
);

IF OBJECT_ID('test_producto_tipo') IS NOT NULL
	DROP TABLE test_producto_tipo;

CREATE TABLE test_producto_tipo(
	id_tipo_producto INT PRIMARY KEY IDENTITY (1,1),
	descripcion VARCHAR(50)
);

/*
* 2. Insertamos los registros
*/

TRUNCATE TABLE test_paises;
INSERT INTO test_paises (pais)
	VALUES ('Argentina'), ('Brasil'), ('Peru'),
			('España'), ('Bolivia'), ('Mexico'),
			('Panama'), ('Chile'), ('Ecuador')

TRUNCATE TABLE test_productos;
INSERT INTO test_productos (nombre, cantidad, id_pais, id_tipo_producto)
	VALUES  ('chocolate', 10, 1, 1), ('chocolate', 50, 2, 1),
			('chocolate', 5, 3, 1), ('mani', 100, 2, 2),
			('mani', 45, 2, 2), ('leche', 99, 3, 3),
			('leche', 150, 4, 3), ('arroz', 500, 5, 3)

TRUNCATE TABLE test_tipo_producto;
INSERT INTO test_producto_tipo (descripcion)
	VALUES ('dulce'), ('salado'), ('neutro')

/*
* 3. Probamos las consultas con JOINs
*/

SELECT * FROM test_paises;
SELECT * FROM test_productos;

-- INNER JOIN (no es necesario poner "INNER")
-- >>"No hay tablas dominante"
--
-- 1. Muestra solo los registros que esten relacionados/asociados por FK+PK
-- 2. Actua como la interseccion entre conjuntos, lo que tengan en comun (la fk+pk)
SELECT * FROM test_paises pa
INNER JOIN test_productos pro ON pro.id_pais = pa.id_pais;

SELECT * FROM test_paises pa
INNER JOIN test_productos pro ON pro.id_pais = pa.id_pais
INNER JOIN test_producto_tipo pt ON pt.id_tipo_producto=pro.id_tipo_producto;


-- LEFT OUTER JOIN (no es necesario poner OUTER)
-- >> "La tabla dominante es la esté a la izq del JOIN"
-- >>  en este caso la del FROM que es test_paises
--
-- 1. Muestra "todos" los registros de la tabla "dominante" (clientes)
--    no interesa que no estén relacionados mediante una FK con otra tabla
-- 2. En teoria de conjuntos..
--    sea A un conjunto (la tabla "dominante" izquierda) y B otro conjunto (la tabla derecha)
--    mostraria al conjunto A y su intersección con B
SELECT * FROM test_paises pa
LEFT OUTER JOIN test_productos pro ON pro.id_pais = pa.id_pais;

SELECT * FROM test_paises pa
LEFT OUTER JOIN test_productos pro ON pro.id_pais = pa.id_pais
LEFT OUTER JOIN test_producto_tipo pt ON pt.id_tipo_producto=pro.id_tipo_producto;

-- RIGHT OUTER JOIN (no es necesario poner OUTER)
-- >> "La tabla dominante será la que esté a la der del JOIN"
-- >> en este caso es test_paises
--
-- 1. Muestra "todos" los registros de la tabla "dominante" (test_paises)
--    y.. NO interesa si no tengan una relación con FK con la otra tabla
-- 2. En teoria de conjuntos..
--    sea A un conjunto (la tabla izquierda) y B otro conjunto (la tabla "dominante" derecha)
--    mostraria al conjunto B y su intersección con A
SELECT * FROM test_productos pro
RIGHT OUTER JOIN test_paises pa ON pa.id_pais=pro.id_pais

