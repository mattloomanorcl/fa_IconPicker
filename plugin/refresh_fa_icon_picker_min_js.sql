prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback

begin
    wwv_flow_imp.import_begin (
        p_version_yyyy_mm_dd     => '2026.01.01',
        p_release                => '26.1.2',
        p_default_workspace_id   => 1360677909333612953,
        p_default_application_id => 14195,
        p_default_id_offset      => 0,
        p_default_owner          => 'WKSP_NEPTUNE'
    );
    wwv_flow_imp.g_mode := 'REPLACE';

    wwv_flow_imp_shared.create_plugin_file (
        p_id           => wwv_flow_imp.id(2116787896646566899),
        p_flow_id      => wwv_flow_imp.id(14195),
        p_plugin_id    => wwv_flow_imp.id(610000000000000001),
        p_file_name    => 'fa-icon-picker.min.js',
        p_mime_type    => 'text/javascript',
        p_file_charset => 'utf-8',
        p_file_content => to_blob(utl_raw.cast_to_raw(q'~(function($,apex){"use strict";function load(id,q,o,done){if(!id){done({icons:[],hasMore:false,error:"The picker has no AJAX identifier. Re-import the plugin and reload the page."});return}apex.server.plugin(id,{x01:q||"",x02:o||0},{dataType:"json",success:function(data){done(data)},error:function(xhr,status,error){var detail=error||status||"Unknown error";window.console&&window.console.error("Font APEX Icon Picker AJAX request failed.",detail,xhr.responseText);done({icons:[],hasMore:false,error:"Icons could not be loaded ("+detail+"). Enable APEX debug and inspect the browser console for details."})}})}function open(button){var $button=$(button),item=$button.data("item"),ajaxId=$button.data("ajax-id"),$dialog=$('<div class="faip-dialog" title="Choose Font APEX Icon"><label class="u-VisuallyHidden" for="faip-search">Search icons</label><input id="faip-search" class="text_field" type="search" placeholder="Search icons"><div class="faip-grid" aria-live="polite"></div></div>'),timer,offset=0,more=true,loading=false;function append(data,replace){var $grid=$dialog.find(".faip-grid"),icons=Array.isArray(data&&data.icons)?data.icons:[];if(replace)$grid.empty();if(data&&data.error&&replace)$grid.append($("<p class=\"faip-empty faip-error\"></p>").text(data.error));else if(!icons.length&&replace)$grid.append('<p class="faip-empty">No matching icons.</p>');icons.forEach(function(icon){var $choice=$('<button type="button" class="faip-choice"></button>').attr("title",icon.name+(icon.category?" - "+icon.category:"")).append($('<span class="fa" aria-hidden="true"></span>').addClass(icon.name)).append($('<span class="faip-name"></span>').text(icon.name));$choice.on("click",function(){apex.item(item).setValue(icon.name);$button.find(".fa").attr("class","fa "+icon.name);$dialog.dialog("close")});$grid.append($choice)});offset=data&&data.nextOffset||offset+icons.length;more=!!(data&&data.hasMore);loading=false}function request(replace){if(loading||!replace&&!more)return;loading=true;load(ajaxId,$dialog.find("#faip-search").val(),replace?0:offset,function(data){append(data,replace)})}$dialog.dialog({modal:true,width:900,maxWidth:"95vw",height:650,close:function(){$dialog.remove()}});$dialog.find("#faip-search").on("input",function(){clearTimeout(timer);timer=setTimeout(function(){offset=0;more=true;request(true)},180)}).trigger("focus");$dialog.find(".faip-grid").on("scroll",function(){var grid=this;if(grid.scrollTop+grid.clientHeight>=grid.scrollHeight-120)request(false)});request(true)}$(document).on("click",".faip-open",function(){open(this)})})(apex.jQuery,apex);~')),
        p_created_by  => 'WKSP_NEPTUNE',
        p_created_on  => sysdate,
        p_updated_by  => 'WKSP_NEPTUNE',
        p_updated_on  => sysdate
    );
    wwv_flow_imp.import_end;
    commit;
end;
/
