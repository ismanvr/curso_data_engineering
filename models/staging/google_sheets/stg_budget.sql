with 

src_budget as (
    select * from {{ source('google_sheets', 'budget') }}
),

stg_budget as (
    select
        {{ dbt_utils.generate_surrogate_key(['_row', 'product_id', 'month']) }} as budget_id,
        cast(_row as int) as _row,
        cast(quantity as float) as quantity,
        cast(month as date) as budget_date,
        cast(product_id as varchar(100)) as product_id,
        cast(_fivetran_synced as timestamp) as date_load
    from src_budget
)

select * from stg_budget
