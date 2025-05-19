WITH latest_transactions AS (
    SELECT 
        s.id AS plan_id,
        s.owner_id,
        'savings' AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    GROUP BY s.id, s.owner_id

    UNION ALL

    SELECT 
        p.id AS plan_id,
        p.owner_id,
        'investment' AS type,
        MAX(p.start_date) AS last_transaction_date
    FROM plans_plan p
    GROUP BY p.id, p.owner_id
),

accounts_with_inactivity AS (
    SELECT 
        lt.plan_id,
        lt.owner_id,
        lt.type,
        lt.last_transaction_date,
        DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
    FROM latest_transactions lt
)

SELECT *
FROM accounts_with_inactivity
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;