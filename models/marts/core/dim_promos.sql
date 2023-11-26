with

dim_promos as (

    select * from {{ ref('stg_promos') }}

),

renamed_cast as (

    select
        promo_id,
        des_promo,
        discount,
        status

    from dim_promos
    

)

select * from renamed_cast