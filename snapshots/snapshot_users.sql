{% snapshot snapshot_users %}

{{
    config(
      target_schema='snapshots',
      unique_key='user_id',
      strategy='check',
      check_cols=['address_id', 'first_name', 'last_name', 'phone_number'],
      invalidate_hard_deletes=True,
        )
}}

select *

from {{ ref('stg_users_incremental') }}

WHERE f_carga = (select max(f_carga) from {{ ref('stg_users_incremental') }}) -- es importante que sea igual porque si fuese > diría que la fecha de carga sea mayor que la ult y no tiene sentido
{% endsnapshot %}
