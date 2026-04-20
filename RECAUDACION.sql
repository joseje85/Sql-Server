
-- --------------------------------------------------------------------------------------
--									SISTEMA DE PAGOS
-- --------------------------------------------------------------------------------------
SELECT 
CASE WHEN B.CIUDAD= 'LEON DE LOS ALDAMA'  OR B.CIUDAD='LEON' OR B.CIUDAD='LEÓN DE LOS ALDAMA' OR B.CIUDAD='BENITO JUAREZ' OR B.CIUDAD= 'ZAPOPAN' THEN 'LEÓN' 
WHEN B.CIUDAD = 'ALLENDE' OR B.CIUDAD = 'ACAPETAHUA' OR B.CIUDAD= 'CUAUHTEMOC' THEN 'SAN MIGUEL DE ALLENDE'
WHEN B.CIUDAD = 'ACAMBARO' OR B.CIUDAD='TLALNEPANTLA DE BAZ' THEN 'ACÁMBARO'
WHEN B.CIUDAD = 'CD. MANUEL DOBLADO' THEN 'MANUEL DOBLADO'
WHEN B.CIUDAD = 'DELEGACION CUAUHTEMOC' THEN 'CELAYA'
WHEN B.CIUDAD = 'DOLORES HIDALGO CUNA DE LA INDEPENDENCIA' THEN 'DOLORES HIDALGO'
WHEN B.CIUDAD = 'HUANIMARO' THEN 'HUANÍMARO'
WHEN B.CIUDAD = 'JERECUARO' THEN 'JERÉCUARO'
WHEN B.CIUDAD = 'MOROLEON' THEN 'MOROLEÓN'
WHEN B.CIUDAD = 'NAJUATO' OR B.CIUDAD='PLAZA DE LA PAZ' THEN 'GUANAJUATO'
WHEN B.CIUDAD = 'SILAO DE LA VICTORIA' OR B.CIUDAD= 'ORIZABA' THEN 'SILAO'
WHEN B.CIUDAD = 'PENJAMO'  THEN 'PÉNJAMO'
WHEN B.CIUDAD = 'PURISIMA DEL RINCON'  THEN 'PURÍSIMA DEL RINCÓN'
WHEN B.CIUDAD = 'SAN DIEGO DE LA UNION' OR B.CIUDAD= 'SN DIEGO DE LA UNIÓN'  THEN 'SAN DIEGO DE LA UNIÓN'
WHEN B.CIUDAD = 'SAN FRANCISCO DEL RINCON'  THEN 'SAN FRANCISCO DEL RINCÓN'
WHEN B.CIUDAD = 'SAN JOSE ITURBIDE'  THEN 'SAN JOSÉ ITURBIDE'
WHEN B.CIUDAD = 'STA CRUZ JUVENTINO R' OR B.CIUDAD= 'SANTA CRUZ DE JUVENTINO ROSAS' THEN 'JUVENTINO ROSAS'
WHEN B.CIUDAD = 'VILLAGRAN'  THEN 'VILLAGRÁN'
WHEN B.CIUDAD = 'ZAPOPAN'  THEN 'XICHÚ'
ELSE UPPER(TRIM(B.CIUDAD))
END AS CIUDAD , TRIM(A.RFC)AS RFC, MAX(A.Parter) AS Partner , A.Ejercicio,A.Periodo, MAX(A.Fecha) as Fecha, A.Importe,MAX(A.Clave_Subclave)as Clave_Subclave   FROM PAGOS_REGISTRADOS_PARA_DEPURAR AS A
LEFT JOIN (SELECT TRIM(RFC)AS RFC , TRIM(CIUDAD) AS CIUDAD  FROM PADRON_TEMP_ GROUP BY RFC, CIUDAD) AS B ON TRIM(A.RFC)= TRIM(B.RFC)
WHERE A.Clave_Subclave IN ('1005-1001','1005-1002','1005-0001','1005-0002') and A.Fecha BETWEEN '20241001' AND '20241231'
GROUP BY B.CIUDAD , A.RFC, A.Ejercicio,A.Periodo, A.Importe
ORDER BY Ejercicio DESC


SELECT * FROM (
SELECT 
CASE WHEN B.CIUDAD= 'LEON DE LOS ALDAMA'  OR B.CIUDAD='LEON' OR B.CIUDAD='LEÓN DE LOS ALDAMA' OR B.CIUDAD='BENITO JUAREZ' OR B.CIUDAD= 'ZAPOPAN' THEN 'LEÓN' 
WHEN B.CIUDAD = 'ALLENDE' OR B.CIUDAD = 'ACAPETAHUA' OR B.CIUDAD= 'CUAUHTEMOC' THEN 'SAN MIGUEL DE ALLENDE'
WHEN B.CIUDAD = 'ACAMBARO' OR B.CIUDAD='TLALNEPANTLA DE BAZ' THEN 'ACÁMBARO'
WHEN B.CIUDAD = 'CD. MANUEL DOBLADO' THEN 'MANUEL DOBLADO'
WHEN B.CIUDAD = 'DELEGACION CUAUHTEMOC' THEN 'CELAYA'
WHEN B.CIUDAD = 'DOLORES HIDALGO CUNA DE LA INDEPENDENCIA' THEN 'DOLORES HIDALGO'
WHEN B.CIUDAD = 'HUANIMARO' THEN 'HUANÍMARO'
WHEN B.CIUDAD = 'JERECUARO' THEN 'JERÉCUARO'
WHEN B.CIUDAD = 'MOROLEON' THEN 'MOROLEÓN'
WHEN B.CIUDAD = 'NAJUATO' OR B.CIUDAD='PLAZA DE LA PAZ' THEN 'GUANAJUATO'
WHEN B.CIUDAD = 'SILAO DE LA VICTORIA' OR B.CIUDAD= 'ORIZABA' THEN 'SILAO'
WHEN B.CIUDAD = 'PENJAMO'  THEN 'PÉNJAMO'
WHEN B.CIUDAD = 'PURISIMA DEL RINCON'  THEN 'PURÍSIMA DEL RINCÓN'
WHEN B.CIUDAD = 'SAN DIEGO DE LA UNION' OR B.CIUDAD= 'SN DIEGO DE LA UNIÓN'  THEN 'SAN DIEGO DE LA UNIÓN'
WHEN B.CIUDAD = 'SAN FRANCISCO DEL RINCON'  THEN 'SAN FRANCISCO DEL RINCÓN'
WHEN B.CIUDAD = 'SAN JOSE ITURBIDE'  THEN 'SAN JOSÉ ITURBIDE'
WHEN B.CIUDAD = 'STA CRUZ JUVENTINO R' OR B.CIUDAD= 'SANTA CRUZ DE JUVENTINO ROSAS' THEN 'JUVENTINO ROSAS'
WHEN B.CIUDAD = 'VILLAGRAN'  THEN 'VILLAGRÁN'
WHEN B.CIUDAD = 'ZAPOPAN'  THEN 'XICHÚ'
ELSE UPPER(TRIM(B.CIUDAD)) 
END AS CIUDAD , TRIM(A.RFC)AS RFC, A.Parter, A.Obligacion, A.Ejercicio,A.Periodo, A.Fecha, A.Importe,A.Clave_Subclave, C.cve_municipio, C.cve_mundir   FROM PAGOS_REGISTRADOS_PARA_DEPURAR AS A
LEFT JOIN 
	(SELECT TRIM(RFC)AS RFC , TRIM(CIUDAD) AS CIUDAD  FROM PADRON_TEMP_ GROUP BY RFC, CIUDAD) AS B ON TRIM(A.RFC)= TRIM(B.RFC)
LEFT JOIN 
	(SELECT CAST(CAST(PSOBKEY AS VARCHAR) AS BIGINT) AS contrato, cve_municipio, cve_mundir FROM REBAS) as C ON A.Obligacion = C.contrato
WHERE  A.Fecha BETWEEN '20241001' AND '20241231' AND (A.Clave_Subclave LIKE '%4004%' OR A.Clave_Subclave LIKE '%4005%' OR A.Clave_Subclave LIKE '%4006%' OR A.Clave_Subclave LIKE '%4007%' OR A.Clave_Subclave LIKE '%4008%')
GROUP BY B.CIUDAD , A.RFC, A.Ejercicio,A.Periodo, A.Importe, A.Parter,A.Obligacion, A.Fecha,A.Clave_Subclave,  C.cve_municipio, C.cve_mundir
) AS Z WHERE z.Parter like '%150102060223%'




CREATE TABLE Pedimentos( 
id INT IDENTITY PRIMARY KEY, 
origen NVARCHAR(250), 
data NVARCHAR(MAX)) -- Aquí se guarda el JSON completo fecha_carga DATETIME DEFAULT GETDATE() )

Select * from Pedimentos

SELECT 
    id,
    origen,
    JSON_VALUE(data, '$.RFC') AS RFC,
    JSON_VALUE(data, '$.nOMBRE_') AS Nombre
FROM Pedimentos
WHERE JSON_VALUE(data, '$.rfc') like '%CAGS%';

SELECT p.id, p.origen, p.data
FROM Pedimentos p
CROSS APPLY OPENJSON(p.data) AS j
WHERE j.value like '%CAGS%';


SELECT *
FROM OPENJSON(
    (SELECT data FROM Pedimentos WHERE id = 10)
);

select distinct origen from Pedimentos


select top 100 * from Pedimentos WHERE data like '%RUPD910808LE7%'

CREATE FULLTEXT CATALOG PedimentosFTCatalog AS DEFAULT;

CREATE FULLTEXT INDEX ON Pedimentos(data LANGUAGE 1033)
KEY INDEX PK_Pedimentos;

CREATE TABLE PedimentosIndexados (
    id INT NOT NULL,
    clave NVARCHAR(255) NOT NULL,
    valor NVARCHAR(450) NOT NULL,
    CONSTRAINT PK_PedimentosIndexados PRIMARY KEY (id, clave, valor)
);


INSERT INTO PedimentosIndexados (id, clave, valor)
SELECT p.id, j.[key], LEFT(j.[value], 450)
FROM Pedimentos p
CROSS APPLY OPENJSON(p.data) j
WHERE j.[value] IS NOT NULL;



select top 100* from Pedimentos
3,890,649

select top 100 * from PedimentosIndexados

3,890,649

SELECT TOP 10000 *FROM Decreto_Vehicular order by 

select * from tasas_recargos order by anio desc

--Revisar lo del Wallet

sp_who2

SELECT 
    blocking_session_id AS Bloquea,
    session_id AS Espera,
    wait_type,
    wait_time,
    t.text AS QueryEsperando
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE blocking_session_id <> 0
ORDER BY wait_time DESC;

SELECT 
    r.session_id,
    s.login_name,
    r.granted_query_memory*8 AS granted_memory_kb,
    r.cpu_time,
    r.total_elapsed_time,
    DB_NAME(r.database_id) AS database_name,
    t.text AS query_text
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.granted_query_memory > 50000;

kill 110;


sp_helptext 'INFORMACION_BASICA'

kill 100

KILL 90;
KILL 92;
KILL 96;

KILL 93;
KILL 95;
KILL 111;





---177,981

select 
	--DISTINCT(SUBSTRING(trim(PERIODO), 1,2)), PERIODO
	COUNT(DISTINCT OBJETO_CONTRATO) AS num_vehiculos,
	SUM(TRY_CAST(Importe AS DECIMAL(18,2))) AS importe_vehiculos
from Decreto_Vehicular WHERE SUBSTRING (trim(PERIODO), 1,2)<'2020'

vehiculos = 177,939


select 
COUNT(DISTINCT Obligacion) as num_vehiculos , SUM(Importe) 
from (
select 
	P.Obligacion,
	P.Parter,
	P.Clave_Subclave,
	DV.OBJETO_CONTRATO,
	MAX(DV.PERIODO) AS PERIODO,
	SUM(P.Importe) AS Importe
from PAGOS_REGISTRADOS_PARA_DEPURAR as P
INNER JOIN 
	(SELECT OBJETO_CONTRATO, MAX(PERIODO)AS PERIODO FROM Decreto_Vehicular GROUP BY OBJETO_CONTRATO) AS DV ON CAST(tRIM(P.Obligacion) AS BIGINT) = CAST(TRIM(DV.OBJETO_CONTRATO) AS BIGINT)
WHERE P.Fecha >= '20250908'
GROUP BY P.Obligacion,
	P.Parter,
	P.Clave_Subclave,
	DV.OBJETO_CONTRATO) AS Z

--13,727,678.00
--14,170,595.00
--16,662,881.00

select count(*) as Periodos , count(distinct(rfc)) as Contribuyentes, sum(Importe) as recauda
from
(    select Ejercicio , Periodo , rfc , sum(importe) as Importe from
(
    select trim(A.rfc) as rfc,A.ejercicio,A.periodo,A.fecha,A.importe,A.Clave_Subclave as cve_subcve,B.NOMBRE_COMPLETO as nombre from
        (
            select * from PAGOS_REGISTRADOS_PARA_DEPURAR where fecha >= '20250908' and ejercicio < 2025 and SUBSTRING(Clave_Subclave,1,4) in('1001', '1002', '1004', '1005', '1006', '1007', '1010', '1012') and importe>0
            union all
            select * from PAGOS_REGISTRADOS_PARA_DEPURAR where fecha >= '20250908' and ejercicio = 2025 and periodo <= 7 and SUBSTRING(Clave_Subclave,1,4) in('1001', '1002', '1004', '1005', '1006', '1007', '1010', '1012') and importe>0
        ) as A
        left join Recaudacion.dbo.Personas_ as B on (trim(A.rfc) = trim(B.rfc))
) as z group by Ejercicio , Periodo , rfc) as X


2066	 4,574,114.50 	 2,077,635.35 	 4,782,899.57 

select 
--COUNT(DISTINCT Obligacion) as num_vehiculos , SUM(PRINCIPAL) as PRINCIPAL, SUM(ACTUALIZACION) AS ACTUALIZACION, SUM(RECARGOS) AS RECARGOS
from (
select
	P.Obligacion,
	SUM(PRINCIPAL) AS PRINCIPAL,
	SUM(ACTUALIZACION) AS ACTUALIZACION,
	SUM(RECARGOS) AS RECARGOS
	--MAX(DV.Ejercicio_Adeudo) AS Ejercicio_Adeudo,
	--SUM(DV.Importe_Recargado_Actualizado) as Importe
	--SUM(DV.Importe_Recargado_Actualizado) AS Importe
from (SELECT Obligacion,SUM(IMPORTE) AS IMPORTE  FROM  PAGOS_REGISTRADOS_PARA_DEPURAR WHERE Fecha >= '20250908' GROUP BY Obligacion) as P
LEFT JOIN 
	(SELECT objeto_contrato ,SUM(COALESCE(TRY_CAST(IMPORTE AS DECIMAL(18,2)), 0)) AS PRINCIPAL , SUM(Importe_Actualizacion) AS ACTUALIZACION, SUM(IMPORTE_RECARGOS) AS RECARGOS
	FROM	Actualizaciones_Recargos_Vehicular
	GROUP BY objeto_contrato
) AS DV ON CAST(tRIM(P.Obligacion) AS BIGINT) = CAST(TRIM(DV.objeto_contrato) AS BIGINT)
GROUP BY P.Obligacion) AS Z



9925     20,170,925.00     9,109,763.78     21,152,830.19

Select TOP 100* from REC_BP

SELECT * FROM REC_DETALLE


select top 100 * from Informacion_Estatal.dbo.PADRON_TEMP


SELECT TOP 100 * FROM Actualizaciones_Recargos_Vehicular

SELECT IMPORTE , COUNT(*) FROM Decreto_Vehicular 
GROUP BY IMPORTE
WHERE IMPORTE =0



SP_HELPTEXT Actualizaciones_Recargos_Vehicular


select top 1000 * from PAGOS_REGISTRADOS_PARA_DEPURAR ORDER BY Fecha desc
	
select count * from Recaudacion.dbo.CONTACTO

1,956,856

--1,931,537

CREATE UNIQUE INDEX UX_CONTACTO_UNICO
ON CONTACTO (rec, tipo, contacto, origen);


select top 100 * from Informacion_Federal.dbo.correos where correo_electronico like '%lafargeholcim.com%'

ALTER TABLE VEHICULOS_REFRENDO
ADD CONSTRAINT PK_VEHICULOS_REFRENDO PRIMARY KEY (PLACA)

CREATE TABLE VEHICULOS_REFRENDO (
    RFC VARCHAR(14),
    PARTNER VARCHAR(20),
    OC VARCHAR(30),
    NOMBRE_COMPLETO VARCHAR(300),
    PLACA VARCHAR(20) PRIMARY KEY,
    MODELO VARCHAR(50),
    MARCA VARCHAR(50),
    ULT_ANIO_PAGO VARCHAR(4)
);


select ULT_ANIO_PAGO, count(*) 
from VEHICULOS_REFRENDO 
group by ULT_ANIO_PAGO
order by ULT_ANIO_PAGO

select COUNT(*) from VEHICULOS_REFRENDO 
---401,438
---863,325

select count(*) from (
select  
	vr.RFC,
    vr.PLACA,
    vr.OC,
    vr.MODELO,
    vr.MARCA,
    vr.ULT_ANIO_PAGO,
    Recaudacion.dbo.fn_LimpiaTelefono(c.contacto) AS telefono,
    Recaudacion.dbo.fn_LimpiaTelefono(b.telefono) AS telefono_estatal,
    ISNULL(d.correo_electronico, '') AS correo_federal,
    ISNULL(b.correo, '') AS correo_estatal
from Informacion_Estatal.dbo.VEHICULOS_REFRENDO as vr
INNER JOIN (SELECT rec, contacto FROM Recaudacion.dbo.CONTACTO group by rec, contacto) AS C ON TRIM(C.rec) = TRIM(vr.RFC)
INNER JOIN (SELECT RFC, MAX(correo_electronico)AS correo_electronico FROM Informacion_Federal.dbo.CORREOS GROUP BY RFC) AS D ON D.RFC = vr.RFC
INNER JOIN (SELECT RFC, Max(correo)as correo, max(telefono)as telefono FROM Informacion_Estatal.dbo.REC_DETALLE group by RFC) as B ON trim(B.RFC) = trim(vr.RFC)
WHERE vr.ULT_ANIO_PAGO = 2019
group by 
	vr.RFC,
    vr.PLACA,
    vr.OC,
    vr.MODELO,
    vr.MARCA,
    vr.ULT_ANIO_PAGO,
	Recaudacion.dbo.fn_LimpiaTelefono(c.contacto),
    Recaudacion.dbo.fn_LimpiaTelefono(b.telefono),
    ISNULL(d.correo_electronico, ''),
    ISNULL(b.correo, '')) as z

select count(*) from Informacion_Estatal.dbo.VEHICULOS_REFRENDO where ULT_ANIO_PAGO = 2025
808,710
--1,873,389

 ISNULL(b.correo, '') AS correo_estatal

delete from VEHICULOS_REFRENDO where ULT_ANIO_PAGO = 2026

SELECT RFC, PLACA, correo_federal, ULT_ANIO_PAGO FROM (
select  
	vr.RFC,
    vr.PLACA,
    ISNULL(d.correo_electronico, '') AS correo_federal,
	Recaudacion.dbo.fn_LimpiaTelefono(c.contacto) as telefono,
	vr.ULT_ANIO_PAGO
from Informacion_Estatal.dbo.VEHICULOS_REFRENDO as vr
INNER JOIN (SELECT RFC, MAX(correo_electronico)AS correo_electronico FROM Informacion_Federal.dbo.CORREOS GROUP BY RFC) AS D ON D.RFC = vr.RFC
WHERE d.correo_electronico IS NOT NULL OR TRIM(d.correo_electronico) <> ''
UNION
select  
	vr.RFC,
    vr.PLACA,
	ISNULL(b.correo, '') AS correo_federal,
	vr.ULT_ANIO_PAGO
from Informacion_Estatal.dbo.VEHICULOS_REFRENDO as vr
INNER JOIN (SELECT RFC, Max(correo)as correo, max(telefono)as telefono FROM Informacion_Estatal.dbo.REC_DETALLE group by RFC) as B ON trim(B.RFC) = trim(vr.RFC)
WHERE b.correo IS NOT NULL OR TRIM(b.correo) <> ''
)as x where x.correo_federal <> ''
GROUP BY RFC, PLACA, correo_federal, ULT_ANIO_PAGO


SELECT RFC, correo_federal
FROM (
    SELECT  
        vr.RFC,
        vr.PLACA,
        ISNULL(LOWER(d.correo_electronico), '') AS correo_federal,
        ISNULL(Recaudacion.dbo.fn_LimpiaTelefono(c.contacto),'') AS telefono,
        vr.ULT_ANIO_PAGO
    FROM Informacion_Estatal.dbo.VEHICULOS_REFRENDO AS vr
    INNER JOIN (
        SELECT rec, MAX(contacto) AS contacto
        FROM Recaudacion.dbo.CONTACTO
        GROUP BY rec) AS C ON TRIM(C.rec) = TRIM(vr.RFC)
    INNER JOIN (
        SELECT RFC, MAX(correo_electronico) AS correo_electronico
        FROM Informacion_Federal.dbo.CORREOS
        GROUP BY RFC) AS D ON D.RFC = vr.RFC
    WHERE d.correo_electronico IS NOT NULL 
          AND TRIM(d.correo_electronico) <> ''
    UNION
    SELECT  
        vr.RFC,
        vr.PLACA,
        ISNULL(LOWER(b.correo), '') AS correo_federal,
        ISNULL(Recaudacion.dbo.fn_LimpiaTelefono(b.telefono), '') AS telefono,
        vr.ULT_ANIO_PAGO
    FROM Informacion_Estatal.dbo.VEHICULOS_REFRENDO AS vr
    INNER JOIN (
        SELECT RFC, 
               MAX(correo) AS correo, 
               MAX(telefono) AS telefono
        FROM Informacion_Estatal.dbo.REC_DETALLE
        GROUP BY RFC) AS B ON TRIM(B.RFC) = TRIM(vr.RFC)
    WHERE b.correo IS NOT NULL 
          AND TRIM(b.correo) <> ''
) AS X
WHERE X.correo_federal <> ''
GROUP BY 
    RFC, 
    correo_federal


278,855
SELECT top 100 * FROM Informacion_Estatal.dbo.REC_DETALLE

select top 100 * from Informacion_Estatal.dbo.PADRON_TEMP

CREATE OR ALTER FUNCTION dbo.fn_LimpiaTelefono (@telefono VARCHAR(50))
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @limpio VARCHAR(50);
    DECLARE @pos INT;

    -- Si viene nulo
    IF @telefono IS NULL
        RETURN NULL;

    -- 1️ Quitar todo lo que no sea número
    SET @limpio = '';
    DECLARE @i INT = 1;

    WHILE @i <= LEN(@telefono)
    BEGIN
        IF SUBSTRING(@telefono, @i, 1) LIKE '[0-9]'
            SET @limpio += SUBSTRING(@telefono, @i, 1);
        SET @i += 1;
    END

    -- 2️ Quitar ceros a la izquierda
    SET @pos = PATINDEX('%[^0]%', @limpio);

    IF @pos > 0
        SET @limpio = SUBSTRING(@limpio, @pos, LEN(@limpio));
    ELSE
        SET @limpio = NULL;

    RETURN @limpio;
END;
GO


select TOP 100 * from Recaudacion.dbo.CONTACTO


SELECT objeto_contrato ,SUM(IMPORTE) AS PRINCIPAL , SUM(Importe_Actualizacion) AS ACTUALIZACION, SUM(IMPORTE_RECARGOS) AS RECARGOS
	FROM	Actualizaciones_Recargos_Vehicular
	GROUP BY objeto_contrato
SELECT SUM(SUMA) FROM (
SELECT --objeto_contrato, 
		SUM(Importe_Recargado_Actualizado) AS SUMA 
FROM Actualizaciones_Recargos_Vehicular as A
INNER JOIN PAGOS_REGISTRADOS_PARA_DEPURAR as P ON P.Obligacion=A.objeto_contrato
GROUP BY objeto_contrato) AS Z



250,221,751.420001
250,221,751.42

select count(distinct objeto_contrato)as num_vehiculos, sum(Importe_Recargado_Actualizado) 
From Actualizaciones_Recargos_Vehicular

--3,007,983,388.44162


--473,358


CREATE VIEW Actualizaciones_Recargos_Vehicular as
SELECT
    D.rfc,
    D.nombre,
    D.objeto_contrato,
    D.placa,
    Ejercicio_Adeudo = (2000 + CAST(SUBSTRING(TRIM(D.periodo),1,2) AS INT)),
    D.importe,
    Fecha_Emision = CAST('2025-09-22' AS date),

    -- INPC y actualización
    ROUND(I1.Inpc, 4) AS INPC_Mes_Ultimo,
    ROUND(I2.Inpc,4) AS INPC_Mes_Anterior,
    Factor_Actualizacion = ROUND(I1.Inpc / I2.Inpc, 4),
    Importe_Actualizacion = ROUND(D.importe * ((ROUND(I1.Inpc,4) / ROUND(I2.Inpc,4)) - 1), 4),
    Importe_Actualizado = ROUND(D.importe + (D.importe * ((ROUND(I1.Inpc,4) / ROUND(I2.Inpc,4)) - 1)), 2),

    -- Recargos
    ROUND(CA3.Tasa_Acumulada,4) AS Tasa_Acumulada,
    ROUND(CA4.Importe_Recargos,4) As Importe_Recargos,
    ROUND(CA4.Importe_Recargado_Actualizado,4) as Importe_Recargado_Actualizado

