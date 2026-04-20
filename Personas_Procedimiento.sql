CREATE PROCEDURE ActualizaInsertaPersonas
	 @SeccionParam INT
AS
BEGIN
    SET NOCOUNT ON;

	 DECLARE 
        @Insertados INT = 0,
        @Actualizados INT = 0,
        @Desactivados INT = 0;  -- cuando se marcan como FALSE

------------------------------------------------------------------------
    -- SECCIÓN 1: REC
    ------------------------------------------------------------------------
IF @SeccionParam = 1
BEGIN
	--INSERTAR NUEVAS PERSONAS
	INSERT INTO Recaudacion.dbo.Personas_
		SELECT
			SUBSTRING(A.RFC,0,14) AS RFC,
			ISNULL(SUBSTRING(A.CURP,0,19), '') AS CURP,
			CASE 
				WHEN LEN(TRIM(A.RFC)) = 12 THEN 'M'
				WHEN LEN(TRIM(A.RFC)) = 13 THEN 'F'
				ELSE '' 
			END AS Tipo_Persona,
			TRIM(A.nombre) AS nombre_completo,
			CASE 
				WHEN LEN(TRIM(A.RFC)) = 12 THEN TRIM(A.nombre) 
				ELSE '' 
			END AS Razon_Social,
			'' AS Tipo_Sociedad,
			ISNULL(A.nombre_, '') AS nombre_,
			isnull(A.ape_paterno,'') AS ape_paterno,
			isnull(A.ape_materno,'')AS ape_materno,
			VISITAS_KOBRA.dbo.fn_FechaDesdeRFC(a.RFC) AS Fecha_RFC,
			'FALSE' AS SAT,
			'TRUE' AS REC,
			'FALSE' AS VAL3,
			'FALSE' AS VAL4,
			'FALSE' AS VAL5,
			'FALSE' AS VAL6
		FROM (
			SELECT *, ROW_NUMBER() OVER (PARTITION BY  SUBSTRING(RFC,0,14) ORDER BY RFC) AS rn
			FROM Informacion_Estatal.dbo.REC_DETALLE
		) AS A
		LEFT JOIN Recaudacion.dbo.Personas_ AS B ON SUBSTRING(A.RFC,0,14) = TRIM(B.RFC)
	WHERE B.RFC IS NULL AND A.rn = 1;

	SET @Insertados = @@ROWCOUNT;

	-- ACTUALIZAR A TRUE CUANDO EXISTAN
	UPDATE P
	SET P.REC = 'TRUE'
	FROM Recaudacion.dbo.Personas_ P
	INNER JOIN (
		SELECT DISTINCT RFC
		FROM Informacion_Estatal.dbo.REC_DETALLE
	) AS D ON TRIM(P.RFC) = SUBSTRING(D.RFC,0,14)
	WHERE P.REC = 'FALSE';

	SET @Actualizados = @@ROWCOUNT;

	-- MARCAR EN FALSE CUANDO YA NO EXISTAN EN EL REC
	UPDATE A
	SET A.REC = 'FALSE'
	FROM Recaudacion.dbo.Personas_ A
	LEFT JOIN Informacion_Estatal.dbo.REC_DETALLE AS B ON TRIM(A.RFC) = SUBSTRING(B.RFC,0,14)
	WHERE A.REC = 'TRUE' AND B.RFC IS NULL;

	SET @Desactivados = @@ROWCOUNT;
