-- Explore purchased items in the GA4 public dataset.
-- One row represents one purchased item.
-- Limited to one day to reduce BigQuery scan costs.

SELECT
  event_date,
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
  AND _TABLE_SUFFIX = '20201216'
ORDER BY
  event_timestamp;