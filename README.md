# Netflix Movies and TV Shows Data Analysis using SQL

### Description
In this project, I used SQL to analyze Netflix’s dataset and uncover interesting trends—like which genres are most common, how content has evolved over the years, and what patterns exist in movie vs. TV show releases. It’s all about making sense of the data behind Netflix’s massive content library. Check it out

![Netflix_Logo](https://github.com/Josh-health/Netflix_sql_project./blob/main/BrandAssets_Logos_02-NSymbol.jpg)

### Objective
- Analyze the distribution of content types (Movies vs TV Shows)
- Identify the most common ratings for movies and TV Shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorise content based on specific criteria and keywords.

### Dataset
The Data set for this project is sourced from Kaggle Dataset
- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows)

### Schema
```sql
DROP TABLE IF EXISTS netflix;
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
```
### Business Problems and Solutions

### 1. Count the number of Movies vs TV Shows

```sql
SELECT
	type,
	COUNT(type) total_num_movies
FROM netflix
GROUP BY type;
```
**Objective:** Determine how many Movies vs. TV Shows are available on Netflix.

### 2. Find the most common rating for movies and TV shows

```sql
SELECT 
	type,
	rating, 
	COUNT (rating) AS num_rating
FROM netflix
GROUP BY 1,2
ORDER BY num_rating DESC
LIMIT 10;
```
```sql
SELECT 
	type,
	rating, 
	COUNT (rating) AS num_rating,
	RANK()OVER(PARTITION BY type ORDER BY 	COUNT (rating) DESC) AS ranking
FROM netflix
GROUP BY 1,2;
```
```sql
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
```
**Objective:** Analyze the most common ratings for both movies and TV shows.

### 3. List all movies released in a specific year (e.g., 2020)
```sql
SELECT *
FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020;
```
**Objective:** Find all movies released in a specific year (e.g., 2020) to track Netflix's content distribution over time.

### 4. Find the top 5 countries with the most content on Netflix
```sql
SELECT country,
	COUNT(show_id) AS num_content
FROM netflix
GROUP BY 1
;
```
```sql
SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country
FROM netflix;
```
```sql
SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	COUNT(show_id) AS num_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 6;
```
**Objective:** Identify the top 5 countries contributing the most content to Netflix.

### 5. Identify the longest movie
```sql
SELECT MAX(duration)FROM netflix;
```
```sql
SELECT * 
FROM netflix
WHERE
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration)FROM netflix);
```
**Objective:** Discover which movie has the highest duration on Netflix.

### 6. Find content added in the last 5 years
```sql
SELECT *,
	TO_DATE(date_added, 'Month DD, YYYY')
FROM netflix;
```
```sql
SELECT *
FROM netflix
WHERE
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - iNTERVAL '5 years';
```

### 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

### 8. List all TV shows with more than 5 seasons

### 9. Count the number of content items in each genre

### 10. Find each year and the average number of content releases in India on Netflix. Return the top 5 years with the highest average content release!

### 11. List all movies that are documentaries

### 12. Find all content without a director
### 13. Find how many movies actor 'Salman Khan' appeared in the last 10 years
### 14. Find the top 10 actors who have appeared in the highest number of movies produced in India
### 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
