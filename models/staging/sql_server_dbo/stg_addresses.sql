-- Este modelo extrae datos de la tabla 'addresses'
with 

src_addresses as (
    select * from {{ source('sql_server_dbo', 'addresses') }}
),

renamed as (
    select
        cast(address_id as varchar(50)) as address_id,
        cast(zipcode as varchar(20)) as zipcode,
        cast(country as varchar(20)) as country,
        COALESCE(cast(address as varchar(255)), 'N/A') as address,
        cast(state as varchar(50)) as state,
       -- _fivetran_deleted, --no lo necesito
        cast(_fivetran_synced as timestamp_ntz) as date_load
    from src_addresses
)

select * from renamed
