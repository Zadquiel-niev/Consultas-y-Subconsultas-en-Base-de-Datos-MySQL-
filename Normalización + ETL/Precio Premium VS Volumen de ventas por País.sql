SELECT
Pai.Country_Name AS Pais,

ROUND(AVG(S.Price_per_Box), 2) AS Precio_Promedio_Caja,  --Redondeo y saco el promedio del precio por caja
 
SUM(S.Boxes_Shipped) AS Total_Cajas_Vendidas,  -- Hago una sumatoria del total de cajas enviadas

(SUM(S.Amount) - SUM(S.Marketing_Spend)) AS Margen_Bruto -- Operacion igual del Margen bruto (total ganado - total invertido)
 
FROM Sales_Fact AS S -- de donde saco los datos, con su respectiva sigla

INNER JOIN Dim_Country AS Pai ON S.Country_ID = Pai.Country_ID  -- interseccion de nombres de los paises para que no aparezca un numero auto-incrementandose

GROUP BY Pai.Country_Name -- Agrupo por pais y luego lo ordeno del mayor margen bruto, al menot margen bruto.

ORDER BY Margen_Bruto DESC;

-- HALLAZGO CLAVE: Australia es el rey indiscutible de la empresa.

-- Venden como unos animales (11.4 millones de cajas, el volumen más alto) 
-- y con un precio jodidamente alto por caja ($5.92 promedio, el segundo más caro). 
-- Es el mercado más lucrativo: genera cerca de 32.7 millones de dólares en puro chocolate. 

-- OJO, Es un Margen Bruto comercial. Para saber la ganancia 100% neta libre,
-- falta restarle el pocotón de variables operativas (envíos, producción, nóminas e impuestos).
-- Pero aun con eso, Australia produce demasiado dinero, una absoluta belleza de mercado....