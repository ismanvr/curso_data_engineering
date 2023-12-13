WITH 

src_budget AS (
    SELECT * FROM {{ source('google_sheets', 'budget') }}
),

stg_budget AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['_row', 'product_id', 'month']) }} AS budget_id,
        CAST(_row AS INT) AS _row,
        CAST(quantity AS FLOAT) AS quantity,
        CAST(month AS DATE) AS budget_date,
        CAST({{ dbt_utils.generate_surrogate_key(['product_id']) }} AS VARCHAR(50)) AS product_id,
        CAST(_fivetran_synced AS TIMESTAMP) AS date_load
    FROM src_budget
)

SELECT * FROM stg_budget
