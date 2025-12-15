SELECT
    campaign_name,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN channel = 'Email' THEN customer_id END) AS email_customers,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN response = 'Clicked' THEN customer_id END) / 
        COUNT(DISTINCT customer_id), 2) AS clicked_rate,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN response = 'Purchased' THEN customer_id END) / 
        COUNT(DISTINCT customer_id), 2) AS purchase_rate,
    SUM(CASE WHEN response = 'Purchased' THEN purchase_amount ELSE 0 END) AS total_revenue,
    COALESCE(ROUND(AVG(CASE WHEN response = 'Purchased' THEN purchase_amount END), 2), 0.00) 
        AS average_purchase_amount
    FROM marketing_campaigns
    WHERE end_date <= '2025-12-31'
    GROUP BY campaign_name,
    ORDER BY campaign_name

