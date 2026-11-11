# MedCore RCM — Healthcare Claim Denial Analytics

**An end-to-end healthcare Revenue Cycle Management (RCM) analytics project using Python, SQL Server, and Power BI to investigate claim denials, outstanding balances, payer performance, and payment recovery.**

---

## Project Overview

MedCore RCM is an end-to-end Data Analyst portfolio project based on a fictional multi-location Indian healthcare network, **MedCore Health Network**.

The project focuses on understanding healthcare insurance claim performance and identifying where claim denials and outstanding financial balances are concentrated.

The central business questions are:

- What proportion of submitted claims are denied?
- Which denial reasons, payers, specialties, and procedures have higher denial rates?
- How much of the claimed amount remains outstanding?
- Which claim categories contribute most to outstanding financial exposure?
- How effectively are denied claims being recovered?
- How quickly are authorization requests being approved?

The project follows a complete analytics workflow, from Python-based data profiling and validation to SQL Server business analysis and an interactive four-page Power BI dashboard.

> **Data Disclaimer:** This is a portfolio project built using synthetic/generated data. MedCore Health Network is fictional. The dataset does not contain real patient, provider, payer, or hospital information. The findings are illustrative and should not be interpreted as actual healthcare industry benchmarks.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| Python | Data profiling, cleaning, and validation |
| Pandas | Data manipulation and quality checks |
| Jupyter Notebook | Data exploration and documentation |
| Microsoft SQL Server | Data storage, querying, and business analysis |
| SQL / T-SQL | Joins, aggregations, CTEs, calculations, and validation |
| Power BI Desktop | Interactive dashboard development |
| DAX | Calculated columns and business measures |

---

## Dataset Overview

The project uses seven related datasets containing **100,072 records across 40 columns**.

| Table | Records | Description |
|---|---:|---|
| Patients | 15,000 | Patient age and gender |
| Payers | 8 | Payer names and payer types |
| Providers | 40 | Provider details, locations, and specialties |
| Procedures | 24 | Procedure codes, specialties, and authorization requirements |
| Claims | 50,000 | Claim details, amounts, service dates, and denial information |
| Authorization | 50,000 | Authorization requirements, statuses, and approval dates |
| Payments | 50,000 | Paid amounts, outstanding balances, and recovery statuses |
| **Total** | **100,072** | **7 related tables** |

### Dataset Coverage

- **Locations:** Chennai Central, Chennai East, Chennai North, Chennai South, Chennai West, and Coimbatore.
- **Payers:** 8.
- **Providers:** 40.
- **Specialties:** 8.
- **Procedures:** 24.
- **Service period:** January–December 2025.

### Dataset Structure

The Claims table acts as the central transaction table, connected to patient, payer, provider, procedure, authorization, and payment information.

**Data modelling simplification:** Authorization and Payments contain one record per claim. Actual healthcare revenue cycle systems may contain multiple authorization requests, payment transactions, adjustments, and appeal events for a single claim.

---

## End-to-End Analytics Workflow

```text
Seven Source CSV Files
          |
          v
Python - Data Profiling and Validation
          |
          v
SQL Server - Data Storage and Analysis
          |
          v
Power BI - Data Modelling and DAX
          |
          v
Four-Page Interactive Dashboard
          |
          v
Business Findings and Recommendations
```

---

## Phase 1 — Python: Data Profiling and Validation

Python and Pandas were used to inspect the seven source datasets and perform data quality checks before loading the data into SQL Server.

### Data Quality Checks

- Record counts and column-level inspection.
- Duplicate checks across transaction and master tables.
- Missing-value analysis.
- Primary identifier uniqueness.
- Foreign-key consistency across related datasets.
- Claim status and denial flag consistency.
- Validation of denial reasons against claim status.
- Claim amount validation against procedure-level minimum and maximum amounts.
- Authorization date and status validation.
- Payment amount and outstanding balance reconciliation.

### Data Quality Decisions

- Null denial reasons were retained for non-denied claims because they are expected.
- Missing authorization dates were retained where an approval had not occurred or no request existed.
- Monetary reconciliation differences caused by floating-point precision were investigated and validated using two-decimal rounding.
- Financial consistency was checked using:

  `Claim Amount = Paid Amount + Outstanding Amount`

- No records were removed simply to make the dataset appear cleaner.

---

## Phase 2 — SQL Server: Business Analysis

The validated datasets were loaded into the `MedCore_RCM_Analytics` SQL Server database.

SQL Server was used to perform business-focused analysis and investigate the relationships between claims, denials, authorizations, and payments.

### Key SQL Investigations

