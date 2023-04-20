SELECT
      'Snowflake Access Control Error' AS title
    , current_account() AS environment
    , 'Snowflake Query' AS object
    , START_TIME AS event_time
    , current_timestamp() AS alert_time
    , 'User ' || USER_NAME || ' received ' || replace(ERROR_MESSAGE,',',' ') AS description
    , coalesce(login_name,a.user_name) AS actor
    , 'Received an authorization error' AS action
    , 'Low' AS severity
    , QUERY_ID
    , 'snowflake_authorization_error_alert_query' AS query_name
    , coalesce(EMAIL,'SNFLAK_ANLYTC_PRJ_GBL_GBL@dl.mgd.novartis.com') as email
from snowflake.account_usage.query_history a
left join snowflake.account_usage.users u on a.user_name = u.login_name
where u.deleted_on is null
AND error_code in (1063, 3001, 3003, 3005, 3007, 3011, 3041)
AND start_time >= DATEADD('hour', -12, CURRENT_TIMESTAMP())
AND a.user_name = '&{v_filter}';