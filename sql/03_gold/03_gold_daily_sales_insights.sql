-- Calculate day-over-day changes in key business metrics.
-- Grain: one row per purchase date.

CREATE OR REPLACE TABLE
  `proud-lamp-305020.ga4_ai_analytics.gold_daily_sales_insights` AS

WITH daily_metrics AS (
  SELECT
    purchase_date,
    orders,
    revenue,
    aov,
    units_sold,
    unique_customers,
    LAG(orders) OVER (ORDER BY purchase_date) AS previous_day_orders,
    LAG(revenue) OVER (ORDER BY purchase_date) AS previous_day_revenue,
    LAG(aov) OVER (ORDER BY purchase_date) AS previous_day_aov,
    LAG(units_sold) OVER (ORDER BY purchase_date) AS previous_day_units_sold,
    LAG(unique_customers) OVER (ORDER BY purchase_date) AS previous_day_customers
  FROM
    `proud-lamp-305020.ga4_ai_analytics.gold_daily_sales`
)

SELECT
  purchase_date,
  orders,
  previous_day_orders,
  SAFE_DIVIDE(orders - previous_day_orders,previous_day_orders) * 100 AS orders_change_pct,
  revenue,
  previous_day_revenue,
  SAFE_DIVIDE(revenue - previous_day_revenue,previous_day_revenue) * 100 AS revenue_change_pct,
  aov,
  previous_day_aov,
  SAFE_DIVIDE(aov - previous_day_aov,previous_day_aov) * 100 AS aov_change_pct,
  units_sold,
  previous_day_units_sold,
  SAFE_DIVIDE(units_sold - previous_day_units_sold,previous_day_units_sold) * 100 AS units_change_pct,
  unique_customers,
  previous_day_customers,
  SAFE_DIVIDE(unique_customers - previous_day_customers,previous_day_customers) * 100 AS customers_change_pct,
  CASE
    WHEN revenue IS NULL THEN 'missing_revenue'
    WHEN orders IS NULL OR orders = 0 THEN 'no_orders'
    WHEN orders < 10 THEN 'low_order_volume'
    ELSE 'normal'
  END AS data_quality_flag
FROM
  daily_metrics
ORDER BY
  purchase_date;