(function ($, apex) {
  "use strict";

  function loadIcons(ajaxId, query, offset, done) {
    if (!ajaxId) {
      done({ icons: [], hasMore: false, error: "The picker has no AJAX identifier. Re-import the plugin and reload the page." });
      return;
    }
    apex.server.plugin(ajaxId, { x01: query || "", x02: offset || 0 }, {
      dataType: "json",
      success: function (data) { done(data); },
      error: function (jqXHR, textStatus, errorThrown) {
        var detail = errorThrown || textStatus || "Unknown error";
        if (window.console) {
          window.console.error("Font APEX Icon Picker AJAX request failed.", detail, jqXHR.responseText);
        }
        done({
          icons: [],
          hasMore: false,
          error: "Icons could not be loaded (" + detail + "). Enable APEX debug and inspect the browser console for details."
        });
      }
    });
  }

  function openPicker(button) {
    var $button = $(button), itemName = $button.data("item"), ajaxId = $button.data("ajax-id"),
      $dialog = $(
        '<div class="faip-dialog" title="Choose Font APEX Icon">'
        + '<label class="u-VisuallyHidden" for="faip-search">Search icons</label>'
        + '<input id="faip-search" class="text_field" type="search" placeholder="Search icons">'
        + '<div class="faip-grid" aria-live="polite"></div></div>'
      ), timer, offset = 0, hasMore = true, loading = false;

    function appendIcons(data, replace) {
      var $grid = $dialog.find(".faip-grid"), icons = Array.isArray(data && data.icons) ? data.icons : [];
      if (replace) { $grid.empty(); }
      if (data && data.error && replace) {
        $grid.append($("<p class=\"faip-empty faip-error\"></p>").text(data.error));
      } else if (!icons.length && replace) {
        $grid.append('<p class="faip-empty">No matching icons.</p>');
      }
      icons.forEach(function (icon) {
        var $choice = $('<button type="button" class="faip-choice"></button>')
          .attr("title", icon.name + (icon.category ? " — " + icon.category : ""))
          .append($('<span class="fa" aria-hidden="true"></span>').addClass(icon.name))
          .append($('<span class="faip-name"></span>').text(icon.name));
        $choice.on("click", function () {
          apex.item(itemName).setValue(icon.name);
          $button.siblings(".faip-value").find(".fa").attr("class", "fa " + icon.name);
          $dialog.dialog("close");
        });
        $grid.append($choice);
      });
      offset = (data && data.nextOffset) || offset + icons.length;
      hasMore = !!(data && data.hasMore);
      loading = false;
    }

    function requestPage(replace) {
      if (loading || (!replace && !hasMore)) { return; }
      loading = true;
      loadIcons(ajaxId, $dialog.find("#faip-search").val(), replace ? 0 : offset, function (data) {
        appendIcons(data, replace);
      });
    }

    $dialog.dialog({ modal: true, width: 900, maxWidth: "95vw", height: 650, close: function () { $dialog.remove(); } });
    $dialog.find("#faip-search").on("input", function () {
      clearTimeout(timer);
      timer = setTimeout(function () { offset = 0; hasMore = true; requestPage(true); }, 180);
    }).trigger("focus");
    $dialog.find(".faip-grid").on("scroll", function () {
      var grid = this;
      if (grid.scrollTop + grid.clientHeight >= grid.scrollHeight - 120) { requestPage(false); }
    });
    requestPage(true);
  }

  $(document).on("click", ".faip-open", function () { openPicker(this); });
  $(document).on("input change", ".faip-value input", function () {
    var value = $(this).val();
    $(this).siblings(".fa").attr("class", value ? "fa " + value : "fa");
  });
})(apex.jQuery, apex);
