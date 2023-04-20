WITH user_login_fails AS (
SELECT  user_name, reported_client_type, listagg(DISTINCT error_code,',') as error_code
  , listagg(DISTINCT error_message,',') as error_message, COUNT(event_id) AS counts
  FROM snowflake.account_usage.login_history
  WHERE DATEDIFF(hour, event_timestamp, CURRENT_TIMESTAMP) <= 12 AND error_code IS NOT NULL
  GROUP BY user_name, reported_client_type
)
SELECT coalesce(u.display_name,f.user_name) as user_name,reported_client_type, error_message
FROM user_login_fails f
LEFT JOIN snowflake.account_usage.users u ON f.user_name = u.login_name
WHERE counts > 3
and u.deleted_on is null;