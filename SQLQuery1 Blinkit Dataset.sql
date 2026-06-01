select * from blinkit_Data 
select COUNT(*) from blinkit_Data
 
 update	blinkit_Data
 set Item_Fat_Content =
 case 
 when Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
 when Item_Fat_Content = 'reg' THEN 'Regular'
 else Item_Fat_Content
 end
 select distinct (Item_Fat_Content) from blinkit_Data 

 --KPI's
 --1. Total_Sales
 select CAST(SUM(Total_Sales)/ 1000000 as decimal (10,2)) as Total_Sales_Millions
 from blinkit_Data
 where Outlet_Establishment_Year = 2022

 --2. Avg_Sales
 Select CAST(AVG(Total_Sales) as decimal (10,1)) as Avg_Sales 
 from blinkit_Data
 where Outlet_Establishment_Year = 2022

 --3. No_Of_Items
 select count(*) as No_of_Items from blinkit_Data
 where Outlet_Establishment_Year = 2022

 --4. Avg Rating
 select CAST(Avg (Rating) as decimal (10,1)) as Avg_Rating
 from blinkit_Data

 -- Requirement Analysis 
 --1. Total Sales by Fat Content
 select Item_Fat_Content, 
		CAST(SUM(Total_Sales) as decimal(10,2)) as Total_Sales,
		CAST(AVG(Total_Sales) as decimal (10,1)) as Avg_Sales,
		count(*) as No_of_Items,
		CAST(Avg (Rating) as decimal (10,2)) as Avg_Rating
 from blinkit_Data
 Group by Item_Fat_Content
 Order by Total_Sales DESC

 --2. Total Sales by Item Type
  select top 5 Item_Type, 
		CAST(SUM(Total_Sales) as decimal(10,2)) as Total_Sales,
		CAST(AVG(Total_Sales) as decimal (10,1)) as Avg_Sales,
		count(*) as No_of_Items,
		CAST(Avg (Rating) as decimal (10,2)) as Avg_Rating
 from blinkit_Data
 Group by Item_Type
 Order by Total_Sales ASC

 --3. Fat Content by Outlet for Total Sales
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

--4. Total Sales by Outlet Establishment
 SELECT Outlet_Establishment_Year,
        CAST(SUM(Total_Sales) as decimal(10,2)) as Total_Sales,
		CAST(AVG(Total_Sales) as decimal (10,1)) as Avg_Sales,
		count(*) as No_of_Items,
		CAST(Avg (Rating) as decimal (10,2)) as Avg_Rating
    FROM blinkit_data
    GROUP BY Outlet_Establishment_Year
    Order by Outlet_Establishment_Year ASC

--5. Percentage of Sales by Outlet Size
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
    CAST(AVG(Total_Sales) as decimal (10,1)) as Avg_Sales,
	count(*) as No_of_Items,
	CAST(Avg (Rating) as decimal (10,2)) as Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC

--6  Sales by Outlet Location
SELECT Outlet_Location_Type, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
    CAST(AVG(Total_Sales) as decimal (10,1)) as Avg_Sales,
	count(*) as No_of_Items,
	CAST(Avg (Rating) as decimal (10,2)) as Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC

--7. All Metrics by Outlet Type
SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC

