--este es de los pocos casos que no tiene source, se genera a partir de una consulta de sql

{{ config(
    materialized='table', 
    sort='date_day',
    dist='date_day',
    pre_hook="alter session set timezone = 'America/New_York'; alter session set week_start = 7;" 
    ) 
}}

WITH date AS (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2000-01-01' as date)",
        end_date="cast(current_date()+1 as date)"
    )
    }}  
)

SELECT
    date_day AS date_forecast,
    year(date_day)*10000+month(date_day)*100+day(date_day) AS date_id,
    year(date_day) AS year_date,
    month(date_day) AS month_date,
    monthname(date_day) AS desc_month,
    year(date_day)*100+month(date_day) AS id_year_month,
    DATEADD(day, -1, date_day) AS day_before,
    year(date_day)||weekiso(date_day)||dayofweek(date_day) AS year_week_day,
    weekiso(date_day) AS week_date,
    quarter(date_day) AS quarter,
    ceil(month(date_day)/4) AS quadmester,
    ceil(month(date_day)/6) AS semester
FROM date
ORDER BY
    date_day DESC
