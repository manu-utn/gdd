--> Pendiente:
--> 1. El ejercicio (8) no respondía de manera adecuada a la hora de manejar los errores
--> para luego reportarlos a la tabla correspondiente

/*******************
 *** Ejercicio (1)
 */
IF OBJECT_ID('auditoria') IS NOT NULL
	DROP TABLE auditoria;

CREATE TABLE auditoria(
	auditID INT PRIMARY KEY IDENTITY,
	nombreTabla VARCHAR(30) NOT NULL,
	operacion CHAR, -- {i, o, n , d}
	rowData VARCHAR(255) NOT NULL,
	Usuario VARCHAR(30) DEFAULT USER,
	fecha DATE DEFAULT GETDATE()
);

/*******************
 *** Ejercicio (2)
 */
--> Podemos evitar la entrada de las columnas auditID, Usuario, fecha
--> 1. el primero por ser un IDENTITY que incrementa su valor al insertarse el registro
--> 2. Los dos ultimos porque tienen un constraint DEFAULT que le asigna un valor predeterminado

IF OBJECT_ID('altaAuditoria') IS NOT NULL
	DROP PROCEDURE altaAuditoria;

GO
CREATE PROCEDURE altaAuditoria
@nombreTabla VARCHAR(30), @operacion CHAR, @rowData VARCHAR(30) AS
BEGIN
	INSERT INTO auditoria (nombreTabla, operacion, rowData)
	VALUES (@nombreTabla, @operacion, @rowData)
END
GO

-- Pruebas
SELECT * FROM auditoria;
EXECUTE altaAuditoria ventas, 'u', 'las ventas suben'
SELECT * FROM auditoria;

/*******************
 *** Ejercicio (3)
 */
IF OBJECT_ID('manufact2') IS NOT NULL
	DROP TABLE manufact2;

SELECT * INTO manufact2 FROM manufact;

IF OBJECT_ID('audit_manufact') IS NOT NULL
	DROP TRIGGER audit_manufact;

GO
CREATE TRIGGER audit_manufact ON manufact2
AFTER INSERT AS
BEGIN
	DECLARE @manu_code CHAR(3), @manu_name VARCHAR(50), @lead_time INT, @state CHAR(2)
	DECLARE @rowData VARCHAR(150)

	DECLARE CURSOR_ITEM CURSOR FOR
		SELECT  manu_code, manu_name, lead_time, state FROM inserted
	OPEN CURSOR_ITEM
	FETCH CURSOR_ITEM INTO @manu_code, @manu_name, @lead_time, @state
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Se ha ejecutado un alta de auditoria por insertar registros'
		SET @rowData = @manu_code + '|'+ @manu_name+'|' +CAST(@lead_time AS VARCHAR)+'|' + @state

		EXECUTE altaAuditoria 'manufact', 'I', @rowData
		FETCH CURSOR_ITEM INTO @manu_code, @manu_name, @lead_time, @state
	END
	CLOSE CURSOR_ITEM
	DEALLOCATE CURSOR_ITEM
END

GO

-- Pruebas
INSERT INTO manufact2 (manu_code, manu_name, lead_time, state, f_alta_audit, d_usualta_audit)
	VALUES ('AX0', 'BZZ', 10, 'ZZ', GETDATE(), 'P'),
			('AX1', 'BZZ', 10, 'ZZ', GETDATE(), 'P'),
			('AX2', 'BZZ', 10, 'ZZ', GETDATE(), 'P'),
			('AX3', 'BZZ', 10, 'ZZ', GETDATE(), 'P')

SELECT * FROM manufact2;
TRUNCATE TABLE auditoria;
SELECT * FROM auditoria;

/*******************
 *** Ejercicio (4)
 */
IF OBJECT_ID('audit_manufact_delete') IS NOT NULL
	DROP TRIGGER audit_manufact_delete;

GO
CREATE TRIGGER audit_manufact_delete ON manufact2
AFTER DELETE AS
BEGIN
	DECLARE @manu_code CHAR(3), @manu_name VARCHAR(50), @lead_time INT, @state CHAR(2)
	DECLARE @rowData VARCHAR(150)

	DECLARE CURSOR_ITEM CURSOR FOR
		SELECT  manu_code, manu_name, lead_time, state FROM deleted
	OPEN CURSOR_ITEM
	FETCH CURSOR_ITEM INTO @manu_code, @manu_name, @lead_time, @state
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Se ha ejecutado un alta de auditoria por borrado de registros'
		SET @rowData = @manu_code + '|'+ @manu_name+'|' +CAST(@lead_time AS VARCHAR)+'|' + @state

		EXECUTE altaAuditoria 'manufact', 'D', @rowData
		FETCH CURSOR_ITEM INTO @manu_code, @manu_name, @lead_time, @state
	END
	CLOSE CURSOR_ITEM
	DEALLOCATE CURSOR_ITEM
