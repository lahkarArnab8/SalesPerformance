USE SalesPerformanceDB;

-- ==========================================================
-- BASIC ANALYSIS QUERIES (1-10)
-- ==========================================================

-- 1. View First 10 Records
SELECT *
FROM `Sales`
LIMIT 10;

-- ----------------------------------------------------------

-- 2. Total Revenue
SELECT
ROUND(SUM(Sales),2) AS TotalRevenue
FROM `Sales`;

-- ----------------------------------------------------------

-- 3. Total Profit
SELECT
ROUND(SUM(Profit),2) AS TotalProfit
FROM `Sales`;

-- ----------------------------------------------------------

-- 4. Total Orders
SELECT
COUNT(*) AS TotalOrders
FROM `Sales`;

-- ----------------------------------------------------------

-- 5. Average Order Value
SELECT
ROUND(AVG(Sales),2) AS AverageOrderValue
FROM `Sales`;

-- ----------------------------------------------------------

-- 6. Top 10 Customers by Revenue
SELECT
c.CustomerName,
ROUND(SUM(s.Sales),2) AS Revenue
FROM `Sales` s
JOIN Customers c
ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerName
ORDER BY Revenue DESC
LIMIT 10;

-- ----------------------------------------------------------

-- 7. Top 10 Products by Revenue
SELECT
p.ProductName,
ROUND(SUM(s.Sales),2) AS Revenue
FROM `Sales` s
JOIN Products p
ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC
LIMIT 10;

-- ----------------------------------------------------------

-- 8. Revenue by Region
SELECT
c.Region,
ROUND(SUM(s.Sales),2) AS Revenue
FROM `Sales` s
JOIN Customers c
ON s.CustomerID = c.CustomerID
GROUP BY c.Region;

-- ----------------------------------------------------------

-- 9. Total Customers
SELECT
COUNT(*) AS TotalCustomers
FROM Customers;

-- ----------------------------------------------------------

-- 10. Total Products
SELECT
COUNT(*) AS TotalProducts
FROM Products;

-- ==========================================================
-- ADVANCED ANALYSIS QUERIES (1-25)
-- ==========================================================

-- 1. Monthly Revenue
SELECT
YEAR(OrderDate) AS Year,
MONTH(OrderDate) AS Month,
ROUND(SUM(Sales),2) AS Revenue
FROM `Sales`
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

-- ----------------------------------------------------------

-- 2. Monthly Profit
SELECT
YEAR(OrderDate) AS Year,
MONTH(OrderDate) AS Month,
ROUND(SUM(Profit),2) AS Profit
FROM `Sales`
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

-- ----------------------------------------------------------

-- 3. Monthly Orders
SELECT
YEAR(OrderDate) AS Year,
MONTH(OrderDate) AS Month,
COUNT(*) AS Orders
FROM `Sales`
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

-- ----------------------------------------------------------

-- 4. Highest Revenue Month
SELECT
YEAR(OrderDate) AS Year,
MONTH(OrderDate) AS Month,
ROUND(SUM(Sales),2) AS Revenue
FROM `Sales`
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Revenue DESC
LIMIT 1;

-- ----------------------------------------------------------

-- 5. Top 10 Customers by Profit
SELECT
c.CustomerName,
ROUND(SUM(s.Profit),2) AS Profit
FROM Customers c
JOIN `Sales` s
ON c.CustomerID=s.CustomerID
GROUP BY c.CustomerName
ORDER BY Profit DESC
LIMIT 10;

-- ----------------------------------------------------------

-- 6. Customer Lifetime Value
SELECT
CustomerID,
ROUND(SUM(Sales),2) AS LifetimeValue
FROM `Sales`
GROUP BY CustomerID
ORDER BY LifetimeValue DESC;

-- ----------------------------------------------------------

-- 7. Repeat Customers
SELECT
CustomerID,
COUNT(OrderID) AS OrdersPlaced
FROM `Sales`
GROUP BY CustomerID
HAVING COUNT(OrderID)>1
ORDER BY OrdersPlaced DESC;

-- ----------------------------------------------------------

-- 8. Average Spending per Customer
SELECT
ROUND(AVG(CustomerSales),2) AS AvgCustomerSpend
FROM
(
SELECT
CustomerID,
SUM(Sales) AS CustomerSales
FROM `Sales`
GROUP BY CustomerID
) t;

-- ----------------------------------------------------------

-- 9. Best Selling Products
SELECT
p.ProductName,
SUM(s.Quantity) AS UnitsSold
FROM Products p
JOIN `Sales` s
ON p.ProductID=s.ProductID
GROUP BY p.ProductName
ORDER BY UnitsSold DESC
LIMIT 10;

