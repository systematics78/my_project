select date(created_on) as created_on, name, display_name, disabled,owner, deleted_on
from snowflake.account_usage.users  
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
order by 1,2;