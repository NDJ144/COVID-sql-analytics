-- Section 2: Basic Insights
-- Fundamental SELECT queries that every data analyst should know.

-- 4. Total number of confirmed COVID-19 cases globally
SELECT SUM(total_cases) AS global_cases
FROM covid_data
WHERE date = (SELECT MAX(date) FROM covid_data);

-- 5. Top 5 countries with highest total cases
SELECT location, MAX(total_cases) AS max_cases
FROM covid_data
GROUP BY location
ORDER BY max_cases DESC
LIMIT 5;

-- 6. Countries with more than 1 million cases
SELECT location
FROM covid_data
WHERE total_cases > 1000000
GROUP BY location;

-- Additional basic insight: Latest death counts by country
SELECT location, MAX(total_deaths) AS latest_deaths
FROM covid_data
GROUP BY location
ORDER BY latest_deaths DESC
LIMIT 10;

-- Additional basic insight: Case fatality rate (deaths per case)
SELECT location, 
       MAX(total_cases) AS total_cases,
       MAX(total_deaths) AS total_deaths,
       ROUND((MAX(total_deaths)::NUMERIC / NULLIF(MAX(total_cases), 0)) * 100, 2) AS case_fatality_rate
FROM covid_data
GROUP BY location
HAVING MAX(total_cases) > 1000  -- Only include countries with significant case numbers
ORDER BY case_fatality_rate DESC;
