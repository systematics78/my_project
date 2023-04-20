select query_id
, DATABASE_NAME
, SCHEMA_NAME
, EXECUTION_STATUS
, ERROR_CODE
, q.user_name as query_executed_by
, q.warehouse_name
, start_time
, end_time
, round(total_elapsed_time/60000,2) as total_elapsed_time_min
, replace(e.owner,',',';') as wh_owner_email
from snowflake.account_usage.query_history as q
left join  snowflake_metadata.account_usage.wh_tags_list e on q.warehouse_name = e.warehouse_name
where 1=1 --(EXECUTION_STATUS <> 'SUCCESS' and EXECUTION_STATUS not like 'FAILED%')
and total_elapsed_time/60000 > 60
and start_time > dateadd(hour, -12, current_timestamp())
and q.warehouse_name = '&{v_filter}'
order by start_time;