with final_task_raw as (
      select user_name,role_name,database_name,schema_name
      ,replace(REGEXP_SUBSTR(upper(replace(query_text,'//',' ')),'task\\W+(\\S+)', 1, 1, 'i', 1),'"','') as task_name
      ,start_time
      ,row_number() over (partition by role_name,database_name,schema_name,task_name order by start_time desc) as rnk    
      from snowflake.account_usage.query_history
      where upper(query_type)='CREATE_TASK'
),
final_task as (
    select case when user_name not like '%@%' then user_name||'@NOVARTIS.NET' else user_name end as user_name
      ,role_name
      ,case when regexp_count(task_name, '\\b.\\b', 1) >= 2 then split_part(task_name,'.',1)
            else database_name
      end as database_name
      ,case when regexp_count(task_name, '\\b.\\b', 1) = 1 then split_part(task_name,'.',1) 
            when regexp_count(task_name, '\\b.\\b', 1) = 2 then REGEXP_SUBSTR(task_name,'.([^.]+)',1,2,'e')
            when regexp_count(task_name, '\\b.\\b', 1) > 2 then REGEXP_SUBSTR(task_name,'.([^.]+)',1,2,'e')
            else schema_name
      end as schema_name
      ,case when regexp_count(task_name, '\\b.\\b', 1) = 1 then split_part(task_name,'.',2) 
            when regexp_count(task_name, '\\b.\\b', 1) = 2 then split_part(task_name,'.',3)
            when regexp_count(task_name, '\\b.\\b', 1) > 2 then substring(task_name,regexp_instr(task_name,'.\\b',1,4)+1)
            else task_name
      end as task_name
      ,start_time as created_date
      from final_task_raw
      where rnk=1
    )
select distinct user_name
from final_task
where database_name||'.'||schema_name != 'CONTROL_DB.UTILITY'
and role_name != 'ACCOUNTADMIN'
and database_name not in ('REFINEMENT_GENERAL','REFINEMENT_RESTRICTED','REFINEMENT_REGIONAL_RESTRICTED')
order by 1;