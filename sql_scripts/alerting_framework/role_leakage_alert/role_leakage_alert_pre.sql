select 
    distinct u.role 
  from snowflake.account_usage.grants_to_users u
  left join snowflake.account_usage.tag_references t on u.role = t.object_name
where u.deleted_on is null and u.grantee_name not ilike 'sys%'
  and t.domain = 'ROLE' and t.tag_name in ('LAYER') and tag_value <> 'PUBLISH'
  -- and t.domain = 'ROLE' and t.tag_name in ('LAYER','OWNER') and tag_value <> 'PUBLISH'
 and role ilike '%DATA%ENGINEER%'
order by 1;