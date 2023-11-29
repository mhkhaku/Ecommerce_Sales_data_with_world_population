# SQL E-commerce and World Population Analysis

## Overview
This repository contains a comprehensive SQL project that demonstrates skills in data manipulation, cleaning, aggregation, and analysis using two tables: ecom_data (E-commerce data) and world_population.

## Project Highlights
### Data Import and Table Creation:
Tables are created for e-commerce data (ecom_data) and world population data (world_population).
CSV files are imported to populate the tables.

### Data Cleaning and Quality Check:
- Null and blank values in critical columns are addressed.
- Total rows and null values in each table are counted for quality assessment.

### Data Type Conversion:
- The InvoiceDate column is converted from VARCHAR to TIMESTAMP for improved temporal analysis.
- Data types are altered for better representation, including the conversion of population-related columns to BIGINT.

### Data Aggregation and Analysis:
- Total sales and total orders per country are calculated in the e-commerce dataset.
- A temporary table (temp_sales) is created to store intermediate results.

### Temporary Tables Usage:
- Temporary tables are utilized efficiently to store and analyze intermediate results, improving performance.

### Joins and Relationships:
- JOIN operations are employed to connect data from the e-commerce and world population tables.

### Business Logic Implementation:
- The project involves implementing business logic, such as calculating total sales and total orders per country.

### GitHub Repository Structure:
- Code is organized into logical sections for ease of understanding.
- Meaningful names are used for tables and columns.
