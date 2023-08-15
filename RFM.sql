SELECT top (10)* from  dbo.SuperStoreSales_Whole
SELECT * from  dbo.segment_scores
GO
WITH CTE1 as(
    SELECT Customer_Name, Datediff(day,max(Order_Date),CONVERT(DATE,GETDATE())) as Recency,
            COUNT(Order_Date) as Frequency,
            ROUND(SUM(Sales),0) as Monetery
    FROM dbo.SuperStoreSales_Whole 
    Group BY Customer_Name
),
RFM_Score as(
    SELECT *,
    NTILE(5) OVER (Order by Recency desc ) as R_Score,
    NTILE(5) OVER (Order by Frequency asc ) as F_Score,
    NTILE(5) OVER (Order by Monetery asc ) as M_Score
    FROM CTE1
),
RFM_Final AS(
    SELECT *, CONCAT(R_Score,F_Score,M_Score) as Score_final
    FROM RFM_Score
)
SELECT rf.*, sc.segment 
FROM RFM_Final  as rf
INNER JOIN dbo.segment_scores as sc
ON rf.Score_final = sc.Scores



