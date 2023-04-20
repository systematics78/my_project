SELECT  start_time, coalesce(u.display_name,user_name) as display_name, role_name, query_id, query_text
FROM snowflake.account_usage.query_history au
left join snowflake.account_usage.users u on au.user_name = u.login_name
WHERE QUERY_TYPE = 'ALTER_USER'
and u.deleted_on is null
and upper(QUERY_TEXT) ilike '%ADMIN%'
and DATEDIFF(hour, start_time, CURRENT_TIMESTAMP) <= 12
order by start_time, display_name, role_name;