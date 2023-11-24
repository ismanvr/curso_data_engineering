
--SELECT
  --AVG(DATEDIFF(day, CAST(created_at_utc AS DATE), CAST(delivered_at_utc AS DATE))) AS avg_days_to_deliver
--FROM {{ ref('stg_orders') }}
--WHERE created_at_utc IS NOT NULL AND delivered_at_utc IS NOT NULL --no es necesario, no lo tiene en cuenta


SELECT
  AVG(DATEDIFF(day, CAST(created_at_utc AS DATE), CAST(delivered_at_utc AS DATE))) AS avg_days,
  AVG(DATEDIFF(hour, CAST(created_at_utc AS TIMESTAMP_NTZ), CAST(delivered_at_utc AS TIMESTAMP_NTZ))) AS avg_hours,
  AVG(DATEDIFF(minute, CAST(created_at_utc AS TIMESTAMP_NTZ), CAST(delivered_at_utc AS TIMESTAMP_NTZ))) AS avg_minutes,
  AVG(DATEDIFF(second, CAST(created_at_utc AS TIMESTAMP_NTZ), CAST(delivered_at_utc AS TIMESTAMP_NTZ))) AS avg_seconds
FROM {{ ref('stg_orders') }}
WHERE created_at_utc IS NOT NULL AND delivered_at_utc IS NOT NULL
