with q1 as (
SELECT user_name,date_trunc(day,start_time) as start_date
,count(query_id) AS cnt_queries
FROM snowflake.account_usage.query_history
where start_time between ADD_MONTHS( date_trunc(month,current_date) , -1) and date_trunc(month,current_date)-1
and IS_CLIENT_GENERATED_STATEMENT = FALSE
and user_name not like '%ILYASSA1%' --and user_name ='SYSTEM'
group by user_name, date_trunc(day,start_time)
  )
, average_queries as (select user_name, round(avg(cnt_queries)) avg_queries from q1 group by user_name)
,total_queries as
(select user_name, count(query_id) ld_queries
 FROM snowflake.account_usage.query_history
 where DATEDIFF(hour, start_time, CURRENT_TIMESTAMP) <= 12
 and IS_CLIENT_GENERATED_STATEMENT = FALSE
 and user_name not like '%ILYASSA1%'
 group by user_name
)
select coalesce(u.display_name,avg.user_name) as display_name
, round(avg.avg_queries,2) as lst_mnth_avg_qry
, round(tot.ld_queries) as query_inc_in_lst_12_hrs
from average_queries avg 
inner join total_queries tot on avg.user_name = tot.user_name
left join  snowflake.account_usage.users u on tot.user_name = u.login_name
where tot.ld_queries > (avg.avg_queries*2) and tot.ld_queries > 100
and u.deleted_on is null;