-- Create Database my_db_4;
CREATE DATABASE my_db_4;
GO

USE my_db_4;
GO

CREATE TABLE Retail_Dataset (
    Order_ID VARCHAR(10),
    Order_Date DATE,
    Store_ID VARCHAR(10),
    Store_City VARCHAR(50),
    Store_Region VARCHAR(50),
    Product_ID VARCHAR(10),
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Salesperson VARCHAR(100),
    Quantity INT,
    Unit_Price DECIMAL(12,2),
    Discount DECIMAL(5,2),
    Sales DECIMAL(12,2),
    Cost DECIMAL(12,2),
    Profit DECIMAL(12,2),
    Payment_Method VARCHAR(20)
);
GO

--
Select * from Retail_Dataset;
GO

--
BULK INSERT Retail_Dataset
from 'C:\Users\user\Pictures\Datasets\retail best dataset.csv'
with (
Fieldterminator = ',',
RowTerminator = '0x0a',
FirstRow = 2);
GO

-- Primary KPIs
Select '$' + cast(convert(decimal(10,2),round(Sum(Sales)/1000000,2)) as varchar(50)) + 'M' as [Total Sales],
'$' + cast(convert(decimal(10,2),round(Sum(Profit)/1000000,2)) as varchar(50)) + 'M' as [Total Profit],
count(Order_ID) as [Orders],
convert(varchar(10),cast(round(Sum(Profit) / Sum(Sales) * 100,2) as decimal(10,2))) + '%' as [Profit Margin %]
from Retail_Dataset;
GO

-- Monthly Total Revenue & Costs
Select LEFT(DATENAME(MONTH,Order_Date),3) as [Month Name],'$' + cast(convert(decimal(10,2),round(Sum(Sales)/1000000,2)) as varchar(50)) + 'M' as [Total Revenue],
'$' + cast(convert(decimal(10,2),round(Sum(Cost)/1000000,2)) as varchar(50)) + 'M' as [Total Expenses]
from Retail_Dataset
Group By LEFT(DATENAME(MONTH,Order_Date),3),Month(Order_Date)
Order by Month(Order_Date);
GO

-- Category by Revenue
Select Category,'$' + cast(convert(decimal(10,2),round(Sum(Sales)/1000000,2)) as varchar(50)) + 'M' as [Total Revenue]
from Retail_Dataset
Group By Category;
GO

-- Store City by Sales
Select Store_City,'$' + cast(convert(decimal(10,2),round(Sum(Sales)/1000000,2)) as varchar(50)) + 'M' as [Total Revenue]
from Retail_Dataset
Group by Store_City;
GO

-- Payment Distribution by Sales
Select Payment_Method,'$' + cast(convert(decimal(10,2),round(Sum(Sales)/1000000,2)) as varchar(50)) + 'M' as [Total Revenue]
from Retail_Dataset
Group By Payment_Method;
GO

-- Region Distribution
Select Store_Region,
'$' + cast(convert(decimal(10,2),round(Sum(Sales)/1000000,2)) as varchar(50)) + 'M' as [Total Revenue],
'$' + cast(convert(decimal(10,2),round(Sum(Profit)/1000000,2)) as varchar(50)) + 'M' as [Total Profit]
from Retail_Dataset
Group By Store_Region;
GO

-- Category by Profit
Select Category,COUNT(Order_ID) as Distribution,SUM(Profit) as [Total Profit]
from Retail_Dataset
Group By Category;
GO

-- Yearly Revenue Trends
Select Year(Order_Date),'$' + cast(convert(decimal(10,2),round(Sum(Sales)/1000000,2)) as varchar(50)) + 'M' as [Total Revenue],
convert(varchar(50),CONVERT(decimal(10,2),round(SUM(Sales) / (Select SUM(Sales) from Retail_Dataset)*100,2))) + '%' as [Revenue Growth]
from Retail_Dataset
Group BY Year(Order_Date);
GO

-- Sales by Customer Segment
Select Segment,'$' + cast(convert(decimal(10,2),round(Sum(Sales)/1000000,2)) as varchar(50)) + 'M' as [Total Revenue]
from Retail_Dataset
Group By Segment;
GO