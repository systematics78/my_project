select date(start_time) as start_date,coalesce(u.display_name,user_name) as display_name,role_name,query_text
FROM snowflake.account_usage.query_history h
left join snowflake.account_usage.users u on h.user_name = u.login_name
WHERE query_type = 'CREATE_USER'
and user_name not like '%ILYASSA1%'
and u.deleted_on is null
and start_time > dateadd(hour, -12, current_timestamp())
order by start_time desc;