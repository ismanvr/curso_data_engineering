with 

source as (

    select * from {{ source('sql_server_dbo', 'orders') }}

),

renamed as (

    select
        order_id,
        shipping_service,
        COALESCE(shipping_cost, 0) AS shipping_cost,
        address_id,
        created_at,
        promo_id,
        estimated_delivery_at,
        COALESCE(order_cost, 0) AS order_cost,
        user_id,
        COALESCE(order_total, 0) AS order_total,
        delivered_at,
        tracking_id,
        status,
        _fivetran_deleted,
        _fivetran_synced as date_load

    from source

)

select * from renamed
