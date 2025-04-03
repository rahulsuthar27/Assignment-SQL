#Assignment sql
#SQL basics
#1.1. Create a table called employees with the following structure?
# emp_id (integer, should not be NULL and should be a primary key)Q
#emp_name (text, should not be NULL)Q
#age (integer, should have a check constraint to ensure the age is at least 18)Q
#email (text, should be unique for each employee)Q
#salary (decimal, with a default value of 30,000).

#1.Write the SQL query to create the above table with all constraints.
use tableo;
create table employee(
emmp_id int primary key,
emp_name varchar (50) not null,
age int check (age>18),
email varchar (50) unique,
salary float default 30000);

#2.Explain the purpose of constraints and how they help maintain data integrity in a database 
"Provide examples of common types of constraints."
"Constraints in a database are rules enforced on data to ensure its accuracy, consistency, and reliability. They help maintain 
data integrity by preventing invalid or inconsistent data from being entered into the database. Constraints enforce business 
rules, maintain relationships between tables, \and prevent accidental deletion or modification of critical data.
How Constraints Help Maintain Data IntegrityPrevent Invalid Data Entry – Constraints restrict data input to valid values only, 
ensuring data quality.Maintain Consistency – They ensure that data across different tables remains consistent.
Enforce Uniqueness – Constraints prevent duplicate values in fields where uniqueness is required.
Preserve Referential Integrity – Constraints maintain valid relationships between tables by ensuring foreign keys reference 
existing values.Improve Data Reliability – By enforcing rules, constraints ensure that the database remains trustworthy and 
useful for analysis.Common Types of Constraints
NOT NULL – Ensures that a column cannot have NULL values.
Example: A Customers table may have a phone_number column marked as NOT NULL to ensure that every customer has a contact 
number.
UNIQUE – Ensures that all values in a column are distinct.
Example: An email column in a Users table should have a UNIQUE constraint to prevent duplicate email registrations.
PRIMARY KEY – Uniquely identifies each record in a table. It combines NOT NULL and UNIQUE constraints.
Example: The id column in an Employees table can be a PRIMARY KEY to ensure each employee has a unique identifier.
FOREIGN KEY – Enforces referential integrity by ensuring that a value in one table exists in another table.
Example: A customer_id in an Orders table should reference an existing id in the Customers table.
CHECK – Ensures that values in a column satisfy a specific condition.
Example: A salary column in an Employees table can have a CHECK constraint to ensure salaries are greater than zero (salary > 0).
DEFAULT – Provides a default value for a column if no value is specified.
Example: A status column in an Orders table might have a default value of Pending if no status is provided during data entry.
INDEX – Improves database performance by creating indexes on columns, though it is not strictly a constraint.
Example: Creating an index on a last_name column in an Employees table can speed up searches for employees by last name."

