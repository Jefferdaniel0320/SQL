-- Ejercicio 5
-- Cargar archivos planos (Prod_Cantidad, Descuento, Dirección, Nombre, Precio)

select * from pruebabd..Prod_Cantidad
select * from pruebabd..Prod_Precio
select * from pruebabd..Prod_Nombre
select * from pruebabd..Prod_Dirección
select * from pruebabd..Prod_Descuento

-- Cargar tabla Prod_Cantidad y agrupar por fecha y id_producto
select fecha, ID_Producto, sum(Cantidad) Total from pruebabd..Prod_Cantidad
GROUP BY Fecha, ID_Producto -- Este es obligatorio cuando se agrupa.

-- Cruzar para obtener precio y calcular ganancia (Cantidad * Precio)
select T1.*,T2.Precio, T1.Total*T2.Precio Ganancia from -- Aca seleccionamos las colunas que queremos visualizar en el JOIN y las operaciones entre col
(
select fecha, ID_Producto, sum(Cantidad) Total from pruebabd..Prod_Cantidad
GROUP BY Fecha, ID_Producto
) T1

LEFT JOIN (
select * from pruebabd..Prod_Precio) T2 -- Segunda tabla del JOIN
ON T1.ID_Producto = T2.ID_Producto -- Match

-- Cruzar para obtener nombre de producto
select T1_nombre.*, T2_nombre.Nombre_Producto from  -- Segundo JOIN T1_nombre
(
select T1.*,T2.Precio, T1.Total*T2.Precio Ganancia from
(
select fecha, ID_Producto, sum(Cantidad) Total from pruebabd..Prod_Cantidad
GROUP BY Fecha, ID_Producto
) T1
LEFT JOIN (
select * from pruebabd..Prod_Precio) T2
ON T1.ID_Producto = T2.ID_Producto
) T1_nombre
LEFT JOIN (
select * from pruebabd..Prod_Nombre) T2_nombre
ON T1_nombre.ID_Producto = T2_nombre.ID_Producto

-- Cruzar para obtener dirección
select T1_direccion.*, T2_direccion.Dirección from 
(
select T1_nombre.*, T2_nombre.Nombre_Producto from 
(
select T1.*,T2.Precio, T1.Total*T2.Precio Ganancia from
(
select fecha, ID_Producto, sum(Cantidad) Total from pruebabd..Prod_Cantidad
GROUP BY Fecha, ID_Producto
) T1
LEFT JOIN (
select * from pruebabd..Prod_Precio) T2
ON T1.ID_Producto = T2.ID_Producto
) T1_nombre
LEFT JOIN (
select * from pruebabd..Prod_Nombre) T2_nombre
ON T1_nombre.ID_Producto = T2_nombre.ID_Producto
) T1_direccion
LEFT JOIN (
select * from pruebabd..Prod_Dirección) T2_direccion
ON T1_direccion.ID_Producto = T2_direccion.ID_Producto

-- Hacer consulta sobre la tabla descuento, agrupar por id producto y sacar promedio de columna descuento.
select ID_Producto, AVG(Descuento) PromDescuesto from pruebabd..Prod_Descuento
GROUP BY ID_Producto

-- Cruzar con tabla descuento (Paso anterior) y calcular precio final (Precio * Descuento)
select T1_descuento.*, T2_descuento.PromDescuesto, T1_descuento.Ganancia*T2_descuento.PromDescuesto  PrecioFinal from
(
select T1_direccion.*, T2_direccion.Dirección from
(
select T1_nombre.*, T2_nombre.Nombre_Producto from 
(
select T1.*,T2.Precio, T1.Total*T2.Precio Ganancia from
(
select fecha, ID_Producto, sum(Cantidad) Total from pruebabd..Prod_Cantidad
GROUP BY Fecha, ID_Producto
) T1
LEFT JOIN (
select * from pruebabd..Prod_Precio) T2
ON T1.ID_Producto = T2.ID_Producto
) T1_nombre
LEFT JOIN (
select * from pruebabd..Prod_Nombre) T2_nombre
ON T1_nombre.ID_Producto = T2_nombre.ID_Producto
) T1_direccion
LEFT JOIN (
select * from pruebabd..Prod_Dirección) T2_direccion
ON T1_direccion.ID_Producto = T2_direccion.ID_Producto
) T1_descuento
LEFT JOIN (
select ID_Producto, AVG(Descuento) PromDescuesto from pruebabd..Prod_Descuento
GROUP BY ID_Producto
) T2_descuento
ON T1_descuento.ID_Producto = T2_descuento.ID_Producto

