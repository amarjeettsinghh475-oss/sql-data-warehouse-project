# Data Warehouse and Analytics Project  

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

---

## 📖 Project Overview  

This project involves:  

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.  
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.  
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.  
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.  

🎯 This repository is an excellent resource for professionals and students looking to showcase expertise in:  
- SQL Development  
- Data Architecture  
- Data Engineering  
- ETL Pipeline Development  
- Data Modeling  
- Data Analytics  

---

## 🚀 Project Requirements  

### Building the Data Warehouse (Data Engineering)  

#### Objective  
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.  

#### Specifications  
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.  
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.  
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.  
- **Scope**: Focus on the latest dataset only; historization of data is not required.  
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.  

---

### BI: Analytics & Reporting (Data Analysis)  

#### Objective  
Develop SQL-based analytics to deliver detailed insights into:  
- **Customer Behavior**  
- **Product Performance**  
- **Sales Trends**  

These insights empower stakeholders with key business metrics, enabling strategic decision-making.  

For more details, refer to `docs/requirements.md`.  

---

## 📂 Repository Structure  
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # ETL data flows
│   ├── data_catalog.md                 # Field descriptions and metadata
│   ├── data_flow.drawio                # Data flow diagram
│   ├── data_models.drawio              # Data models (star schema)
│   ├── naming-conventions.md           # Naming guidelines for tables and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Raw data extraction and loading
│   ├── silver/                         # Data cleaning and transformation
│   ├── gold/                           # Analytical model creation
│
├── tests/                              # Data quality and validation scripts
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Ignored files for Git
└── requirements.txt                    # Project dependencies
```

---

## 🛡️ License  

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.  

---

## 🌟 About Me  

Hi there! I'm **Amarjeet Singh** — a data enthusiast passionate about developing modern data solutions and creating insightful analytics that drive business value. This project reflects my learning journey in data engineering, modeling, and analysis.  
```
