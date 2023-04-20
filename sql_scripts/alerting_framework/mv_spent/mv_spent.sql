select 
to_char(start_time,'MON-YYYY') as month
, uc_name
, owner
, round(sum(total_credits_used),2) as total_credits_used
, case when current_account() ilike '%PRD%' then 700 else 400 end as monthly_notification_credits_limit
from "MONITOR_DB"."VIEWS_MONITORING"."MATERIALIZED_VIEWS_REFRESH_SI"
where start_time >= date_trunc(month,dateadd('month', -1, current_timestamp))
group by to_char(start_time,'MON-YYYY'), uc_name, owner
having sum(total_credits_used) > case when current_account() ilike '%PRD%' then 700 else 400 end
and coalesce(owner,'NA') = coalesce('&{v_filter}','NA');
