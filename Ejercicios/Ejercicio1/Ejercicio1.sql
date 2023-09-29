-- Resolucion Ejercicio 1
-- Parte 1
select TU.FUENTE_INFORMACIÓN,TU.Periodo_Admon, SUM(TU.Suma_de_VALOR_ANTES_IVA) Total from (
select * from Ejercicio1..Datos1
UNION
select * from Ejercicio1..Datos2) TU
where TU.Suma_de_VALOR_ANTES_IVA > 400000000
AND TU.FUENTE_INFORMACIÓN = 'Ejecutado'
GROUP BY TU.FUENTE_INFORMACIÓN, TU.Periodo_Admon

-- Parte 2
select * from (
select * from Ejercicio1..Datos1
UNION
select * from Ejercicio1..Datos2
) TU
where TU.NEGOCIO = 'ADMON BIENESTAR'
and TU.FUENTE_INFORMACIÓN = 'Ppto'


select FUENTE_INFORMACIÓN, Suma_de_VALOR_ANTES_IVA from (
select * from Ejercicio1..Datos1
UNION
select * from Ejercicio1..Datos2
) TU
where FUENTE_INFORMACIÓN = 'Ejecutado'


-- Consulta donde se agrupa y luego se filtra - Ejercicio 1 parte 3.
SELECT T3.* FROM
(SELECT T2.FUENTE_INFORMACIÓN, SUM(Suma_de_VALOR_ANTES_IVA) Resultado FROM 
(select T1.* from(
select * from Ejercicio1..Datos1 A
union
select * from Ejercicio1..Datos2 B) T1)T2
GROUP BY T2.FUENTE_INFORMACIÓN) T3
WHERE T3.FUENTE_INFORMACIÓN = 'Ejecutado'