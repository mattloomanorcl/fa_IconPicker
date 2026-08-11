create or replace package body fa_icon_picker_plugin as

    function render (
        p_item                in apex_plugin.t_item,
        p_plugin              in apex_plugin.t_plugin,
        p_value               in varchar2,
        p_is_readonly         in boolean,
        p_is_printer_friendly in boolean
    ) return apex_plugin.t_item_render_result is
        l_item_name varchar2(255) := apex_escape.html_attribute(apex_plugin.get_input_name_for_item);
        l_value     varchar2(4000) := apex_escape.html_attribute(p_value);
        l_result    apex_plugin.t_item_render_result;
    begin
        apex_javascript.add_library(
            p_name      => 'fa-icon-picker',
            p_directory => p_plugin.file_prefix,
            p_version   => null
        );
        apex_css.add_file(
            p_name      => 'fa-icon-picker',
            p_directory => p_plugin.file_prefix,
            p_version   => null
        );

        sys.htp.p(
            '<div class="faip-item" id="' || l_item_name || '_FAIP">'
            || '<div class="faip-value" style="position:relative;flex:1 1 auto;">'
            || '<span class="fa ' || l_value || '" aria-hidden="true"'
            || ' style="position:absolute;z-index:1;top:50%;left:.625rem;transform:translateY(-50%);pointer-events:none;"></span>'
            || '<input type="text" id="' || l_item_name || '" name="' || l_item_name
            || '" value="' || l_value || '" class="text_field apex-item-text"'
            || ' style="width:100%;padding-left:2.25rem;">'
            || '</div>'
            || '<button type="button" class="t-Button faip-open"'
            || ' aria-label="Choose Font APEX icon" data-item="' || l_item_name || '"'
            || ' data-ajax-id="' || apex_escape.html_attribute(apex_plugin.get_ajax_identifier) || '">...</button></div>'
        );

        l_result.is_navigable := not p_is_readonly and not p_is_printer_friendly;
        return l_result;
    end render;

    function ajax (
        p_item   in apex_plugin.t_item,
        p_plugin in apex_plugin.t_plugin
    ) return apex_plugin.t_item_ajax_result is
        l_search varchar2(4000) := upper(trim(apex_application.g_x01));
        l_offset number := 0;
        l_count  pls_integer := 0;
        l_result apex_plugin.t_item_ajax_result;
        c_page_size constant pls_integer := 100;
    begin
        begin
            l_offset := greatest(0, nvl(to_number(apex_application.g_x02), 0));
        exception
            when value_error then
                l_offset := 0;
        end;

        apex_json.open_object;
        apex_json.open_array('icons');
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
            if l_count <= c_page_size then
                apex_json.open_object;
                apex_json.write('id', r.icon_id);
                apex_json.write('name', r.icon_name);
                apex_json.write('category', r.icon_category);
                apex_json.close_object;
            end if;
        end loop;
        apex_json.close_array;
        apex_json.write('hasMore', l_count > c_page_size);
        apex_json.write('nextOffset', l_offset + least(l_count, c_page_size));
        apex_json.close_object;
        return l_result;
    end ajax;

end fa_icon_picker_plugin;
/
