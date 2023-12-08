-- Este modelo extrae datos de la tabla 'orders' --no tiene la linea product, hay que verlo, tambien el shipping cost (esta a nivel de pedido y no a nivel linea de pedido tiene diferente granularidad, bajarle grano al shipping cost, si el pedido tiene 1 producto no hay problema, si tiene 3 hay que dividirlo por 3 bajando asi el grano)
{{ config(
    materialized='incremental', 
    unique_key='order_id',
    target_schema='staging',
    target_table='orders'
) }}
WITH src_orders AS (
    SELECT * FROM {{ source('sql_server_dbo', 'orders') }}
),
stg_orders AS (
    SELECT
        CAST(order_id AS VARCHAR(50)) AS order_id,
        CAST(CASE WHEN shipping_service IS NULL OR shipping_service = '' THEN 'Not Shipped' ELSE shipping_service END AS VARCHAR(20)) AS shipping_service,
        CAST(COALESCE(shipping_cost, 0) AS FLOAT) AS shipping_cost_dollars,
        CAST(address_id AS VARCHAR(50)) AS address_id,
        CONVERT_TIMEZONE('UTC', 'America/New_York', CAST(created_at AS TIMESTAMP_NTZ)) AS created_at_utc,
        CAST(promo_id AS VARCHAR(50)) as promo_id,
        CONVERT_TIMEZONE('UTC', 'America/New_York', CAST(estimated_delivery_at AS TIMESTAMP_NTZ)) AS estimated_delivery_at_utc,
        CAST(COALESCE(order_cost, 0) AS FLOAT) AS order_cost_dollars,
        CAST(user_id AS VARCHAR(50)) AS user_id,
        COALESCE(order_total, 0) AS order_total,
        CONVERT_TIMEZONE('UTC', 'America/New_York', CAST(delivered_at AS TIMESTAMP_NTZ)) AS delivered_at_utc,
        CAST(tracking_id AS VARCHAR(50)) as tracking_id,
        CAST(DECODE(status, NULL, 'NA', status) AS VARCHAR(20)) AS status,
        CONVERT_TIMEZONE('UTC', 'America/New_York', CAST(_fivetran_synced AS TIMESTAMP_NTZ)) AS date_load_utc,
        DATEDIFF(day, CAST(created_at_utc AS DATE), CAST(delivered_at_utc AS DATE)) AS days_to_deliver
    FROM src_orders
)

SELECT * FROM stg_orders

