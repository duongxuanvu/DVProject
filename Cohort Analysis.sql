USE Cohort_Retail
Go 
select top(10)* 
from dbo.[OnlineSale-2018]
GO
WITH
CTE1 as (
    SELECT Order_ID,
            Order_Date,
            Customer_ID,
            Sales,
            FORMAT(Order_Date,'yyyy-MM-01') Order_Month 
    FROM [OnlineSale-2018]
),
--select * FROM CTE1
CTE2 as (
    SELECT Customer_ID,
            FORMAT(MIN(Order_Date),'yyyy-MM-01') Cohort_month
    FROM [OnlineSale-2018]
    GROUP BY Customer_ID
),
CTE3 as (
    SELECT CTE1.*, CTE2.Cohort_month,DATEDIFF(MONTH,CAST(CTE2.Cohort_month as date),CAST(CTE1.Order_Month as date)) +1 as Cohort_index 
    FROM CTE1
    INNER Join CTE2
    ON CTE1.Customer_ID = CTE2.Customer_ID
),
--select * from CTE3
CTE4 as(
    SELECT Cohort_month,
    Order_Month,
    Cohort_index,
    count(distinct(Customer_ID)) as Count_Customer_ID
    FROM CTE3
    GROUP BY Cohort_month,Order_Month,Cohort_index
),
--select * from CTE4
CTE4_2 as(
    SELECT Cohort_month,
    Order_Month,
    Cohort_index,
    SUM(Sales) as Total_sale
    FROM CTE3
    GROUP BY Cohort_month,Order_Month,Cohort_index
),
--select * from CTE4_2
CTE5 as(
    SELECT *
    FROM(
        SELECT Cohort_month,
        Cohort_index,
        Count_Customer_ID
        FROM CTE4) p 
    PIVOT(
        Sum(Count_Customer_ID)
        For Cohort_index IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
    ) piv

)
--SELECT * FROM CTE5
SELECT Cohort_month,
        ROUND(1.0 *[1]/[1],2) as [1],
        ROUND(1.0 *[2]/[1],2) as [2],
        ROUND(1.0 *[3]/[1],2) as [3],
        ROUND(1.0 *[4]/[1],2) as [4],
        ROUND(1.0 *[5]/[1],2) as [5],
        ROUND(1.0 *[6]/[1],2) as [6],
        ROUND(1.0 *[7]/[1],2) as [7],
        ROUND(1.0 *[8]/[1],2) as [8],
        ROUND(1.0 *[9]/[1],2) as [9],
        ROUND(1.0 *[10]/[1],2) as [10],
        ROUND(1.0 *[11]/[1],2) as [11],
        ROUND(1.0 *[12]/[1],2) as [12]
FROM CTE5