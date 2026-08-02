# Global Superstore Sales Analysis

### End-to-End Data Analytics Project | Excel • PostgreSQL • Power BI

---

## 📌 Quick Summary

- 📦 Identified **2,259 loss-making products**, enabling data-driven product portfolio optimization.
- 🚚 Discovered **2,394 orders** where shipping costs exceeded **20% of sales**, with some reaching **48.26%**, highlighting significant logistics inefficiencies.

---

## 📑 Table of Contents

- [Project Overview](#project-overview)
- [Business Problem](#business-problem)
- [Objectives](#objectives)
- [Dataset](#dataset)
- [Tech Stack](#-tech-stack)
- [Project Architecture](#️-project-architecture)
- [Star Schema](#-star-schema)
- [Data Warehouse Design](#️-data-warehouse-design)
- [SQL Analysis](#-sql-analysis)
- [Excel Dashboard](#-excel-dashboard)
- [Power BI Dashboard](#-power-bi-dashboard)
- [Business Insights](#-business-insights)
- [Key Features](#-key-features)
- [How to Run](#-how-to-run)
- [Author](#-author)

---

# Project Overview

This project uses the **Global Superstore** dataset to build a full analytics pipeline — from raw transactional data to a business-ready reporting solution.

The project followed a complete analytics pipeline:

1. **Data Acquisition**
    - Downloaded the Global Superstore dataset from Kaggle.
2. **Data Cleaning & Preparation**
    - Cleaned and transformed the raw data using **Power Query**.
    - Standardized data types, handled inconsistencies, and prepared the dataset for loading.
3. **Data Warehouse Development**
    - Built a **Star Schema** in PostgreSQL.
    - Created dimension tables and a central fact table.
    - Loaded the cleaned data into the warehouse through a structured ETL process.
4. **SQL Analytics**
    - Developed SQL queries to calculate KPIs and answer business questions.
    - Performed sales, profitability, customer, product, location, and time-based analysis.
5. **Excel Dashboard**
    - Connected Excel directly to PostgreSQL.
    - Built an interactive dashboard using Power Query, Power Pivot, Pivot Tables, Pivot Charts, and DAX.
6. **Power BI Dashboard**
    - Connected Power BI to the PostgreSQL database.
    - Designed a multi-page interactive dashboard with navigation, drill-through analysis, bookmarks, parameters, and business-focused visualizations.
7. **Business Insights**
    - Interpreted the dashboard findings.
    - Produced actionable business insights supported by visual evidence.

---

## Business Problem

Retail companies process thousands of sales transactions across different products, customers, markets, and time periods. While this data is valuable, it is difficult to identify meaningful business patterns directly from raw transactional records.

Decision-makers need clear answers to questions such as:

- Which categories and products drive profitability?
- Which sub-categories consistently generate losses?
- Which markets and customer segments perform best?
- How do discounts impact profit?
- How has business performance changed over time?

Without a structured analytical model and interactive reporting, answering these questions becomes time-consuming and limits effective decision-making.

This project addresses these challenges by transforming raw sales data into a business intelligence solution using a data warehouse, SQL analytics, Excel, and Power BI dashboards.

---

# Objectives

The main objectives of this project were to:

- Design a **Star Schema** data warehouse to support analytical reporting.
- Clean and transform raw sales data using **Power Query**.
- Perform SQL-based analysis to answer key business questions and calculate essential KPIs.
- Develop interactive dashboards in **Excel** and **Power BI** to monitor sales performance.
- Analyze profitability across products, categories, customer segments, markets, and time.
- Identify business opportunities and underperforming areas through data-driven insights.
- Deliver an end-to-end business intelligence solution that supports informed decision-making.

---

# Dataset

The project uses the **Global Superstore** dataset, a publicly available retail sales dataset that contains transactional records from a global retail company.

## Dataset Information

- **Source:** Kaggle – Global Superstore Dataset
- **Dataset Link:** [Global Superstore Dataset](https://www.kaggle.com/datasets/fatihilhan/global-superstore-dataset)
- **Records:** 51,290
- **Time Period:** 2011 – 2014
- **Type:** Retail Sales Transactions

## Key Features

The dataset includes information about:

- Orders
- Customers
- Products
- Categories & Sub-Categories
- Markets & Locations
- Order & Ship Dates
- Sales
- Profit
- Discount
- Quantity
- Shipping Cost

## Why This Dataset?

This dataset was selected because it represents a realistic retail business scenario and provides sufficient dimensions and measures to build a complete Business Intelligence solution, including:

- Data Cleaning
- Data Warehousing
- SQL Analytics
- Dashboard Development
- Business Insights

## 🔧 Tech Stack

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-336791?style=flat-square&logo=postgresql&logoColor=white)
![Power Query](https://img.shields.io/badge/Power%20Query-217346?style=flat-square&logo=microsoft-excel&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-217346?style=flat-square&logo=microsoft-excel&logoColor=white)
![Power Pivot](https://img.shields.io/badge/Power%20Pivot-107C41?style=flat-square)
![DAX](https://img.shields.io/badge/DAX-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![Git](https://img.shields.io/badge/Git-F05032?style=flat-square&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white)

## 🏗️ Project Architecture

```text
                    Global Superstore Dataset (CSV)
                                │
                                ▼
                     Power Query (Data Cleaning)
                                │
                                ▼
                     PostgreSQL Staging Table
                                │
                                ▼
                 ETL & Star Schema Transformation
                                │
            ┌───────────────────┼───────────────────┐
            ▼                   ▼                   ▼
      Dimension Tables     Fact Table         Data Validation
                                │
                                ▼
                         SQL Analytics & KPIs
                                │
                ┌───────────────┴───────────────┐
                ▼                               ▼
         Excel Dashboard                 Power BI Dashboard
                                │
                                ▼
                     Business Insights & Decisions
```

## ⭐ Star Schema

<p align="center">
  <img src="images\07_Star_Schema_ERD.png" width="950">
</p>

## 🗄️ Data Warehouse Design

The project follows a **Star Schema** design to optimize analytical queries and reporting performance.

### Schema Components

- **Fact Table**
  - `fact_sales`
  - Stores all transactional measures:
    - Sales
    - Profit
    - Quantity
    - Discount
    - Shipping Cost

- **Dimension Tables**
  - `dim_product`
  - `dim_customer`
  - `dim_location`
  - `dim_date`

### Design Features

- One central **Fact Table** connected to four **Dimension Tables**
- Surrogate Keys used for all dimensions
- Composite business key implemented in `dim_product` to ensure uniqueness
- Separate Date Dimension supporting both **Order Date** and **Ship Date**
- Optimized for SQL analytics, Power Pivot, and Power BI reporting

## 🧮 SQL Analysis

The analytical layer was built in PostgreSQL to transform raw transactional data into actionable business insights.

### 📊 Key Performance Indicators (KPIs)

- Total Sales
- Total Profit
- Total Orders
- Total Customers
- Total Quantity Sold
- Average Order Value (AOV)
- Profit Margin (%)
- Average Discount
- Average Shipping Cost

### 📈 Business Analysis

- Sales Performance Analysis
- Product Performance Analysis
- Customer Analysis
- Geographic Analysis
- Time Trend Analysis

### 💼 Business Questions Answered

- Which customers generate high sales but negative profit?
- Which products should be discontinued?
- Do higher discounts increase sales or simply reduce profit?
- Which category contributes the most to total sales?
- Which products have above-average sales but negative profit?
- Which are the most profitable products in each category?
- Who are the top customers in each market?
- Which sub-categories underperform in each region?
- How does yearly sales growth compare across markets?
- Which products dominate sales within each market?
- Which customers consistently generate losses?
- Which orders have unusually high shipping costs?

### 🧠 SQL Concepts Used

- Common Table Expressions (CTEs)
- Window Functions
- Aggregate Functions
- Ranking Functions (`RANK`)
- Analytical Functions (`LAG`)
- Running Totals
- Moving Averages
- Subqueries
- CASE Expressions
- JOIN Operations
- GROUP BY & HAVING
- Percentage Contribution Analysis

### Example Query
```sql
--Find the top-selling product in each market --
WITH product_sales AS(
    SELECT
        market,
        product_id,
        product_name,
        category,
        sub_category,
        sum(sales) as total_sales
    FROM fact_sales fs
    JOIN product_dim pd ON fs.product_key = pd.product_key
    JOIN dim_location dl ON fs.location_key = dl.location_key
    GROUP BY 
        market,
        product_id,
        product_name,
        category,
        sub_category
),
product_ranking AS (SELECT 
    market,
    product_name,
    total_sales,
    RANK() OVER(PARTITION BY market order by total_sales DESC) as product_rank
FROM product_sales
)

SELECT 
    market,
    product_name,
    total_sales,
    product_rank
FROM product_ranking
WHERE product_rank = 1
```

## 📊 Excel Dashboard

An interactive Excel dashboard was developed using **Power Query**, **Power Pivot**, and **DAX** to provide a comprehensive overview of business performance before moving to Power BI.

### Dashboard Features

- Executive KPI Cards
  - Total Sales
  - Total Profit
  - Profit Margin
  - Total Orders
  - Total Customers

- Interactive Slicers
  - Market
  - Segment
  - Category
  - Date (Timeline)

- Business Visualizations
  - 3-Month Moving Average Sales Trend
  - Top 15 Countries by Sales
  - Sales & Profit by Market
  - Sales & Profit by Category
  - Top 10 Products by Profit
  - Sales & Profit by Segment

### Excel Features Used

- Power Query
- Power Pivot
- Data Model Relationships
- DAX Measures
- Time Intelligence
- Moving Average
- Pivot Charts
- Timeline & Slicers

<p align="center">
  <img src="images\Excel_Dashboard.png" width="950">
</p>

# 📈 Power BI Dashboard

The final stage of this project is a fully interactive Power BI dashboard that turns raw transactional data into insights for decision-makers.

Designed with a **multi-page analytical workflow**, the dashboard enables users to move from high-level KPIs to detailed product-level analysis while maintaining a smooth navigation experience.

---

## 🚀 Explore the Dashboard

### 🏠 Home
Start your journey from a clean landing page designed to navigate through the entire analytical solution.

<p align="center">
<img src="images\01_Home.png" width="900">
</p>

---

### 📊 Executive Overview
Monitor overall business performance through executive KPIs and interactive visualizations.

**Answer questions like:**
- How have sales evolved over time?
- Which markets generate the highest sales?
- Which business areas contribute the most profit?
- Which categories perform the best?

<p align="center">
<img src="images\02_Executive_Overview.png" width="900">
</p>

---

### 📦 Products Analysis
Dive deeper into product performance and identify profitable and underperforming sub-categories.

**Explore questions such as:**
- Which sub-categories generate the lowest profit?
- Which products have high sales but poor profitability?
- Which sub-categories receive high discounts while remaining unprofitable?

<p align="center">
<img src="images\03_Product_Analysis.png" width="900">
</p>

---

### 🔍 Product Drill-through
Analyze every product inside a selected sub-category with detailed KPIs and transaction-level information.

<p align="center">
<img src="images\04_Product_Drill_Through.png" width="900">
</p>

---

### 💡 Business Insights
A dedicated page that summarizes the most important findings discovered during the analysis.

Each insight includes:
- Observation
- Business Impact
- Recommendation
- **"See Why?"** button that navigates directly to the supporting visualization.

<p align="center">
<img src="images\05_Insights.png" width="900">
</p>

---

## ⭐ Dashboard Highlights

- Executive KPI Cards
- Dynamic Field Parameters
- Interactive Navigation
- Drill-through Analysis
- Business Insights Storytelling
- Cross Filtering
- Dynamic Slicers
- Custom Dark Theme
- End-to-End Business Analytics

---

# 💡 Business Insights

The dashboard translates analytical findings into clear business recommendations. A total of **21 Actionable Business Insights** were generated from the analysis, each following a consistent framework:

- 📊 **Observation**
- 💼 **Business Insight**
- ✅ **Recommendation**

The insights cover multiple business domains, including:

- Product Performance
- Category Analysis
- Customer Behavior
- Geographic Performance
- Market Growth
- Discount Strategy
- Profitability Analysis
- Shipping Cost Optimization

## 📝 Example Insights

### 📌 Insight 1 – Furniture Generates Strong Sales but Weak Profitability

**Observation**
Furniture contributes a considerable share of total sales, yet its profitability remains significantly lower than Technology.

**Business Insight**
Revenue alone is not a reliable indicator of business success. Despite strong sales, Furniture delivers relatively low margins, making it less valuable from a profitability perspective.

**Recommendation**
Review pricing strategy, discount policies, and operational costs for Furniture products while prioritizing investment in high-margin Technology products.

---

### 📌 Insight 2 – High Discounts Reduce Profit Instead of Driving Growth

**Observation**
Several products receiving the highest discount rates still generated negative profit despite achieving relatively high sales.

**Business Insight**
The current discount strategy sacrifices profitability without creating sustainable business value.

**Recommendation**
Optimize promotional campaigns by limiting excessive discounts and focusing offers on products capable of maintaining healthy profit margins.

---

### 📌 Insight 3 – Technology Drives Profit Disproportionately to Its Sales Share

**Observation**
Technology generates nearly **50% of the company's total profit** while contributing only around **35% of total sales**.

**Business Insight**
Technology is the company's primary profit driver, whereas Furniture contributes a significant share of sales but delivers relatively low profitability.

**Recommendation**
Increase investment in high-performing Technology products while reviewing pricing, discount strategy, and operational costs within the Furniture category to improve margins.

---

## 📖 Complete Business Insights

The full report contains **21 detailed business insights**, each linked to the supporting dashboard visualization through the **"See Why?"** navigation feature inside the Power BI report.

➡️ **[Read All Business Insights](docs/Business_Insights.md)**

---

# ✨ Key Features

- End-to-End Data Analytics Pipeline
- Data Cleaning with Power Query
- PostgreSQL Data Warehouse
- Star Schema Data Modeling
- Advanced SQL Analytics
- Excel Dashboard with Power Pivot & DAX
- Interactive Power BI Dashboard
- Dynamic Field Parameters
- Drill-through Product Analysis
- Executive KPI Reporting
- 21 Actionable Business Insights
- Interactive Navigation Experience

# 🚀 How to Run

1. Clone this repository.

```bash
git clone https://github.com/zeyad902/global-superstore-analytics.git
```

2. Open the SQL scripts to create the database and data warehouse.

3. Import the cleaned dataset into PostgreSQL.

4. Open the Excel dashboard (`.xlsx`) to explore the Excel analytics solution.

5. Open the Power BI dashboard (`.pbix`) to interact with the complete analytical report.

# 👨‍💻 Author

**Zeyad Mohamed Goda**

🎓 Business Information Systems Student

📊 junior Data Analyst

- 💼 LinkedIn: https://www.linkedin.com/in/zeyad-mohamed-goda
- 💻 GitHub: https://github.com/zeyad902
- 📧 Email: zeyadmohamedgoda@gmail.com