END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--															Informacion_Estatal.dbo.REBAS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF @SeccionParam = 2
BEGIN
	INSERT INTO Recaudacion.dbo.Personas_
		SELECT
			SUBSTRING(TRIM(A.RFC),0,14) AS RFC,
			CASE WHEN LEN(A.RFC) > 13 THEN SUBSTRING(A.RFC,0,19) ELSE '' END AS CURP,
			CASE 
				WHEN LEN(TRIM(A.RFC)) = 12 or A.RAZON_SOCIAL <> ''
				THEN 'M'
				WHEN (LEN(TRIM(A.RFC)) >= 13 or LEN(TRIM(A.RFC)) = 10)  and A.RAZON_SOCIAL = '' THEN 'F'
				ELSE '' 
			END AS Tipo_Persona,
			TRIM(A.NOMBRE) + ' ' + TRIM(A.AP_PATERNO) + ' '+ TRIM(A.AP_PATERNO) AS nombre_completo,
			A.RAZON_SOCIAL,
			'' AS Tipo_Sociedad,
			ISNULL(A.NOMBRE, '') AS nombre_,
			isnull(A.AP_PATERNO,'') AS ape_paterno,
			isnull(A.AP_PATERNO,'')AS ape_materno,
			VISITAS_KOBRA.dbo.fn_FechaDesdeRFC(a.RFC) AS Fecha_RFC,
			'FALSE' AS SAT,
			'FALSE' AS REC,
			'FALSE' AS VEHICULAR,
			'TRUE' AS REBAS,
			'FALSE' AS VAL5,
			'FALSE' AS VAL6
		FROM (
			SELECT *, ROW_NUMBER() OVER (PARTITION BY  SUBSTRING(TRIM(RFC),0,14) ORDER BY RFC) AS rn
			FROM Informacion_Estatal.dbo.REBAS
		) AS A
		LEFT JOIN Recaudacion.dbo.Personas_ AS B ON SUBSTRING(TRIM(A.RFC),0,14) = TRIM(B.RFC)
		WHERE B.RFC IS NULL AND A.rn = 1;

	-- ACTUALIZAR A TRUE CUANDO EXISTAN
    UPDATE P
    SET P.REBAS = 'TRUE'
    FROM Recaudacion.dbo.Personas_ P
    INNER JOIN (
        SELECT DISTINCT RFC
        FROM Informacion_Estatal.dbo.REBAS) AS D ON trim(P.RFC) = SUBSTRING(TRIM(D.RFC),0,14)
	where p.REBAS = 'FALSE';

	SET @Actualizados = @@ROWCOUNT;

	-- MARCAR EN FALSE CUANDO YA NO EXISTAN EN EL REBAS
	UPDATE A
	SET A. REBAS = 'FALSE'
	FROM Recaudacion.dbo.Personas_ A
	LEFT JOIN Informacion_Estatal.dbo.REBAS AS B ON TRIM(A.RFC) = SUBSTRING(B.RFC,0,14)
	where A.REBAS = 'TRUE' AND B.RFC IS NULL
	
	SET @Desactivados = @@ROWCOUNT;
