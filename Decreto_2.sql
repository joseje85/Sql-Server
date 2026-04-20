2066	 4,574,114.50 	 2,077,635.35 	 4,782,899.57 

select 
COUNT(DISTINCT Obligacion) as num_vehiculos , SUM(PRINCIPAL) as PRINCIPAL, SUM(ACTUALIZACION) AS ACTUALIZACION, SUM(RECARGOS) AS RECARGOS
from (
select
	P.Obligacion,
	SUM(PRINCIPAL) AS PRINCIPAL,
	SUM(ACTUALIZACION) AS ACTUALIZACION,
	SUM(RECARGOS) AS RECARGOS
	--MAX(DV.Ejercicio_Adeudo) AS Ejercicio_Adeudo,
	--SUM(DV.Importe_Recargado_Actualizado) as Importe
	--SUM(DV.Importe_Recargado_Actualizado) AS Importe
from (SELECT Obligacion,SUM(IMPORTE) AS IMPORTE  FROM  PAGOS_REGISTRADOS_PARA_DEPURAR WHERE Fecha between '20250908' and '20251231' GROUP BY Obligacion) as P
INNER JOIN 
	(SELECT objeto_contrato ,SUM(COALESCE(TRY_CAST(IMPORTE AS DECIMAL(18,2)), 0)) AS PRINCIPAL , SUM(Importe_Actualizacion) AS ACTUALIZACION, SUM(IMPORTE_RECARGOS) AS RECARGOS
	FROM	Actualizaciones_Recargos_Vehicular
	GROUP BY objeto_contrato
) AS DV ON CAST(tRIM(P.Obligacion) AS BIGINT) = CAST(TRIM(DV.objeto_contrato) AS BIGINT)
GROUP BY P.Obligacion) AS Z

SELECT * FROM  PAGOS_REGISTRADOS_PARA_DEPURAR WHERE Obligacion = '4000037822' AND Fecha between '20250908' and '20251231' ORDER BY Ejercicio

select * from Decreto_Vehicular where OBJETO_CONTRATO='4000037822'


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

---3,645,872

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


select top 100 * from Actualizaciones_Recargos_Vehicular