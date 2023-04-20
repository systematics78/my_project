WITH table_spend AS (
  SELECT database_name, schema_name, table_name, SUM(credits_used) AS credits
  FROM snowflake.account_usage.materialized_view_refresh_history
  WHERE DATEDIFF(hour, end_time, CURRENT_TIMESTAMP) <= 12
  GROUP BY database_name, schema_name, table_name
  ORDER BY credits DESC)
SELECT database_name, schema_name, table_name, round(credits,2) AS credits
FROM table_spend
WHERE credits > 5;