END


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--															Informacion_Estatal.dbo.CFDI_EMISOR
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--366,240 + 16,532 Insertados
INSERT INTO Recaudacion.dbo.Personas_
    SELECT
        SUBSTRING(TRIM(A.RfcEmisor),0,14) AS RFC,
        CASE WHEN LEN(TRIM(A.RfcEmisor)) = 12 THEN ''  ELSE A.RfcEmisor END AS CURP,
        CASE 
            WHEN LEN(TRIM(A.RfcEmisor)) = 12
			THEN 'M'
            WHEN LEN(TRIM(A.RfcEmisor)) >= 13 THEN 'F'
            ELSE '' 
        END AS Tipo_Persona,
        UPPER(A.NombreRazonSocialEmisor) AS nombre_completo,
        UPPER(A.NombreRazonSocialEmisor) AS Razon_Social,
        '' AS Tipo_Sociedad,
        '' AS nombre_,
        '' AS ape_paterno,
        '' AS ape_materno,
        CASE 
            WHEN LEN(A.RfcEmisor) = 13 AND ISNUMERIC(SUBSTRING(A.RfcEmisor, 5, 6)) = 1 THEN
                TRY_CONVERT(DATE, 
                    CASE 
                        WHEN CAST(SUBSTRING(A.RfcEmisor, 5, 2) AS INT) >= 
						CAST(RIGHT(CAST(YEAR(GETDATE()) + 1 AS CHAR(4)), 2) AS INT) THEN '19'
                        ELSE '20'
                    END +
                    SUBSTRING(A.RfcEmisor, 5, 2) + '-' +
                    SUBSTRING(A.RfcEmisor, 7, 2) + '-' +
                    SUBSTRING(A.RfcEmisor, 9, 2)
                )
            WHEN LEN(A.RfcEmisor) = 12 AND ISNUMERIC(SUBSTRING(A.RfcEmisor, 4, 6)) = 1 THEN
                TRY_CONVERT(DATE, 
                    CASE 
                        WHEN CAST(SUBSTRING(A.RfcEmisor, 4, 2) AS INT) >= 
						CAST(RIGHT(CAST(YEAR(GETDATE()) + 1 AS CHAR(4)), 2) AS INT) 
						THEN '19'
                        ELSE '20'
                    END +
                    SUBSTRING(A.RfcEmisor, 4, 2) + '-' +
                    SUBSTRING(A.RfcEmisor, 6, 2) + '-' +
                    SUBSTRING(A.RfcEmisor, 8, 2)
                )
            ELSE ''
        END AS Fecha_RFC,
        'FALSE' AS SAT,
        'FALSE' AS REC,
        'FALSE' AS VEHICULAR,
        'FALSE' AS REBAS,
        'FALSE' AS VAL5,
        'TRUE' AS CFDI
    FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY  SUBSTRING(TRIM(RfcEmisor),0,14) ORDER BY RfcEmisor) AS rn
        FROM Recaudacion.dbo.LISTADO_CFDI
    ) AS A
    LEFT JOIN Recaudacion.dbo.Personas_ AS B ON SUBSTRING(TRIM(A.RfcEmisor),0,14) = TRIM(B.RFC)
    WHERE B.RFC IS NULL AND A.rn = 1;


	--69,852 + 45
	UPDATE P
    SET P.CFDI = 'TRUE'
    
	select TOP 1000 *
	FROM Recaudacion.dbo.Personas_ P
    INNER JOIN (
        SELECT DISTINCT RfcEmisor
        FROM Recaudacion.dbo.LISTADO_CFDI) AS D ON trim(P.RFC) = SUBSTRING(TRIM(D.RfcEmisor),0,14)
	where p.CFDI = 'TRUE' AND p.NOMBRE_COMPLETO = '';


Select * from Personas_ 
left join ()
where NOMBRE_COMPLETO = '' AND RAZON_SOCIAL= '' AND CFDI = 1 and SAT = 0 AND REC = 0 AND VEHICULAR=0 AND REBAS = 0 AND RC = 0

PELG840114GY9
PELE850319A19
PELC920724MM1
PELC671126MM9
PEKM621202MX0
PEJO720623653
PEJL7107081W5
PEJF790324HL7
PEIY830922NE1
PEHR610718NP8
PEHL6904267T9
PEHJ860506R46
PEHE931114DQ2
PEHE7304202D4
PEHC890209AA1
PEGS9609302R0

