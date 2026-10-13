# 🏥 MedCore RCM — Healthcare Claim Denial Analytics

> **End-to-end portfolio analytics project simulating revenue cycle management at a fictional Indian health network using Python, SQL Server, and Power BI.**

---

## 📌 Project Overview

MedCore RCM is a complete Data Analyst portfolio project built around a fictional multi-location health network — **MedCore Health Network** — processing insurance claims across six locations, 40 providers, eight specialties and eight payers.

The core business question driving this project:

> *"Where do claim denials concentrate, how much revenue is still unpaid because of them, and where should prevention and follow-up be prioritized?"*

The project answers this question through a full analytics workflow: from profiling and validating seven source tables, to SQL Server analysis, to an interactive four-page Power BI dashboard.

> **Note:** This is a portfolio project on **synthetic (generated) data**. MedCore Health Network is fictional. It is not real client work, employment experience, or real patient, provider or payer data.

---

## 🛠️ Technology Stack

| Tool | Purpose |
|------|---------|
| **Python** (pandas, Jupyter Notebook) | Data profiling, cleaning, validation |
| **SQL Server** (T-SQL, SSMS) | Structured business analysis and reconciliation |
| **Power BI Desktop** (DAX) | Interactive four-page dashboard |

---

## 📊 Dataset Summary

| Table | Rows | Description |
|-------|------|-------------|
| Claims | 50,000 | Claim amounts, service dates, denial flag and reason |
| Claim_Authorization | 50,000 | Authorization requirement, status and dates |
| Payments | 50,000 | Paid and outstanding amounts, recovery status |
| Patients | 15,000 | Age and gender |
| Providers | 40 | Provider type, location, specialty profile |
| Payers | 8 | Seven private payers, one government payer |
| Procedures | 24 | Procedure, specialty, authorization rule, claim-amount range |

**Coverage:** Six locations: Chennai Central, East, North, South, West and Coimbatore
**Period:** Claim service dates January – December 2025
**Specialties:** Cardiology, Radiology, Orthopedics, Oncology, Neurology, Gastroenterology, General Medicine, Emergency Medicine

**Simplification:** authorization and payments have one row per claim. Real systems can have several authorization, payment or appeal events per claim.

---

## 🔄 End-to-End Pipeline

```
Raw CSVs (7 tables)
    ↓
Python — Profiling, Cleaning & Validation
    ↓
SQL Server — Business Analysis & Reconciliation
    ↓
Power BI — Interactive Dashboard (4 Pages)
    ↓
Findings & Recommendations
```

---

## 🐍 Phase 1 — Python: Profiling, Cleaning & Validation

### Checks Performed
- Duplicate claim IDs, missing values and invalid ranges across all seven tables
- Business rules: denied status matches denial flag, every denied claim has a reason, no non-denied claim has one
- Authorization rules: approved authorizations have request date, approval date and ID; no approval before request
- Financial reconciliation: `Claim_Amount = Paid_Amount + Outstanding_Amount` for every claim
- Cross-table validation: claims to patients, providers, payers, procedures, authorization and payments, with zero mismatches
- Procedure rules: authorization requirements, specialties and claim amounts validated against the procedure master

### Data Quality Decisions
- **Nulls kept on purpose:** `Denial_Reason` is null for non-denied claims, authorization dates are null when no request exists, and payment dates are null where nothing was paid. Filling them with "Unknown" or invented dates would have created false data.
- **Floating-point mismatch investigated:** an initial check flagged 10,895 reconciliation differences. They were precision differences, not errors, and rounding to two decimals brought the count to zero.
- **Cleaning was light:** date-type standardization and monetary rounding. The data was generated to be consistent, so no rows were removed.
- Raw files were kept unchanged, and cleaned copies were saved separately.

---

## 🗄️ Phase 2 — SQL Server: Business Analysis

Analysis in SQL Server covers eleven business areas. Power BI figures were reconciled against these results.

| No. | Business Question | Technique |
|-----|-------------------|-----------|
| A | Overall claims, value, paid, outstanding and denial rate | SUM, COUNT, percentage calculations |
| B | Denial rate by payer | JOIN, GROUP BY |
| C | Denial count and denied value by reason | GROUP BY, aggregation |
| D | Outstanding amount and rate on denied claims by reason | JOIN, GROUP BY |
| E | Denied vs. non-denied claims: unpaid share | CASE WHEN, aggregation |
| F | Denial rate and denied value by specialty | JOIN, GROUP BY |
| G | Denial rate and denied value by procedure | JOIN, GROUP BY |
| H | Denial rate by authorization status | JOIN, GROUP BY |
| I | Outstanding amount and rate by payer | JOIN, GROUP BY |
| J | Paid and outstanding by recovery status | JOIN, GROUP BY |
| K | Monthly denial rate | Date functions, GROUP BY |

---

## 📈 Phase 3 — Power BI Dashboard

Four-page interactive report with slicers (payer, specialty, location), KPI cards, heatmap matrices and a dedicated date table.

### Report Pages

