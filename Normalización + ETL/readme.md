# 🍫 Pipeline de ETL & Normalización Relacional: Chocolate Sales

Este proyecto implementa un pipeline completo de **ETL (Extract, Transform, Load)** y la optimización arquitectónica de una base de datos de venta de chocolates a nivel global (con un volumen inicial de **200,000 registros**). El objetivo fue erradicar la redundancia de datos, limpiar inconsistencias y extraer hallazgos comerciales de alto impacto.

---

## 🛠️ El Proceso ETL & Normalización (Paso a Paso)

### 📤 1. Extracción (Extract)
La materia prima del proyecto se extrajo de un set de datos masivo desnormalizado hospedado en **Kaggle** (`Chocolate_Sales.csv`). El archivo original contenía transacciones repetitivas combinando datos geográficos, de inventario, financieros y de personal en una sola tabla gigante, lo que generaba un alto costo de almacenamiento en disco.

### 🔄 2. Transformación & Limpieza (Transform)
Antes de estructurar los datos, realizamos una auditoría inicial de calidad de datos (*Data Profiling*) detectando **1,603 filas con registros vacíos**. 

Aplicamos mano dura mediante un filtro lógico estricto para depurar la base de datos de variables corruptas. Al evaluar estadísticamente sobre la población de 200,000 registros, determinamos que la pérdida representaba menos del 1% del set de datos, manteniendo la distribución normal de la muestra sin alterar ni sesgar las medias comerciales:

```sql
DELETE FROM Chocolate_Sales 
WHERE Order_ID IS NULL OR Product IS NULL OR Country IS NULL 
   OR Channel IS NULL OR Salesperson IS NULL OR Order_Date IS NULL 
   OR Discount_Pct IS NULL OR Price_per_Box IS NULL 
   OR Marketing_Spend IS NULL OR Boxes_Shipped IS NULL OR Amount IS NULL;
```

---

## 📐 Arquitectura del Modelo Relacional (Formas Normales)

Para eliminar la redundancia de texto y optimizar el rendimiento de la memoria y el almacenamiento, aplicamos las leyes de normalización dividiendo la tabla gigante en 3 tablas de dimensiones (catálogos únicos) y 1 tabla reina de hechos en singular.

### 📦 PASO 1: Crear e Insertar las Dimensiones (Catálogos Únicos)
Construimos pasillos lógicos independientes utilizando la restricción `UNIQUE` para asegurar que cada entidad exista una sola vez en el sistema, inyectando los datos únicos con `SELECT DISTINCT`:

*   **`Dim_Country`**: Catálogo único de los 5 países destino.
*   **`Dim_Product`**: Catálogo de los tipos de chocolates del portafolio.
*   **`Dim_Salesperson`**: Catálogo con el registro del equipo de vendedores.

### 🧾 PASO 2: Crear la Tabla de Hechos (`Sales_Fact`)
Diseñamos el plano de la factura central vacía. Esta estructura elimina el texto repetido y lo reemplaza por métricas numéricas decimales (`REAL`) y enteros (`INTEGER`), enlazando el sistema mediante cables relacionales de integridad referencial (**`FOREIGN KEY`**) perfectamente alineados en singular:

```sql
CREATE TABLE Sales_Fact (
    Sale_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Order_ID TEXT NOT NULL,
    Order_Date TEXT,
    Channel TEXT,
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
```

### 📥 PASO 3: Carga Inteligente (El Corazón del ETL)
Activamos un sistema de carga masiva traduciendo el texto crudo de la tabla original de Kaggle a las llaves numéricas dinámicas de los nuevos catálogos en singular a través de un triple `INNER JOIN`:

