with 

src_products as (

    select * from {{ source('sql_server_dbo', 'products') }}

),

renamed as (

    select
        cast(product_id as varchar(50)) as product_id,
        cast(price as float) as price,
        cast(name as varchar(50)) as name,
        cast(inventory as int) as inventory,
        --_fivetran_deleted, --borrado porque no es necesario
        cast(_fivetran_synced as timestamp_ntz) as date_load

    from src_products

)

select * from renamed
