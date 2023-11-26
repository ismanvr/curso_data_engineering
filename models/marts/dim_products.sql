WITH stg_products AS (
    SELECT * 
    FROM {{ ref('stg_products') }}
    ),

renamed_casted AS (
    SELECT *
    FROM stg_products
    )

SELECT * FROM renamed_casted