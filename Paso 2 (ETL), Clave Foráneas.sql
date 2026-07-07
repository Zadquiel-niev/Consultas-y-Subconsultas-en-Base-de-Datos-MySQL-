CREATE TABLE Sales_Fact (
    Sale_ID INTEGER PRIMARY KEY AUTOINCREMENT, -- Básicamente tomo todas las columnas de la data cruda de kaggle
    Order_ID TEXT NOT NULL,                   -- y las meto en una nueva tabla con nuevos parametros y claves foráneas
    Order_Date TEXT,                    -- ya creadas las dimensiones aqui creé la tabla de los hechos, 2 paso de ETL
    Channel TEXT,                      --  (Extract, Transform, Load)
    Amount REAL,
    Marketing_Spend REAL,
    Boxes_Shipped INTEGER,
    Price_per_Box REAL,
    Discount_Pct REAL,
    Country_ID INTEGER,
    Product_ID INTEGER,
    Salesperson_ID INTEGER,
    FOREIGN KEY (Country_ID) REFERENCES Dim_Country(Country_ID),
    FOREIGN KEY (Product_ID) REFERENCES Dim_Product(Product_ID),
    FOREIGN KEY (Salesperson_ID) REFERENCES Dim_Salesperson(Salesperson_ID)
);
