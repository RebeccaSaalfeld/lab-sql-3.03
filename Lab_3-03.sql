USE sakila;
#How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(distinct inventory_id) FROM sakila.film
JOIN sakila.inventory i USING(film_id)
WHERE title='Hunchback Impossible';

#List all films whose length is longer than the average of all the films.

SELECT title, length
FROM sakila.film
WHERE length > (
	SELECT AVG(length)
	FROM sakila.film
    );


#Use subqueries to display all actors who appear in the film Alone Trip.

	SELECT first_name, last_name FROM sakila.actor
    WHERE actor_id IN(
    SELECT actor_id FROM sakila.film_actor
    WHERE film_id = (
		SELECT film_id
		FROM sakila.film 
		WHERE title='Alone Trip'
        )
	)
	;


#Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
SELECT title FROM sakila.film
WHERE film_id IN (
	SELECT film_id FROM sakila.film_category
	WHERE category_id = ( 
		SELECT category_id FROM sakila.category
		WHERE name = 'Family'
		)
	);


#Get name and email from customers from Canada using subqueries. Do the same with joins. 
#Note that to create a join, you will have to identify the correct tables with their primary keys and 
#foreign keys, that will help you get the relevant information.

SELECT first_name, last_name, email FROM sakila.customer
WHERE address_id IN (
	SELECT address_id FROM sakila.address
	WHERE city_id IN (
		SELECT city_id FROM sakila.city
		WHERE country_id = (
			SELECT country_id FROM sakila.country
			WHERE country = 'Canada')
		)
	)
;


SELECT cu.first_name, cu.last_name, cu.email 
FROM sakila.customer cu
JOIN sakila.address ad USING (address_id)
JOIN sakila.city ci USING (city_id)
JOIN sakila.country co USING (country_id)
WHERE co.country = 'Canada';

#Which are films starred by the most prolific actor? 
#Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor and then use that actor_id to find the different films 
#that he/she starred.

SELECT title
FROM sakila.film
WHERE film_id IN(
    SELECT film_id
	FROM sakila.film_actor
	WHERE film_actor.actor_id IN (
		SELECT sub1.actor_id FROM(
			SELECT actor_id, COUNT(film_id)
			FROM sakila.film_actor
			GROUP BY actor_id
			ORDER BY COUNT(film_id) DESC
			LIMIT 1
			)sub1
		)
	);

#Films rented by most profitable customer. 
#You can use the customer table and payment table to find the most profitable customer ie the customer 
#that has made the largest sum of payments

SELECT title
FROM sakila.film
WHERE film_id IN(
	SELECT film_id
	FROM sakila.inventory
	WHERE inventory_id IN(
	SELECT rental_id
		FROM sakila.rental
		WHERE customer_id IN (
			SELECT sub2.customer_id FROM(
				SELECT customer_id, SUM(amount)
				FROM sakila.payment
				GROUP BY customer_id
				ORDER BY SUM(amount) DESC
				LIMIT 1
				)sub2
			)
		)
);


SELECT
	film.title
FROM
	sakila.film
WHERE film.film_id IN
	(
    SELECT 
		inventory.film_id
	FROM
		sakila.inventory
	WHERE inventory.inventory_id IN
		(
		SELECT
			rental.inventory_id
		FROM
			sakila.rental
		WHERE
			rental.customer_id IN
            (
            SELECT
				customer.customer_id
			FROM
				sakila.customer
			WHERE customer.customer_id IN
				(SELECT 
					foo.customer_id 
				FROM
					(
					SELECT 
						payment.customer_id
						, sum(payment.amount) AS pay
					FROM
						sakila.payment
					GROUP BY
						payment.customer_id
					ORDER BY 
						pay DESC
					LIMIT
						1
					) AS foo
				)
			)
        )    
     )       
;





#Customers who spent more than the average payments.










-- Customers who spent more than the average payments.
select concat(last_name, ', ', first_name) as Name from sakila.customer
where customer_id in (
	select customer_id
    from rental
    where RENTAL_ID IN(
		SELECT rental_id
		FROM sakila.payment
		where payment.amount > (
			select avg(payment.amount)
			from payment)));





select count(i.inventory_id) as Copies
from inventory i
where film_id = (
	select film_id
    from sakila.film
	where title = 'Hunchback Impossible');

