-- Section 1: Data Cleaning & Setup
-- These queries demonstrate data preparation techniques essential for any data analysis role.

-- 1. Standardize country names (replace inconsistent values)
UPDATE covid_data
SET location = 'United States'
WHERE location IN ('USA', 'US');

-- 2. Remove duplicate records
DELETE FROM covid_data
WHERE id NOT IN (
  SELECT MIN(id)
  FROM covid_data
  GROUP BY date, location
);

-- 3. Check for NULLs in key fields
SELECT *
FROM covid_data
WHERE total_cases IS NULL OR total_deaths IS NULL;

-- Additional cleaning: Remove any entries with future dates
DELETE FROM covid_data
WHERE date > CURRENT_DATE;

-- Additional cleaning: Standardize case formats
UPDATE covid_data
SET location = INITCAP(location)
WHERE location <> INITCAP(location);
