{% test is_date(model, column_name) %}
select *
from {{ model }}
where DATE({{ column_name }}) is null
{% endtest %}
