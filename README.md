# MedCore RCM – Healthcare Claim Denial Analytics

An end-to-end healthcare Revenue Cycle Management (RCM) analytics project focused on identifying insurance claim denials, analyzing denial patterns, monitoring payment recovery, and evaluating authorization performance using Python, Microsoft SQL Server, and Power BI.

## Project Overview

Healthcare organizations process large volumes of insurance claims, but not all claims are successfully reimbursed. Claim denials, delayed authorizations, and outstanding payments can affect revenue collection and create additional administrative work.

This project simulates a healthcare network, **MedCore Health Network**, to analyze its revenue cycle operations and identify areas contributing to claim denials and outstanding payments.

The analysis focuses on understanding:
- How many insurance claims are denied?
- What are the major reasons for claim denials?
- Which insurance payers have higher denial rates?
- Which medical specialties and procedures experience more denials?
- How much denied claim value remains outstanding?
- How efficiently are insurance authorizations processed?
- What is the current payment and recovery status?

The objective is to transform raw healthcare transaction data into meaningful business insights through data validation, SQL analysis, and interactive Power BI dashboards.

**Note:** This project uses synthetic data generated for portfolio and analytical purposes. It does not contain real patient or insurance records.

## Business Objectives

- Measure the overall claim denial rate and total denied claim value.
- Identify the most common denial reasons and their financial impact.
- Compare denial performance across insurance payers.
- Analyze denial trends by medical specialty, procedure, and location.
- Monitor paid amounts, outstanding balances, and recovery status.
- Evaluate authorization approval turnaround time.
- Identify opportunities to improve revenue recovery and reduce claim processing issues.

## Technology Stack

| Technology | Purpose |
|---|---|
| Python | Synthetic data generation and data validation |
| Pandas & NumPy | Data manipulation, profiling, and quality checks |
| Microsoft SQL Server | Relational data storage and SQL-based analysis |
| SQL | Joins, aggregations, CASE statements, CTE/window-function analysis |
| Power BI | Interactive dashboards and business reporting |
| DAX | KPI calculations and analytical measures |
| Excel / CSV | Dataset storage and data exchange |

## Dataset Overview

The project contains seven related datasets representing master data and transaction data.

| Dataset | Rows | Columns | Description |
|---|---:|---:|---|
| Patients | 15,000 | 3 | Patient demographic information |
| Payers | 8 | 3 | Insurance payer details |
| Providers | 40 | 5 | Healthcare provider information |
| Procedures | 24 | 6 | Medical procedures, specialties, and authorization requirements |
| Claims | 50,000 | 12 | Insurance claim details, amounts, status, and denial information |
| Authorization | 50,000 | 6 | Authorization requests, approval status, and dates |
| Payments | 50,000 | 5 | Payment amounts, payment dates, and recovery information |

**Total:** 7 datasets containing 165,112 records.

### Key Dataset Relationships

The transaction datasets are connected using `Claim_ID`.

- Claims → Patients using `Patient_ID`
- Claims → Payers using `Payer_ID`
- Claims → Providers using `Provider_ID`
- Claims → Procedures using `Procedure_Code`
- Claims → Authorization using `Claim_ID`
- Claims → Payments using `Claim_ID`

Each claim has one corresponding authorization record and one payment record in this simulated dataset.

## Project Workflow

### 1. Synthetic Data Generation – Python

Generated a healthcare revenue-cycle dataset using Python, Pandas, and NumPy.

The data generation process includes:
- Creating patient, payer, provider, and procedure master datasets.
- Generating 50,000 healthcare insurance claims.
- Assigning claim amounts based on procedure-level minimum and maximum values.
- Generating paid, denied, and pending claim statuses.
- Creating authorization records based on procedure authorization requirements.
- Generating payment amounts, outstanding balances, and recovery statuses.
- Applying business rules to maintain consistency between claims, authorization, and payment records.

A fixed random seed was used to support reproducible data generation.

### 2. Data Profiling & Quality Validation – Python

Performed data profiling and business-rule validation before loading the datasets into SQL Server.

Key validation activities:
- Checked dataset dimensions, missing values, and duplicate records.
- Validated primary keys and foreign-key references.
- Checked claim status against denial flags.
- Verified authorization requirements against the procedure master dataset.
- Validated claim amounts against procedure-level limits.
- Checked payment amounts and outstanding balance calculations.
- Validated date fields and authorization timing.
- Checked consistency between claim status and payment recovery status.
- Verified claim-to-authorization and claim-to-payment relationships.

The corrected generation notebook also includes assertion-based validation to prevent exporting datasets when critical business rules fail.

### 3. SQL Analysis – Microsoft SQL Server

Loaded the validated datasets into the `MedCore_RCM_Analytics` database.

Performed business-oriented analysis using SQL queries.

**Key SQL analysis areas:**

1. Overall claim denial rate and claim status distribution.
2. Denial analysis by reason.
3. Comparison of denial rates across insurance payers.
4. Denial reasons by payer.
5. Recovery performance of denied claims.
6. Denial rates by medical specialty.
7. Denial rates by medical procedure.
8. Authorization status and denial performance.
9. Outstanding denied amounts by denial reason.

SQL techniques used:
- SELECT, WHERE, GROUP BY, ORDER BY
- INNER JOIN
- CASE WHEN
- Aggregate functions such as COUNT, SUM, and AVG
- NULLIF and CAST
- Window functions
- Transaction-based update validation

### 4. Power BI Dashboard Development

Developed an interactive Power BI dashboard consisting of four analytical pages.

