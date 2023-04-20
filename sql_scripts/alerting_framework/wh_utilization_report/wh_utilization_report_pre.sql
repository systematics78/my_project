show warehouses;
create or replace transient table demo_db.dummy.warehouse_info_poc as
SELECT "name" as warehouse_name, "size" as size,"min_cluster_count" as min_cluster_count,
"max_cluster_count" as max_cluster_count,"resource_monitor" as resource_monitor, "scaling_policy" as scaling_policy
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));