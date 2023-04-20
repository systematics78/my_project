with history as (
select user_name,query_text 
from  snowflake.account_usage.query_history 
where query_type='CREATE_TASK' 
    )
, task_alert as (
select t.name as task_name,
  t.database_name,
  t.schema_name,
  t.query_text,
  t.state,
  replace(t.error_message,',',';') as error_message,
  coalesce(tag.tag_value,r.owner) as owner,
  tag.object_name
from table(util_db.information_schema.task_history(ERROR_ONLY => TRUE)) as t
inner join util_db.public.task_owner as r on t.root_task_id = r.id
left join snowflake.account_usage.tag_references tag on tag.object_name = r.owner and tag.tag_name ='OWNER'
where datediff(hour,t.query_start_time,current_timestamp) <= 12
  )
  select task_name, database_name, schema_name, state, error_message, h.user_name as task_creator, t.owner, object_name, count(*) as failed_count
  from task_alert as t 
  left join history as h on h.query_text ilike '%' || t.task_name  || '%'
  where t.owner = '&{v_filter}'
  group by task_name, database_name, schema_name, state, error_message, h.user_name, t.owner, object_name
order by 1, 2, 3;