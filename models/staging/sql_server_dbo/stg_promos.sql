WITH source AS (
    SELECT * FROM {{ source('sql_server_dbo', 'promos') }}
),
renamed AS (
    SELECT
    cast(
        {{ dbt_utils.surrogate_key ([])}}
    )
        promo_id,
        discount,
        status,
        _fivetran_deleted,
        _fivetran_synced AS date_load
    FROM source
)


SELECT *
FROM renamed

UNION ALL
