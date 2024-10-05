-- Total number of cars sold by year
SELECT year, COUNT(*) AS Total_cars_sold
FROM car_prices
GROUP BY year
ORDER BY year;

-- Most cars sold by make
SELECT TOP 10 make, COUNT(*) AS Total_Cars_Sold
FROM car_prices
GROUP BY make
ORDER BY Total_Cars_Sold DESC;

-- Car make with the most revenue
SELECT TOP 10 make, 
       FORMAT(SUM(sellingprice), 'N0') AS Total_Make_Revenue
FROM car_prices
GROUP BY make
ORDER BY SUM(sellingprice) DESC;

-- Ranking of total Sales
SELECT make, 
       FORMAT(SUM(sellingprice), 'N0') AS Total_Make_Revenue
FROM car_prices
GROUP BY make
ORDER BY SUM(sellingprice) DESC;

-- Most common car make and model sold
SELECT TOP 10 make, model, COUNT(*) AS Total_Sales
FROM car_prices
GROUP BY make, model
HAVING make IS NOT NULL
ORDER BY total_sales DESC;

-- Cars make and model with most total sales
SELECT TOP 10 make, model, SUM(sellingprice) AS Total_Sales
FROM car_prices
GROUP BY make, model
HAVING make IS NOT NULL
ORDER BY Total_Sales DESC;

-- Most expensive car make
SELECT make, AVG(sellingprice) AS Most_Expensive_Make
FROM car_prices
GROUP BY make
ORDER BY Most_Expensive_Make DESC;

-- Most expensive car make and model
SELECT make, model, AVG(sellingprice) AS Most_Expensive_Make_Model
FROM car_prices
GROUP BY make, model
ORDER BY Most_Expensive_Make_Model DESC;

-- Highest Selling Price by Make and Model
SELECT make, model, MAX(sellingprice) AS Max_Selling_Price
FROM car_prices
GROUP BY make, model
ORDER BY Max_Selling_Price DESC;

-- Most Popular Body Type by Year
-- Ordered by year
SELECT year, body, COUNT(*) AS total
FROM car_prices
GROUP BY year, body
HAVING body IS NOT NULL
ORDER BY year, total DESC;

-- Ordered by year
SELECT year, body, COUNT(*) AS total
FROM car_prices
GROUP BY year, body
HAVING body IS NOT NULL
ORDER BY body, total DESC;

-- Most common exterior color
SELECT color, COUNT(*) AS Total
FROM car_prices
GROUP BY color
HAVING color IS NOT NULL
ORDER BY total DESC

-- Most common interior color
SELECT interior, COUNT(*) AS Total
FROM car_prices
GROUP BY interior
HAVING interior IS NOT NULL
ORDER BY total DESC

-- Average selling price by exterior color
SELECT color, AVG(sellingprice) AS avg_selling_price
FROM car_prices
GROUP BY color
HAVING color IS NOT NULL
ORDER BY avg_selling_price DESC;

-- Average selling price by interior Color
SELECT interior, AVG(CAST(sellingprice AS BIGINT)) AS avg_selling_price
FROM car_prices
GROUP BY interior
HAVING interior IS NOT NULL
ORDER BY avg_selling_price DESC;

-- Average selling price based on car condition
SELECT car_condition, AVG(sellingprice) AS avg_selling_price
FROM car_prices
GROUP BY car_condition
HAVING car_condition IS NOT NULL
ORDER BY car_condition;

-- Which car condition has the highest selling average price
SELECT car_condition, AVG(sellingprice) AS avg_selling_price
FROM car_prices
GROUP BY car_condition
HAVING car_condition IS NOT NULL
ORDER BY avg_selling_price DESC;

-- Average Selling Price by Condition Category
-- Group the condition into categories (Excellent, Good, Fair, etc.) and calculates the average selling price.
-- Find the range first
SELECT
    MIN(car_condition) AS min_condition,
    MAX(car_condition) AS max_condition,
    MAX(car_condition) - MIN(car_condition) AS condition_range
FROM car_prices;

-- Assign a label
SELECT
    CASE 
        WHEN car_condition >= 40 THEN 'Excellent'
		WHEN car_condition >= 30 THEN 'Good'
		WHEN car_condition >= 20 THEN 'Fair'
		ELSE 'Poor'
    END AS condition_category,
    AVG(CAST(sellingprice AS BIGINT)) AS avg_selling_price
FROM car_prices
GROUP BY
    CASE 
        WHEN car_condition >= 40 THEN 'Excellent'
		WHEN car_condition >= 30 THEN 'Good'
		WHEN car_condition >= 20 THEN 'Fair'
		ELSE 'Poor'
    END
