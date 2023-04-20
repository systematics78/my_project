select t.name as task_name,
  t.database_name,
  t.schema_name,
  t.query_text,
  t.state,
  t.error_message,
  r.owner
from table(information_schema.task_history(ERROR_ONLY => TRUE)) as t
inner join util_db.public.task_owner as r on t.root_task_id = r.id
where datediff(hour,t.query_start_time,current_timestamp) <= 12;