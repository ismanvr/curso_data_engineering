{{ config(
    materialized='incremental', 
    unique_key='user_id',
    target_schema='staging',
    target_table='users'
) }}
--al ser incremental ya sabemos que no es una vista porque no existe modelo incremental con vistas
with 

src_users as (

    select * from {{ source('sql_server_dbo', 'users') }}

),

renamed as (

    select
        user_id,
        updated_at,
        address_id,
        last_name,
        created_at,
        cast(replace(phone_number, '-', '') as number) as phone_number,
        total_orders,
        first_name,
        email,
        _fivetran_deleted,
        _fivetran_synced as f_carga

    from src_users

)

select * from renamed
