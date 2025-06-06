#Assignment sql
#Windows Function:
create table sakila;
use sakila;
#1. Rank the customers based on the total amount they've spent on rentals.
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(p.amount) AS total_spent,  
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS ranking  
FROM customer c  
JOIN payment p ON c.customer_id = p.customer_id  
GROUP BY c.customer_id, c.first_name, c.last_name  
ORDER BY ranking;

#2.Calculate the cumulative revenue generated by each film over time.
SELECT  f.title,  p.payment_date,  SUM(p.amount) OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative_revenue  
FROM payment p  
JOIN rental r ON p.rental_id = r.rental_id  
JOIN inventory i ON r.inventory_id = i.inventory_id  
JOIN film f ON i.film_id = f.film_id  
ORDER BY f.title, p.payment_date;

#3.Determine the average rental duration for each film, considering films with similar lengths.
SELECT  f.title,  f.length AS film_length,  AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_duration,  
NTILE(5) OVER (ORDER BY f.length) AS length_category  
FROM film f  
JOIN inventory i ON f.film_id = i.film_id  
JOIN rental r ON i.inventory_id = r.inventory_id  
WHERE r.return_date IS NOT NULL  
GROUP BY f.film_id, f.title, f.length  
ORDER BY length_category, avg_rental_duration DESC;

#4. Identify the top 3 films in each category based on their rental counts.
WITH RankedFilms AS (  
    SELECT  c.name AS category_name,  f.title,  COUNT(r.rental_id) AS rental_count,  
	RANK() OVER (PARTITION BY c.category_id ORDER BY COUNT(r.rental_id) DESC) AS ranking  
    FROM film f  
    JOIN film_category fc ON f.film_id = fc.film_id  
    JOIN category c ON fc.category_id = c.category_id  
    JOIN inventory i ON f.film_id = i.film_id  
    JOIN rental r ON i.inventory_id = r.inventory_id  
    GROUP BY c.category_id, c.name, f.film_id, f.title  
)  
SELECT * FROM RankedFilms WHERE ranking <= 3  
ORDER BY category_name, ranking;

#5. Calculate the difference in rental counts between each customer's total rentals and the average rentalsacross all customers.
WITH CustomerRentals AS (  
    SELECT  
        c.customer_id,  
        c.first_name,  
        c.last_name,  
        COUNT(r.rental_id) AS total_rentals  
    FROM customer c  
    JOIN rental r ON c.customer_id = r.customer_id  
    GROUP BY c.customer_id, c.first_name, c.last_name  
),  
AverageRentals AS (  
    SELECT AVG(total_rentals) AS avg_rentals FROM CustomerRentals  
)  
SELECT  cr.customer_id,  cr.first_name,  cr.last_name,  cr.total_rentals,  ar.avg_rentals,  (cr.total_rentals - ar.avg_rentals) AS rental_difference  
FROM CustomerRentals cr, AverageRentals ar  
ORDER BY rental_difference DESC;

#6. Find the monthly revenue trend for the entire rental store over time
SELECT  
    DATE_FORMAT(p.payment_date, '%Y-%m') AS month,  
    SUM(p.amount) AS total_revenue  
FROM payment p  
GROUP BY month  
ORDER BY month;

#7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.
WITH CustomerSpending AS (  
    SELECT  
        c.customer_id,  
        c.first_name,  
        c.last_name,  
        SUM(p.amount) AS total_spent  
    FROM customer c  
    JOIN payment p ON c.customer_id = p.customer_id  
    GROUP BY c.customer_id, c.first_name, c.last_name  
),  
RankedCustomers AS (  
    SELECT *,  
           PERCENT_RANK() OVER (ORDER BY total_spent DESC) AS percentile_rank  
    FROM CustomerSpending  
)  
SELECT customer_id, first_name, last_name, total_spent  
FROM RankedCustomers  
WHERE percentile_rank >= 0.80  
ORDER BY total_spent DESC;

#8. Calculate the running total of rentals per category, ordered by rental count
WITH CategoryRentals AS (  
    SELECT  
        c.name AS category_name,  
        COUNT(r.rental_id) AS rental_count  
    FROM category c  
    JOIN film_category fc ON c.category_id = fc.category_id  
    JOIN film f ON fc.film_id = f.film_id  
    JOIN inventory i ON f.film_id = i.film_id  
    JOIN rental r ON i.inventory_id = r.inventory_id  
    GROUP BY c.name  
)  
SELECT  
    category_name,  
    rental_count,  
    SUM(rental_count) OVER (ORDER BY rental_count DESC) AS running_total  
FROM CategoryRentals  
ORDER BY rental_count DESC;

#9. Find the films that have been rented less than the average rental count for their respective categories.
WITH FilmCategoryRentals AS (  
    SELECT  
        f.film_id,  
        f.title,  
        c.category_id,  
        c.name AS category_name,  
        COUNT(r.rental_id) AS film_rental_count  
    FROM film f  
    JOIN film_category fc ON f.film_id = fc.film_id  
    JOIN category c ON fc.category_id = c.category_id  
    JOIN inventory i ON f.film_id = i.film_id  
    JOIN rental r ON i.inventory_id = r.inventory_id  
    GROUP BY f.film_id, f.title, c.category_id, c.name  
),  
CategoryAverageRentals AS (  
    SELECT  
        category_id,  
        AVG(film_rental_count) AS avg_category_rentals  
    FROM FilmCategoryRentals  
    GROUP BY category_id  
)  
SELECT  
    fcr.film_id,  
    fcr.title,  
    fcr.category_name,  
    fcr.film_rental_count,  
    car.avg_category_rentals  
FROM FilmCategoryRentals fcr  
JOIN CategoryAverageRentals car ON fcr.category_id = car.category_id  
WHERE fcr.film_rental_count < car.avg_category_rentals  
ORDER BY fcr.category_name, fcr.film_rental_count ASC;

#10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.
SELECT  
    DATE_FORMAT(payment_date, '%Y-%m') AS month,  
    SUM(amount) AS total_revenue  
FROM payment  
GROUP BY month  
ORDER BY total_revenue DESC  
LIMIT 5;




