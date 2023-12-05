{% test valid_url(model, column_name) %}
  select*
  from {{ model }}
  where {{ column_name }} not ilike 'http%'
{% endtest %}