FROM Decreto_Vehicular AS D
LEFT JOIN inpc AS I1
    ON I1.Ejercicio = 2025 
   AND I1.Periodo = 8  -- Periodo_INPC (mes anterior a la emisión)
LEFT JOIN inpc AS I2
    ON I2.Ejercicio = (2000 + CAST(SUBSTRING(TRIM(D.periodo),1,2) AS INT))
   AND I2.Periodo = CASE WHEN (2000 + CAST(SUBSTRING(TRIM(D.periodo),1,2) AS INT)) = 2020 THEN 4 ELSE 3 END

-- Determinar fechas de inicio y fin para los recargos
CROSS APPLY
(
    SELECT
        fecha_inicio = DATEFROMPARTS(
            (2000 + CAST(SUBSTRING(TRIM(D.periodo),1,2) AS INT)),
            CASE WHEN (2000 + CAST(SUBSTRING(TRIM(D.periodo),1,2) AS INT)) = 2020 THEN 5 ELSE 4 END, 
            1
        ),
        fecha_limite = DATEADD(
            MONTH, 
            59, 
            DATEFROMPARTS(
                (2000 + CAST(SUBSTRING(TRIM(D.periodo),1,2) AS INT)),
                CASE WHEN (2000 + CAST(SUBSTRING(TRIM(D.periodo),1,2) AS INT)) = 2020 THEN 5 ELSE 4 END, 
                1
            )
        ),
        fecha_emision = CAST('2025-09-22' AS date)
) AS CA1
CROSS APPLY
(
    SELECT fecha_fin = CASE 
                           WHEN CA1.fecha_limite < CA1.fecha_emision THEN CA1.fecha_limite 
                           ELSE CA1.fecha_emision 
                       END
) AS CA2

-- Sumar tasas de recargo entre fecha_inicio y fecha_fin
CROSS APPLY
(
    SELECT
        Tasa_Acumulada = ISNULL((
            SELECT SUM(t.tasa_mensual)
            FROM tasas_recargos AS t
            WHERE DATEFROMPARTS(t.anio, t.mes, 1) 
                  BETWEEN CA1.fecha_inicio AND CA2.fecha_fin
        ), 0.0)
) AS CA3

-- Calcular importe de recargos y total actualizado
CROSS APPLY
(
    SELECT
        Importe_Recargos = ROUND(
            (ROUND(D.importe + (D.importe * ((I1.Inpc / I2.Inpc) - 1)), 2)) 
            * (CA3.Tasa_Acumulada / 100.0)
        , 2),
        Importe_Recargado_Actualizado = ROUND(
            (ROUND(D.importe + (D.importe * ((I1.Inpc / I2.Inpc) - 1)), 2))
            + ((ROUND(D.importe + (D.importe * ((I1.Inpc / I2.Inpc) - 1)), 2)) 
            * (CA3.Tasa_Acumulada / 100.0))
        , 2)
) AS CA4

ORDER BY D.rfc;




select * from inpc WHERE Ejercicio=2012

INSERT INTO inpc (Ejercicio, Periodo, Inpc, Fecha_Publicacion)
VALUES 
(2011, 1, 75.2959, '2011-02-10'),  -- Enero
(2011, 2, 75.5784, '2011-03-10'),  -- Febrero
(2011, 3, 75.7234, '2011-04-08'),  -- Marzo
(2011, 4, 75.7174, '2011-05-10'),  -- Abril
(2011, 5, 75.1592, '2011-06-10'),  -- Mayo
(2011, 6, 75.1555, '2011-07-08'),  -- Junio
(2011, 7, 75.5161, '2011-08-10'),  -- Julio
(2011, 8, 75.6355, '2011-09-09'),  -- Agosto
(2011, 9, 75.8211, '2011-10-10'),  -- Septiembre
(2011, 10, 76.3327, '2011-11-10'), -- Octubre
(2011, 11, 77.1583, '2011-12-09'), -- Noviembre
(2011, 12, 77.7923, '2012-01-10'); -- Diciembre



ALTER TABLE Decreto_Vehicular
ADD Objeto_contrato_int AS CAST(LTRIM(OBJETO_CONTRATO) AS BIGINT) PERSISTED;



SELECT TOP 100 * FROM PAGOS_REGISTRADOS_PARA_DEPURAR where rfc = 'EISG640610BG9'  ORDER BY Fecha desc

select * from pagos_temp where 

trim(Clave_Subclave) in('1012-0001','1012-1001','1012-2001')


select count(*) from pagos_temp
--741,351

SELECT * FROM Informacion_Estatal.dbo.RFC_PRUEBAS_SIAT

SELECT RFC, Clave_Subclave, Ejercicio, Periodo, Parter, Fecha, Importe, count(*) FROM PAGOS_REGISTRADOS_PARA_DEPURAR 
group by RFC, Clave_Subclave, Ejercicio, Periodo, Parter, Fecha, Importe
having count(*)>1


EXECUTE SELECCIONA_PAGOS 10, 'VRO240924BC7', '2026-01-15','PADRONES'


select * from vw_Comprobantes_Nomina where Emisor_RFC= 'ADE020422Q19';


select distinct descripcion_giro from ALC
--PRODUCTOR DE BEBIDAS ALCOHOLICAS ARTESANALES BAJO CONTENIDO

--EXP. DE BEB. DE BAJO CONT. ALCOHOLICO ENV.CERRADO

select top 100 * from ALC where licencia = 'A020200058'

select top 100* from REBAS where ESTATUS = ''

CREATE FUNCTION dbo.fn_Obtener_Municipio
(
    @clave VARCHAR(2)
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @nombre VARCHAR(100);

    SET @nombre = 
    CASE @clave
        WHEN '01' THEN 'Abasolo'
        WHEN '02' THEN 'Acámbaro'
        WHEN '03' THEN 'San Miguel de Allende'
        WHEN '04' THEN 'Apaseo el Alto'
        WHEN '05' THEN 'Apaseo el Grande'
        WHEN '06' THEN 'Atarjea'
        WHEN '07' THEN 'Celaya'
        WHEN '08' THEN 'Manuel Doblado'
        WHEN '09' THEN 'Comonfort'
        WHEN '10' THEN 'Coroneo'
        WHEN '11' THEN 'Cortazar'
        WHEN '12' THEN 'Cuerámaro'
        WHEN '13' THEN 'Doctor Mora'
        WHEN '14' THEN 'Dolores Hidalgo Cuna de la Independencia Nacional'
        WHEN '15' THEN 'Guanajuato'
        WHEN '16' THEN 'Huanímaro'
        WHEN '17' THEN 'Irapuato'
        WHEN '18' THEN 'Jaral del Progreso'
        WHEN '19' THEN 'Jerécuaro'
        WHEN '20' THEN 'León'
        WHEN '21' THEN 'Moroleón'
        WHEN '22' THEN 'Ocampo'
        WHEN '23' THEN 'Pénjamo'
        WHEN '24' THEN 'Pueblo Nuevo'
        WHEN '25' THEN 'Purísima del Rincón'
        WHEN '26' THEN 'Romita'
        WHEN '27' THEN 'Salamanca'
        WHEN '28' THEN 'Salvatierra'
        WHEN '29' THEN 'San Diego de la Unión'
        WHEN '30' THEN 'San Felipe'
        WHEN '31' THEN 'San Francisco del Rincón'
        WHEN '32' THEN 'San José Iturbide'
        WHEN '33' THEN 'San Luis de la Paz'
        WHEN '34' THEN 'Santa Catarina'
        WHEN '35' THEN 'Santa Cruz de Juventino Rosas'
        WHEN '36' THEN 'Santiago Maravatío'
        WHEN '37' THEN 'Silao de la Victoria'
        WHEN '38' THEN 'Tarandacuao'
        WHEN '39' THEN 'Tarimoro'
        WHEN '40' THEN 'Tierra Blanca'
        WHEN '41' THEN 'Uriangato'
        WHEN '42' THEN 'Valle de Santiago'
        WHEN '43' THEN 'Victoria'
        WHEN '44' THEN 'Villagrán'
        WHEN '45' THEN 'Xichú'
        WHEN '46' THEN 'Yuriria'
        ELSE NULL
    END;

    RETURN @nombre;
END;
GO

select P.RFC, P.Parter, P.Obligacion, P.Ejercicio, P.Periodo, P.Fecha, P.Importe, P.Clave_Subclave, R.PSOBKEY,R.MUNICIPIO, R.CVE_TIPO, R.ESTATUS
from PAGOS_REGISTRADOS_PARA_DEPURAR AS P
LEFT JOIN 
	(SELECT CAST(PSOBKEY AS INTEGER)AS PSOBKEY, 
			CVE_TIPO,	
			ESTATUS,	
			dbo.fn_Obtener_Municipio(CVE_MUNICIPIO) AS MUNICIPIO 
	FROM REBAS
	GROUP BY
		CAST(PSOBKEY AS INTEGER), 
			CVE_TIPO,	
			ESTATUS,	
			dbo.fn_Obtener_Municipio(CVE_MUNICIPIO)) AS R ON R.PSOBKEY = P.Obligacion
WHERE 
Fecha BETWEEN '20250101' AND '20251231'
AND Clave_Subclave IN ('4006-0001',	'4006-0002',	'4006-0003',	'4006-0004',	'4006-0005',	'4006-0006',	'4006-0007',	'4006-0008',	'4006-0009',	'4006-0010',	'4006-0011',	'4006-0012',	'4006-0013',	'4006-0014',	'4006-0015',	'4006-0016',	'4006-0017',	'4006-0018',	'4006-0019',	'4006-0020',	'4006-0021',	'4006-0022',	'4006-0023',	'4006-0024','4005-0001',	'4005-0002',	'4005-0003')


SELECT COUNT(*) FROM PAGOS_REGISTRADOS_PARA_DEPURAR 
WHERE
Fecha BETWEEN '20250101' AND '20251231'
AND Clave_Subclave IN ('4006-0001',	'4006-0002',	'4006-0003',	'4006-0004',	'4006-0005',	'4006-0006',	'4006-0007',	'4006-0008',	'4006-0009',	'4006-0010',	'4006-0011',	'4006-0012',	'4006-0013',	'4006-0014',	'4006-0015',	'4006-0016',	'4006-0017',	'4006-0018',	'4006-0019',	'4006-0020',	'4006-0021',	'4006-0022',	'4006-0023',	'4006-0024','4005-0001',	'4005-0002',	'4005-0003')
--5,359

Select * FROM PAGOS_REGISTRADOS_PARA_DEPURAR where rfc='ACL8101166G3' and Fecha>= '20260303'

00000000000121586624
descripcion_giro
--EXP.BEBIDAS ALCOHOLICAS AL COPEO C/ALIMENTOS
--PRODUCTOR DE BEBIDAS ALCOHOLICAS ARTESANALES BAJO CONTENIDO
--DISCOTECA CON VENTA DE BEBIDAS ALCOHOLICAS
--BAR
--CENTRO DE APUESTAS
--EXP.DE BEB.DE BAJO CONT.ALCOHO.ENV.ABIERTO C/ALIM
--VINICOLA
--SERVI-BAR
--PRODUCTOR DE BEBIDAS ALCOHOLICAS
--EXPENDIO DE ALCOHOL POTABLE EN ENVASE CERRADO
--EXP.BEB.BAJO CONTEN.ALCOHO.ENVASE ABIERTO
--TIENDA DE AUTOSERV.,ABARROTES,TENDAJONES O SIMILAR
--ALMACEN O DISTRIBUIDORA
--RESTAURANT-BAR
--CENTRO NOCTURNO
--PRODUCTOR DE BEBIDAS ALCOHOLICAS ARTESANALES ALTO CONTENIDO
--PEÑA
--SALON DE FIESTAS CON VENTA DE BEBIDAS ALCOHOLICAS
--CANTINA
--DEPOSITO
--EXP. DE BEB. DE BAJO CONT. ALCOHOLICO ENV.CERRADO

-- Tabla derivada de años (puedes cambiarla por una tabla física si quieres)
-- Paso 1: CTE con Descripcion y Tipo_Licencia

ALTER VIEW View_Alcoholes_Giros AS
WITH Años AS (
    SELECT 2013 AS Año UNION ALL
    SELECT 2014 UNION ALL
    SELECT 2015 UNION ALL
    SELECT 2016 UNION ALL
    SELECT 2017 UNION ALL
    SELECT 2018 UNION ALL
    SELECT 2019 UNION ALL
    SELECT 2020
),
LicenciasClasificadas AS (
    SELECT
        REBA AS Reba,
		LICENCIA as Licencia,
        TRIM(CVE_GIRO) AS descripcion_giro,
        CASE 
            WHEN TRIM(CVE_GIRO) IN (
                '30', 
                '03',
                '06',
                '01',
                '27'
            ) THEN 'Las licencias para la venta de bebidas de bajo contenido alcohólico'
            WHEN TRIM(CVE_GIRO) IN (
                '29',
                '07',
                '08',
                '09',
                '10',
                '11',
                '13',
                '12',
                '02',
                '04',
                '14',
                '15',
                '23',
                '05'
            ) THEN 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros'
            WHEN TRIM(CVE_GIRO) = '16' THEN 'Las licencias para la venta de bebidas alcohólicas en centro nocturno'
            WHEN TRIM(CVE_GIRO) = '28' THEN 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas'
            ELSE TRIM(CVE_GIRO) 
        END AS Descripcion,
        CASE 
            WHEN TRIM(CVE_GIRO) IN (
                '30', 
                '03',
                '06'
            ) THEN 'B1'
            WHEN TRIM(CVE_GIRO) IN (
                '01',
                '27'
            ) THEN 'B2'
            WHEN TRIM(CVE_GIRO) IN (
                '29',
                '07',
                '08',
                '09',
                '10',
                '11',
                '13',
                '12'
            ) THEN 'A1'
            WHEN TRIM(CVE_GIRO) IN (
                '02',
                '04',
                '14',
                '15',
                '23',
                '05'
            ) THEN 'A2'
            WHEN TRIM(CVE_GIRO) IN ('16', '28') THEN 'A1'
            ELSE ''
        END AS Tipo_Licencia
    FROM REBAS
)

-- Unir con Años y calcular Tarifa
SELECT
	lc.Reba,   
   lc.Licencia,
	CASE 
    -- 2020
    WHEN a.Año = 2020 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN 'Artículo quinto transitorio, tercer párrafo, fracción I de la Ley de Ingresos para el Estado de Guanajuato de 2020'
    WHEN a.Año = 2020 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN 'Artículo quinto transitorio, tercer párrafo, fracción II de la Ley de Ingresos para el Estado de Guanajuato de 2020'
    WHEN a.Año = 2020 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN 'Artículo quinto transitorio, tercer párrafo, fracción III de la Ley de Ingresos para el Estado de Guanajuato de 2020'
    WHEN a.Año = 2020 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN 'Artículo quinto transitorio, tercer párrafo, fracción IV de la Ley de Ingresos para el Estado de Guanajuato de 2020'

    -- 2019
    WHEN a.Año = 2019 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN 'Artículo 30, fracción I, de la Ley de Ingresos para el Estado de Guanajuato de 2019'
    WHEN a.Año = 2019 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN 'Artículo 30, fracción II, de la Ley de Ingresos para el Estado de Guanajuato de 2019'
    WHEN a.Año = 2019 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN 'Artículo 30, fracción III, de la Ley de Ingresos para el Estado de Guanajuato de 2019'
    WHEN a.Año = 2019 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN 'Artículo 30, fracción IV, de la Ley de Ingresos para el Estado de Guanajuato de 2019'

    -- 2018
    WHEN a.Año = 2018 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN 'Artículo 30, fracción I, de la Ley de Ingresos para el Estado de Guanajuato de 2018'
    WHEN a.Año = 2018 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN 'Artículo 30, fracción II, de la Ley de Ingresos para el Estado de Guanajuato de 2018'
    WHEN a.Año = 2018 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN 'Artículo 30, fracción III, de la Ley de Ingresos para el Estado de Guanajuato de 2018'
    WHEN a.Año = 2018 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN 'Artículo 30, fracción III, de la Ley de Ingresos para el Estado de Guanajuato de 2018'

    -- 2017
    WHEN a.Año = 2017 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN 'Artículo 27, fracción I, de la Ley de Ingresos de 2017'
    WHEN a.Año = 2017 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN 'Artículo 27, fracción II, de la Ley de Ingresos de 2017'
    WHEN a.Año = 2017 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN 'Artículo 27, fracción III, de la Ley de Ingresos de 2017'
    WHEN a.Año = 2017 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN 'Artículo 27, fracción IV, de la Ley de Ingresos de 2017'

    -- 2016
    WHEN a.Año = 2016 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN 'Artículo 28, fracción I, de la Ley de Ingresos de 2016'
    WHEN a.Año = 2016 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN 'Artículo 28, fracción II, de la Ley de Ingresos de 2016'
    WHEN a.Año = 2016 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN 'Artículo 28, fracción III, de la Ley de Ingresos de 2016'
    WHEN a.Año = 2016 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN 'Artículo 28, fracción IV, de la Ley de Ingresos de 2016'

	--2015
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN 'Artículo 22, fracción I, de la Ley de Ingresos de 2015'
    WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN 'Artículo 22, fracción II, de la Ley de Ingresos de 2015'
    WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN 'Artículo 22, fracción II, de la Ley de Ingresos de 2015'
    WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN 'Artículo 22, fracción III, de la Ley de Ingresos de 2015'

	-- 2014
    WHEN a.Año = 2014 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN 'Artículo 21, fracción I, de la Ley de Ingresos de 2014'
    WHEN a.Año = 2014 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN 'Artículo 21, fracción II, de la Ley de Ingresos de 2014'
    WHEN a.Año = 2014 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN 'Artículo 21, fracción III, de la Ley de Ingresos de 2014'

    -- 2013
    WHEN a.Año = 2013 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN 'Artículo 23, fracción I, de la Ley de Ingresos de 2013'
    WHEN a.Año = 2013 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN 'Artículo 23, fracción II, de la Ley de Ingresos de 2013'
    WHEN a.Año = 2013 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN 'Artículo 23, fracción III, de la Ley de Ingresos de 2013'
    ELSE 'Sin fundamento legal'
END AS Fundamento_Ley,
	'Artículo 29, fracción II, de la Ley de Alcoholes para el Estado de Guanajuato' AS Fundamento_Multa,
	lc.descripcion_giro,
    lc.Descripcion,
    lc.Tipo_Licencia,
	20 as Unidades,
    a.Año as Anio,
    CASE 
    -- 2020
    WHEN a.Año = 2020 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN '622.00'
    WHEN a.Año = 2020 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN '5645.00'
    WHEN a.Año = 2020 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN '13321.00'
    WHEN a.Año = 2020 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN '59352.00'

    -- 2019
    WHEN a.Año = 2019 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN '601.00'
    WHEN a.Año = 2019 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN '5454.00'
    WHEN a.Año = 2019 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN '12871.00'
    WHEN a.Año = 2019 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN '57245.00'

    -- 2018
    WHEN a.Año = 2018 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN '546.00'
    WHEN a.Año = 2018 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN '4958.00'
    WHEN a.Año = 2018 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN '11701.00'
    WHEN a.Año = 2018 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN '52132.00'

    -- 2017
    WHEN a.Año = 2017 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN '520.00'
    WHEN a.Año = 2017 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN '4722.00'
    WHEN a.Año = 2017 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN '11144.00'
    WHEN a.Año = 2017 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN '49650.00'

    -- 2016
    WHEN a.Año = 2016 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN '505.00'
    WHEN a.Año = 2016 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN '4584.00'
    WHEN a.Año = 2016 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN '10819.00'
    WHEN a.Año = 2016 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN '48204.00'

	--2015
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN '490.00'
    WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'EXP.BEBIDAS ALCOHOLICAS AL COPEO C/ALIMENTOS' THEN '93909.00'
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'PEÑA' THEN '102953.00'
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'SALON DE FIESTAS CON VENTA DE BEBIDAS ALCOHOLICAS' THEN '108523.00'
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'CANTINA' THEN '113046.00'
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'BAR' THEN '113046.00'
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'RESTAURANT-BAR' THEN '125805.00'
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'DISCOTECA CON VENTA DE BEBIDAS ALCOHOLICAS' THEN '134662.00'
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'SERVI-BAR' THEN '38140.00'
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'EXPENDIO DE ALCOHOL POTABLE EN ENVASE CERRADO' THEN '46425.00'
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'TIENDA DE AUTOSERV.,ABARROTES,TENDAJONES O SIMILAR' THEN '63613.00'
    WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'VINICOLA' THEN '139093.00'
    WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'PRODUCTOR DE BEBIDAS ALCOHOLICAS' THEN '149722.00'  
	WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' AND TRIM(lc.descripcion_giro) = 'ALMACEN O DISTRIBUIDORA' THEN '157164.00'                                
    WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN '269322.00'
    WHEN a.Año = 2015 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro de apuestas' THEN '46800.00'

	-- 2014
    WHEN a.Año = 2014 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN '471.00'
    WHEN a.Año = 2014 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN '3667.00'
    WHEN a.Año = 2014 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN '8737.00'

    -- 2013
    WHEN a.Año = 2013 AND lc.Descripcion = 'Las licencias para la venta de bebidas de bajo contenido alcohólico' THEN '453.00'
    WHEN a.Año = 2013 AND lc.Descripcion = 'Las licencias para la venta de bebidas de alto contenido alcohólico en sus distintos giros' THEN '3526.00'
    WHEN a.Año = 2013 AND lc.Descripcion = 'Las licencias para la venta de bebidas alcohólicas en centro nocturno' THEN '8401.00'
    ELSE '0.00'
END AS Tarifa
FROM LicenciasClasificadas lc
CROSS JOIN Años a



select top 100 * from REBAS WHERE FE_EXPEDICION <> '00000000' AND ESTATUS=1 order by FE_EXPEDICION 

Select descripcion_giro, Descripcion 
from View_Alcoholes_Giros 
GROUP BY descripcion_giro, Descripcion 

Select top 10* from View_Alcoholes_Giros where PSOBKEY

select * from REBAS WHERE REBA like '%120150569%'

select * from ALC WHERE RFC LIKE '%56701_ROSM600916AW5%'

select top 10 * from ALC  WHERE 
    CASE 
        WHEN licencia LIKE '[A-Z]%' THEN 
            LEFT(licencia, 1) + 
            RIGHT(licencia, LEN(licencia) - 1 - PATINDEX('%[^0]%', SUBSTRING(licencia, 2, LEN(licencia) - 1)) + 1)
        ELSE 
            RIGHT(licencia, LEN(licencia) - PATINDEX('%[^0]%', Licencia) + 1)
    END = '121404260';  -- O '' si no tiene letra

insert into ALC (RFC,	lic_rea,	licencia,	rea,	nombre_razon,	descripcion_giro,	calle,	colonia,	cp,	poblacion,	estatus,	tipo_persona,	fecha_alta) VALUES ('','','','','','','','', ,'','','','');

select * from incp

select RFC, COUNT(*) from ALC
GROUP BY RFC
HAVING COUNT(*)>1

CREATE TABLE ALC_TEMP (
    RFC VARCHAR(50),
    lic_rea VARCHAR(50),
    licencia VARCHAR(50),
    rea VARCHAR(50),
    nombre_razon VARCHAR(max),
    descripcion_giro VARCHAR(max),
    calle VARCHAR(max),
    colonia VARCHAR(max),
    cp INT,
    poblacion VARCHAR(max),
    estatus CHAR(1),
    tipo_persona CHAR(30),
    fecha_alta DATE
);




-- --------------------------------------------------------------------------------------
--									OBLIGACIONES Y CLAVES
-- --------------------------------------------------------------------------------------

select top 100 *from obligaciones_Claves

select Clave, Obligacion from claves_obligaciones
group by Clave, Obligacion

SELECT TOP 10 SUBSTRING(Clave_Subclave,1,4) FROM PAGOS_REGISTRADOS_PARA_DEPURAR

execute [SELECT_PAGOS_PROG] 12,'CARJ880225DE4', '2025-08-07' 

select * from claves_obligaciones where Obligacion like '%IMPUESTO SOBRE NÓMINA%'

select P.*, R.OC from PAGOS_REGISTRADOS_PARA_DEPURAR AS P
inner join (SELECT CAST(PSOBKEY AS bigint)AS OC FROM REBAS GROUP BY PSOBKEY)AS R ON P.Obligacion = R.OC
WHERE P.Fecha BETWEEN '20250101' AND '20251231'

--39,408
select PSOBKEY, COUNT(*) from REBAS
GROUP BY PSOBKEY
HAVING COUNT(*)>1


SELECT * FROM REBAS WHERE PSOBKEY= '00000000000500014766'
--54,103
--54,065

WHERE RFC = 'CARJ880225DE4' ORDER BY Fecha Desc


select * from MOVIMIENTOS_OBLIGACIONES order by rec

SELECT * FROM rec_movimientos

select * from Informacion_Estatal.dbo.TIPO_CONTRIBUYENTE where rfc like '%CAA070301N24%' ORDER BY RFC

SELECT top 100 * FROM Actividades_Economicas_Activas

select TOP 100 * from PADRON_TEMP_

select top 100 * from [dbo].[cat_actividad]
-- --------------------------------------------------------------------------------------
--										CFDI
-- --------------------------------------------------------------------------------------
Select top 100 A.*, b.tipo from [dbo].[cfdi] as a
left join cfdi_tipos as b on a.tipo_id=b.id

select top 100 * from cfdi where id=206

Select top 100 * from [dbo].[cfdi_detalle]

Select top 100 * from [dbo].[cfdi_nodos]

Select top 100 * from [Informacion_Estatal].dbo.[cfdi_tipos]

select * from Recaudacion.dbo.XML_CFDI

drop table XML_CFDI

CREATE TABLE xml_cfdi (
    id INT IDENTITY(1,1) PRIMARY KEY,
    uuid_relacionado NVARCHAR(50),
    folio NVARCHAR(50),
    version NVARCHAR(10),
    fecha DATETIME,
    forma_pago NVARCHAR(50),
    no_certificado NVARCHAR(50),
    subtotal DECIMAL(18,2),
    descuento DECIMAL(18,2),
    moneda NVARCHAR(10),
    total DECIMAL(18,2),
    tipo_comprobante NVARCHAR(10),
    lugar_expedicion NVARCHAR(50),
    metodo_pago NVARCHAR(50),
    rfc_emisor NVARCHAR(50),
    nombre_emisor NVARCHAR(255),
    regimen_fiscal NVARCHAR(50),
    rfc_receptor NVARCHAR(50),
    nombre_receptor NVARCHAR(255),
    uso_cfdi NVARCHAR(50),
    uuid_timbre NVARCHAR(50),
    fecha_timbrado DATETIME,
    rfc_prov_certif NVARCHAR(50),
    no_certificado_sat NVARCHAR(50)
);

CREATE TABLE xml_conceptos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    xml_id INT FOREIGN KEY REFERENCES XML_CFDI(id),
    clave_prod_serv NVARCHAR(50),
    cantidad DECIMAL(18,2),
    clave_unidad NVARCHAR(50),
    unidad NVARCHAR(50),
    descripcion NVARCHAR(255),
    valor_unitario DECIMAL(18,2),
    importe DECIMAL(18,2),
    descuento DECIMAL(18,2) NULL
);

