WITH 
warehouse_spend AS
    (SELECT warehouse_name,Sum(total_elapsed_time) total_elapsed
    FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
    WHERE start_time >= Date_trunc(month, CURRENT_DATE())
    GROUP BY warehouse_name)
,user_spend AS
    (
    SELECT Sum(total_elapsed_time) total_elapsed, warehouse_name, user_name, role_name
    FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
    WHERE start_time >= Date_trunc(month, CURRENT_DATE())
    GROUP BY warehouse_name, user_name, role_name) 
,credits_used AS
    (
    SELECT Sum(credits_used) credits_used, warehouse_name
    FROM "SNOWFLAKE"."ACCOUNT_USAGE"."WAREHOUSE_METERING_HISTORY"
    WHERE start_time >= Date_trunc(month, CURRENT_DATE())
    GROUP BY warehouse_name)
SELECT user_spend.warehouse_name,
coalesce(u.display_name,user_spend.user_name) as user_name,
user_spend.role_name,
(user_spend.total_elapsed / warehouse_spend.total_elapsed ) * credits_used.credits_used AS credits_by_user
FROM credits_used
JOIN user_spend ON user_spend.warehouse_name = credits_used.warehouse_name
JOIN warehouse_spend ON warehouse_spend.warehouse_name = credits_used.warehouse_name
LEFT JOIN snowflake.account_usage.users u ON user_spend.user_name = u.login_name
where user_spend.WAREHOUSE_NAME like '&{v_wh_name}'
order by 4 desc;