-- ----------------------------------------------------------

-- 10. Least Selling Products
SELECT
p.ProductName,
SUM(s.Quantity) AS UnitsSold
FROM Products p
JOIN `Sales` s
ON p.ProductID=s.ProductID
GROUP BY p.ProductName
ORDER BY UnitsSold
LIMIT 10;

-- ----------------------------------------------------------

-- 11. Most Profitable Products
SELECT
p.ProductName,
ROUND(SUM(s.Profit),2) AS Profit
FROM Products p
JOIN `Sales` s
ON p.ProductID=s.ProductID
GROUP BY p.ProductName
ORDER BY Profit DESC
LIMIT 10;

-- ----------------------------------------------------------

-- 12. Category-wise Revenue
SELECT
p.Category,
ROUND(SUM(s.Sales),2) AS Revenue
FROM Products p
JOIN `Sales` s
ON p.ProductID=s.ProductID
GROUP BY p.Category;

-- ----------------------------------------------------------

-- 13. Revenue by Region
SELECT
c.Region,
ROUND(SUM(s.Sales),2) AS Revenue
FROM Customers c
JOIN `Sales` s
ON c.CustomerID=s.CustomerID
GROUP BY c.Region;

-- ----------------------------------------------------------

-- 14. Profit by State
SELECT
c.State,
ROUND(SUM(s.Profit),2) AS Profit
FROM Customers c
JOIN `Sales` s
ON c.CustomerID=s.CustomerID
GROUP BY c.State
ORDER BY Profit DESC;

-- ----------------------------------------------------------

-- 15. Average Discount
SELECT
ROUND(AVG(Discount)*100,2) AS AvgDiscountPercent
FROM `Sales`;

-- ----------------------------------------------------------

-- 16. Discount vs Profit
SELECT
Discount,
ROUND(AVG(Profit),2) AS AvgProfit
FROM `Sales`
GROUP BY Discount
ORDER BY Discount;

-- ----------------------------------------------------------

-- 17. Rank Customers by Revenue
SELECT
CustomerID,
SUM(Sales) AS Revenue,
RANK() OVER(
ORDER BY SUM(Sales) DESC
) AS CustomerRank
FROM `Sales`
GROUP BY CustomerID;

-- ----------------------------------------------------------

-- 18. Dense Rank Products
SELECT
ProductID,
SUM(Sales) AS Revenue,
DENSE_RANK() OVER(
ORDER BY SUM(Sales) DESC
) AS ProductRank
FROM `Sales`
GROUP BY ProductID;

-- ----------------------------------------------------------

-- 19. Row Number by Sales
SELECT
OrderID,
Sales,
ROW_NUMBER() OVER(
ORDER BY Sales DESC
) AS RowNum
FROM `Sales`;

-- ----------------------------------------------------------

-- 20. Daily Running Revenue
SELECT
OrderDate,
SUM(Sales) AS DailyRevenue,
SUM(SUM(Sales)) OVER(
ORDER BY OrderDate
) AS RunningRevenue
FROM `Sales`
GROUP BY OrderDate;

-- ----------------------------------------------------------

-- 21. Customers Spending Above Average
WITH CustomerRevenue AS
(
SELECT
CustomerID,
SUM(Sales) AS Revenue
FROM `Sales`
GROUP BY CustomerID
)
SELECT *
FROM CustomerRevenue
WHERE Revenue >
(
SELECT AVG(Revenue)
FROM CustomerRevenue
);

-- ----------------------------------------------------------

-- 22. Top 5 Products in Each Category
WITH ProductRevenue AS
(
SELECT
p.Category,
p.ProductName,
SUM(s.Sales) AS Revenue,
ROW_NUMBER() OVER(
PARTITION BY p.Category
ORDER BY SUM(s.Sales) DESC
) AS rn
FROM Products p
JOIN `Sales` s
ON p.ProductID=s.ProductID
GROUP BY p.Category,p.ProductName
)
SELECT *
FROM ProductRevenue
WHERE rn<=5;

-- ----------------------------------------------------------

-- 23. Profit Margin by Category
SELECT
p.Category,
ROUND(
SUM(s.Profit)/SUM(s.Sales)*100,
2
) AS ProfitMargin
FROM Products p
JOIN `Sales` s
ON p.ProductID=s.ProductID
GROUP BY p.Category;

-- ----------------------------------------------------------

-- 24. Average Items Per Order
SELECT
ROUND(AVG(Quantity),2) AS AvgItemsPerOrder
FROM `Sales`;

-- ----------------------------------------------------------

-- 25. Highest Value Order
SELECT *
FROM `Sales`
ORDER BY Sales DESC
LIMIT 1;