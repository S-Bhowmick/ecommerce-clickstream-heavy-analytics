WITH user_funnel AS (
    SELECT
        user_id,
        MAX(event_type = 'page_view')     AS page_view,
        MAX(event_type = 'product_view')  AS product_view,
        MAX(event_type = 'add_to_cart')   AS add_to_cart,
        MAX(event_type = 'checkout')      AS checkout,
        MAX(event_type = 'purchase')      AS purchase
    FROM read_parquet('data/raw/clickstream_raw.parquet')
    GROUP BY user_id
),

funnel_counts AS (
    SELECT
        COUNT(*) FILTER (WHERE page_view)    AS page_view_users,
        COUNT(*) FILTER (WHERE product_view) AS product_view_users,
        COUNT(*) FILTER (WHERE add_to_cart)  AS add_to_cart_users,
        COUNT(*) FILTER (WHERE checkout)     AS checkout_users,
        COUNT(*) FILTER (WHERE purchase)     AS purchase_users
    FROM user_funnel
)

SELECT
    page_view_users,
    product_view_users,
    ROUND(product_view_users * 100.0 / page_view_users, 2) AS pv_to_product_pct,

    add_to_cart_users,
    ROUND(add_to_cart_users * 100.0 / product_view_users, 2) AS product_to_cart_pct,

    checkout_users,
    ROUND(checkout_users * 100.0 / add_to_cart_users, 2) AS cart_to_checkout_pct,

    purchase_users,
    ROUND(purchase_users * 100.0 / checkout_users, 2) AS checkout_to_purchase_pct
FROM funnel_counts;