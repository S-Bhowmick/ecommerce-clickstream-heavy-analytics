-- Basic Clickstream KPIs

SELECT
    COUNT(*)                    AS total_events,
    COUNT(DISTINCT user_id)     AS total_users,
    COUNT(DISTINCT session_id)  AS total_sessions,
    COUNT(DISTINCT product_id)    AS total_products,
    COUNT(DISTINCT event_type)  AS total_event_types
FROM read_parquet('data/raw/clickstream_raw.parquet');
