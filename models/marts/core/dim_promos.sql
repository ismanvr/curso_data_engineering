{{
  config(
    materialized='table',
    unique_key=['promo_id']
  )
}}

with

stg_promos as (

    select * from {{ ref('stg_promos') }}

),

dim_promos as (

    select
        promo_id,
        des_promo,
        discount,
        status,
        date_load

    from stg_promos
    

)

select * from dim_promos