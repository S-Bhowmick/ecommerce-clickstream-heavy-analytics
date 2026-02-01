WITH user_ltv AS (
    SELECT
        user_id,
        SUM(price) AS lifetime_value
    FROM read_parquet('data/raw/clickstream_raw.parquet')
    WHERE event_type = 'checkout'
      AND price IS NOT NULL
    GROUP BY user_id
),

ranked_users AS (
    SELECT
        user_id,
        lifetime_value,
        NTILE(10) OVER (ORDER BY lifetime_value DESC) AS ltv_decile
    FROM user_ltv
)

SELECT
    CASE
        WHEN ltv_decile = 1 THEN 'Top 10%'
        ELSE 'Bottom 90%'
    END AS user_segment,
    COUNT(*) AS users,
    SUM(lifetime_value) AS total_revenue,
    AVG(lifetime_value) AS avg_ltv
FROM ranked_users
GROUP BY user_segment
ORDER BY total_revenue DESC;