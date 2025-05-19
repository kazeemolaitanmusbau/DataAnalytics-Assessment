# DataAnalytics-Assessment


#### AssessmentQ1 Explanation:

* **Common Table Expressions (CTEs)**:

  * `investment_cte`: Calculates the total investment (`SUM(amount)`) for each user from the `plans_plan` table.
  * `savings_cte`: Calculates the total savings (`SUM(amount)`) for each user from the `savings_savingsaccount` table. Only successful transactions are considered (`transaction_status IN (...)`).

* **Joins**:

  * The `users_customuser` table is joined with both the `investment_cte` and `savings_cte` on `owner_id`. This brings together user details (name) with their financial data.

* **COALESCE**:

  * `COALESCE(i.investment, 0)`: If there is no investment data for a user, it defaults to `0`.
  * `COALESCE(s.saving, 0)`: Similarly, for savings data, if absent, it defaults to `0`.

* **Result**:

  * This query provides each user's total deposits, consisting of both investments and savings. It orders the users by their total deposit in descending order.

#### Why This Is the Best Approach:

* **Efficiency**: Using CTEs allows you to break the problem into logical chunks, making the query more readable and modular.
* **Aggregation**: The use of `SUM` for investment and savings ensures that the query aggregates the data appropriately, providing a total per user.
* **Handling Nulls**: The `COALESCE` function ensures that the absence of data doesn’t break the query or result in null values, which is essential for generating accurate reports.

#### Improvements:

* **Optimization with Indexing**: If `plans_plan`, `savings_savingsaccount`, or `users_customuser` are large tables, indexing the `owner_id` column can significantly improve performance.
* **Error Handling**: Ensure that the data in the `transaction_status` column is standardized and consistent to avoid missing values during the filtering process (`IN (...)`).

 


#### AssessmentQ2 Explanation:

* **CTEs**:

  * `latest_transactions`: This CTE combines data from two sources (`savings_savingsaccount` and `plans_plan`) to determine the most recent transaction for each user by using `MAX(transaction_date)` and `MAX(start_date)`. It tags each transaction as either 'savings' or 'investment'.
  * `accounts_with_inactivity`: This CTE calculates the number of inactive days for each user since their last transaction using `DATEDIFF(CURDATE(), lt.last_transaction_date)`.

* **Result**:

  * The final query identifies accounts that have been inactive for more than 365 days and orders them by the inactivity duration.

#### Why This Is the Best Approach:

* **Centralized Transaction Logic**: Combining both savings and investment transactions into a single CTE streamlines the process of identifying inactivity.
* **Clear Categorization**: Tagging transactions as 'savings' or 'investment' helps differentiate the two types of financial activities, improving the granularity of the report.

#### Improvements:

* **Performance Tuning**: The use of `UNION ALL` can be optimized by ensuring the dataset from both tables is indexed for faster retrieval of transaction dates.
* **Edge Cases**: The query currently assumes that the presence of a transaction implies activity. It may be helpful to add logic to handle cases where users have created accounts but never made a transaction.




#### AssessmentQ3 Explanation:


* **CTEs**:

  * `monthly_transactions`: This CTE counts the number of transactions per user, grouped by month.
  * `avg_transactions_per_user`: This CTE calculates the average number of transactions per month for each user.

* **Result**:

  * The query calculates a frequency category for each user based on their average monthly transaction count. It categorizes them into 'High Frequency', 'Medium Frequency', or 'Low Frequency'.

#### Why This Is the Best Approach:

* **Granular Analysis**: This approach provides insights into user behavior by categorizing users based on transaction frequency.
* **Use of `COALESCE`**: It ensures that even users with no transactions are assigned a frequency category (defaults to `0`).

#### Improvements:

* **Performance**: The `COUNT(*)` function may become slow if the `savings_savingsaccount` table is very large. Indexing on `transaction_date` and `owner_id` can improve performance.
* **Additional Categories**: It could be useful to add more granular frequency categories or define the categories dynamically based on percentiles or user activity trends.














