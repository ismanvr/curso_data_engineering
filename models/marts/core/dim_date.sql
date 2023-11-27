with

dim_date as (

    select * from {{ ref('stg_dates') }}

),

renamed_cast as (

    select
    date_forecast
    , id_date
    , year
    , month
    , desc_mes
    , id_year_month
    , previus_day
    , year_week_day
    , week
    from dim_date
    

)

select * from renamed_cast