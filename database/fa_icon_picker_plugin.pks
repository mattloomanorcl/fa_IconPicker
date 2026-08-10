create or replace package fa_icon_picker_plugin as

    function render (
        p_item                in apex_plugin.t_item,
        p_plugin              in apex_plugin.t_plugin,
        p_value               in varchar2,
        p_is_readonly         in boolean,
        p_is_printer_friendly in boolean
    ) return apex_plugin.t_item_render_result;

    function ajax (
        p_item   in apex_plugin.t_item,
        p_plugin in apex_plugin.t_plugin
    ) return apex_plugin.t_item_ajax_result;

end fa_icon_picker_plugin;
/
