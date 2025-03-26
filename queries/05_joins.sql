-- Section 5: Joins & Comparative Queries
-- Demonstrates SQL join operations to combine data from multiple tables.

-- 14. Join with population table to get cases per 100k people
SELECT c.location, c.date, c.total_cases, p.population,
       (c.total_cases / p.population) * 100000 AS cases_per_100k
FROM covid_data c
JOIN population_data p ON c.location = p.country;

-- 15. Compare total vaccinations with total cases per country
SELECT v.location, MAX(v.total_vaccinations) AS total_vax, MAX(c.total_cases) AS total_cases
FROM covid_vaccinations v
JOIN covid_data c ON v.location = c.location AND v.date = c.date
GROUP BY v.location;

-- 16. Countries with more vaccinations than total cases
SELECT location
FROM (
  SELECT v.location, MAX(v.total_vaccinations) AS total_vax, MAX(c.total_cases) AS total_cases
  FROM covid_vaccinations v
  JOIN covid_data c ON v.location = c.location AND v.date = c.date
  GROUP BY v.location
) sub
WHERE total_vax > total_cases;

-- Additional join query: Calculate vaccination effectiveness by comparing case rates
SELECT 
    c.location,
    MAX(v.people_fully_vaccinated) / p.population AS vaccination_rate,
    SUM(c.new_cases) / p.population AS infection_rate,
    ROUND(
        (1 - (SUM(c.new_cases) / p.population) / NULLIF(MAX(v.people_fully_vaccinated) / p.population, 0)) * 100,
        2
    ) AS estimated_effectiveness
FROM covid_data c
JOIN covid_vaccinations v ON c.location = v.location AND c.date = v.date
JOIN population_data p ON c.location = p.country
WHERE c.date >= '2021-01-01'  -- Start date when vaccinations became widespread
GROUP BY c.location, p.population
HAVING MAX(v.people_fully_vaccinated) > 0  -- Only include countries with vaccination data
ORDER BY estimated_effectiveness DESC;