ORDER BY avg_selling_price DESC;

-- States with highest sales totals
SELECT state, SUM(sellingprice) AS total_sales
FROM car_prices
GROUP BY state
ORDER BY total_sales DESC;

-- States with lowest sales totals
SELECT state, SUM(sellingprice) AS total_sales
FROM car_prices
GROUP BY state
ORDER BY total_sales ASC;

-- States with the highest average selling price
SELECT TOP 10 state, AVG(sellingprice) AS Average_Sales
FROM car_prices
GROUP BY state
ORDER BY Average_Sales DESC;

-- States with the lowest average selling price
SELECT TOP 10 state, AVG(sellingprice) AS Average_Sales
FROM car_prices
GROUP BY state
ORDER BY Average_Sales ASC;

-- Top 10 Makes with the Highest Average Selling Price for Sedans
SELECT TOP 10 make, AVG(sellingprice) AS avg_selling_price
FROM car_prices
WHERE body = 'Sedan'
GROUP BY make
ORDER BY avg_selling_price DESC;

-- Average Selling Price Based on Exterior/Interior Color Combinations
SELECT color, interior, AVG(sellingprice) AS avg_selling_price
FROM car_prices
GROUP BY color, interior
ORDER BY avg_selling_price DESC;

-- Impact of Body Type on Sales Volume and Selling Price
SELECT body, COUNT(*) AS total_sales, AVG(CAST(sellingprice AS BIGINT)) AS avg_selling_price
FROM car_prices
GROUP BY body
ORDER BY total_sales DESC, avg_selling_price DESC;

-- Distribution of car conditions based on odometer readings
SELECT car_condition, AVG(CAST(ISNULL(odometer, 0) AS BIGINT)) AS avg_odometer
FROM car_prices
GROUP BY car_condition
ORDER BY car_condition;

-- Ordered from highest avg_odometer
SELECT car_condition, AVG(CAST(ISNULL(odometer, 0) AS BIGINT)) AS avg_odometer
FROM car_prices
GROUP BY car_condition
ORDER BY avg_odometer DESC;

-- Average Odometer Reading by Year and Make
SELECT year, make, AVG(odometer) AS avg_odometer
FROM car_prices
GROUP BY year, make
HAVING make IS NOT NULL
ORDER BY year, avg_odometer;

-- Price Difference Between Manual and Automatic Transmission
SELECT transmission, AVG(CAST(sellingprice AS BIGINT)) AS avg_selling_price
FROM car_prices
GROUP BY transmission
ORDER BY avg_selling_price DESC;

-- Average total car sale by transmission type
SELECT transmission, AVG(CAST(sellingprice AS BIGINT)) AS avg_selling_price
FROM car_prices
GROUP BY transmission
ORDER BY avg_selling_price DESC;

-- Distribution of cars by transmission type
WITH transmission_counts AS (
    SELECT transmission, 
           COUNT(*) AS transmission_count,
           AVG(CAST(sellingprice AS BIGINT)) AS avg_selling_price
    FROM car_prices
    GROUP BY transmission
)
SELECT transmission, 
       transmission_count, 
       avg_selling_price,
       (transmission_count * 100.0) / (SELECT COUNT(*) FROM car_prices) AS percentage
FROM transmission_counts
ORDER BY avg_selling_price DESC;

--  Correlation between MMR values and actual selling prices
SELECT make, 
       (AVG(CAST(sellingprice AS BIGINT)) - AVG(CAST(mmr AS BIGINT))) AS price_difference
FROM car_prices
GROUP BY make
ORDER BY price_difference DESC;

-- Top 10 Cars with the Highest Price-to-Odometer Ratio
-- highest selling price per mile driven.
SELECT TOP 10 make, model, sellingprice, odometer, (sellingprice / odometer) AS price_per_mile
FROM car_prices
WHERE odometer > 0
ORDER BY price_per_mile DESC;

-- Average MMR Deviation by Car Make
SELECT make, AVG(sellingprice - mmr) AS avg_mmr_deviation
FROM car_prices
GROUP BY make
ORDER BY avg_mmr_deviation DESC;

-- Cars with the Highest MMR Deviation by Seller
WITH seller_price_deviation AS (
    SELECT seller, vin, make, model, (sellingprice - mmr) AS price_deviation
    FROM car_prices
)
SELECT seller, vin, make, model, price_deviation
FROM (
    SELECT seller, vin, make, model, price_deviation,
           ROW_NUMBER() OVER (PARTITION BY seller ORDER BY price_deviation DESC) AS rank
    FROM seller_price_deviation
) AS ranked_seller_deviation
WHERE rank = 1
ORDER BY price_deviation DESC;

