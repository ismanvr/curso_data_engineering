with 

source as (

    select * from {{ source('sql_server_dbo', 'events') }}

),

renamed as (

    select
        event_id,
        cast(page_url as varchar(300)) as page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        created_at,
        order_id,
        cast(_fivetran_deleted as boolean) as _fivetran_deleted,
        cast(_fivetran_synced as timestamp) as date_load

    from source

)

select * from renamed
