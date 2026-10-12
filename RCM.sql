USE MedCore_RCM;
GO

/* ============================================================
   MEDCORE RCM - CLAIMS DENIAL ANALYSIS
   Database: MedCore_RCM
   Purpose: SQL analysis for healthcare claims denial project
   ============================================================ */


/* ============================================================
   01. OVERALL CLAIMS KPI
   ============================================================ */

SELECT
    COUNT(*) AS Total_Claims,

    SUM(
        CASE
            WHEN C.Denial_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Denied_Claims,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value,

    CAST(SUM(P.Paid_Amount) AS DECIMAL(18,2))
        AS Total_Paid_Amount,

    CAST(SUM(P.Outstanding_Amount) AS DECIMAL(18,2))
        AS Total_Outstanding_Amount

FROM Claims C
INNER JOIN Payments P
    ON C.Claim_ID = P.Claim_ID;


/* ============================================================
   02. PAYER-LEVEL DENIAL ANALYSIS
   ============================================================ */

SELECT
    P.Payer_ID,
    P.Payer_Name,
    P.Payer_Type,

    COUNT(C.Claim_ID) AS Total_Claims,

    SUM(
        CASE
            WHEN C.Denial_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Denied_Claims,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(C.Claim_ID)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value

FROM Claims C
INNER JOIN Payers P
    ON C.Payer_ID = P.Payer_ID

GROUP BY
    P.Payer_ID,
    P.Payer_Name,
    P.Payer_Type

ORDER BY
    Denial_Rate_Percent DESC;


/* ============================================================
   03. DENIAL REASON ANALYSIS
   ============================================================ */

SELECT
    C.Denial_Reason,

    COUNT(*) AS Denied_Claims,

    CAST(
        100.0 * COUNT(*) /
        NULLIF(
            (
                SELECT COUNT(*)
                FROM Claims
                WHERE Denial_Flag = 1
            ),
            0
        )
        AS DECIMAL(5,2)
    ) AS Percentage_of_Denials,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Denied_Claim_Value

FROM Claims C

WHERE C.Denial_Flag = 1

GROUP BY
    C.Denial_Reason

ORDER BY
    Denied_Claims DESC;


/* ============================================================
   04. PAYER + DENIAL REASON ANALYSIS
   ============================================================ */

SELECT
    P.Payer_ID,
    P.Payer_Name,
    C.Denial_Reason,

    COUNT(*) AS Denied_Claims,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Denied_Claim_Value

FROM Claims C
INNER JOIN Payers P
    ON C.Payer_ID = P.Payer_ID

WHERE C.Denial_Flag = 1

GROUP BY
    P.Payer_ID,
    P.Payer_Name,
    C.Denial_Reason

ORDER BY
    Denied_Claim_Value DESC;


/* ============================================================
   05. SPECIALTY-LEVEL DENIAL ANALYSIS
   ============================================================ */

SELECT
    C.Specialty,

    COUNT(*) AS Total_Claims,

    SUM(
        CASE
            WHEN C.Denial_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Denied_Claims,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value,

    CAST(
        SUM(
            CASE
                WHEN C.Denial_Flag = 1
                THEN C.Claim_Amount
                ELSE 0
            END
        )
        AS DECIMAL(18,2)
    ) AS Denied_Claim_Value

FROM Claims C

GROUP BY
    C.Specialty

ORDER BY
    Denial_Rate_Percent DESC;


/* ============================================================
   06. PROVIDER-LEVEL DENIAL ANALYSIS
   ============================================================ */

SELECT
    P.Provider_ID,
    P.Provider_Name,
    P.Location,
    P.Provider_Type,

    COUNT(C.Claim_ID) AS Total_Claims,

    SUM(
        CASE
            WHEN C.Denial_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Denied_Claims,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(C.Claim_ID)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value,

    CAST(
        SUM(
            CASE
                WHEN C.Denial_Flag = 1
                THEN C.Claim_Amount
                ELSE 0
            END
        )
        AS DECIMAL(18,2)
    ) AS Denied_Claim_Value

FROM Claims C
INNER JOIN Providers P
    ON C.Provider_ID = P.Provider_ID

GROUP BY
    P.Provider_ID,
    P.Provider_Name,
    P.Location,
    P.Provider_Type

ORDER BY
    Denial_Rate_Percent DESC;


/* ============================================================
   07. PROVIDER + DENIAL REASON
   ============================================================ */

SELECT
    P.Provider_ID,
    P.Provider_Name,
    C.Denial_Reason,

    COUNT(*) AS Denied_Claims,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Denied_Claim_Value

FROM Claims C
INNER JOIN Providers P
    ON C.Provider_ID = P.Provider_ID

WHERE C.Denial_Flag = 1

GROUP BY
    P.Provider_ID,
    P.Provider_Name,
    C.Denial_Reason

ORDER BY
    Denied_Claim_Value DESC;


/* ============================================================
   08. PAYER-LEVEL OUTSTANDING ANALYSIS
   ============================================================ */

SELECT
    P.Payer_ID,
    P.Payer_Name,
    P.Payer_Type,

    COUNT(C.Claim_ID) AS Total_Claims,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value,

    CAST(SUM(PY.Paid_Amount) AS DECIMAL(18,2))
        AS Total_Paid_Amount,

    CAST(SUM(PY.Outstanding_Amount) AS DECIMAL(18,2))
        AS Total_Outstanding_Amount,

    CAST(
        100.0 *
        SUM(PY.Outstanding_Amount)
        / NULLIF(SUM(C.Claim_Amount), 0)
        AS DECIMAL(5,2)
    ) AS Outstanding_Rate_Percent

FROM Claims C
INNER JOIN Payers P
    ON C.Payer_ID = P.Payer_ID

INNER JOIN Payments PY
    ON C.Claim_ID = PY.Claim_ID

GROUP BY
    P.Payer_ID,
    P.Payer_Name,
    P.Payer_Type

ORDER BY
    Total_Outstanding_Amount DESC;


/* ============================================================
   09. AUTHORIZATION STATUS DISTRIBUTION
   ============================================================ */

SELECT
    A.Authorization_Status,

    COUNT(*) AS Claim_Count,

    CAST(
        100.0 * COUNT(*)
        / CAST(SUM(COUNT(*)) OVER() AS DECIMAL(18,2))
        AS DECIMAL(5,2)
    ) AS Percentage_of_Claims

FROM Claim_Authorization A

GROUP BY
    A.Authorization_Status

ORDER BY
    Claim_Count DESC;


/* ============================================================
   10. AUTHORIZATION STATUS - FINANCIAL IMPACT
   ============================================================ */

SELECT
    A.Authorization_Status,

    COUNT(C.Claim_ID) AS Claim_Count,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value,

    CAST(SUM(P.Outstanding_Amount) AS DECIMAL(18,2))
        AS Total_Outstanding_Amount

FROM Claims C
INNER JOIN Claim_Authorization A
    ON C.Claim_ID = A.Claim_ID

INNER JOIN Payments P
    ON C.Claim_ID = P.Claim_ID

GROUP BY
    A.Authorization_Status

ORDER BY
    Total_Outstanding_Amount DESC;


/* ============================================================
   11. AUTHORIZATION STATUS + DENIAL ANALYSIS
   ============================================================ */

SELECT
    A.Authorization_Status,

    COUNT(*) AS Claim_Count,

    SUM(
        CASE
            WHEN C.Denial_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Denied_Claims,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value,

    CAST(SUM(P.Outstanding_Amount) AS DECIMAL(18,2))
        AS Outstanding_Amount

FROM Claims C
INNER JOIN Claim_Authorization A
    ON C.Claim_ID = A.Claim_ID

INNER JOIN Payments P
    ON C.Claim_ID = P.Claim_ID

GROUP BY
    A.Authorization_Status

ORDER BY
    Denial_Rate_Percent DESC;


/* ============================================================
   12. PROCEDURE-LEVEL DENIAL ANALYSIS
   ============================================================ */

SELECT
    C.Procedure_Code,
    C.Procedure_Name,
    C.Specialty,

    COUNT(*) AS Total_Claims,

    SUM(
        CASE
            WHEN C.Denial_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Denied_Claims,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value,

    CAST(
        SUM(
            CASE
                WHEN C.Denial_Flag = 1
                THEN C.Claim_Amount
                ELSE 0
            END
        )
        AS DECIMAL(18,2)
    ) AS Denied_Claim_Value

FROM Claims C

GROUP BY
    C.Procedure_Code,
    C.Procedure_Name,
    C.Specialty

ORDER BY
    Denial_Rate_Percent DESC;


/* ============================================================
   13. PROCEDURE-LEVEL DENIED VALUE ANALYSIS
   ============================================================ */

SELECT
    C.Procedure_Code,
    C.Procedure_Name,
    C.Specialty,

    COUNT(*) AS Denied_Claims,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Denied_Claim_Value,

    CAST(AVG(C.Claim_Amount) AS DECIMAL(18,2))
        AS Average_Denied_Claim_Amount

FROM Claims C

WHERE C.Denial_Flag = 1

GROUP BY
    C.Procedure_Code,
    C.Procedure_Name,
    C.Specialty

ORDER BY
    Denied_Claim_Value DESC;


/* ============================================================
   14. PROCEDURE + AUTHORIZATION STATUS
   ============================================================ */

SELECT
    C.Procedure_Name,
    A.Authorization_Status,

    COUNT(*) AS Claim_Count,

    SUM(
        CASE
            WHEN C.Denial_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Denied_Claims,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent

FROM Claims C
INNER JOIN Claim_Authorization A
    ON C.Claim_ID = A.Claim_ID

GROUP BY
    C.Procedure_Name,
    A.Authorization_Status

ORDER BY
    Denial_Rate_Percent DESC;


/* ============================================================
   15. RECOVERY STATUS ANALYSIS
   ============================================================ */

SELECT
    PY.Recovery_Status,

    COUNT(*) AS Claim_Count,

    CAST(SUM(PY.Paid_Amount) AS DECIMAL(18,2))
        AS Total_Paid_Amount,

    CAST(SUM(PY.Outstanding_Amount) AS DECIMAL(18,2))
        AS Total_Outstanding_Amount,

    CAST(
        100.0 *
        SUM(PY.Outstanding_Amount)
        / NULLIF(
            SUM(PY.Paid_Amount + PY.Outstanding_Amount),
            0
        )
        AS DECIMAL(5,2)
    ) AS Outstanding_Rate_Percent

FROM Payments PY

GROUP BY
    PY.Recovery_Status

ORDER BY
    Total_Outstanding_Amount DESC;


/* ============================================================
   16. PROVIDER-LEVEL OUTSTANDING ANALYSIS
   ============================================================ */

SELECT
    P.Provider_ID,
    P.Provider_Name,

    COUNT(C.Claim_ID) AS Total_Claims,

    CAST(SUM(PY.Paid_Amount) AS DECIMAL(18,2))
        AS Total_Paid_Amount,

    CAST(SUM(PY.Outstanding_Amount) AS DECIMAL(18,2))
        AS Total_Outstanding_Amount,

    CAST(
        100.0 *
        SUM(PY.Outstanding_Amount)
        / NULLIF(SUM(C.Claim_Amount), 0)
        AS DECIMAL(5,2)
    ) AS Outstanding_Rate_Percent

FROM Claims C
INNER JOIN Providers P
    ON C.Provider_ID = P.Provider_ID

INNER JOIN Payments PY
    ON C.Claim_ID = PY.Claim_ID

GROUP BY
    P.Provider_ID,
    P.Provider_Name

ORDER BY
    Total_Outstanding_Amount DESC;


/* ============================================================
   17. DENIED VS NOT-DENIED FINANCIAL COMPARISON
   ============================================================ */

SELECT
    CASE
        WHEN C.Denial_Flag = 1 THEN 'Denied'
        ELSE 'Not Denied'
    END AS Claim_Category,

    COUNT(*) AS Claim_Count,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value,

    CAST(SUM(PY.Paid_Amount) AS DECIMAL(18,2))
        AS Total_Paid_Amount,

    CAST(SUM(PY.Outstanding_Amount) AS DECIMAL(18,2))
        AS Total_Outstanding_Amount,

    CAST(
        100.0 *
        SUM(PY.Outstanding_Amount)
        / NULLIF(SUM(C.Claim_Amount), 0)
        AS DECIMAL(5,2)
    ) AS Outstanding_Rate_Percent

FROM Claims C
INNER JOIN Payments PY
    ON C.Claim_ID = PY.Claim_ID

GROUP BY
    CASE
        WHEN C.Denial_Flag = 1 THEN 'Denied'
        ELSE 'Not Denied'
    END

ORDER BY
    Total_Outstanding_Amount DESC;


/* ============================================================
   18. DENIAL REASON - FINANCIAL IMPACT
   ============================================================ */

SELECT
    C.Denial_Reason,

    COUNT(*) AS Denied_Claims,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Denied_Claim_Value,

    CAST(SUM(PY.Outstanding_Amount) AS DECIMAL(18,2))
        AS Outstanding_Amount,

    CAST(
        100.0 *
        SUM(PY.Outstanding_Amount)
        / NULLIF(SUM(C.Claim_Amount), 0)
        AS DECIMAL(5,2)
    ) AS Outstanding_Rate_Percent

FROM Claims C
INNER JOIN Payments PY
    ON C.Claim_ID = PY.Claim_ID

WHERE C.Denial_Flag = 1

GROUP BY
    C.Denial_Reason

ORDER BY
    Outstanding_Amount DESC;


/* ============================================================
   19. PAYER - FINANCIAL IMPACT OF DENIALS/OUTSTANDING
   ============================================================ */

SELECT
    P.Payer_ID,
    P.Payer_Name,

    COUNT(*) AS Total_Claims,

    SUM(
        CASE
            WHEN C.Denial_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Denied_Claims,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value,

    CAST(SUM(PY.Outstanding_Amount) AS DECIMAL(18,2))
        AS Outstanding_Amount,

    CAST(
        100.0 *
        SUM(PY.Outstanding_Amount)
        / NULLIF(SUM(C.Claim_Amount), 0)
        AS DECIMAL(5,2)
    ) AS Outstanding_Rate_Percent

FROM Claims C
INNER JOIN Payers P
    ON C.Payer_ID = P.Payer_ID

INNER JOIN Payments PY
    ON C.Claim_ID = PY.Claim_ID

GROUP BY
    P.Payer_ID,
    P.Payer_Name

ORDER BY
    Outstanding_Amount DESC;


/* ============================================================
   20. MONTHLY DENIAL TREND
   ============================================================ */

WITH Monthly_Claims AS
(
    SELECT
        YEAR(Service_Date) AS Service_Year,
        MONTH(Service_Date) AS Service_Month,

        COUNT(*) AS Total_Claims,

        SUM(
            CASE
                WHEN Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) AS Denied_Claims,

        CAST(
            100.0 *
            SUM(
                CASE
                    WHEN Denial_Flag = 1 THEN 1
                    ELSE 0
                END
            ) / NULLIF(COUNT(*), 0)
            AS DECIMAL(5,2)
        ) AS Denial_Rate_Percent,

        CAST(SUM(Claim_Amount) AS DECIMAL(18,2))
            AS Total_Claim_Value,

        CAST(
            SUM(
                CASE
                    WHEN Denial_Flag = 1
                    THEN Claim_Amount
                    ELSE 0
                END
            )
            AS DECIMAL(18,2)
        ) AS Denied_Claim_Value

    FROM Claims

    GROUP BY
        YEAR(Service_Date),
        MONTH(Service_Date)
)

SELECT
    Service_Year,
    Service_Month,
    Total_Claims,
    Denied_Claims,
    Denial_Rate_Percent,
    Total_Claim_Value,
    Denied_Claim_Value,

    RANK() OVER (
        ORDER BY Denial_Rate_Percent DESC
    ) AS Denial_Rate_Rank

FROM Monthly_Claims

ORDER BY
    Service_Year,
    Service_Month;


/* ============================================================
   21. PROVIDER DENIED-VALUE RANKING
   ============================================================ */

WITH Provider_Denials AS
(
    SELECT
        P.Provider_ID,
        P.Provider_Name,
        P.Location,
        P.Provider_Type,

        COUNT(C.Claim_ID) AS Total_Claims,

        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) AS Denied_Claims,

        CAST(
            SUM(
                CASE
                    WHEN C.Denial_Flag = 1
                    THEN C.Claim_Amount
                    ELSE 0
                END
            )
            AS DECIMAL(18,2)
        ) AS Denied_Claim_Value

    FROM Claims C
    INNER JOIN Providers P
        ON C.Provider_ID = P.Provider_ID

    GROUP BY
        P.Provider_ID,
        P.Provider_Name,
        P.Location,
        P.Provider_Type
)

SELECT
    Provider_ID,
    Provider_Name,
    Location,
    Provider_Type,
    Total_Claims,
    Denied_Claims,
    Denied_Claim_Value,

    DENSE_RANK() OVER (
        ORDER BY Denied_Claim_Value DESC
    ) AS Denied_Value_Rank

FROM Provider_Denials

ORDER BY
    Denied_Value_Rank;


/* ============================================================
   22. PROCEDURE DENIED-VALUE RANKING
   ============================================================ */

WITH Procedure_Denials AS
(
    SELECT
        C.Procedure_Code,
        C.Procedure_Name,
        C.Specialty,

        COUNT(C.Claim_ID) AS Total_Claims,

        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) AS Denied_Claims,

        CAST(
            SUM(
                CASE
                    WHEN C.Denial_Flag = 1
                    THEN C.Claim_Amount
                    ELSE 0
                END
            )
            AS DECIMAL(18,2)
        ) AS Denied_Claim_Value

    FROM Claims C

    GROUP BY
        C.Procedure_Code,
        C.Procedure_Name,
        C.Specialty
)

SELECT
    Procedure_Code,
    Procedure_Name,
    Specialty,
    Total_Claims,
    Denied_Claims,
    Denied_Claim_Value,

    DENSE_RANK() OVER (
        ORDER BY Denied_Claim_Value DESC
    ) AS Denied_Value_Rank

FROM Procedure_Denials

ORDER BY
    Denied_Value_Rank;


/* ============================================================
   23. LOCATION-LEVEL DENIAL ANALYSIS
   ============================================================ */

SELECT
    P.Location,

    COUNT(C.Claim_ID) AS Total_Claims,

    SUM(
        CASE
            WHEN C.Denial_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Denied_Claims,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(C.Claim_ID)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value,

    CAST(
        SUM(
            CASE
                WHEN C.Denial_Flag = 1
                THEN C.Claim_Amount
                ELSE 0
            END
        )
        AS DECIMAL(18,2)
    ) AS Denied_Claim_Value

FROM Claims C
INNER JOIN Providers P
    ON C.Provider_ID = P.Provider_ID

GROUP BY
    P.Location

ORDER BY
    Denial_Rate_Percent DESC;


/* ============================================================
   24. AUTHORIZATION RISK - DENIED CLAIMS
   ============================================================ */

SELECT
    A.Authorization_Status,

    C.Denial_Reason,

    COUNT(*) AS Denied_Claims,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Denied_Claim_Value,

    CAST(SUM(P.Outstanding_Amount) AS DECIMAL(18,2))
        AS Outstanding_Amount

FROM Claims C
INNER JOIN Claim_Authorization A
    ON C.Claim_ID = A.Claim_ID

INNER JOIN Payments P
    ON C.Claim_ID = P.Claim_ID

WHERE
    C.Denial_Flag = 1

GROUP BY
    A.Authorization_Status,
    C.Denial_Reason

ORDER BY
    Denied_Claim_Value DESC;


/* ============================================================
   25. MISSING-AUTHORIZATION RISK
   ============================================================ */

SELECT
    C.Procedure_Name,
    A.Authorization_Status,

    COUNT(*) AS Claim_Count,

    SUM(
        CASE
            WHEN C.Denial_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Denied_Claims,

    CAST(
        SUM(
            CASE
                WHEN C.Denial_Flag = 1
                THEN C.Claim_Amount
                ELSE 0
            END
        )
        AS DECIMAL(18,2)
    ) AS Denied_Claim_Value

FROM Claims C
INNER JOIN Claim_Authorization A
    ON C.Claim_ID = A.Claim_ID

WHERE
    A.Authorization_Status IN
    (
        'Not Requested',
        'Pending',
        'Denied'
    )

GROUP BY
    C.Procedure_Name,
    A.Authorization_Status

ORDER BY
    Denied_Claim_Value DESC;


/* ============================================================
   26. FINAL FINANCIAL RECONCILIATION
   ============================================================ */

SELECT
    COUNT(*) AS Total_Claims,

    CAST(SUM(C.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Value,

    CAST(SUM(P.Paid_Amount) AS DECIMAL(18,2))
        AS Total_Paid_Amount,

    CAST(SUM(P.Outstanding_Amount) AS DECIMAL(18,2))
        AS Total_Outstanding_Amount,

    CAST(
        SUM(C.Claim_Amount)
        - SUM(P.Paid_Amount)
        - SUM(P.Outstanding_Amount)
        AS DECIMAL(18,2)
    ) AS Reconciliation_Difference,

    SUM(
        CASE
            WHEN C.Denial_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS Denied_Claims,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN C.Denial_Flag = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent

FROM Claims C
INNER JOIN Payments P
    ON C.Claim_ID = P.Claim_ID;


/* ============================================================
   27. DATA QUALITY - CLAIM COUNT
   ============================================================ */

SELECT
    COUNT(*) AS Total_Claims
FROM Claims;


/* ============================================================
   28. DATA QUALITY - PAYMENT RECORD COUNT
   ============================================================ */

SELECT
    COUNT(*) AS Total_Payment_Records,
    COUNT(DISTINCT Claim_ID) AS Distinct_Payment_Claims
FROM Payments;


/* ============================================================
   29. DATA QUALITY - AUTHORIZATION RECORD COUNT
   ============================================================ */

SELECT
    COUNT(*) AS Total_Authorization_Records,
    COUNT(DISTINCT Claim_ID) AS Distinct_Authorization_Claims
FROM Claim_Authorization;


/* ============================================================
   30. DATA QUALITY - DUPLICATE CLAIM IDs IN PAYMENTS
   ============================================================ */

SELECT
    Claim_ID,
    COUNT(*) AS Record_Count
FROM Payments
GROUP BY
    Claim_ID
HAVING COUNT(*) > 1;


/* ============================================================
   31. DATA QUALITY - DUPLICATE CLAIM IDs IN AUTHORIZATION
   ============================================================ */

SELECT
    Claim_ID,
    COUNT(*) AS Record_Count
FROM Claim_Authorization
GROUP BY
    Claim_ID
HAVING COUNT(*) > 1;


/* ============================================================
   32. DATA QUALITY - NULL SERVICE DATES
   ============================================================ */

SELECT
    COUNT(*) AS Null_Service_Date_Count
FROM Claims
WHERE Service_Date IS NULL;


/* ============================================================
   33. DATA QUALITY - DENIAL FLAG DISTRIBUTION
   ============================================================ */

SELECT
    Denial_Flag,
    COUNT(*) AS Claim_Count
FROM Claims
GROUP BY
    Denial_Flag
ORDER BY
    Denial_Flag;


/* ============================================================
   34. DATA QUALITY - AUTHORIZATION STATUS DISTRIBUTION
   ============================================================ */

SELECT
    Authorization_Status,
    COUNT(*) AS Claim_Count
FROM Claim_Authorization
GROUP BY
    Authorization_Status
ORDER BY
    Claim_Count DESC;


/* ============================================================
   END OF MEDCORE RCM SQL ANALYSIS
   ============================================================ */