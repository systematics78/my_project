WITH ip_login_fails AS (
  SELECT  user_name, client_ip, reported_client_type, listagg(DISTINCT error_code,',') as error_code, listagg(DISTINCT error_message,',') as error_message
  , COUNT(event_id) AS counts
  FROM snowflake.account_usage.login_history
  WHERE DATEDIFF(HOUR, event_timestamp, CURRENT_TIMESTAMP) <= 12
  AND error_code IS NOT NULL
  GROUP BY user_name, client_ip, reported_client_type
)
SELECT coalesce(u.display_name,user_name) as display_name, ip.client_ip, ip.reported_client_type, ip.error_code, ip.error_message, ip.counts
FROM ip_login_fails ip
left join snowflake.account_usage.users u on ip.user_name = u.login_name
WHERE counts > 3
and u.deleted_on is null
order by counts desc;