SELECT 
Pai.Country_Name AS Pais,
SUM(S.Amount) AS Ventas_Totales,
SUM(S.Marketing_Spend) AS Marketing_Invertido,

(SUM(S.Amount) - SUM(Marketing_Spend)) AS Margen_Bruto, -- Esto es un Margen Bruto, faltan costos fijos, Costos de producción, operativos, etc etc

 -- Calculamos qué porcentaje de las ventas se lo está devorando la publicidad
 
    ROUND((SUM(S.Marketing_Spend) / SUM(S.Amount)) * 100, 2) AS Porcentaje_Costo_Marketing
	
FROM Sales_Fact AS S  -- De donde saqué los datos

INNER JOIN Dim_Country AS Pai ON S.Country_ID = Pai.Country_ID  -- Hago un inner join para traer los nombres de los paises
                                                           -- y no que quede el pais por numero, 1,2,3 sino que tenga su respectivo nombre país
GROUP BY Pai.Country_Name   -- Los agrupo por el nombre del país alfabeticamente

ORDER BY Margen_Bruto DESC; -- y los ordeno del margen bruto mayor al menor

-- Ahora veremos si Australia genera tanto dinero porque vende el chocolate carísimo o porque vende toneladas de cajas

-- Precio Premium vs Volumen de ventas 
