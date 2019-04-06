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

-- 4c. rename actor HARPO WILLIAMS from GROUCHO WILLIAMS
update sakila.actor set first_name ='HARPO' where first_name ='GROUCHO' and last_name = 'Williams';

-- 4d. Undo actor name change
update sakila.actor set first_name ='GROUCH' where first_name ='HARPO' and last_name = 'Williams';

-- 5a. locate address table
select *from sakila.address;
select *from sakila.staff;

-- 6a. Use JOIN to display the first and last names, as well as the addresses of each staff member.