| Page | Focus | Key Visuals |
|------|-------|-------------|
| **Executive Summary** | Business overview | KPI cards, monthly denial rate, unpaid share (denied vs. non-denied), denial rate by payer, unpaid share by reason |
| **Denial Root Causes** | Where denials concentrate | Denied count vs. value by reason, denial rate by specialty, top 10 procedures by value and by rate |
| **Authorization & Recovery** | Authorization and unpaid money | Claims and denial rate by authorization status, unpaid share by status and payer, recovery status, top 10 providers |
| **Drill-down Matrix** | Combinations to investigate | Payer × reason and specialty × reason heatmaps, reason × authorization status counts |

### Core DAX Measures Used

```
// Denial Rate
Denial Rate =
DIVIDE([Denied Claims], [Total Claims], 0)

// Denied Claim Value
Denied Claim Value =
CALCULATE([Total Claim Value], Claims_Clean[Denial_Flag] = 1)

// Outstanding Rate
Outstanding Rate =
DIVIDE([Total Outstanding Amount], [Total Claim Value], 0)

// Outstanding Amount on Denied Claims
Denied Outstanding Amount =
CALCULATE([Total Outstanding Amount], Claims_Clean[Denial_Flag] = 1)

// Unpaid Share of Denied Value
Denied Outstanding Rate =
DIVIDE([Denied Outstanding Amount], [Denied Claim Value], 0)

// Reconciliation Check (should equal 0)
Reconciliation Difference =
ROUND([Total Claim Value] - [Total Paid Amount] - [Total Outstanding Amount], 2)

// Claim Group (calculated column)
Claim Group =
IF(Claims_Clean[Denial_Flag] = 1, "Denied", "Not Denied")
```

---

## 📋 Key Findings


### 💰 Overall Performance
- **50,000 claims** worth **₹770.89M**: **₹643.09M paid** and **₹127.81M outstanding**
- **4,042 denied claims**, an overall denial rate of **8.08%**
- Denied claims are 8.08% of claims, but **58.70% of their value is unpaid**, compared with **11.58%** for non-denied claims

### 🧾 Denial Reasons
- **Documentation Missing** is the most frequent reason (**849** claims)
- **Missing Authorization** has the largest denied value (**₹21.85M**) and outstanding amount (**₹12.71M**)
- Unpaid share of denied value ranges from **52.79% to 62.00%** across reasons (highest for Medical Necessity), so differences between reasons are small
- Frequency and money point to different priorities

### 🏦 Payers
- **PrimeCare Health** has the highest denial rate (**10.32%**), **MediSure** the lowest (**6.46%**)
- **HealthFirst** has the highest unpaid share (**20.07%**); **PrimeCare** has the largest outstanding amount (**₹18.77M**)
- Claim, specialty and procedure mix were not adjusted, so payer comparisons show where to investigate, not what caused the difference

### 🏥 Specialties & Procedures
- **Oncology** has the highest specialty denial rate (**10.76%**); **Orthopedics** has the largest denied value (**₹30.17M**)
- **Knee Replacement** carries **₹27.99M** of denied value (115 denials, about ₹243K each)
- **Radiation Therapy** has the highest procedure denial rate (**12.81%**)

### 🔐 Authorization
- Denial rate is **6.72%** where authorization is not required, versus roughly **11%** for the other statuses; Approved (**10.74%**) is nearly as high as Not Requested (**11.13%**)
- **417 of 566** Missing Authorization denials sit on claims whose authorization status is **Approved**, so status alone does not explain them
- Denial reasons in this synthetic data do not appear to depend on authorization status

### 📅 Monthly Pattern
- Monthly denial rate ranges from **7.45% (February)** to **8.84% (January)**
- One year of data is not enough to show a trend or seasonality

---

## 💡 Business Recommendations


| Area | Recommendation |
|------|---------------|
| **Follow-up Priority** | Rank denied claims by outstanding amount for follow-up, adding claim age and appeal deadlines if that data becomes available |
| **Authorization Review** | Review Missing Authorization denials at claim level, starting with the 417 that have an approved authorization on record |
| **Denial Monitoring** | Monitor payer, denial reason, specialty and procedure together rather than payer-level rates alone |
| **High-Value Procedures** | Add pre-submission checks (authorization, eligibility, coding, documentation) for Knee Replacement and Cardiac Catheterization |
| **KPI Design** | Track count-based and value-based KPIs together: denial rate, denied value, outstanding amount, outstanding rate |
| **Recurring Review** | Review denial metrics monthly and investigate unusual changes with more granular data |

---

## ⚠️ Limitations

- Dataset is **synthetic**, generated for portfolio purposes only, not real healthcare data. It cannot establish industry benchmarks
- Only one year of service dates, so no seasonality or long-term trend can be established
- **Outstanding amount is not permanent loss**, and denied claim value is the original claim amount, not confirmed loss
- Observed relationships are not causes. Payer comparisons are not adjusted for claim, specialty or procedure mix
- Denial reasons do not appear to depend on authorization status, so reason-level findings are descriptive only
- No appeal outcomes, claim aging or payer contract rules were modeled, so recovery probability cannot be estimated
- Authorization and payments are simplified to one row per claim
- No intervention was implemented or measured. No savings, reduced denials or recoveries are claimed
- Scope is descriptive and diagnostic analytics. Predictive modelling is outside current scope

---


## 👩‍💻 About

**Madhumitha Mathivanan**
Junior Data Engineer → Aspiring Data Analyst
