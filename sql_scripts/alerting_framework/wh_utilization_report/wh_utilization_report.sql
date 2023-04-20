select h.warehouse_name
, date(date_trunc(month,start_time)) as month
, sum(avg_running) as total_avg_running
, count(start_time) as total_count
, sum(avg_running) / count(start_time) * 100 as "EFFICTIVENESS in %age"
, size,min_cluster_count,max_cluster_count,resource_monitor, scaling_policy
, sum(avg_queued_load) as total_avg_queued_load
, sum(avg_queued_load) / count(start_time) * 100 as wh_queued_load_pct
, sum(avg_queued_provisioning) as total_avg_queued_provisioning
, sum(avg_queued_provisioning) / count(start_time) * 100 as wh_queued_provisioning_pct
, sum(avg_blocked) as total_avg_blocked
, sum(avg_blocked) / count(start_time) * 100 as wh_blocked_pct
from snowflake.account_usage.warehouse_load_history h
join demo_db.dummy.warehouse_info_poc w on h.warehouse_name = w.warehouse_name
where 1=1
and date(start_time) >= date_trunc(month,add_months(current_date,-3))
group by h.warehouse_name,month
, size, min_cluster_count, max_cluster_count
, resource_monitor, scaling_policy
order by warehouse_name,month;