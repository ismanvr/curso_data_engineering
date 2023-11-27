--esto no sería una fact table, sino una dimensión debido a que order_items refleja mejor la max granularidad

WITH stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_orders') }}
),


dim_orders AS (
    SELECT
        order_id 
        , user_id 
        , order_total
        , promo_id
        , address_id
        , created_at_utc
        , shipping_cost_dollars
        , order_cost_dollars
        , tracking_id
        , shipping_service
        , estimated_delivery_at_utc
        , delivered_at_utc
		, days_to_deliver        
        , status
        , date_load_utc
    FROM stg_orders
    )

SELECT * FROM dim_orders