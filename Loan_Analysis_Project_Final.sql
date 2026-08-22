
/* =========================================================
LOAN DATA ANALYSIS PROJECT
MySQL | Data Analyst Portfolio Project
========================================================= */


/* =========================================================
1. DATA EXPLORATION
========================================================= */

-- 1. View all loan records
SELECT *
FROM Loans;


-- 2. View all customer records
SELECT *
FROM Customers;


-- 3. Total number of loan applications
SELECT COUNT(*) AS Total_Loan_Applications
FROM Loans;


-- 4. Total number of customers
SELECT COUNT(*) AS Total_Customers
FROM Customers;

/* =========================================================
2. DATA QUALITY CHECKS
========================================================= */

-- 1. Check duplicate Loan IDs
SELECT
Loan_ID,
COUNT(*) AS Duplicate_Count
FROM Loans
GROUP BY Loan_ID
HAVING COUNT(*) > 1;


-- 2. Check missing values in Loans
SELECT
COUNT(*) AS Total_Rows,
COUNT(Loan_ID) AS Loan_ID_Filled,
COUNT(Customer_ID) AS Customer_ID_Filled,
COUNT(Loan_Amount) AS Loan_Amount_Filled,
COUNT(Interest_Rate) AS Interest_Rate_Filled,
COUNT(Loan_Status) AS Loan_Status_Filled,
COUNT(Loan_Type) AS Loan_Type_Filled
FROM Loans;


-- 3. Check invalid Loan Amounts
SELECT *
FROM Loans
WHERE Loan_Amount <= 0;


-- 4. Check invalid Interest Rates
SELECT *
FROM Loans
WHERE Interest_Rate < 0;


-- 5. Check available Loan Status values
SELECT DISTINCT
Loan_Status
FROM Loans;


-- 6. Check available Loan Type values
SELECT DISTINCT
Loan_Type
FROM Loans;


-- 7. Check Customer IDs that do not exist in Customers table
SELECT DISTINCT
l.Customer_ID
FROM Loans AS l
LEFT JOIN Customers AS c
ON l.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;


-- 8. Check invalid Credit Scores
SELECT *
FROM Customers
WHERE Credit_Score < 300
OR Credit_Score > 850;


-- 9. Check missing values in Customers
SELECT
COUNT(*) AS Total_Customers,
COUNT(Customer_ID) AS Customer_ID_Filled,
COUNT(Customer_Name) AS Customer_Name_Filled,
COUNT(Credit_Score) AS Credit_Score_Filled
FROM Customers;

/* =========================================================
3. BASIC LOAN ANALYSIS
========================================================= */

-- 1. Overall Loan Status Distribution
SELECT
Loan_Status,
COUNT(*) AS Total_Loans
FROM Loans
GROUP BY Loan_Status
ORDER BY Total_Loans DESC;


-- 2. Loan Status Distribution with Percentage
SELECT
Loan_Status,
COUNT(*) AS Total_Loans,
ROUND(
100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
2
) AS Percentage
FROM Loans
GROUP BY Loan_Status
ORDER BY Total_Loans DESC;


-- 3. Loan Type Distribution
SELECT
Loan_Type,
COUNT(*) AS Total_Loans
FROM Loans
GROUP BY Loan_Type
ORDER BY Total_Loans DESC;


-- 4. Loan Amount by Loan Type
SELECT
Loan_Type,
COUNT(*) AS Total_Loans,
SUM(Loan_Amount) AS Total_Loan_Amount,
ROUND(AVG(Loan_Amount), 2) AS Average_Loan_Amount
FROM Loans
GROUP BY Loan_Type
ORDER BY Total_Loan_Amount DESC;


-- 5. Loan Amount by Loan Status
SELECT
Loan_Status,
COUNT(*) AS Total_Loans,
SUM(Loan_Amount) AS Total_Loan_Amount,
ROUND(AVG(Loan_Amount), 2) AS Average_Loan_Amount
FROM Loans
GROUP BY Loan_Status
ORDER BY Total_Loan_Amount DESC;


-- 6. Interest Rate by Loan Status
SELECT
Loan_Status,
COUNT(*) AS Total_Loans,
ROUND(AVG(Interest_Rate), 2) AS Average_Interest_Rate,
ROUND(MIN(Interest_Rate), 2) AS Min_Interest_Rate,
ROUND(MAX(Interest_Rate), 2) AS Max_Interest_Rate
FROM Loans
GROUP BY Loan_Status
ORDER BY Average_Interest_Rate DESC;

/* =========================================================
4. CREDIT SCORE ANALYSIS
========================================================= */

-- 1. Credit Score Distribution
SELECT
CASE
WHEN Credit_Score >= 700 THEN 'High'
WHEN Credit_Score >= 650 THEN 'Medium'
ELSE 'Low'
END AS Credit_Category,
    
