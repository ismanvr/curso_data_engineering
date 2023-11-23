-- Este modelo extrae datos de la tabla 'orders' --no tiene la linea product, hay que verlo, tambien el shipping cost (esta a nivel de pedido y no a nivel linea de pedido tiene diferente granularidad, bajarle grano al shipping cost, si el pedido tiene 1 producto no hay problema, si tiene 3 hay que dividirlo por 3 bajando asi el grano)
WITH src_orders AS (
    SELECT * FROM {{ source('sql_server_dbo', 'orders') }}
),
renamed_casted AS (
    SELECT
        CAST(order_id AS VARCHAR(50)) AS order_id,
        CAST(shipping_service AS VARCHAR(20)) AS shipping_service,
        CAST(COALESCE(shipping_cost, 0) AS FLOAT) AS shipping_cost_dollars,
        CAST(address_id AS VARCHAR(50)) AS address_id,
        CONVERT_TIMEZONE('UTC', 'Europe/Madrid', CAST(created_at AS TIMESTAMP_NTZ)) AS created_at_utc,
        DECODE(promo_id, '', '9999', {{ dbt_utils.generate_surrogate_key(["promo_id"]) }}) AS promo_id,
        CONVERT_TIMEZONE('UTC', 'Europe/Madrid', CAST(estimated_delivery_at AS TIMESTAMP_NTZ)) AS estimated_delivery_at_utc,
        CAST(COALESCE(order_cost, 0) AS FLOAT) AS order_cost_dollars,
        CAST(user_id AS VARCHAR(50)) AS user_id,
        COALESCE(order_total, 0) AS order_total,
        CONVERT_TIMEZONE('UTC', 'Europe/Madrid', CAST(delivered_at AS TIMESTAMP_NTZ)) AS delivered_at_utc,
        CAST(tracking_id AS VARCHAR(50)) AS tracking_id,
        CAST(DECODE(status, NULL, 'NA', status) AS VARCHAR(20)) AS status,
        -- No incluir _fivetran_deleted, no se necesita
        CONVERT_TIMEZONE('UTC', 'Europe/Madrid', CAST(_fivetran_synced AS TIMESTAMP_NTZ)) AS date_load_utc,
        DATEDIFF(day, CAST(created_at_utc AS DATE), CAST(delivered_at_utc AS DATE)) AS days_to_deliver
    FROM src_orders
)

SELECT * FROM renamed_casted

