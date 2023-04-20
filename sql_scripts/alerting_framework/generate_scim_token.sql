with q1 as (
select start_time,query_text,user_name
, datediff(day,date(start_time),current_date) as token_age
, case when datediff(day,date(start_time),current_date) > 163 then 'Y' else 'N' end as generate_token_flag
from snowflake.account_usage.query_history
where query_text ilike 'select system$generate_scim_access_token%'
and execution_status='SUCCESS'
    )
select start_time, token_age, generate_token_flag, 180-token_age as remaining_expiry_day
from q1
where start_time = (select max(start_time) from q1)
and generate_token_flag = 'Y'
;