DELETE FROM Chocolate_Sales 
WHERE Order_ID IS NULL 
   OR Product IS NULL
   OR Country IS NULL
   OR Channel IS NULL
   OR Salesperson IS NULL 
   OR Order_Date IS NULL 
   OR Discount_Pct IS NULL 
   OR Price_per_Box IS NULL
   OR Marketing_Spend IS NULL
   OR Boxes_Shipped IS NULL
   OR Amount IS NULL;
