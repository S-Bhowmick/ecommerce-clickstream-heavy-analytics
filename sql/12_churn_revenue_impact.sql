WITH priced_events AS (
    SELECT
        user_id,
        price
    FROM read_parquet('data/raw/clickstream_raw.parquet')
    WHERE price IS NOT NULL
),

aov AS (
    SELECT
        AVG(price) AS avg_order_value
    FROM priced_events
),

churn_users AS (
    SELECT
        CASE
            WHEN event_type = 'page_view' THEN 'Bounce risk'
            WHEN event_type = 'product_view' THEN 'Browsing only'
            WHEN event_type = 'add_to_cart' THEN 'Cart abandoner'
            WHEN event_type = 'checkout' THEN 'Checkout drop'
        END AS churn_stage,
        COUNT(DISTINCT user_id) AS users_lost
    FROM read_parquet('data/raw/clickstream_raw.parquet')
    WHERE user_id NOT IN (
        SELECT DISTINCT user_id
        FROM priced_events
    )
    GROUP BY churn_stage
)

SELECT
    c.churn_stage,
    c.users_lost,
    ROUND(c.users_lost * a.avg_order_value, 2) AS estimated_revenue_loss
FROM churn_users c
CROSS JOIN aov a
ORDER BY estimated_revenue_loss DESC;