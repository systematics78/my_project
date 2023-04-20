/*SELECT distinct USER_NAME
from snowflake.account_usage.query_history  a
left join snowflake.account_usage.users u on a.user_name = u.login_name
where u.deleted_on is null
AND error_code in (1063, 3001, 3003, 3005, 3007, 3011, 3041)
AND start_time >= DATEADD('hour', -12, CURRENT_TIMESTAMP());
*/
with auth_err as (
SELECT USER_NAME,count(*) as rw_cnt
from snowflake.account_usage.query_history  a
left join snowflake.account_usage.users u on a.user_name = u.login_name
where u.deleted_on is null
AND error_code in (1063, 3001, 3003, 3005, 3007, 3011, 3041)
AND start_time >= DATEADD('hour', -12, CURRENT_TIMESTAMP())
group by USER_NAME
)
select user_name from auth_err where rw_cnt>5;