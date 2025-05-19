WITH investment_cte AS (
    SELECT owner_id, SUM(amount) AS investment
    FROM plans_plan
    GROUP BY owner_id
),
savings_cte AS (
    SELECT owner_id, SUM(amount) AS saving
    FROM adashi_staging.savings_savingsaccount
    WHERE transaction_status IN ('success', 'successful', 'monnify_success', 'reward')
    GROUP BY owner_id
)
SELECT 
    v.id AS owner_id,
    CONCAT(v.first_name, ' ', v.last_name) AS namess,
    COALESCE(i.investment, 0) AS investment,
    COALESCE(s.saving, 0) AS saving,
    ROUND((COALESCE(i.investment, 0) + COALESCE(s.saving, 0)), 2) AS total_deposit
FROM users_customuser v
INNER JOIN investment_cte i ON v.id = i.owner_id
INNER JOIN savings_cte s ON v.id = s.owner_id
ORDER BY total_deposit DESC;