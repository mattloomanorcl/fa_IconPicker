prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback

begin
    wwv_flow_imp.import_begin (
        p_version_yyyy_mm_dd      => '2026.01.01',
        p_release                 => '26.1.2',
        p_default_workspace_id    => 1360677909333612953,
        p_default_application_id  => 14195,
        p_default_id_offset       => 0,
        p_default_owner           => 'WKSP_NEPTUNE'
    );
end;
/

begin
    wwv_flow_imp.g_mode := 'REPLACE';
end;
/

begin
    wwv_flow_imp_shared.create_plugin (
        p_id                        => wwv_flow_imp.id(610000000000000001),
        p_plugin_type               => 'ITEM TYPE',
        p_name                      => 'COM.MLOOMAN.FONTAPEX.ICON.PICKER',
        p_display_name              => 'Font APEX Icon Picker',
        p_supported_ui_types        => 'DESKTOP',
        p_supported_component_types => 'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS',
        p_javascript_file_urls      => '#PLUGIN_FILES#fa-icon-picker.js',
        p_css_file_urls             => '#PLUGIN_FILES#fa-icon-picker.css',
        p_plsql_code                => wwv_flow_string.join(wwv_flow_t_varchar2(
            'function render (',
            '    p_item                in apex_plugin.t_item,',
            '    p_plugin              in apex_plugin.t_plugin,',
            '    p_value               in varchar2,',
            '    p_is_readonly         in boolean,',
            '    p_is_printer_friendly in boolean',
            ') return apex_plugin.t_item_render_result is',
            'begin',
            '    return fa_icon_picker_plugin.render(p_item, p_plugin, p_value, p_is_readonly, p_is_printer_friendly);',
            'end render;',
            '',
            'function ajax (',
            '    p_item   in apex_plugin.t_item,',
            '    p_plugin in apex_plugin.t_plugin',
            ') return apex_plugin.t_item_ajax_result is',
            'begin',
            '    return fa_icon_picker_plugin.ajax(p_item, p_plugin);',
            'end ajax;'
        )),
        p_render_function           => 'render',
        p_ajax_function             => 'ajax',
        p_standard_attributes       => 'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:ESCAPE_OUTPUT:SOURCE:ELEMENT:WIDTH:PLACEHOLDER:ICON',
        p_substitute_attributes     => true,
        p_version_identifier        => '1.0.0',
        p_about_url                 => 'https://github.com/oracle/apex',
        p_files_version             => 1
    );

    wwv_flow_imp.import_end;
    commit;
end;
/
