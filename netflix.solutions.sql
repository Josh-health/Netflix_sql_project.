-- Netflix Project

CREATE TABLE netflix(
	show_id      VARCHAR(6),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

SELECT * FROM netflix;

SELECT 
	COUNT(*)AS total_content 
FROM netflix;


SELECT 
	DISTINCT type
FROM  netflix;
 
-- 15 Business Problems
-- 1. Count the number of Movies vs TV Shows
SELECT
	type,
	COUNT(type) total_num_movies
FROM netflix
GROUP BY type;


--2. Find the most common rating for movies and TV shows
SELECT 
	type,
	rating, 
	COUNT (rating) AS num_rating
FROM netflix
GROUP BY 1,2
ORDER BY num_rating DESC
LIMIT 10;

-- Ranking the rating.
SELECT 
	type,
	rating, 
	COUNT (rating) AS num_rating,
	RANK()OVER(PARTITION BY type ORDER BY 	COUNT (rating) DESC) AS ranking
FROM netflix
GROUP BY 1,2;

-- Getting the most common rating for movies and tv shows
SELECT 
	type,
	rating
FROM (
SELECT 
	type,
	rating, 
	COUNT (rating) AS num_rating,
	RANK()OVER(PARTITION BY type ORDER BY 	COUNT (rating) DESC) AS ranking
FROM netflix
GROUP BY 1,2
) AS table_1
WHERE ranking = 1;



-- 3. List all movies released in a specific year (e.g., 2020)
SELECT *
FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix
SELECT country,
	COUNT(show_id) AS num_content
FROM netflix
GROUP BY 1
;
-- Separating contries where more that one country was involved in a movie production
SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country
FROM netflix;

-- Using the all the countries as single involvement to know the top 5 countries with most content on Netflix
SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	COUNT(show_id) AS num_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 6;

--5. Identify the longest movie
-- longest duration
SELECT MAX(duration)FROM netflix;

-- Fetching the movies with the longest duration
SELECT * 
FROM netflix
WHERE
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration)FROM netflix);


-- 6. Find content added in the last 5 years
-- convert date_added to date data type in a new column
SELECT *,
	TO_DATE(date_added, 'Month DD, YYYY')
FROM netflix;

-- Use the new date to discover the contents added in the last years
SELECT *
FROM netflix
WHERE
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - iNTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons
-- Use split function to separate number from text (e.g 6 Seasons) in duration column f
SELECT *,
	SPLIT_PART(duration, ' ', 1) AS seasons -- (column, 'delimiter', text/no before_delimiter)
FROM netflix;
-- Use the function above to get TV shows with more than 5 seasons
SELECT *,
	SPLIT_PART(duration, ' ', 1) AS seasons
FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::numeric > 5; -- ::numeric (converts 5 from int to num)
	
-- 9. Count the number of content items in each genre
SELECT listed_in,
	COUNT(show_id) AS num_content
FROM netflix
GROUP BY 1;

-- Separating genre where more than one genre is present in a movie production
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
FROM netflix;
-- Using the all the genre as single involvement to know the number of content items in each genre
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
	COUNT(show_id) AS num_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;


-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!
  -- convert date_added to a date data type in a new colunm
  SELECT TO_DATE(date_added, 'Month DD, YYYY') AS date,
  *
  FROM netflix
  WHERE country = 'India';

  -- Extract the yeare from the new date created
  SELECT 
  	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	  COUNT(*)
  FROM netflix
  WHERE country = 'India'
  GROUP BY 1;

--Finding the average for each year
SELECT 
  	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	COUNT(*) AS yearly_content,
	ROUNd(
	COUNT(*)::numeric /(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric *100, 2) AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1;

-- 11. List all movies that are documentaries
SELECT *
FROM netflix
WHERE listed_in ILIKE '%documentaries%';

-- 12. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT *
FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT * FROM netflix;
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
	count(*) AS num_actors
FROM netflix
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- 15.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

WITH content_cat 
AS(
SELECT 
	*,
	CASE 
	WHEN
		description ILIKE '%kill%' 
	OR  description ILIKE '%violence%' THEN 'Bad_Content'
	ELSE 'Good_Content'
	END category
FROM netflix
)
SELECT 
	category,
	COUNT(*) AS total_content
FROM content_cat
GROUP BY 1;