CREATE TABLE xml_complementos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    xml_id INT FOREIGN KEY REFERENCES XML_CFDI(id),
    tipo_complemento NVARCHAR(100),
    datos_complemento NVARCHAR(MAX) -- Almacena datos en JSON
);


select * from xml_cfdi

select * from xml_conceptos

select * from xml_complemento


SELECT COUNT(*) FROM Recaudacion.[dbo].[registroc_Civil_Nacimientos]

select * from Civil

CREATE TABLE Contactos (
    Interlocutor VARCHAR(20),
    Rec Varchar(20),
    Id varchar (20),
    Telefono VARCHAR(30),
    Correo VARCHAR(150),
    Origen VARCHAR(100),
    Fecha_Alta DATE
);

select top 100 * from Informacion_Federal.dbo.PERSONAS_FISICAS_2 where rfc = 'JAGR991112TD4'

select top 100 * from Informacion_Estatal.DBO.REC_DETALLE where rfc in ('JAGR991112TD4', 'GURA991112TD4')

select * from Informacion_Estatal.dbo.Contactos

select COUNT(*) from Recaudacion.dbo.CONTACTO

SELECT top 100* FROM Informacion_Estatal.dbo.PADRON_TEMP_ where trim(RFC) ='RAGE9701017M0'

select TOP 100 * from Informacion_Estatal.dbo.REC_DETALLE WHERE RFC= 'RAGE9701017M0'

Select top 100 * from Recaudacion.dbo.Personas_ where RFC IN ('RAGE9701017M0','RASJ941221I9A','SASJ850524V57','GACU9707251W8','GUMJ9104091E7','MOMM820905FF2','GURA991112TD4','ROTL9909099T6','JAGR991112TD4','PILA980509BD0','VEHJ790517DK5')
ORDER BY RFC

SELECT 
	A.rec,
	CASE
		WHEN LEN(TRIM(A.rec)) = 13 THEN trim(CONCAT(B.nombre_, ' ' , B.ape_paterno, ' ', B.ape_materno))
		ELSE ''
	END AS nombre,
	CASE
		WHEN LEN(TRIM(A.rec)) = 12 THEN Trim(B.nombre)
		ELSE ''
	END AS razon_social,
	CASE
		WHEN LEN(TRIM(A.rec)) = 13 THEN 'FISICA'
		WHEN LEN(TRIM(A.rec)) = 12 THEN 'MORAL'
		ELSE ''
	END AS tipo_persona,
	CASE
		WHEN LEN(TRIM(A.rec)) = 13 THEN ISNULL(B.curp, '')
		ELSE ''
	END AS curp,
	CASE 
		WHEN B.correo IN ('', NULL) THEN D.correo_electronico 
		ELSE B.correo
		END AS correo_electronico,
	ISNULL(C.contacto, '') AS telefono,
	A.fe_ini_op as fecha_inicio_operaciones,
	CASE 
		WHEN TRIM(A.obligacion) = 'Impuesto por Emisión de Gases Contaminantes' THEN 'IEGC' 
		WHEN TRIM(A.obligacion) = 'Impuesto por Deposito de residuos' THEN 'IDR' 
		ELSE ''
	END AS obligacion,
	a.fe_alta as fecha_alta,
	A.fe_baja AS fecha_baja,
	CASE 
		WHEN A.estatus = 'Activo' THEN CAST(1 AS BIT)
		WHEN A.estatus = 'Suspendido' THEN CAST(0 AS BIT)
		ELSE NULL
	END AS obligacion_activa,
	CASE 
		WHEN A.estatus = 'Suspendido' THEN A.estatus
		ELSE NULL
	END AS motivo_baja
FROM (
SELECT rec, obligacion, fe_ini_op, estatus, fe_baja, fe_alta FROM Recaudacion.dbo.REC_OBLIGACIONES AS ro
where ro.obligacion in ('Impuesto por Emisión de Gases Contaminantes', 'Impuesto por Deposito de residuos')
	and ro.rec not in (Select RFC from Informacion_Estatal.dbo.RFC_PRUEBAS_SIAT)
group by rec, obligacion, fe_ini_op, estatus, fe_baja, fe_alta) AS A
LEFT JOIN Informacion_Estatal.dbo.REC_DETALLE as B ON trim(B.RFC) = trim(A.rec)
LEFT JOIN (SELECT rec, MAX(contacto) AS contacto FROM Recaudacion.dbo.CONTACTO WHERE origen = 'SAP-Dirección Fiscal' group by rec ) AS C ON TRIM(C.rec) = TRIM(A.rec)
LEFT JOIN (SELECT RFC, MAX(correo_electronico)AS correo_electronico FROM Informacion_Federal.dbo.CORREOS GROUP BY RFC) AS D ON D.RFC = A.rec order by A.rec


SELECT top 100 * FROM Informacion_Federal.dbo.CORREOS

SELECT top 100 * FROM Recaudacion.dbo.CONTACTO ORDER BY rec

select top 100 * FROM Recaudacion.dbo.REC_OBLIGACIONES

select * from Informacion_Estatal.dbo.RFC_PRUEBAS_SIAT

select top 100 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.sucursales

select * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes where activo=1


Impuesto por Emisión de Gases Contaminantes
Impuesto por Deposito de residuos


----------------------------------------------------------------------------------------
--                                     DECLARACIONES
----------------------------------------------------------------------------------------

Select * from detalle_ingresos

delete [DETALLE_INGRESOS_PF]

ALTER TABLE [DETALLE_INGRESOS_PF]
ALTER COLUMN ptu_pagada decimal (12,2);

EXEC sp_rename 'DeclaracionAnual', 'declaraciones';

SELECT TOP 1000 * FROM Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR WHERE rfc= 'NME980506LPA' order by Fecha desc


EXEC sp_who2;

kill 84

97   
99   


select * from Informacion
SELECT * FROM Informacion_Federal.dbo.Personas_Fisicas_2 AS A WHERE rfc_vig LIKE '%DISH980420C94%'

--2000-01-07

select 3625995*2

SELECT TOP 100
    A.C_IDC_RFCEEOG1 AS RFC,                     -- VARCHAR(13)
    LEN(A.C_IDC_RFCEEOG1) AS LEN_RFC,

    A.D_IDC_CURPLNE1 AS CURP,                    -- VARCHAR(18)
    LEN(A.D_IDC_CURPLNE1) AS LEN_CURP,

    A.C_IDC_CTPLIEA1 AS TIPO_PERSONA,            -- CHAR(1)
    LEN(A.C_IDC_CTPLIEA1) AS LEN_TIPO,

    CASE 
        WHEN A.C_IDC_CTPLIEA1 = 'F' THEN A.D_IDC_NOMBRE01 + ' ' + A.D_IDC_APPAETL1 + ' ' + A.D_IDC_AMPAETL1 
        WHEN A.C_IDC_CTPLIEA1 = 'M' THEN A.D_IDC_DRSEAON1
        ELSE A.D_IDC_NCOOMMB1 
    END AS NOMBRE_COMPLETO,                      -- VARCHAR(255)
    LEN(
        CASE 
            WHEN A.C_IDC_CTPLIEA1 = 'F' THEN A.D_IDC_NOMBRE01 + ' ' + A.D_IDC_APPAETL1 + ' ' + A.D_IDC_AMPAETL1 
            WHEN A.C_IDC_CTPLIEA1 = 'M' THEN A.D_IDC_DRSEAON1
            ELSE A.D_IDC_NCOOMMB1 
        END
    ) AS LEN_NOMBRE_COMPLETO,

    CASE 
        WHEN A.C_IDC_CTPLIEA1 = 'M' THEN A.D_IDC_DRSEAON1 
        ELSE '' 
    END AS RAZON_SOCIAL,                         -- VARCHAR(255)
    LEN(
        CASE 
            WHEN A.C_IDC_CTPLIEA1 = 'M' THEN A.D_IDC_DRSEAON1 
            ELSE '' 
        END
    ) AS LEN_RAZON_SOCIAL,
    CASE 
            WHEN A.C_IDC_CTPLIEA1 = 'F' THEN A.D_IDC_NOMBRE01
            WHEN A.C_IDC_CTPLIEA1 = 'M' THEN ''
            ELSE ''
        END AS NOMBRE,
		  LEN(CASE 
            WHEN A.C_IDC_CTPLIEA1 = 'F' THEN A.D_IDC_NOMBRE01
            WHEN A.C_IDC_CTPLIEA1 = 'M' THEN ''
            ELSE ''
        END) AS LEN_NOMBRE,
		CASE 
            WHEN A.C_IDC_CTPLIEA1 = 'F' THEN A.D_IDC_APPAETL1
            WHEN A.C_IDC_CTPLIEA1 = 'M' THEN ''
            ELSE ''
        END AS APE_PATERNO,
		LEN(CASE 
            WHEN A.C_IDC_CTPLIEA1 = 'F' THEN A.D_IDC_APPAETL1
            WHEN A.C_IDC_CTPLIEA1 = 'M' THEN ''
            ELSE ''
        END) AS LEN_APE_PATERNO,
		CASE 
            WHEN A.C_IDC_CTPLIEA1 = 'F' THEN A.D_IDC_AMPAETL1
            WHEN A.C_IDC_CTPLIEA1 = 'M' THEN ''
            ELSE ''
        END AS APE_MATERNO,
		LEN(CASE 
            WHEN A.C_IDC_CTPLIEA1 = 'F' THEN A.D_IDC_AMPAETL1
            WHEN A.C_IDC_CTPLIEA1 = 'M' THEN ''
            ELSE ''
        END) AS LEN_APE_MATERNO
FROM (
    SELECT *, 
           ROW_NUMBER() OVER (
               PARTITION BY C_IDC_RFCEEOG1
               ORDER BY C_IDC_RFCEEOG1
           ) AS rn
    FROM Informacion_Federal.dbo.[PERSONAS_FISICAS_1]
) A
WHERE A.rn = 1
  AND (
      LEN(A.C_IDC_RFCEEOG1) > 13 OR
      LEN(A.D_IDC_CURPLNE1) > 18 OR
      LEN(A.C_IDC_CTPLIEA1) > 1 OR
      LEN(A.D_IDC_NOMBRE01 + ' ' + A.D_IDC_APPAETL1 + ' ' + A.D_IDC_AMPAETL1) > 255 OR
      LEN(A.D_IDC_DRSEAON1) > 255 OR
      LEN(TRIM(A.D_IDC_NOMBRE01)) > 255 OR
      LEN(TRIM(A.D_IDC_APPAETL1)) > 60 OR
      LEN(TRIM(A.D_IDC_AMPAETL1)) > 60
  );



exec [dbo].[UsersRoles]

select * from [dbo].[actualizacion_tablas]

SELECT TOP 10 * FROM Informacion_Federal.dbo.Personas_Fisicas_2 WHERE rfc_vig= 'WUXI791017R46'

select *  FROM Informacion_Federal.[dbo].[PF_Respaldo] where rfc_vig = 'WUXI791017R46'

Select * from Informacion_Estatal.dbo.REC_DETALLE WHERE RFC= 'WUXI791017R46'

select top 100 *from [dbo].[Personas_] WHERE FECHA_NAC > '20260101' and TIPO_PERSONA = 'M'

select top 2000 * from [dbo].[Personas_] order by NOMBRE_COMPLETO

select * from [dbo].[Personas_] WHERE NOMBRE_COMPLETO LIKE '%LETICIA ARREOLA JAIME%'


select * from REC where rec='WUXI791017R46'

select top 100 * from [dbo].[/BIC/OHZDRS2]

UPDATE Personas_
SET NOMBRE_COMPLETO = LTRIM(RTRIM(
        TRANSLATE(NOMBRE_COMPLETO, '"#', '  ')
    )) WHERE RFC IN ('A&AAA1101175J4', 'AAAA7809184S0');


--6,139,223


