CREATE DATABASE BW_RECAUDACION;

CREATE DATABASE Declaraciones_Fisicas

CREATE DATABASE Ejecucion

CREATE DATABASE Informacion_Estatal

CREATE DATABASE Informacion_Estatal_Temporal

CREATE DATABASE Informacion_Federal

CREATE DATABASE Promocion

CREATE DATABASE Recaudacion

CREATE DATABASE Reporte_Ingresos

CREATE DATABASE VISITAS_KOBRA

CREATE LOGIN [aperezmo] WITH PASSWORD = 'xU4CwGS2WuKrHA0';
CREATE LOGIN [ajmcarpio] WITH PASSWORD = '3ZKtqXALpMRv9b';
CREATE LOGIN [ameyalli] WITH PASSWORD = '49QTxsbNvpMAzK';
CREATE LOGIN [angelica.fernandezg] WITH PASSWORD = 'Sil892531$';
CREATE LOGIN [cvillagomezp] WITH PASSWORD = '7LmPvqXaTZb29K';
CREATE LOGIN [dgamezme] WITH PASSWORD = 'aK73ZqL2bM9xVp';
CREATE LOGIN [emartinezol] WITH PASSWORD = 'AVKqLmNt73XPbz';
CREATE LOGIN [fledesmap] WITH PASSWORD = 'aWZKqLp83xt1VN';
CREATE LOGIN [gcisnerosg] WITH PASSWORD = 'bKZXPqtA9Lmv7R';
CREATE LOGIN [hlopezgomez] WITH PASSWORD = 'bP2tZK9XqVwCmr';
CREATE LOGIN [lona.jorge] WITH PASSWORD = 'KqtLMzVp89RxWa';
CREATE LOGIN [jespinosav] WITH PASSWORD = 'Temporal2024.';
CREATE LOGIN [jpaniaguavi] WITH PASSWORD = 'MkXvp7qWyN38LA';
CREATE LOGIN [jcastanedaar] WITH PASSWORD = 'NX2Lm79tPqvbKR';


CREATE LOGIN [heriberto.alvarado] WITH PASSWORD = 'qKPmaVXr39TZbL';
CREATE LOGIN [jtorresb] WITH PASSWORD = 'R9KXzLpWTq8v3M';
CREATE LOGIN [kvrojasr] WITH PASSWORD = 'Rxm92YtpqLa5Ve';
CREATE LOGIN [lalcarazb] WITH PASSWORD = 'Sateg2025.';
CREATE LOGIN [juarez.leonardo] WITH PASSWORD = 'VmKPtzLX8qANr3';
CREATE LOGIN [mbarrientosm] WITH PASSWORD = 'Temporal2025.';
CREATE LOGIN [mmelladom] WITH PASSWORD = 'WqAKmpZXLt3vB9';
CREATE LOGIN [nltorres] WITH PASSWORD = 'Liz1269*';
CREATE LOGIN [sespinosas] WITH PASSWORD = 'zqVKmtL9P3XWAb';
CREATE LOGIN [tfuentesmu] WITH PASSWORD = 'Pelusa18.';
CREATE LOGIN [declaraciones_sectorial] WITH PASSWORD = 'qL8VmP9AZXt3Rb';
CREATE LOGIN [declaraciones] WITH PASSWORD = 'Temporal2024';
CREATE LOGIN [sas] WITH PASSWORD = 'KxZpA73NvqMLt9';
CREATE LOGIN [tableros] WITH PASSWORD = 'bRMXz8LtKqV1Ap';
CREATE LOGIN [obtiene.informacion] WITH PASSWORD = 'T3mp0r@l_2025';
CREATE LOGIN [motor.busqueda] WITH PASSWORD = 'T3mp0r@l_2025';
CREATE LOGIN [api] WITH PASSWORD = 'T3mp0r@l_2025';
CREATE LOGIN [rpp.catastro] WITH PASSWORD = 'T3mp0r@l_2025';
CREATE LOGIN [registro.civil] WITH PASSWORD = 'T3mp0r@l_2025';
CREATE LOGIN [micro.ejecucion] WITH PASSWORD = 'T3mp0r@l_2025';
CREATE LOGIN [micro.informacion] WITH PASSWORD = 'T3mp0r@l_2025';
CREATE LOGIN [fafd] WITH PASSWORD = 'T3mp0r@l_2025';
CREATE LOGIN [micro.187] WITH PASSWORD = 'T3mp0r@l_2025';
CREATE LOGIN [scripts.python] WITH PASSWORD = 'T3mp0r@l_2025';
CREATE LOGIN [importa.cfdi] WITH PASSWORD = 'T3mp0r@l_2025';
CREATE LOGIN [bwrecaudacion] WITH PASSWORD = 'T3mp0r@l_2@25';
CREATE LOGIN [mgasca] WITH PASSWORD = 'S@t3g2025';
CREATE LOGIN [jzamarripaz] WITH PASSWORD = 'S@t3g2025@';
CREATE LOGIN [fledesmap] WITH PASSWORD = 'Temporal2025.';
CREATE LOGIN [fledesmap] WITH PASSWORD = 'Temporal2025.';
CREATE LOGIN [evillafuerter] WITH PASSWORD = 'VIRE980916RT0@';
CREATE LOGIN [maramirezpe] WITH PASSWORD = 'RAPM971203DV4@';
CREATE LOGIN [microservicios] WITH PASSWORD = 'T3mp0r@l_2025';

