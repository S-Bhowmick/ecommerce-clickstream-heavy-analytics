WITH user_events AS (
    SELECT
        user_id,
        COUNT(*) AS total_events,

        SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS page_views,
        SUM(CASE WHEN event_type = 'product_view' THEN 1 ELSE 0 END) AS product_views,
        SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart,
        SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS checkouts,
        SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchases

    FROM read_parquet('data/raw/clickstream_raw.parquet')
    GROUP BY user_id
)
SELECT *
FROM user_events
LIMIT 10;
