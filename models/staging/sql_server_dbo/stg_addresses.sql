-- Este modelo extrae datos de la tabla 'addresses'
with 

source as (

    select * from {{ source('sql_server_dbo', 'addresses') }}

),

renamed as (

    select
        address_id,
        zipcode,
        country,
        COALESCE(address, 'N/A') AS address,
        state,
        _fivetran_deleted,
        _fivetran_synced as date_load

    from source

)

select * from renamed
