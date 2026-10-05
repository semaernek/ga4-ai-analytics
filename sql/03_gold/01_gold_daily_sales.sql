-- Gold Layer: Daily Sales
-- Grain: 1 row per day

-- Purpose:
--   Create daily business-level sales metrics from the Silver layer.

CREATE OR REPLACE TABLE
  `proud-lamp-305020.ga4_ai_analytics.gold_daily_sales` AS

SELECT
  purchase_date,
  COUNT(DISTINCT transaction_id) AS orders,
  SUM(item_revenue) AS revenue,
  SAFE_DIVIDE(
    SUM(item_revenue),
    COUNT(DISTINCT transaction_id)
  ) AS aov,
  SUM(quantity) AS units_sold,
  COUNT(DISTINCT user_pseudo_id) AS unique_customers
FROM
  `proud-lamp-305020.ga4_ai_analytics.silver_purchase_items`
GROUP BY
  purchase_date
ORDER BY
  purchase_date;