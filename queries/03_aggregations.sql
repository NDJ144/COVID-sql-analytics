-- Section 3: Aggregations & Grouping
-- These queries demonstrate various grouping and aggregation techniques.

-- 7. Daily new cases for the US
SELECT date, new_cases
FROM covid_data
WHERE location = 'United States'
ORDER BY date;

-- 8. Average daily deaths per country
SELECT location, AVG(new_deaths) AS avg_daily_deaths
FROM covid_data
GROUP BY location;

-- 9. Monthly total cases worldwide
SELECT DATE_TRUNC('month', date) AS month, SUM(new_cases) AS total_cases
FROM covid_data
GROUP BY month
ORDER BY month;

-- 10. Highest death rate by country
SELECT location, MAX(total_deaths / total_cases) AS max_death_rate
FROM covid_data
WHERE total_cases > 0
GROUP BY location;

-- Additional aggregation: Weekly case growth rate
SELECT 
    location,
    DATE_TRUNC('week', date) AS week,
    SUM(new_cases) AS weekly_cases,
    LAG(SUM(new_cases)) OVER (PARTITION BY location ORDER BY DATE_TRUNC('week', date)) AS prev_week_cases,
    ROUND(
        (SUM(new_cases) - LAG(SUM(new_cases)) OVER (PARTITION BY location ORDER BY DATE_TRUNC('week', date))) / 
        NULLIF(LAG(SUM(new_cases)) OVER (PARTITION BY location ORDER BY DATE_TRUNC('week', date)), 0) * 100,
        2
    ) AS weekly_growth_rate
FROM covid_data
GROUP BY location, DATE_TRUNC('week', date)
ORDER BY location, week;
