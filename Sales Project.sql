/*Business Request:
1) Get dashboard overview of internet sales to be able to better follow which customers and products sell best
2) Get detailed overview of internet sales per customer to be able to follow customers that buy the most and who more products can be sold to
3) Get detailed overview of internet sales per product to be able to follow products that sell the most
4) Get dashboard overview of internet sales to be able to follow sales over time against budget (2 years)*/

--Calendar Table
SELECT DateKey,
	FullDateAlternateKey AS Date,
	EnglishDayNameOfWeek AS Day,
	EnglishMonthName AS Month,
	LEFT(EnglishMonthName, 3) AS MonthShort,
	MonthNumberOfYear AS MonthNo,
	CalendarQuarter AS Quarter,
	CalendarYear AS Year
FROM DimDate
WHERE CalendarYear >= 2020;

--Customers Table
SELECT c.CustomerKey AS [Customer Key],
	FirstName AS [First Name],
	LastName AS [Last Name],
	--Full Name
	CASE WHEN MiddleName IS NOT NULL
		THEN CONCAT(FirstName, ' ', MiddleName, '. ', LastName)
		ELSE CONCAT(FirstName, ' ', LastName)
		END AS [Full Name],
	--Gender
	CASE WHEN Gender = 'M'
		THEN 'Male'
		WHEN Gender = 'F'
		THEN 'Female'
		END AS Gender,
	DateFirstPurchase AS [Date First Purchase],
	g.City AS [Customer City]
FROM DimCustomer AS c
LEFT JOIN DimGeography AS g
	ON c.GeographyKey = g.GeographyKey
ORDER BY [Customer Key];

--Products Table
SELECT ProductKey,
	ProductAlternateKey AS ProductItemCode,
	EnglishProductName AS [Product Name],
	ps.EnglishProductSubcategoryName AS Subcategory,
	pc.EnglishProductCategoryName AS Category,
	Color AS [Product Color],
	Size AS [Product Size],
	ProductLine AS [Product Line],
	ModelName AS [Product Model Name],
	EnglishDescription AS [Product Description],
	ISNULL(Status, 'Outdated') AS [Product Status]
FROM DimProduct AS p
LEFT JOIN DimProductSubcategory AS ps
	ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS pc
	ON ps.ProductCategoryKey = pc.ProductCategoryKey
ORDER BY ProductKey;

--Internet Sales Table
SELECT ProductKey,
	OrderDateKey,
	DueDateKey,
	ShipDateKey,
	CustomerKey,
	SalesOrderNumber,
	SalesAmount
FROM FactInternetSales
--Data only for past 2 years
WHERE LEFT(OrderDateKey, 4) >= YEAR(GETDATE()) - 2
ORDER BY OrderDateKey;