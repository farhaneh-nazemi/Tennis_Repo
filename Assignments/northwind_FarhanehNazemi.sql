-- این فایل در محیط dbeaver ساخته و اجرا شد اما در محیط datagrip ذخیره شد
-- 1. چند سفارش در مجموع ثبت شدهاست
select Count(*) from orders;

-- 2. درآمد حاصل از این سفارشها چقدر بوده است؟
select Sum(od.Quantity*p.Price) as All_Income  
from orderdetails od 
join products p on od.ProductID =p.ProductID;

-- 3.پنج مشتری برتر را بر اساس مقداری که خرج کردهاند پیدا کنید. )ID، نام و مقدار خرج شده هر یک را  گزارش کنید( 
select c.CustomerID,c.CustomerName ,sum(od.Quantity*p.Price) as Cost
from orders o 
join orderdetails od on o.OrderID =od.OrderID 
join products p on od.ProductID =p.ProductID 
join customers c on c.CustomerID =o.CustomerID 
group by c.CustomerID ,c.CustomerName 
order by 3 desc 
LIMIT 5;

-- 4. میانگین هزینه ی سفارشات هر مشتری را به همراه ID و نام او گزارش کنید. )به ترتیب نزولی نشان دهید( 
select c.CustomerID,c.CustomerName ,AVG(od.Quantity*p.Price) as AVGCost 
from orders o 
join orderdetails od on o.OrderID =od.OrderID 
join products p on od.ProductID =p.ProductID 
join customers c on c.CustomerID =o.CustomerID 
group by c.CustomerID ,c.CustomerName 
order by 3 desc;

-- 5. مشتری ان را بر اساس مقدار کل هزینهی سفارشات رتبهبندی کنید، اما فقط مشتریان ی را در نظر  بگیرید که بیشتر از 5 سفارش دادهاند.
select rank() over(order by sum(od.Quantity * p.Price) desc) as Rate,sum(od.Quantity * p.Price) as Cost ,c.CustomerID,c.CustomerName  
from orders o 
join orderdetails od on o.OrderID =od.OrderID 
join products p on od.ProductID =p.ProductID 
join customers c on c.CustomerID =o.CustomerID 
group by c.CustomerID ,c.CustomerName 
having Count(distinct o.OrderID)>5
order by 1;

-- 6. کدام محصول در کل سفارشات ثبت شده بیشترین درآمد را ایجاد کرده است؟ )به همراه ID و نام گزارش کنید(
select p.ProductID,p.ProductName,sum(od.Quantity * p.Price) Income
from orderdetails od
join products p on od.ProductID =p.ProductID 
group by p.ProductID,p.ProductName
order by 3 desc 
limit 1;

-- 7. هر دسته )category )چند محصول دارد؟ )به ترتیب نزولی نشان دهید( 
select CategoryID,Count(*) from products p 
group by CategoryID 
order by 2 desc;


-- 8. محصول پرفروش در هر دسته بر اساس درآمد را تعیین کنید
with cte as 
(
select od.ProductID,p.ProductName ,p.CategoryID 
,rank() over (partition by categoryid  order by sum(od.Quantity * p.Price) desc) Rate
,sum(od.Quantity * p.Price) as SalesAmount
from orderdetails od
join products p on od.ProductID =p.ProductID 
group by od.ProductID,p.ProductName 
)
select CategoryID,ProductID ,ProductName,SalesAmount from cte
where Rate=1
order by 1;

-- 9. پنج کارمند برتر که باالترین درآمد را ایجاد کردند به همراه ID و نام + ’ ’ + نام خانوادگی گزارش کنید
select o.EmployeeID ,concat(e.FirstName,' ' ,e.LastName) as Fullname,sum(od.Quantity * p.Price) as SalesAmount
from orders o 
join orderdetails od on o.OrderID =od.OrderID 
join products p on od.ProductID =p.ProductID 
join employees e on e.EmployeeID  =o.EmployeeID  
group by o.EmployeeID,concat(e.FirstName,' ' ,e.LastName)
order by 3 desc 
LIMIT 5;

-- 10. میانگین درآمد هر کارمند به ازای هر سفارش چقدر بودهاست؟ )به ترتیب نزولی نشان دهید(
-- *************************
-- فکر نمی کنم هیچ جا درآمد کارمند برابر با میانگین فروشی باشه که برای شرکت به دست آورده در نتیجه صورت سوال جای اصلاح داره
-- میانگین آورده ای که هر کارمند برای شرکت داشته چقدر است؟
-- *************************
select o.EmployeeID ,concat(e.FirstName,' ' ,e.LastName) as Fullname,AVG(od.Quantity * p.Price) as AVGIncome
from orders o 
join orderdetails od on o.OrderID =od.OrderID 
join products p on od.ProductID =p.ProductID 
join employees e on e.EmployeeID  =o.EmployeeID  
group by o.EmployeeID,concat(e.FirstName,' ' ,e.LastName)
order by 3 desc;

-- 11. کدام کشور بیشترین تعداد سفارشات را ثبت کرده است؟ )نام کشور را به همراه تعداد سفارشات گزارش کنید
select s.Country ,Count(distinct o.OrderID) as OrderCount
from orders o 
join orderdetails od on o.OrderID =od.OrderID 
join products p on od.ProductID =p.ProductID 
join suppliers s on p.SupplierID =s.SupplierID 
group by s.Country 
order by 2 desc 
limit 1;

