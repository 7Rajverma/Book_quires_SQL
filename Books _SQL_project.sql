create database books;

-- Create Tables Book
DROP TABLE IF EXISTS Book;
CREATE TABLE Book (
Book_ID SERIAL PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(100),
Genus VARCHAR(50),
Published_Year INT,
Price NUMERIC(10, 2)
,Stock INT);

select * from Book;

-- Create Tables Customers

CREATE TABLE Customers (
Customer_ID SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR(50),
Country VARCHAR (150));

-- Create Tables Orders

CREATE TABLE Orders (
Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES   -- Foregin Key
Customers(Customer_ID),
Book_ID INT REFERENCES Book (Book_ID),   -- Foregin Key
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10, 2));



-- Inporting data for book table 

copy Book(Book_ID,Title,Author,Genus,Published_Year,Price,Stock)
from 'D:\sql\ST - SQL ALL PRACTICE FILES SD61\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Books.csv'
CSV HEADER;

-- Importing data for table Customer

copy Customers(Customer_ID,Name,Email,Phone,City,Country)
from 'D:\sql\ST - SQL ALL PRACTICE FILES SD61\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Customers.csv'
csv header;


-- Importing data for table Order

copy Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
from 'D:\sql\ST - SQL ALL PRACTICE FILES SD61\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Orders.csv'
CSV HEADER;

-- Advance Questions
-- Q1.Retrive the total number of books sold for each genre:

select b.Genus, sum(o.quantity) 
from orders o
join book b on o.book_id = b.book_id
group by b.genus;

-- Q2.Find the avg price of books in the 'Fantasy' genre:
select AVG(price) as Average_Price
from Book
where genus = 'Fantasy';

-- Q3.List customer who have placed at least 2 orders:
select * from orders;
select * from customers;

--Without join if customer name is not required
select  customer_id , count( order_id) AS order_count from orders o
group by customer_id
having count( order_id) >= 2;

--With join if customer name is required
select  o.customer_id ,c.name, count( o.order_id) AS order_count from orders o
join customers c on c.customer_id = o.customer_id
group by o.customer_id,c.name
having count( o.order_id) >= 2;



-- Q4. Find the most frequently ordered book:

--Without join if book name is not required
select * from orders;
select book_id, count(order_id) as most_order from orders
group by book_id
order by most_order DESC limit 1;


--With join if book name is required
select o.book_id,b.title, count(o.order_id) as most_order from orders o
join book b on b.book_id = o.book_id
group by o.book_id, b.title
order by most_order DESC limit 5;


-- Q5.SHow the top 3 most expensive books of 'Fantasy'

select * from book
where genus = 'Fantasy'
order by price desc limit 3;

-- Q6. Retrive the total quantity of books sold by each author:

select  b.author,sum( o.quantity) AS total_book_sold from orders o
join book b on b.book_id = o.book_id
group by b.author;

-- Q7. List the city where customer who spent over $30 are located:
select * from customers;
select * from orders;

select DISTINCT c.city,c.name,o.total_amount as total_spend from customers c
join orders o on o.customer_id = c.customer_id
where o.total_amount > 30;

-- order by total_spend ;

--Q8.Find the customer who spent the most on orders:

select c.customer_id,c.name, sum(o.total_amount) as total_spent
from customers c
join orders o on c.customer_id=o.customer_id
group by c.name,c.customer_id
order by total_spent desc;


--Q9. Calculate the stock remaining after fulfilling all orders:
select * from orders;
select * from book;

select b.book_id,b.title,b.stock,
	coalesce(sum(o.quantity),0) as order_quantity,
	b.stock - coalesce(sum(o.quantity),0) as remainning_quantity
from book b
	left join orders o ON b.book_id = o.order_id
group by b.book_id;


-- Basic SQL Question 
--Q1. Retrive all books in the 'Fiction' genre:
select * from book
where genus = 'Fiction';


--Q2. Find books published after the year 1950:
select * from book
where published_year >1950;


--Q3. List all the customer from the 'Canada':
select * from Customers
where country = 'Canada';

--Q4. Show orders placed in November 2023:
select * from Orders;

-- select * from Orders  -- Use in not 2023 or any year it show all year november months 
-- where EXTRACT(Month from order_date ) = 11;

select * from Orders
 	where order_date 
	Between '2023-11-01' AND '2023-11-30';


--Q5. Retrive the total stock of books avilable:
select 
    Sum(stock) as total_stock 
from book;

-- Q6. Find the details of the most expensive book:
select * from book;

select book_id,title,author,genus,published_year, price 
from book
order by price DESC 
limit 1;

-- Q7. Show all customers who ordered more than 1 quantity of a book:
select * from orders;

select customer_id from orders
where quantity > 1;

-- Q8.Retrive all orders where the total amount exceeds $20:
select * from orders
where total_amount > 20;

-- Q9.List all the genres avilabe in the Books table:
select * from book;
select distinct genus from book;

-- Q10. Book with the lowest 5 stock:
select title,author,stock from book
order by stock ASC limit 5;

-- Q11. Calculate the total revenue generated from all orders:
select sum(total_amount) as total_revenue 
from orders;