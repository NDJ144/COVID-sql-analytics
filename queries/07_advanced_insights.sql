-- Section 7: Advanced Insights
-- Complex analytical queries extracting deeper insights from COVID-19 data.

-- 19. Detect countries where cases decreased for 7 consecutive days
WITH daily_change AS (
  SELECT location, date, new_cases,
         LAG(new_cases, 1) OVER (PARTITION BY location ORDER BY date) AS prev_cases
  FROM covid_data
),
decreases AS (
  SELECT *, 
         CASE WHEN new_cases < prev_cases THEN 1 ELSE 0 END AS is_decreasing
  FROM daily_change
),
streak_data AS (
  SELECT 
    location, 
    date,
    SUM(is_decreasing) OVER (PARTITION BY location ORDER BY date 
                           ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS streak_count,
    COUNT(*) OVER (PARTITION BY location ORDER BY date 
                 ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS days_count
  FROM decreases
)
SELECT DISTINCT location, date, streak_count
FROM streak_data
WHERE streak_count = 7 AND days_count = 7
ORDER BY location, date;

-- 20. Ratio of vaccinated to infected population per country
SELECT v.location,
       MAX(v.people_vaccinated) AS vaccinated,
       MAX(c.total_cases) AS infected,
       ROUND(MAX(v.people_vaccinated) / NULLIF(MAX(c.total_cases), 0), 2) AS vax_to_infection_ratio
FROM covid_vaccinations v
JOIN covid_data c ON v.location = c.location AND v.date = c.date
GROUP BY v.location;

-- Additional advanced query: Identify waves of infections using local maxima
WITH daily_cases AS (
    SELECT 
        location,
        date,
        new_cases,
        AVG(new_cases) OVER (PARTITION BY location ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS smooth_cases
    FROM covid_data
),
local_peaks AS (
    SELECT
        location,
        date,
        smooth_cases,
        LAG(smooth_cases, 7) OVER (PARTITION BY location ORDER BY date) AS prev_week,
        LEAD(smooth_cases, 7) OVER (PARTITION BY location ORDER BY date) AS next_week
    FROM daily_cases
)
SELECT
    location,
    date,
    smooth_cases AS peak_cases
FROM local_peaks
WHERE smooth_cases > COALESCE(prev_week, 0)
  AND smooth_cases > COALESCE(next_week, 0)
  AND smooth_cases > 100  -- Minimum threshold to be considered a wave
ORDER BY location, date;

-- Advanced insights: Calculate r-effective (reproduction rate) estimation
WITH cases_data AS (
    SELECT
        location,
        date,
        new_cases,
        SUM(new_cases) OVER (PARTITION BY location ORDER BY date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS cases_5day,
        SUM(new_cases) OVER (PARTITION BY location ORDER BY date ROWS BETWEEN 9 PRECEDING AND 5 PRECEDING) AS cases_prev_5day
    FROM covid_data
)
SELECT
    location,
    date,
    ROUND(cases_5day::NUMERIC / NULLIF(cases_prev_5day, 0), 2) AS r_effective,
    CASE 
        WHEN (cases_5day::NUMERIC / NULLIF(cases_prev_5day, 0)) > 1 THEN 'Growing'
        WHEN (cases_5day::NUMERIC / NULLIF(cases_prev_5day, 0)) < 1 THEN 'Shrinking'
        ELSE 'Stable'
    END AS epidemic_status
FROM cases_data
WHERE cases_prev_5day > 0
ORDER BY location, date;
