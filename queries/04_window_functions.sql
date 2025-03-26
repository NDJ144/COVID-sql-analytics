-- Section 4: Window Functions
-- Demonstrates the use of SQL window functions for time-series analysis.

-- 11. 7-day rolling average of new cases for Italy
SELECT date, location, new_cases,
       AVG(new_cases) OVER (PARTITION BY location ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM covid_data
WHERE location = 'Italy';

-- 12. Rank countries by total deaths on a given date
SELECT location, total_deaths, RANK() OVER (ORDER BY total_deaths DESC) AS death_rank
FROM covid_data
WHERE date = '2021-05-01';

-- 13. Calculate daily percent increase in cases for Brazil
SELECT date, location, new_cases,
       LAG(total_cases, 1) OVER (PARTITION BY location ORDER BY date) AS previous_total,
       ROUND((total_cases - LAG(total_cases, 1) OVER (PARTITION BY location ORDER BY date)) / LAG(total_cases, 1) OVER (PARTITION BY location ORDER BY date) * 100, 2) AS pct_increase
FROM covid_data
WHERE location = 'Brazil';

-- Additional window function: Calculate cumulative vaccination percentage
SELECT 
    v.date,
    v.location,
    v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY v.location ORDER BY v.date) AS cumulative_vaccinations,
    ROUND(
        (SUM(v.new_vaccinations) OVER (PARTITION BY v.location ORDER BY v.date)::NUMERIC / p.population) * 100,
        2
    ) AS cumulative_vaccination_percentage
FROM covid_vaccinations v
JOIN population_data p ON v.location = p.country
ORDER BY v.location, v.date;
