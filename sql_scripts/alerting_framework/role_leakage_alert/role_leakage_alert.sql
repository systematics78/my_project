with q1 as (
select u.role
      ,listagg(distinct replace(t.tag_value,',',';'), '; ') within group (order by replace(t.tag_value,',',';') desc) as owner
      ,listagg(distinct u.grantee_name, '<br>') within group (order by u.grantee_name desc) as grantee_name
    from snowflake.account_usage.grants_to_users u
    left join snowflake.account_usage.tag_references t on u.role = t.object_name
where u.deleted_on is null and u.grantee_name not ilike 'sys%'
  and t.domain = 'ROLE' and t.tag_name in ('OWNER') and tag_value <> 'PUBLISH'
  and u.role = '&{v_filter}'
group by u.role
)
select role, owner, grantee_name
--,initcap(replace(replace(replace(split_part(owner,'@',1),'_ext',''),'.',' '),'_',' ')) as user_name
from q1;