#3.Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify your answer.
"The NOT NULL constraint ensures that a column cannot store NULL values, which helps maintain data integrity by preventing 
missing or incomplete data. This is particularly useful when a field must always have a meaningful value.
Reasons to Use NOT NULL Constraint:
Ensures Mandatory Data Entry – Prevents essential data from being omitted.
Maintains Data Consistency – Guarantees that required information is always available.
Supports Business Logic – Some attributes, like a customer's email in a user database, are necessary for operations.'''
Avoids NULL-related Issues in Queries – NULL values can complicate calculations and comparisons in SQL queries.
No, a primary key cannot contain NULL values.
Justification:
Uniqueness and Identification – A primary key uniquely identifies each record in a table. If NULL were allowed, 
multiple rows could have NULL as their primary key, violating uniqueness.
Indexing and Search Optimization – Primary keys are indexed automatically. NULL values can disrupt indexing,
 making lookups inefficient.'''
Referential Integrity – Foreign keys reference primary keys. If a primary key contained NULL, 
a foreign key referencing it would lose its integrity, leading to orphaned records"

#4.Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an 
#example for both adding and removing a constraint.
"Adding a Constraint to an Existing Table
Steps:
Identify the table and column where the constraint needs to be added.
Use the ALTER TABLE command along with ADD CONSTRAINT.
Specify the type of constraint (e.g., NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK).
Example: Adding a UNIQUE Constraint
Suppose we have a Customers table and want to ensure that the email column has unique values."
ALTER TABLE Customers  
ADD CONSTRAINT unique_email UNIQUE (email);
"Removing a Constraint from an Existing Table
Steps:
Identify the constraint name (constraints have unique names in a database).
Use the ALTER TABLE command with DROP CONSTRAINT.
Some constraints like NOT NULL require modifying the column itself.
Example: Removing the UNIQUE Constraint
If we need to remove the unique_email constraint added earlier:"
ALTER TABLE Customers  
#DROP CONSTRAINT unique_email;

#5.Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints 
Provide an example of an error message that might occur when violating a constraint
"Consequences of Violating Constraints in a Database
When attempting to insert, update, or delete data that violates constraints, the database management system (DBMS) 
will reject the operation and return an error message. These constraints ensure data integrity and consistency. 
Below are the consequences of violating different constraints:
1. Violation of NOT NULL Constraint
Consequence: The operation fails if a required column is left NULL.
Example Scenario: 
Trying to insert a record without providing a mandatory field.
Error Message (MySQL):
ERROR: Column 'email' cannot be null
Example:"
INSERT INTO Customers (customer_id, name, email) VALUES (1, 'John Doe', NULL);
"If the email column is NOT NULL, the database will reject this insertion.
2. Violation of UNIQUE Constraint
Consequence: The operation fails if a duplicate value is inserted into a column that requires unique values.
Example Scenario: Attempting to insert the same email twice.
Error Message (MySQL/PostgreSQL):
ERROR: Duplicate entry 'john.doe@email.com' for key 'unique_email'
Example:"
INSERT INTO Customers (customer_id, name, email) VALUES (2, 'Jane Doe', 'john.doe@email.com');
"If john.doe@email.com already exists in the email column, the operation is rejected.
3. Violation of PRIMARY KEY Constraint
Consequence: The operation fails if a duplicate value is inserted into a primary key column or if a NULL value is attempted in a primary key.
Example Scenario: Trying to insert a duplicate customer ID.
Error Message (PostgreSQL):
ERROR: duplicate key value violates unique constraint "customers_pkey"
Example:"
#INSERT INTO Customers (customer_id, name, email) VALUES (1, 'Michael Scott', 'michael@email.com');
"If customer_id = 1 already exists, the operation fails.
4. Violation of FOREIGN KEY Constraint
Consequence: The operation fails if a referenced key does not exist in the parent table.
Example Scenario: Trying to insert an order for a non-existent customer.
Error Message (PostgreSQL/MySQL):
ERROR: Insert or update on table 'Orders' violates foreign key constraint 'fk_customer'
Example:"
#INSERT INTO Orders (order_id, customer_id, order_date) VALUES (101, 999, '2024-04-03');
"If customer_id = 999 does not exist in the Customers table, the insertion is rejected."

#6. You created a products table without constraints as follows:
CREATE TABLE products (
product_id INT,
product_name VARCHAR(50),
price DECIMAL(10, 2));
#Now, you realise that?
#: The product_id should be a primary keyQ
#: The price should have a default value of 50.00
#answ

alter table products
add constraint primary key (product_id);

alter table products
modify column price decimal default 50.00;

#7.You have two tables:
#student and classes
#Write a query to fetch the student_name and class_name for each student using an INNER JOIN
create table student(
student_id int,
student_name varchar (50),
class_id int 
);
create table class(
class_id int,
class_name varchar (50)
);
insert into student
values
(1,'alice',101),
(2,'bob',102),
(3,'charlie',101);
insert into class
values
(101,'math'),
(102,'science'),
(103,'history');

select student_name,class_name 
from student as s
inner join class as c
on s.class_id=c.class_id;

#8. Consider the following three tables:
#orders
#customers
#products
#Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are 
#listed even if they are not associated with an order

create table orders(
order_id int,
order_date date,
customer_id int
);
create table customers(
customer_id int,
customer_name varchar (50)
);
create table products(
product_id int,
product_name varchar (50),
order_id int 
);

insert into orderw
values
(1,'2024-01-01',101),
(2,'2024-01-03',102);

insert into customerw
values
(101,'alice'),
(102,'bob');

insert into producw
values
(1,'laptop',1),
(2,'phone',null);

select pt.product_name,oe.order_id,co.customer_id
from product as pt
left join orders as oe
on pt.order_id=oe.order_id 
left join customer as co
on oe.customer_id=co.customer_id;

#9.Given the following tables:
#sales,product
#Write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function.
create table sales(
sales_id int,
product_id int,
amount int
);
insert into sales
values
(1,101,500),
(2,102,300),
(3,101,700);
select pt.product_name,sum(s.amount) as total_sales
from product as pt
inner join sales as s
on pt.product_id=s.product_id
group by pt.product_name;

#10. You are given three tables:
#orders,customers,order_details
#Write a query to display the order_id, customer_name, and the quantity of products ordered by each customer 
create table orders(
order_id int,
order_date date,
customer_id int
);
insert into orders
values
(1,'2024-01-01',101),
(2,'2024-01-03',102);
create table order_details(
order_id int,
product_id int,
quantity int);
insert into order_details
values
(1,101,2),
(1,102,1),
(2,101,3);

select oe.order_id,co.customer_name,os.quantity
from orders as oe
inner join customers as co
on oe.customer_id=co.customer_id
inner join order_details as os
on oe.order_id=os.order_id;

