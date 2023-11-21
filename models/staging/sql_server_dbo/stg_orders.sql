with 

src_orders as (

    select * from {{ source('sql_server_dbo', 'orders') }}

),

renamed_casted as (

    select
        cast(order_id as varchar(50)) as order_id,
        cast(shipping_service as varchar(20)) as shipping_service,
        cast(COALESCE(shipping_cost, 0) as float) as shipping_cost_in_dollars,
        cast(address_id as varchar (50)) as address_id,
        cast(created_at as timestamp_ntz) as created_at_utc,
        decode(promo_id, '', '9999', {{dbt_utils.generate_surrogate_key(["promo_id"]) }}) as promo_id,
        cast(estimated_delivery_at as timestamp_ntz) as estimated_delivery_at_utc,
        cast(COALESCE(order_cost, 0) as float) as order_cost_in_dollars,
        cast(user_id as varchar(50)) as user_id,
        COALESCE(order_total, 0) AS order_total,
        cast(delivered_at as timestamp_ntz) as delivered_at_utc,
        cast(tracking_id as varchar(50)) as tracking_id,
        cast(decode(status, null,'NA', status) as varchar(20)) as status,
        --cast(_fivetran_deleted AS varchar) as _fivetran_deleted, --se eliminaria porque no lo necesitamos para el cdc, con el fivetran_synced tenemos
        cast(_fivetran_synced as timestamp_ntz) as date_load_utc

    from src_orders

)

select * from renamed_casted