SELECT TOP 100 * FROM Recaudacion.dbo.LISTADO_CFDI WHERE RfcEmisor='PEHE7304202D4' OR RfcReceptor= 'PEHE7304202D4'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--															Informacion_Estatal.dbo.CFDI_RECEPTOR
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---1,483,755 INSERTADOS
INSERT INTO Recaudacion.dbo.Personas_
    SELECT
        SUBSTRING(TRIM(A.RfcReceptor),0,14) AS RFC,
        CASE WHEN LEN(TRIM(A.RfcReceptor)) = 12 THEN ''  ELSE A.RfcReceptor END AS CURP,
        CASE 
            WHEN LEN(TRIM(A.RfcReceptor)) = 12
			THEN 'M'
            WHEN LEN(TRIM(A.RfcReceptor)) >= 13 THEN 'F'
            ELSE '' 
        END AS Tipo_Persona,
        UPPER(A.NombreRazonSocialReceptor) AS nombre_completo,
        UPPER(A.NombreRazonSocialReceptor) AS Razon_Social,
        '' AS Tipo_Sociedad,
        '' AS nombre_,
        '' AS ape_paterno,
        '' AS ape_materno,
        CASE 
            WHEN LEN(A.RfcReceptor) = 13 AND ISNUMERIC(SUBSTRING(A.RfcReceptor, 5, 6)) = 1 THEN
                TRY_CONVERT(DATE, 
                    CASE 
                        WHEN CAST(SUBSTRING(A.RfcReceptor, 5, 2) AS INT) >= 
						CAST(RIGHT(CAST(YEAR(GETDATE()) + 1 AS CHAR(4)), 2) AS INT) THEN '19'
                        ELSE '20'
                    END +
                    SUBSTRING(A.RfcReceptor, 5, 2) + '-' +
                    SUBSTRING(A.RfcReceptor, 7, 2) + '-' +
                    SUBSTRING(A.RfcReceptor, 9, 2)
                )
            WHEN LEN(A.RfcReceptor) = 12 AND ISNUMERIC(SUBSTRING(A.RfcReceptor, 4, 6)) = 1 THEN
                TRY_CONVERT(DATE, 
                    CASE 
                        WHEN CAST(SUBSTRING(A.RfcReceptor, 4, 2) AS INT) >= 
						CAST(RIGHT(CAST(YEAR(GETDATE()) + 1 AS CHAR(4)), 2) AS INT) 
						THEN '19'
                        ELSE '20'
                    END +
                    SUBSTRING(A.RfcReceptor, 4, 2) + '-' +
                    SUBSTRING(A.RfcReceptor, 6, 2) + '-' +
                    SUBSTRING(A.RfcReceptor, 8, 2)
                )
            ELSE ''
        END AS Fecha_RFC,
        'FALSE' AS SAT,
        'FALSE' AS REC,
        'FALSE' AS VEHICULAR,
        'FALSE' AS REBAS,
        'FALSE' AS RC,
        'TRUE' AS CFDI
    FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY  SUBSTRING(TRIM(RfcReceptor),0,14) ORDER BY RfcReceptor) AS rn
        FROM Recaudacion.dbo.LISTADO_CFDI
    ) AS A
    LEFT JOIN Recaudacion.dbo.Personas_ AS B ON SUBSTRING(TRIM(A.RfcReceptor),0,14) = TRIM(B.RFC)
    WHERE B.RFC IS NULL AND A.rn = 1;


	--433,896 ACTUALIZADOS
	UPDATE P
    SET P.CFDI = 'TRUE'
    FROM Recaudacion.dbo.Personas_ P
    INNER JOIN (
        SELECT DISTINCT RfcReceptor
        FROM Recaudacion.dbo.LISTADO_CFDI) AS D ON trim(P.RFC) = SUBSTRING(TRIM(D.RfcReceptor),0,14)
	where p.CFDI = 'FALSE';


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--															Informacion_Estatal.dbo.VEHICULAR
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--21,038 INSERTADOS

