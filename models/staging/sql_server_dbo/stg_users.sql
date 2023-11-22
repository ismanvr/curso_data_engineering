with 

src_users as (

    select * from {{ source('sql_server_dbo', 'users') }}

),

renamed as (

    select
        cast(user_id as varchar (50)) as user_id,
        updated_at,
        address_id,
        last_name,
        created_at,
        cast(regexp_replace(phone_number, '-', '') as number) as phone_number,
       -- total_orders,   --lo borramos porque viene vacío
        first_name,
        email,
        _fivetran_deleted,
        _fivetran_synced as f_carga

    from src_users

)

select * from renamed
