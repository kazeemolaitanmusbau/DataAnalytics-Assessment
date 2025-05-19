WITH monthly_transactions AS (
    SELECT 
        s.owner_id,
        monthname(s.transaction_date) AS month,
        COUNT(*) AS monthly_txn_count
    FROM savings_savingsaccount s
    GROUP BY s.owner_id,  monthname(s.transaction_date)
),

avg_transactions_per_user AS (
    SELECT 
        owner_id,
        AVG(monthly_txn_count) AS avg_txn_per_month
    FROM monthly_transactions
    GROUP BY owner_id
)

SELECT 
    u.id AS user_id,
    COALESCE(a.avg_txn_per_month, 0) AS avg_transactions_per_month,
    CASE 
        WHEN COALESCE(a.avg_txn_per_month, 0) >= 10 THEN 'High Frequency'
        WHEN COALESCE(a.avg_txn_per_month, 0) BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category
FROM users_customuser u
LEFT JOIN avg_transactions_per_user a ON u.id = a.owner_id;