with wh_credits as 
(SELECT warehouse_id, warehouse_name,SUM(credits_used) / 28 AS avg_credits_used
FROM snowflake.account_usage.warehouse_metering_history
WHERE DATEDIFF(DAY, start_time, CURRENT_TIMESTAMP) <= 28 
group by warehouse_id, warehouse_name
),
ld_wh_credits as
(
select warehouse_id, warehouse_name,SUM(credits_used) AS ld_credits_used 
  FROM snowflake.account_usage.warehouse_metering_history
where datediff(day,start_time,current_timestamp) = 1 
  group by warehouse_id, warehouse_name
)
select wc.warehouse_name, round(wc.avg_credits_used,2) as avg_credits_used_in_a_mnth, round(ld.ld_credits_used,2) as credit_spike_in_12_hrs
from wh_credits wc
left join ld_wh_credits ld on wc.warehouse_id = ld.warehouse_id
where ld.ld_credits_used > (wc.avg_credits_used * 1.25)
and credit_spike_in_12_hrs > 100;