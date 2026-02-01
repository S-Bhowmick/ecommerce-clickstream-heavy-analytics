WITH revenue_events AS (
    SELECT
        user_id,
        event_type,
        price
    FROM read_parquet('data/raw/clickstream_raw.parquet')
    WHERE event_type IN ('add_to_cart', 'checkout', 'purchase')
      AND price IS NOT NULL
),

revenue_by_step AS (
    SELECT
        SUM(price) FILTER (WHERE event_type = 'add_to_cart') AS cart_value,
        SUM(price) FILTER (WHERE event_type = 'checkout')    AS checkout_value,
        SUM(price) FILTER (WHERE event_type = 'purchase')    AS purchase_value
    FROM revenue_events
)

SELECT
    cart_value,
    checkout_value,
    purchase_value,

    (cart_value - checkout_value) AS revenue_lost_cart_to_checkout,
    (checkout_value - purchase_value) AS revenue_lost_checkout_to_purchase,

    ROUND(purchase_value * 100.0 / cart_value, 2) AS cart_to_purchase_realization_pct
FROM revenue_by_step;