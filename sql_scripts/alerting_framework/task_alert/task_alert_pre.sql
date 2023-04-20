select distinct coalesce(tag.tag_value,r.owner) as owner
from table(util_db.information_schema.task_history(ERROR_ONLY => TRUE)) as t
inner join util_db.public.task_owner as r on t.root_task_id = r.id
left join snowflake.account_usage.tag_references tag on tag.object_name = r.owner and tag.tag_name ='OWNER'
where datediff(hour,t.query_start_time,current_timestamp) <= 12;