with snowflake_admin_role_grant_monitor_alert_query AS (
SELECT
     'Snowflake - Admin role granted' AS alerttype
    , current_account() AS environment
    , REGEXP_SUBSTR(query_text, '\\s([^\\s]+)\\sto\\s',1,1,'ie') AS object
    , start_time AS event_time
    , CURRENT_TIMESTAMP() AS alert_time
    , 'A new grant was added ' || LOWER(REGEXP_SUBSTR(query_text, '\\s(to\\s[^\\s]+\\s[^\\s]+);?',1,1,'ie')) || ' by user ' || user_name || ' using role ' || role_name AS description
    , query_text AS event_data
    , 'Medium' AS severity
    , user_name AS actor
    , 'Granted Admin role' AS action
FROM snowflake.account_usage.query_history
WHERE 1=1
  AND query_type='GRANT'
  AND execution_status='SUCCESS'
  AND (object ILIKE '%securityadmin%' OR object ILIKE '%accountadmin%' OR object ILIKE '%sysadmin%' OR object ILIKE '%useradmin%')
  AND start_time >= DATEADD('hour',-12,CURRENT_TIMESTAMP())

)
select * from snowflake_admin_role_grant_monitor_alert_query where ACTOR not like '%ILYASSA1%'
;
