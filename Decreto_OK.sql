ALTER VIEW Actualizaciones_Recargos_Vehicular as  
SELECT  
    D.rfc,  
    D.nombre,  
    D.objeto_contrato,  
    D.placa,  
    Ejercicio_Adeudo = (2000 + CAST(SUBSTRING(TRIM(D.periodo),1,2) AS INT)),  
    D.importe,  
    Fecha_Emision = CAST('2026-03-09' AS date),  
  
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
    ON I1.Ejercicio = 2026   
   AND I1.Periodo = 1  -- Periodo_INPC (mes anterior a la emisión)  
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
        fecha_emision = CAST('2026-03-09' AS date)  
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
WHERE CAST(SUBSTRING(TRIM(D.PERIODO), 1,2) AS INT) >= 11 

sp_helptext 'Actualizaciones_Recargos_Vehicular'

SELECT TOP 1000* FROM Decreto_Vehicular WHERE OBJETO_CONTRATO in ('4001348406', '4002016657')

select top 20* from [Informacion_Estatal].dbo.[CODIGOS_POSTALES]

WHERE D.ORIGEN = 'HANA' and D.IMPORTE not in ('','0') and D.PERIODO <> '?'


select * from INPC order by Ejercicio

SELECT top 10000 * FROM Decreto_Vehicular WHERE OBJETO_CONTRATO = '4000001287'
---3,645,872

select 
--COUNT(DISTINCT Obligacion) as num_vehiculos , SUM(PRINCIPAL) as PRINCIPAL, SUM(ACTUALIZACION) AS ACTUALIZACION, SUM(RECARGOS) AS RECARGOS
from (
select
	*
from (SELECT Obligacion,SUM(IMPORTE) AS IMPORTE  FROM  PAGOS_REGISTRADOS_PARA_DEPURAR WHERE substring(Clave_Subclave,1,4) = '4011' AND Ejercicio <= 2020 AND Fecha BETWEEN '20250908' AND '20251231' GROUP BY Obligacion) as P
LEFT JOIN 
	(SELECT v.p ,SUM(COALESCE(TRY_CAST(IMPORTE AS DECIMAL(18,2)), 0)) AS PRINCIPAL , SUM(Importe_Actualizacion) AS ACTUALIZACION, SUM(IMPORTE_RECARGOS) AS RECARGOS
	FROM	Actualizaciones_Recargos_Vehicular
	GROUP BY objeto_contrato
) AS DV ON CAST(tRIM(P.Obligacion) AS BIGINT) = CAST(TRIM(DV.objeto_contrato) AS BIGINT)
GROUP BY P.Obligacion
) AS Z




SELECT 
    DV.placa,
    DV.objeto_contrato,
    SUM(DV.PRINCIPAL) AS PRINCIPAL,
    SUM(DV.ACTUALIZACION) AS ACTUALIZACION,
    SUM(DV.RECARGOS) AS RECARGOS
FROM (
    SELECT 
        Obligacion,
        SUM(IMPORTE) AS IMPORTE
    FROM PAGOS_REGISTRADOS_PARA_DEPURAR
    WHERE Fecha between '20250908' and '20251231'
    GROUP BY Obligacion
) AS P
INNER JOIN (
    SELECT 
        objeto_contrato,
        placa,
        SUM(COALESCE(TRY_CAST(importe AS DECIMAL(18,2)), 0)) AS PRINCIPAL,
        SUM(COALESCE(Importe_Actualizacion, 0)) AS ACTUALIZACION,
        SUM(COALESCE(Importe_Recargos, 0)) AS RECARGOS
    FROM Actualizaciones_Recargos_Vehicular
    GROUP BY objeto_contrato, placa
) AS DV ON TRY_CAST(TRIM(P.Obligacion) AS BIGINT) = TRY_CAST(TRIM(DV.objeto_contrato) AS BIGINT)
GROUP BY 
    DV.placa,
    DV.objeto_contrato;



SELECT 
    DV.placa,
    DV.objeto_contrato,
    DV.Ejercicio_Adeudo,
    SUM(DV.PRINCIPAL) AS PRINCIPAL,
    SUM(DV.ACTUALIZACION) AS ACTUALIZACION,
    SUM(DV.RECARGOS) AS RECARGOS
FROM (
    SELECT 
        Obligacion,
        SUM(IMPORTE) AS IMPORTE
    FROM PAGOS_REGISTRADOS_PARA_DEPURAR
    WHERE Fecha between '20260101' and '20260309'
   GROUP BY Obligacion
) AS P
INNER JOIN (
    SELECT 
        objeto_contrato,
        placa,
        Ejercicio_Adeudo,
        SUM(COALESCE(TRY_CAST(importe AS DECIMAL(18,2)), 0)) AS PRINCIPAL,
        SUM(COALESCE(Importe_Actualizacion, 0)) AS ACTUALIZACION,
        SUM(COALESCE(Importe_Recargos, 0)) AS RECARGOS
    FROM Actualizaciones_Recargos_Vehicular
    GROUP BY objeto_contrato, placa, Ejercicio_Adeudo
) AS DV
    ON TRY_CAST(TRIM(P.Obligacion) AS BIGINT) 
       = TRY_CAST(TRIM(DV.objeto_contrato) AS BIGINT)
GROUP BY 
    DV.placa,
    DV.objeto_contrato,
    DV.Ejercicio_Adeudo;



------- DECRETO TELEGRAM

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
WHERE P.Fecha >= '20250908'
GROUP BY P.Obligacion,
	P.Parter,
	P.Clave_Subclave,
	DV.OBJETO_CONTRATO) AS Z


select count(distinct Obligacion) from (
select 
	P.Obligacion,
	P.Parter,
	P.Clave_Subclave,
	P.Fecha,
	DV.OBJETO_CONTRATO,
	DV.PLACA,
	P.Importe
from PAGOS_REGISTRADOS_PARA_DEPURAR as P
INNER JOIN 
	(SELECT PLACA, OBJETO_CONTRATO, MAX(PERIODO)AS PERIODO FROM Decreto_Vehicular GROUP BY OBJETO_CONTRATO, PLACA) AS DV ON CAST(tRIM(P.Obligacion) AS BIGINT) = CAST(TRIM(DV.OBJETO_CONTRATO) AS BIGINT)
WHERE P.Fecha BETWEEN '20250908' AND '20260309') as z


SELECT COUNT(*) FROM (
SELECT PLACA, OBJETO_CONTRATO, MAX(PERIODO)AS PERIODO FROM Decreto_Vehicular 
GROUP BY OBJETO_CONTRATO, PLACA) AS Z
--473,358
--473,358



