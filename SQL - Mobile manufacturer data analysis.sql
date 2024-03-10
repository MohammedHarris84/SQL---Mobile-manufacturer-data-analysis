--SQL Advance Case Study


--Q1--BEGIN 
	
select distinct state from (
select T1.state, SUM(quantity) as CNT, YEAR(T2.date) as year from DIM_LOCATION as T1
join FACT_TRANSACTIONS as T2
on T1.IDLocation = T2.IDLocation
where YEAR(T2.date) >= 2005
group by T1.State, YEAR(T2.date)
)as A

--Q1--END

--Q2--BEGIN
	
Select top 1 State, count(*) as CNT from DIM_LOCATION as T1
join FACT_TRANSACTIONS as T2
on T1.IDLocation = T2.IDLocation
join DIM_MODEL as T3
on T2.IDModel = T3.IDModel
join DIM_MANUFACTURER as T4
on T3.IDManufacturer = T4.IDManufacturer
where Country = 'US' and Manufacturer_Name = 'Samsung'
Group by State
order by CNT desc;

--Q2--END

--Q3--BEGIN      
	
Select idmodel,state,zipcode, COUNT(*) as tot_trans
from FACT_TRANSACTIONS as T1
join DIM_LOCATION as T2
on T1.IDLocation = T2.IDLocation
group by IDModel,state,ZipCode;


--Q3--END

--Q4--BEGIN

select top 1 model_name, min(unit_price) as min_price
from DIM_MODEL
group by Model_Name
order by min_price

--Q4--END

--Q5--BEGIN

select T1.IDModel, AVG(totalprice) as avg_price, SUM(quantity) as tot_qty from FACT_TRANSACTIONS as T1
join DIM_MODEL as T2
on T1.IDModel = T2.IDModel
join DIM_MANUFACTURER as T3
on T2.IDManufacturer = T3.IDManufacturer
where Manufacturer_Name in (select top 5 Manufacturer_Name from FACT_TRANSACTIONS as T1
							join DIM_MODEL as T2
							on T1.IDModel = T2.IDModel
							join DIM_MANUFACTURER as T3
							on T2.IDManufacturer = T3.IDManufacturer
							group by Manufacturer_Name
							order by sum(totalprice) desc)
group by T1.IDModel
order by avg_price desc;

--Q5--END

--Q6--BEGIN

Select customer_name, AVG(totalprice) as avg_price from DIM_CUSTOMER as T1
join FACT_TRANSACTIONS as T2
on T1.IDCustomer = T2.IDCustomer
where YEAR(date) = 2009
group by Customer_Name
having AVG(totalprice) > 500;

--Q6--END
	
--Q7--BEGIN  
	
 select * from(
 select top 5 idmodel from FACT_TRANSACTIONS
 where YEAR(date) = 2008
 group by IDModel, YEAR(date)
 order by SUM(quantity) desc
 ) as T1
 
 intersect
 select * from(
 select top 5 idmodel from FACT_TRANSACTIONS
 where YEAR(date) = 2009
 group by IDModel, YEAR(date)
 order by SUM(quantity) desc
 ) as T2

 intersect
 select * from(
 select top 5 idmodel from FACT_TRANSACTIONS
 where YEAR(date) = 2010
 group by IDModel, YEAR(date)
 order by SUM(quantity) desc
 ) as T3

--Q7--END	
--Q8--BEGIN

select * from (
select top 1*from (
select top 2 manufacturer_name, YEAR (date) as year , sum(totalprice) as sales from FACT_TRANSACTIONS as T1
join DIM_MODEL as T2
on T1.IDModel = T2.IDModel
join DIM_MANUFACTURER as T3
on T2.IDManufacturer = T3.IDManufacturer
where year(date) = 2009
group by Manufacturer_Name, YEAR(date)
order by sales desc) as M1
order by sales asc) as M3
union
select * from (
select top 1*from (
select top 2 manufacturer_name, YEAR (date) as year , sum(totalprice) as sales from FACT_TRANSACTIONS as T1
join DIM_MODEL as T2
on T1.IDModel = T2.IDModel
join DIM_MANUFACTURER as T3
on T2.IDManufacturer = T3.IDManufacturer
where year(date) = 2010
group by Manufacturer_Name, YEAR(date)
order by sales desc) as M1
order by sales asc) as M4

--Q8--END
--Q9--BEGIN
	
select manufacturer_name from FACT_TRANSACTIONS as T1
join DIM_MODEL as T2
on T1.IDModel = T2.IDModel
join DIM_MANUFACTURER as T3
on T2.IDManufacturer = T3.IDManufacturer
where YEAR(date) = 2010
group by Manufacturer_Name
Except
select manufacturer_name from FACT_TRANSACTIONS as T1
join DIM_MODEL as T2
on T1.IDModel = T2.IDModel
join DIM_MANUFACTURER as T3
on T2.IDManufacturer = T3.IDManufacturer
where YEAR(date) = 2009
group by Manufacturer_Name

--Q9--END

--Q10--BEGIN
	
select *, ((avg_price - lag_price)/lag_price) as percentage_change from (
select *, LAG(avg_price,1) over(partition by idcustomer order by year) as lag_price from(
select idcustomer,YEAR(date) as year, AVG(totalprice) as avg_price, SUM(quantity) as qty from FACT_TRANSACTIONS
where IDCustomer in (select top 100 idcustomer from FACT_TRANSACTIONS
					 group by IDCustomer
					 order by sum(totalprice)desc)
group by IDCustomer,YEAR(date)
)as D1
)as D2


--Q10--END
	