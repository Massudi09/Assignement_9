USE sakila;

-- 1a. Display first and last names from the table actor.
select first_name,last_name from sakila.actor limit 10;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM sakila.actor;

-- 2a. ID number, first name, and last name of an actor, of whom you know only the first name, "Joe".
select * from sakila.actor where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN
select * from sakila.actor where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI
select last_name, first_name from sakila.actor where last_name like '%LI%';

-- 2d. Display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
select country_id, country from sakila.country where country in ('Afghanistan','Bangladesh','China');

-- 3a. Add column description in actor table
ALTER TABLE sakila.actor
ADD COLUMN description BLOB(200) after last_update;

-- 3b. Delete column description
ALTER TABLE sakila.actor DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS counts FROM sakila.actor GROUP BY last_name ;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) as counts FROM sakila.actor GROUP BY last_name HAVING COUNT(last_name) > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update sakila.actor set first_name ='HARPO' where first_name ='GROUCHO' and last_name = 'Williams';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update sakila.actor set first_name ='GROUCH' where first_name ='HARPO' and last_name = 'Williams';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table sakila.address;

-- 6a. Use JOIN to display the first and last names, as well as the addresses of each staff member.
Select first_name, last_name, address, address2, district, city_id, postal_code from sakila.address a
join sakila.staff s on (a.address_id = s.address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment
select *from sakila.payment;
select first_name, last_name, sum(amount) as 'Total Amount August 2005' from sakila.payment p join sakila.staff s on (p.staff_id=s.staff_id) where month(payment_date)=8 and year(payment_date)=2005 group by first_name,last_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select title, count(actor_id) as 'Number of Actors' from sakila.film f inner join sakila.film_actor fa on f.film_id=fa.film_id group by title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(i.inventory_id) as 'Stock - Hunchback Impossible' from inventory i join film f on (i.film_id=f.film_id) where 1=1 and f.title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select first_name, last_name, sum(amount) as 'Total Amount Paid' from sakila.payment p join sakila.customer c on p.customer_id=c.customer_id group by first_name,last_name order by last_name asc;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title
from film
where language_id in
	(select language_id
    from language
    where name = 'English'
    and title like 'K%' or title like 'Q%'
	);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip
select first_name, last_name 
from actor
where actor_id in
	(select actor_id
    from film_actor
    where film_id in
		(select film_id
        from film
        where title = 'Alone Trip'
        )
	);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select c.first_name, c.last_name, c.email
from sakila.customer c
join sakila.rental r on (c.customer_id=r.customer_id)
join sakila.address a on (c.address_id = a.address_id) 
join sakila.city ci on (a.city_id=ci.city_id) 
join sakila.country co on (ci.country_id=co.country_id) where country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title as 'Family Movies',rating from film where rating = 'G';

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title as 'Most Rented Movies', COUNT(r.inventory_id) as 'Number of Times Rented' FROM inventory i
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
GROUP BY i.film_id
ORDER BY COUNT(r.inventory_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in
SELECT store_id, CONCAT('$', FORMAT(SUM(amount),2)) AS 'Store Revenue' FROM store
INNER JOIN staff using (store_id)
INNER JOIN payment using (staff_id)
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country FROM store 
JOIN customer cu using (store_id)
JOIN staff using (store_id)
JOIN address a on (cu.address_id=a.address_id)
JOIN city using (city_id)
JOIN country coun using (country_id);

-- 7h. List the top five genres in gross revenue in descending order. 
select name, CONCAT('$', FORMAT(SUM(amount),2)) as 'Gross Revenue' FROM category
JOIN film_category using (category_id)
JOIN inventory using (film_id)
JOIN rental using (inventory_id)
JOIN payment using (rental_id)
GROUP BY name 
order by SUM(amount) desc limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
CREATE VIEW top_five_genres_revenues AS
select name, CONCAT('$', FORMAT(SUM(amount),2)) as 'Gross Revenue' FROM category
JOIN film_category using (category_id)
JOIN inventory using (film_id)
JOIN rental using (inventory_id)
JOIN payment using (rental_id)
GROUP BY name 
order by SUM(amount) desc limit 5;

-- 8b. How would you display the view that you created in 8a?
select *from top_five_genres_revenues;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_five_genres_revenues;
