WITH transaction_summary AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        SUM(CASE 
            WHEN s.confirmed_amount IS NOT NULL THEN s.confirmed_amount
            ELSE 0
        END) AS total_inflow_value_kobo
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY u.id, u.first_name, u.last_name, u.date_joined
),
clv_calculation AS (
    SELECT 
        customer_id,
        name,
        tenure_months,
        total_transactions,
       -- 
        CASE 
            WHEN total_transactions > 0 THEN 
                ((total_inflow_value_kobo / 100.0) * 0.001) / total_transactions
            ELSE 0
        END AS avg_profit_per_transaction
    FROM transaction_summary
),
final_clv AS (
    SELECT 
        customer_id,
        name,
        tenure_months,
        total_transactions,
        ROUND(
            CASE 
                WHEN tenure_months > 0 THEN 
                    (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
                ELSE 0
            END
        , 2) AS estimated_clv
    FROM clv_calculation
)

SELECT *
FROM final_clv
ORDER BY estimated_clv DESC;
