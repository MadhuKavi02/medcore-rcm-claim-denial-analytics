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

## Technology Stack

| Tool | Application |
|---|---|
| Python (Pandas, NumPy) | Synthetic dataset generation, data profiling, and validation |
| Microsoft SQL Server (T-SQL) | Data storage, relational analysis, and business queries |
| Power BI (DAX) | Data modeling, KPI development, and interactive dashboard creation |

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

Created key DAX measures and calculated columns for claim denial analysis, outstanding payment tracking, and authorization turnaround analysis.

### Key DAX Formulas

**1. Denial Rate**
```dax
Denial Rate =
DIVIDE(
    [Denied Claims],
    [Total Claims],
    0
)
```

**2. Denied Claim Value**
```dax
Denied Claim Value =
CALCULATE(
    [Total Claim Value],
    Claims[Denial_Flag] = TRUE()
)
```

**3. Denied Outstanding Rate**
```dax
Denied Outstanding Rate =
DIVIDE(
    [Denied Outstanding Amount],
    [Denied Claim Value],
    0
)
```

**4. Outstanding Rate**
```dax
Outstanding Rate =
DIVIDE(
    [Total Outstanding Amount],
    [Total Claim Value],
    0
)
```

**5. Reconciliation Difference**
```dax
Reconciliation Difference =
ROUND(
    [Total Claim Value] - [Total Paid Amount] - [Total Outstanding Amount],
    2
)
```

**6. Approval Days (Calculated Column)**
```dax
Approval Days =
IF(
    NOT ISBLANK(Authorization[Approval_Date])
        && NOT ISBLANK(Authorization[Request_Date]),
    DATEDIFF(
        Authorization[Request_Date],
        Authorization[Approval_Date],
        DAY
    )
)
```


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

**Project Domain:** Healthcare Analytics | Revenue Cycle Management (RCM)

**Tools:** Python | SQL Server | Power BI | DAX
