select distinct q.warehouse_name    
from snowflake.account_usage.query_history as q
left join  snowflake_metadata.account_usage.wh_tags_list e on q.warehouse_name = e.warehouse_name
where 1=1 --(EXECUTION_STATUS <> 'SUCCESS' and EXECUTION_STATUS not like 'FAILED%')
and total_elapsed_time/60000 > 60
and start_time > dateadd(hour, -12, current_timestamp());