-- Session-level metrics
WITH session_events AS (
    SELECT
        session_id,
        user_id,
        MIN(event_time) AS session_start,
        MAX(event_time) AS session_end,
        COUNT(*) AS total_events,
        COUNT(DISTINCT event_type) AS unique_event_types
    FROM read_parquet('data/raw/clickstream_raw.parquet')
    GROUP BY session_id, user_id
)

SELECT
    session_id,
    user_id,
    session_start,
    session_end,
    DATE_DIFF('second', session_start, session_end) AS session_duration_sec,
    total_events,
    unique_event_types
FROM session_events
ORDER BY session_duration_sec DESC
LIMIT 20;
