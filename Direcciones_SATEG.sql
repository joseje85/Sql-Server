
CREATE TABLE Direcciones_STG (
    id_stg BIGINT IDENTITY PRIMARY KEY,
    rec VARCHAR(50),
    estado NVARCHAR(150),
    municipio NVARCHAR(150),
    colonia NVARCHAR(150),
    cp CHAR(5),
    calle NVARCHAR(200),
    num_ext NVARCHAR(20),
    num_int NVARCHAR(20),
    localidad NVARCHAR(150),
    interlocutor VARCHAR(50),
    latitud VARCHAR(50) NULL,
    longitud VARCHAR(50) NULL,
    hash_direccion VARBINARY(32),
    fecha_proceso DATETIME DEFAULT GETDATE()
);

CREATE TABLE dbo.Sepomex_CP (
    d_codigo            VARCHAR(10),
    d_asenta            VARCHAR(250),
    d_tipo_asenta       VARCHAR(100),
    D_mnpio             VARCHAR(150),
    d_estado            VARCHAR(150),
    d_ciudad            VARCHAR(150),
    d_CP                VARCHAR(10),
    c_estado            VARCHAR(10),
    c_oficina           VARCHAR(10),
    c_CP                VARCHAR(10),
    c_tipo_asenta       VARCHAR(10),
    c_mnpio             VARCHAR(10),
    id_asenta_cpcons    VARCHAR(20),
    d_zona              VARCHAR(100),
    c_cve_ciudad        VARCHAR(10)
);

CREATE TABLE Direcciones_Limpias (
    id_clean INT IDENTITY(1,1) PRIMARY KEY,
    rfc VARCHAR(20),
    estado VARCHAR(150),
    municipio VARCHAR(150),
    colonia VARCHAR(150),
    cp VARCHAR(10),
    calle VARCHAR(150),
    num_ext VARCHAR(30),
    num_int VARCHAR(30),
    latitud VARCHAR(50) NULL,
    longitud VARCHAR(50) NULL,
    observaciones VARCHAR(300) NULL,
    hash_unico VARCHAR(200),
    fecha_proceso DATETIME DEFAULT GETDATE(),
    fuente VARCHAR(50)
);

CREATE TABLE Direcciones_Limpias_Detalle (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    id_clean INT,
    campo VARCHAR(50),
    valor_original VARCHAR(200),
    valor_osm VARCHAR(200),
    fecha_proceso DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_clean) REFERENCES Direcciones_Limpias(id_clean)
);

drop table Direcciones_Limpias
delete Direcciones_Limpias

select top 1000 * from Direcciones_STG where rec <> ''  and rec= 'VSU141222RB5' order by colonia

select * from Informacion_Estatal.dbo.REBAS where RFC= 'VSU141222RB5'

select * from Catastro_Sat where rfc like '%VSU141222RB5%'

select * from RPP where rfc = 'VSU141222RB5'

select * from Informacion_Federal.dbo.Personas_Morales_2 where rfc_vig like '%VSU141222RB5%'

select top 10 rfc, calle, no_exterior, no_interior, entre_calle_1, entre_calle_2,b.nombre as colonia, a.cv_cp, c.d_estado as estado, c.D_mnpio as municipio
from Informacion_Federal.dbo.Personas_Morales_2 as a
left join Informacion_Federal.dbo.cat_colonia as b on a.cv_colonia= b.cv_colonia
left join Informacion_Estatal.dbo.CODIGOS_POSTALES as c on a.cv_cp= c.d_codigo
where a.rfc_vig like '%VSU141222RB5%'

select * from Informacion_Estatal.dbo.REC_DETALLE where RFC = 'VSU141222RB5'


select * from Direcciones_Limpias where rfc = 'AAA020621GA1'

select * from Direcciones_Limpias_Detalle

ALTER TABLE Direcciones_Limpias
DROP COLUMN localidad;

select distinct TipoDeComprobante from [dbo].[vw_Comprobantes_Completa] where Emisor_RFC = 'MMA1202141PA'


delete Direcciones_Limpias
DBCC CHECKIDENT ('Direcciones_Unicas_RFC', RESEED, 0);
--40,091


select from Informacion_Federal.dbo.Sepomex_CP where d_codigo = '36090'

--157,660

--157,660

select TOP 0* from Informacion_Estatal.dbo.[CODIGOS_POSTALES]

select top 0* from Direcciones_STG where rec <> '' order by rec

update Direcciones_STG Set procesado = 0

ALTER TABLE Direcciones_STG
ADD procesado BIT NOT NULL DEFAULT 0;

