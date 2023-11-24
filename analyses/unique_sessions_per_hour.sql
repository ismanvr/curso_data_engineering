SELECT
  AVG(unique_sessions) AS avg_unique_sessions_per_hour
FROM (
  SELECT
    DATE_TRUNC('hour', created_at) AS hour,
    COUNT(DISTINCT session_id) AS unique_sessions
  FROM {{ ref('stg_events') }}
  GROUP BY 1
) subquery
