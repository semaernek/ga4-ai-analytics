-- Gold Layer: Daily Category Sales
-- Grain: 1 row per day per product category

-- Purpose:
--   Create category-level daily sales metrics.

-- Data quality:
--   NULL or blank categories are normalized to "Unknown".

CREATE OR REPLACE TABLE
  `proud-lamp-305020.ga4_ai_analytics.gold_daily_category_sales` AS

SELECT
  purchase_date,
  COALESCE(item_category,"Unknown") as item_category,
  COUNT(DISTINCT transaction_id) AS orders,
  SUM(item_revenue) AS revenue,
  SUM(quantity) AS units_sold,
  SAFE_DIVIDE(
    SUM(item_revenue),
    COUNT(DISTINCT transaction_id)
  ) AS aov,
  COUNT(DISTINCT user_pseudo_id) AS unique_customers
FROM
  `proud-lamp-305020.ga4_ai_analytics.silver_purchase_items`
GROUP BY
  purchase_date,
  item_category
ORDER BY
  purchase_date,
  revenue DESC;