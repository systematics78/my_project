select query_id,DATABASE_NAME,SCHEMA_NAME,EXECUTION_STATUS,ERROR_CODE,
coalesce(u.display_name,q.user_name) as display_name, warehouse_name,start_time,end_time,
round(total_elapsed_time/60000,2) as total_elapsed_time_min
from snowflake.account_usage.query_history as q
left join  snowflake.account_usage.users as u on q.user_name = u.login_name
where 1=1 --(EXECUTION_STATUS <> 'SUCCESS' and EXECUTION_STATUS not like 'FAILED%')
and total_elapsed_time/60000 > 60
and start_time > dateadd(hour, -12, current_timestamp())
and u.deleted_on is null
order by start_time;