-- Funnel Analysis: View → Add to Cart → Purchase

WITH session_events AS (
    SELECT
        session_id,
        MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS viewed,
        MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM read_parquet('data/raw/clickstream_raw.parquet')
    GROUP BY session_id
)

SELECT
    COUNT(*)                                   AS total_sessions,
    SUM(viewed)                                AS viewed_sessions,
    SUM(added_to_cart)                         AS add_to_cart_sessions,
    SUM(purchased)                             AS purchase_sessions,
    ROUND(SUM(added_to_cart) * 100.0 / SUM(viewed), 2) AS view_to_cart_rate,
    ROUND(SUM(purchased) * 100.0 / SUM(added_to_cart), 2) AS cart_to_purchase_rate
FROM session_events;
