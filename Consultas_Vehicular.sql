--# ==========================================================================
--    PADRON PLATAFORMAS TECNOLOGICAS (RETENEDORES)
--# ==========================================================================
SELECT  D.TEXT AS OBLIGACION , 
		F.STATU AS SITUACION , 	
		F.FCAOC AS CREACION , 
		F.FCINO AS INICIO , 
		F.FCBAJ AS FECHA_BAJA, 
		B.NAME_ORG1 || B.NAME_ORG2 || B.NAME_FIRST || ' ' || B.NAME_LAST || ' ' || B.NAME_LST2 AS CONTRIBUYENTE, 
		H.IDNUMBER AS RFC,
		CASE 
            WHEN B.TYPE = '1' THEN 'FISICA'
            WHEN B.TYPE = '2' THEN 'MORAL'
            ELSE 'DESCONOCIDO'
        END AS TIPO_PERSONA_BP
 FROM DESARROLLO.dpsob_bp_acc AS A
INNER JOIN DESARROLLO.But000 AS B  ON  B.CLIENT='400' AND B.BU_GROUP = 'TRM1' AND A.PARTNER = B.PARTNER
INNER JOIN DESARROLLO.dpsob AS C ON C.CLIENT='400' AND C.PSOBKEY = A.PSOBKEY
INNER JOIN DESARROLLO.TFK002AT AS D ON D.MANDT='400' AND D.SPRAS='S' AND D.APPLK='P' AND D.VKTYP=A.PARTNERACCTYP
INNER JOIN DESARROLLO.FKKVK AS E ON E.MANDT='400' AND E.VKONT= A.PARTNERACC
INNER JOIN DESARROLLO.ZRPTT_REC AS F ON F.MANDT='400' AND A.PSOBKEY = F.PSOBKEY
LEFT JOIN DESARROLLO.ADRC AS G ON G.CLIENT='400' AND STATU='1' AND G.ADDRNUMBER=A.ADRNR
LEFT JOIN DESARROLLO.BUT0ID AS H ON H.CLIENT='400' AND H.TYPE='Z01' AND A.PARTNER = H.PARTNER
LEFT JOIN DESARROLLO.BUT0ID AS I ON H.CLIENT='400' AND I.TYPE='Z02' AND A.PARTNER = I.PARTNER
WHERE A.CLIENT ='400'  
	AND F.STATU = '1'
 AND XOBSL = '' and text in ( 'Retenedor Reg Gral Plat Tecnol')	



--# ==========================================================================
--    PAGOS PLATAFORMAS TECNOLOGICAS
--# ==========================================================================
SELECT  H.IDNUMBER AS RFC_PADRON,
 		B.NAME_ORG1 || B.NAME_ORG2 || B.NAME_FIRST || ' ' || B.NAME_LAST || ' ' || B.NAME_LST2 AS CONTRIBUYENTE_PADRON, 
		P. GPART AS INTERLOCUTOR,
		P.RFC AS RFC,
		P.NOMBRE AS CONTRIBUYENTE,
		LTRIM(P.VTREF,'0') AS OBJETO_CONTRATO,
		P.VKONT AS CUENTA_CONTRATO,
		P.OPBEL AS DOCUMENTO,
		P.HVORG AS CLAVE,
		P.TVORG AS SUBCLAVE,
		P.DES_CLA AS DESCRIPCION,
		P.BETRH AS IMPORTE,
		P.OPTXT AS PERIODO,
		P.AUGBD AS FECHA, 
		P.CLADOCT
 FROM DESARROLLO.dpsob_bp_acc AS A
