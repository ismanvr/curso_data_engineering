with

dim_date as (

    select * from {{ ref('stg_dates') }}

),

renamed_cast as (

    select
        date_forecast
        , id_date
        , year_date
        , month_date
        , desc_month
        , id_year_month
        , day_before
        , year_week_day
        , week_date
        --Añadir trimestre, cuantrimestre, semestre, año fiscal, trimestre fiscal, cuatrimestre fiscal y semestre fiscal

    from source
    

)

select * from renamed