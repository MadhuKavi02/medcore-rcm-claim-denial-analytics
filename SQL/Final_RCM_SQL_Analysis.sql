
--1.Calculate the overall denial rate
USE MedCore_RCM_Analytics;
GO

SELECT
    COUNT(*) AS Total_Claims,
    SUM(CASE WHEN Claim_Status = 'Denied' THEN 1 ELSE 0 END)
        AS Denied_Claims,
    SUM(CASE WHEN Claim_Status = 'Paid' THEN 1 ELSE 0 END)
        AS Paid_Claims,
    SUM(CASE WHEN Claim_Status = 'Pending' THEN 1 ELSE 0 END)
        AS Pending_Claims,
    CAST(
        100.0 * SUM(CASE WHEN Claim_Status = 'Denied' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent,
    CAST(SUM(Claim_Amount) AS DECIMAL(18,2))
        AS Total_Claim_Amount
FROM dbo.Claims;

--2.Calculate denial rates by reason


USE MedCore_RCM_Analytics;
GO

SELECT
    Denial_Reason,
    COUNT(*) AS Denied_Claims,
    CAST(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(5,2)
    ) AS Percentage_of_Denials,
    CAST(SUM(Claim_Amount) AS DECIMAL(18,2))
        AS Total_Denied_Claim_Amount
FROM dbo.Claims
WHERE Claim_Status = 'Denied'
GROUP BY Denial_Reason
ORDER BY Denied_Claims DESC;

--3.Compare denial rates by payer


USE MedCore_RCM_Analytics;
GO

SELECT
    p.Payer_Name,
    COUNT(*) AS Total_Claims,
    SUM(CASE
        WHEN c.Claim_Status = 'Denied' THEN 1
        ELSE 0
    END) AS Denied_Claims,
    CAST(
        100.0 * SUM(CASE
            WHEN c.Claim_Status = 'Denied' THEN 1
            ELSE 0
        END) / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent,
    CAST(
        SUM(CASE
            WHEN c.Claim_Status = 'Denied' THEN c.Claim_Amount
            ELSE 0
        END) AS DECIMAL(18,2)
    ) AS Total_Denied_Claim_Amount
FROM dbo.Claims c
INNER JOIN dbo.Payers p
    ON c.Payer_ID = p.Payer_ID
GROUP BY p.Payer_Name
ORDER BY Denial_Rate_Percent DESC;

--4.Analyze denial reasons by payer


USE MedCore_RCM_Analytics;
GO

SELECT
    p.Payer_Name,
    c.Denial_Reason,
    COUNT(*) AS Denied_Claims,
    CAST(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (
            PARTITION BY p.Payer_Name
        )
        AS DECIMAL(5,2)
    ) AS Payer_Denial_Reason_Pct,
    CAST(
        SUM(c.Claim_Amount) AS DECIMAL(18,2)
    ) AS Total_Denied_Claim_Amount
FROM dbo.Claims c
INNER JOIN dbo.Payers p
    ON c.Payer_ID = p.Payer_ID
WHERE c.Claim_Status = 'Denied'
GROUP BY
    p.Payer_Name,
    c.Denial_Reason
ORDER BY
    p.Payer_Name,
    Denied_Claims DESC;

--5.denied-claim recovery performance.

USE MedCore_RCM_Analytics;
GO

SELECT
    COUNT(*) AS Denied_Claims,
    CAST(SUM(c.Claim_Amount) AS DECIMAL(18,2))
        AS Total_Denied_Claim_Amount,
    CAST(SUM(p.Paid_Amount) AS DECIMAL(18,2))
        AS Amount_Recovered,
    CAST(SUM(p.Outstanding_Amount) AS DECIMAL(18,2))
        AS Amount_Outstanding,
    CAST(
        100.0 * SUM(p.Paid_Amount)
        / NULLIF(SUM(c.Claim_Amount), 0)
        AS DECIMAL(5,2)
    ) AS Recovery_Percentage
FROM dbo.Claims c
INNER JOIN dbo.Payments p
    ON c.Claim_ID = p.Claim_ID
WHERE c.Claim_Status = 'Denied';

--6.Denial rate by provider specialty


USE MedCore_RCM_Analytics;
GO

SELECT
    c.Specialty,
    COUNT(*) AS Total_Claims,
    SUM(CASE
        WHEN c.Claim_Status = 'Denied' THEN 1
        ELSE 0
    END) AS Denied_Claims,
    CAST(
        100.0 * SUM(CASE
            WHEN c.Claim_Status = 'Denied' THEN 1
            ELSE 0
        END) / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent,
    CAST(
        SUM(CASE
            WHEN c.Claim_Status = 'Denied'
            THEN c.Claim_Amount
            ELSE 0
        END) AS DECIMAL(18,2)
    ) AS Denied_Claim_Amount
FROM dbo.Claims c
GROUP BY c.Specialty
ORDER BY Denial_Rate_Percent DESC;

--7.Denial rate by procedure

USE MedCore_RCM_Analytics;
GO

SELECT
    c.Procedure_Code,
    c.Procedure_Name,
    COUNT(*) AS Total_Claims,
    SUM(CASE
        WHEN c.Claim_Status = 'Denied' THEN 1
        ELSE 0
    END) AS Denied_Claims,
    CAST(
        100.0 * SUM(CASE
            WHEN c.Claim_Status = 'Denied' THEN 1
            ELSE 0
        END) / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent
FROM dbo.Claims c
GROUP BY
    c.Procedure_Code,
    c.Procedure_Name
HAVING COUNT(*) >= 100
ORDER BY Denial_Rate_Percent DESC;

--8.Authorization performance


USE MedCore_RCM_Analytics;
GO

SELECT
    a.Authorization_Status,
    COUNT(*) AS Total_Claims,
    SUM(CASE
        WHEN c.Claim_Status = 'Denied' THEN 1
        ELSE 0
    END) AS Denied_Claims,
    CAST(
        100.0 * SUM(CASE
            WHEN c.Claim_Status = 'Denied' THEN 1
            ELSE 0
        END) / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS Denial_Rate_Percent
FROM dbo.Claims c
INNER JOIN dbo.[Authorization] a
    ON c.Claim_ID = a.Claim_ID
GROUP BY a.Authorization_Status
ORDER BY Denial_Rate_Percent DESC;

--9.Outstanding denied amount by denial reason


USE MedCore_RCM_Analytics;
GO

SELECT
    c.Denial_Reason,
    COUNT(*) AS Denied_Claims,
    CAST(
        SUM(p.Outstanding_Amount) AS DECIMAL(18,2)
    ) AS Outstanding_Amount,
    CAST(
        100.0 * SUM(p.Outstanding_Amount) /
        NULLIF(
            SUM(SUM(p.Outstanding_Amount)) OVER (),
            0
        )
        AS DECIMAL(5,2)
    ) AS Percentage_of_Outstanding
FROM dbo.Claims c
INNER JOIN dbo.Payments p
    ON c.Claim_ID = p.Claim_ID
WHERE c.Claim_Status = 'Denied'
GROUP BY c.Denial_Reason
ORDER BY Outstanding_Amount DESC;
/*
USE MedCore_RCM_Analytics;
GO

DECLARE @UpdatedRows INT;

BEGIN TRANSACTION;

UPDATE p
SET Recovery_Status =
    CASE
        WHEN c.Claim_Status = 'Paid'
            THEN 'Partially Collected'

        WHEN c.Claim_Status = 'Denied'
            THEN 'Partially Recovered'
    END
FROM dbo.Payments AS p
INNER JOIN dbo.Claims AS c
    ON p.Claim_ID = c.Claim_ID
WHERE
    (
        c.Claim_Status = 'Paid'
        AND p.Recovery_Status = 'Collected'
        AND p.Outstanding_Amount > 0
    )
    OR
    (
        c.Claim_Status = 'Denied'
        AND p.Recovery_Status = 'Recovered'
        AND p.Outstanding_Amount > 0
    );

SET @UpdatedRows = @@ROWCOUNT;

IF @UpdatedRows = 45626
BEGIN
    COMMIT TRANSACTION;
    SELECT
        @UpdatedRows AS Updated_Records,
        'Successfully committed' AS Update_Status;
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    SELECT
        @UpdatedRows AS Updated_Records,
        'Rolled back - unexpected record count' AS Update_Status;
END;*/
SELECT
    c.Claim_Status,
    p.Recovery_Status,
    COUNT(*) AS Claim_Count
FROM dbo.Payments AS p
INNER JOIN dbo.Claims AS c
    ON p.Claim_ID = c.Claim_ID
GROUP BY
    c.Claim_Status,
    p.Recovery_Status
ORDER BY
    c.Claim_Status,
    p.Recovery_Status;







