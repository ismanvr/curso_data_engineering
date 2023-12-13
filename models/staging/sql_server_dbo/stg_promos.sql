with src_promos as (
    select * from {{ source('sql_server_dbo', 'promos') }}
),

stg_promos as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key (["promo_id"]) }} as varchar (50)
        ) as promo_id,
        cast(promo_id as varchar(50)) as des_promo,
        cast(discount as float) as discount,
        cast(status as varchar(50)) as status,
        cast(_fivetran_deleted as boolean) as _fivetran_deleted,
        cast(_fivetran_synced as timestamp) as date_load
    from src_promos
)

select *
from stg_promos
union all
select
    {{ dbt_utils.generate_surrogate_key (["9999"]) }} as promo_id,
    'no promo' as des_promo,
    '0' as discount,
    'inactive' as status,
    null as _fivetran_deleted,
    MIN(date_load) as date_load
from stg_promos