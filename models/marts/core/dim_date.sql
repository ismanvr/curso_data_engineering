with

dim_date as (

    select * from {{ ref('stg_dates') }}

),

renamed_cast as (

    select
<<<<<<< HEAD
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
=======
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
>>>>>>> be34eafa411b30e32909ab39b8630908bdc6afa8
    

)

<<<<<<< HEAD
select * from renamed_cast
=======
select * from renamed
>>>>>>> be34eafa411b30e32909ab39b8630908bdc6afa8
