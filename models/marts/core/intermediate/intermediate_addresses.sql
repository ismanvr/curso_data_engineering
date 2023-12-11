{{ config(
    materialized='view',
    target_schema='core',
    target_table='intermediate_addresses'
) 
}}
WITH stg_addresses AS (
    SELECT * 
    FROM {{ ref('stg_addresses') }}
),
snapshot_users AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY address_id ORDER BY date_load DESC) as row_num
    FROM {{ ref('snapshot_users') }}
        {% if is_incremental() %}
    WHERE date_load > (SELECT max(date_load) FROM {{ this }})
    {% endif %}
),
stg_orders AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY address_id ORDER BY date_load_utc DESC) as row_num
    FROM {{ ref('stg_orders') }}
        {% if is_incremental() %}
    WHERE date_load_utc > (SELECT max(date_load_utc) FROM {{ this }})
    {% endif %}
),
intermediate_addresses AS (
    SELECT
        a.address_id,
        a.zipcode,
        a.country,
        a.address,
        a.state,
        a.date_load,
        CASE
            WHEN u.address_id IS NOT NULL AND o.address_id IS NULL THEN 'user'
            WHEN u.address_id IS NULL AND o.address_id IS NOT NULL THEN 'order'
            ELSE 'both'
        END as source_type
    FROM stg_addresses a
    LEFT JOIN snapshot_users u ON a.address_id = u.address_id AND u.row_num = 1
    LEFT JOIN stg_orders o ON a.address_id = o.address_id AND o.row_num = 1
)

SELECT * FROM intermediate_addresses