-- Cars Sold by Seller and Total Sales Amount
SELECT seller, COUNT(*) AS total_cars_sold, SUM(sellingprice) AS total_sales
FROM car_prices
GROUP BY seller
ORDER BY total_sales DESC;

-- Best performing seller in each state by total sales revenue
WITH state_seller_revenue AS (
    SELECT state, seller, SUM(sellingprice) AS total_revenue
    FROM car_prices
    GROUP BY state, seller
)
SELECT state, seller, total_revenue
FROM (
    SELECT state, seller, total_revenue,
           ROW_NUMBER() OVER (PARTITION BY state ORDER BY total_revenue DESC) AS rank
    FROM state_seller_revenue
) AS ranked_sellers
WHERE rank = 1;

-- Cars with High Odometer and Low Selling Price for Potential Deals
SELECT make, model, odometer, sellingprice
FROM car_prices
WHERE CAST(odometer AS BIGINT) > (SELECT AVG(CAST(odometer AS BIGINT)) FROM car_prices) 
  AND CAST(sellingprice AS BIGINT) < (SELECT AVG(CAST(sellingprice AS BIGINT)) FROM car_prices)
ORDER BY sellingprice ASC;

-- Analysis of Car Sales with Odd Price Deviations (Outliers)
-- This query detects outliers where the selling price is either significantly higher or lower than the MMR value.
SELECT vin, make, model, sellingprice, mmr, 
       ABS(sellingprice - mmr) AS deviation,
       CASE 
           WHEN sellingprice > mmr THEN 'Overpriced'
           ELSE 'Underpriced'
       END AS price_category
FROM car_prices
WHERE ABS(sellingprice - mmr) > (SELECT AVG(ABS(sellingprice - mmr)) FROM car_prices)
ORDER BY deviation DESC;

-- Percentage of cars sold above MMR value
SELECT 
    (COUNT(CASE WHEN sellingprice > mmr THEN 1 END) * 100.0) / COUNT(*) AS percent_above_mmr
FROM car_prices;

-- Total Cars Sold and Revenue Generated by Year and State
SELECT year, state, COUNT(*) AS total_cars_sold, SUM(sellingprice) AS total_revenue
FROM car_prices
GROUP BY year, state
ORDER BY year, total_cars_sold DESC;

-- Average Price Change Over Time by Make and Model
-- All values including NULL values
WITH price_trend AS (
    SELECT make, model, year, AVG(sellingprice) AS avg_selling_price
    FROM car_prices
    GROUP BY make, model, year
)
SELECT make, model, year, avg_selling_price,
       LAG(avg_selling_price, 1) OVER (PARTITION BY make, model ORDER BY year) AS prev_year_price,
       (avg_selling_price - LAG(avg_selling_price, 1) OVER (PARTITION BY make, model ORDER BY year)) AS price_difference
FROM price_trend
ORDER BY make, model, year;

-- Excluding NULL values
WITH price_trend AS (
    SELECT make, model, year, AVG(sellingprice) AS avg_selling_price
    FROM car_prices
    GROUP BY make, model, year
)
SELECT make, model, year,
    avg_selling_price,
    LAG(avg_selling_price, 1) OVER (PARTITION BY make, model ORDER BY year) AS prev_year_price,
    avg_selling_price - LAG(avg_selling_price, 1) OVER (PARTITION BY make, model ORDER BY year) AS price_difference
FROM price_trend
WHERE make IS NOT NULL
ORDER BY make, model, year;

-- Cars Sold in the Last Quarter of the Year
SELECT *FROM car_prices
WHERE MONTH(CONVERT(DATE, saledate, 103)) IN (10, 11, 12);

-- Sales Performance by Month and Year
SELECT 
    YEAR(CONVERT(DATE, saledate, 103)) AS sale_year, 
    MONTH(CONVERT(DATE, saledate, 103)) AS sale_month, 
    COUNT(*) AS total_sales, 
    SUM(CAST(sellingprice AS BIGINT)) AS total_revenue
FROM car_prices
GROUP BY YEAR(CONVERT(DATE, saledate, 103)), MONTH(CONVERT(DATE, saledate, 103))
ORDER BY sale_year, sale_month;

-- Predicting Future Price Trends Using Moving Averages
WITH moving_avg AS (
    SELECT make, model, year, sellingprice,
           AVG(sellingprice) OVER (PARTITION BY make, model ORDER BY year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_price
    FROM car_prices
    WHERE make IS NOT NULL
)
SELECT make, model, year, sellingprice, moving_avg_price
FROM moving_avg
ORDER BY make, model, year;