INSERT INTO Recaudacion.dbo.Personas_
    SELECT
        SUBSTRING(TRIM(A.rfc),0,14) AS RFC,
        CASE WHEN LEN(TRIM(A.rfc)) = 12 THEN ''  ELSE A.rfc END AS CURP,
        CASE 
            WHEN LEN(TRIM(A.rfc)) = 12
			THEN 'M'
            WHEN LEN(TRIM(A.rfc)) >= 13 THEN 'F'
            ELSE '' 
        END AS Tipo_Persona,
        UPPER(A.nombre_completo) AS nombre_completo,
        UPPER(A.razon_social) AS Razon_Social,
        '' AS Tipo_Sociedad,
        a.nombre AS nombre_,
        a.ape_paterno AS ape_paterno,
        a.ape_materno AS ape_materno,
        VISITAS_KOBRA.dbo.fn_FechaDesdeRFC(a.RFC) AS Fecha_RFC,
        'FALSE' AS SAT,
        'FALSE' AS REC,
        'TRUE' AS VEHICULAR,
        'FALSE' AS REBAS,
        'FALSE' AS RC,
        'FALSE' AS CFDI
    FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY  SUBSTRING(TRIM(rfc),0,14) ORDER BY rfc) AS rn
        FROM Informacion_Estatal.dbo.Personas_Vehicular
    ) AS A
    LEFT JOIN Recaudacion.dbo.Personas_ AS B ON SUBSTRING(TRIM(A.rfc),0,14) = TRIM(B.RFC)
    WHERE B.RFC IS NULL AND A.rn = 1;


	--351,818 ACTUALIZADOS
	UPDATE P
    SET P.VEHICULAR = 'TRUE'
	--select *
    FROM Recaudacion.dbo.Personas_ P
    INNER JOIN (
        SELECT DISTINCT rfc
        FROM Informacion_Estatal.dbo.Personas_Vehicular) AS D ON trim(P.RFC) = SUBSTRING(TRIM(D.rfc),0,14)
	where p.VEHICULAR = 'FALSE';

	--351,818 ACTUALIZADOS
	UPDATE P
    SET P.NOMBRE_COMPLETO = D.nombre_completo,
		P.RAZON_SOCIAL= D.razon_social,
		P.NOMBRE = D.nombre,
		P.AP_PATERNO = D.ape_paterno,
		P.AP_MATERNO = D.ape_materno
	--select *
    FROM Recaudacion.dbo.Personas_ P
    INNER JOIN (
        SELECT rfc, nombre_completo, razon_social, nombre, ape_paterno, ape_materno
        FROM Informacion_Estatal.dbo.Personas_Vehicular) AS D ON trim(P.RFC) = SUBSTRING(TRIM(D.rfc),0,14)
	where p.NOMBRE_COMPLETO = '' AND p.RAZON_SOCIAL= ''

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--															Informacion_Estatal.dbo.REGISTRO_CIVIL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF @SeccionParam = 3
BEGIN
	INSERT INTO Recaudacion.dbo.Personas_
		SELECT
			SUBSTRING(TRIM(A.rfc),0,14) AS RFC,
			CASE WHEN LEN(TRIM(A.rfc)) = 12 THEN ''  ELSE A.rfc END AS CURP,
			CASE 
				WHEN LEN(TRIM(A.rfc)) = 12
				THEN 'M'
				WHEN LEN(TRIM(A.rfc)) >= 13 THEN 'F'
				ELSE '' 
			END AS Tipo_Persona,
			UPPER(CONCAT(A.NOMBRE , ' ' , A.AP_PATERNO , ' ' , A.AP_MATERNO)) AS nombre_completo,
			'' AS Razon_Social,
			'' AS Tipo_Sociedad,
			a.nombre AS nombre_,
			a.ap_paterno AS ape_paterno,
			a.ap_materno AS ape_materno,
			VISITAS_KOBRA.dbo.fn_FechaDesdeRFC(a.RFC) AS Fecha_RFC,
			'FALSE' AS SAT,
			'FALSE' AS REC,
			'FALSE' AS VEHICULAR,
			'FALSE' AS REBAS,
			'TRUE' AS RC,
			'FALSE' AS CFDI
		FROM (
			SELECT *, ROW_NUMBER() OVER (PARTITION BY  SUBSTRING(TRIM(rfc),0,14) ORDER BY rfc) AS rn
			FROM Recaudacion.dbo.PERSONAS_RC
		) AS A
		LEFT JOIN Recaudacion.dbo.Personas_ AS B ON SUBSTRING(TRIM(A.rfc),0,14) = TRIM(B.RFC)
		WHERE B.RFC IS NULL AND A.rn = 1;

	SET @Insertados = @@ROWCOUNT;


	-- ACTUALIZAR A TRUE CUANDO EXISTAN
	UPDATE P
    SET P.RC = 'TRUE'
	--select *
    FROM Recaudacion.dbo.Personas_ P
    INNER JOIN (
        SELECT DISTINCT rfc
        FROM  Recaudacion.dbo.PERSONAS_RC) AS D ON trim(P.RFC) = SUBSTRING(TRIM(D.rfc),0,14)
	where p.RC = 'FALSE';

	SET @Actualizados = @@ROWCOUNT;
END

 SELECT 
        @SeccionParam AS Seccion,
        @Insertados AS Insertados,
        @Actualizados AS Actualizados,
        @Desactivados AS Desactivados;
END;