| No. | Business Analysis | SQL Techniques |
|---|---|---|
| 1 | Overall claim volume, claim value, paid amount, and outstanding amount | COUNT, SUM, aggregation |
| 2 | Overall denial rate and claim status distribution | CASE, conditional aggregation |
| 3 | Denial rate by payer | JOIN, GROUP BY |
| 4 | Denial count and claim value by denial reason | GROUP BY, aggregation |
| 5 | Outstanding amount and outstanding rate by denial reason | JOIN, conditional aggregation |
| 6 | Denial rate and denied value by specialty | JOIN, GROUP BY |
| 7 | Denial rate by procedure | JOIN, GROUP BY, HAVING |
| 8 | Authorization status and denial performance | JOIN, conditional aggregation |
| 9 | Denied claim payment recovery analysis | JOIN, SUM, percentage calculations |
| 10 | Outstanding amount by payer and recovery status | GROUP BY, aggregation |
| 11 | Monthly denial rate analysis | Date functions, GROUP BY |
| 12 | High-value claim outstanding exposure | CASE, conditional aggregation |
| 13 | Authorization approval turnaround | DATEDIFF, AVG, grouping |
| 14 | Service-to-payment interval analysis | DATEDIFF, JOIN, AVG |

The SQL analysis also included cross-table reconciliation and validation of the financial amounts used in the Power BI report.

---

## Phase 3 — Power BI: Interactive Dashboard

An interactive four-page Power BI report was developed to present the analytical findings through KPIs, charts, comparisons, and detailed breakdowns.

### Data Modelling

- Connected Power BI to the SQL Server database.
- Loaded the seven related tables.
- Created a dedicated Date Table.
- Established relationships between the central Claims table and relevant dimension and transaction tables.
- Created DAX measures and calculated columns for business metrics.
- Used slicers to support interactive analysis.

### Report Pages

| Page | Focus | Key Visuals |
|---|---|---|
| **1. Claim Denial Analytics** | Overall claim performance | KPI cards, monthly denial rate trend, outstanding rate by denial status, denial rate by payer, outstanding rate by denial reason |
| **2. Denial Root Causes** | Identifying denial patterns | Top 10 procedures by denied claim value, denied claim value by reason, outstanding denied amount by reason, denial rate by specialty, denied claim count by reason |
| **3. Payment & Outstanding Analysis** | Financial exposure and recovery | Outstanding amount by claim value category, outstanding amount by recovery status, top 10 providers by outstanding amount, unpaid share by payer |
| **4. Payer, Authorization & Denial Analysis** | Payer-level investigation and authorization turnaround | Outstanding amount by claim status, authorization approval turnaround distribution, denied claim value by payer and denial reason matrix |

### Key DAX Concepts

The report uses DAX for conditional calculations, filter context, aggregation, and percentage measures.

Examples of the calculations include:

- Total claims and distinct claim counts.
- Denied, paid, and pending claims.
- Overall denial rate.
- Total claim value and denied claim value.
- Total paid and outstanding amounts.
- Denied outstanding amount and outstanding rate.
- Recovery status classification.
- Authorization approval days and approval time categories.
- Claim value categorization.

---

## Key Business Findings

The following findings are based on the corrected SQL Server database and the final Power BI report.

### 1. Overall Claim Performance

| Metric | Result |
|---|---:|
| Total Claims | 50,000 |
| Denied Claims | 4,137 |
| Paid Claims | 43,113 |
| Pending Claims | 2,750 |
| Denial Rate | 8.27% |
| Total Claim Value | ₹781.29M |
| Total Paid Amount | ₹649.62M |
| Total Outstanding Amount | ₹131.67M |

The overall denial rate is 8.27%. The outstanding balance represents the portion of the original claim value that has not yet been collected in the dataset.

### 2. Denial Reason Analysis

| Denial Reason | Denied Claims | Denied Claim Value |
|---|---:|---:|
| Coding Error | 946 | ₹21.10M |
| Documentation Missing | 916 | ₹14.35M |
| Medical Necessity | 822 | ₹18.67M |
| Eligibility Issue | 775 | ₹17.65M |
| Timely Filing | 265 | ₹0.87M |
| Missing Authorization | 236 | ₹10.59M |
| Duplicate Claim | 177 | ₹0.49M |

**Key finding:** Coding Error and Documentation Missing together account for approximately 45.01% of denied claims.

Denial frequency and financial exposure do not always identify the same priorities. Therefore, both claim count and monetary value are important measures.

### 3. Payer Performance

- PrimeCare Health recorded the highest denial rate at **10.49%**.
- MediSure Insurance recorded the lowest denial rate at **6.31%**.
- The difference highlights areas for further payer-level investigation.

Payer comparisons are descriptive. Claim, specialty, and procedure mix were not adjusted, so the results do not establish that a payer caused the differences.

