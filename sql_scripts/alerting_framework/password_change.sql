SELECT start_time, coalesce(u.display_name,user_name) as display_name, role_name, query_text  
FROM snowflake.account_usage.query_history h
left join snowflake.account_usage.users u on h.user_name = u.login_name
WHERE query_type = 'ALTER_USER'
and u.deleted_on is null
and upper(query_text) ilike '%password%'
and DATEDIFF(hour, start_time, CURRENT_TIMESTAMP) <= 12
order by start_time, display_name, role_name;