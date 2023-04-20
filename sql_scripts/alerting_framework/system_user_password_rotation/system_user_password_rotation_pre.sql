with user_rotation as (
    select u.name as user_name, password_last_set_time,datediff(day,password_last_set_time,current_timestamp) as age_in_days
    , replace(listagg(distinct t.tag_value,',')  within group (order by t.tag_value desc),space(1),'') as owner
    from snowflake.account_usage.users as u
    left join snowflake_metadata.account_usage.dbgrants_to_roles as r on u.name = r.grantee_name
    left join snowflake.account_usage.tag_references as t on t.object_name = r.name
    where u.login_name ilike '%SYS%'
    and u.deleted_on is null 
    and u.disabled = false 
    and u.has_password = true
    and datediff(day,u.password_last_set_time,current_timestamp) >= 90
    and t.tag_name = 'OWNER'
    and t.tag_value != 'snflak_anlytc_prj_gbl_gbl@dl.mgd.novartis.com'
    group by user_name, password_last_set_time, age_in_days
    )
select distinct owner
from user_rotation
order by 1
;