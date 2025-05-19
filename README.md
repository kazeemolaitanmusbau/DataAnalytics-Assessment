# DataAnalytics-Assessment



##  SQL Assessment for Data Analyst Role 

This repository contains my submission for the SQL assessment given as part of the Data Analyst job application. The assessment focuses on evaluating SQL proficiency in querying, analyzing, and drawing insights from relational data.

The tasks demonstrate the ability to:

* Write clean and efficient SQL queries
* Perform data cleaning and transformation
* Extract actionable insights from raw data
* Apply analytical thinking to real-world datasets

All queries and explanations are included, with a focus on clarity, performance, and relevance to business decision-making.




#### Assessment-Q1 Explanation:





#### Objective

This query generates a ranked list of users based on their **total deposits**, combining investments and savings. It joins user details with aggregated financial data and sorts results in descending order of total deposit.



##  What the Query Does

* **CTEs**:

  * `investment_cte`: Sums investment amounts per user.
  * `savings_cte`: Sums savings amounts per user, filtered by valid transaction statuses.

* **Joins**:

  * Combines the aggregated data with user info using `INNER JOIN`, including only users who have both savings and investments.

* **Final Output**:

  * Returns user ID, full name, investment, savings, and total deposit.
  * Uses `COALESCE` to handle potential `NULL` values.
  * Orders results by `total_deposit DESC`.

---

## Why This Approach

* CTEs separate aggregation logic for readability.
* Pre-aggregating reduces data volume before joining.
* Filters savings to include only successful transactions.
* Handles missing values gracefully using `COALESCE`.

-

## Suggested Improvements

* Add indexes on `owner_id` and `id` for performance.
* Consider pagination (`LIMIT`, `OFFSET`) for large datasets.

-------------------------------------------------------------------------------------------------------------------------------------






#### Assessment-Q2 Explanation:




---



###  Objective

This query analyzes **user savings activity** by calculating their **average monthly transaction count** and classifying them into frequency categories: **High**, **Medium**, or **Low**.



##  What the Query Does

* **CTE 1 - `monthly_transactions`**:
  Groups savings transactions by user and month, counting how many transactions each user made per month.

* **CTE 2 - `avg_transactions_per_user`**:
  Calculates each user’s **average number of transactions per month** based on the monthly counts.

* **Final Output**:

  * Joins with the `users_customuser` table to include all users.
  * Uses `COALESCE` to handle users with no transactions (defaults to 0).
  * Classifies users into:

    * **High Frequency**: ≥ 10 transactions/month
    * **Medium Frequency**: 3–9 transactions/month
    * **Low Frequency**: < 3 transactions/month

---

##  Why This Approach

* CTEs break down the logic into clear, manageable steps.
* Uses averages over months rather than raw totals, giving a fairer view of user behavior.

---

##  Possible Improvements

* use filter if only recent data is relevant .
* **Ensure indexing** on `owner_id` and `transaction_date` for better performance.

---





#### Assessment-Q3 Explanation:



##  Objective

This query identifies **savings and investment accounts** that have been **inactive for over 1 year (365 days)** by checking the last transaction date for each plan.

---

##  What the Query Does

* **CTE 1 - `latest_transactions`**:

  * Retrieves the **latest transaction date** for:

    * **Savings accounts** (`transaction_date` from `savings_savingsaccount`)
    * **Investment plans** (`start_date` from `plans_plan`)
  * Uses `UNION ALL` to combine both types into one unified dataset.

* **CTE 2 - `accounts_with_inactivity`**:

  * Calculates the number of **days since the last transaction** using `DATEDIFF`.

* **Final Output**:

  * Filters accounts with **inactivity over 365 days**.
  * Orders them by `inactivity_days` in descending order to show the longest-inactive accounts first.

---

##  Why This Approach

* Merges savings and investments in a single query, making reporting easier and more consistent.
* Uses straightforward grouping and filtering logic that works efficiently even with large datasets.
* **Easy to Extend**: Additional transaction types or conditions can be added with minimal changes.

---

##  Suggested Improvements

* **Date Indexing**: Ensure `transaction_date` and `start_date` fields are indexed for faster execution.

---





#### Assessment-Q4 Explanation:



##  Objective

This query estimates the **Customer Lifetime Value (CLV)** of users based on their savings transaction history, account age (tenure), and a simple profit model. The output ranks customers by estimated CLV in descending order.

---

## What the Query Does

### 1. **`transaction_summary` CTE**

* Joins users with their savings transactions.
* Calculates:

  * Account **tenure** in months.
  * **Total number of transactions**.
  * **Total inflow value** (in kobo), using `confirmed_amount`.

### 2. **`clv_calculation` CTE**

* Converts inflow from **kobo to naira** (`/100.0`).
* Assumes **0.1% profit per naira** (`* 0.001`).
* Calculates the **average profit per transaction**.

### 3. **`final_clv` CTE**

* Estimates CLV using this formula:

  $$
  \text{CLV} = \left(\frac{\text{Transactions}}{\text{Tenure in months}}\right) \times 12 \times \text{Avg Profit per Transaction}
  $$

  * This approximates **annualized value** based on transaction rate and profit per transaction.

### 4. **Final Output**

* Returns user ID, name, tenure, total transactions, and **rounded estimated CLV**.
* Sorts results by `estimated_clv` in **descending** order.

---

##  Why This Approach


* **Scalable**: Efficient aggregation via CTEs handles large datasets cleanly.


---

##  Suggestions for Improvement

* Optimize performance by indexing `owner_id`, `confirmed_amount`, and `date_joined`.

---

