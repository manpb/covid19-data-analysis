# 🧪 COVID-19 Data Analysis (SQL Server + Power BI)

This project analyzes global COVID-19 trends using **SQL Server** for data preparation and **Power BI** for visualization.  
It demonstrates how to transform raw COVID-19 data into meaningful insights on infection rates, vaccination progress, and overall pandemic impact.

---

## 📁 Project Structure

| Folder | Description |
| :------ | :----------- |
| **Data/** | Contains sample data files (`CovidDeaths-sample.xlsx`, `CovidVaccination-sample.xlsx`). These are truncated samples of the full datasets. A link to the complete dataset is provided below. |
| **Queries/** | Includes SQL scripts used to clean, join, and analyze data, as well as create database views for reporting. |
| **Query Results/** | Contains sample CSV outputs from SQL queries, representing partial results used for visualization. |

---

## 📊 Data Description

### 1. `CovidDeaths-sample.xlsx`
Contains sample data on reported COVID-19 deaths by country, date, and population.  
Typical fields include:
- `location`
- `date`
- `total_cases`
- `new_cases`
- `total_deaths`
- `population`

### 2. `CovidVaccination-sample.xlsx`
Contains vaccination-related sample data by country and date.  
Typical fields include:
- `location`
- `date`
- `new_vaccinations`
- `total_vaccinations`
- `people_vaccinated`
- `people_fully_vaccinated`

---

## 🧠 SQL Analysis

The SQL scripts in the `Queries` folder perform data cleaning, transformation, and analysis.  
They focus on key metrics such as:
- Infection and death rates by country  
- Percentage of population infected  
- Vaccination progress over time  
- Comparison between vaccination and fatality trends  

| SQL File | Description |
|-----------|--------------|
| `data_analysis.sql` | Performs core analytical queries and joins across COVID-19 datasets. |
| `views.sql` | Defines reusable database views for reporting and visualization. |

---

## 📊 Power BI Dashboard

Insights from the SQL queries were visualized using **Microsoft Power BI**, transforming analytical results into interactive dashboards.  

The Power BI dashboard highlights:
- Global and regional COVID-19 case trends  
- Death-to-case ratio visualizations  
- Vaccination coverage over time  
- Comparison of cases vs. vaccination impact  

*(Power BI file not included in the repo due to size limitations, but visuals were built directly from the SQL views and query outputs.)*

---

## 🌐 Full Dataset
Access the complete COVID-19 dataset here:  
👉 [Full COVID-19 Data [https://1drv.ms/f/c/ede05ee8b19c3fa2/Egrzlf10q6BAhgewgzvvMn8BUglXiJCVNhk_oMyLvVmiTA?e=GmvSpA]


---

## 🛠️ Tools & Technologies
- **Microsoft SQL Server**
- **Power BI Desktop**
- **Excel / CSV**
- **Git & GitHub**

---


---

## 👤 Author
**Manuja Palamakumbura**  
Data & Analytics Enthusiast  
👉 [Project Portfolio [[[https://1drv.ms/f/c/ede05ee8b19c3fa2/Egrzlf10q6BAhgewgzvvMn8BUglXiJCVNhk_oMyLvVmiTA?e=GmvSpA](https://manuja84.wixsite.com/data-projects)]]
