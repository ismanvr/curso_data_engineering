WITH src_suppliers AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'suppliers') }}
),

stg_suppliers AS (
    SELECT
        CAST({{ dbt_utils.generate_surrogate_key (["suppliers_id"]) }} as varchar (50)) as suppliers_id,
        CAST(NAME AS VARCHAR(256)) AS suppliers_name,
        CAST(ADDRESS AS VARCHAR(256)) AS suppliers_address,
        CAST(PHONE_NUMBER AS VARCHAR(16)) AS suppliers_phone_number,
        CAST(EMAIL AS VARCHAR(100)) AS suppliers_email,
        CAST(PRODUCT_NAME AS VARCHAR(256)) AS suppliers_product_name,
        CAST(PRODUCT_PRICE AS FLOAT) AS suppliers_product_price_dollars,
        CAST({{ dbt_utils.generate_surrogate_key(['product_id']) }} AS VARCHAR(50)) AS product_id,
        CAST(_FIVETRAN_SYNCED AS TIMESTAMP) AS date_load
    FROM src_suppliers
)

SELECT * FROM stg_suppliers
