-- Este modelo crea una dimensión a partir de la tabla 'addresses' teniendo en cuenta que el address de donde vive a donde pide no es el mismo
WITH stg_addresses AS (
    SELECT * FROM ALUMNO21_DEV_SILVER_DB.dbt.stg_addresses
),
dim_addresses as (
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
    LEFT JOIN stg_users u ON a.address_id = u.address_id
    LEFT JOIN stg_orders o ON a.address_id = o.address_id
)

SELECT * FROM dim_addresses
