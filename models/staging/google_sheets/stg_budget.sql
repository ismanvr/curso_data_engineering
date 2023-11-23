with 

source as (

    select * from {{ source('google_sheets', 'budget') }}

),

renamed as (

    select
        _row,
        quantity,
        month,
        product_id,
        _fivetran_synced as date_load

    from source

)

select * from renamed
