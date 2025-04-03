#Assignment sql
#Advance join and group by
create table sakila;
use sakila;
#Question 13:
#Display the top 5 rented movies along with the number of times they've been rented.
select film.title,count(rental.rental_id) as total_count
from film
inner join inventory
on film.film_id=inventory.film_id
inner join rental
on inventory.inventory_id=rental.inventory_id
group by film.title
order by total_count desc
limit 5;

#Question 14:
#Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
SELECT customer.customer_id, customer.first_name, customer.last_name  
FROM customer 
JOIN rental  ON customer.customer_id = rental.customer_id  
JOIN inventory  ON rental.inventory_id = inventory.inventory_id  
WHERE inventory.store_id IN (1, 2)  
GROUP BY customer.customer_id, customer.first_name, customer.last_name  
HAVING COUNT(DISTINCT inventory.store_id) = 2;