-- 12. مجموع درآمد از سفارشات هر کشور چقدر بوده؟ )به همراه نام کشور و به ترتیب نزولی نشان دهید( 
select s.Country  ,sum(od.Quantity * p.Price) as SalesAmount
from orders o 
join orderdetails od on o.OrderID =od.OrderID 
join products p on od.ProductID =p.ProductID 
join suppliers s on p.SupplierID =s.SupplierID 
group by s.Country 
order by 2 desc;

-- 13.میانگین قیمت هر دسته چقدر است؟ )به همراه نام دسته و به ترتیب نزولی گزارش کنید
select c.CategoryID ,c.CategoryName ,AVG(Price) as AVGPrice 
from products p 
join categories c on p.CategoryID =c.CategoryID 
group by CategoryID 
order by 3 desc;

-- 14.گران ترین دسته بندی کدام است؟ )به همراه نام دسته گزارش کنید(
select c.CategoryID ,c.CategoryName ,AVG(Price) as AVGPrice 
from products p 
join categories c on p.CategoryID =c.CategoryID 
group by CategoryID 
order by 3 desc 
limit 1;

-- 15.طی سال 1996 هر ماه چند سفارش ثبت شده است؟
select month (OrderDate) as MonthNumber,MONTHNAME(OrderDate) as MonthName,Count(*) 
from orders o 
where year(OrderDate)='1996'
group by month (OrderDate),MONTHNAME(OrderDate);


-- 16.میانگین فاصله ی زمانی بین سفارشات هر مشتری چقدر بوده؟ )به همراه نام مشتری و به صورت نزولی نشان دهید
with cte as 
(
select datediff(OrderDate , lag(OrderDate) over(partition by CustomerID order by OrderDate )) as DateDiff,CustomerID
from orders o 
)
select AVG(DateDiff),c.CustomerID,c.CustomerName  from cte
join customers c on cte.CustomerID =c.CustomerID 
group by cte.CustomerID ,c.CustomerName 
order by 1 desc;


-- 17.در هر فصل جمع سفارشات چقدر بودهاست؟ )به صورت نزولی نشان دهید
select quarter(OrderDate) as quarter,Sum(od.Quantity * p.Price) as SalesAmount
from orders o 
join orderdetails od on o.OrderID =od.OrderID 
join products p on od.ProductID =p.ProductID  
group by quarter(OrderDate) 
order by 2 desc;

-- 18.کدام تامین کننده بیشترین تعداد کاال را تامین کرده است؟ )به همراه نام و ID گزارش کنید(
select s.SupplierID,s.SupplierName,Sum(Quantity)
from orderdetails od 
join products p on od.ProductID =p.ProductID 
join suppliers s on p.SupplierID =s.SupplierID 
group by s.SupplierID,s.SupplierName  
order by 3 desc 
limit 1;

-- 19. میانگین قیمت کاالی تامین شده توسط هر تامیکننده چقدر بوده؟ )به همراه نام و ID و به صورت نزولی گزارش کنید( 
select p.SupplierID,s.SupplierName,AVG(Price)
from products p 
join suppliers s on p.SupplierID =s.SupplierID 
group by s.SupplierID ,s.SupplierName 
order by 3 desc;