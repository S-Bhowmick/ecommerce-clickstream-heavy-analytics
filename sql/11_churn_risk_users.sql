WITH user_events AS (
    SELECT
        user_id,
        MAX(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS viewed,
        MAX(CASE WHEN event_type = 'product_view' THEN 1 ELSE 0 END) AS product_viewed,
        MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS checked_out,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM read_parquet('data/raw/clickstream_raw.parquet')
    GROUP BY user_id
),

churn_segments AS (
    SELECT
        user_id,
        CASE
            WHEN viewed = 1 AND product_viewed = 0 THEN 'Bounce risk'
            WHEN product_viewed = 1 AND added_to_cart = 0 THEN 'Browsing only'
            WHEN added_to_cart = 1 AND checked_out = 0 THEN 'Cart abandoner'
            WHEN checked_out = 1 AND purchased = 0 THEN 'Checkout drop'
            WHEN purchased = 1 THEN 'Converted'
            ELSE 'Unknown'
        END AS churn_stage
    FROM user_events
)

SELECT
    churn_stage,
    COUNT(*) AS users
FROM churn_segments
GROUP BY churn_stage
ORDER BY users DESC;