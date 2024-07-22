 SELECT *
 FROM food_Prices

--- To count the total number of rows
SELECT COUNT (*) AS row_num
FROM food_Prices

----Checking for the Null Values 
SELECT *
FROM food_Prices
WHERE date IS NULL OR adm1_name IS NULL OR adm2_name IS NULL OR  loc_market_name IS NULL OR
geo_lat IS NULL OR geo_lon IS NULL OR item_type IS NULL OR item_unit IS NULL OR 
item_price_flag IS NULL OR currency IS NULL OR value IS NULL OR value_usd IS NULL;

SELECT *
FROM food_prices
WHERE adm1_name = 'Kano' AND item_name ='Millet';

---Delete the null values because it is 0.09% of my dataset
DELETE FROM food_prices
WHERE 
    date IS NULL OR
    adm1_name IS NULL OR
    adm2_name IS NULL OR
    loc_market_name IS NULL OR
    geo_lat IS NULL OR
    geo_lon IS NULL OR
    item_type IS NULL OR
    item_unit IS NULL OR
    item_price_flag IS NULL OR
    currency IS NULL OR
    value IS NULL OR
    value_usd IS NULL;
---- Change few of the columns names
EXEC sp_rename 'food_Prices.adm1_name', 'States', 'COLUMN';
EXEC sp_rename 'food_Prices.adm2_name', 'Local_Government', 'COLUMN';
EXEC sp_rename 'food_Prices.loc_market_name', 'Local_Market_Name', 'COLUMN';
EXEC sp_rename 'food_Prices.geo_lat', 'Latitude', 'COLUMN';
EXEC sp_rename 'food_Prices.geo_lon', 'Longitude', 'COLUMN';

---Unique Identifier
---The type of items 
SELECT DISTINCT(item_type)
FROM food_Prices;
---For Item Names
SELECT DISTINCT(item_name)
FROM food_Prices;
---For Item Units
SELECT DISTINCT(item_unit)
FROM food_Prices;
--Item_Price_Flag
SELECT DISTINCT(item_price_flag)
FROM food_Prices;
---item Price Type
SELECT DISTINCT(item_price_type)
FROM food_Prices;

----Number of years in the Dataset
SELECT 
    DATEDIFF(YEAR, MIN(date), MAX(date)) + 1 AS NumberOfYears
FROM 
    food_Prices;

--- Number of States
SELECT DISTINCT(states)
FROM food_Prices;

---What is the overall trend of food prices over the years in Nigeria?
SELECT 
    YEAR(date) AS Year,
    AVG(value) AS AveragePrice_NGN
FROM 
    food_Prices
GROUP BY 
    YEAR(date)
ORDER BY 
    Year;


----Which state has the highest and lowest average food prices?
SELECT States,
     AVG(Value) AS AveragePrice
FROM 
    food_prices
GROUP BY 
   States
ORDER BY 
    AveragePrice DESC;

--- What is the seasonal variation in food prices within a specific state? (Oyo State as a case study)
SELECT 
    DATEPART(QUARTER, date) AS Season,
    AVG(value) AS AveragePrice
FROM 
    food_Prices
WHERE 
    States = 'Oyo' 
GROUP BY 
    DATEPART(QUARTER, date)
ORDER BY 
    Season;

---Which item_types have shown the highest price increase over the years?
WITH PriceIncreases AS (
    SELECT 
        item_type,
        YEAR(date) AS Year,
        AVG(value) AS AveragePrice,
        LAG(AVG(value)) OVER (PARTITION BY item_type ORDER BY YEAR(date)) AS PreviousYearPrice
    FROM 
        food_Prices
    GROUP BY 
        item_type, YEAR(date)
)
SELECT 
    item_type,
    (AveragePrice - PreviousYearPrice) *100 / SUM (PreviousYearPrice) OVER () AS Price_Increase_Percentage
FROM 
    PriceIncreases
WHERE 
    PreviousYearPrice IS NOT NULL
ORDER BY 
    Price_Increase_Percentage DESC;

---How do exchange rate fluctuations affect the prices of items when converted to USD over the years?
SELECT 
    YEAR (date) AS Years,
    item_type,
    AVG(value_usd) AS AveragePriceUSD
FROM 
    food_Prices
GROUP BY 
    YEAR (date), item_type
ORDER BY 
    YEAR (date), item_type;

DELETE FROM food_Prices
WHERE YEAR(date) = 2024;

