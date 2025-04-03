#Assignmnet sql
#joins
create database sakila;
use sakila;
use tableo;

#Questions 9 -
#Display the title of the movie, customer s first name, and last name who rented it
select film.title,customer.first_name,customer.last_name
from film
inner join inventory
on film.film_id=inventory.inventory_id
inner join rental
on inventory.inventory_id=rental.inventory_id
inner join customer
on rental.customer_id=customer.customer_id;

#Question 10:
#Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
select actor.first_name,actor.last_name
from actor
inner join film_actor
on actor.actor_id=film_actor.actor_id
inner join film
on film_actor.film_id=film.film_id
where film.title="Gone with the Wind";

#Question 11:
#Retrieve the customer names along with the total amount they've spent on rentals.
select customer.first_name,customer.last_name,payment.rental_id,sum(payment.amount)
from customer
inner join payment
on customer.customer_id=payment.payment_id
group by customer.first_name,customer.last_name,payment.rental_id;

#Question 12:
#List the titles of movies rented by each customer in a particular city (e.g., 'London').
select film.title,customer.first_name
from film
inner join inventory
on film.film_id=inventory.film_id
inner join rental
on inventory.inventory_id=rental.inventory_id
inner join customer
on rental.customer_id=customer.customer_id
inner join address
on customer.address_id=address.address_id
inner join city
on address.city_id=city.city_id
where city.city = 'London';