COUNT(*) AS Total_Customers,
ROUND(AVG(Credit_Score), 2) AS Average_Credit_Score

FROM Customers

GROUP BY
CASE
WHEN Credit_Score >= 700 THEN 'High'
WHEN Credit_Score >= 650 THEN 'Medium'
ELSE 'Low'
END

ORDER BY Average_Credit_Score DESC;


-- 2. Credit Category vs Loan Approval Rate
SELECT
CASE
WHEN c.Credit_Score >= 700 THEN 'High'
WHEN c.Credit_Score >= 650 THEN 'Medium'
ELSE 'Low'
END AS Credit_Category,

COUNT(*) AS Total_Loans,

SUM(
CASE
WHEN l.Loan_Status = 'Approved' THEN 1
ELSE 0
END
) AS Approved_Loans,

ROUND(
100.0 * SUM(
CASE
WHEN l.Loan_Status = 'Approved' THEN 1
ELSE 0
END
) / COUNT(*),
2
) AS Approval_Rate

FROM Loans AS l
JOIN Customers AS c
ON l.Customer_ID = c.Customer_ID

GROUP BY
CASE
WHEN c.Credit_Score >= 700 THEN 'High'
WHEN c.Credit_Score >= 650 THEN 'Medium'
ELSE 'Low'
END

ORDER BY Approval_Rate DESC;

/* =========================================================
5. LOAN TYPE ANALYSIS
========================================================= */

-- 1. Loan Type Approval Rate
SELECT
Loan_Type,
COUNT(*) AS Total_Loans,

SUM(
CASE
WHEN Loan_Status = 'Approved' THEN 1
ELSE 0
END
) AS Approved_Loans,

SUM(
CASE
WHEN Loan_Status = 'Rejected' THEN 1
ELSE 0
END
) AS Rejected_Loans,

ROUND(
100.0 * SUM(
CASE
WHEN Loan_Status = 'Approved' THEN 1
ELSE 0
END
) / COUNT(*),
2
) AS Approval_Rate,

ROUND(
100.0 * SUM(
CASE
WHEN Loan_Status = 'Rejected' THEN 1
ELSE 0
END
) / COUNT(*),
2
) AS Rejection_Rate

FROM Loans

GROUP BY Loan_Type

ORDER BY Approval_Rate DESC;


-- 2. Loan Amount Analysis by Loan Type
SELECT
Loan_Type,
COUNT(*) AS Total_Loans,
SUM(Loan_Amount) AS Total_Loan_Amount,
ROUND(AVG(Loan_Amount), 2) AS Average_Loan_Amount,
ROUND(MIN(Loan_Amount), 2) AS Minimum_Loan_Amount,
ROUND(MAX(Loan_Amount), 2) AS Maximum_Loan_Amount

FROM Loans

GROUP BY Loan_Type

ORDER BY Total_Loan_Amount DESC;


-- 3. Average Interest Rate by Loan Type
SELECT
Loan_Type,
COUNT(*) AS Total_Loans,
ROUND(AVG(Interest_Rate), 2) AS Average_Interest_Rate,
ROUND(MIN(Interest_Rate), 2) AS Minimum_Interest_Rate,
ROUND(MAX(Interest_Rate), 2) AS Maximum_Interest_Rate

FROM Loans

GROUP BY Loan_Type

ORDER BY Average_Interest_Rate DESC;

/* =========================================================
6. CUSTOMER ANALYSIS
========================================================= */

-- 1. Top 10 Customers by Total Loan Exposure
SELECT
Customer_ID,
COUNT(*) AS Total_Loans,
SUM(Loan_Amount) AS Total_Loan_Amount,
ROUND(AVG(Loan_Amount), 2) AS Average_Loan_Amount
FROM Loans
GROUP BY Customer_ID
ORDER BY Total_Loan_Amount DESC
LIMIT 10;


-- 2. Top 10 Customers by Number of Loans
SELECT
Customer_ID,
COUNT(*) AS Total_Loans,
SUM(Loan_Amount) AS Total_Loan_Amount
FROM Loans
GROUP BY Customer_ID
ORDER BY Total_Loans DESC,
Total_Loan_Amount DESC
LIMIT 10;


-- 3. Customer Loan Status Summary
SELECT
Customer_ID,
COUNT(*) AS Total_Loans,

SUM(
CASE
WHEN Loan_Status = 'Approved' THEN 1
ELSE 0
END
) AS Approved_Loans,

SUM(
CASE
WHEN Loan_Status = 'Rejected' THEN 1
ELSE 0
END
) AS Rejected_Loans,

SUM(Loan_Amount) AS Total_Loan_Amount

FROM Loans

GROUP BY Customer_ID

ORDER BY Total_Loan_Amount DESC;


