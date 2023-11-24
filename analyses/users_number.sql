
SELECT
  COUNT(DISTINCT user_id) AS total_users
FROM {{ ref('stg_users') }}
