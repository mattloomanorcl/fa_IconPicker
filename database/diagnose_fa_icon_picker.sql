set pagesize 100
set linesize 200
set feedback on

select sys_context('USERENV', 'SESSION_USER') as session_user,
       sys_context('USERENV', 'DB_NAME') as db_name,
       sys_context('USERENV', 'CON_NAME') as con_name
from dual;

select count(*) as icon_count
from apex_dg_builtin_fontapex;

declare
    l_search varchar2(4000) := null;
    l_offset number := 0;
    l_count  pls_integer := 0;
    c_page_size constant pls_integer := 100;
begin
    for r in (
        select icon_id, icon_name, icon_category
        from apex_dg_builtin_fontapex
        where l_search is null
           or instr(upper(icon_name), l_search) > 0
           or instr(upper(nvl(icon_filters, ' ')), l_search) > 0
           or instr(upper(nvl(icon_category, ' ')), l_search) > 0
        order by icon_name
        offset l_offset rows fetch next c_page_size + 1 rows only
    ) loop
        l_count := l_count + 1;
    end loop;
    dbms_output.put_line('Paged query row count: ' || l_count);
end;
/

select object_name, object_type, status
from user_objects
where object_name = 'FA_ICON_PICKER_PLUGIN'
order by object_type;

select line, position, text
from user_errors
where name = 'FA_ICON_PICKER_PLUGIN'
order by type, sequence;

select object_name, argument_name, position, data_type, in_out
from all_arguments
where owner = 'APEX_260100'
  and package_name = 'WWV_FLOW_IMP_SHARED'
  and object_name = 'CREATE_PLUGIN_FILE'
order by subprogram_id, sequence;

select column_name
from all_tab_columns
where owner = 'APEX_260100'
  and table_name = 'APEX_APPL_PLUGIN_FILES'
order by column_id;

select plugin_file_id, application_id, plugin_id, file_name, mime_type, file_charset, dbms_lob.getlength(file_content) as bytes
from apex_appl_plugin_files
where application_id = 14195
  and plugin_id = 610000000000000001
order by file_name;

select dbms_lob.substr(file_content, 4000, 1) as min_js
from apex_appl_plugin_files
where application_id = 14195
  and plugin_id = 610000000000000001
  and file_name = 'fa-icon-picker.min.js';

select version_no
from apex_release;

select plsql_code
from apex_appl_plugins
where application_id = 14195
  and plugin_id = 610000000000000001;

select case
         when instr(plsql_code, 'p_param') = 0
          and instr(plsql_code, 'fa_icon_picker_plugin.ajax(p_item, p_plugin)') > 0
         then 'CORRECT'
         else 'INCORRECT'
       end as ajax_wrapper_status
from apex_appl_plugins
where application_id = 14195
  and plugin_id = 610000000000000001;
