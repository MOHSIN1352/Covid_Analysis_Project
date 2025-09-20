# 📊 COVID-19 Data Exploration with SQL and Tableau

This project performs a comprehensive analysis of the global COVID-19 pandemic. Raw data is cleaned and transformed using **SQL**, and the resulting dataset is visualized through a powerful, interactive **Tableau Dashboard**. The goal is to distill complex data into clear, actionable insights about the pandemic's spread, impact, and the global vaccination effort.

### [View the Interactive Tableau Dashboard Here](https://public.tableau.com/app/profile/mohsin.pathan1078/viz/Covid-Data-Analysis/Dashboard1)

---
## ✨ Project Workflow & Key Features

The project is executed in two main stages:

### 1. Data Cleaning & Preparation (SQL)
The foundation of this analysis is a robust data cleaning process performed using SQL. Key tasks include:
* **Data Exploration:** Understanding the structure, data types, and inconsistencies in the raw data.
* **Handling Null Values:** Identifying and managing missing data points to ensure calculation accuracy.
* **Data Transformation:** Converting data types (e.g., `nvarchar` to `datetime`) for proper analysis.
* **Feature Engineering:** Creating new metrics with SQL queries to calculate key performance indicators (KPIs) such as mortality rates and infection percentages.
* **Joins & Aggregations:** Combining `CovidDeaths` and `CovidVaccinations` tables to create a unified dataset for visualization.

### 2. Dashboard & Visualization (Tableau)
The clean, structured data is connected to Tableau to build an interactive dashboard that allows users to explore the pandemic's impact visually. The dashboard includes:
* **Global Overview:** High-level KPIs for total cases, deaths, and vaccinations.
* **Geographical Analysis:** An interactive world map visualizing infection and death rates by country.
* **Time Series Analysis:** Trend lines showing the progression of infections and vaccinations over time.
* **Comparative Insights:** Bar charts and tables comparing key metrics across different countries.

---
## 🛠️ Tech Stack

* **Data Cleaning & Manipulation:** **SQL**
* **Data Visualization & Dashboarding:** **Tableau**

---
## 🚀 How to View This Project

* **SQL Scripts:** The queries used for data cleaning are located in the `SQL_Queries` folder of this repository.
* **Tableau Dashboard:** The final, interactive dashboard can be viewed on Tableau Public at the following link:
    * **[https://public.tableau.com/app/profile/mohsin.pathan1078/viz/Covid-Data-Analysis/Dashboard1](https://public.tableau.com/app/profile/mohsin.pathan1078/viz/Covid-Data-Analysis/Dashboard1)**

---
## 📄 Data Source

The raw data for this project was sourced from the COVID-19 dataset provided by **Our World in Data**.
* **[Link to Data Source](https://ourworldindata.org/covid-deaths)**