-- Unir con tabla con información 2022
select T1_descuento.Fecha, T1_descuento.ID_Producto, T1_descuento.Total Cantidad, T1_descuento.Precio, T1_descuento.Nombre_Producto, T1_descuento.Dirección, T1_descuento.Ganancia*T2_descuento.PromDescuesto Final from
(
select T1_direccion.*, T2_direccion.Dirección from
(
select T1_nombre.*, T2_nombre.Nombre_Producto from 
(
select T1.*,T2.Precio, T1.Total*T2.Precio Ganancia from
(
select fecha, ID_Producto, sum(Cantidad) Total from pruebabd..Prod_Cantidad
GROUP BY Fecha, ID_Producto
) T1
LEFT JOIN (
select * from pruebabd..Prod_Precio) T2
ON T1.ID_Producto = T2.ID_Producto
) T1_nombre
LEFT JOIN (
select * from pruebabd..Prod_Nombre) T2_nombre
ON T1_nombre.ID_Producto = T2_nombre.ID_Producto
) T1_direccion
LEFT JOIN (
select * from pruebabd..Prod_Dirección) T2_direccion
ON T1_direccion.ID_Producto = T2_direccion.ID_Producto
) T1_descuento
LEFT JOIN (
select ID_Producto, AVG(Descuento) PromDescuesto from pruebabd..Prod_Descuento
GROUP BY ID_Producto
) T2_descuento
ON T1_descuento.ID_Producto = T2_descuento.ID_Producto
UNION
select * from pruebabd..Info_2022

-- Crear vista de esta consulta (Create View "Nombre_vista" As "Consulta")

CREATE VIEW vw_ventas_Producto AS
select T1_descuento.Fecha, T1_descuento.ID_Producto, T1_descuento.Total Cantidad, T1_descuento.Precio, T1_descuento.Nombre_Producto, T1_descuento.Dirección, T1_descuento.Ganancia*T2_descuento.PromDescuesto Final from
(
select T1_direccion.*, T2_direccion.Dirección from
(
select T1_nombre.*, T2_nombre.Nombre_Producto from 
(
select T1.*,T2.Precio, T1.Total*T2.Precio Ganancia from
(
select fecha, ID_Producto, sum(Cantidad) Total from pruebabd..Prod_Cantidad
GROUP BY Fecha, ID_Producto
) T1
LEFT JOIN (
select * from pruebabd..Prod_Precio) T2
ON T1.ID_Producto = T2.ID_Producto
) T1_nombre
LEFT JOIN (
select * from pruebabd..Prod_Nombre) T2_nombre
ON T1_nombre.ID_Producto = T2_nombre.ID_Producto
) T1_direccion
LEFT JOIN (
select * from pruebabd..Prod_Dirección) T2_direccion
ON T1_direccion.ID_Producto = T2_direccion.ID_Producto
) T1_descuento
LEFT JOIN (
select ID_Producto, AVG(Descuento) PromDescuesto from pruebabd..Prod_Descuento
GROUP BY ID_Producto
) T2_descuento
ON T1_descuento.ID_Producto = T2_descuento.ID_Producto
UNION
select * from pruebabd..Info_2022

-- Para el siguiente cuestionario generar las consultas necesarias para obtener la siguiente información:
-- Total de ventas de Buzos en año 2022 y 2023 y cantidad.
select Fecha, SUM(Cantidad) Total, Nombre_Producto, SUM(Final) from pruebabd..vw_ventas_Producto
where Nombre_Producto = 'Buzos'
GROUP BY Fecha, Nombre_Producto

-- Total de ventas por año (Funcion: YEAR(Date)) y cantidad
select YEAR(Fecha) Año, SUM(Cantidad) Cantidad, SUM(Final) Final from vw_ventas_Producto
GROUP BY YEAR(Fecha)

-- Cantidad de productos por año Organizado por nombre de producto y año (Utilizar función Order By (Columnas) después de Group By)
select YEAR(Fecha) Año, Nombre_Producto, SUM(Cantidad) Cantidad from vw_ventas_Producto
GROUP BY YEAR(Fecha), Nombre_Producto
ORDER BY Año, Nombre_Producto

-- Total ventas por dirección por año.
select YEAR(Fecha) Año, Dirección, SUM(Final) Final from vw_ventas_Producto
GROUP BY YEAR(Fecha), Dirección
ORDER BY Año, Dirección