CREATE LOGIN [juan.hernandezal] WITH PASSWORD = 'SzdrWdGr@2025';
CREATE LOGIN [jlopezj] WITH PASSWORD = 'Temporal2025@';
CREATE LOGIN [hmachucav] WITH PASSWORD = 'Sat3G2025@';
CREATE LOGIN [safonsecap] WITH PASSWORD = 'Sat3G2025@';
CREATE LOGIN [jnunezt] WITH PASSWORD = 'Sat3G2025@';
CREATE LOGIN [xml] WITH PASSWORD = 'Sat3G25@'

CREATE LOGIN [ollama] WITH PASSWORD = 'Temporal2026@'

ALTER LOGIN dgamezme WITH PASSWORD = 'Miranda07!'
ALTER LOGIN cvillagomezp WITH PASSWORD = 'Temporal2025.'
ALTER LOGIN evillafuerter WITH PASSWORD = 'VIRE980916RT0@@@'
ALTER LOGIN emartinezol WITH PASSWORD = 'Temporal2025'

ALTER LOGIN jlopezj WITH PASSWORD = 'Temporal2026.'

ALTER LOGIN tfuentesmu WITH PASSWORD = 'Pelusa18.';

select TOP 10* from PedimentosIndexados


GRANT CONTROL 
ON OBJECT::dbo.sat_datos_qweb
TO jpaniaguavi;



--Rol de servidor	¿Qué permite hacer?
--sysadmin		Control total sobre todo el servidor. Puede hacer cualquier cosa. ¡Cuidado con asignarlo!
--serveradmin	Puede cambiar configuraciones del servidor, apagarlo, etc.
--securityadmin	Puede administrar logins, roles, permisos de servidor, y restablecer contraseñas.
--processadmin	Puede finalizar procesos que se estén ejecutando (como matar sesiones).
--setupadmin	Puede ejecutar tareas de configuración del servidor, como agregar servidores vinculados.
--bulkadmin		Puede ejecutar operaciones de importación masiva (BULK INSERT).
--diskadmin		Puede administrar discos y archivos de respaldo.
--dbcreator		Puede crear, modificar, borrar y restaurar bases de datos.

172.31.5.146
scripts.python
T3mp0r@l_2025

    conn_sql = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=172.31.5.146;"
    "DATABASE=Informacion_Estatal;"
    "UID=scripts.python;"
    "PWD=T3mp0r@l_2025;")