**Page 1 – Claim Denial Overview**

Provides a high-level view of healthcare claim performance.

Key KPIs:
- Total Claims
- Total Paid Amount
- Outstanding Amount
- Denied Claims
- Denial Rate
- Total Claim Value

Visualizations:
- Outstanding rate by denial status
- Monthly denial rate trend
- Denial rate by insurance payer
- Outstanding rate by denial reason

**Page 2 – Denial Root Cause Analysis**

Focuses on identifying the major reasons behind claim denials.

Visualizations:
- Top 10 procedures by denied claim value
- Denial rate by medical specialty
- Denied claim value by denial reason
- Outstanding denied amount by denial reason
- Denied claim count by denial reason

**Page 3 – Payment & Outstanding Analysis**

Evaluates payment collection and outstanding balances.

Visualizations:
- Outstanding amount by claim value category
- Outstanding amount by recovery status
- Top 10 providers by outstanding amount
- Unpaid share by insurance payer

**Page 4 – Payer, Authorization & Denial Analysis**

Provides a detailed view of payer performance and authorization processing.

Visualizations:
- Outstanding amount by claim status
- Approved authorizations by approval time category
- Denied claim value by payer and denial reason

Interactive slicers allow analysis by payer, location, and medical specialty.

## DAX Measures & Calculated Columns

Created DAX measures and calculated columns to support dashboard KPIs and business analysis.

Key measures include:
- Total Claims
- Total Claim Value
- Total Paid Amount
- Total Outstanding Amount
- Denied Claims
- Denial Rate
- Denied Claim Value
- Denied Outstanding Amount
- Outstanding Rate
- Paid Rate
- Approved Count
- Average Approval Days
- Median Approval Days
- Approved Within 3 Days %
- Partially Collected Claims
- Unrecovered Claims
- Reconciliation Difference

Calculated columns include:
- Approval Days
- Approval Time Category
- Claim Value Category
- Denial Status
- Service To Payment Days

A separate Date Table was created to support date-based reporting.

## Key Business Findings

Based on the generated dataset and Power BI analysis:

| Metric | Result |
|---|---:|
| Total Claims | 50,000 |
| Denied Claims | 4,137 |
| Overall Denial Rate | 8.27% |
| Total Claim Value | ₹781.29 Million |
| Total Paid Amount | ₹649.62 Million |
| Total Outstanding Amount | ₹131.67 Million |
| Denied Claim Value | ₹83.72 Million |

### Important Insights

**1. Major Denial Reasons**

Coding Error (946 claims) and Documentation Missing (916 claims) are the two largest denial categories, together representing approximately 45.01% of denied claims.

**2. Payer Performance**

PrimeCare Health has the highest denial rate at 10.49%, while MediSure Insurance has the lowest denial rate at 6.31%.

**3. Financial Impact of Denials**

Coding Error contributes approximately ₹21.10 million in denied claim value, followed by Medical Necessity at ₹18.67 million.

**4. Outstanding Amount**

The overall outstanding amount is approximately ₹131.67 million. The dashboard also highlights differences in outstanding balances across claim statuses and recovery categories.

**5. Authorization Performance**

The dashboard categorizes approved authorizations based on turnaround time, helping evaluate the time taken to process authorization requests.

## Project Structure

The following is the recommended GitHub repository structure for organizing the project files:

```text
MedCore-RCM-Healthcare-Analytics/
│
├── README.md
│
├── Data/
│   ├── Patients.csv
│   ├── Payers.csv
│   ├── Providers.csv
│   ├── Procedures.csv
│   ├── Claims.csv
│   ├── Authorization.csv
│   └── Payments.csv
│
├── Python/
│   ├── MedCore_RCM_Data_Generation_Corrected.ipynb
│   └── MedCore_RCM_Data_Profiling.ipynb
│
├── SQL/
│   └── Final_RCM_SQL_Analysis.sql
│
├── PowerBI/
│   ├── MedCore_RCM_Dashboard.pbix
│   ├── DAX.txt
│   └── Dashboard_Preview.pdf
│
└── Screenshots/
    ├── Claim_Denial_Overview.png
    ├── Denial_Root_Cause.png
    ├── Payment_Outstanding_Analysis.png
    └── Payer_Authorization_Analysis.png
```

## How to Run the Project

1. Clone or download this repository.
2. Install Python and the required libraries: `pandas`, `numpy`, and `jupyter`.
3. Run `MedCore_RCM_Data_Generation_Corrected.ipynb` to generate the seven CSV datasets.
4. Run `MedCore_RCM_Data_Profiling.ipynb` to perform data quality checks and profiling.
5. Create the `MedCore_RCM_Analytics` database in Microsoft SQL Server.
6. Import the generated CSV files into SQL Server using the appropriate table structures and data types.
7. Execute `Final_RCM_SQL_Analysis.sql` to perform the SQL analysis.
8. Open the Power BI report and connect it to the SQL Server database.
9. Review the DAX measures and explore the four interactive dashboard pages.

## Project Outcome

This project demonstrates an end-to-end Data Analytics workflow, starting from synthetic data generation and data quality validation to SQL-based business analysis and interactive Power BI reporting.

It showcases practical skills in Python, SQL, data modeling, business-rule validation, DAX, KPI development, and data visualization, with a focus on healthcare revenue-cycle operations and insurance claim denial analysis.

---

**Project Domain:** Healthcare Analytics | Revenue Cycle Management (RCM)

**Tools:** Python | SQL Server | Power BI | DAX
