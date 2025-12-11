WITH ordered AS (
    SELECT
        customer_id,
        order_date,
        product_category,
        revenue,
        is_returned,
        order_id,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS order_sequence,

        SUM ( CASE WHEN is_returned = 0 THEN revenue ELSE 0)
        OVER (PARTITION BY customer_id) AS total_revenue_kept

    FROM customer_orders
)

SELECT 
    customer_id,
    MAX(CASE WHEN order_sequence = 1 THEN order_date END) AS first_order_date,
    MAX(CASE WHEN order_sequence = 1 THEN product_category END) AS first_category,
    MAX(CASE WHEN order_sequence = 2 THEN product_category END) AS second_category,

    DATEDIFF(day,
        MAX(CASE WHEN order_sequence = 1 THEN order_date END),
        MAX(CASE WHEN order_sequence = 2 THEN order_date END)
        ) AS days_between_first_two_orders,
    MAX(total_revenue_kept)

    FROM ordered
    WHERE order_sequence <= 2 or order_sequence > 0
    GROUP BY customer_id
    HAVING MAX(total_revenue_kept) > 0
    ORDER BY customer_id
