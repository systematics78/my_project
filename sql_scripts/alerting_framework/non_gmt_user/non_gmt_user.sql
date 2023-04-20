/*
select date(created_on) as created_on
, name
, display_name
, disabled
, coalesce(tag.tag_value,u.owner) as owner
, deleted_on
from snowflake.account_usage.users u
left join snowflake.account_usage.tag_references tag on tag.object_name = u.owner and tag.tag_name ='OWNER'
where disabled = false
and (
       (name = display_name and case when current_region() like '%_US_%' then owner <> 'AAD_PROVISIONER' else owner <> 'SCIM_ACCESS_GENERATOR' end)
    or (name <> display_name and case when current_region() like '%_US_%' then owner <> 'AAD_PROVISIONER' else owner <> 'SCIM_ACCESS_GENERATOR' end)
    or (name = display_name and case when current_region() like '%_US_%' then owner = 'AAD_PROVISIONER' else owner = 'SCIM_ACCESS_GENERATOR' end)
    )   
and name not in ('ILYASSA1@NOVARTIS.NET'
                ,'VDESAI'
                ,'SPLUNK_DBX_USER'
                ,'SYS_EBX'
                ,'SYS_F1_EBX_TAG_ADMIN@NOVARTIS.NET'
                )
and name not ilike 'SYS_F1_ALERTS_%'
and name not ilike 'SYS_F1_CICD_%'                
and deleted_on is null
and name not in ('SYS_TAG_ADMIN'
                ,'SYS_F1_SABIR_TEST@NOVARTIS.NET'
                ,'SYS_F1_DATAIKU'
                ,'VASANT.DESAI@NOVARTIS.COM'
                ,'SYS_TEST_EBX'
                ,'SYS_ACCOUNT_MONITOR'
                ,'SYS_QLIK_ACCOUNT_MONITOR'
                )
and coalesce(tag.tag_value,u.owner) = '&{v_filter}'                
order by 1,2;
*/

select date(created_on) as created_on
, name
, display_name
, disabled
, coalesce(tag.owner,u.owner) as owner
, deleted_on
from snowflake.account_usage.users u
left join CONTROL_DB.UTILITY.ROLE_TO_UC_TAGS_MAPPING_TABLE tag on tag.role_name = u.owner
where disabled = false
and (
       (name = display_name and case when current_region() like '%_US_%' then u.owner <> 'AAD_PROVISIONER' else u.owner <> 'SCIM_ACCESS_GENERATOR' end)
    or (name <> display_name and case when current_region() like '%_US_%' then u.owner <> 'AAD_PROVISIONER' else u.owner <> 'SCIM_ACCESS_GENERATOR' end)
    or (name = display_name and case when current_region() like '%_US_%' then u.owner = 'AAD_PROVISIONER' else u.owner = 'SCIM_ACCESS_GENERATOR' end)
    )   
and name not in ('ILYASSA1@NOVARTIS.NET'
                ,'VDESAI'
                ,'SPLUNK_DBX_USER'
                ,'SYS_EBX'
                ,'SYS_F1_EBX_TAG_ADMIN@NOVARTIS.NET'
                )
and name not ilike 'SYS_F1_ALERTS_%'
and name not ilike 'SYS_F1_CICD_%'                
and deleted_on is null
and name not in ('SYS_TAG_ADMIN'
                ,'SYS_F1_SABIR_TEST@NOVARTIS.NET'
                ,'SYS_F1_DATAIKU'
                ,'VASANT.DESAI@NOVARTIS.COM'
                ,'SYS_TEST_EBX'
                ,'SYS_ACCOUNT_MONITOR'
                ,'SYS_QLIK_ACCOUNT_MONITOR'
                ,'SYS_TEST_OCPO@NOVARTIS.NET'
                ,'SYS_F1_ACCOUNT_NAME@NOVARTIS.NET'
                ,'SYS_TEST'
                )
and coalesce(tag.owner,u.owner) = '&{v_filter}'                
order by 1,2;