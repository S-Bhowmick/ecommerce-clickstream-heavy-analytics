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

SELECT
    user_id,
    total_events,
    purchases,
    CASE
        WHEN purchases > 0 AND total_events >= 10 THEN 'Power User'
        WHEN purchases > 0 THEN 'Buyer'
        WHEN checkouts > 0 AND purchases = 0 THEN 'Abandoner'
        WHEN add_to_cart > 0 OR product_views > 0 THEN 'Interested'
        ELSE 'Browser'
    END AS user_segment
FROM user_events;