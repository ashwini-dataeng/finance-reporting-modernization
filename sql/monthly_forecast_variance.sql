WITH ranked_forecasts AS (
    SELECT 
        business_unit,
        forecast_month,
        forecast_version,
        forecast_revenue,
        actual_revenue

        TRY_CONVERT(date, LEFT(forecast_version,
            CHARINDEX(' ', forecast_version + ' ') - 1)) AS version_date,

        ROW_NUMBER() OVER (
            PARTITION BY business_unit, forecast_month
            ORDER BY TRY_CONVERT(date, LEFT(forecast_version,
                CHARINDEX(' ', forecast_version + ' ') - 1)) DESC, 
                forecast_month DESC
        ) as rn
        FROM monthly_revenue_forecast
        WHERE forecast_month BETWEEN '2024-01-01' AND '2024-12-01'
)

SELECT 
    business_unit,
    forecast_month,
    forecast_revenue AS latest_forecast,
    actual_revenue,
    ISNULL(actual_revenue, forecast_revenue) - forecast_revenue AS variance_abs,
    ROUND(
        CASE
            WHEN forecast_revenue = 0 THEN 0.00
            ELSE 100.0 * (ISNULL(actual_revenue, forecast_revenue) - forecast_revenue)
            / forecast_revenue
        END,
    2) as variance_pct
    FROM ranked_forecasts
    WHERE rn = 1
    ORDER BY business_unit, forecast_month