delete Direcciones_STG
DBCC CHECKIDENT ('Direcciones_STG', RESEED, 0);


select * from Direcciones_CLEAN where rec = 'ACE9608276P8'

delete Direcciones_CLEAN
DBCC CHECKIDENT ('Direcciones_CLEAN', RESEED, 0);

select top 100 * from Direcciones_CLEAN


select top 10000 * from Directions_Sateg where rfc like '%PCE970626SY1%' order by rfc

sp_help Directions_Sateg


update Direcciones_CLEAN
set procesado_fuzzy = 0
where procesado_fuzzy = 1


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Directions_Sateg'



CREATE OR ALTER FUNCTION dbo.fn_NormalizaNumero
(
    @valor NVARCHAR(100)
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @resultado NVARCHAR(100)

    SET @resultado = UPPER(LTRIM(RTRIM(ISNULL(@valor, ''))))

    -- Eliminar palabras comunes
    SET @resultado = REPLACE(@resultado, 'SIN NUMERO', '')
    SET @resultado = REPLACE(@resultado, 'SIN N', '')
    SET @resultado = REPLACE(@resultado, 'S/N', '')
    SET @resultado = REPLACE(@resultado, 'SN', '')
    SET @resultado = REPLACE(@resultado, 'LOCAL', '')
    SET @resultado = REPLACE(@resultado, 'NO.', '')
    SET @resultado = REPLACE(@resultado, 'NUM.', '')

    -- Eliminar caracteres especiales
    SET @resultado = REPLACE(
    TRANSLATE(@resultado, '*''/&%$#{}[].,:;_-', REPLICATE(' ', LEN('*''/&%$#{}[].,:;_-'))),
    ' ',
    ''
)


    -- Quitar dobles espacios
    WHILE CHARINDEX('  ', @resultado) > 0
        SET @resultado = REPLACE(@resultado, '  ', ' ')

    RETURN LTRIM(RTRIM(@resultado))
END


CREATE OR ALTER FUNCTION dbo.fn_ExtraeNumeroPrincipal
(
    @valor NVARCHAR(100)
)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @normalizado NVARCHAR(100)
    DECLARE @numero NVARCHAR(50)

    SET @normalizado = dbo.fn_NormalizaNumero(@valor)

    -- Extraer solo los dígitos iniciales
    SET @numero = LEFT(@normalizado,
                       PATINDEX('%[^0-9]%', @normalizado + 'X') - 1)

    RETURN @numero
END


CREATE OR ALTER FUNCTION dbo.fn_ExtraeComplementoNumero
(
    @valor NVARCHAR(100)
)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @normalizado NVARCHAR(100)
    DECLARE @principal NVARCHAR(50)

    SET @normalizado = dbo.fn_NormalizaNumero(@valor)
    SET @principal = dbo.fn_ExtraeNumeroPrincipal(@valor)

    RETURN LTRIM(REPLACE(@normalizado, @principal, ''))
END



CREATE OR ALTER FUNCTION dbo.fn_NumeroValido
(
    @valor NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @principal NVARCHAR(50)

    SET @principal = dbo.fn_ExtraeNumeroPrincipal(@valor)

    IF ISNUMERIC(@principal) = 1 AND LEN(@principal) > 0
        RETURN 1

    RETURN 0
END

ALTER TABLE Direcciones_CLEAN
ADD num_ext_normalizado NVARCHAR(100),
    num_ext_principal NVARCHAR(50),
    num_ext_complemento NVARCHAR(50),
    flag_numero_valido BIT


CREATE OR ALTER FUNCTION dbo.fn_TipoNumero
(
    @valor NVARCHAR(100)
)
RETURNS NVARCHAR(30)
AS
BEGIN
    DECLARE @v NVARCHAR(100)
    SET @v = dbo.fn_NormalizaNumero(@valor)

    IF @v = '' RETURN 'SIN_NUMERO'

    IF @v LIKE 'KM %' RETURN 'KILOMETRO'

    IF @v LIKE '%MZ%' OR @v LIKE '%LT%'
        RETURN 'MANZANA_LOTE'

    IF @v LIKE '%-%'
        RETURN 'RANGO'

    IF ISNUMERIC(dbo.fn_ExtraeNumeroPrincipal(@v)) = 1
        RETURN 'NORMAL'

    RETURN 'INVALIDO'
END

ALTER TABLE Direcciones_CLEAN
ADD tipo_numero NVARCHAR(30);

select top 10000* from Direcciones_CLEAN
---1,626,596
