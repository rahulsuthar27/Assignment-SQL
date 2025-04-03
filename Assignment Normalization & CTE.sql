#Assignment sql
#Normalization & CTE
create table sakila;
use tableo;
#1. First Normal Form (1NF):
#a. Identify a table in the Sakila database that violates 1NF. Explain how you
#would normalize it to achieve 1NF.
"First Normal Form (1NF) in the Sakila Database
What is 1NF?
A table violates 1NF if:
It has duplicate rows (no unique identifier).
It has repeating or multivalued attributes (multiple values in a single column).
It does not have an atomic (indivisible) structure.
Table That Violates 1NF: film_textThe film_text table in the Sakila database stores film information but has repeating data issues:
Existing film_text Table (Violating 1NF)
film_id	title	description
1	ACADEMY DINOSAUR	A story of a T-Rex and a raptor who…
2	ACE GOLDFINGER	A secret agent fights evil…
1	ACADEMY DINOSAUR	A story of a T-Rex and a raptor who…
Problems:
✅ Duplicate film_id values → This violates 1NF.
✅ Non-atomic description column → It may contain multiple sentences, making it difficult to query efficiently.
How to Normalize film_text to Achieve 1NF?
Step 1: Remove Duplicate Rows
Ensure film_id is unique by setting it as a Primary Key.
Step 2: Separate description into Another Table
Move the descriptions to a new film_description table.
Normalized Schema (1NF)
New film Table (Ensuring Atomicity & Uniqueness)
film_id	title
1	ACADEMY DINOSAUR
2	ACE GOLDFINGER
New film_description Table (Separated Descriptions)
film_id	description
1	A story of a T-Rex and a raptor who…
2	A secret agent fights evil…
Key Fixes in 1NF:
✅ Each row is unique (no duplicates).
✅ Atomic values (each column contains a single value).
✅ No repeating groups (description moved to a separate table).
Final SQL to Achieve 1NF"

