with wh as (
    select warehouse_name
    from snowflake_metadata.account_usage.wh_tags_list
    where (app_id = 'null' or app_name = 'null' or cost_center = 'null' or owner = 'null')
    and not (warehouse_name like any ('%_EU_%','%_US_%','%_GLB_%','%_GBL_%','%_GLOBAL_%'))
    and case when split_part(warehouse_name,'_',2) = '' then 0 else 1 end != 0
    and not (split_part(warehouse_name,'_',-1) like ('%WH%'))
    )
,owner as  (
    select distinct r.name,o.owner as email_address
    from snowflake_metadata.account_usage.dbgrants_to_roles r 
    inner join control_db.utility.role_to_uc_tags_mapping_table o on r.grantee_name = o.role_name
    where privilege='OWNERSHIP' and granted_on ='WAREHOUSE'
           ) 
select wh.warehouse_name, owner.email_address
from wh inner join owner on wh.warehouse_name=owner.name
where wh.warehouse_name = '&{v_filter}';