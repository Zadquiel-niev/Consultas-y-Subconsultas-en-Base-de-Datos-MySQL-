CREATE TABLE Dim_Country (
    Country_ID INTEGER PRIMARY KEY AUTOINCREMENT, --Dimension 1, Países
    Country_Name TEXT NOT NULL UNIQUE
);

INSERT INTO Dim_Country (Country_Name)
SELECT DISTINCT Country FROM Chocolate_Sales;


CREATE TABLE Dim_Product (
    Product_ID INTEGER PRIMARY KEY AUTOINCREMENT, -- Dimensión 2, Productos
    Product_Name TEXT NOT NULL UNIQUE
);

INSERT INTO Dim_Product (Product_Name)
SELECT DISTINCT Product FROM Chocolate_Sales;


CREATE TABLE Dim_Salesperson (
    Salesperson_ID INTEGER PRIMARY KEY AUTOINCREMENT, -- Dimensión 3, Vendedores
    Salesperson_Name TEXT NOT NULL UNIQUE
);

INSERT INTO Dim_Salesperson (Salesperson_Name)
SELECT DISTINCT Salesperson FROM Chocolate_Sales;
