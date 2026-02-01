-- Revenue & Conversion Performance

SELECT
    COUNT(*) AS total_checkouts,
    COUNT(price) AS priced_checkouts,
    SUM(price) AS total_revenue,
    AVG(price) AS avg_order_value
FROM read_parquet('data/raw/clickstream_raw.parquet')
WHERE event_type = 'checkout'
  AND price IS NOT NULL;

