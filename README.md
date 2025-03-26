# COVID-19 SQL Analytics Project

![COVID-19 Data](https://img.shields.io/badge/COVID--19-Data%20Analysis-blue)
![SQL](https://img.shields.io/badge/SQL-Queries-orange)
![Database](https://img.shields.io/badge/Database-PostgreSQL-lightgrey)

## 📊 Project Overview

This repository contains a collection of SQL queries for analyzing COVID-19 pandemic data. The queries demonstrate various SQL techniques from basic data cleaning to advanced analytics, using publicly available COVID-19 datasets such as Our World in Data and Johns Hopkins University data.

## 🔍 Data Sources

The queries are designed to work with the following COVID-19 datasets:
- [Our World in Data COVID-19 dataset](https://github.com/owid/covid-19-data)
- [Johns Hopkins University COVID-19 data](https://github.com/CSSEGISandData/COVID-19)

**Tables required:**
- `covid_data`: Main COVID-19 case and death data
- `covid_vaccinations`: Vaccination data 
- `population_data`: Population information by country

## 📂 Project Structure

```
.
├── README.md               # Project documentation
├── schema/                 # Database schema files
│   └── tables.sql          # SQL to create the required tables
└── queries/                # SQL queries organized by category
    ├── 01_data_cleaning.sql       # Data cleaning operations
    ├── 02_basic_insights.sql      # Simple analysis queries
    ├── 03_aggregations.sql        # Aggregation and grouping
    ├── 04_window_functions.sql    # Window function examples
    ├── 05_joins.sql               # Join operations
    ├── 06_subqueries_ctes.sql     # Subqueries and CTEs
    └── 07_advanced_insights.sql   # Advanced analysis techniques
```

## 🚀 Getting Started

### Prerequisites
- PostgreSQL database (queries are PostgreSQL compatible)
- COVID-19 datasets loaded into your database

### Setup Instructions

1. Clone this repository
```bash
git clone https://github.com/yourusername/covid-sql-analytics.git
cd covid-sql-analytics
```

2. Create the database schema
```bash
psql -d your_database -f schema/tables.sql
```

3. Import COVID-19 data into your database
   - Download the data from sources mentioned above
   - Import CSV files into your PostgreSQL database

## 📋 Query Categories

### 1. Data Cleaning & Setup
Queries for data preparation, standardization, and quality checks.

### 2. Basic Insights
Fundamental queries to extract key pandemic statistics.

### 3. Aggregations & Grouping
Queries demonstrating aggregations across different dimensions.

### 4. Window Functions
Examples of using SQL window functions for time-series analysis.

### 5. Joins & Comparative Analysis
Multi-table queries combining different COVID-19 datasets.

### 6. Subqueries & CTEs
Examples using subqueries and Common Table Expressions.

### 7. Advanced Insights
Complex analytical queries extracting deeper insights.

## 💡 Usage Examples

Run queries directly in your SQL client:

```sql
-- Example: Finding countries with highest case counts
SELECT location, MAX(total_cases) AS max_cases
FROM covid_data
GROUP BY location
ORDER BY max_cases DESC
LIMIT 5;
```

## 📈 Sample Visualizations

The SQL queries in this repository can be used to generate data for visualizations like:

- Daily case and death trends
- Vaccination progress by country
- Infection rate comparisons
- Recovery patterns over time

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Feel free to submit a Pull Request.

## 📞 Contact

If you have any questions, please reach out to me on [LinkedIn](https://linkedin.com/in/yourusername) or [Twitter](https://twitter.com/yourusername).