END
GO

-- Pruebas
DELETE FROM manufact2 WHERE state='AZ'
TRUNCATE TABLE auditoria;
SELECT * FROM auditoria;
SELECT * FROM manufact2;

/*******************
 *** Ejercicio (5)
 */
IF OBJECT_ID('audit_manufact_update') IS NOT NULL
	DROP TRIGGER audit_manufact_update;

GO
CREATE TRIGGER audit_manufact_update ON manufact2
AFTER UPDATE AS
BEGIN
	DECLARE @manu_code CHAR(3), @manu_name VARCHAR(50), @lead_time INT, @state CHAR(2)
	DECLARE @rowData VARCHAR(150)

	DECLARE CURSOR_ITEM CURSOR FOR
		SELECT  manu_code, manu_name, lead_time, state FROM deleted
	OPEN CURSOR_ITEM
	FETCH CURSOR_ITEM INTO @manu_code, @manu_name, @lead_time, @state
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Se ha ejecutado un alta de auditoria por modificación de registros'
		SET @rowData = @manu_code + '|'+ @manu_name+'|' +CAST(@lead_time AS VARCHAR)+'|' + @state

		EXECUTE altaAuditoria 'manufact', 'O', @rowData
		FETCH CURSOR_ITEM INTO @manu_code, @manu_name, @lead_time, @state
	END
	CLOSE CURSOR_ITEM
	DEALLOCATE CURSOR_ITEM

	DECLARE CURSOR_ITEM CURSOR FOR
		SELECT  manu_code, manu_name, lead_time, state FROM inserted
	OPEN CURSOR_ITEM
	FETCH CURSOR_ITEM INTO @manu_code, @manu_name, @lead_time, @state
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Se ha ejecutado un alta de auditoria por modificación de registros'
		SET @rowData = @manu_code + '|'+ @manu_name+'|' +CAST(@lead_time AS VARCHAR)+'|' + @state

		EXECUTE altaAuditoria 'manufact', 'N', @rowData
		FETCH CURSOR_ITEM INTO @manu_code, @manu_name, @lead_time, @state
	END
	CLOSE CURSOR_ITEM
	DEALLOCATE CURSOR_ITEM

END
GO

-- Pruebas
TRUNCATE TABLE auditoria;
SELECT * FROM auditoria;
SELECT * FROM manufact2;

UPDATE manufact2
	SET state = 'CA'
	WHERE state = 'CE'


/**************
*** Ejercicio (7)
*/
CREATE TABLE errorAudit(
	errorID INT PRIMARY KEY IDENTITY,
	sqlError INT,
	errorInfo CHAR(70),
	nombreTabla VARCHAR(30) NULL,
	operacion CHAR,
	rowData VARCHAR(255) NULL,
	usuario VARCHAR(30) DEFAULT USER,
	fecha DATETIME DEFAULT GETDATE(),
	errorStatus CHAR DEFAULT 'P'
);

/**************
*** Ejercicio (8)
*/
GO
ALTER PROCEDURE altaAuditoria
@nombreTabla VARCHAR(30), @operacion CHAR, @rowData VARCHAR(30) AS
BEGIN
	BEGIN TRY
		PRINT 'OK..'

		INSERT INTO auditoria (nombreTabla, operacion, rowData)
		VALUES (@nombreTabla, @operacion, @rowData)
	END TRY
	BEGIN CATCH
		PRINT 'ERROR..'

		INSERT INTO errorAudit (sqlError, errorInfo, nombreTabla, operacion, rowData)
		VALUES (ERROR_NUMBER(), ERROR_MESSAGE(), @nombreTabla, @operacion, @rowData)
	END CATCH
END
GO

-- pruebas
EXECUTE altaAuditoria NULL,'I', 12
EXECUTE altaAuditoria 'WWW','IIIOKOKOKOOK', 12

SELECT * FROM manufact2;

TRUNCATE TABLE auditoria;
SELECT * FROM auditoria;
SELECT * FROM errorAudit;
