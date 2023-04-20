select distinct owner
from "MONITOR_DB"."VIEWS_MONITORING"."MATERIALIZED_VIEWS_REFRESH_SI"
where start_time >= Date_trunc(month, CURRENT_DATE())
group by to_char(start_time,'MON-YYYY'), uc_name, owner
having sum(total_credits_used) > case when current_account() ilike '%PRD%' then 700 else 400 end;
