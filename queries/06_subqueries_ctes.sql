-- Section 6: Subqueries & CTEs
-- Examples using subqueries and Common Table Expressions for more complex analyses.

-- 17. CTE to find peak case day for each country
WITH country_peaks AS (
  SELECT location, date, new_cases,
         RANK() OVER (PARTITION BY location ORDER BY new_cases DESC) AS rnk
  FROM covid_data
)
SELECT location, date, new_cases
FROM country_peaks
WHERE rnk = 1;

-- 18. Subquery to find countries with death rate over 5%
SELECT location, total_cases, total_deaths,
       (total_deaths / total_cases) * 100 AS death_rate
FROM covid_data
WHERE date = (SELECT MAX(date) FROM covid_data)
AND (total_deaths / total_cases) > 0.05;

-- Additional CTE: Find countries with accelerating case growth
WITH daily_growth AS (
    SELECT 
        location,
        date,
        new_cases,
        LAG(new_cases, 1) OVER (PARTITION BY location ORDER BY date) AS prev_day_cases,
        LAG(new_cases, 2) OVER (PARTITION BY location ORDER BY date) AS two_days_ago_cases
    FROM covid_data
),
acceleration AS (
    SELECT
        location,
        date,
        new_cases,
        prev_day_cases,
        two_days_ago_cases,
        (new_cases - prev_day_cases) - (prev_day_cases - two_days_ago_cases) AS case_acceleration
    FROM daily_growth
    WHERE prev_day_cases IS NOT NULL AND two_days_ago_cases IS NOT NULL
)
SELECT 
    location,
    date,
    new_cases,
    case_acceleration,
    CASE WHEN case_acceleration > 0 THEN 'Accelerating' ELSE 'Decelerating' END AS trend
FROM acceleration
WHERE case_acceleration > 100  -- Only show significant acceleration
ORDER BY case_acceleration DESC;
