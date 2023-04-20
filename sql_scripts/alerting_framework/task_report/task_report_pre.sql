with q as (
select t."name" as task_name, t."database_name" as database_name, t."schema_name" as schema_name
    ,t."owner" as role_name,h.warehouse_name
    ,coalesce(u.email,h.user_name) as user_name
    ,t."created_on" as created_date
    ,row_number() over(partition by t."name" , t."database_name", t."schema_name" order by t."created_on" desc) as rnk
from control_db.utility.temp_task_report_alert t
inner join snowflake.account_usage.query_history h
on t."database_name" = h.database_name and t."schema_name" = h.schema_name and h.query_text ilike '%'||t."name"||'%' and t."owner" = h.role_name
left join snowflake.account_usage.users u on h.user_name = u.login_name    
where upper(h.query_type)='CREATE_TASK'
and h.execution_status='SUCCESS'
    and u.deleted_on is null
)
select distinct user_name
from q where rnk=1
and database_name||'.'||schema_name <>'CONTROL_DB.UTILITY'
and database_name not in ('REFINEMENT_GENERAL','REFINEMENT_RESTRICTED','REFINEMENT_REGIONAL_RESTRICTED')
and role_name != 'ACCOUNTADMIN';