### 4. Denied Claim Recovery and Outstanding Exposure

| Metric | Result |
|---|---:|
| Total Denied Claims | 4,137 |
| Denied Claim Value | ₹83.72M |
| Paid / Recovered Amount | ₹36.08M |
| Outstanding Amount on Denied Claims | ₹47.64M |
| Recovery Percentage | 43.09% |

The analysis shows that approximately 43.09% of the denied claim value has been paid or recovered in the synthetic dataset, while ₹47.64M remains outstanding.

Outstanding balances should not automatically be interpreted as permanent financial losses.

### 5. Outstanding Exposure by Claim Value

| Claim Category | Claims | Outstanding Amount |
|---|---:|---:|
| High Value (₹1L+) | 1,875 | ₹63.94M |
| Medium Value (₹25K–₹1L) | 4,160 | ₹36.30M |
| Low Value (Below ₹25K) | 43,965 | ₹31.43M |

**Key finding:** High-value claims account for only 3.75% of all claims but contribute approximately 48.6% of the total outstanding amount.

This indicates that monitoring high-value claims could be a useful financial follow-up priority.

### 6. Authorization Approval Turnaround

The authorization analysis identified 12,642 approved authorizations.

| Approval Time | Approved Authorizations |
|---|---:|
| Same Day | 2,487 |
| 1 Day | 2,478 |
| 2–3 Days | 5,154 |
| 4 Days | 2,523 |
| **Total** | **12,642** |

Additional findings:

- Average approval time: **2.01 days**.
- 60.04% of approved authorizations were completed within one day.
- 80.04% were completed within three days.

The turnaround analysis provides an operational view of authorization approval timing.

### 7. Service-to-Payment Analysis

An additional SQL investigation examined the number of days between claim service dates and payment dates.

The average interval across payers was approximately **33.5 days**.

**Important interpretation:** This is a service-to-payment interval, not actual payer processing time. The dataset does not contain claim submission or receipt dates, so the payer's processing duration cannot be established.

---

## Business Recommendations

Based on the descriptive and diagnostic findings, the following areas could be prioritised for further investigation.

| Business Area | Recommendation |
|---|---|
| Denial Prevention | Review coding accuracy and documentation completeness, as these are the two most frequent denial categories. |
| Financial Follow-up | Prioritise claims with higher outstanding balances for follow-up. |
| High-Value Claims | Monitor high-value claims more closely because they account for a substantial share of outstanding exposure. |
| Payer Monitoring | Review payer-level denial patterns alongside specialty and procedure information. |
| Authorization Management | Monitor approval turnaround and investigate claims denied for missing authorization. |
| Recovery Monitoring | Track denied claim recovery and outstanding balances by recovery status. |
| Reporting and Review | Review denial rates, outstanding amounts, and recovery performance regularly. |

These recommendations identify potential areas for operational review. No actual intervention or improvement in recovery was implemented or measured as part of this project.

---

## Data Limitations and Assumptions

- The dataset is synthetic and does not establish real healthcare industry benchmarks.
- The analysis covers one year of service dates (2025), which is insufficient to establish long-term trends or seasonality.
- Outstanding amounts represent balances in the dataset and should not be interpreted as confirmed permanent losses.
- Denied claim value represents the original claim amount, not a confirmed financial loss.
- Payer comparisons are not adjusted for differences in claim, specialty, or procedure mix.
- Authorization and payment tables are simplified to one record per claim.
- The dataset does not include claim submission dates, denial dates, appeal outcomes, or payer contract rules.
- Service-to-payment days are therefore a proxy rather than a direct measure of payer processing time.
- Authorization approval after the service date may indicate a delayed-authorization pattern, but the available fields do not establish the reason for denial.
- No savings, improved denial rates, or additional recoveries are claimed because no intervention was implemented or measured.
- The project focuses on descriptive and diagnostic analytics. Predictive modelling is outside the current scope.

---

## Project Outcomes

This project demonstrates an end-to-end analytical workflow involving:

- Python-based data profiling and quality validation.
- SQL Server database creation and multi-table analysis.
- Business-focused SQL queries and financial reconciliation.
- Power BI data modelling and DAX calculations.
- Interactive dashboard development.
- Interpretation of operational and financial performance metrics.
- Translation of analytical findings into business recommendations.

---

## About

**Madhumitha Mathivanan**

Aspiring Data Analyst | SQL | Python | Power BI | Excel

Interested in data analysis, business reporting, SQL-based problem solving, and transforming data into meaningful business insights.

---

**Project:** MedCore RCM — Healthcare Claim Denial Analytics  
**Data Type:** Synthetic / Generated  
**Tools:** Python, SQL Server, Power BI
