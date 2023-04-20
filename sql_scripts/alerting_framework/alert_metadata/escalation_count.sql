update CONTROL_DB.UTILITY.ALERTING_FRAMEWORK as t1
set escalation_flag =  
(with q as (
select date(alert_date) as alert_date,alert_name,owner_email,count(1) as num_of_alert,max(escalation_flag) as escalation_flag
from CONTROL_DB.UTILITY.ALERTING_FRAMEWORK
group by date(alert_date),alert_name,owner_email
having alert_name=upper('&{v_alert_name}') and owner_email=upper('&{v_owner_email}')
)
select case when num_of_alert >= 3 then 1 else 0 end
from q where q.alert_name = t1.alert_name and q.owner_email = t1.owner_email
and t1.alert_name=upper('&{v_alert_name}') and t1.owner_email=upper('&{v_owner_email}')
),
escalation_date = current_timestamp()
;