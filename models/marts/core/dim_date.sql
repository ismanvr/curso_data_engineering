{{
  config(
    materialized='table',
    unique_key=['date_id']
  )
}}
with

stg_date as (

    select * from {{ ref('stg_date') }}

),

dim_date as (

    select
        date_forecast
        , date_id
        , year_date
        , month_date
        , desc_month
        , id_year_month
        , day_before
        , year_week_day
        , week_date
        , quarter
        , quadmester
        , semester

    from stg_date
    

)

select * from dim_date