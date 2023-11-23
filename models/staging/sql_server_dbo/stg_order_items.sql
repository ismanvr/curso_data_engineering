WITH source AS (
    SELECT * FROM {{ source('sql_server_dbo', 'order_items') }}
),
renamed AS (
    SELECT
        COALESCE(order_id, {{ dbt_utils.generate_surrogate_key(['order_id']) }}) AS order_id,
        cast(product_id as varchar (50)) as product_id,
        cast(quantity as int) as quantity,
        _fivetran_deleted,
        _fivetran_synced AS date_load
    FROM source
)
SELECT * FROM renamed
