-- Explore event distribution in the GA4 public dataset.
-- Limited to one day to reduce BigQuery scan costs.

SELECT
  event_date,
  event_name,
  COUNT(*) AS event_count
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  _TABLE_SUFFIX = '20201216'
GROUP BY
  event_date,
  event_name
ORDER BY
  event_date,
  event_count DESC;