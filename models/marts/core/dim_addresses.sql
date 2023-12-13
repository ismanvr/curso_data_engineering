-- Este modelo crea una dimensión a partir de la tabla 'addresses' teniendo en cuenta que el address de donde vive a donde pide puede no ser es el mismo
{{
  config(
    materialized='table',
    unique_key=['address_id']
  )
}}
WITH intermediate_addresses AS (
    SELECT * 
    FROM {{ ref('intermediate_addresses') }}
    ),
dim_addresses as (
    SELECT
        address_id,
        zipcode,
        country,
        address,
        state,
        source_type,
        date_load
    FROM intermediate_addresses
)

SELECT * FROM dim_addresses
