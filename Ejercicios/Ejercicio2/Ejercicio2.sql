/*
En resumen, este script combina datos de casos y muertes relacionados con COVID-19 de dos tablas diferentes, utilizando la columna "Llave" 
como punto de unión, y luego muestra los resultados ordenados por el código de país. Esto permite analizar la evolución de casos y muertes 
por COVID-19 en diferentes países y regiones.
*/
select T1.Date_reported,T1.Country_code, T1.Country, T1.WHO_region,T1.New_cases, T1.Cumulative_cases, T2.New_deaths, T2.Cumulative_deaths from (
select C.* ,CONCAT(C.Date_reported, C.Country) Llave from Ejercicio2..Covid_casos C) T1
left JOIN (
select M.* , CONCAT(M.Date_reported, M.Country) Llave from Ejercicio2..Covid_muertes M) T2
ON T1.Llave = T2.Llave
ORDER BY T1.Country_code asc
