select
warehouse_name
,date_trunc(day, current_date) as period_start_date
,date_trunc(day, current_date) as period_end_date
,round(sum(credits_used),2) as total_credits_used
,sum(credits_used_compute) as total_credits_compute
,sum(credits_used_cloud_services) as total_credits_cloud_services
,max(CREDIT_QUOTA) as CREDIT_QUOTA
,round(((100 * total_credits_used) / max(CREDIT_QUOTA)),3) as credit_usage_percent
,iff (credit_usage_percent>=85, 'true','false') as alert_condition
,max(owner) as owner
,max(USE_CASE) as USE_CASE
,max(DOMAIN) as DOMAIN
,max(LAYER) as LAYER
,max(FREQUENCY) as FREQUENCY
from MONITOR_DB.WAREHOUSE_MONITORING.WAREHOUSE_CONSUMPTION
where warehouse_name IS NOT NULL and FREQUENCY='DAILY'
and start_time >= date_trunc(day, current_date)
group by warehouse_name
having alert_condition='true'

union all

select
warehouse_name
,date_trunc(month, current_date) as period_start_date
,date_trunc(day, current_date) as period_end_date
,round(sum(credits_used),2) as total_credits_used
,sum(credits_used_compute) as total_credits_compute
,sum(credits_used_cloud_services) as total_credits_cloud_services
,max(CREDIT_QUOTA) as CREDIT_QUOTA
,round(((100 * total_credits_used) / max(CREDIT_QUOTA)),3) as credit_usage_percent
,iff (credit_usage_percent>=85, 'true','false') as alert_condition
,max(owner) as owner
,max(USE_CASE) as USE_CASE
,max(DOMAIN) as DOMAIN
,max(LAYER) as LAYER
,max(FREQUENCY) as FREQUENCY
from MONITOR_DB.WAREHOUSE_MONITORING.WAREHOUSE_CONSUMPTION
where warehouse_name IS NOT NULL and FREQUENCY='MONTHLY'
and start_time >= date_trunc(month, current_date)
group by warehouse_name
having alert_condition='true';