/* ============================================================
   RETAIL SALES ANALYSIS - SQL QUERIES
   Dataset: sales_data.csv (imported as table "Sales")
   ============================================================ */

-- 1. Create Table Structure
CREATE TABLE Sales (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    Region NVARCHAR(50),
    Category NVARCHAR(50),
    Product NVARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    Discount_Percent DECIMAL(5,2),
    PaymentMode NVARCHAR(50),
    CustomerSegment NVARCHAR(50),
    Rating INT,
    TotalAmount DECIMAL(12,2)
);

-- ============================================================
-- 2. Total Revenue & Orders Overview
-- ============================================================
SELECT 
    COUNT(OrderID) AS TotalOrders,
    SUM(TotalAmount) AS TotalRevenue,
    ROUND(AVG(TotalAmount), 2) AS AvgOrderValue
FROM Sales;

-- ============================================================
-- 3. Top 5 Products by Revenue
-- ============================================================
SELECT TOP 5
    Product,
    Category,
    SUM(TotalAmount) AS TotalRevenue,
    SUM(Quantity) AS UnitsSold
FROM Sales
GROUP BY Product, Category
ORDER BY TotalRevenue DESC;

-- ============================================================
-- 4. Monthly Sales Trend
-- ============================================================
SELECT 
    FORMAT(OrderDate, 'yyyy-MM') AS Month,
    SUM(TotalAmount) AS MonthlyRevenue,
    COUNT(OrderID) AS OrderCount
FROM Sales
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY Month;

-- ============================================================
-- 5. Region-wise Performance
-- ============================================================
SELECT 
    Region,
    COUNT(OrderID) AS TotalOrders,
    SUM(TotalAmount) AS TotalRevenue,
    ROUND(AVG(TotalAmount), 2) AS AvgOrderValue
FROM Sales
GROUP BY Region
ORDER BY TotalRevenue DESC;

-- ============================================================
-- 6. Category-wise Revenue Contribution (%)
-- ============================================================
SELECT 
    Category,
    SUM(TotalAmount) AS Revenue,
    ROUND(SUM(TotalAmount) * 100.0 / (SELECT SUM(TotalAmount) FROM Sales), 2) AS RevenuePercent
FROM Sales
GROUP BY Category
ORDER BY Revenue DESC;

-- ============================================================
-- 7. Quarter-over-Quarter Comparison (Detecting Q3 2023 Dip)
-- ============================================================
SELECT 
    YEAR(OrderDate) AS Year,
    DATEPART(QUARTER, OrderDate) AS Quarter,
    SUM(TotalAmount) AS Revenue,
    COUNT(OrderID) AS Orders
FROM Sales
GROUP BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate)
ORDER BY Year, Quarter;

-- ============================================================
-- 8. Customer Segment Analysis
-- ============================================================
SELECT 
    CustomerSegment,
    COUNT(OrderID) AS Orders,
    SUM(TotalAmount) AS Revenue,
    ROUND(AVG(Rating), 2) AS AvgRating
FROM Sales
GROUP BY CustomerSegment
ORDER BY Revenue DESC;

-- ============================================================
-- 9. Payment Mode Preference
-- ============================================================
SELECT 
    PaymentMode,
    COUNT(OrderID) AS Orders,
    ROUND(COUNT(OrderID) * 100.0 / (SELECT COUNT(*) FROM Sales), 2) AS Percentage
FROM Sales
GROUP BY PaymentMode
ORDER BY Orders DESC;

-- ============================================================
-- 10. Discount Impact on Sales Volume
-- ============================================================
SELECT 
    Discount_Percent,
    COUNT(OrderID) AS OrdersCount,
    SUM(TotalAmount) AS Revenue
FROM Sales
GROUP BY Discount_Percent
ORDER BY Discount_Percent;

-- ============================================================
-- 11. Best & Worst Rated Products
-- ============================================================
SELECT 
    Product,
    ROUND(AVG(Rating), 2) AS AvgRating,
    COUNT(OrderID) AS TotalOrders
FROM Sales
GROUP BY Product
HAVING COUNT(OrderID) >= 5
ORDER BY AvgRating DESC;

-- ============================================================
-- 12. Region + Category Cross Analysis
-- ============================================================
SELECT 
    Region,
    Category,
    SUM(TotalAmount) AS Revenue
FROM Sales
GROUP BY Region, Category
ORDER BY Region, Revenue DESC;
