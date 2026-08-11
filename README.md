# Font APEX Icon Picker

Oracle APEX item plugin source for selecting a Font APEX icon from a searchable modal dialog.

The picker reads the current APEX installation's `APEX_DG_BUILTIN_FONTAPEX` view at request time. No icon list is embedded in the plugin.

## Project layout

- `database/fa_icon_picker_plugin.pks` and `.pkb` — render and AJAX callbacks.
- `static/fa-icon-picker.js` — dialog, search, and selection UI.
- `static/fa-icon-picker.css` — responsive icon grid styling.
- `plugin/plugin_item_type_fa_icon_picker.sql` — import script for the item plugin.

## Install

1. Run the package specification and body in the target parsing schema.
2. Upload `static/fa-icon-picker.js` and `static/fa-icon-picker.css` as plugin files.
3. Import `plugin/plugin_item_type_fa_icon_picker.sql` in APEX Builder, or use it as the plugin export source.
4. Create an item of type **Font APEX Icon Picker**. Its return value is the Font APEX icon name, for example `fa-cloud`. Users can also type a name directly or clear the field to store `NULL`.

The parsing schema needs `SELECT` on `APEX_DG_BUILTIN_FONTAPEX`; this is normally available to APEX parsing schemas. The AJAX callback returns 100 icons per request and the dialog loads subsequent pages as the user scrolls. If a request fails, the dialog now displays the error instead of presenting an empty list; inspect the browser console and APEX debug output for the underlying server error.
