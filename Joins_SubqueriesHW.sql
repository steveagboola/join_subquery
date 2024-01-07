-- Joins and Subqueries HW.

--Question 1
--List all customers who live in Texas (use JOINs)

--first_name|last_name|district|
------------+---------+--------+
--Jennifer  |Davis    |Texas   |
--Kim       |Cruz     |Texas   |
--Richard   |Mccrary  |Texas   |
--Bryan     |Hardison |Texas   |
--Ian       |Still    |Texas   |

SELECT * 
FROM customer c
JOIN address a
ON c.address_id = a.address_id
WHERE district = 'Texas';

-- Question 2
-- List all payments of more than $7.00 with the customer’s first and last name

--first_name|last_name   |amount|
------------+------------+------+
--Peter     |Menard      |  7.99|
--Peter     |Menard      |  7.99|
--Peter     |Menard      |  7.99|
--Douglas   |Graf        |  8.99|
--Ryan      |Salisbury   |  8.99|
--Ryan      |Salisbury   |  8.99|
--Ryan      |Salisbury   |  7.99|
--Roger     |Quintanilla |  8.99|
--Joe       |Gilliland   |  8.99|
-- ...
SELECT *
FROM payment p
WHERE amount > 7; --ONLY gets the amount > 7.  JOIN it

SELECT first_name ,last_name ,amount
FROM payment p
JOIN customer c 
ON p.customer_id = c.customer_id 
WHERE amount > 7;


-- Question 3
-- Show all customer names who have made over $175 in payments (use
--subqueries)



--customer_id|store_id|first_name|last_name|email                            |address_id|activebool|create_date|last_update            |active|
-------------+--------+----------+---------+---------------------------------+----------+----------+-----------+-----------------------+------+
--        137|       2|Rhonda    |Kennedy  |rhonda.kennedy@sakilacustomer.org|       141|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|
--        144|       1|Clara     |Shaw     |clara.shaw@sakilacustomer.org    |       148|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|
--        148|       1|Eleanor   |Hunt     |eleanor.hunt@sakilacustomer.org  |       152|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|
--        178|       2|Marion    |Snyder   |marion.snyder@sakilacustomer.org |       182|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|
--        459|       1|Tommy     |Collazo  |tommy.collazo@sakilacustomer.org |       464|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|
--        526|       2|Karl      |Seal     |karl.seal@sakilacustomer.org     |       532|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|


SELECT customer_id ,sum(amount)	
FROM payment p 
GROUP BY customer_id 
HAVING sum(amount) > 175
;


-- Question 4
-- List all customers that live in Argentina (use the city table)

--first_name|last_name|district    |city                |country  |
------------+---------+------------+--------------------+---------+
--Willie    |Markham  |Buenos Aires|Almirante Brown     |Argentina|
--Jordan    |Archuleta|Buenos Aires|Avellaneda          |Argentina|
--Jason     |Morrissey|Buenos Aires|Baha Blanca         |Argentina|
--Kimberly  |Lee      |Crdoba      |Crdoba              |Argentina|
--Micheal   |Forman   |Buenos Aires|Escobar             |Argentina|
--Darryl    |Ashcraft |Buenos Aires|Ezeiza              |Argentina|
--Julia     |Flores   |Buenos Aires|La Plata            |Argentina|
--Florence  |Woods    |Buenos Aires|Merlo               |Argentina|
--Perry     |Swafford |Buenos Aires|Quilmes             |Argentina|
--Lydia     |Burke    |Tucumn      |San Miguel de Tucumn|Argentina|
--Eric      |Robert   |Santa F     |Santa F             |Argentina|
--Leonard   |Schofield|Buenos Aires|Tandil              |Argentina|
--Willie    |Howell   |Buenos Aires|Vicente Lpez        |Argentina|



SELECT first_name, last_name, address, city, district, country
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city ci 
ON ci.city_id = a.city_id
JOIN country co
ON ci.country_id = co.country_id
WHERE country = 'Argentina';
​
​
-- could have also done this with a subquery

SELECT *
FROM customer 
WHERE address_id IN (
	SELECT address_id 
	FROM address 
	WHERE city_id IN (
		SELECT city_id
		FROM city 
		WHERE country_id = (
			SELECT country_id 
			FROM country
			WHERE country = 'Argentina'
		)
	)
);


-- Question 5
-- Show all the film categories with their count in descending order

--category_id|name       |num_movies_in_cat|
-------------+-----------+-----------------+
--         15|Sports     |               74|
--          9|Foreign    |               73|
--          8|Family     |               69|
--          6|Documentary|               68|
--          2|Animation  |               66|
--          1|Action     |               64|
--         13|New        |               63|
--          7|Drama      |               62|
--         14|Sci-Fi     |               61|
--         10|Games      |               61|
--          3|Children   |               60|
--          5|Comedy     |               58|
--          4|Classics   |               57|
--         16|Travel     |               57|
--         11|Horror     |               56|
--         12|Music      |               51|

SELECT fc.category_id, c.name, COUNT(*) AS num_movies_in_cat
FROM film_category fc
JOIN category c 
ON fc.category_id = c.category_id 
GROUP BY fc.category_id, c.name
ORDER BY num_movies_in_cat DESC;

-- Question 6
-- What film had the most actors in it (show film info)?


--film_id|title           |num_actors|
---------+----------------+----------+
--    508|Lambs Cincinatti|        15|

SELECT *
FROM film 
WHERE film_id = (
	SELECT film_id
	FROM film_actor
	GROUP BY film_id
	ORDER BY COUNT(*) DESC
	LIMIT 1
);


-- Question 7 
-- Which actor has been in the least movies?


--actor_id|first_name|last_name|num_films|
----------+----------+---------+---------+
--     148|Emily     |Dee      |       14|

SELECT fa.actor_id, first_name, last_name, COUNT(*) AS num_films
FROM film_actor fa
JOIN actor a
ON fa.actor_id = a.actor_id 
GROUP BY fa.actor_id, first_name, last_name
ORDER BY num_films
LIMIT 1;
​
-- Question 8
-- Which country has the most cities?

--country_id|country                              |num_cities|
------------+-------------------------------------+----------+
--        44|India                                |        60|
--        23|China                                |        53|
--       103|United States                        |        35|

SELECT *
FROM country 
WHERE country_id = (
	SELECT country_id
	FROM city
	GROUP BY country_id
	ORDER BY COUNT(*) DESC
	LIMIT 1
);


SELECT ci.country_id, co.country, COUNT(*)
FROM city ci
JOIN country co
ON ci.country_id = co.country_id 
GROUP BY ci.country_id, co.country
ORDER BY COUNT(*) DESC;
​
-- Question 9
-- List the actors who have been in between 20 and 25 films.


--actor_id|first_name |last_name  |count|
----------+-----------+-----------+-----+
--     114|Morgan     |Mcdormand  |   25|
--     153|Minnie     |Kilmer     |   20|
--      32|Tim        |Hackman    |   23|
--     132|Adam       |Hopper     |   22|
--      46|Parker     |Goldberg   |   24|
--     163|Christopher|West       |   21|
--...
SELECT fa.actor_id, first_name, last_name, COUNT(*)
FROM film_actor fa
JOIN actor a
ON fa.actor_id = a.actor_id 
GROUP BY fa.actor_id, first_name, last_name
HAVING COUNT(*) BETWEEN 20 AND 25;