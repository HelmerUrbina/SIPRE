<%-- 
    Document   : TipoDocumento
    Created on : 26/07/2017, 12:08:42 PM
    Author     : H-TECCSI-V
--%>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        fn_CargarBusqueda();
    });
    function fn_CargarBusqueda() {
        var msg = "";
        if (msg === "") {
            $("#div_ContextMenu").remove();
            $("#div_VentanaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../TipoDocumento",
                data: {mode: "G", codigo: '0'},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        } else {
            $.alert({theme: 'material', title: 'Alerta!', content: msg, boxWidth: '50%'});
        }
    }
</script>
<div style="border: none;" id='div_Titulo'>
    <div class="jqx-hideborder">TIPO DOCUMENTO</div>
    <div>
        <div id="div_Cabecera"></div>
        <div id="div_Detalle" class="maincen"></div>
    </div>
</div>