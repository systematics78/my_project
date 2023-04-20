USE ROLE F1_&{ENV}_SNO_UCE_ADMIN;

alter warehouse if exists &{PROJECT}_WH_S set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.SUBJECT_AREA = '&{SUBJECT_AREA}';
alter warehouse if exists &{PROJECT}_WH_M set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.SUBJECT_AREA = '&{SUBJECT_AREA}';

alter warehouse if exists &{PROJECT}_WH_S set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.APP_NAME = '&{APP_NAME}';
alter warehouse if exists &{PROJECT}_WH_M set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.APP_NAME = '&{APP_NAME}';

alter warehouse if exists &{PROJECT}_WH_S set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.COST_CENTER= '&{COST_CENTER}';
alter warehouse if exists &{PROJECT}_WH_M set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.COST_CENTER= '&{COST_CENTER}';

alter warehouse if exists &{PROJECT}_WH_S set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.APP_ID= '&{APP_ID}';
alter warehouse if exists &{PROJECT}_WH_M set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.APP_ID= '&{APP_ID}';

alter warehouse if exists &{PROJECT}_WH_S set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.DOMAIN= '&{DOMAIN}';
alter warehouse if exists &{PROJECT}_WH_M set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.DOMAIN= '&{DOMAIN}';

alter warehouse if exists &{PROJECT}_WH_S set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.USE_CASE= '&{USE_CASE}';
alter warehouse if exists &{PROJECT}_WH_M set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.USE_CASE= '&{USE_CASE}';

alter warehouse if exists &{PROJECT}_WH_S set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.LAYER= '&{LAYER}';
alter warehouse if exists &{PROJECT}_WH_M set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.LAYER= '&{LAYER}';

alter warehouse if exists &{PROJECT}_WH_S set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.OWNER= '&{OWNER_EMAIL}';
alter warehouse if exists &{PROJECT}_WH_M set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.OWNER= '&{OWNER_EMAIL}';

alter warehouse if exists &{PROJECT}_WH_S set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.DESCRIPTION= '&{DESCRIPTION}';
alter warehouse if exists &{PROJECT}_WH_M set tag MONITOR_DB.WAREHOUSE_TAG_CATALOG.DESCRIPTION= '&{DESCRIPTION}';