SELECT TOP 10 *
FROM Personas_
WHERE NOMBRE_COMPLETO = 
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    NOMBRE_COMPLETO, '"', ''), '''', ''), ',', ''), '+', ''), '-', ''), '#', '');

SELECT count(*)
FROM Personas_
WHERE NOMBRE_COMPLETO <> TRANSLATE(NOMBRE_COMPLETO, '"#', '  ');
--74,689

SELECT TOP 200 *
FROM Personas_
WHERE NOMBRE_COMPLETO <> TRANSLATE(NOMBRE_COMPLETO, '"#', '  ') AND RFC IN ('AAAA1101175J4', 'AAAA7809184S0')



SELECT TOP 5000* FROM Personas_ WHERE NOMBRE_COMPLETO LIKE '%--%' AND LEN(NOMBRE_COMPLETO) < 100
--6,786,917

--89,527


111,807
3,973,861
3,973,860

select COUNT(*) from [dbo].[Personas_] 
---3,973,860
---4,082,868
---4,165,330
---4,185,748
-- 4,208,130
---4,208,170
---4,208,179
---4,210,988
---4,641,866
---6,128,912
---6,128,926



SELECT TOP 10 * FROM Recaudacion.dbo.LISTADO_CFDI

select * from Recaudacion.dbo.Personas_ where NOMBRE_COMPLETO like '%MARTHA VARGAZ MARTINEZ%'

select top 100 * from Comprobantes where Emisor_RFC LIKE '%BCI111018E57'

select top 100 * from Comprobantes WHERE TipoDeComprobante = 'P' and cast(Fecha as date) = '2022-06-02' 

select cast(Fecha as date) from vw_Comprobantes_Nomina  where Emisor_RFC LIKE '%BCI111018E57'

select top 100 * from [dbo].[vw_Comprobantes_Completa]

select top 100000 d_codigo as cp,
		D_mnpio AS municipio,
		d_estado as estado,
		c_estado as clave_estado,
		c_mnpio as clave_municipio
		from Informacion_Federal.dbo.Sepomex_CP 

SELECT top 10 *  FROM Informacion_Federal.dbo.Regimenes_Fiscales AS A INNER JOIN Informacion_Federal.dbo.cat_regimen AS B ON A.cv_regimen  = B.cv_regimen   WHERE RFC IN (SELECT RFC FROM Informacion_Federal.dbo.INFORMACION_BASICA)

select TOP 100* from PADRON_TEMP

---PADRON REBAS
select PARTNER AS INTERLOCUTOR, 
		RFC,
		CONCAT(NOMBRE,' ', AP_PATERNO, ' ', AP_PATERNO) AS CONTRIBUYENTE,
		RAZON_SOCIAL,
		REBA, 
		LICENCIA,
		CAST(PSOBKEY AS INT) AS OBJETO_CONTRATO,
		FE_EXPEDICION AS FECHA_EXPEDICION,
		CVE_TIPO AS TIPO,
		ESTATUS,
		ISNULL(ADEUDO,0) AS ADEUDO,
		ISNULL(MAX_ADEUDO,0) AS MAX_ADEUDO,
		CVE_GIRO AS GIRO,
		UPPER(G.Descripcion) AS DESCRIPCION_GIRO
from Informacion_Estatal.dbo.REBAS AS R
LEFT JOIN (SELECT descripcion_giro, Descripcion 
			FROM Informacion_Estatal.dbo.View_Alcoholes_Giros
			group by descripcion_giro, Descripcion) AS G ON G.descripcion_giro = R.CVE_GIRO

SELECT descripcion_giro, Descripcion 
FROM [dbo].[View_Alcoholes_Giros]
group by descripcion_giro, Descripcion 
SELECT
    db_name(mf.database_id) AS database_name,
    mf.name AS logical_name,
    mf.type_desc,
    mf.physical_name,
    CAST(mf.size / 128.0 AS DECIMAL(18,2)) AS size_mb,
    CAST(
        CASE 
            WHEN mf.max_size = -1 THEN -1
            ELSE mf.max_size / 128.0
        END
    AS DECIMAL(18,2)) AS max_size_mb,
    mf.is_percent_growth,
    mf.growth
FROM sys.master_files mf
WHERE db_name(mf.database_id) = 'Recaudacion';




SELECT TOP 10 * FROM REBAS

select top 10 *
                          from Visitas as A
                          INNER JOIN  [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.visitas as B on A.Folio = b.Folio
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados AS X ON X.id_acreditado = B.id_acreditado     
                          INNER JOIN ETIQUETAS AS C ON  B.ID_ETIQUETA_VISITA = C.ID_ETIQUETA
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados_cuentas_domicilios AS J ON B.id_acreditado= J.id_acreditado AND J.id_acreditado_cuenta_domicilio= B.id_acreditado_cuenta_domicilio AND B.ID_CUENTA=J.ID_CUENTA
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.estados AS K ON J.id_estado= K.id_estado
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.municipios AS L ON L.id_municipio= J.id_municipio

SELECT  *
FROM OPENQUERY(PG_Recaudacion, 
'select hcp.codigo_postal, he.clave as clave_estado, he.nombre as estado, hm.clave as clave_municipio, hm.nombre as municipio from home_codigo_postal hcp
	inner join home_municipio hm on hcp.municipio_id = hm.id
	inner join home_estado he on hcp.estado_id = he.id') as z
RIGHT join Informacion_Federal.dbo.Sepomex_CP as sc on trim(d_codigo) = trim(z.codigo_postal)
WHERE Z.codigo_postal is null



SELECT distinct Emisor_RFC FROM Comprobantes

select top 100 * from Recaudacion.dbo.Personas_ where rfc = 'CIN100528662' 

select * from Informacion_Estatal.dbo.REC_DETALLE where Recaudacion.dbo.RemoverAcentos(concat(trim(calle),' ', trim(colonia), ' ', cp)) like '%JUAN JOSE TORRES LANDA ORIENTE%'

[dbo].[RemoverAcentos]
select DISTINCT sector from Informacion_Estatal.dbo.REC_DETALLE 

select * from Informacion_Estatal.dbo.REC_DETALLE WHERE RFC='CIN100528662'

select top 10 rfc, razon_social, calle, no_exterior, no_interior, entre_calle_1, entre_calle_2,b.nombre as colonia, a.cv_cp, c.d_estado as estado, c.D_mnpio as municipio
from Informacion_Federal.dbo.Personas_Fisicas_2 as a
left join Informacion_Federal.dbo.cat_colonia as b on a.cv_colonia= b.cv_colonia
left join Informacion_Estatal.dbo.CODIGOS_POSTALES as c on a.cv_cp= c.d_codigo
where a.rfc_vig like '%DISH980420C94%'



Select top 10 * from Informacion_Estatal.dbo.Personas_Vehicular

select TOP 100 * from Informacion_Estatal.dbo.REC_DETALLE where len(nombre_)=0

select * from Informacion_Estatal.dbo.REC_DETALLE where len(cp)>5 

--42,807,283
select COUNT(*) from Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR

select top 100 * from Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR order by Fecha desc

update P
set 
	P.cp = A.CP,
	P.localidad= A.LOCALIDAD
	--SELECT *
	from Informacion_Estatal.dbo.REC_DETALLE as P
	left join (SELECT RFC, MAX(CP) AS CP, MAX(LOCALIDAD) AS LOCALIDAD, MAX(OBLIGACION) AS OBLIGACION, MAX(COLONIA) AS COLONIA FROM Informacion_Estatal.dbo.PADRON_TEMP_ GROUP BY RFC) AS A on P.RFC = A.RFC
	where len(P.cp)>5

select top 2000 * from Informacion_Estatal.dbo.REC_DETALLE where actividad <> '' order by Fe_Alta_Obligacion desc


select top 1000* from Informacion_Estatal.dbo.REC_DETALLE as A
inner join Informacion_Estatal.dbo.TEMP_GENERALES_REC_29 as b on a.rfc = b.rfc

SELECT * FROM Informacion_Estatal.dbo.PADRON_TEMP_ WHERE rfc LIKE '%CIN100528662%'

select * from Informacion_Estatal.dbo.REBAS WHERE RFC LIKE '%CIN100528662%'

select  * from Recaudacion.[dbo].[DIRECCIONES]
--585,527

select  * from Recaudacion.[dbo].[DIRECCIONES_SATEG]

select top 10000 * from  Recaudacion.[dbo].Personas_
order by NOMBRE_COMPLETO

SELECT rfc, count(*) 
FROM Personas_Vehicular
group by rfc 
having count(*)>1

select * from dbo.PERSONAS_RC

SELECT 707544 -707562
--1,672

SELECT s.session_id, r.blocking_session_id, r.cpu_time, r.status, s.login_name, r.command, s.host_name, s.program_name,DB_NAME(r.database_id) AS database_name
    FROM sys.dm_exec_requests r 
    JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
    WHERE s.session_id not in (2,3,4,5,6,7,46) 
    AND (r.blocking_session_id <> 0 OR r.cpu_time > 5000) 
    AND s.host_name not in ('SATEGANALISISDA', 'SATEGREPO')

	SELECT * FROM Informacion_Estatal.dbo.INPC order by Ejercicio desc

	KILL 8




KILL 63;

KILL 81;
KILL 82;
KILL 91;
KILL 93;
KILL 94;
KILL 103;
KILL 104;
KILL 105;
KILL 107;
KILL 108;
KILL 109;
KILL 110;
KILL 115;


SELECT 4185748 - 4165330

select * from [dbo].[PERSONAS_RC]

select top 100 * from [dbo].[rfc]

select top 100 * from r

select top 100* from Declaraciones.dbo.declaraciones

SELECT TOP 100 * FROM Informacion_Federal.dbo.WORK_QUERY_FOR_VMM_IDC_DICADOT1_R  WHERE C_IDC_CTPLIEA1 ='M'

ALTER TABLE declaraciones
--ALTER COLUMN [razon_social] [varchar](1000) NULL
ALTER COLUMN [numero_operacion] [varchar](50) NULL

INSERT INTO declaraciones
SELECT * 
FROM OPENQUERY(PG_Sectorial, 
'select 
A.rfcdeclarante,
M.razonsocial,
A.ejercicio,
A.fechapresentacion,
CAST(A.numerooperacion AS BIGINT) AS numerooperacion ,
B.totalasim,
B.totalisrretenasimsal,
B.totalnrotrabajasimsal,
B.totalnomina as totalsuelsal,
B.totalnomiexenta,
B.totalisrretensuelsal,
B.totalisrentersuelsal,
B.totaldiferenciasuelsal,
B.totalnrotrabajsuelsal,
B.totalnomina + B.totalasim as totalsuelsalasim,
B.totalnrotrabajasimsal + B.totalnrotrabajsuelsal as totaltrabajadores,
C.ptugeneradaejer,
D.ingacumulable,
F.impucausaejer,
F.isrcargoejer,
F.isrfavorejer,
F.isrretencontri,
F.pagosprovefec,
F.perdfiscalantesptu,
F.perdfiscalejer,
F.ptupagadaejer,
F.resultafiscal,
F.totalaplicaejer,
F.totaldeducautoriza,
F.totalingacum as totalingacum_16,
F.utilfiscalantesptu,
F.utilfiscalejer,
H.totalingacum as totalingac_24,
I.totalingacum as totalingac_30,
J.totalingacum as totalingac_36,
K.totalingacum as totalingac_47,
L.idtipodecla as idtipodecla_32,
M.idtipodecla as idtipodecla_37
from dapm37 as A
left join dapm13 AS B on A.numerooperacion=B.numerooperacion
left join dapm08 AS C on A.numerooperacion=C.numerooperacion
left join dapm11 AS D on A.numerooperacion=D.numerooperacion
left join dapm16 AS F on A.numerooperacion=F.numerooperacion
left join dapm24 AS H on A.numerooperacion=H.numerooperacion
left join dapm30 AS I on A.numerooperacion=I.numerooperacion
left join dapm36 AS J on A.numerooperacion=J.numerooperacion
left join dapm47 AS K on A.numerooperacion=K.numerooperacion
left join dapm32 AS L on A.numerooperacion=L.numerooperacion
left join dapm37 AS M on A.numerooperacion=M.numerooperacion
order by A.rfcdeclarante, A.fechapresentacion;');



SELECT * FROM OPENQUERY(PG_Recaudacion, '
select a.*, INITCAP(TRIM(TO_CHAR(fecha_captura, ''TMMonth''))) AS mes from pbi_servicios_2024 as a where 
fecha_captura between ''20240101'' and ''20250101'' 
and oficina not in (''OFICINA VIRTUAL'', ''AREA CENTRAL'', ''VENTANILLA ÚNICA ALCOHOLES'', ''Oficina Virtual'', ''PRUEBA TEST'');
')
-- --------------------------------------------------------------------------------------
--											REC
-- --------------------------------------------------------------------------------------
select * from Recaudacion.[dbo].[registroc_Civil_Nacimientos]

select TOP 1000 *from Informacion_Estatal.dbo.PADRON_TEMP_ where RFC='%LIGS901210RF3%'


select TOP 10 * from Informacion_Federal.dbo.Personas_Fisicas_2 where rfc like '%EOGJ770428M95%'



select TOP 1000 * from Informacion_Federal.dbo.Personas_Fisicas_2 where CONCAT(nombre,' ', ap_materno, ' ', ap_materno) like '%MANRIQUEZ%'


select TOP 10 * from Informacion_Federal.dbo.Personas_Fisicas_2 where ap_paterno like '%MANRIQUEZ%' AND ap_materno like '%RODRIGUEZ%'

select TOP 10 * from Informacion_Federal.dbo.Personas_Fisicas_2 where rfc like '%TC6'

select top 10 * from Informacion_Federal.dbo.PERSONAS_ where RFC like '%IPS8410043I7%'

select top 10 * from Informacion_Federal.dbo.PERSONAS_ where nombre like '%OLIVA MARIQUEZ%'

select  top 10 * from Informacion_Federal.dbo.Personas_Fisicas_2 where nombre_comercial like '%JIN HYEON BAE%' 


select top 10 *  from Informacion_Federal.dbo.Personas_Morales_2 where rfc like '%AST220527HE7%'

select top 10* from Informacion_Federal.dbo.Personas_Morales_2  where razon_social like '%BUFFETE%'

SELECT top 10 * FROM Recaudacion.dbo.REC where rec ='IPS8410043I7'

 SELECT base_datos, 
                    tabla, 
                    descripcion, 
                    creacion, 
                    modificacion, 
                    ultimo_registro, 
                    tipo_actualizacion, 
                    visible, 
                    responsable, 
                    gestor
            FROM actualizacion_tablas
            WHERE descripcion <> '' and tipo_actualizacion <> '' and responsable <> ''


SELECT A.RFC , 
		DATEDIFF(MONTH , ISNULL(FechaVisita, '20230224'), ISNULL(fe_baja, {fecha_acual})) - 2 AS PERIODOS,  
		estatus ,
		fe_baja, 
		C.PAGO, 
		ISNULL(C.CANTIDAD,0) AS CANTIDAD, 
		(DATEDIFF(MONTH , ISNULL(FechaVisita, '20230224'), ISNULL(fe_baja, {fecha_acual})) - 2 )- ISNULL(C.CANTIDAD,0) AS ADEUDO
FROM Informacion_Estatal.dbo.RFC_TIANGUIS AS A
LEFT JOIN REC_OBLIGACIONES AS B ON A.RFC = B.rec  
LEFT JOIN (
    SELECT RFC , SUM(PAGO) AS PAGO, COUNT(*) AS CANTIDAD FROM
    (SELECT RFC , Ejercicio , Periodo, SUM(IMPORTE) AS PAGO  FROM Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR WHERE Clave_Subclave IN ('1002-0009','0177-0003') GROUP BY RFC , Ejercicio , Periodo) AS X GROUP BY RFC) AS C ON A.RFC =C.RFC
WHERE obligacion LIKE '%REGIMEN SIMPLIFICADO DE CONFIA%' AND 
(DATEDIFF(MONTH , ISNULL(FechaVisita, '20230224'), ISNULL(fe_baja, {fecha_acual})) - 2 )- ISNULL(C.CANTIDAD,0) <= 10
ORDER BY ADEUDO

sp_help RFC_TIANGUIS

select * from fn_Adeudos_RegimenSimplificado(GETDATE()) WHERE RFC IN()

CREATE FUNCTION dbo.fn_Adeudos_RegimenSimplificado (@fecha_actual DATE)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        A.RFC,
        DATEDIFF(MONTH, ISNULL(A.FechaVisita,'20230224'), ISNULL(B.fe_baja,@fecha_actual)) - 2 AS PERIODOS,
        B.estatus,
        B.fe_baja,
        C.PAGO,
        ISNULL(C.CANTIDAD,0) AS CANTIDAD,
        (DATEDIFF(MONTH, ISNULL(A.FechaVisita,'20230224'), ISNULL(B.fe_baja,@fecha_actual)) - 2) 
        - ISNULL(C.CANTIDAD,0) AS ADEUDO
    FROM Informacion_Estatal.dbo.RFC_TIANGUIS AS A
    LEFT JOIN Recaudacion.dbo.REC_OBLIGACIONES AS B 
        ON A.RFC = B.rec  
    LEFT JOIN (
        SELECT 
            RFC,
            SUM(PAGO) AS PAGO,
            COUNT(*) AS CANTIDAD
        FROM (
            SELECT 
                RFC,
                Ejercicio,
                Periodo,
                SUM(IMPORTE) AS PAGO
            FROM Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR
            WHERE Clave_Subclave IN ('1002-0009','0177-0003')
            GROUP BY RFC, Ejercicio, Periodo
        ) AS X
        GROUP BY RFC
    ) AS C 
        ON A.RFC = C.RFC
    WHERE 
        B.obligacion LIKE '%REGIMEN SIMPLIFICADO DE CONFIA%'
        AND (
            (DATEDIFF(MONTH, ISNULL(A.FechaVisita,'20230224'), ISNULL(B.fe_baja,@fecha_actual)) - 2)
            - ISNULL(C.CANTIDAD,0)
        ) <= 10
);

select top 10* FROM Informacion_Estatal.dbo.RFC_TIANGUIS
					   
SELECT TOP 10 * FROM Informacion_Estatal.dbo.REC_DETALLE WHERE RFC='BAMJ521205RR0'

SELect top 100* from Rpp where rfc like '%PASM7503029Y9%'

select top 100 * from Catastro_Sat where rfc like '%PASM750302%'

select * from Personas_ where rfc like '%PASM7503029Y9%'

select COUNT(*) from REC_DETALLE

select 1135698 - 718625

417,073


select * from registroc_Civil_Nacimientos where rfc_relacionado like '%PASM750302%'

select top 100 * from PERSONAS_RC where RFC = 'PASM7503029Y9'

select * from Recaudacion.dbo.DOMICILIOS_REGISTRO_CIVIL WHERE RFC_RELACIONADO = 'PASM7503029Y9'



select top 10 * from Recaudacion.dbo.LISTADO_CFDI where NombreRazonSocialEmisor like '%%' 

SELECT TOP 10 * FROM Recaudacion.dbo.LISTADO_CFDI 

select top 100 * from  Informacion_Federal.dbo.Personas_Fisicas_2

select top 10 rfc, concat(a.nombre, ' ', a.ap_paterno, ' ', a.ap_materno)as nombre, calle, no_exterior, no_interior, entre_calle_1, entre_calle_2,b.nombre as colonia, a.cv_cp, c.d_estado as estado, c.D_mnpio as municipio
from Informacion_Federal.dbo.Personas_Fisicas_2 as a
inner join Informacion_Federal.dbo.cat_colonia as b on a.cv_colonia= b.cv_colonia
inner join Informacion_Estatal.dbo.CODIGOS_POSTALES as c on a.cv_cp= c.d_codigo
where  a.rfc_vig like '%DISH980420C94%'

select top 10 rfc, calle, no_exterior, no_interior, entre_calle_1, entre_calle_2,b.nombre as colonia, a.cv_cp, c.d_estado as estado, c.D_mnpio as municipio
from Informacion_Federal.dbo.Personas_Morales_2 as a
left join Informacion_Federal.dbo.cat_colonia as b on a.cv_colonia= b.cv_colonia
left join Informacion_Estatal.dbo.CODIGOS_POSTALES as c on a.cv_cp= c.d_codigo
where a.rfc like '%RED18062774A%' or a.rfc_vig like '%RED18062774A%'

Select top 100* from  Informacion_Estatal.dbo.CODIGOS_POSTALES

select top 10 * from Informacion_Federal.dbo.cat_municipio where cv_municipio='2124'

select top 10 * from Informacion_Federal.dbo.cat_colonia where cv_cp='11520' and cv_colonia='198597'obra

SELECT * FROM Informacion_Estatal.dbo.REC_DETALLE where rfc like '%DISH980420C94%'


SELECT * FROM Informacion_Estatal.dbo.REBAS WHERE FE_EXPEDICION >= '20130101' AND CVE_TIPO	<> '' ORDER BY FE_EXPEDICION

SELECT TOP 100 * FROM [dbo].[NOMBRES_CONTRIBUYENTES]



select count(*) from Recaudacion.dbo.registroc_Civil_Nacimientos

select top 100 * from[dbo].[RFC_PRUEBAS_SIAT]

SELECT top 1000 * FROM Recaudacion.dbo.listado_cfdi where RfcEmisor like '%GOGD870630%' or RfcReceptor like '%GOGD870630%'

SELECT TOP 100 * FROM Informacion_Estatal.dbo.TIPO_CONTRIBUYENTE

select top 1000 * from Informacion_Federal.dbo.PERSONAS_ where TRIM(RFC) like '%SAAR6201305P0%'

select top 1000 * from Recaudacion.dbo.PERSONAS_ where NOMBRE_COMPLETO like '%LOURDES AVILA HERRERA%'

select *from Recaudacion.dbo.RPP where trim(CONCAT(nombre,' ',apellido_paterno,' ',apellido_materno)) like '%MA. LOURDES AVILA HERRERA%'

select top 10 *from Recaudacion.dbo.RPP where trim(CONCAT(nombre_fedatario,' ',ap_paterno_fedatario,' ',ap_materno_fedatario)) like '%LOPEZ MERCADO%'

select * from (
select denominacion, 
				CONCAT(trim(nombre), ' ', trim(apellido_paterno) , ' ', trim(apellido_materno))as contribuyente,
				fe_inscripcion_inmueble,
				concat(trim(nombre_fedatario), ' ', trim(ap_paterno_fedatario), ' ', trim(ap_materno_fedatario)) as nombre_fedatario,
				calle_inmueble,
				num_ext_inmueble,
				col_inmueble,
				municipio_inmueble, 
				entidad_inmueble
from Recaudacion.dbo.RPP) as rpp 
LEFT JOIN Recaudacion.dbo.Personas_ p on rpp.contribuyente = p.NOMBRE_COMPLETO
where CONCAT(col_inmueble, ' ', calle_inmueble, ' ', num_ext_inmueble, ' ', municipio_inmueble) like '%Andrade%' 
	AND CONCAT(col_inmueble, ' ', calle_inmueble, ' ', num_ext_inmueble, ' ', municipio_inmueble) like '%Londres%'



select top 10 * from Recaudacion.dbo.RPP where rfc like '%DISH980420C94%'

select top 100* from Recaudacion.dbo.Catastro_Sat 
WHERE CONCAT(colonia_inmueble, ' ', calle_inmueble, ' ', num_ext_inmueble, ' ', municipio_inmueble) like '%Andrade%' 
	AND CONCAT(colonia_inmueble, ' ', calle_inmueble, ' ', num_ext_inmueble, ' ', municipio_inmueble) like '%Londres%'
	AND num_ext_inmueble like '%611%'

SELECT * FROM Recaudacion.dbo.Personas_ WHERE CURP = 'VAMA461224HGTLRR09'


CREATE INDEX IX_Tabla_RFC ON Catastro_Sat(rfc);

CREATE INDEX IX_Tabla_CURP ON Catastro_Sat(curp);

CREATE INDEX IX_Tabla_RFC ON Catastro_Sat(clave_catastral);

CREATE INDEX IX_Tabla_RFC ON Catastro_Sat(clave_catastral);



select top 100* from Recaudacion.dbo.Catastro_Sat where trim(concat(nombre, ' ', apellido_p,' ',apellido_m)) like '%JESUS EDUARDO LOPEZ MERCADO%';

select top 100* from Recaudacion.dbo.Catastro_Sat where nombre like '%JESUS EDUARDO%' AND apellido_p like '%LOPEZ%';

select * from Informacion_Estatal.dbo.REC_DETALLE

select * from Informacion_Estatal.dbo.PADRON_DETALLE_

select top 10 * from Recaudacion.dbo.LISTADO_CFDI where RfcEmisor like '%MUMM810315LP6%' or RfcReceptor like '%MUMM810315LP6%' or RfcPac like '%MUMM810315LP6%'

SELECT TOP 100 * FROM Informacion_Federal.dbo.Personas_Fisicas_2 where concat(trim(nombre),' ', trim(ap_paterno), ' ', trim(ap_materno)) like '%SASAKI%'

select * from rebas where rfc = 'BAMJ521205RR0'

EXECUTE SELECCIONA_PAGOS 79264 , 'GUGJ6102021YA' , '2025-05-07' , 'PROMOCION'

select top 10000 * from PAGOS_REGISTRADOS_PARA_DEPURAR order by Fecha desc

select count(*) from PAGOS_REGISTRADOS_PARA_DEPURAR
---42,906,074

select * from Informacion_Estatal_Temporal.dbo.

Select top 1000 * from Recaudacion.dbo.REC order by fe_alta desc, rec desc

SELECT rfc, Ejercicio, Periodo, fecha, SUBSTRING(Clave_Subclave,0,5) as clave FROM PAGOS_REGISTRADOS_PARA_DEPURAR where Ejercicio= 2025 and Periodo=2 and Fecha >= '20250325' and Clave_Subclave like '%1001%' group by rfc, Ejercicio, Periodo, fecha, SUBSTRING(Clave_Subclave,0,5)

SELECT sum(tasa_mensual) - 11.76
FROM tasas_recargos
WHERE (anio = 2013 AND mes >= 4)
   OR (anio > 2013)

select * FROM tasas_recargos order by anio desc

SELECT sum(tasa_mensual)
        FROM tasas_recargos
        WHERE anio = '2022' AND mes >= 4
		group by anio,mes
          

select top 100 * from "/BIC/OHZDRS1"

select top 100 * from "/BIC/OHZDRS2"


--ALTER DATABASE Declaraciones_Fisicas SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--GO

--ALTER DATABASE Declaraciones_Fisicas MODIFY NAME = Declaraciones;
--GO

--ALTER DATABASE Declaraciones SET MULTI_USER;
--GO

select * from [dbo].[Personas_]

select top 100* from Informacion_Federal.dbo.Personas_Fisicas_2

CREATE TABLE [dbo].[Personas_General](
	[RFC] [varchar](13) NOT NULL,
	[CURP] [varchar](18) NULL,
	[TIPO_PERSONA] [char](1) NULL,
	[NOMBRE_COMPLETO] [varchar](255) NULL,
	[RAZON_SOCIAL] [varchar](255) NULL,
	[TIPO_SOCIEDAD] [varchar](50) NULL,
	[NOMBRE] [varchar](255) NULL,
	[AP_PATERNO] [varchar](60) NULL,
	[AP_MATERNO] [varchar](60) NULL,
	[FECHA_NAC] [date] NULL,
	[SAT] [bit] NULL,
	[REC] [bit] NULL,
	[VEHICULAR] [bit] NULL,
	[REBAS] [bit] NULL,
	[RC] [bit] NULL,
	[CFDI] [bit] NULL,
 CONSTRAINT [PK_Personas_] PRIMARY KEY CLUSTERED 
(








-- --------------------------------------------------------------------------------------
--											BLOQUEOS
-- --------------------------------------------------------------------------------------

Select count(*)from BLOQUEOS_SATEG 

select TOP 100* from BLOQUEOS_SATEG ORDER BY FECHA_INICIO_BLOQUEO DESC






-- --------------------------------------------------------------------------------------
--											REBAS
-- --------------------------------------------------------------------------------------


SELECT TOP 10*FROM PBI_REBAS

select * from REBAS_TEM where FE_EXPEDICION >= '20210101'

SELECT  TOP 100 * FROM REBAS order by FE_EXPEDICION desc






-- --------------------------------------------------------------------------------------
--											VISITAS KOBRA
-- --------------------------------------------------------------------------------------

SELECT TOP 100 * FROM Visitas 
WHERE Folio = '151A10432V762'

151A10432V751
151A10432V762

151A10195V645
151A10195V641
151A10370V339
151A10370V338
execute INSERTA_VISITAS

select * from[dbo].[Preguntas_kobra] where Pregunta like 'Foto'

select top 100 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.visitas where folio in ('151A9938V2363')


select top 100 * from [dbo].[Control_ETL_VisitasDetalles]

select top 100 * from [dbo].[Coordenadas]

select top 100 * from etiquetas 

select top 100 * from Direcciones_Verificadas

select top 100 * from ALGUNA_TABLA 



select top 100 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.[acreditados_cuentas]

 select top 100 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.[acreditados_cuentas_domicilios]
 inner join [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.[acreditados_cuentas]


SELECT count(*) FROM entregado



select * from KobraVisitasHoy where FolioVisita in( 
'151A10013V2150',
'151A10458V834',
'151A10492V412',
'151A9537V1602',
'151A9981V2098')
order by ID_Interno DESC

select FolioVisita, count(*) from KobraVisitasHoy 
group by FolioVisita
having count(*)>1

order by FolioVisita

--delete KobraVisitasHoy where ID_Interno = 462;
--delete KobraVisitasHoy where ID_Interno = 412;
--delete KobraVisitasHoy where ID_Interno = 112;
--delete KobraVisitasHoy where ID_Interno = 63;
--delete KobraVisitasHoy where ID_Interno = 62;


select * from KobraVisitasHoy where IdSubcuenta like '%1610/2026-2%';

select * from KobraVisitasHoy Order by InicioVisita desc

select * from KobraVisitasHoy Order by ID_Interno desc


CREATE UNIQUE INDEX UX_KobraVisitasHoy_Folio
ON KobraVisitasHoy (FolioVisita);


DBCC CHECKIDENT('KobraVisitasHoy', RESEED, 0)

select top 100 * from Informacion_Estatal.dbo.Difuntos



select TOP 100 * from ALGUNA_TABLA

select * from visitas

select * from Recaudacion.dbo.Personas_ where rfc in ('GOMG8105244L0',	'GOTA7208204T8',	'GOGB861005DU3',	'OEMA900424A21',	'CAPN891020DB9',	'AATE711030QX6',	'GABN870130F15',	'GALK820413534',	'NALL930817AC0',	'HEJA9212118A2',	'MOVD960904SC8',	'EALC721007GWA',	'AOOC910813H39',	'BASJ670530342',	'GABM7211284C8',	'CAFL690322AZ9',	'CAEM950214PE3',	'CESA830510S31',	'OALE9408148P4',	'HEAS900224PE9',	'OISY8508055Q4',	'AUMK9602161C3',	'CORE890405563',	'MOZG880312RB4',	'GOEG9809292M5',	'AEFC800309F48',	'AUFM690728P7A',	'GACK930829212',	'AUEA7802261R2',	'MASE7902169P2',	'GOCR840105E40',	'AIFL920825KL3',	'HEOA690607429',	'HERF691202796',	'AURM820603TT4',	'COMM861024IW8',	'MIRA870402P31',	'AUDD781217JT7',	'BAGR9104272B4',	'MOAH860602UV1',	'MAOL7906171U6',	'AARC941208JB3',	'CEBR6511263X3',	'LUNR880306Q63',	'QUQG780312J29',	'GOAM88022549A',	'MOPP881230SS5',	'DIGR900115CXA',	'MELE850820G96',	'BAZE940404E15',	'CURE760303KZ5',	'CAMB981016129',	'LOGP890412521',	'HEFP760810JR9',	'AAPE720830S75',	'AAOR8711076B9',	'AARA830606VC1',	'BAGB9006286Y7',	'FEQS880716Q72',	'BEMM950716B97',	'CAAG9402034N7',	'AALN891222NJ2',	'AALL820501LF7',	'CUHL9010207J7',	'GAPG900513R55',	'MOVT921001TT0',	'RODA920321NY2',	'MAAG850406787',	'EAGJ730608TRA',	'CORS930818CB7',	'MIMF870727GC3',	'DICA861118UA2',	'EIRM800613ND9',	'DULR9411164T8',	'EUTA7310276Y6',	'MAGN9412269B7',	'GAMR031220VD9',	'GASD9912308N0',	'MALM750530P14',	'HILF800314TJA',	'LIHM780510MH8',	'COVA7102221Q1',	'MAAR850123AG3',	'AEEJ900619NA2',	'CAGR7908149L7',	'EIRD790705UV9',	'MEMR690329KI3',	'HECK970928SC2',	'LOAA7205078P5',	'GANJ690515NT8',	'MELU9410055T0',	'AEMC580621JF7',	'MUDE841224956',	'AOMI0011098MA',	'AURI911005ED3',	'COPP760905974',	'SAGC0303113EA',	'HECA900202VE1',	'GAAS8004274E0',	'BAMG730809EY9',	'GOBB9801237X0',	'PAGA691024AU5',	'GAMF950205AF2',	'MARP970819TD4',	'DAVE890919CA2',	'BOJJ980701Q59',	'GAMG9112319H6',	'OEHA901212JE1',	'COML800816UV7',	'FEGA871130TV8',	'ROSM920618P79',	'EAMA930129SL5',	'CUMR7609291CA',	'DEML961015NH3',	'GOGE870727M37',	'LORG670325DZA',	'LEMA930709H73',	'MOCP8202195S7',	'RAAM920303LQ9',	'MASD950306QD8',	'GOTV990115868',	'LOCF850402FD8',	'GOEO880808S65',	'MELJ9710235HA',	'GOCJ8810267Q7',	'AEPC820706NAA',	'BATJ701208V91',	'GADF9907036J7',	'VEAN710313BF7',	'MABC6602236IA',	'NAVG970628HH1',	'MENL861018DV4',	'COLO801108HV8',	'HEMJ900921G64',	'CABS9608059D9',	'FESC8201219C7',	'PADS880317574',	'MOML8606063W5',	'CAHE910919234',	'CAGC001122F52',	'RAAJ040709ED6',	'GAEA950809KL2',	'AIMV001111811',	'CAPM7905152M1',	'AISA990220RD6',	'HEBA8902062Z1',	'EAHJ8809139G1',	'CACP881217NR9',	'EIOT911025FD7',	'DUCJ8806082U9',	'NIML811204HN9',	'GACE010801663',	'CAGG980412416',	'AEAM861106HRA',	'OECA970620BZA',	'MAZE711111C58',	'OEEF940915DW6',	'EIAE880818UD2',	'FEOC690309TG7',	'COCA780609I3A',	'HEGG720613JBA',	'DOHC720121UW0',	'MESC000703FB9',	'CESK890220ED1',	'GUPJ940726EJ6',	'VATA7911101L2',	'BIMG860625PK2',	'GAJJ890412N96',	'GORA920108LH7',	'BIFE040503DI1',	'GOVA9505018K9',	'AUMD910912QT6',	'TOHD8708179E5',	'GABH840220E13',	'FUMO960605LG3',	'GUPI9705126K3',	'BAMG8404014EA',	'MECM860825SA0',	'POLM890725B47',	'MAVL031114873',	'GIRA830422CB6',	'LOBS921219CB0',	'GABJ97110887A',	'MEHM850513LD2',	'AIAD8101089B6',	'EICL990310QS1',	'CAHA990311JI0',	'IAGL9706238H8',	'VAVN8808317L2',	'LORM990605EF4',	'OIPG760122GG8',	'CUTR8512266U3',	'GIAA960222MX8',	'LOCR681218T56',	'IAMY890404MS0',	'GAMB970208245',	'MAVD921115BV2',	'FORA750910118',	'MACM820613UB9',	'AAGE990205Q47',	'HEHD9409138I7',	'EUZM951124SK6',	'AOPV810130F22',	'VAGG861225TA4',	'PALF990821AH4',	'RAAJ740621JL6',	'MUZO9810182W8',	'CAGV980116T89',	'CUBR7312184D1',	'UIGH9006203S7',	'COOP800401AS9',	'BIPE920406GW1',	'AAAJ991012ITA',	'NARP950126PV8',	'LOCD900926PN5',	'MAAI8512199B7',	'MAPJ840504FB1',	'GOTI900429GE9',	'BACC830308FD5',	'MUSF951208360',	'NUZR951019AV7',	'RAQM830929R65',	'JIRA790326IA1',	'MUCR640903V7A',	'AIVL800721R29',	'GOML881207N17',	'MAGA9010093J5',	'BAMA811001EWA',	'MAMA031018GW5',	'AURR981024HD8',	'PAPM820908AN7',	'MERH9609115K9',	'MOMS6604258RA',	'GIVR910622NS5',	'COGM9303078T2',	'GACA8107085VA',	'GAMO720121SG7',	'CAMA78070261A',	'GUSJ7402259M1',	'AAVR861023NZ5',	'BIAB9408292Y7',	'CEAD821215EP2',	'PEME910726496',	'GOGI7501197D6',	'AIRH981115P98',	'NAGG981210663',	'LIBA8602281A6',	'RALJ941019S37',	'DIRH900329FZ8',	'GUNV920617U23',	'AEAB890214S42',	'GOAJ860127DF4',	'GUOR8307182L6',	'HURM780925AF5',	'GOTV921008AE1',	'AEFN790507KI8',	'EACE960418U1A',	'AOLA990710EF1',	'AURF7309136G9',	'MAVJ8901166P2',	'PARL990412P69',	'MUNY850706DB7',	'RAML000630FA4',	'AAFM970310UB3',	'BASM960108190',	'DOPL970921570',	'LOMM9808272D0',	'DEAD990705949',	'AAMJ830804FH3',	'AESO8903172Q0',	'COMG710523BE3',	'COLG9201215P3',	'DICC920721DS4',	'RACD8204241K8',	'AISO940908C64',	'PUHP950507J47',	'AAVI690911TH5',	'MACC980805564',	'AULL9904039H6',	'CACH940326986',	'LOCG950129252',	'VAHJ0104035M7',	'SANA771231H76',	'GUZA0203193E0',	'RESD931218576',	'JICM900916AN1',	'AUSL8410233Y0',	'MELJ901025A94',	'BAVM870210U99',	'GURC840712D8A',	'VEMA9501147I2',	'BOPG8407126U5',	'GOVM960224P81',	'MAMX960927JZ4',	'GOGR970515LM2',	'AECJ9209178R7',	'GOMM9602099E8',	'GORS770215S63',	'CALD8601084X5',	'CAAP830321686',	'ZANM840228S38',	'AAGR000620HRA',	'AAPR930514DE6',	'GALJ790423FM4',	'JIEC961016GPA',	'GAGB910124MM2',	'MOGJ781224UB4',	'BOEJ010205TY3',	'AASC010821UY2',	'GORJ890717244',	'PUPJ830426E98',	'LOAE660823SS4',	'RIBO890802I72',	'OIAA811017P40',	'GOJD871014I50',	'OIMC950118CT3',	'OOLF8810128A4',	'OIGE761219GM2',	'CORA971123QU9',	'GOGO7605124J6',	'GOMA950525IE9',	'MULC840701UQ3',	'HEDH831023RQ3',	'MEFD971021KQ2',	'MOTE961206TE7',	'MESF830403KG8',	'AESS010702LI3',	'NIGL960929585',	'GULE8402031K0',	'GABA720316UIA',	'HESM861123R77',	'CAGD810629PB3',	'GUGA890819KM6',	'GULM901027QG6',	'GUJD000205EG9',	'HEHM75121144A',	'PEMG000719NR6',	'MOCF010424BT4',	'MERG871211FL1',	'SABA011022A43',	'ROCD011218BS8',	'RIAC6603116S8',	'VAVF670306RR1',	'HEBA981020V87',	'RACC930503628',	'COFE810711II8',	'RARJ8902231L5',	'LAMJ910113P59',	'AEQG800727IT2',	'MABA9705114Z4',	'GUMF9510072D6',	'PABP940202EP1',	'CERC821007AX6',	'GOVF860926MG4',	'COCC000527T38',	'VABJ9312261I1',	'GAPG820131748',	'GOGA7408272I5',	'GUFA010916DW4',	'MUHM910601RY5',	'BICP941105T38',	'MAGA690713CU3',	'MAGD911119BU7',	'IARR920703FR5',	'BAIE7301274L6',	'AENS930711T10',	'GACM7510137N6',	'BAGL6909139R6',	'GOGC8301104L3',	'LOMC790812D31',	'AAFM920814525',	'NOAM751205N20',	'CAGF950916L27',	'MOJU740913KV2',	'NAOV830515PZ5',	'JAEV901129LG2',	'MODA850614PC0',	'CIPA970611ID3',	'BALL910316651',	'HEAE751019AQ6',	'GUEA7602147F5',	'MIRA720504RX1',	'PECB720207HX4',	'AUMC971024LJ9',	'MAOB861211CE9',	'HEGE800928J80',	'LUPJ900424355',	'NAOC780307IR3',	'GORJ950308CB8',	'MAPJ810405HJ5',	'GAPS910412GI8',	'MAPE990410JN5',	'HELE961009291',	'HEBH9605234Z1',	'OEGJ690414UL1',	'MAFL830911AN7',	'OOVV801020RV6',	'MAMN900430828',	'GUMJ000828BN7',	'GUGA8911147A3',	'RERA990525FM1',	'HEGF990503CW0',	'EIAS950329BJ2',	'RACA901109KS4',	'AARI970423IQ5',	'MEVP810520RC4',	'RAAS880326B30',	'GOMH930302KL2',	'MOSJ000719Q49',	'PECR910731G57',	'CEVC900405IX2',	'HAGB8701172L5',	'TEGA810423954',	'GARO750815V91',	'NEAJ990308PF0',	'MEHC8505263HA',	'HEQL710126VE2',	'COSJ011120DC8',	'LOVL8805185C9',	'BAAJ930128HJ9',	'GAFJ8504298P5',	'BOBG940906PD4',	'MIGE970103TM4',	'LATH961205K36',	'MAGY880406QR1',	'LORB9303102J3',	'NADD770625P7A',	'HEHA020718IS8',	'GUNA920419PJA',	'IAVE911201PK2',	'SUCV860219FS8',	'AOHB650714988',	'SIRJ7208139B3',	'ROGM850412QZ2',	'GECE920723EH6',	'NACJ920118N82',	'SACS770715NV5',	'RAFS940527TY7',	'RONF0209233U2',	'ROCA951130TL0',	'ROAJ8811012J5',	'SAOM690313LN3',	'OISF800424Q16',	'AEVD7107017Q7',	'MUCA010705S76',	'AUMR810510N53',	'AATA911019M91',	'MIRK921209GC9',	'NONJ990410HCA',	'OISC680320A42',	'PELE860228VB8',	'GORL890411UP5',	'GORF710705MF4',	'TIFC870913UB5',	'RIEC8310068H6',	'MAEL941020BW2',	'GOMR940904G20',	'PACB840119EY5',	'MUVC931026AE8',	'DOJU8305062M0',	'AURC820319DC4',	'MOMR870908EG1',	'MELS9910083G2',	'MOPF870117190',	'ZAFS9210065SA',	'OIMH960627V37',	'VEPL690216EU2',	'LAAA030715UJ0',	'MUCT7708036W0',	'MOVE980127726',	'PEGM921225SI6',	'PEMS9411033P6',	'CUCG911202RDA',	'SAEA8508044U0',	'OILB9008136S7',	'CASB850215H67',	'OOLR871230426',	'MEVA880520T3A',	'EIMR870623P63',	'FOJE800521AZ5',	'EURL010127B76',	'GUCL781224AU2',	'ROPS891230AW4',	'BECC950609RFA',	'DEMJ7306064B7',	'BASJ8111279G6',	'RAAA711224A90',	'PESR8802107I5',	'MOPC7905156D6',	'LOSS000608E65',	'RIEA780719G83',	'GOSP9806123AA',	'BERG841118IA5',	'CETJ010516I46',	'LUGM000811P28',	'ZAGF861114JY4',	'RACJ761220RN2',	'DAGA820421BP5',	'RAHL811112KT4',	'SEAS990308TP8',	'RAHM880903UL4',	'EORS730521R62',	'GALM921019973',	'MECR810322PT2',	'MAGL950218MT1',	'UUPA840108TZ9',	'RIRR8709021Q4',	'HEOV0006073G0',	'GOOA971215LF9',	'OASM780117GJ7',	'PASG870903C34',	'SIQS850904M53',	'LAAC740624P43',	'RARJ941016RF9',	'PEDM0112183S1',	'RAGB740307A72',	'AURC8105201C1',	'REOL900125LD9',	'PAPL810514A23',	'TESE8303019H3',	'RAHH970729HS2',	'OECJ720412UBA',	'PAAM950906U5A',	'MORH891031Q72',	'MARI910213U49',	'ROPH720411QFA',	'RESA840902SG7',	'VEFY881009MJ4',	'SALO940906RE6',	'AATA7403127T4',	'MOLF951125G5A',	'PIMM001111880',	'PIMJ950407QB3',	'RAPJ790901G33',	'OEMA970927JU5',	'OOHC720910UZ8',	'PASY840525KU6',	'QUMC921111JB4',	'RAHA8901166K4',	'OECA800707PNA',	'OEMD920120K4A',	'NALD9409033J6',	'NOCL9904152KA',	'PEAV760420CX3',	'PERM8701079Z3',	'PEGA820831JW7',	'AEMM811210I57',	'VIAG881117RM9',	'OOMM7806124Y8',	'NIML821211L25',	'RUEA981124SP7',	'SAEL900524631',	'OIRH750709JX6',	'PAPL8405149Q9',	'PAHA910802S96',	'VADI6706174J1',	'ROVA770328I71',	'GAMA920817UH4',	'IEAD891212NS1',	'OIML9408059D5',	'CAMH7202189JA',	'MECJ940211NC9',	'ROGJ8205295CA',	'REHH900210IE9',	'MOVM8010057R8',	'MOML630813UM2',	'JISS770611FZ0',	'MOMJ940526IS2',	'AOSL951010SB9',	'CABS880607UMA',	'GAFN8209218K3',	'GUSC8810255Z8',	'GOAV9609151M6',	'REMM760115KQ4',	'VERC010321MU8',	'CAHL660427DA6',	'GOGB730623SK1',	'ROMO720803GV1',	'LOZB911011JP5',	'AUJB970406PEA',	'LEJM810908GB5',	'DIRC9603031Q5',	'REVS8110073Q1',	'TUCA941018M71')

select Distinct sub_id_externo  from Visitas

select * from KobraVisitasHoy

select TOP 10 *
					from   [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.visitas as B 
					LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados AS X ON X.id_acreditado = B.id_acreditado    
					LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados_cuentas_domicilios AS J ON B.id_acreditado= J.id_acreditado AND J.id_acreditado_cuenta_domicilio= B.id_acreditado_cuenta_domicilio AND B.ID_CUENTA=J.ID_CUENTA
					LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.estados AS K ON J.id_estado= K.id_estado
					LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.municipios AS L ON L.id_municipio= J.id_municipio
					INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados_cuentas AS C ON X.ID_EXTERNO = C.ID_EXTERNO AND B.id_cuenta=C.id_cuenta
					WHERE( C.sub_id_externo ='EJECUCION:{sub_id}' OR C.sub_id_externo ='{sub_id}'  ) 
					AND CAST(fec_finalizada AS DATE) BETWEEN '{fecha_envio}' AND DATEADD (DAY,20,'{fecha_max}' )
					order by fec_finalizada 



select *
--GETDATE() AS Fecha_Consulta ,B.folio, B.comentarios, B.fec_finalizada, B.fec_registro, C.sub_id_externo as Num_guia
                          from   [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.visitas as B 
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados AS X ON X.id_acreditado = B.id_acreditado    
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados_cuentas_domicilios AS J ON B.id_acreditado= J.id_acreditado AND J.id_acreditado_cuenta_domicilio= B.id_acreditado_cuenta_domicilio AND B.ID_CUENTA=J.ID_CUENTA
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.estados AS K ON J.id_estado= K.id_estado
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.municipios AS L ON L.id_municipio= J.id_municipio
						  INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados_cuentas AS C ON X.ID_EXTERNO = C.ID_EXTERNO AND B.id_cuenta=C.id_cuenta
                          WHERE 
						 -- X.ID_EXTERNO LIKE '%CUPL7310178R1%' AND  
						 C.sub_id_externo LIKE  '%11721/2025%'  
						  --AND CAST(fec_finalizada AS DATE) BETWEEN '{fecha_envio}' AND DATEADD (DAY,20,'{fecha_max}' )
                          order by fec_finalizada desc



select  X.ID_EXTERNO as rfc, concat(AGENTE.nombre, ' ', AGENTE.apellido_paterno, ' ', AGENTE.apellido_materno) as agente, AGENTE.email, J.calle , ISNULL(J.numero_ext, '')AS num_ext , ISNULL(J.numero_int, '')AS num_int , J.colonia , j.codigo_postal , L.nombre AS municipio , k.nombre as Estado, j.lat , j.lng, b.fec_finalizada
                          from   [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.visitas as B 
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados AS X ON X.id_acreditado = B.id_acreditado    
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados_cuentas_domicilios AS J ON B.id_acreditado= J.id_acreditado AND J.id_acreditado_cuenta_domicilio= B.id_acreditado_cuenta_domicilio AND B.ID_CUENTA=J.ID_CUENTA
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.estados AS K ON J.id_estado= K.id_estado
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.municipios AS L ON L.id_municipio= J.id_municipio
						  INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados_cuentas AS C ON X.ID_EXTERNO = C.ID_EXTERNO AND B.id_cuenta=C.id_cuenta
						  LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes as AGENTE ON B.id_agente=AGENTE.id_agente
                          order by fec_finalizada desc
						  


select TOP 10 B.Folio , B.fec_finalizada AS FVISITA , B.repunteo AS REPUNTEO , B.comentarios, J.calle , J.numero_ext , J.numero_int , J.colonia , j.codigo_postal , L.nombre AS Municipio , k.nombre as Estado  ,
                         j.lat , j.lng ,  id_etiqueta_visita as id_etiqueta , fotos ,des_etiqueta='' , localizado=0,notificado=0, b.checklist , coordenadas,  X.ID_EXTERNO as rfc, AGENTE.folio as Agente
                          from   visitas as B 
                          LEFT JOIN acreditados AS X ON X.id_acreditado = B.id_acreditado    
                          LEFT JOIN acreditados_cuentas_domicilios AS J ON B.id_acreditado= J.id_acreditado AND J.id_acreditado_cuenta_domicilio= B.id_acreditado_cuenta_domicilio AND B.ID_CUENTA=J.ID_CUENTA
                          LEFT JOIN estados AS K ON J.id_estado= K.id_estado
                          LEFT JOIN municipios AS L ON L.id_municipio= J.id_municipio
                          LEFT JOIN agentes as AGENTE ON B.id_agente=AGENTE.id_agente
						  INNER JOIN acreditados_cuentas AS C ON X.ID_EXTERNO = C.ID_EXTERNO AND B.id_cuenta=C.id_cuenta
select  top 100 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.visitas order by fec_finalizada desc

SELECT TOP 100 * FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes


select top 100 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes where folio = '30068'

select distinct sub_id_externo from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados_cuentas

select top 100 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados_cuentas

--313,178

--307,746
execute INSERTA_DETALLES

SP_HELPTEXT INSERTA_VISITAS

Select jefatura,nombre_jefatura from Visitas group by jefatura,nombre_jefatura

Select top 500* from Visitas

select top 100 * from  recorrido


SELECT
            id_usuario_kobra,
            CASE 
                WHEN ape_materno_consultor IS NULL 
                    THEN CONCAT(nombre_agente, ' ', ape_paterno_consultor) 
                ELSE CONCAT(nombre_agente, ' ', ape_paterno_consultor, ' ', ape_materno_consultor) 
            END AS nombre_agente,
            email_agente,
            UPPER(municipio) AS municipio,
            CONVERT(VARCHAR(10), CAST(fecha_registro AS DATE), 120) AS fecha_registro,
			CONVERT(VARCHAR(8), fecha_registro, 108) AS hora_registro
        FROM DeclaraFacil_Visistas
        GROUP BY
            id_usuario_kobra,
            CASE 
                WHEN ape_materno_consultor IS NULL 
                    THEN CONCAT(nombre_agente, ' ', ape_paterno_consultor) 
                ELSE CONCAT(nombre_agente, ' ', ape_paterno_consultor, ' ', ape_materno_consultor) 
            END,
            email_agente,
            UPPER(municipio),
            CAST(fecha_registro AS DATE),
			CONVERT(VARCHAR(8), fecha_registro, 108)
        ORDER BY fecha_registro DESC


select B.Folio , B.fec_finalizada AS FVISITA , A.nombre AS Area , A.comentarios, J.calle , J.numero_ext , J.numero_int , J.colonia , j.codigo_postal , L.nombre AS Municipio , k.nombre as Estado  , j.lat , j.lng ,  C.LOCALIZADO , C.ENTREGADO,C.descripcion as Etiqueta , B.fotos
                          from Visitas as A
                          INNER JOIN  [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.visitas as B on A.Folio = b.Folio
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados AS X ON X.id_acreditado = B.id_acreditado     
                          INNER JOIN ETIQUETAS AS C ON  B.ID_ETIQUETA_VISITA = C.ID_ETIQUETA
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados_cuentas_domicilios AS J ON B.id_acreditado= J.id_acreditado AND J.id_acreditado_cuenta_domicilio= B.id_acreditado_cuenta_domicilio AND B.ID_CUENTA=J.ID_CUENTA
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.estados AS K ON J.id_estado= K.id_estado
                          LEFT JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.municipios AS L ON L.id_municipio= J.id_municipio
                          WHERE X.ID_EXTERNO LIKE '%PJE960101QF5%' and B.id_producto='113' order  by B.fec_finalizada desc




select top 10 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.visitas

select top 10 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.acreditados_cuentas_domicilios

select top 10 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.estados 

select top 10 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.municipios

select top 100 * from Visitas


SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM 
    [172.31.113.31\DIDS_PROD1].KobraRemoto.INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_TYPE = 'BASE TABLE'
ORDER BY 
    TABLE_SCHEMA, TABLE_NAME;

select * from [dbo].[DeclaraFacil_Visistas] where origen = 'Visitas'

select * from DeclaraFacil_Visitas

SELECT  * FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes where rfc in ('MOAD620405FM5',	'MEOM8205248EA',	'HERG78021600A',	'EIOB790709TX1',	'MALC970213UB7',	'BAHA77010200A',	'SAJS730820K92',	'AUGA850313BT5',	'HEOL8111028E7',	'HEMI70011200A',	'MARL591229AZ2',	'FOOP63042700A',	'AEAA840208PV5',	'AEGC7207239G7',	'CAMR970102NG6',	'ROCR650311452') order by fec_registro desc


SELECT TOP 10 * FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes  order by fec_registro desc

SELECT TOP 100 * FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes_domicilios

SELECT top 100  * FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitudes where folio = '151A9174V6880' ORDER BY fec_registro desc

SELECT  TOP 10 * FROM Coordenadas

SELECT TOP 10 * FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.tipos_solicitudes


SELECT  C.calle, C.num_int, C.num_ext, C.colonia, C.lat as lat_dir, C.lng as lng_dir, A.lat_inicio, A.lng_inicio, A.lat_fin, A.lng_fin, C.codigo_postal, C.estado, C.municipio 
FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitudes AS A
INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes AS B ON A.id_solicitante=B.id_solicitante
INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes_domicilios AS C ON A. = C.id_solicitante_domicilio
INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes AS D on A.id_agente = D.id_agente
where CAST(B.fec_registro AS DATE) = '20250421' 


select 
A.folio, 
		A.id_solicitante, 
		A.lat_inicio, 
		A.lng_inicio, 
		A.lat_fin, 
		A.lng_fin, 
        B.nombre, 
		B.primer_apellido, 
		B.segundo_apellido, 
		B.fec_nacimiento, 
		B.tel_cel, 
		TRIM(B.email) as email, 
		B.curp, 
		B.rfc, 
        C.calle, 
		C.num_int, 
		C.num_ext, 
		C.colonia, 
		CD.Latitud as lat, 
		CD.Longitud as lng, 
		CASE 
			WHEN TRIM(C.codigo_postal) = '01209' or TRIM(C.codigo_postal) = '' or TRIM(C.codigo_postal) is null THEN 'SIN CP' 
			ELSE TRIM(C.codigo_postal) 
		END AS codigo_postal, 
		C.estado, 
		CASE
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'ABASOLO' THEN 'Abasolo'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'ACAMBARO' THEN 'Acámbaro'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'APASEO EL ALTO' THEN 'Apaseo el Alto'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'APASEO EL GRANDE' THEN 'Apaseo el Grande'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'ATARJEA' THEN 'Atarjea'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'CELAYA' THEN 'Celaya'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'MANUEL DOBLADO' THEN 'Manuel Doblado'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'COMONFORT' THEN 'Comonfort'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'CORONEO' THEN 'Coroneo'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'CORTAZAR' THEN 'Cortazar'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) IN ('CUERAMARO', 'CUERÁMARO') THEN 'Cuerámaro'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'DOCTOR MORA' THEN 'Doctor Mora'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) LIKE 'DOLORES HIDALGO%' THEN 'Dolores Hidalgo Cuna de la Independencia Nacional'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'GUANAJUATO' THEN 'Guanajuato'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'HUANIMARO' THEN 'Huanímaro'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'IRAPUATO' THEN 'Irapuato'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'JARAL DEL PROGRESO' THEN 'Jaral del Progreso'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'JERECUARO' THEN 'Jerécuaro'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'LEON' THEN 'León'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'MOROLEON' THEN 'Moroleón'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'OCAMPO' THEN 'Ocampo'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'PENJAMO' THEN 'Pénjamo'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'PUEBLO NUEVO' THEN 'Pueblo Nuevo'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'ROMITA' THEN 'Romita'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'SALAMANCA' THEN 'Salamanca'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'SALVATIERRA' THEN 'Salvatierra'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'SAN DIEGO DE LA UNION' THEN 'San Diego de la Unión'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'SAN FELIPE' THEN 'San Felipe'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'SAN FRANCISCO DEL RINCON' THEN 'San Francisco del Rincón'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'SAN JOSE ITURBIDE' THEN 'San José Iturbide'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'SILAO DE LA VICTORIA' THEN 'Silao de la Victoria'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'VALLE DE SANTIAGO' THEN 'Valle de Santiago'
			WHEN UPPER(LTRIM(RTRIM(C.municipio))) = 'YURIRIA' THEN 'Yuriria'
			ELSE C.municipio
		END AS municipio, 
        CASE 
			WHEN UPPER(D.nombre)='MONTSERRAT' AND D.id_agente= 10034 then 'MONSERRAT' 
			WHEN UPPER(D.nombre)='JOSÉ ANDRÉS' AND D.id_agente = 10159 THEN 'JOSE ANDRES'
			WHEN UPPER(D.nombre)= 'JOSE LUIS' AND D.id_agente = 9604 THEN 'JOSÉ LUIS'
			ELSE trim(UPPER(D.nombre)) 
		END AS nombre,
		CASE
			WHEN TRIM(UPPER(D.apellido_paterno)) ='HUITRÓN GARCÍA' and D.id_agente = 10159 THEN 'HUITRON GARCIA' 
			WHEN TRIM(UPPER(D.apellido_paterno)) ='GOMEZ GALVAN' and D.id_agente = 9604 THEN 'GÓMEZ GALVAN' 
			ELSE TRIM(UPPER(D.apellido_paterno)) 
		END AS apellido_paterno, 
		CASE 
			WHEN TRIM(UPPER(D.apellido_materno)) = 'GARCÍA' and D.id_agente = 10159 THEN 'GARCIA' 
			ELSE TRIM(UPPER(D.apellido_materno))
		END AS apellido_materno , 
		D.folio as usuario_kobra,
		D.email, 
		B.fec_registro
from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.visitas AS A
	INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.productos AS P ON A.id_producto = P.id_producto AND P.id_producto = 133  
	--LEFT JOIN Coordenadas_DeclaraFacil as CD on A.folio = CD.Folio
    INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes AS B ON A.id_solicitante = B.id_solicitante
    INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes_domicilios AS C ON A.id_solicitante = C.id_solicitante
    INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes AS D ON A.id_agente = D.id_agente
	WHERE D.id_agente not in (6282, 7237, 9895)


select top 100 * from visitas

select top 100 * from Preguntas_Kobra where Folio='151A9174V6880'

SELECT folio, count(*) FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitudes
group by folio
having count(*)>1

 SELECT 
        A.folio, A.id_solicitante, A.lat_inicio, A.lng_inicio, A.lat_fin, A.lng_fin, 
        B.nombre, B.primer_apellido, B.segundo_apellido, B.fec_nacimiento, B.tel_cel, B.email, B.curp, B.rfc, 
        C.calle, C.num_int, C.num_ext, C.colonia, C.lat, C.lng, C.codigo_postal, C.estado, C.municipio, 
        D.nombre, D.apellido_paterno, D.apellido_materno, D.email, B.fec_registro
    FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitudes AS A
    INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes AS B ON A.id_solicitante = B.id_solicitante
    INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes_domicilios AS C ON A.id_solicitante = C.id_solicitante
    INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes AS D ON A.id_agente = D.id_agente
	WHERE D.nombre like '%MONTSERRAT%'
	GROUP BY A.folio, A.id_solicitante, A.lat_inicio, A.lng_inicio, A.lat_fin, A.lng_fin, 
        B.nombre, B.primer_apellido, B.segundo_apellido, B.fec_nacimiento, B.tel_cel, B.email, B.curp, B.rfc, 
        C.calle, C.num_int, C.num_ext, C.colonia, C.lat, C.lng, C.codigo_postal, C.estado, C.municipio, 
        D.nombre, D.apellido_paterno, D.apellido_materno, D.email,B.fec_registro
	--order by B.fec_registro desc

		

Select * from Informacion_Federal.dbo.CORREOS WHERE correo_electronico like '%juanmanueldelgado%'

select * from 

SELECT TOP 10 * FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes WHERE email like '%juan%'

6282, 7237, 9895
SELECT TOP 100 * FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes WHERE folio = 31014 order by fec_registro desc

SELECT TOP 10 *FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes where nombre like '%LAURA PATRICIA%'

SELECT  * FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes 

select * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitudes where checklist like '%467b06fe99aab75143fe085e442fd611ee6f84e3.jpeg%' order by fec_registro desc

ALTER TABLE [dbo].[CheckList_DeclaraFacil]
ADD Origen NVARCHAR(50) NULL;

select * from [CheckList_DeclaraFacil] Where Folio = '151S1231'

select * from DeclaraFacil_Visistas where rfc in ('RANY900619UB4', 'HEHC79102921A','HEHM880930SR0', 'SARM91040100A', 'LEHR930830LA7')


select * from DeclaraFacil_Visistas where id_usuario_kobra= '31136'


select
	id_usuario_kobra ,
	CASE 
		WHEN ape_materno_consultor is null then concat(nombre_agente, ' ', ape_paterno_consultor) else concat(nombre_agente, ' ', ape_paterno_consultor, ' ', ape_materno_consultor ) 
	END AS nombre_agente, 
	email_agente,
	upper(municipio)as municipio,
	CAST(fecha_registro AS DATE) as fecha_registro
	from DeclaraFacil_Visistas
	group by 
	id_usuario_kobra ,
	CASE 
		WHEN ape_materno_consultor is null then concat(nombre_agente, ' ', ape_paterno_consultor) else concat(nombre_agente, ' ', ape_paterno_consultor, ' ', ape_materno_consultor ) 
	END,
	email_agente,
	upper(municipio),
	CAST(fecha_registro AS DATE)
	ORDER BY fecha_registro desc

select top 100 * from DeclaraFacil_Visistas order by fecha_registro desc

select * from Direcciones_Verificadas

CREATE TABLE Direcciones_Verificadas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    rfc NVARCHAR(13) NOT NULL,
    contribuyente NVARCHAR(255) NULL,
    calle NVARCHAR(255) NULL,
    num_int NVARCHAR(50) NULL,
    num_ext NVARCHAR(50) NULL,
    colonia NVARCHAR(255) NULL,
    codigo_postal NVARCHAR(10) NULL,
    municipio NVARCHAR(255) NULL,
    estado NVARCHAR(255) NULL,
    latitud DECIMAL(10, 6) NOT NULL,
    longitud DECIMAL(10, 6) NOT NULL,
    url_maps NVARCHAR(500) NULL,
    fecha_registro DATETIME DEFAULT GETDATE()
);


CREATE TABLE DeclaraFacil_Visistas (
    folio NVARCHAR(255),
    id_solicitante FLOAT,
    lat_inicio DECIMAL(18,10),
    lng_inicio DECIMAL(18,10),
    lat_fin DECIMAL(18,10),
    lng_fin DECIMAL(18,10),
    nombre NVARCHAR(255),
    primer_apellido NVARCHAR(255),
    segundo_apellido NVARCHAR(255),
    fec_nacimiento DATETIME,
    tel_cel NVARCHAR(255),
    email NVARCHAR(255),
    curp NVARCHAR(255),
    rfc NVARCHAR(255),
    calle NVARCHAR(255),
    num_int NVARCHAR(50),
    num_ext NVARCHAR(50),
    colonia NVARCHAR(255),
    lat_dir DECIMAL(18,10),
    lng_dir DECIMAL(18,10),
    codigo_postal NVARCHAR(50),
    estado NVARCHAR(255),
    municipio NVARCHAR(255),
    nombre_agente NVARCHAR(255),
    ape_paterno_consultor NVARCHAR(255),
    ape_materno_consultor NVARCHAR(255),
	id_usuario_kobra NVARCHAR(50),
    email_agente NVARCHAR(255),
	fecha_registro DATETIME
);


CREATE TABLE CheckList_DeclaraFacil (
    id_checklist INT IDENTITY(1,1) PRIMARY KEY,
	Created DATETIME DEFAULT GETDATE(),
    Folio NVARCHAR(100) NOT NULL,
    Pregunta NVARCHAR(MAX) NOT NULL,
    Respuesta NVARCHAR(MAX) NULL,
	Fecha_Registro Datetime
);

--DROP TABLE DeclaraFacil_Visistas

kobra-files/fotos-checklist/2025/4/b2cca023f2317e5b354a31972e154a66e2046a58.jpeg
SELECT folio, COUNT(*) FROM DeclaraFacil_Visistas
GROUP BY FOLIO
HAVING COUNT(*)>1

SELECT folio, COUNT(*) FROM CheckList_DeclaraFacil
GROUP BY FOLIO
HAVING COUNT(*)=7

Select * from [dbo].[Coordenadas]

select top 100* from Informacion_Estatal.dbo.CODIGOS_POSTALES

select * from CheckList_DeclaraFacil

select  top 100 A.Folio, TRIM(c.rfc) as rfc, TRIM(a.Pregunta) as Pregunta, TRIM(a.Respuesta) as Respuesta ,a.Fecha_Registro from CheckList_DeclaraFacil as a
left join [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitudes  as b on trim(a.Folio)= trim(b.folio) 
left join [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes as c on b.id_solicitante= c.id_solicitante
where trim(c.rfc) in
(
'MEPJ03121100A'
)

select * from visitas

select * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitudes order by fec_registro desc

select * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes where rfc = 'MEPJ03121100A'

select * from 
order by A.Fecha_Registro

select * from coordenadas


CREATE TABLE [dbo].[Coordenadas_DeclaraFacil] (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Folio NVARCHAR(100) NOT NULL,
    Latitud DECIMAL(18,10) NULL,
    Longitud DECIMAL(18,10) NULL,
    Fecha_Registro DATETIME NOT NULL
);

EXEC [dbo].[INSERTA_CHECKLIST_DECLARAFACIL]

select * from [Coordenadas_DeclaraFacil]

select * from vw_Comprobantes_Nomina where Emisor_Rfc = 'EIOM450118M6A' order by ComprobanteId desc

--delete CheckList_DeclaraFacil WHERE id_checklist >= 23740


alter table [DeclaraFacil_Visistas]
add origen varchar (20) NULL



Select top 100 * from [DeclaraFacil_Visistas]

select *from CheckList_DeclaraFacil order by id_checklist 

select distinct Respuesta from CheckList_DeclaraFacil where Pregunta= 'Confirmar rango de ingresos del Contribuyente' 

--kobra-files/fotos-checklist/2025/10/ddf50fbe-58c8-4c09-921c-73a811914216.jpg
--23,966
--1,167
[dbo].[DeclaraFacil_Visistas]


select * from [DeclaraFacil_Visistas] order by fecha_registro desc
--1,197

update [DeclaraFacil_Visistas]
set municipio = 'San Miguel de Allende' where municipio = 'SAN MIGUEL DE ALLENDE'


select * from [DeclaraFacil_Visistas] 
where municipio = 'SAN MIGUEL DE ALLENDE'



select * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.visitas where folio='151A9769V227'

select * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.visitas order by fec_finalizada desc

select top 100 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes_domicilios

select top 100 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitudes order by fec_registro desc where folio = '151S416'

select top 100 * from [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes where folio = 29754

151S331
select distinct folio from [dbo].[DeclaraFacil_Visistas] order by fecha_registro desc

ALTER FUNCTION dbo.fn_NormalizaMunicipio (@municipio NVARCHAR(100))
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @mun NVARCHAR(100);

    SET @mun = UPPER(LTRIM(RTRIM(@municipio)));

    RETURN
        CASE
            WHEN @mun = 'ABASOLO' THEN 'Abasolo'
            WHEN @mun = 'ACAMBARO' THEN 'Acámbaro'
            WHEN @mun = 'APASEO EL ALTO' THEN 'Apaseo el Alto'
            WHEN @mun = 'APASEO EL GRANDE' THEN 'Apaseo el Grande'
            WHEN @mun = 'ATARJEA' THEN 'Atarjea'
            WHEN @mun = 'CELAYA' THEN 'Celaya'
            WHEN @mun = 'MANUEL DOBLADO' THEN 'Manuel Doblado'
            WHEN @mun = 'COMONFORT' THEN 'Comonfort'
            WHEN @mun = 'CORONEO' THEN 'Coroneo'
            WHEN @mun = 'CORTAZAR' THEN 'Cortazar'
            WHEN @mun IN ('CUERAMARO', 'CUERÁMARO') THEN 'Cuerámaro'
            WHEN @mun = 'DOCTOR MORA' THEN 'Doctor Mora'
            WHEN @mun LIKE 'DOLORES HIDALGO%' THEN 'Dolores Hidalgo Cuna de la Independencia Nacional'
            WHEN @mun = 'GUANAJUATO' THEN 'Guanajuato'
            WHEN @mun = 'HUANIMARO' THEN 'Huanímaro'
            WHEN @mun = 'IRAPUATO' THEN 'Irapuato'
            WHEN @mun = 'JARAL DEL PROGRESO' THEN 'Jaral del Progreso'
            WHEN @mun = 'JERECUARO' THEN 'Jerécuaro'
            WHEN @mun = 'LEON' THEN 'León'
            WHEN @mun = 'MOROLEON' THEN 'Moroleón'
            WHEN @mun = 'OCAMPO' THEN 'Ocampo'
            WHEN @mun = 'PENJAMO' THEN 'Pénjamo'
            WHEN @mun = 'PUEBLO NUEVO' THEN 'Pueblo Nuevo'
            WHEN @mun = 'ROMITA' THEN 'Romita'
            WHEN @mun = 'SALAMANCA' THEN 'Salamanca'
            WHEN @mun = 'SALVATIERRA' THEN 'Salvatierra'
            WHEN @mun = 'SAN DIEGO DE LA UNION' THEN 'San Diego de la Unión'
            WHEN @mun = 'SAN FELIPE' THEN 'San Felipe'
            WHEN @mun = 'SAN FRANCISCO DEL RINCON' THEN 'San Francisco del Rincón'
            WHEN @mun = 'SAN JOSE ITURBIDE' THEN 'San José Iturbide'
            WHEN @mun = 'SILAO DE LA VICTORIA' THEN 'Silao de la Victoria'
			WHEN @mun = 'SAN LUIS DE LA PAZ' THEN 'San Luis de la Paz'
            WHEN @mun = 'VALLE DE SANTIAGO' THEN 'Valle de Santiago'
            WHEN @mun = 'YURIRIA' THEN 'Yuriria'
            ELSE @municipio
        END;
END;
GO




CREATE FUNCTION dbo.fn_FechaDesdeRFC (@rfc NVARCHAR(13))
RETURNS DATE
AS
BEGIN
    DECLARE @fecha DATE;

    -- RFC de persona física (13 caracteres)
    IF LEN(@rfc) = 13 AND ISNUMERIC(SUBSTRING(@rfc, 5, 6)) = 1
    BEGIN
        SET @fecha = TRY_CONVERT(DATE,
            CASE 
                WHEN CAST(SUBSTRING(@rfc, 5, 2) AS INT) >= 
                     CAST(RIGHT(CAST(YEAR(GETDATE()) + 1 AS CHAR(4)), 2) AS INT)
                    THEN '19'
                ELSE '20'
            END +
            SUBSTRING(@rfc, 5, 2) + '-' +
            SUBSTRING(@rfc, 7, 2) + '-' +
            SUBSTRING(@rfc, 9, 2)
        );
    END
    -- RFC de persona moral (12 caracteres)
    ELSE IF LEN(@rfc) = 12 AND ISNUMERIC(SUBSTRING(@rfc, 4, 6)) = 1
    BEGIN
        SET @fecha = TRY_CONVERT(DATE,
            CASE 
                WHEN CAST(SUBSTRING(@rfc, 4, 2) AS INT) >= 
                     CAST(RIGHT(CAST(YEAR(GETDATE()) + 1 AS CHAR(4)), 2) AS INT)
                    THEN '19'
                ELSE '20'
            END +
            SUBSTRING(@rfc, 4, 2) + '-' +
            SUBSTRING(@rfc, 6, 2) + '-' +
            SUBSTRING(@rfc, 8, 2)
        );
    END
    ELSE
    BEGIN
        SET @fecha = NULL;
    END;

    RETURN @fecha;
END;
GO








[dbo].[DeclaraFacil_Visistas]
SELECT 
                a.calle,
                a.num_int,
                a.num_ext,
                a.colonia,
                a.lat_dir,
                a.lng_dir,
                a.codigo_postal,
                11 as estado,
        		a.municipio ,
                a.rfc,
                a.curp,
                CASE 
        			WHEN CAST(p.[Fecha de la Firma del Acuerdo] AS DATE) IS NULL THEN CAST(a.fecha_registro AS DATE) 
        			ELSE CAST(p.[Fecha de la Firma del Acuerdo] AS DATE) 
        		END AS fecha_inicio_operaciones,
        		a.Fecha_Registro,
                a.nombre, 
                a.primer_apellido, 
                a.segundo_apellido, 
                a.tel_cel,
                CASE 
        			WHEN TRIM(p.[Confirmar correo electrónico]) = '' OR TRIM(p.[Confirmar correo electrónico]) IS NULL THEN a.email
        			ELSE TRIM(p.[Confirmar correo electrónico])
        		END AS email, 
                CASE 
        			WHEN p.[Contraseña (CIP)] IS NULL THEN '12345678' 
        			ELSE p.[Contraseña (CIP)] 
        		END AS contraseña_cip,
                'PENDIENTE' AS estatus,  
                CASE 
        			WHEN p.[Confirmar Contraseña (CIP)] IS NULL THEN '12345678' 
        			ELSE p.[Confirmar Contraseña (CIP)]
        		END AS contraseña_cip,
                'Cargado automaticamente desde sistema' + '===>'+ [Comentarios] as observaciones,
                trim(CONCAT(a.nombre_agente,' ',a.ape_paterno_consultor, ' ', a.ape_materno_consultor))as capturista_id,
                a.id_usuario_kobra,
                CASE WHEN CAST(p.[¿La georreferenciación corresponde al domicilio del contribuyente?] AS BIT) IS NULL THEN 1 ELSE CAST(p.[¿La georreferenciación corresponde al domicilio del contribuyente?] AS BIT) END as geo,
                CASE 
                    WHEN p.[Rango de ingresos del Contribuyente] IS NULL THEN 'Hasta $100,000.00' 
                    WHEN p.[Rango de ingresos del Contribuyente] = 'Hasta $10,000' then 'Hasta $10,000.00'
                    WHEN p.[Rango de ingresos del Contribuyente] = 'Hasta $5,000' THEN 'Hasta $5,000.00'
                    WHEN p.[Rango de ingresos del Contribuyente] = 'Hasta $35,000' THEN 'Hasta $35,000.00'
                    WHEN p.[Rango de ingresos del Contribuyente] = 'Hasta $25,000' THEN 'Hasta $25,000.00'
                    WHEN p.[Rango de ingresos del Contribuyente] = 'Hasta $15,000' THEN 'Hasta $15,000.00'
                    WHEN p.[Rango de ingresos del Contribuyente] = 'Hasta $65,000' THEN 'Hasta $65,000.00'
                    ELSE p.[Rango de ingresos del Contribuyente] 
                END AS ingreso_id,
                trim(p.[Adjuntar fotografía del anverso de la identificación]) as foto_anverso,
                trim(p.[Adjuntar fotografía del reverso de la identificación]) as foto_reverso,
         		trim(p.[Fotografía del Contribuyente (rostro)]) as foto_rostro,
         		trim(p.[Fotografía del Acuerdo de Inscripción a Declara Fácil - Hoja 1]) as hoja_1,
                trim(p.[Fotografía del Acuerdo de Inscripción a Declara Fácil - Hoja 2]) as hoja_2,
                trim(p.[Fotografía del Acuerdo de Inscripción a Declara Fácil - Hoja 3]) as hoja_3
            FROM DeclaraFacil_Visistas AS a
            LEFT JOIN (
                SELECT * FROM (
                    SELECT 
                        Folio,
                        Pregunta,
                        Respuesta
                    FROM CheckList_DeclaraFacil) AS SourceTable
            PIVOT (
                MAX(Respuesta)
                FOR Pregunta IN (
                    [¿La georreferenciación corresponde al domicilio del contribuyente?],
                    [Contraseña (CIP)],
                    [Confirmar Contraseña (CIP)],
        			[Confirmar correo electrónico],
                    [Adjuntar fotografía del anverso de la identificación],
                    [Adjuntar fotografía del reverso de la identificación],
                    [Fecha de la Firma del Acuerdo],
                    [Fotografía del Contribuyente (rostro)],
                    [Comentarios],
                	[Rango de ingresos del Contribuyente],
                    [Confirmar rango de ingresos del Contribuyente],
                    [Fotografía del Acuerdo de Inscripción a Declara Fácil - Hoja 1],
                    [Fotografía del Acuerdo de Inscripción a Declara Fácil - Hoja 2],
                    [Fotografía del Acuerdo de Inscripción a Declara Fácil - Hoja 3]
                )
            ) AS PivotTable) AS p ON trim(a.Folio) = trim(p.Folio) where CAST(a.Fecha_Registro AS DATE) >= ? order by rfc

select * from  CheckList_DeclaraFacil where Folio = '151S885'

SELECT * FROM  DeclaraFacil_Visistas 
where rfc in 
(
'BAAA700216B20',
'BAMY920516',
'CICA790624VD1',
'COVC730213TC6',
'CUGS89061500A',
'FERD670707OOA',
'FOGJ860819UU9',
'FOPS010816GZ0',
'GACI680718448',
'GAJD68040300A',
'GOCC76112100A',
'GORB821116637',
'GOTE91071400A',
'GUFP000614123',
'HEAS720910EA9',
'IATA98123100A',
'LILM930523183',
'LOCJ9912133K0',
'MARL790812UPO',
'MEPJ03121100A',
'NATA25072000A',
'NSDI22103000A',
'PALD970624CR7',
'PIQ790125797',
'RALR01090900A',
'ROMJ820901CJ8',
'ROVP800614RW3',
'SERJ740720FM0',
'SERL830330QL1',
'SINO30062600A',
'TODA991026TR1',
'VABS610514CO5',
'VAES770117998'
)
order by fecha_registro desc

select * from DeclaraFacil_Visistas order by fecha_registro desc



delete Conceptos
DBCC CHECKIDENT ('Egresos', RESEED, 0);


delete CheckList_DeclaraFacil

DBCC CHECKIDENT ('CheckList_DeclaraFacil', RESEED, 0);

EXECUTE [INSERTA_CHECKLIST_DECLARAFACIL]

EXECUTE [INSERTA_DECLARAFACIL_VISITAS]

select distinct Folio from CheckList_DeclaraFacil order by folio

select * from Coordenadas_DeclaraFacil order by folio

SELECT * FROM Recaudacion.dbo.BLOQUEOS_SATEG order by rec, FECHA_ULTIMO_MOVIMIENTO

728,877

select * from CheckList_DeclaraFacil order by Folio


SELECT A.folio, A.checklist  
	FROM [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitudes AS A
	INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes AS B ON A.id_solicitante=B.id_solicitante
	INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.solicitantes_domicilios AS C ON A.id_solicitante = C.id_solicitante
	INNER JOIN [172.31.113.31\DIDS_PROD1].KobraRemoto.dbo.agentes AS D ON A.id_agente = D.id_agente
	ORDER BY A.FOLIO DESC
	kobra-files/fotos-checklist/2025/5/b6a7af5e86235680dcd733be240c425579afede1.jpeg

	SELECT *FROM VISITAS_KOBRA.dbo.DeclaraFacil_Visistas

-- --------------------------------------------------------------------------------------
--											VEHICULAR
-- --------------------------------------------------------------------------------------

SELECT top 1* FROM VEHICULAR WHERE rfc = '' or curp=''



select DISTINCT agrupador  from catalogo_vehicular

select * from catalogo_vehicular where agrupador='CLASE'

is= USO = 36 PARTICULAR

ES_HIBRIDO O ELECTRICO = TIPO = 012

DISCAPACITADO = USO = 79

SELECT TOP 100 * FROM Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR WHERE RFC LIKE '%PARR590607S81%' and Fecha>='20250527' ORDER BY Fecha Desc

select top 100 * from Vehicular_Hana where REV = '' ORDER BY RFC_10 DESC, RFC desc

select top 100 * from Vehicular_Hana where Objeto_Contrato like '%4000323476%'
UPDATE Personas_
select Objeto_Contrato, count(*) from Vehicular_Hana
WHERE Fecha_Alta between '20240101' and '20240131'
group by Objeto_Contrato
having Objeto_Contrato > 1 

select top 100 * from PAGOS_REGISTRADOS_PARA_DEPURAR

select fecha, ejercicio, periodo, cumplimiento, tipo, denominacion,count(*) from Recaudacion_Vehicular
group by fecha, ejercicio, periodo, cumplimiento, tipo, denominacion
having count(*)>1

Select * from Recaudacion.dbo.Recaudacion_Vehicular WHERE denominacion = 'REFRENDO PLACAS'  and fecha between '20260101' and '20260220' 
order by Fecha desc

Select SUM(recaudado) from Recaudacion.dbo.Recaudacion_Vehicular where denominacion='MINISTRACION PLACAS' and fecha >= '20260101' order by Fecha desc
10,363,331.29
13,303,820.00

96,481,598.25
Select sum(recaudado) from Informacion_Estatal.dbo.Recaudacion_Vehicular_Temp where denominacion='REFRENDO PLACAS' and fecha >= '20260101'
99,845,254.47

114,497,191.73
Select sum(recaudado) from Recaudacion.dbo.Recaudacion_Vehicular where fecha between '20250101' and '20251231' and  denominacion='MULTAS'


115,490,503.74
---803,977,737.84
--1,013,450,599.11
--726,841,795.76
1,190,658,758.55
---1,247,480,030.88
select top 1000 * from Recaudacion_Vehicular order by fecha desc


--48,692
--48,861

select count(*) from Informacion_Estatal.dbo.Recaudacion_Vehicular_Temp

DELETE FROM Recaudacion.dbo.Recaudacion_Vehicular WHERE Fecha >= '20250801'


--51,452
--61,167

CREATE TABLE Recaudacion_Vehicular(
    fecha DATE,
    ejercicio INT,
    periodo INT,
    cumplimiento DECIMAL(10,2),
    tipo VARCHAR(50),
    recaudado DECIMAL(18,2),
    num_pagos INT,
    contribuyentes_por_dia INT,
    contribuyentes_2 INT
);


CREATE TABLE dbo.Resumen_Recaudacion_Vehicular (
    Fecha_Corte              DATETIME        NOT NULL,

    -- Refrendo - Vehículos
    Vehiculos_Total          INT             NOT NULL,
    Vehiculos_2026           INT             NOT NULL,
    Vehiculos_Rezago         INT             NOT NULL,

    -- Refrendo - Pagos
    Pagos_Total              INT             NOT NULL,
    Pagos_2026               INT             NOT NULL,
    Pagos_Rezago             INT             NOT NULL,

    -- Refrendo - Recaudación
    Recaudado_Total          DECIMAL(18,2)    NOT NULL,
    Recaudado_2026           DECIMAL(18,2)    NOT NULL,
    Recaudado_Rezago         DECIMAL(18,2)    NOT NULL,

    -- Multas
    Vehiculos_Multas         INT             NOT NULL,
    Pagos_Multas             INT             NOT NULL,
    Recaudado_Multas         DECIMAL(18,2)    NOT NULL,

    CONSTRAINT PK_Resumen_Recaudacion_Vehicular
        PRIMARY KEY (Fecha_Corte)
);

select * from Resumen_Recaudacion_Vehicular

ALTER TABLE Recaudacion_Vehicular ALTER COLUMN cumplimiento INT

Alter Table Recaudacion_Vehicular_Temp
add denominacion varchar (50)

update Recaudacion_Vehicular
set denominacion = 'REFRENDO PLACAS'

CREATE TABLE Recaudacion_Vehicular_Temp(
    fecha DATE,
    ejercicio INT,
    periodo INT,
    cumplimiento DECIMAL(10,2),
    tipo VARCHAR(100),
    recaudado DECIMAL(18,2),
    num_pagos INT,
    contribuyentes_por_dia INT,
    contribuyentes_2 INT
);


CREATE TABLE Creditos_Multas (
concepto varchar (250),
unidades_min int,
unidades_max int,
tipo varchar (30)
)

drop table Creditos_Multas

INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Cuando no se devuelvan las placas metálicas y tarjeta de circulación: Por la presentación extemporánea del aviso de alta, baja o modificación', 1, 2,'VEHICULOS');
INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Cuando no se devuelvan las placas metálicas y tarjeta de circulación: Por falta de una placa',6 ,7 ,'VEHICULOS');
INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Cuando no se devuelvan las placas metálicas y tarjeta de circulación: Por falta de dos placas',12 ,13 ,'VEHICULOS');
INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Cuando no se devuelvan las placas metálicas y tarjeta de circulación: Por falta de tarjeta de circulación',1 ,2 ,'VEHICULOS');
INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Por trámite extemporáneo de canje:Vehículos de motor distintos a motocicletas, bicimotos y vehículos similares',17 ,24 ,'VEHIUCLOS');
INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Cuando no se devuelvan las placas metálicas y tarjeta de circulación: Por falta de tarjeta de circulación',1 ,2 ,'MOTOCICLETAS');
INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Cuando no se devuelvan las placas metálicas y tarjeta de circulación: Por falta de placa de motocicleta, bicimotos y vehículos similares', 3 , 4,'MOTOCICLETAS');
INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Por trámite extemporáneo de canje: Motocicletas, bicimotos y vehículos similares',4 ,6 ,'MOTOCICLETAS');

INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Multa de alto contenido alcohólico',100 199 ,'A1');
INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Multa de alto contenido alcohólico',100 199 ,'A2');

INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Multa de bajo contenido alcohólico',20 99 ,'B1');
INSERT INTO Creditos_Multas (concepto, unidades_min, unidades_max, tipo) VALUES ('Multa de bajo contenido alcohólico',20 99 ,'B2');



select * from Creditos_Multas
SELECT * FROM Recaudacion_Vehicular_Temp where fecha = '20231006'

select top 10 * from Recaudacion.dbo.Recaudacion_Vehicular order by fecha desc

select * from Ejecucion.[dbo].[creditos_cartera_ui]

alter table creditos_cartera_ui
add estatus_emision varchar(50)

select top 100 * from VEHICULAR

select top 100* from Vehicular_Hana 

--3,616,129

--3,616,598


select * from Vehicular_Hana where modelo in ('1995') and Nombre_Razon_Social like '%%'


select TOP 100 * from Recaudacion.dbo.DIRECCIONES

SELECT * FROM Recaudacion.dbo.DIRECCIONES_SATEG 

select 
COUNT(DISTINCT Obligacion) as num_vehiculos , SUM(Importe) as importe_vehiculos 
from (
select 
	P.Obligacion,
	P.Parter,
	P.Clave_Subclave,
	DV.OBJETO_CONTRATO,
	MAX(DV.PERIODO) AS PERIODO,
	SUM(P.Importe) AS Importe
from PAGOS_REGISTRADOS_PARA_DEPURAR as P
INNER JOIN 
	(SELECT OBJETO_CONTRATO, MAX(PERIODO)AS PERIODO FROM Decreto_Vehicular GROUP BY OBJETO_CONTRATO) AS DV ON CAST(tRIM(P.Obligacion) AS BIGINT) = CAST(TRIM(DV.OBJETO_CONTRATO) AS BIGINT)
WHERE P.Fecha >= '20250908' and P.Fecha <= '20251231' 
GROUP BY P.Obligacion,
	P.Parter,
	P.Clave_Subclave,
	DV.OBJETO_CONTRATO) AS Z



select count(*) as total_periodos , count(distinct(rfc)) as num_contribuyentes, sum(Importe) as importe_impuestos
from
(    select Ejercicio , Periodo , rfc , sum(importe) as Importe from
(
    select trim(A.rfc) as rfc,A.ejercicio,A.periodo,A.fecha,A.importe,A.Clave_Subclave as cve_subcve,B.NOMBRE_COMPLETO as nombre from
        (
            select * from PAGOS_REGISTRADOS_PARA_DEPURAR where fecha >= '20250908' and Fecha <= '20251231' and ejercicio < 2025 and SUBSTRING(Clave_Subclave,1,4) in('1001', '1002', '1004', '1005', '1006', '1007', '1010', '1012') and importe>0
            union all
            select * from PAGOS_REGISTRADOS_PARA_DEPURAR where fecha >= '20250908' and Fecha <= '20251231' and ejercicio = 2025 and periodo <= 6 and SUBSTRING(Clave_Subclave,1,4) in('1001', '1002', '1004', '1005', '1006', '1007', '1010', '1012') and importe>0
        ) as A
        left join Recaudacion.dbo.Personas_ as B on (trim(A.rfc) = trim(B.rfc))
) as z group by Ejercicio , Periodo , rfc) as X

-- --------------------------------------------------------------------------------------
--											RPP Y CATASTRO
-- --------------------------------------------------------------------------------------

select top 100 CONCAT(nombre,' ',apellido_paterno,' ', apellido_materno) as nombre_completo, 
CONCAT(colonia, ' ', calle, ' ', 'EXT:', numero_exterior, '/' ,'INT:', numero_interior,' ', 'CP:',cp) as domicilio,
CONCAT(nombre_fedatario, ' ', ap_paterno_fedatario, ' ', ap_materno_fedatario) as nombre_fedatario,
CONCAT (col_inmueble, ' ', calle_inmueble, ' ', 'EXT:', num_ext_inmueble, ' INT:', num_int_inmueble, ' CP:', cp_inmueble)as direccion_inmueble
from RPP
order by domicilio

select top 1000* from rpp where rfc like '%MAGL631226%'

select count(*) from Catastro_Sat
---16,376,784

select top 100 * from rpp order by rfc desc
---539,209

select * from tasas_recargos order by anio

EXEC SELECT_CATASTRO 'CATASTRO','*', 'ZVGJN730926';

EXEC SELECT_CATASTRO 'RPP', '*', 'MORM790821122';

SELECT TOP 100 * FROM Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR where rfc= 'CARJ880225DE4' ORDER BY Fecha desc


EXEC SELECT_PAGOS_PROG

select * from ResultadosCuentas rc where rc.FechaRegistro >= '20251027' order by id desc;


select TOP 100 * from Catastro_Sat ORDER BY  rfc desc

select top 1000 CAST(clave_catastral AS DECIMAL(38,10))AS CLAVE  from Catastro_Sat

DECLARE @numero_varchar VARCHAR(50) = '1.1004035040026E+30';

-- Verificar si es numérico antes de convertir
IF ISNUMERIC(@numero_varchar) = 1
BEGIN
    SELECT CAST(@numero_varchar AS FLOAT) AS NumeroConvertido;
END
ELSE
BEGIN
    SELECT 'El valor no es numérico' AS Error;
END





31.5.
select  distinct RFC_RETENEDOR from [dbo].[PAGOS_PLATAFORMAS]


select top 100 * from Recaudacion_Vehicular_Temp order by fecha desc

select top 100 * from Catastro_Sat

select * from INPC_TEMP order by Ejercicio desc

select * from [dbo].[inpc] order by Ejercicio desc, Periodo desc

CREATE TABLE catastro_temp (
rfc varchar (50),
curp varchar (50),
tipo_persona varchar (80),
razon_social varchar (150),
nombre varchar(100),
apellido_p varchar (70),
apellido_m varchar(70),
nombre_completo varchar (260),
calle_inmueble varchar (80),
num_ext_inmueble varchar (60),
num_int_inmueble varchar(40),
colonia_inmueble varchar(80),
localidad_inmueble varchar (80),
entidad_inmueble varchar (80),
municipio_inmueble varchar(80),
cp_inmueble varchar(15),
domicilio_inmueble varchar(280),
telefono varchar (40),
correo_electronico varchar(80),
ejercicio varchar (10),
uso_suelo varchar(280),
tipo_predio varchar (280),
monto_rentas varchar (100),
superficie_terreno varchar (100),
valor_terreno varchar (100),
superficie_construccion varchar(100),
valor_construccion varchar (100),
fecha_ultimo_mov varchar (50),
tipo_movimiento varchar (280),
impuesto varchar (100),
clave_catastral varchar (80),
valor_catastral varchar (100)
)





SELECT COUNT(*) FROM(
SELECT
A.rfc,
A.curp,
A.tipo_persona,
A.razon_social,
A.nombre,
A.apellido_p,
A.apellido_m,
A.nombre_completo,
A.calle_inmueble,
A.num_ext_inmueble,
A.num_int_inmueble,
A.colonia_inmueble,
A.localidad_inmueble,
A.entidad_inmueble,
A.municipio_inmueble,
A.cp_inmueble,
A.domicilio_inmueble,
A.telefono,
A.correo_electronico,
A.ejercicio,
A.uso_suelo,
A.tipo_predio,
A.monto_rentas,
A.superficie_terreno,
A.valor_terreno,
A.superficie_construccion,
A.valor_construccion,
A.fecha_ultimo_mov,
A.tipo_movimiento,
A.impuesto,
A.clave_catastral,
A.valor_catastral
FROM (
    SELECT top 100 *,
           ROW_NUMBER() OVER (PARTITION BY CONCAT(TRIM(clave_catastral), '-', TRIM(valor_catastral), '-', TRIM(nombre_completo), '-', TRIM(impuesto), '-', TRIM(fecha_ultimo_mov)) ORDER BY rfc) AS rn
    FROM Recaudacion.dbo.Catastro_Sat
) AS A
WHERE rn = 1) AS C;

--delete catastro_temp

select count(*) from catastro_temp

select top 5000 * from Recaudacion.dbo.Catastro_Sat

select count(*) from Recaudacion.dbo.Catastro_Sat
--4,980,776
--9,207,687
--15,628,872
--16,376,784


select top 5000* from cfdi order by fecha desc

select top 5000 * from cfdi_detalle




-- --------------------------------------------------------------------------------------
--											EJECUCIÓN
-- --------------------------------------------------------------------------------------
--5,843,614
--5,843,650
--5,843,650

Select count(*) from PAGOS_EJECUCION 

select top 1000 * from PAGOS_EJECUCION where Clave_Subclave = '6011-1011' 

select * from 

SELECT clave_subclave, count(*) 
from CLAVES_SUBCLAVES
group by clave_subclave
having count(*) >1

4034-3002
8005-3225


delete CLAVES_SUBCLAVES where clave_subclave = '4034-3002'
--32,534,511
select TOP 100* from Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR WHERE RFC LIKE '%CRI150312RR9%' and fecha >= '20250404'


INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('');

INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4034-3002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8005-3225');

INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8007-3201');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8007-3202');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3201');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3202');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3203');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3204');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3205');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3206');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8012-2001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8012-5001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('1008-4002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('1008-4502');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1009');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4009');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4509');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1018');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4018');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4518');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4507');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1008');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4008');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4508');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1010');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4010');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4510');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1011');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4011');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4511');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1012');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4012');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4512');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1013');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4013');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4513');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4017');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4517');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1021');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4021');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4521');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1020');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4020');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4520');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4501');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4503');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1004');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4004');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4504');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1005');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4005');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4505');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1006');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4006');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4506');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('P006-4001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('P006-4501');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6006-1001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4502');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4034-4001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4034-4501');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4034-1002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4034-4002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4034-4502');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4515');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4016');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4516');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1014');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4014');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4514');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-1019');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4019');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6011-4519');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3101');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3102');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3103');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3104');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3105');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-3106');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8007-1001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8007-1002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-1001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-1002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-1003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-1004');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-1005');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('8010-1006');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4004-4001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4004-4501');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4004-4002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4004-4502');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('5013-0002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6006-4004');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6006-4504');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('P003-0002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6006-1002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6006-2002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6006-4002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6006-4502');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('P003-0001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6006-1003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6006-2003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6006-4003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6006-4503');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4005-3003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4005-4001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4005-4002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4005-4003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4005-4501');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4005-4502');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4005-4503');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4005-4504');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3004');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3007');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3008');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3009');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3011');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3012');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3014');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3015');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3016');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3017');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3018');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3019');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3020');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3021');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3022');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3023');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-3024');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4004');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4007');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4008');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4009');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4011');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4012');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4014');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4015');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4016');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4017');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4018');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4019');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4020');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4021');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4022');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4023');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4024');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4501');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4502');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4503');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4504');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4505');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4506');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4507');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4508');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4509');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4510');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4511');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4512');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4513');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4514');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4515');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4516');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4517');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4518');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4519');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4520');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4521');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4522');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4523');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4006-4524');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-4002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-4003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-4501');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-4502');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-4503');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-0001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-0002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-0003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-1001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-1002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-1003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-2001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-2002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('4011-2003');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6016-4001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6016-4501');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6008-0001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6008-1001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6008-4001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6008-4501');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('P008-0002');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6017-4001');
INSERT INTO CLAVES_SUBCLAVES (clave_subclave) VALUES ('6017-4501');



-- --------------------------------------------------------------------------------------
--										REGISTRO FEDERAL
-- --------------------------------------------------------------------------------------
Select top 100 *from PERSONAS_FISICAS_PF
select top 10 * from PERSONAS_FISICAS_1








-- --------------------------------------------------------------------------------------
--										BW_RECAUDACIÓN.
-- --------------------------------------------------------------------------------------

Select count(*) from [/BIC/OHZDNMA]

--Ordena y cuenta el número de declaraciones por periodo
Select PERIOD_KEY, count(*) as cuenta from [/BIC/OHZDNMA] group by PERIOD_KEY order by PERIOD_KEY 

--VERIFICAMOS QUE NO EXISTAN EN Z01 RFC menores a 12 caracteres.
SELECT * FROM 
(SELECT BU_ID_TYPE, TAXPAYER_ID, LEN(TAXPAYER_ID) AS LONGITUD FROM [/BIC/OHZDNMA] 
WHERE BU_ID_TYPE='Z01' 
GROUP BY BU_ID_TYPE, TAXPAYER_ID) AS sub where sub.LONGITUD not in (12,13)


--VERIFICAMOS QUE NO EXISTAN EN Z01 RFC menores a 12 caracteres.
SELECT * FROM 
(SELECT BU_ID_TYPE, TAXPAYER_ID, LEN(TAXPAYER_ID) AS LONGITUD FROM [/BIC/OHZDNMA] 
WHERE BU_ID_TYPE='Z03' 
GROUP BY BU_ID_TYPE, TAXPAYER_ID) AS sub where sub.LONGITUD not in (12,13)

SELECT DISTINCT A_T1_PERAA  FROM [/BIC/OHZDNMA]

SELECT * FROM [/BIC/OHZDNMA] WHERE A_T1_PERAA=' '

select count(*) from [/BIC/OHZDNMA] 
--4,219,152

SELECT COUNT(*) FROM [dbo].[/BIC/OHZDSPM]

SELECT PERIOD_KEY, COUNT(*) FROM [dbo].[/BIC/OHZDSPM] GROUP BY PERIOD_KEY ORDER BY PERIOD_KEY 


SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH, 
    IS_NULLABLE 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = '/BIC/OHZDNMA'



Select PERIOD_KEY, COUNT(*)AS CUENTA from [/BIC/OHZDNMM] GROUP BY PERIOD_KEY ORDER BY PERIOD_KEY



            SELECT base_datos, 
                    tabla, 
                    descripcion, 
                    creacion, 
                    modificacion, 
                    ultimo_registro, 
                    tipo_actualizacion, 
                    visible, 
                    responsable, 
                    gestor
            FROM actualizacion_tablas
            WHERE descripcion = '' OR tipo_actualizacion = '' OR responsable = ''

select top 100 * from Informacion_Federal.dbo.lista_CFDI

select *, year(FechaEmision) as AÑO 
from Recaudacion.dbo.listado_cfdi
WHERE RfcReceptor like '%SRI970114845%' and year(FechaEmision) = '2020'

25208178

--25,198,074
--25,198,074
--25,198,175
---25,208,174
--25,208,178
--25,208,178

select
       year(FechaEmision) as AÑO,
       FORMAT(sum(Subtotal), 'N0') as IMPORTE_CFDIS_RECIBIDOS,
       COUNT(Subtotal) as NUMERO_CFDIS_RECIBIDOS
from Recaudacion.dbo.LISTADO_CFDI
where
       RfcReceptor LIKE '%SRI970114845%'
       --AND EfectoComprobante LIKE '%INGRESO%'
       --AND EstadoComprobante = 'Vigente'
GROUP BY YEAR (FechaEmision)
ORDER BY AÑO ASC;




select * from xml_cfdi

DROP TABLE XML_CFDI 


drop table Facturas_Completas

select * from Facturas_Completas

CREATE TABLE XML_CFDI (
	UUID_relacionado NVARCHAR(50),
    folio NVARCHAR(50),
    version NVARCHAR(10),
    fecha DATETIME,
    forma_pago VARCHAR(50),
    no_certificado NVARCHAR(50),
    subtotal DECIMAL(18,2),
    descuento DECIMAL(18,2),
    moneda NVARCHAR(10),
    total DECIMAL(18,2),
    tipo_comprobante NVARCHAR(10),
    lugar_expedicion NVARCHAR(50),
    metodo_pago NVARCHAR(50),
    rfc_emisor NVARCHAR(50),
    nombre_emisor NVARCHAR(255),
    regimen_fiscal NVARCHAR(50),
    rfc_receptor NVARCHAR(50),
    nombre_receptor NVARCHAR(255),
    uso_cfdi NVARCHAR(50),
    base DECIMAL(18,2),
    impuesto NVARCHAR(50),
    tipo_factor NVARCHAR(50),
    tasa_cuota DECIMAL(18,6),
    importe_traslado DECIMAL(18,2),
    UUID_timbre NVARCHAR(50),
    fecha_timbrado DATETIME,
    rfc_prov_certif NVARCHAR(50),
    no_certificado_sat NVARCHAR(50),
    Clave_Prod_Serv NVARCHAR(50),
    Cantidad DECIMAL(18,2),
    Clave_Unidad NVARCHAR(50),
    unidad_concepto NVARCHAR(100),
    Descripcion NVARCHAR(500),
    Valor_Unitario DECIMAL(18,2),
    Importe DECIMAL(18,2),
    Descuento_Concepto DECIMAL(18,2)
);


select * from XML_CFDI




-- --------------------------------------------------------------------------------------
--											OTRAS
-- --------------------------------------------------------------------------------------

select top 100 * from Difuntos

select RFC_RETENEDOR, EJERCICIO, PERIODO
from Informacion_Estatal_Temporal.dbo.PAGOS_PLATAFORMAS 
group by RFC_RETENEDOR, EJERCICIO, PERIODO
order by EJERCICIO DESC, PERIODO DESC

select distinct(RFC_RETENEDOR) from Informacion_Estatal_Temporal.dbo.PAGOS_PLATAFORMAS where EJERCICIO = 2024

select TOP 100 *from PAGOS_PLATAFORMAS AS a
LEFT JOIN Informacion_Estatal.dbo.PADRON_TEMP_ as b on a.RFC= b.RFC
where b.FECHA_BAJA <> '00000000' and b.CREACION between '20240501' and '20240814'


CREATE TABLE #RESICO (
RFC VARCHAR (20),
CONTRIBUYENTE VARCHAR (500),
FECHA_INICIO VARCHAR (20)
);


SELECT A.RFC , FechaVisita, DATEDIFF(MONTH , ISNULL(FechaVisita, '20230224'), ISNULL(fe_baja, '20250901')) - 2 AS PERIODOS,  estatus ,fe_baja, C.PAGO, 
ISNULL(C.CANTIDAD,0) AS CANTIDAD, 
(DATEDIFF(MONTH , ISNULL(FechaVisita, '20230224'), ISNULL(fe_baja, '20250901')) - 2 )- ISNULL(C.CANTIDAD,0) AS ADEUDO
FROM Informacion_Estatal.dbo.RFC_TIANGUIS AS A
LEFT JOIN REC_OBLIGACIONES AS B ON A.RFC = B.rec  
LEFT JOIN (
    SELECT RFC , SUM(PAGO) AS PAGO, COUNT(*) AS CANTIDAD FROM
    (SELECT RFC , Ejercicio , Periodo, SUM(IMPORTE) AS PAGO  FROM Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR WHERE Clave_Subclave IN ('1002-0009','0177-0003') GROUP BY RFC , Ejercicio , Periodo) AS X GROUP BY RFC) AS C ON A.RFC =C.RFC
WHERE obligacion LIKE '%REGIMEN SIMPLIFICADO DE CONFIA%' AND 
(DATEDIFF(MONTH , ISNULL(FechaVisita, '20230224'), ISNULL(fe_baja, '20250901')) - 2 )- ISNULL(C.CANTIDAD,0) <= 10
ORDER BY ADEUDO


SELECT TOP 100 * FROM Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR WHERE RFC= 'BAAO88072100A' 
AND Clave_Subclave IN ('1002-0009','0177-0003')
ORDER BY Ejercicio desc, Periodo desc

SELECT * FROM Informacion_Estatal.dbo.RFC_TIANGUIS ORDER BY FechaVisita


Select top 1000* from Informacion_Estatal.dbo.REC_DETALLE
--718,625

select TOP 100 * from Informacion_Estatal.dbo.PADRON_TEMP_ where RFC = 'AAAJ700101DB9'
--1,118,406


select trim(A.rfc) as rfc,A.ejercicio,A.periodo,A.fecha,A.importe,A.Clave_Subclave as cve_subcve,B.NOMBRE_COMPLETO as nombre from
            (
                select * from PAGOS_REGISTRADOS_PARA_DEPURAR where fecha between '20250908' and '20251231' and ejercicio < 2025 and 
                    SUBSTRING(Clave_Subclave,1,4) in('1001', '1002', '1004', '1005', '1007', '1010', '1012') and importe>0
                union all
                select * from PAGOS_REGISTRADOS_PARA_DEPURAR where fecha between '20250908' and '20251231' and ejercicio = 2025 and 
                    SUBSTRING(Clave_Subclave,1,4) in('1001', '1002', '1004', '1005', '1007', '1010', '1012') and 
                    importe>0 and periodo <= 6
                union all
                select * from PAGOS_REGISTRADOS_PARA_DEPURAR where fecha between '20251101' and '20251231' and ejercicio = 2025 and 
                    SUBSTRING(Clave_Subclave,1,4) in('1001', '1002', '1004', '1005', '1007', '1010', '1012') and 
                    importe > 0 and periodo = 7
            ) as A
            left join Recaudacion.dbo.Personas_ as B on (trim(A.rfc) = trim(B.rfc))

SELECT count(*) FROM Recaudacion.dbo.REC
715,980

select top 1000* from Recaudacion.dbo.REC_OBLIGACIONES

select top 100* from Informacion_Estatal.dbo.REC_OBLIGACIONES

select COUNT(*) from Informacion_Estatal.dbo.REC_BP
---774,335

select TOP 100 * from Informacion_Estatal.dbo.PADRON_TEMP_ WHERE OBLIGACION LIKE '%REGIMEN SIMPLIFICADO DE CONFIA%' AND RFC = 'MAJU660124814'

SELECT TOP 100 * FROM "/BIC/OHZDRS1" WHERE TAXPAYER_ID = 'OEJX650307251'


SELECT TOP 100 * FROM "/BIC/OHZDRS2"  WHERE TAXPAYER_ID = 'HEAA690904DZ7'

select * from REC

select * from 


WITH EjerciciosPorRfc AS (
    -- Obtenemos todos los ejercicios por RFC a partir de los pagos y la tabla #RESICO
    SELECT DISTINCT r.RFC, b.Ejercicio, r.FECHA_INICIO
    FROM #RESICO r
    LEFT JOIN PAGOS_REGISTRADOS_PARA_DEPURAR b
        ON r.RFC = b.RFC
),
PeriodosEsperados AS (
    -- Genera todos los periodos 1-13 por RFC y por Ejercicio
    SELECT e.RFC, e.FECHA_INICIO, e.Ejercicio, p.Periodo
    FROM EjerciciosPorRfc e
    CROSS JOIN (VALUES 
        (1),(2),(3),(4),(5),(6),(7),
        (8),(9),(10),(11),(12),(13)
    ) p(Periodo)
),
Omisos AS (
    -- Detecta periodos sin pago posterior a FECHA_INICIO
    SELECT 
        e.RFC,
        e.Ejercicio,
        e.FECHA_INICIO,
        STRING_AGG(CAST(e.Periodo AS varchar(2)), ',') 
            WITHIN GROUP (ORDER BY e.Periodo ASC) AS Periodos_Omisos,
        COUNT(*) * 200 AS omisos_importe
    FROM PeriodosEsperados e
    LEFT JOIN PAGOS_REGISTRADOS_PARA_DEPURAR b
        ON e.RFC = b.RFC
        AND e.Ejercicio = b.Ejercicio
        AND e.Periodo = b.Periodo
        AND b.Fecha >= CONVERT(DATE, e.FECHA_INICIO)
		AND b.Clave_Subclave IN ('1002-0009', '1002-1009','1002-2009')
    WHERE b.Periodo IS NULL
    GROUP BY e.RFC, e.Ejercicio, e.FECHA_INICIO
),
Pagados AS (
    -- Suma de pagos por RFC y Ejercicio posteriores a FECHA_INICIO
    SELECT 
        r.RFC,
        b.Ejercicio,
        SUM(b.Importe) AS pagados
    FROM #RESICO r
    LEFT JOIN PAGOS_REGISTRADOS_PARA_DEPURAR b
        ON r.RFC = b.RFC
        AND b.Fecha >= CONVERT(DATE, r.FECHA_INICIO)
		AND b.Clave_Subclave IN ('1002-0009', '1002-1009','1002-2009')
    GROUP BY r.RFC, b.Ejercicio
)
SELECT 
    r.RFC,
    CONVERT(DATE, r.FECHA_INICIO) AS FECHA_INICIO_SOLO_FECHA,
    o.Ejercicio,
    ISNULL(o.Periodos_Omisos, '') AS Periodos_Omisos,
    ISNULL(o.omisos_importe, 0) AS omisos_importe,
    ISNULL(p.pagados, 0) AS pagados
FROM #RESICO r
LEFT JOIN Omisos o
    ON r.RFC = o.RFC
LEFT JOIN Pagados p
    ON r.RFC = p.RFC AND o.Ejercicio = p.Ejercicio
ORDER BY r.RFC, o.Ejercicio;












SELECT * FROM PAGOS_REGISTRADOS_PARA_DEPURAR WHERE Clave_subvlave in 
('1002-0009',
'1002-1009',
'1002-2009'
)


--689,821
Select top 10 * from Informacion_Estatal.dbo.REC_DETALLE where RfC= 'CAF140521228'

SELECT rfc, sum(Importe), Clave_Subclave FROM PAGOS_REGISTRADOS_PARA_DEPURAR WHERE rfc in
(
'AALE4201135Q5',
'ACF130424MH1 ',
'ADS221207IH7 ',
'AEMF880110JM8',
'ALE210325H46 ',
'ANE140618P37 ',
'ARM210427PS0 ',
'ART170201NX3 ',
'BAAA810211FB8',
'BACM720906UJA',
'BAZ211020CL6 ',
'BPA200313UT5 ',
'BUK1804185P9 ',
'BUZE800102VE4',
'CACL650308V86',
'CAF140521228 ',
'CARL7911158C8',
'CAS080919CL3 ',
'CLE2204081T6 ',
'COBN770330QU9',
'COLE0007115X7',
'CPR150910Q9A ',
'CSO181027MF0 ',
'DCM991109KR2 ',
'DIS141020TK7 ',
'DMI1712045J9 ',
'EEMA8606194G2',
'FEX210204265 ',
'FOGG690606B9A',
'FOHB530818K57',
'FORA471125QQ4',
'FVE1009011Y5 ',
'FZE240325C78 ',
'GARF8103183M5',
'GCE151207BL6 ',
'GMC220726BK3 ',
'GORD931202SD8',
'GPE000407UP2 ',
'GRU180113T32 ',
'GTM0402107R4 ',
'HECR781007C45',
'HUGD730903MJA',
'IARA761124CT4',
'ICI180820J61 ',
'ILM130405IQ9 ',
'IMA201111FF1 ',
'IME1503125X1 ',
'IWM230209GW1 ',
'JAAS701103DVA',
'JDG910804VB0 ',
'JSC080814JH3 ',
'LBA201123FL6 ',
'LOMA8004087Z8',
'LOPI640706SK2',
'LTF170407RG6 ',
'LUL210914U23 ',
'MANS720206QZ4',
'MBA100915J51 ',
'MEAJ830228FI5',
'MEGA730926HCA',
'MEGF870715357',
'MOCR570421TR4',
'MOFR891003TX1',
'MRB981203S39 ',
'NWM9709244W4',
'OFF230518MI2 ',
'OIPA680205EW3',
'OODE450902FC7',
'PAOB800913NL3',
'PAPV811031LX8',
'PDW190410999 ',
'PPR901104XX1 ',
'PRU200223XX0 ',
'PUS031217EY5 ',
'QIN240531VA4 ',
'RAAA750706LA0',
'RAAB740329979',
'RENS7309082Y7',
'RODR760218KN0',
'ROGG8203131N5',
'RORG851129KF4',
'RSE821202E82 ',
'RTP181221NE7 ',
'SALM831019164',
'SKD221201IM8 ',
'SLO130117A82 ',
'SMA191017Q53 ',
'SNT4403137K5 ',
'SPA171101JF2 ',
'SSC2112093A8 ',
'STS2103054M4 ',
'TAL171123C28 ',
'TARL4711269W5',
'TEMJ730629260',
'TGT240614FV7 ',
'TRA150604TW1 ',
'TTC1608107D4 ',
'UBV121024TN8 ',
'UPM191014S31 ',
'VACU591209MT0',
'VIC2402269C1 ',
'VIPD920604B45'
) AND Fecha between '20240101' and '20241231' and Clave_Subclave in ('1002-0007','1002-0003','1002-0007','1002-2015','1002-2016','1002-2007','1002-0005')
group by Clave_Subclave, rfc


Select top 10 * from Informacion_Estatal.dbo.PADRON_TEMP_


Select TOP 10 * from Recaudacion.DBO.REC AS a 

Select TOP 10 * from Recaudacion.DBO.REC_OBLIGACIONES

select top 10 *from REC where rec= 'GUOE050517IYA'

select count(*) from REC


CREATE VIEW REC_VIEW AS
SELECT a.tipo_persona, a.rec, 
b.CONTRIBUYENTE, 
c.correo, c.telefono,
b.CURP,
d.fe_ini_op, d.obligacion, d.fe_alta, d.fe_baja, a.estatus 
FROM REC AS a
left join
	(SELECT trim(RFC)as RFC, MAX(CONTRIBUYENTE) AS CONTRIBUYENTE, MAX(CURP) AS CURP 
		FROM Informacion_Estatal.dbo.PADRON_TEMP_ 
			GROUP BY RFC) AS b ON trim(a.rec)= trim(b.RFC)
left join 
	(SELECT trim(RFC) AS RFC, MAX(correo)AS correo, MAX(telefono)as telefono 
		FROM Informacion_Estatal.dbo.REC_DETALLE 
			GROUP BY RFC) AS c ON trim(a.rec)= trim(c.RFC)
left join 
	(SELECT trim(rec) as rec, MAX(fe_ini_op) as fe_ini_op , MAX(obligacion) AS obligacion, MAX(fe_alta)AS fe_alta, MAX(fe_baja) as fe_baja 
		FROM REC_OBLIGACIONES 
			group by rec) AS d ON trim(a.rec)= d.rec


select top 100 * from REC_VIEW

SELECT TOP 100 *  FROM REC_OBLIGACIONES ORDER BY fe_alta desc

select top 100 *from REC where estatus= 'Baja'


select * from Informacion_Federal.dbo.Personas_Morales where rfc like '%TMH190123SDA%'



select top 10 a.interlocutor as BP, a.rfc as RFC, a.rfc_10, a.curp as CURP, a.objeto_contrato as Objeto_Contrato, a.numero_serie as Numero_Serie,
		a.rev as REV, a.oficina as Oficina, a.folio_tarjeta as No_Tarjeta_Circulacion, a.placa as Placa,  
from Vehicular_Hana a




---- QUERY PARA OBTENER RECARGOS Y ACTUALIZACIONES
SELECT A.RFC, A.Parter, A.Ejercicio, A.Periodo, A.Fecha,
CASE WHEN TRIM(A.Clave_Subclave) = TRIM(B.Clave_Sub) THEN A.Importe END AS Principal,
CASE WHEN TRIM(A.Clave_Subclave) = TRIM(C.Clave_Sub) THEN A.Importe END AS Recargos,
CASE WHEN TRIM(A.Clave_Subclave) = TRIM(D.Clave_Sub) THEN A.Importe END AS Actualizaciones,
A.Importe as Total
	FROM PAGOS_REGISTRADOS_PARA_DEPURAR AS A
LEFT JOIN 
	(SELECT Obligacion, CONCAT(Clave,'-',Subclave) AS Clave_Sub, Tipo 
		FROM claves_obligaciones where Tipo ='Principal') AS B ON TRIM(A.Clave_Subclave)= TRIM(B.Clave_Sub)
LEFT JOIN 
	(SELECT Obligacion, CONCAT(Clave,'-',Subclave) AS Clave_Sub, Tipo 
		FROM claves_obligaciones where Tipo='Recargos' ) AS C ON TRIM(A.Clave_Subclave)= TRIM(C.Clave_Sub)
LEFT JOIN 
	(SELECT Obligacion, CONCAT(Clave,'-',Subclave) AS Clave_Sub, Tipo 
		FROM claves_obligaciones where Tipo='Actualización' ) AS D ON TRIM(A.Clave_Subclave)= TRIM(D.Clave_Sub)
WHERE (CASE WHEN TRIM(A.Clave_Subclave) = TRIM(B.Clave_Sub) THEN A.Importe END IS NOT NULL)
   OR (CASE WHEN TRIM(A.Clave_Subclave) = TRIM(C.Clave_Sub) THEN A.Importe END IS NOT NULL)
   OR (CASE WHEN TRIM(A.Clave_Subclave) = TRIM(D.Clave_Sub) THEN A.Importe END IS NOT NULL)


 select * from actualizacion_tablas

 update actualizacion_tablas
 set responsable = 1

 execute ActualizarInfoTablas
 delete actualizacion_tablas
 ALTER SEQUENCE nombre_de_tu_secuencia
RESTART WITH nuevo_valor;

SELECT OBJECT_NAME(OBJECT_ID) AS Table_Name, name AS Column_Name, 
       last_value AS Last_Identity_Value
FROM sys.identity_columns
WHERE OBJECT_NAME(OBJECT_ID) = 'actualizacion_tablas';

DBCC CHECKIDENT ('actualizacion_tablas', RESEED, 0);




SELECT base_datos, 
                    tabla, 
                    descripcion, 
                    creacion, 
                    modificacion, 
                    ultimo_registro, 
                    tipo_actualizacion, 
                    visible, 
                    responsable, 
                    gestor
            FROM actualizacion_tablas
            WHERE descripcion <> '' and tipo_actualizacion <> '' and responsable <> '' and descripcion like '%vacia%'


select base_datos, tabla, descripcion, creacion, modificacion, ultimo_registro, tipo_actualizacion, visible, responsable, gestor
from actualizacion_tablas where descripcion <> '' and tipo_actualizacion <> '' and responsable <> '' and visible = 1;




exec ActualizarInfoTablas;

select * from Informacion_Estatal.dbo.actualizacion_tablas WHERE ultimo_registro is not null

UPDATE actualizacion_tablas
set responsable = 1

SELECT 
	''' + Informacion_Estatal + ''', 
	t.name AS tabla,
	t.create_date AS creacion,
	t.modify_date AS modificacion,
	case when i.last_user_update is null then '' else i.last_user_update end as ult_registro,
	COALESCE(i.last_user_update, '') AS ultimo_registro
    FROM sys.tables t
	LEFT JOIN sys.dm_db_index_usage_stats i 
                ON i.object_id = t.object_id
                AND i.database_id = DB_ID();

	select * from sys.dm_db_index_usage_stats

	select * from sys.tables

	select * from Recaudacion.dbo.actualizacion_tablas

	select top 100* from Informacion_Estatal.dbo.ENVIO_CARTAS

	select top 100 * from Informacion_Estatal_Temporal.dbo.CORREOS_PADRONES order by Fecha desc


	--Pueba
select TOP 100 * from cfdi_lista

select * from cfdi_temp


--Productivo
Select top 100 * from lista_cfdi


SELECT TOP 5000
    A.RFC, 
    A.Parter AS Documento,  
    A.Ejercicio,
    CAST(SUM(A.Importe) AS VARCHAR) AS Total_Importe,  
    COUNT(*) AS Cantidad_Pagos
FROM PAGOS_REGISTRADOS_PARA_DEPURAR AS A
LEFT JOIN (
    SELECT rfc_vig, 
            CONCAT(nombre, ' ', ap_paterno, ' ', ap_materno) AS Nombre 
    FROM Informacion_Federal.dbo.Personas_Fisicas_2
    GROUP BY rfc_vig, nombre, ap_paterno, ap_materno) AS B ON TRIM(A.RFC) = TRIM(B.rfc_vig)

SELECT COUNT(*) FROM Recaudacion.dbo.LISTADO_CFDI WHERE RfcEmisor like '%EIPL690902BW7%' and EfectoComprobante like '%MINA%'
--24,505,402
--24,507,402
--24,510,262

select FolioFiscal, count(*) from temp_cfdi2025 
group by FolioFiscal
having count(*) > 1

41,655
--select 448625 -41655

CREATE TABLE temp_cfdi2025 (
	FolioFiscal varchar(1000),
    Id varchar(1000),
    PeriodoEmision varchar(100),
    EjercicioEmision varchar(100),
    FechaEmision DATE,
    FechaCertificacion DATE,
    RfcEmisor VARCHAR(1000),
    Emisor VARCHAR(1000),
    RfcReceptor VARCHAR(1000),
    Receptor VARCHAR(1000),
    Subtotal DECIMAL(18, 2),
    Total DECIMAL(18, 2),
    Descuento DECIMAL(18, 2),
    EfectoComprobante VARCHAR(10),
    EstadoComprobante VARCHAR(100),
    FechaCancelacion DATE,
    Total_IVA_retenidos DECIMAL(18, 2),
    Total_ISR_retenidos DECIMAL(18, 2),
    Total_IEPS__retenidos DECIMAL(18, 2),
    Total_Impuestos_Retenidos DECIMAL(18, 2),
    Total_IVA_trasladados DECIMAL(18, 2),
    Total_ISR_trasladados DECIMAL(18, 2),
    Total_IEPS_trasladados DECIMAL(18, 2),
    Total_Impuestos_Trasladados DECIMAL(18, 2),
    Tipo_de_Cambio DECIMAL(18, 6),
    Moneda VARCHAR(1000),
    Concepto_Cantidad INT,
    Concepto_Unidad VARCHAR(1000),
    Concepto_num_Identificacion VARCHAR(1000),
    Concepto_Descripcion VARCHAR(5000),
    Concepto_Valor_Unitario DECIMAL(18, 2),
    Concepto_Importe DECIMAL(18, 2),
    Serie VARCHAR(1000),
    Folio VARCHAR(1000),
    Forma_de_pago VARCHAR(1000),
    Condiciones_de_Pago VARCHAR(1000),
    Metodo_de_pago VARCHAR(1000),
    Version_CFDI VARCHAR(1000)
);


Select top 100 * from [Informacion_Estatal].dbo.cfdi_yudico

DELETE temp_cfdi2025

SELECT count(*) FROM temp_cfdi2025

drop table cfdi_yudico


CREATE TABLE cfdi_yudico (
    FolioFiscal varchar(1000) not null PRIMARY KEY,
    Id varchar(1000),
    PeriodoEmision VARCHAR(100),
    EjercicioEmision VARCHAR(100),
    FechaEmision DATE,
    FechaCertificacion DATE,
    RfcEmisor VARCHAR(1000),
    Emisor VARCHAR(1000),
    RfcReceptor VARCHAR(1000),
    Receptor VARCHAR(1000),
    Subtotal DECIMAL(18, 2),
    Total DECIMAL(18, 2),
    Descuento DECIMAL(18, 2),
    EfectoComprobante VARCHAR(10),
    EstadoComprobante VARCHAR(100),
    FechaCancelacion DATE,
    Total_IVA_retenidos DECIMAL(18, 2),
    Total_ISR_retenidos DECIMAL(18, 2),
    Total_IEPS__retenidos DECIMAL(18, 2),
    Total_Impuestos_Retenidos DECIMAL(18, 2),
    Total_IVA_trasladados DECIMAL(18, 2),
    Total_ISR_trasladados DECIMAL(18, 2),
    Total_IEPS_trasladados DECIMAL(18, 2),
    Total_Impuestos_Trasladados DECIMAL(18, 2),
    Tipo_de_Cambio DECIMAL(18, 6),
    Moneda VARCHAR(1000),
    Concepto_Cantidad INT,
    Concepto_Unidad VARCHAR(1000),
    Concepto_num_Identificacion VARCHAR(1000),
    Concepto_Descripcion VARCHAR(5000),
    Concepto_Valor_Unitario DECIMAL(18, 2),
    Concepto_Importe DECIMAL(18, 2),
    Serie VARCHAR(1000),
    Folio VARCHAR(1000),
    Forma_de_pago VARCHAR(1000),
    Condiciones_de_Pago VARCHAR(1000),
    Metodo_de_pago VARCHAR(1000),
    Version_CFDI VARCHAR(1000)
);



	




select * from [dbo].[Operaciones_CFDI_2025]


xp_cmdshell 'wmic logicaldisk get size,freespace,caption'

E:       3,760,128           751552167936   
E:       24,028,749,824       751,552,167,936       


SELECT name FROM sys.database_files WHERE type_desc = 'LOG';

-- 3. Reducir el log a 1 GB (1024 MB)
DBCC SHRINKFILE (Informacion_Estatal_log, 1024);

select * from[dbo].[Comprobante]

select * from Kobra_Importaciones

select * from Kobra_Importaciones_Detalle  where id_subcuenta='18442/2026-1' or id_cuenta like '%GODM770614P91%'


select * from Informacion_Federal.dbo.Sepomex_CP where d_codigo= '37370' or d_asenta like '%LEON%' and D_mnpio = 'León'

alter table Kobra_Importaciones
add correo_enviado bit default 0

UPDATE Kobra_Importaciones
SET correo_enviado = 1
WHERE correo_enviado = 0;


SELECT  *
FROM OPENQUERY(PG_Recaudacion, 
				'select enpd.id, 
					enpd.rfc, 
					enpd.nombre, 
					enpd.no_guia, 
					uu.nombre || '' || uu.primer_ape || ' ' || uu.segundo_ape as usuario, 
					uu.correo_electronico,
					enpdd.etapa,
					enpdd. fecha_limite ,
					enpdd.fecha_visita,
					uu2.nombre || '' || uu2.primer_ape || ' ' || uu2.segundo_ape as notificador
				from ejecucion_notificaciones_programa_documento enpd 
				inner join users_usuarios uu on uu.id = enpd.usuario_asigna_zona_id 
				inner join ejecucion_notificaciones_programa_documento_detalle enpdd on enpdd.notificaciones_programa_documento_id = enpd.id and enpdd.envio_kobra = true and enpdd.estatus = 1
				inner join users_usuarios uu2 on uu2.id = enpdd.notificador_id 
				where enpd.is_active = true
					and enpd.no_guia is not null') as z
INNER JOIN Informacion_Federal.dbo.Sepomex_CP as sc on trim(d_codigo) = trim(z.codigo_postal)


select	ki.id_lote,
		ISNULL(ki.cuentas_importadas,0)as cuentas_importadas, 
		ki.errores, 
		ki.fecha_creada,
		kid.id_cuenta,
		kid.id_subcuenta,
		kid.error,
		kid.resultado,
		pg.usuario,
		pg.correo_electronico,
		pg.notificador,
		pg.etapa
from Kobra_Importaciones as ki
left join Kobra_Importaciones_Detalle as kid on ki.id_lote = kid.id_lote
INNER JOIN 
(
SELECT  *
FROM OPENQUERY(PG_Recaudacion, 
'select enpd.id, 
	enpd.rfc, 
	enpd.nombre, 
	enpd.no_guia, 
	uu.nombre || '' '' || uu.primer_ape || '' '' || uu.segundo_ape as usuario, 
	uu.correo_electronico,
	enpdd.etapa,
	enpdd. fecha_limite ,
	enpdd.fecha_visita,
	uu2.nombre || '' '' || uu2.primer_ape || '' '' || uu2.segundo_ape as notificador
from ejecucion_notificaciones_programa_documento enpd 
inner join users_usuarios uu on uu.id = enpd.usuario_asigna_zona_id 
inner join ejecucion_notificaciones_programa_documento_detalle enpdd on enpdd.notificaciones_programa_documento_id = enpd.id and enpdd.envio_kobra
inner join users_usuarios uu2 on uu2.id = enpdd.notificador_id 
where enpd.is_active = true
	and enpd.no_guia is not null;')
) as pg on trim(pg.no_guia) = trim(kid.id_subcuenta)
WHERE 
	--kid.error = 'Sí' 
	 ki.usuario = 'LUIS ALCARAZ'
	AND ki.estatus = 'Terminado'
	order by ki.id_lote
	--and UPPER(resultado) NOT IN ('|Esta cuenta ya se encuentra inactiva.', '|Registro repetido.') 


select	ki.id_lote,
		ISNULL(ki.cuentas_importadas,0)as cuentas_importadas, 
		ki.errores, 
		ki.fecha_creada,
		kid.id_cuenta,
		kid.id_subcuenta,
		kid.error,
		kid.resultado
from Kobra_Importaciones as ki
left join Kobra_Importaciones_Detalle as kid on ki.id_lote = kid.id_lote
WHERE 
	kid.error = 'Sí' 
	AND ki.usuario = 'LUIS ALCARAZ'
	AND ki.estatus = 'Terminado'
	AND ki.correo_enviado = 0
	AND UPPER(resultado) NOT IN ('|Esta cuenta ya se encuentra inactiva.', '|Registro repetido.') 
	order by ki.id_lote



	SELECT  ki.id_lote,
            ISNULL(ki.cuentas_importadas, 0) as cuentas_importadas, 
            ISNULL(ki.errores, 0) as errores, 
            ki.fecha_creada,
            kid.id_cuenta,
            kid.id_subcuenta,
            kid.error,
            kid.resultado,
            pg.usuario
    FROM Kobra_Importaciones AS ki
    LEFT JOIN Kobra_Importaciones_Detalle AS kid ON ki.id_lote = kid.id_lote
    INNER JOIN 
    (
        SELECT  *
        FROM OPENQUERY(PG_Recaudacion, 
        'SELECT enpd.id, 
                enpd.rfc, 
                enpd.nombre, 
                enpd.no_guia, 
                uu.nombre || '' '' || uu.primer_ape || '' '' || uu.segundo_ape as usuario
        FROM ejecucion_notificaciones_programa_documento enpd 
        INNER JOIN users_usuarios uu ON uu.id = enpd.usuario_asigna_zona_id 
        WHERE enpd.is_active = true
            AND enpd.no_guia is not null;')
    ) AS pg ON trim(pg.no_guia) = trim(kid.id_subcuenta)
    WHERE 
        kid.error = 'Sí' 
        AND ki.usuario = 'LUIS ALCARAZ'
        AND ki.estatus = 'Terminado'
        AND ISNULL(ki.correo_enviado, 0) = 0
    ORDER BY ki.id_lote


select * from Kobra_Importaciones_Detalle where id_lote = 17613


select * from Kobra_Importaciones WHERE id_lote = 17613



alter table Kobra_Importaciones_Detalle
ALTER COLUMN resultado VARCHAR(200);




select * from Recaudacion.dbo.Personas_ where concat(trim(AP_PATERNO), ' ', trim(AP_MATERNO)) like '%Vargas Martinez%'

select top 100 * from Direcciones_STG

exec GENERA_TABLA_ECOLOGICOS
exec [dbo].[SP_CUMPLIMIENTO_ECOLOGICOS]

select * from sysobjects where xtype= 'P'

select * from RFC_PRUEBAS_SIAT where RFC in ('CAM2503285Q2',	'GUMJ9104091E7',	'GURA991112TD4',	'HME170717989',	'JAGR991112TD4',	'MODD8808153S9',	'MOMM820905FF2',	'MURM690521BH7',	'PILA980509BD0',	'RASJ941221I9A',	'ROTL9909099T6',	'SFC250424EN2',	'TORB991120M70',	'VEHJ790517DK5')

INSERT INTO RFC_PRUEBAS_SIAT ()


SELECT TOP 100 * FROM REC_OBLIGACIONES WHERE RFC IN ('CAM2503285Q2',	'GUMJ9104091E7',	'GURA991112TD4',	'HME170717989',	'JAGR991112TD4',	'MODD8808153S9',	'MOMM820905FF2',	'MURM690521BH7',	'PILA980509BD0',	'RASJ941221I9A',	'ROTL9909099T6',	'SFC250424EN2',	'TORB991120M70',	'VEHJ790517DK5')






	







