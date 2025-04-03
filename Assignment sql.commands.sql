#Assignment
#SQL Commands
create database sakila;
use sakila;
#1-Identify the primary keys and foreign keys in maven movies db. Discuss the differences
"In the Maven Movies database, the primary keys (PKs) and foreign keys (FKs) are crucial for maintaining relationships between tables. Here’s how they function:
Primary Keys (PKs):
A primary key is a unique identifier for each record in a table. It ensures that each row is uniquely identifiable.
A PK cannot contain NULL values.
Each table typically has one PK.
Example Primary Keys in Maven Movies DB:
actor_id in the actor table.
film_id in the film table.
customer_id in the customer table.
rental_id in the rental table.
Foreign Keys (FKs):
A foreign key is a field (or set of fields) in one table that refers to the primary key in another table.
It establishes a relationship between the two tables.
It helps enforce referential integrity (i.e., ensuring data consistency).
Example Foreign Keys in Maven Movies DB:
film_id in the film_actor table (References film_id in the film table).
customer_id in the rental table (References customer_id in the customer table).
inventory_id in the rental table (References inventory_id in the inventory table)."

#2- List all details of actors
select * from actor;

#3 -List all customer information from DB.
select * from customer;

#4 -List different countries.
select distinct * from country;

#5 -Display all active customers.
select * from customer
where active=1;

#6 -List of all rental IDs for customer with ID 1.
select rental_id,customer_id
from rental
where customer_id=1;

#7.display all the film whose rental duration is greater than5. 
select * from film
where rental_duration >5;

#8 - List the total number of films whose replacement cost is greater than $15 and less than $20.
select * from film 
where replacement_cost between 15 and 20;

#9.- Display the count of unique first names of actors.
select count(distinct first_name)
from actor;

#10- Display the first 10 records from the customer table 
select * from customer
limit 10;

#11 - Display the first 3 records from the customer table whose first name starts with ‘b’.
select * from actor
where first_name like 'b%'
limit 3
offset 0;

#12 -Display the names of the first 5 movies which are rated as ‘G’.
select * from film
where rating ='G';

#13.-Find all customers whose first name starts with "a".
select * from customer
where first_name like 'a%';

#14- Find all customers whose first name ends with "a".
select * from customer
where first_name like '%a';

#15- Display the list of first 4 cities which start and end with ‘a’ .
select * from city
where city like 'a%%a';

#16- Find all customers whose first name have "NI" in any position.
select * from customer
where first_name like '%NI%';

#17- Find all customers whose first name have "r" in the second position .
select * from customer
where first_name like '_r%';

#18 - Find all customers whose first name starts with "a" and are at least 5 characters in length.
select * from customer
where first_name like 'a%_____';

#19- Find all customers whose first name starts with "a" and ends with "o".
select * from customer
where first_name like 'a%%o';

#20 - Get the films with pg and pg-13 rating using IN operator.
select * from film
where rating in ('pg', 'pg-13');

#21 - Get the films with length between 50 to 100 using between operator.
select * from film
where length between 50 and 100;

#22 - Get the top 50 actors using limit operator.
select * from actor 
limit 50;

#23 - Get the distinct film ids from inventory table.
select distinct film_id from inventory;