INSERT INTO Sales_Fact (
    Order_ID, Order_Date, Channel, Amount, Marketing_Spend, 
    Boxes_Shipped, Price_per_Box, Discount_Pct, -- Inserto las columnas de las nueva tabla para despues seleccionar las columnas
    Country_ID, Product_ID, Salesperson_ID  -- de la vieja tabla para despues hacer una intersecion completa y si errores para normalizar la base de datos
)
SELECT 
    C.Order_ID, C.Order_Date, C.Channel, C.Amount, C.Marketing_Spend, -- aqui seleccioné todas las columnas de la tabla cruda de kaggle
    C.Boxes_Shipped, C.Price_per_Box, C.Discount_Pct,  -- por eso tienen un c al principio indicando que vienen de lo crudo antes de cruzarlo
    Pai.Country_ID,
    Pro.Product_ID,
    Ven.Salesperson_ID
FROM Chocolate_Sales AS C -- aqui tomé la sigla c para indicar de donde estaba sacando las columnas
INNER JOIN Dim_Country AS Pai ON C.Country = Pai.Country_Name -- y aqui hago las intersecciones para quedarme con la data normalizada y lista para ejecutarse
INNER JOIN Dim_Product AS Pro ON C.Product = Pro.Product_Name 
INNER JOIN Dim_Salesperson AS Ven ON C.Salesperson = Ven.Salesperson_Name; -- con maxima eficiencia siguiendo los 4 pasos para un buen ETL..
