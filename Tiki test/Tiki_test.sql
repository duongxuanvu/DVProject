-- SELECT * FROM xtable
GO
--Question 1: table xtable, ytable
--a. write a query to find the best seller by each category
WITH CTE1 AS 
(
SELECT SellerID, 
        Category, 
        Sales, 
        rank() OVER (PARTITION BY Category ORDER BY Sales DESC) as rank
FROM xtable
)
SELECT * FROM CTE1 
WHERE rank = 1
-- b. write a sql query to find of 3 best sellers in a. how many award did they received in 2017
WITH CTE2 AS 
(
SELECT SellerID, 
        Category, 
        Sales, 
        rank() OVER (PARTITION BY Category ORDER BY Sales DESC) as rank
FROM xtable
),
CTE3 AS(
SELECT * FROM CTE2
WHERE rank = 1
),
CTE4 AS(
SELECT Seller_ID, Count (Seller_ID) as "Award in 2017"
FROM ytable
WHERE Award_Year = 2017
GROUP BY Seller_ID
)
SELECT CTE3.SellerID,CTE3.Category,CTE4."Award in 2017" FROM CTE4
INNER JOIN CTE3
ON CTE3.SellerID = CTE4.Seller_ID
-- Question 2: table product_history.csv
--a. Write a SQl query to find the number of product that were available for sale at the end of each month
--SELECT TOP(10)* FROM product_history
WITH CTE5 AS (
SELECT *,
        concat(Year(date),'/',month(date)) as YM
       --product_id,
       --SUM(stock) as stock --OVER (PARTITION BY concat(Year(date),month(date))
       --order by concat(Year(date),month(date))
       --range between unbounded preceding and current row)
from product_history
WHERE product_status = 'On'
)
SELECT YM, 
        SUM(stock) as stock
from CTE5
GROUP BY YM
--b. Average stock is calculated as: Total stock in a month/ total date in a month. Write a SQL query to find Product ID with the most “average stock” by month.
--SELECT TOP(10)* FROM product_history
WITH CTE5 AS (
SELECT *,
        concat(Year(date),'/',month(date)) as YM,
        DAY(EOMONTH(date)) as a
from product_history
WHERE product_status = 'On'
)
,CTE6 AS(
SELECT YM,product_id,a,
    SUM(stock) as sum
from CTE5
GROUP BY YM,product_id,a
)
,CTE7 AS(
SELECT YM,
       product_id,
       sum/a as avg,
       rank() OVER (PARTITION BY YM ORDER BY sum/a DESC) as rank
FROM CTE6)
SELECT * FROM CTE7
WHERE rank =1
