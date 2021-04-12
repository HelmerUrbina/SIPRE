 // ui-start  -- ui-redmond -- ui-lightness -- arctic -- darkblue -- fresh
function getTheme() {
    var theme = "ui-start";
    var url = "/SIPRE/css/styles/jqx." + theme + ".css";
    var hasStyle = false;
    if (document.styleSheets) {
        $.each(document.styleSheets, function (index, value) {
            if (value.href !== undefined && value.href.indexOf(theme) !== -1) {
                hasStyle = true;
                return false;
            }
        });
    }
    if (!hasStyle) {
        var link = $('<link rel="stylesheet" href="' + url + '" media="screen" />');
        link[0].onload = function () {
            if ($.jqx && $.jqx.ready) {
                $.jqx.ready();
            }
        };
        $(document).find('head').append(link);
    }
    $.jqx = $.jqx || {};
    $.jqx.theme = theme;
    return theme;
}

var theme = 'ui-start';
try {
    if (jQuery) {
        theme = getTheme();
        if (window.location.toString().indexOf('file://') >= 0) {
            var loc = window.location.toString();
            var addMessage = false;
            if (loc.indexOf('grid') >= 0 || loc.indexOf('chart') >= 0 || loc.indexOf('tree') >= 0 || loc.indexOf('list') >= 0 || loc.indexOf('combobox') >= 0 || loc.indexOf('php') >= 0 || loc.indexOf('adapter') >= 0 || loc.indexOf('datatable') >= 0 || loc.indexOf('ajax') >= 0) {
                addMessage = true;
            }
            if (addMessage) {
                $(document).ready(function () {
                    setTimeout(function () {
                        $(document.body).prepend($('<div style="font-size: 12px; font-family: Verdana;">Note: To run a sample that includes data binding, you must open it via "http://..." protocol since Ajax makes http requests.</div><br/>'));
                    }
                    , 50);
                });
            }
        }
    } else {
        $(document).ready(function () {
            theme = getTheme();
        });
    }
} catch (error) {
    var er = error;
}