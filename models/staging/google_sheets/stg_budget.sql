with 

stg_budget as (
    select * from {{ source('google_sheets', 'budget') }}
),

renamed_cast as (
    select
        cast(_row as int) as _row,
        cast(quantity as float) as quantity,
        cast(month as date) as budget_date,
        cast(product_id as varchar(100)) as product_id,
        cast(_fivetran_synced as timestamp) as date_load
    from stg_budget
)

select * from renamed_cast
