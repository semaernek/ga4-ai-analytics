-- Silver Layer: Purchase Items
-- Grain: 1 row per purchased item
--
-- Source:
--   GA4 BigQuery public ecommerce dataset
--
-- Purpose:
--   Transform nested GA4 purchase events into a clean, item-level analytical table.


CREATE OR REPLACE TABLE
  `proud-lamp-305020.ga4_ai_analytics.silver_purchase_items` 
--PARTITION BY purchase_date CLUSTER BY transaction_id, user_pseudo_id 
AS

SELECT
  DATE(PARSE_DATE('%Y%m%d', event_date)) AS purchase_date,
  TIMESTAMP_MICROS(event_timestamp) AS purchase_timestamp,
  ecommerce.transaction_id AS transaction_id,
  user_pseudo_id,
  item.item_name,
  item.item_category,
  item.price AS item_price,
  item.quantity,
  item.price * item.quantity AS item_revenue
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
CROSS JOIN
  UNNEST(items) AS item
WHERE
  event_name = 'purchase'
--  AND _TABLE_SUFFIX = '20201216'
  ;