INNER JOIN DESARROLLO.But000 AS B  ON  B.CLIENT='400' AND B.BU_GROUP = 'TRM1' AND A.PARTNER = B.PARTNER
INNER JOIN DESARROLLO.dpsob AS C ON C.CLIENT='400' AND C.PSOBKEY = A.PSOBKEY
INNER JOIN DESARROLLO.TFK002AT AS D ON D.MANDT='400' AND D.SPRAS='S' AND D.APPLK='P' AND D.VKTYP=A.PARTNERACCTYP
INNER JOIN DESARROLLO.FKKVK AS E ON E.MANDT='400' AND E.VKONT= A.PARTNERACC
INNER JOIN DESARROLLO.ZRPTT_REC AS F ON F.MANDT='400' AND A.PSOBKEY = F.PSOBKEY
LEFT JOIN DESARROLLO.ADRC AS G ON G.CLIENT='400' AND STATU='1' AND G.ADDRNUMBER=A.ADRNR
LEFT JOIN DESARROLLO.BUT0ID AS H ON H.CLIENT='400' AND H.TYPE='Z01' AND A.PARTNER = H.PARTNER
LEFT JOIN DESARROLLO.BUT0ID AS I ON H.CLIENT='400' AND I.TYPE='Z02' AND A.PARTNER = I.PARTNER
LEFT JOIN (select * from INGRESOS.ZIN_F_PAGOS_HANA('20240101','20251231', '', '')) AS P ON LTRIM(P.VTREF) = LTRIM(A.PSOBKEY)
WHERE A.CLIENT ='400'  
		AND F.STATU = '1'
 AND XOBSL = '' and text in ( 'Retenedor Reg Gral Plat Tecnol')	



--# ==========================================================================
--    PADRON REBAS (SQL SERVER)
--# ==========================================================================
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


--# ==========================================================================
--   PAGOS REBAS (SQL SERVER)
--# ==========================================================================

SELECT 
	R.RFC AS RFC_PADRON,
	CAST(R.OBJETO_CONTRATO AS BIGINT) AS OC_PADRON,
	P.RFC, 
	P.Parter as Documento,
	P.Ejercicio,
	P.Periodo,
	P.Obligacion as Objeto_Contrato,
	P.Fecha,
	P.Importe,
	P.Clave_Subclave
FROM Informacion_Estatal.dbo.PAGOS_REGISTRADOS_PARA_DEPURAR AS P
RIGHT JOIN (SELECT RFC, PSOBKEY AS OBJETO_CONTRATO FROM Informacion_Estatal.dbo.REBAS GROUP BY RFC, PSOBKEY) AS R ON CAST(R.OBJETO_CONTRATO AS BIGINT) = P.Obligacion
WHERE P.Fecha BETWEEN '20240101' AND '20251231'
--21,985


--# ==========================================================================
--   REFRENDO VEHICULAR (HANA)
--# ==========================================================================

SELECT
    Ejercicio,
    COUNT(*) AS Pagos_Totales,
    COUNT(DISTINCT RFC) AS Contribuyentes,
    COUNT(DISTINCT OPBEL) AS Pagos_Unicos,
    SUM(BETRH) AS Recaudado
FROM (
    SELECT
    	RFC,
        OPBEL,
        BETRH,
        CAST(LEFT(AUGBD, 4) AS INT) AS Ejercicio
    FROM INGRESOS.ZIN_F_PAGOS_HANA('20240101','20251231','4011','')
    WHERE TVORG IN ('1001','1002','1003','0001','0002','0003','0004')
) Z
GROUP BY Ejercicio
ORDER BY Ejercicio;



--# ==========================================================================
--   TENENCIA (HANA)
--# ==========================================================================
SELECT
    Ejercicio,
    COUNT(*) AS Pagos_Totales,
    COUNT(DISTINCT RFC) AS Contribuyentes,
    COUNT(DISTINCT OPBEL) AS Pagos_Unicos,
    SUM(BETRH) AS Recaudado
FROM (
    SELECT
    	RFC,
        OPBEL,
        BETRH,
        CAST(LEFT(AUGBD, 4) AS INT) AS Ejercicio
    FROM INGRESOS.ZIN_F_PAGOS_HANA('20240101','20251231','1006','')
    WHERE TVORG IN ('0001','0002','1001','1002','2001', '2002')
) Z
GROUP BY Ejercicio
ORDER BY Ejercicio;



























