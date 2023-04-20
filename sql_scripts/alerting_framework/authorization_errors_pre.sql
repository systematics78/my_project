SELECT distinct USER_NAME
, coalesce(u.display_name,a.user_name) as display_name
, coalesce(EMAIL,'SNFLAK_ANLYTC_PRJ_GBL_GBL@dl.mgd.novartis.com') as email
, split_part(login_name, '@',  1) file_name
from snowflake.account_usage.query_history  a
left join snowflake.account_usage.users u on a.user_name = u.login_name
where u.deleted_on is null
AND error_code in (1063, 3001, 3003, 3005, 3007, 3011, 3041)
AND start_time >= DATEADD('hour', -12, CURRENT_TIMESTAMP());