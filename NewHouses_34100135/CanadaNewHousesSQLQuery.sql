/****** Script for SelectTopNRows command from SSMS  ******/

-- Explore the data
SELECT TOP (10) *
  FROM [NewHouses];

Select distinct(year([REF_DATE])) from [dbo].[NewHouses];


-- Change data type from Datetime to Date
ALTER TABLE [dbo].[NewHouses]
ALTER COLUMN [REF_DATE] DATE
GO

Select count(*) from [dbo].[NewHouses];

Select * from [NewHouses] Where [TERMINATED] IS NOT NULL;

-- Columns not needed: DGUID, UOM, UOM_ID, Seasonal_adjustment, SCALAR_FACTOR, SCALAR_ID, STATUS, SYMBOL, TERMINATED, DECIMALS
-- I know why I'm dropping STATUS, SYMBOL, TERMINATED (need to write queries to prove they are null and useless)

-- checking DECIMALS column
select distinct([DECIMALS]) from [dbo].[NewHouses];
select [DECIMALS], count([DECIMALS]) from [dbo].[NewHouses] group by [DECIMALS];
select distinct([DECIMALS]) from [dbo].[NewHouses] where [VALUE] is null; -- since I will drop all the records where VALUE is null. DECIMALS column is useless

--checking VECTOR column
select count(distinct([VECTOR])) from [dbo].[NewHouses];
select distinct([VECTOR]) from [dbo].[NewHouses];
select [VECTOR], count(*) from [dbo].[NewHouses] where [VALUE] is null  group by [VECTOR];
select * from [dbo].[NewHouses] where [VECTOR] in ('v730441', 'v730440') order by [REF_DATE];
select distinct([GEO]) from [dbo].[NewHouses] where [VECTOR] in ('v730441', 'v730440'); -- answer is Canada
select distinct([Housing_estimates]) from [dbo].[NewHouses] where [VECTOR] in ('v730441', 'v730440'); -- answer is Housing starts
select distinct([Type_of_unit]) from [dbo].[NewHouses] where [VECTOR] in ('v730441', 'v730440'); -- answer are Multiples and Single-detached
select distinct([Seasonal_adjustment]) from [dbo].[NewHouses] where [VECTOR] in ('v730441', 'v730440'); -- Seasonally adjusted at annual rates
select distinct([SCALAR_FACTOR]) from [dbo].[NewHouses] where [VECTOR] in ('v730441', 'v730440'); -- thousands
select distinct([SCALAR_ID]) from [dbo].[NewHouses] where [VECTOR] in ('v730441', 'v730440'); -- 3

--checking COORDINATE column
select count(distinct([COORDINATE])) from [dbo].[NewHouses];

-- Reasons to drop columns UOM and UOM_ID
select distinct([UOM]) from [dbo].[NewHouses];
select distinct([UOM_ID]) from [dbo].[NewHouses];

-- Reasons to drop column SCALAR_ID
select distinct([SCALAR_ID]) from [dbo].[NewHouses];
select [SCALAR_ID] , count(*) from [dbo].[NewHouses] group by [SCALAR_ID];

-- Looking at [Seasonal_adjustment] column. Reasons to drop
Select Distinct([Seasonal_adjustment]) from [dbo].[NewHouses];
select [Seasonal_adjustment], count(*) from [dbo].[NewHouses] group by [Seasonal_adjustment];
select distinct([VALUE]) from [dbo].[NewHouses] where [Seasonal_adjustment] = 'Seasonally adjusted at annual rates';
select distinct([Type_of_unit]) from [dbo].[NewHouses] where [Seasonal_adjustment] = 'Seasonally adjusted at annual rates';
select distinct(year([REF_DATE])) as yearr from [dbo].[NewHouses] where [Seasonal_adjustment] = 'Seasonally adjusted at annual rates'
order by yearr asc;

-- Looking at [SCALAR_FACTOR] column. Reasons to drop.
Select Distinct([SCALAR_FACTOR]) from [dbo].[NewHouses];
select [SCALAR_FACTOR], count(*) as Total from [dbo].[NewHouses] group by [SCALAR_FACTOR];
select * from [dbo].[NewHouses] where [SCALAR_FACTOR]  = 'thousands';
select distinct([VALUE]) from [dbo].[NewHouses] where [SCALAR_FACTOR]  = 'thousands';
select distinct([Type_of_unit]) from [dbo].[NewHouses] where [SCALAR_FACTOR]  = 'thousands';
select distinct([Housing_estimates]) from [dbo].[NewHouses] where [SCALAR_FACTOR]  = 'thousands';
select distinct([SCALAR_ID]) from [dbo].[NewHouses] where [SCALAR_FACTOR]  = 'thousands';
SELECT *
FROM dbo.NewHouses NH
WHERE NH.REF_DATE = '1966-01-01'
  AND NH.Housing_estimates = 'Housing starts'
  AND NH.Type_of_unit IN ('Total units', 'Multiples', 'Single-detached');

-- getting distinct geo's
select distinct([GEO]) from [dbo].[NewHouses];
select * from [dbo].[NewHouses] where [GEO] in ('Prairie provinces', 'Atlantic provinces');
select distinct([VALUE]) from [dbo].[NewHouses] where [GEO] in ('Prairie provinces', 'Atlantic provinces'); -- removing the records for [GEO] in ('Prairie provinces', 'Atlantic provinces') as [VALUE] is null

select count(*) from [dbo].[NewHouses] where [VALUE] is null;

-- Columns not needed: DGUID, UOM, UOM_ID, Seasonal_adjustment, SCALAR_FACTOR, SCALAR_ID, STATUS, SYMBOL, TERMINATED, DECIMALS
-- I know why I'm dropping STATUS, SYMBOL, TERMINATED (need to write queries to prove they are null and useless)
-- Below is the edited database.
Select REF_DATE, GEO, Housing_estimates, Type_of_unit, VECTOR, COORDINATE, VALUE
 FROM NewHouses
 WHERE VALUE IS NOT NULL;

 -- created two new tables for ML and Visualization purposes
 'Select REF_DATE, GEO, Housing_estimates, Type_of_unit, VECTOR, COORDINATE, VALUE
INTO NewHousesForML
 FROM NewHouses
 WHERE VALUE IS NOT NULL;'

'Select REF_DATE, GEO, Housing_estimates, Type_of_unit, VALUE
INTO NewHousesForViz
 FROM NewHouses
 WHERE VALUE IS NOT NULL;'


-- Let's Start the SQL Analysis
--  Questions to Answer
--   Annual Percentage change every year from 1948 to 2022 in Housing Starts, Housing Compleition and Housing Under Construction in all over Canada and Province Wise.