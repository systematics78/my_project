Select r.name as role_name
From SNOWFLAKE.ACCOUNT_USAGE.ROLES r
    Left Join SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES GTR ON R.name = GTR.name
Where GTR.privilege IS NULL And r.name NOT IN ('ACCOUNTADMIN', 'USERADMIN', 'SECURITYADMIN', 'SYSADMIN', 'PUBLIC');