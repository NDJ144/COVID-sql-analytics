-- COVID-19 Analytics Database Schema

-- Main COVID-19 data table
CREATE TABLE IF NOT EXISTS covid_data (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    location VARCHAR(100) NOT NULL,
    total_cases BIGINT,
    new_cases INT,
    total_deaths BIGINT,
    new_deaths INT,
    
    -- Add index for faster queries
    CONSTRAINT covid_data_date_location UNIQUE (date, location)
);

-- Vaccination data table
CREATE TABLE IF NOT EXISTS covid_vaccinations (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    location VARCHAR(100) NOT NULL,
    total_vaccinations BIGINT,
    people_vaccinated BIGINT,
    people_fully_vaccinated BIGINT,
    new_vaccinations INT,
    
    -- Add index for faster queries
    CONSTRAINT covid_vaccinations_date_location UNIQUE (date, location)
);

-- Population data table
CREATE TABLE IF NOT EXISTS population_data (
    id SERIAL PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    population BIGINT NOT NULL,
    
    -- Add index for faster queries
    CONSTRAINT population_data_country UNIQUE (country)
);

-- Add comments for documentation
COMMENT ON TABLE covid_data IS 'Main COVID-19 case and death data from Johns Hopkins or Our World in Data';
COMMENT ON TABLE covid_vaccinations IS 'COVID-19 vaccination data from Our World in Data';
COMMENT ON TABLE population_data IS 'Population information by country for per-capita calculations';
