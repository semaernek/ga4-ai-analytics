-- Calculate day-over-day changes by product category.
-- Grain: one row per purchase date and product category.

CREATE OR REPLACE TABLE `proud-lamp-305020.ga4_ai_analytics.gold_daily_category_insights` AS

WITH category_metrics AS (
  SELECT
    purchase_date,
    item_category,
    orders,
    revenue,
    units_sold,
    aov,
    unique_customers,
    LAG(orders) OVER (PARTITION BY item_category ORDER BY purchase_date) AS previous_day_orders,
    LAG(revenue) OVER (PARTITION BY item_category ORDER BY purchase_date) AS previous_day_revenue,
    LAG(units_sold) OVER (PARTITION BY item_category ORDER BY purchase_date) AS previous_day_units_sold,
    LAG(aov) OVER (PARTITION BY item_category ORDER BY purchase_date) AS previous_day_aov
  FROM
    `proud-lamp-305020.ga4_ai_analytics.gold_daily_category_sales`
)

SELECT
  purchase_date,
  item_category,
  orders,
  previous_day_orders,
  SAFE_DIVIDE(orders - previous_day_orders, previous_day_orders) * 100 AS orders_change_pct,
  revenue,
  previous_day_revenue,
  SAFE_DIVIDE(revenue - previous_day_revenue, previous_day_revenue) * 100 AS revenue_change_pct,
  units_sold,
  previous_day_units_sold,
  SAFE_DIVIDE(units_sold - previous_day_units_sold, previous_day_units_sold) * 100 AS units_change_pct,
  aov,
  previous_day_aov,
  SAFE_DIVIDE(aov - previous_day_aov, previous_day_aov) * 100 AS aov_change_pct,
  unique_customers
FROM
  category_metrics
ORDER BY
  purchase_date,
  revenue_change_pct;