-- 4. Customers with High Loan Exposure
SELECT
Customer_ID,
COUNT(*) AS Total_Loans,
SUM(Loan_Amount) AS Total_Loan_Amount,
ROUND(AVG(Loan_Amount), 2) AS Average_Loan_Amount
FROM Loans
GROUP BY Customer_ID
HAVING SUM(Loan_Amount) > (
SELECT AVG(Customer_Total)
FROM (
SELECT
Customer_ID,
SUM(Loan_Amount) AS Customer_Total
FROM Loans
GROUP BY Customer_ID
) AS Customer_Exposure
)
ORDER BY Total_Loan_Amount DESC;

/* =========================================================
7. CTE ANALYSIS
========================================================= */

-- 1. Customer Credit Category Analysis using CTE

WITH Credit_Category AS
(
SELECT
Customer_ID,
Credit_Score,

CASE
WHEN Credit_Score >= 700 THEN 'High'
WHEN Credit_Score >= 650 THEN 'Medium'
ELSE 'Low'
END AS Credit_Category

FROM Customers
)

SELECT
Credit_Category,
COUNT(*) AS Total_Customers,
ROUND(AVG(Credit_Score), 2) AS Average_Credit_Score,
MIN(Credit_Score) AS Minimum_Credit_Score,
MAX(Credit_Score) AS Maximum_Credit_Score

FROM Credit_Category

GROUP BY Credit_Category

ORDER BY Average_Credit_Score DESC;


/* =========================================================
8. WINDOW FUNCTION ANALYSIS
========================================================= */


-- 1. ROW_NUMBER()
-- Assign a unique sequence number to each loan

SELECT
Loan_ID,
Customer_ID,
Loan_Type,
Loan_Amount,
Loan_Status,

ROW_NUMBER() OVER (
ORDER BY Loan_Amount DESC
) AS Loan_Row_Number

FROM Loans
ORDER BY Loan_Row_Number;


-- 2. RANK()
-- Rank loans based on loan amount
-- Same loan amounts receive the same rank

SELECT
Loan_ID,
Customer_ID,
Loan_Amount,

RANK() OVER (
ORDER BY Loan_Amount DESC
) AS Loan_Rank

FROM Loans
ORDER BY Loan_Rank;


-- 3. DENSE_RANK()
-- Rank loan types based on their total loan amount
-- Unlike RANK(), DENSE_RANK() does not skip rank numbers

SELECT
Loan_Type,
SUM(Loan_Amount) AS Total_Loan_Amount,

DENSE_RANK() OVER (
ORDER BY SUM(Loan_Amount) DESC
) AS Loan_Type_Rank

FROM Loans

GROUP BY Loan_Type

ORDER BY Loan_Type_Rank;


-- 4. PARTITION BY
-- Rank customers' loans separately within each customer

SELECT
Customer_ID,
Loan_ID,
Loan_Type,
Loan_Amount,

ROW_NUMBER() OVER (
PARTITION BY Customer_ID
ORDER BY Loan_Amount DESC
) AS Customer_Loan_Rank

FROM Loans

ORDER BY Customer_ID, Customer_Loan_Rank;


-- 5. LAG()
-- Compare each loan amount with the previous loan

SELECT
Loan_ID,
Customer_ID,
Loan_Amount,

LAG(Loan_Amount) OVER (
ORDER BY Loan_ID
) AS Previous_Loan_Amount,

Loan_Amount -
LAG(Loan_Amount) OVER (
ORDER BY Loan_ID
) AS Difference_From_Previous

FROM Loans

ORDER BY Loan_ID;


-- 6. LEAD()
-- Compare each loan amount with the next loan

SELECT
Loan_ID,
Customer_ID,
Loan_Amount,

LEAD(Loan_Amount) OVER (
ORDER BY Loan_ID
) AS Next_Loan_Amount,

LEAD(Loan_Amount) OVER (
ORDER BY Loan_ID
) - Loan_Amount AS Difference_To_Next

FROM Loans

ORDER BY Loan_ID;


-- 7. Loan Status Percentage using Window Function

SELECT
Loan_Status,
COUNT(*) AS Total_Loans,

ROUND(
100.0 * COUNT(*) /
SUM(COUNT(*)) OVER (),
2
) AS Percentage

FROM Loans

GROUP BY Loan_Status

ORDER BY Total_Loans DESC;


/* =========================================================
9. FINAL INSIGHTS
========================================================= */


-- Insight 1: Overall Loan Performance

SELECT
COUNT(*) AS Total_Loans,

SUM(
CASE
WHEN Loan_Status = 'Approved' THEN 1
ELSE 0
END
) AS Approved_Loans,

SUM(
CASE
WHEN Loan_Status = 'Rejected' THEN 1
ELSE 0
END
) AS Rejected_Loans,

