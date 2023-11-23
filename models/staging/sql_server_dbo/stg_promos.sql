with src_promos as (
    select * from {{ source('sql_server_dbo', 'promos') }}
),

renamed_casted as (
    select
        cast(
            {{ dbt_utils.generate_surrogate_key (["promo_id"]) }} as varchar (50)
        ) as promo_id,
        cast(promo_id AS varchar(50)) as des_promo,
        discount,
        status,
        _fivetran_deleted,
        _fivetran_synced as date_load
    from src_promos
)


select *
from renamed_casted
union all
select
    '9999' as promo_id,
    'sin promo' as des_promo,
    '0' as discount,
    'inactive' as status,
    null as _fivetran_deleted,
    null as date_load
