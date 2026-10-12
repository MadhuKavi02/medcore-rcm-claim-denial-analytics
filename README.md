# Healthcare Revenue Cycle Analytics: Claim Denial Root Cause and Revenue Exposure

> **Disclaimer:** This is a portfolio project built on **synthetic (generated) data**. MedCore Health Network is a fictional organization. It is not real client work, employment experience, or real patient, provider or payer data. Findings describe this dataset only.

## Project overview
An end-to-end data analyst project: data profiling and validation in Python, analysis in SQL Server (T-SQL), and a four-page Power BI dashboard. It investigates which claim denial patterns carry the most operational and financial exposure at a fictional multi-location health network.

## Business problem
MedCore's Revenue Cycle Management (RCM) team wants to understand the operational and payer-related patterns associated with claim denials, quantify the related outstanding revenue, and decide where preventive controls and follow-up should be prioritized.

**Stakeholders:** RCM Manager, Finance Operations Manager.

**Questions answered:**
- How many submitted claims are denied, and which denial reasons are most frequent?
- Which reasons create the greatest financial exposure?
- Which payers, specialties, procedures and providers need further investigation?
- How does authorization status relate to denials?
- How much money remains outstanding, and where?

## Dataset
Seven related synthetic tables. Claim service dates run from January to December 2025.

| Table | Rows | Description |
|---|---:|---|
| Claims | 50,000 | Claim amounts, service dates, denial flag and reason |
| Claim_Authorization | 50,000 | Authorization requirement, status and dates |
| Payments | 50,000 | Paid and outstanding amounts, recovery status |
| Patients | 15,000 | Age and gender |
| Providers | 40 | Type, location and specialty profile |
| Payers | 8 | Seven private payers, one government payer |
| Procedures | 24 | Procedure, specialty, authorization rule, claim-amount range |

**Simplification:** authorization and payments have one row per claim. Real systems can have several authorization, payment or appeal events per claim.

## Tools
Python (pandas, Jupyter Notebook), SQL Server and SSMS (T-SQL), Power BI and DAX, GitHub.

## Data validation and cleaning
- Profiled all seven tables and checked duplicates, missing values, keys and business rules.
- Cross-table checks (claims to patients, providers, payers, procedures, authorization and payments) returned zero mismatches.
- `Claim_Amount = Paid_Amount + Outstanding_Amount` holds for every claim after rounding to two decimals. An initial floating-point mismatch turned out to be a precision issue, not a data error.
- Nulls in `Denial_Reason`, authorization dates and payment dates were intentionally kept, because they follow from the business rules (for example, a non-denied claim has no denial reason).
- Cleaning was limited to date-type standardization and monetary rounding. Little repair was needed because the data was generated to be consistent, and no rows were removed.

## SQL analysis
Analysis in SQL Server covered overall performance, payers, denial reasons, specialties, procedures, providers, authorization status, recovery status, outstanding balances and monthly trend. Power BI figures were reconciled against the SQL results.

## Dashboard
**[View the full four-page dashboard (PDF)](dashboard/MedCore_RCM_Dashboard.pdf)**

| Page | Purpose |
|---|---|
| 1. Executive Summary | KPIs, monthly denial rate, unpaid share of denied vs. other claims, payer denial rates |
| 2. Denial Root Causes | Denial count vs. value by reason, specialty and procedure |
| 3. Authorization & Recovery | Authorization status, recovery status, unpaid share by payer and provider |
| 4. Drill-down Matrix | Payer x reason, specialty x reason, reason x authorization status |

## Key results
- 50,000 claims worth ₹770.89M
- ₹643.09M paid and ₹127.81M outstanding
- 4,042 denied claims, an overall denial rate of 8.08%

## Key findings
These are observed patterns in the dataset, not proven causes.

1. **Denied claims carry a disproportionate unpaid share.** They are 8.08% of claims, but 58.70% of their value is unpaid, compared with 11.58% for non-denied claims.
2. **Frequency and money point to different priorities.** Documentation Missing is the most frequent reason (849 claims), but Missing Authorization has the largest denied value (₹21.85M) and outstanding amount (₹12.71M).
3. **Unpaid share is similar across reasons.** It ranges from 52.79% to 62.00% (highest for Medical Necessity), so differences between reasons are small.
4. **PrimeCare has the highest denial rate (10.32%) and MediSure the lowest (6.46%).** Claim and procedure mix were not adjusted, so this shows where to investigate, not that a payer is the cause.
5. **High-value procedures drive exposure.** Knee Replacement has ₹27.99M of denied value (115 denials, about ₹243K each).
6. **The monthly denial rate moves between 7.45% and 8.84%.** One year of data cannot show a trend or seasonality.
7. **Authorization status does not explain Missing Authorization denials on its own.** 417 of the 566 sit on claims whose authorization status is Approved.

## Recommendations
These are proposed actions. None were implemented or tested.

1. Rank denied claims by outstanding amount for follow-up, adding claim age and appeal deadlines if that data becomes available.
2. Review Missing Authorization denials at claim level, starting with the 417 that have an approved authorization on record.
3. Monitor payer, denial reason, specialty and procedure together rather than payer-level rates alone.
4. Add pre-submission checks (authorization, eligibility, coding, documentation) for high-value procedures such as Knee Replacement and Cardiac Catheterization.
5. Track count-based and value-based KPIs together: denial rate, denied value, outstanding amount and outstanding rate.
6. Review denial metrics monthly and investigate unusual changes with more granular data.

## Limitations
- Synthetic data cannot establish healthcare industry benchmarks.
- One year of service dates, so no seasonality or long-term trend.
- Outstanding amount is not permanent loss. Denied claim value is the original claim amount, not confirmed loss.
- Observed relationships are not causes. Payer comparisons are not adjusted for claim, specialty or procedure mix.
- Denial reasons in the data do not appear to depend on authorization status, so reason-level findings are descriptive only.
- No appeal outcomes, claim aging or payer contract rules were modeled, so recovery probability cannot be estimated.
- No intervention was implemented or measured. No savings or recoveries are claimed.

## Repository structure
```
data/raw        original CSV files (unchanged)
data/clean      cleaned CSV files used by SQL Server and Power BI
notebooks/      profiling, cleaning and validation (Jupyter Notebook)
sql/            schema, load and analysis scripts
dashboard/      Power BI dashboard exported as PDF
```

## How to reproduce
1. Run the notebook in `notebooks/` to profile and clean the files in `data/raw`, and confirm the output matches `data/clean`.
2. In SQL Server, create a database named `MedCore_RCM`, then run `sql/01_create_schema.sql`.
3. Edit the file paths in `sql/02_load_data.sql` to match your machine, then run it.
4. Run `sql/03_analysis_queries.sql` and `sql/04_validation_checks.sql`.
5. Review the dashboard in `dashboard/MedCore_RCM_Dashboard.pdf`.

## Author
Madhumitha Mathivanan · [LinkedIn profile link] · [email address]