ROUND(
100.0 * SUM(
CASE
WHEN Loan_Status = 'Approved' THEN 1
ELSE 0
END
) / COUNT(*),
2
) AS Approval_Rate,

ROUND(
100.0 * SUM(
CASE
WHEN Loan_Status = 'Rejected' THEN 1
ELSE 0
END
) / COUNT(*),
2
) AS Rejection_Rate

FROM Loans;


-- Insight 2: Credit Category and Approval Rate

SELECT
CASE
WHEN c.Credit_Score >= 700 THEN 'High'
WHEN c.Credit_Score >= 650 THEN 'Medium'
ELSE 'Low'
END AS Credit_Category,

COUNT(*) AS Total_Loans,

SUM(
CASE
WHEN l.Loan_Status = 'Approved' THEN 1
ELSE 0
END
) AS Approved_Loans,

SUM(
CASE
WHEN l.Loan_Status = 'Rejected' THEN 1
ELSE 0
END
) AS Rejected_Loans,

ROUND(
100.0 * SUM(
CASE
WHEN l.Loan_Status = 'Approved' THEN 1
ELSE 0
END
) / COUNT(*),
2
) AS Approval_Rate,

ROUND(
100.0 * SUM(
CASE
WHEN l.Loan_Status = 'Rejected' THEN 1
ELSE 0
END
) / COUNT(*),
2
) AS Rejection_Rate

FROM Loans AS l
JOIN Customers AS c
ON l.Customer_ID = c.Customer_ID

GROUP BY
CASE
WHEN c.Credit_Score >= 700 THEN 'High'
WHEN c.Credit_Score >= 650 THEN 'Medium'
ELSE 'Low'
END

ORDER BY Approval_Rate DESC;


-- Insight 3: Loan Type Performance

SELECT
Loan_Type,
COUNT(*) AS Total_Loans,

SUM(
CASE
WHEN Loan_Status = 'Approved' THEN 1
ELSE 0
END
) AS Approved_Loans,

SUM(
CASE
WHEN Loan_Status = 'Rejected' THEN 1
ELSE 0
END
) AS Rejected_Loans,

ROUND(
100.0 * SUM(
CASE
WHEN Loan_Status = 'Approved' THEN 1
ELSE 0
END
) / COUNT(*),
2
) AS Approval_Rate,

SUM(Loan_Amount) AS Total_Loan_Amount,
ROUND(AVG(Loan_Amount), 2) AS Average_Loan_Amount

FROM Loans

GROUP BY Loan_Type

ORDER BY Approval_Rate DESC;


-- Insight 4: Loan Amount by Loan Status

SELECT
Loan_Status,
COUNT(*) AS Total_Loans,
SUM(Loan_Amount) AS Total_Loan_Amount,
ROUND(AVG(Loan_Amount), 2) AS Average_Loan_Amount

FROM Loans

GROUP BY Loan_Status

ORDER BY Total_Loan_Amount DESC;


-- Insight 5: Interest Rate by Loan Status

SELECT
Loan_Status,
COUNT(*) AS Total_Loans,
ROUND(AVG(Interest_Rate), 2) AS Average_Interest_Rate,
ROUND(MIN(Interest_Rate), 2) AS Minimum_Interest_Rate,
ROUND(MAX(Interest_Rate), 2) AS Maximum_Interest_Rate

FROM Loans

GROUP BY Loan_Status

ORDER BY Average_Interest_Rate DESC;



-- Insight 7: Loan Type Ranking

SELECT
Loan_Type,
COUNT(*) AS Total_Loans,
SUM(Loan_Amount) AS Total_Loan_Amount,

DENSE_RANK() OVER (
ORDER BY SUM(Loan_Amount) DESC
) AS Loan_Type_Rank

FROM Loans

GROUP BY Loan_Type

ORDER BY Loan_Type_Rank;

/* =========================================================
   10. PROJECT CONCLUSION
   ========================================================= */

-- Project Conclusion:
--
-- In this project, I analyzed loan data using MySQL to understand
-- loan applications, approval patterns, customer credit profiles,
-- loan amounts, loan types, and interest rates.
--
-- The analysis covered data exploration, data quality checks,
-- basic loan analysis, credit score analysis, loan type analysis,
-- customer analysis, CTEs, and window functions.
--
-- I used SQL techniques such as SELECT, WHERE, GROUP BY,
-- ORDER BY, aggregate functions, CASE statements, JOINs,
-- CTEs, ROW_NUMBER(), RANK(), DENSE_RANK(), PARTITION BY,
-- LAG(), LEAD(), and window functions.
--
-- The analysis helped identify patterns in loan approvals,
-- credit categories, loan types, customer loan exposure,
-- loan amounts, and interest rates.
--
-- Overall, this project helped me understand how SQL can be
-- used to clean, analyze, and transform loan data into
-- meaningful business insights for decision-making.