SELECT name AS LoginName, type_desc AS Tipo, is_disabled, create_date, modify_date
FROM sys.server_principals
WHERE type IN ('S', 'U') AND name NOT LIKE '##%';

SELECT name AS Usuario, type_desc AS Tipo, create_date, modify_date
FROM sys.database_principals
WHERE type IN ('S', 'U') AND name NOT LIKE '##%';

select * from sys.database_principals


EXEC UsersRoles;



CREATE PROCEDURE UsersRoles
AS
BEGIN
    SET NOCOUNT ON;

    -- Tabla temporal para acumular todos los datos
    CREATE TABLE #Results (
        DatabaseName       SYSNAME,
        LoginName          SYSNAME,
        IsDisabled         BIT,
        LoginCreateDate    DATETIME,
        LoginModifyDate    DATETIME,
        DbPrincipalName    SYSNAME NULL,
        DbPrincipalType    NVARCHAR(60) NULL,
        Roles              NVARCHAR(MAX) NULL,
        HasRoles           BIT
    );

    DECLARE @DBName SYSNAME;
    DECLARE @SQL    NVARCHAR(MAX);

    -- Cursor que recorre todas las bases online excepto las de sistema
    DECLARE db_cursor CURSOR FOR
        SELECT name
        FROM sys.databases
        WHERE state = 0
          AND name NOT IN ('master','model','msdb','tempdb');

    OPEN db_cursor;
    FETCH NEXT FROM db_cursor INTO @DBName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @SQL = N'
        INSERT INTO #Results
            (DatabaseName, LoginName, IsDisabled, LoginCreateDate, LoginModifyDate,
             DbPrincipalName, DbPrincipalType, Roles, HasRoles)
        SELECT
            N''' + @DBName + N'''                        AS DatabaseName,
            sp.name                                      AS LoginName,
            sp.is_disabled                               AS IsDisabled,
            sp.create_date                               AS LoginCreateDate,
            sp.modify_date                               AS LoginModifyDate,
            dp.name                                      AS DbPrincipalName,
            dp.type_desc                                 AS DbPrincipalType,
            ISNULL(STRING_AGG(r.name, '',''), '''')      AS Roles,
            CASE WHEN COUNT(r.name) > 0 THEN 1 ELSE 0 END AS HasRoles
        FROM master.sys.server_principals sp
        LEFT JOIN ' + QUOTENAME(@DBName) + N'.sys.database_principals dp
            ON sp.sid = dp.sid
        LEFT JOIN ' + QUOTENAME(@DBName) + N'.sys.database_role_members drm
            ON drm.member_principal_id = dp.principal_id
        LEFT JOIN ' + QUOTENAME(@DBName) + N'.sys.database_principals r
            ON drm.role_principal_id = r.principal_id
        WHERE sp.type_desc IN (''SQL_LOGIN'') and sp.name not in (''##MS_PolicyEventProcessingLogin##'', ''##MS_PolicyTsqlExecutionLogin##'')
 
        GROUP BY
            sp.name, sp.is_disabled, sp.create_date, sp.modify_date,
            dp.name, dp.type_desc;
        ';

        EXEC sp_executesql @SQL;
        FETCH NEXT FROM db_cursor INTO @DBName;
    END

    CLOSE db_cursor;
    DEALLOCATE db_cursor;

    -- Mostrar todo, ordenando primero quienes TIENEN roles y luego los que no
    SELECT 
        DatabaseName,
        LoginName,
        IsDisabled,
        LoginCreateDate,
        LoginModifyDate,
        DbPrincipalName,
        DbPrincipalType,
        Roles,
        HasRoles
    FROM #Results
    ORDER BY 
        DatabaseName,
        HasRoles DESC,
        LoginName,
        DbPrincipalName;

    DROP TABLE #Results;
END
GO

GO








