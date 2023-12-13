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

from {{ ref('stg_users') }}

WHERE date_load = (select max(date_load) from {{ ref('stg_users') }}) -- con esto hago la snapshot incremental, es importante que sea = porque si fuese > diría que la fecha de carga sea mayor que la ult y no tiene sentido
{% endsnapshot %}
