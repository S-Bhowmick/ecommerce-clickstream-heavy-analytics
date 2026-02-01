-- User Lifetime Value
SELECT
    AVG(lifetime_value) AS avg_user_ltv
FROM (
    SELECT
        user_id,
        SUM(price) AS lifetime_value
    FROM read_parquet('data/raw/clickstream_raw.parquet')
    WHERE event_type = 'checkout'
    GROUP BY user_id
);

-- Average Lifetime Value
SELECT
    AVG(lifetime_value) AS avg_user_ltv
FROM (
    SELECT
        user_id,
        SUM(price) AS lifetime_value
    FROM read_parquet('data/raw/clickstream_raw.parquet')
    WHERE event_type = 'checkout'
      AND price IS NOT NULL
    GROUP BY user_id
);