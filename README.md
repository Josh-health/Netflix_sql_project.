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
