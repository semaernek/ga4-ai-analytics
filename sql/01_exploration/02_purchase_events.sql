-- Explore purchase events in the GA4 public dataset.
-- Limited to one day to reduce BigQuery scan costs.

SELECT
  event_date,
  event_timestamp,
  user_pseudo_id,
  ecommerce.transaction_id,
  ecommerce.purchase_revenue,
  ecommerce.total_item_quantity
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  event_name = 'purchase'
  AND _TABLE_SUFFIX = '20201216'
ORDER BY
  event_timestamp;