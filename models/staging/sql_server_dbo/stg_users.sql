with 

src_users as (

    select * from {{ source('sql_server_dbo', 'users') }}

),

renamed_cast as (

    select
        cast(user_id as varchar (50)) as user_id,
        updated_at,
        cast(address_id as varchar (50)) as address_id,
        cast(last_name as varchar (20)) as last_name,
        created_at,
        cast(replace(phone_number, '-', '') as number) as phone_number,
       -- total_orders,   --lo borramos porque viene vacío
        cast(first_name as varchar (20)) as first_name,
        cast(email as varchar (50)) as email,
        _fivetran_deleted,
        _fivetran_synced as f_carga

    from src_users

)

select * from renamed_cast