```sql
INSERT INTO Sales_Fact (Order_ID, Order_Date, Channel, Amount, Marketing_Spend, Boxes_Shipped, Price_per_Box, Discount_Pct, Country_ID, Product_ID, Salesperson_ID)
SELECT C.Order_ID, C.Order_Date, C.Channel, C.Amount, C.Marketing_Spend, C.Boxes_Shipped, C.Price_per_Box, C.Discount_Pct, Pai.Country_ID, Pro.Product_ID, Ven.Salesperson_ID
FROM Chocolate_Sales AS C
INNER JOIN Dim_Country AS Pai ON C.Country = Pai.Country_Name
INNER JOIN Dim_Product AS Pro ON C.Product = Pro.Product_Name
INNER JOIN Dim_Salesperson AS Ven ON C.Salesperson = Ven.Salesperson_Name;
```
*   **Resultado de Carga:** **198,397 filas afectadas y migradas con éxito en solo 501 milisegundos.**

### 🗑️ PASO 4: La Purga Final
Una vez verificado que toda la información relacional quedó engranada en la tabla reina, eliminamos de forma definitiva la tabla cruda original para liberar espacio en el disco duro:
```sql
DROP TABLE Chocolate_Sales;
```

---

## 📊 Operaciones Analíticas & Hallazgos de Negocio

Para extraer el verdadero valor de los datos normalizados, realizamos consultas cruzadas aplicando lógica de conjuntos e intersecciones a través de `INNER JOIN`.

### 💵 1. Rendimiento Comercial e Inversión de Marketing por País
Evaluamos qué parte de los ingresos brutos se está devorando el presupuesto de publicidad usando una regla de tres redondeada (`ROUND`):

| País | Ventas Totales ($) | Inversión Marketing ($) | Margen Bruto ($) | % Costo Marketing |
| :--- | :---: | :---: | :---: | :---: |
| **Australia** | 41,512,407.39 | 8,754,072.62 | **32,758,334.76** | **21.09%** |
| **Brazil** | 35,736,753.21 | 5,031,163.68 | **30,705,589.52** | **14.05%** |
| **Germany** | 11,111,515.25 | 2,388,065.22 | **8,723,449.02** | **21.49%** |
| **India** | 6,352,956.46 | 1,660,835.51 | **4,692,120.94** | **26.14%** |
| **Japan** | 5,520,545.13 | 1,193,025.40 | **4,327,519.72** | **21.61%** |

*   **Análisis Crítico:** **Brasil** es un titán comercial extremadamente eficiente; requiere solo un **14.05%** de inversión en publicidad para sostener su operación masiva. En contraste, **India** es el mercado menos eficiente con diferencia, devorándose un altísimo **26.14%** de sus ingresos solo en marketing.

---

### 📈 2. Matriz de Precio Premium vs. Volumen de Ventas
Cruzamos el precio promedio cobrado por caja con el volumen físico total de mercancía despachada:

| País | Precio Promedio Caja ($) | Total Cajas Vendidas | Margen Bruto Comercial ($) |
| :--- | :---: | :---: | :---: |
| **Australia** | **5.92** | **11,420,804** | **32,758,334.76** |
| **Brazil** | 5.09 | 9,921,533 | 30,705,589.52 |
| **Germany** | 5.93 | 3,073,359 | 8,723,449.02 |
| **India** | 5.91 | 1,747,177 | 4,692,120.94 |
| **Japan** | 5.88 | 1,525,532 | 4,327,519.72 |

#### 🧠 Conclusión Definitiva del Analista:
*   **Australia es el rey indiscutible de la empresa:** Venden como unos animales (11.4 millones de cajas, el volumen más alto de todos los países por amplia ventaja) y logran sostener un precio jodidamente alto por caja ($5.92 promedio, el segundo más caro del portafolio global, casi empatado con el precio de nicho de Alemania de $5.93). Es el mercado más lucrativo, metiendo cerca de 32.7 millones de dólares en la caja comercial.
*   **OJO**, Cabe destacar que esto representa el Margen Bruto comercial, Para saber la ganancia 100% neta libre de la empresa, el modelo requerirá que se le reste en el futuro el pocotón de variables operativas de manufactura y distribución (costos de envío, producción de empaques, materia prima de cacao/azúcar, pagos de nómina e impuestos). Pero aun con esa advertencia, Australia produce demasiado dinero, una absoluta belleza de mercado..