CREATE TABLE film (
    film_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE film_description (
    film_id INT PRIMARY KEY,
    description TEXT,
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

#2. Second Normal Form (2NF):
#a. Choose a table in Sakila and describe how you would determine whether it is in 2NF. 
#If it violates 2NF, explain the steps to normalize it
"Second Normal Form (2NF) in the Sakila Database
What is 2NF?
A table is in 2NF if:
✅ It is in 1NF (i.e., no duplicate rows, atomic columns).
✅ It has no partial dependencies → All non-key columns must depend only on the primary key, not part of it.
A table violates 2NF if:
A composite primary key exists, and some columns depend only on part of that key.
Table That Violates 2NF: rental
In the Sakila database, the rental table contains rental records.
Existing rental Table (Violating 2NF)
rental_id	customer_id	inventory_id	rental_date	return_date	customer_name
1	10	202	2024-03-01 10:00:00	2024-03-05 12:00:00	John Doe
2	15	305	2024-03-02 14:00:00	2024-03-06 11:00:00	Jane Smith
Primary Key: (rental_id)
rental_id uniquely identifies each rental.
Issue: Partial Dependency
customer_name depends only on customer_id, NOT on rental_id.
This violates 2NF because customer_name is not dependent on the entire primary key (rental_id).
How to Normalize rental to Achieve 2NF?
Step 1: Remove Partial Dependencies
Move customer_name to a new customer table (since it depends only on customer_id).
Normalized Schema (2NF)
New rental Table (No Partial Dependencies)
rental_id	customer_id	inventory_id	rental_date	return_date
1	10	202	2024-03-01 10:00:00	2024-03-05 12:00:00
2	15	305	2024-03-02 14:00:00	2024-03-06 11:00:00
New customer Table (Separate Customer Data)
customer_id	customer_name
10	John Doe
15	Jane Smith
✅ No partial dependency → customer_name now depends only on customer_id.
✅ Tables are linked by customer_id (Foreign Key).
Final SQL to Achieve 2NF"

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL
);

CREATE TABLE rental (
    rental_id INT PRIMARY KEY,
    customer_id INT,
    inventory_id INT,
    rental_date DATETIME,
    return_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

#3. Third Normal Form (3NF):
#a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies 
#present and outline the steps to normalize the table to 3NF.
"Third Normal Form (3NF) in the Sakila Database
What is 3NF?
A table is in 3NF if:
✅ It is in 2NF (i.e., no partial dependencies).
✅ It has no transitive dependencies → Non-key columns should depend only on the primary key, not on another non-key column.
A table violates 3NF if:
A non-key attribute (column) depends on another non-key attribute, instead of the primary key.
Table That Violates 3NF: customer
The customer table in the Sakila database contains customer details.
Existing customer Table (Violating 3NF)
customer_id	first_name	last_name	address_id	street_address	city_id	city_name	country_id	country_name
1	John	Doe	101	123 Main St	55	New York	8	USA
2	Jane	Smith	102	456 Elm St	65	London	2	UK
Primary Key: customer_id
customer_id uniquely identifies each customer.
Problem: Transitive Dependencies
city_name depends on city_id, not directly on customer_id → Transitive dependency
country_name depends on country_id, which depends on city_id → Transitive dependency
This violates 3NF because customer_id should not determine country_name through city_id.
How to Normalize customer to Achieve 3NF?
Step 1: Create a Separate city Table
Move city-related columns (city_id, city_name, country_id) into a city table.
Step 2: Create a Separate country Table
Move country-related columns (country_id, country_name) into a country table.
Step 3: Update the customer Table
Keep only direct customer information and refer to addresses using address_id.
Normalized Schema (3NF)
New customer Table (No Transitive Dependencies)
customer_id	first_name	last_name	address_id
1	John	Doe	101
2	Jane	Smith	102
New address Table (Separating Address Details)
address_id	street_address	city_id
101	123 Main St	55
102	456 Elm St	65
New city Table (Separating City Details)
city_id	city_name	country_id
55	New York	8
65	London	2
New country Table (Separating Country Details)
country_id	country_name
8	USA
2	UK
✅ No transitive dependency → customer_id now only determines address_id, and location data is split into separate tables.
✅ Easier updates → If a city or country name changes, update one place, not multiple rows.
Final SQL to Achieve 3NF"

CREATE TABLE country (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

CREATE TABLE city (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE address (
    address_id INT PRIMARY KEY,
    street_address VARCHAR(255) NOT NULL,
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

#4. Normalization Process:
#a. Take a specific table in Sakila and guide through the process of normalizing it from the initial 
#unnormalized form up to at least 2NF.
"Normalization Process in the Sakila Database
Let’s take the rental table from the Sakila database and normalize it step by step from Unnormalized Form (UNF) → 1NF → 2NF.
Step 1: Unnormalized Form (UNF)
A table is in UNF if it contains:
Duplicate data
Repeating groups (multiple values in a single column)
No clear primary key
Unnormalized rental Table (UNF)
rental_id	customer_name	phone_number	film_titles (Multiple values)	rental_date	return_date
1	John Doe	9876543210	Matrix, Inception	2024-03-01 10:00:00	2024-03-05 12:00:00
2	Jane Smith	8765432109	Avatar	2024-03-02 14:00:00	2024-03-06 11:00:00
3	John Doe	9876543210	Titanic, Interstellar	2024-03-05 16:30:00	2024-03-10 09:00:00
Problems in UNF:
film_titles contains multiple values in one column (not atomic).
customer_name and phone_number repeat (no unique customer identifier).
Step 2: Convert to First Normal Form (1NF)
Make all attributes atomic (single value per cell)
Identify a primary key
Eliminate repeating groups
Transformed rental Table (1NF)
rental_id	customer_name	phone_number	film_title	rental_date	return_date
1	John Doe	9876543210	Matrix	2024-03-01 10:00:00	2024-03-05 12:00:00
1	John Doe	9876543210	Inception	2024-03-01 10:00:00	2024-03-05 12:00:00
2	Jane Smith	8765432109	Avatar	2024-03-02 14:00:00	2024-03-06 11:00:00
3	John Doe	9876543210	Titanic	2024-03-05 16:30:00	2024-03-10 09:00:00
3	John Doe	9876543210	Interstellar	2024-03-05 16:30:00	2024-03-10 09:00:00
film_titles column is now split into separate rows (atomic).
No more multiple values in a single cell.
A composite primary key (rental_id, film_title) can be used, but this leads to partial dependencies, which 2NF will fix.
Step 3: Convert to Second Normal Form (2NF)
Ensure no partial dependencies (all non-key attributes must depend on the whole primary key).
Separate customer details into a customer table (as customer_name and phone_number depend only on customer_id, not on rental_id).
Separate film details into a film table (as film_title should depend only on film_id).
New Tables in 2NF
rental Table (Now in 2NF)
rental_id	customer_id	inventory_id	rental_date	return_date
1	10	202	2024-03-01 10:00:00	2024-03-05 12:00:00
1	10	203	2024-03-01 10:00:00	2024-03-05 12:00:00
2	15	305	2024-03-02 14:00:00	2024-03-06 11:00:00
3	10	408	2024-03-05 16:30:00	2024-03-10 09:00:00
3	10	409	2024-03-05 16:30:00	2024-03-10 09:00:00
customer Table (Separating Customer Data)
customer_id	customer_name	phone_number
10	John Doe	9876543210
15	Jane Smith	8765432109
inventory Table (Separating Film Details)
inventory_id	film_id
202	1
203	2
305	3
408	4
409	5
film Table (Ensuring Unique Film Titles)
film_id	title
1	Matrix
2	Inception
3	Avatar
4	Titanic
5	Interstellar
customer_name and phone_number moved to customer table (removes partial dependency).
film_title moved to film table (removes dependency on rental_id).
inventory_id is used to track film copies in rental stores.
Final SQL for 2NF"

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE film (
    film_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    film_id INT,
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

CREATE TABLE rental (
    rental_id INT PRIMARY KEY,
    customer_id INT,
    inventory_id INT,
    rental_date DATETIME,
    return_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
);

#5. CTE Basics:
#a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they 
#have acted in from the actor and film_actor tables.
WITH ActorFilmCount AS (
    SELECT 
        fa.actor_id, 
        a.first_name, 
        a.last_name, 
        COUNT(fa.film_id) AS film_count
    FROM film_actor fa
    JOIN actor a ON fa.actor_id = a.actor_id
    GROUP BY fa.actor_id, a.first_name, a.last_name
)  
SELECT first_name, last_name, film_count  
FROM ActorFilmCount  
ORDER BY film_count DESC;

#6. CTE with Joins:
#a. Create a CTE that combines information from the film and language tables to display the film title, 
#language name, and rental rate.
WITH FilmLanguage AS (
    SELECT 
        f.title, 
        l.name AS language_name, 
        f.rental_rate
    FROM film f
    JOIN language l ON f.language_id = l.language_id
)  
SELECT title, language_name, rental_rate  
FROM FilmLanguage  
ORDER BY rental_rate DESC;

#7.CTE for Aggregation:
#a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) 
#from the customer and payment tables.
WITH CustomerRevenue AS (
    SELECT 
        p.customer_id, 
        c.first_name, 
        c.last_name, 
        SUM(p.amount) AS total_revenue
    FROM payment p
    JOIN customer c ON p.customer_id = c.customer_id
    GROUP BY p.customer_id, c.first_name, c.last_name
)  
SELECT customer_id, first_name, last_name, total_revenue  
FROM CustomerRevenue  
ORDER BY total_revenue DESC;

#8.CTE with Window Functions:
#a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.
WITH CustomerRevenue AS (
    SELECT 
        p.customer_id, 
        c.first_name, 
        c.last_name, 
        SUM(p.amount) AS total_revenue
    FROM payment p
    JOIN customer c ON p.customer_id = c.customer_id
    GROUP BY p.customer_id, c.first_name, c.last_name
)  
SELECT customer_id, first_name, last_name, total_revenue  
FROM CustomerRevenue  
ORDER BY total_revenue DESC;

#9CTE and Filtering:
#a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the 
#customer table to retrieve additional customer details
WITH FrequentRenters AS (
    SELECT 
        rental.customer_id, 
        COUNT(rental.rental_id) AS rental_count
    FROM rental
    GROUP BY rental.customer_id
    HAVING COUNT(rental.rental_id) > 2
)  
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.email, 
    c.address_id, 
    f.rental_count
FROM FrequentRenters f
JOIN customer c ON f.customer_id = c.customer_id
ORDER BY f.rental_count DESC;

#10.CTE for Date Calculations:
#a. Write a query using a CTE to find the total number of rentals made each month, considering the 
#rental_date from the rental tabl
WITH MonthlyRentals AS (
    SELECT 
        DATE_FORMAT(rental_date, '%Y-%m') AS rental_month, 
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY rental_month
)  
SELECT rental_month, total_rentals  
FROM MonthlyRentals  
ORDER BY rental_month;

#11.CTE and Self-Join:
#a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film 
#together, using the film_actor table.
WITH ActorPairs AS (
    SELECT 
        fa1.film_id, 
        fa1.actor_id AS actor1_id, 
        a1.first_name AS actor1_first_name, 
        a1.last_name AS actor1_last_name, 
        fa2.actor_id AS actor2_id, 
        a2.first_name AS actor2_first_name, 
        a2.last_name AS actor2_last_name
    FROM film_actor fa1
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id  
        AND fa1.actor_id < fa2.actor_id  -- Avoid duplicate and self-pairing
    JOIN actor a1 ON fa1.actor_id = a1.actor_id
    JOIN actor a2 ON fa2.actor_id = a2.actor_id
)  
SELECT * FROM ActorPairs  
ORDER BY film_id, actor1_last_name, actor2_last_name;

#12. CTE for Recursive Search:
#a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, 
#considering the reports_to column
WITH RECURSIVE StaffHierarchy AS (
    -- Base case: Select the manager (change the manager's staff_id as needed)
    SELECT 
        staff_id, 
        first_name, 
        last_name, 
        reports_to, 
        1 AS level
    FROM staff
    WHERE staff_id = <MANAGER_ID>  -- Replace with the actual manager's ID

    UNION ALL

    -- Recursive case: Find employees who report to the previously selected employees
    SELECT 
        s.staff_id, 
        s.first_name, 
        s.last_name, 
        s.reports_to, 
        sh.level + 1 AS level
    FROM staff s
    JOIN StaffHierarchy sh ON s.reports_to = sh.staff_id
)  
SELECT * FROM StaffHierarchy  
ORDER BY level, last_name;
