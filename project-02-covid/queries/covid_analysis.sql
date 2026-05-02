-- Q1: Death Rate in Nigeria Over Time
SELECT location, date, total_cases, total_deaths,
ROUND((CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100, 2) AS death_rate
FROM covid_data
WHERE location = 'Nigeria'
AND total_cases > 0
ORDER BY date;

-- Q2: Countries with Highest Death Rate Globally
SELECT location, 
MAX(CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT) * 100) AS death_rate
FROM covid_data
WHERE total_cases > 0
AND continent != ''
GROUP BY location
ORDER BY death_rate DESC
LIMIT 10;

-- Q3: Countries with highest total cases
SELECT location, MAX(CAST(total_cases AS INTEGER)) AS highest_cases
FROM covid_data
WHERE continent != ''
GROUP BY location
ORDER BY highest_cases DESC
LIMIT 10;

-- Q4: What percentage of Nigeria's population got infected?
SELECT location, population, 
MAX(CAST(total_cases AS FLOAT)) AS total_cases,
ROUND(MAX(CAST(total_cases AS FLOAT)) / population * 100, 4) AS infection_rate
FROM covid_data
WHERE location = 'Nigeria';

-- Q5: Global death count by continent
SELECT continent, 
SUM(CAST(new_deaths AS INTEGER)) AS total_deaths
FROM covid_data
WHERE continent != ''
GROUP BY continent
ORDER BY total_deaths DESC;