WITH stg_orders AS (
    SELECT *
    FROM {{ ref('stg_orders') }}
),
users_buying AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS num_purchases
    FROM stg_orders
  GROUP BY 1
),

user_per_buying as
(
SELECT
 CASE 
    WHEN num_purchases >= 3 THEN '3+'
    ELSE cast(num_purchases AS VARCHAR)
    END AS num_purchases,
    COUNT(user_id) AS num_users
FROM users_buying
GROUP BY 1)
SELECT * FROM user_per_buying