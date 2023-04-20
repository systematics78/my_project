show tasks in account;
create or replace transient table control_db.utility.temp_task_report_alert as
select * from TABLE(RESULT_SCAN(LAST_QUERY_ID())) where "state"<>'suspended';