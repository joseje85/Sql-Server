select 
substring(Clave_Subclave,1,4) as Clave, substring(Clave_Subclave,6,4) as Subclave, SUM(Importe)AS IMPORTE 
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
WHERE P.Fecha >= '20250908' and P.Fecha <= '20251209'
GROUP BY P.Obligacion,
	P.Parter,
	P.Clave_Subclave,
	DV.OBJETO_CONTRATO) AS Z
	GROUP BY 
	Z.Clave_Subclave 
	



select count(*) as total_periodos , count(distinct(rfc)) as num_contribuyentes, sum(Importe) as importe_impuestos
from
(select Ejercicio , Periodo , rfc , sum(importe) as Importe from(
    select trim(A.rfc) as rfc,A.ejercicio,A.periodo,A.fecha,A.importe,A.Clave_Subclave as cve_subcve,B.NOMBRE_COMPLETO as nombre from
        (
            select * from PAGOS_REGISTRADOS_PARA_DEPURAR where fecha >= '20250908' and ejercicio < 2025 and SUBSTRING(Clave_Subclave,1,4) in('1001', '1002', '1004', '1005', '1006', '1007', '1010', '1012') and importe>0
            union all
            select * from PAGOS_REGISTRADOS_PARA_DEPURAR where fecha >= '20250908' and ejercicio = 2025 and periodo <= 6 and SUBSTRING(Clave_Subclave,1,4) in('1001', '1002', '1004', '1005', '1006', '1007', '1010', '1012') and importe>0
        ) as A
        left join Recaudacion.dbo.Personas_ as B on (trim(A.rfc) = trim(B.rfc))
) as z group by Ejercicio , Periodo , rfc) as X




SELECT 
	Clave,
    Subclave,
    SUM(Importe) AS importe_impuestos
FROM
(
    SELECT 
        Ejercicio,
        Periodo,
        rfc,
        Clave,
        Subclave,
        SUM(importe) AS Importe
    FROM
    (
        SELECT  
            TRIM(A.rfc) AS rfc,
            A.ejercicio,
            A.periodo,
            A.fecha,
            A.importe,
            SUBSTRING(A.Clave_Subclave,1,4) AS Clave,
            SUBSTRING(A.Clave_Subclave,6,4) AS Subclave,
            B.NOMBRE_COMPLETO AS nombre
        FROM
        (
            SELECT * 
            FROM PAGOS_REGISTRADOS_PARA_DEPURAR 
            WHERE fecha >= '20250908' and Fecha <= '20251209'
              AND ejercicio < 2025
              AND SUBSTRING(Clave_Subclave,1,4) IN ('1001','1002','1004','1005','1006','1007','1010','1012')
              AND importe > 0

            UNION ALL

            SELECT * 
            FROM PAGOS_REGISTRADOS_PARA_DEPURAR 
            WHERE fecha >= '20250908' and Fecha <= '20251209'
              AND ejercicio = 2025
              AND periodo <= 6
              AND SUBSTRING(Clave_Subclave,1,4) IN ('1001','1002','1004','1005','1006','1007','1010','1012')
              AND importe > 0
        ) AS A
        LEFT JOIN Recaudacion.dbo.Personas_ AS B 
            ON TRIM(A.rfc) = TRIM(B.rfc)
    ) AS z
    GROUP BY Ejercicio, Periodo, rfc, Clave, Subclave
) AS X
GROUP BY Clave, Subclave;



SELECT A.RFC , DATEDIFF(MONTH , ISNULL(FechaVisita, '20230224'), ISNULL(fe_baja, '20251211')) - 2 AS PERIODOS,  estatus ,fe_baja, C.PAGO, ISNULL(C.CANTIDAD,0) AS CANTIDAD, 
(DATEDIFF(MONTH , ISNULL(FechaVisita, '20230224'), ISNULL(fe_baja, '20251211')) - 2 )- ISNULL(C.CANTIDAD,0) AS ADEUDO
FROM Informacion_Estatal.dbo.RFC_TIANGUIS AS A
LEFT JOIN REC_OBLIGACIONES AS B ON A.RFC = B.rec  
LEFT JOIN (
    SELECT RFC , SUM(PAGO) AS PAGO, COUNT(*) AS CANTIDAD FROM
    (SELECT RFC , Ejercicio , Periodo, SUM(IMPORTE) AS PAGO  FROM Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR WHERE Clave_Subclave IN ('1002-0009','0177-0003') GROUP BY RFC , Ejercicio , Periodo) AS X GROUP BY RFC) AS C ON A.RFC =C.RFC
WHERE obligacion LIKE '%REGIMEN SIMPLIFICADO DE CONFIA%' AND 
(DATEDIFF(MONTH , ISNULL(FechaVisita, '20230224'), ISNULL(fe_baja, '20251211')) - 2 )- ISNULL(C.CANTIDAD,0) <= 10
ORDER BY ADEUDO





