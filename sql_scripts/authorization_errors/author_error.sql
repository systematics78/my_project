with snowflake_authorization_error_alert_query  AS (
SELECT
      'Snowflake Access Control Error' AS title
    , current_account() AS environment
    , 'Snowflake Query' AS object
    , START_TIME AS event_time
    , current_timestamp() AS alert_time
    , 'User ' || USER_NAME || ' received ' || ERROR_MESSAGE AS description
    , ERROR_MESSAGE AS event_data
    , USER_NAME AS actor
    , 'Received an authorization error' AS action
    , 'Low' AS severity
    , 'b0724d64b40d4506b7bc4e0caedd1442' AS query_id
    , 'snowflake_authorization_error_alert_query' AS query_name
from snowflake.account_usage.query_history
WHERE 1=1
  AND error_code in (1063, 3001, 3003, 3005, 3007, 3011, 3041)
  AND start_time >= DATEADD('HOUR',-12,CURRENT_TIMESTAMP())
)
select * from snowflake_authorization_error_alert_query
;