with q as (
select 
date(alert_date) as alert_date
, alert_name
, owner_email
, count(1) as num_of_alert
, max(escalation_flag) as escalation_flag
from CONTROL_DB.UTILITY.ALERTING_FRAMEWORK
group by date(alert_date),alert_name,owner_email
having alert_name=upper('&{v_alert_name}') and owner_email=upper('&{v_owner_email}')
--and date(alert_date) = current_date
),q1 as (
    select 
    sum(num_of_alert) as num_of_alert
    , max(escalation_flag) as escalation_flag 
    from q
)
select 
case when num_of_alert < 3 then 0 else 1 end as alert_flag
, escalation_flag 
from q1;