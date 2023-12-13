
with 

src_addresses as (
    select * from {{ source('sql_server_dbo', 'addresses') }}
),

stg_addresses as (
    select
        CAST({{ dbt_utils.generate_surrogate_key(['address_id']) }} AS VARCHAR(50)) AS address_id,
        cast(zipcode as varchar(20)) as zipcode,
        cast(country as varchar(20)) as country,
        COALESCE(cast(address as varchar(255)), 'N/A') as address,
        cast(state as varchar(50)) as state,
        _fivetran_deleted,
        cast(_fivetran_synced as timestamp_ntz) as date_load
    from src_addresses
)

select * from stg_addresses
