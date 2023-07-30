-- CREATING DATABASE
create database testdb3;


-- CREATING TABLE AND DEFINING ITS STRUCTURE
create table customer
(
customer_id int8 PRIMARY KEY,
first_name varchar(50),
last_name varchar(50),
email varchar (100),
address_id int8
);


-- Inserting new row
INSERT INTO payment values (17, 100, 'UPI', '2022-06-27');


-- CHECKING THE STRUCTURE
desc customer;


-- LOADING DATA FROM CSV INTO THE TABLE
LOAD DATA INFILE "customer.csv"
INTO TABLE customer
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



-- Secure folder Location for Data Import  -   /*SHOW VARIABLES LIKE 'secure_file_priv';*/

select * from customer where last_name = "Smith";

-- extracting month from table date coloumn in the table
SELECT *, extract(month from payment_date) as date from Payment;
SELECT *, extract(quarter from payment_date) as week from Payment;
SELECT *, extract(day from payment_date) as day from Payment;


-- STRING FUNCTIONS
-- String functions are used to perform an operation on input string and  return an output string
SELECT CONCAT(first_name, ' ', last_name ) from customer
ORDER BY CONCAT(first_name, ' ', last_name) ASC;

SELECT CHAR_LENGTH(EMAIL) AS LEN FROM CUSTOMER;

SELECT concat_ws("-", first_name, last_name) AS LEN FROM CUSTOMER;


-- WILDCARDS
select * from customer where first_name like "M%";

SELECT customer_id, mode
from payment
where mode like
'D%D';


-- SUB-QUERY
/* A Subquery or Inner query or a Nested query allows us to 
create complex query on the output of another query
• Sub query syntax involves two SELECT statements */

SELECT email,max(address_id) as High from customer where address_id <> (SELECT max(address_id) from customer);

SELECT email, MAX(address_id) AS High
FROM customer
WHERE address_id < (SELECT MAX(address_id) FROM customer);

-- EMAIL WITH 2nd HIGHEST CHARACTER COUNT (Subquery)
SELECT email
FROM customer
WHERE address_id = (
  SELECT MAX(address_id)
  FROM customer
  WHERE address_id < (
    SELECT MAX(address_id)
    FROM customer
  )
);


-- creating Payment table and defining it's structure
create table Payment
(
customer_id int primary key,
amount int,
mode varchar(50),
payment_date date
);

-- Loading CSV into table
LOAD DATA INFILE 'payment.csv'
INTO TABLE Payment
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

SELECT * from payment;
SELECT * from customer;


-- AGGREGATE FUNCTION
/* Aggregate function performs a calculation on multiple values and 
returns a single value. 
And Aggregate functiona are often used with GROUP BY & SELECT 
statement*/
select avg(amount) from Payment;
select round(avg(amount), 2 ) from Payment;


-- Group by and Having clause

-- GROUP BY
/* The GROUP BY statement group rows that have the same values into 
summary rows.
It is often used with aggregate functions (COUNT(), MAX(), MIN(), SUM(), 
AVG()) to group the result-set by one or more columns */

select mode, sum(amount) as groupsum
from payment
group by mode
order by groupsum ASC;

select mode, round(avg(amount) , 2) as groupsum
from payment
group by mode
order by groupsum desc;

-- HAVING
/* The HAVING clause is used to apply a filter on the result of GROUP BY based on the 
specified condition.
The WHERE clause places conditions on the selected columns, whereas the HAVING 
clause places conditions on groups created by the GROUP BY clause */

select mode, round(avg(amount) , 2) as groupsum
from payment
group by mode
having groupsum > 45;


-- Inserting a New Coloumn in Customer Table to understand the concept of all the JOINS
Insert into Customer 
values
(16, 'Rahul', 'Negi', 'rahulnegi1555@gmail.com', 77);


-- JOINS

-- INNER JOIN
-- Returns records that have matching values in both tables
SELECT customer.customer_id, payment.mode
FROM Customer
inner join Payment ON customer.customer_id = payment.customer_id;


-- LEFT JOIN
-- Returns all records from the left table, and the matched records from the right table
SELECT customer.customer_id, payment.mode
FROM Customer
left join Payment ON customer.customer_id = payment.customer_id;


-- RIGHT JOIN
-- Returns all records from the Right table, and the matched records from the Left table
SELECT customer.customer_id, payment.mode
FROM Customer
right join Payment ON customer.customer_id = payment.customer_id;


-- Query for Power Bi
Select *, day(payment_date), month(payment_date), year(payment_date) from Payment;


-- CASE STATEMENTS

/*  The CASE expression goes through conditions and returns 
a value when the first condition is met (like if-then-else 
statement). If no conditions are true, it returns the value 
in the ELSE clause.
• If there is no ELSE part and no conditions are true, it 
returns NULL  */
select customer_id, amount,
	CASE
		WHEN amount >= 50 THEN "High Transaction"
		WHEN amount >=30 and amount < 50 THEN "Moderate Transaction"
		WHEN amount < 30 THEN "Low Transaction"
	END AS Transaction_Status
from payment;


-- UNION  and  UNION ALL

/*  UNION - The SQL UNION clause/operator is used to combine/concatenate the results 
of two or more SELECT statements without returning any duplicate rows and 
keeps unique records  */
Select customer_id from customer
UNION
Select customer_id from payment;


-- UNION ALL -  Same as Union but but it displays all records, including duplicates 
Select customer_id from customer
UNION
Select customer_id from payment;

