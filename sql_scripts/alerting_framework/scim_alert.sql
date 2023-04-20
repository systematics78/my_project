with scim as 
(
select
	EVENT_TIMESTAMP,
	EVENT_ID,
	EVENT_TYPE,
	ENDPOINT,
	METHOD,
	STATUS,
	ERROR_CODE,
	DETAILS,
	ACTOR_NAME,
	ACTOR_DOMAIN,
	RESOURCE_NAME,
	RESOURCE_DOMAIN
	from table(demo_db.information_schema.rest_event_history('scim'))
    where DATEDIFF(hour, EVENT_TIMESTAMP, CURRENT_TIMESTAMP) <= 12
),
ep as (
select ENDPOINT,max(RESOURCE_NAME) as RESOURCE_NAME, max(RESOURCE_DOMAIN) as RESOURCE_DOMAIN
from table(demo_db.information_schema.rest_event_history('scim'))
group by ENDPOINT
)
select to_varchar(s.EVENT_TIMESTAMP, 'DD-MoN-YYYY hh24:mi:ss') as EVENT_TIMESTAMP,
	s.ENDPOINT,
	s.METHOD,
	s.STATUS,
	s.DETAILS,
	coalesce(u.display_name,ep.RESOURCE_NAME,'Not Available') as display_name,
	coalesce(ep.RESOURCE_DOMAIN,'Not Available') as RESOURCE_DOMAIN
from scim as s 
left join ep on s.endpoint = ep.endpoint
left join snowflake.account_usage.users u on upper(u.login_name) = upper(ep.RESOURCE_NAME)
-- where s.METHOD <> 'GET' and s.STATUS <> 'SUCCESS';
where (s.METHOD <> 'GET' 
or (s.METHOD = 'GET' and lower(s.STATUS) like '%failed%')
or s.STATUS <> 'SUCCESS');