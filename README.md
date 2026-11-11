# MedCore RCM – Healthcare Claim Denial Analytics

## Project Overview

MedCore RCM – Healthcare Claim Denial Analytics is a data analytics portfolio project focused on understanding healthcare claim denials, payment recovery, and outstanding balances.

The project uses a synthetic healthcare claims dataset to explore claim patterns, identify common denial reasons, compare payer performance, and examine outstanding amounts across different claim categories.

The analysis was carried out using **Python, SQL Server, and Power BI**, covering data validation, SQL-based analysis, and interactive dashboard development.

## Business Objectives

The main objective is to understand where claim denials occur and how they contribute to outstanding payment amounts.

The analysis focuses on the following questions:

- What is the overall claim denial rate?
- Which denial reasons contribute most to denied claims?
- How do denial rates vary across payers, specialties, and procedures?
- How much of the denied claim amount has been recovered, and how much remains outstanding?
- What does the authorization approval turnaround look like?
- Do high-value claims account for a significant share of outstanding balances?

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Python | Data loading, profiling, and initial validation |
| SQL Server | Database management, data validation, and business analysis |
| Power BI | Data modelling, DAX measures, and interactive reporting |
| Jupyter Notebook | Python-based data exploration |

## Dataset Overview

The project uses a **synthetic dataset representing healthcare claim and payment records for 2025**. It contains no real patient or organizational information.

The database consists of seven related tables with 100,072 records in total.

| Table | Records | Description |
|---|---:|---|
| Patients | 15,000 | Patient demographic details |
| Payers | 8 | Insurance payer information |
| Providers | 40 | Healthcare provider details |
| Procedures | 24 | Procedure and authorization details |
| Claims | 50,000 | Claim amounts, dates, status, and denial information |
| Authorization | 50,000 | Authorization requests and approval details |
| Payments | 50,000 | Payment amounts and outstanding balances |

## Project Workflow

### 1. Data Profiling and Validation – Python

- Loaded the source CSV files into Jupyter Notebook.
- Reviewed dataset dimensions, column types, and data distributions.
- Checked missing values, duplicate records, and key fields.
- Performed initial validation to understand the structure and quality of the data.

### 2. Database Development and Analysis – SQL Server

- Imported the seven datasets into a SQL Server database.
- Established the relationships between claims and their related tables.
- Validated record counts, key uniqueness, and data consistency.
- Checked claim amounts, payment amounts, outstanding balances, and authorization details.
- Wrote SQL queries to investigate denial patterns, payer performance, recovery amounts, and outstanding balances.

### 3. Data Modelling and Reporting – Power BI

- Connected Power BI to the SQL Server database.
- Created relationships between the claims data and related tables.
- Developed DAX measures for claim counts, denial rates, payment amounts, and outstanding balances.
- Built a four-page interactive report to present the findings.

## Power BI Dashboard

The report is organised into four pages.

### Page 1 – Claim Denial Overview

Provides an overall view of claim performance through key metrics and visualisations.

Includes:
- Total claims, denied claims, and denial rate
- Total claim value, paid amount, and outstanding amount
- Monthly denial rate trend
- Denial rate by payer
- Outstanding rate by denial reason and claim status

### Page 2 – Denial Root Causes

Focuses on the reasons behind denied claims and the value associated with them.

Includes:
- Denied claim value by denial reason
- Denied claim count by denial reason
- Denial rate by specialty
- Top procedures by denied claim value
- Outstanding denied amount by denial reason

### Page 3 – Payment and Outstanding Analysis

Examines payment recovery and outstanding balances across claim categories and providers.

Includes:
- Outstanding amount by claim value category
- Outstanding amount by recovery status
- Top providers by outstanding amount
- Unpaid share by payer

### Page 4 – Payer, Authorization and Denial Analysis

Brings together payer-level denial exposure and authorization turnaround information.

Includes:
- Outstanding amount by claim status
- Authorization approval turnaround distribution
- Denied claim value by payer and denial reason

## Key Findings

The analysis produced the following observations from the synthetic dataset:

| Metric | Result |
|---|---:|
| Total Claims | 50,000 |
| Denied Claims | 4,137 |
| Overall Denial Rate | 8.27% |
| Total Claim Value | ₹781.29 Million |
| Total Paid Amount | ₹649.62 Million |
| Total Outstanding Amount | ₹131.67 Million |

Other observations:

- **Denial reasons:** Coding Error and Documentation Missing together account for approximately 45% of denied claims.
- **Payer performance:** PrimeCare Health has the highest denial rate at 10.49%, while MediSure Insurance has the lowest at 6.31%.
- **Recovery analysis:** Approximately 43.09% of the denied claim value is covered by recorded payments, with the remaining amount outstanding.
- **High-value claims:** Claims valued at ₹1 lakh or more represent 3.75% of all claims but contribute approximately 48.6% of the total outstanding amount.
- **Authorization turnaround:** The average approval time is approximately 2.01 days, and around 80.04% of approved authorizations were processed within three days.

## Business Observations

Based on the findings, the following areas may be worth reviewing:

- Review coding and documentation processes, as these account for a considerable share of denials.
- Monitor payer-level denial patterns to identify areas requiring further investigation.
- Pay closer attention to high-value claims because they contribute significantly to outstanding balances.
- Monitor authorization turnaround and identify claims that may require earlier follow-up.

These are observations and potential areas for investigation based on the dataset, not confirmed operational improvements.

## Data Limitations

- The dataset is synthetic and was created for portfolio analysis. Results should not be interpreted as actual healthcare industry performance.
- Claim submission and receipt dates are not available. Therefore, the actual payer processing time cannot be calculated from this dataset.
- Some authorization and denial patterns require additional claim-level information to establish the exact reason behind an outcome.

## Project Outcome

This project demonstrates an end-to-end analytics workflow, starting with data profiling and validation in Python, followed by SQL-based investigation and Power BI reporting.

It provided practical experience in working with relational datasets, writing analytical SQL queries, developing DAX measures, and presenting business findings through an interactive dashboard.

## Author

**Madhu**

Aspiring Data Analyst | SQL | Python | Power BI | Excel
