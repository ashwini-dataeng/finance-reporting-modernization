WITH calender AS (
    SELECT DATEFROMPARTS(2024, n, 1) AS month_start
    FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)) v(n)
),

transactions_summary AS (
    SELECT
        DATEFROMPARTS(YEAR(transaction_date), MONTH(transaction_date), 1) AS month_start,
        SUM(CASE WHEN amount  > 0 AND category = 'Revenue' THEN amount ELSE 0 END) AS total_revenue,
        SUM(CASE WHEN amount < 0 AND category in ('OPEX','Payroll') THEN ABS(amount) ELSE 0) AS total_opex,
        SUM(CASE WHEN amount < 0 AND category =  'CAPEX' THEN ABS(amount) ELSE 0 END) AS total capex
    FROM finance_transactions
    WHERE YEAR(transaction_date) = 2024
    GROUP BY YEAR(transaction_date), MONTH(transaction_date)
)

SELECT 
    FORMAT(c.month_start, 'yyyy-MM') AS month_year,
    COALESCE(ts.total_revenue, 0.00) AS total_revenue,
    COALESCE(ts.total_opex, 0.00) AS total_opex,
    COALESCE(ts.total_capex, 0.00) AS total_capex,
    COALESCE(ts.total_revenue,0) - COALESCE(ts.total_opex) - COALESCE(ts.total_capex) AS net_profit
FROM calender c
LEFT JOIN transactions_summary ts on c.month_start = ts.month_start
ORDER BY c.month_start
