SELECT
      'Snowflake Access Control Error' AS title
    , current_account() AS environment
    , 'Snowflake Query' AS object
    , START_TIME AS event_time
    , current_timestamp() AS alert_time
    , 'User ' || USER_NAME || ' received ' || ERROR_MESSAGE AS description
    , ERROR_MESSAGE AS event_data
    , coalesce(u.display_name,a.user_name) AS actor
    , 'Received an authorization error' AS action
    , 'Low' AS severity
    , QUERY_ID
    , 'snowflake_authorization_error_alert_query' AS query_name
from snowflake.account_usage.query_history a
left join snowflake.account_usage.users u on a.user_name = u.login_name
where u.deleted_on is null
AND error_code in (1063, 3001, 3003, 3005, 3007, 3011, 3041)
AND start_time >= DATEADD('hour', -12, CURRENT_TIMESTAMP())
AND a.USER_NAME = '&{v_user_name}';