<%-- 
    Document   : Clasificadores
    Created on : 10/05/2017, 03:51:22 PM
    Author     : OPRE
--%>

<!DOCTYPE html>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        fn_CargarBusqueda();
    });
    function fn_CargarBusqueda() {
        $("#div_VentanaPrincipal").remove();
        $("#div_ContextMenu").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "GET",
            url: "../Clasificadores",
            data: {mode: "G"},
            success: function (data) {
                $contenidoAjax.html(data);
            }
        });
    }
</script>
<div style="border: none;" id='div_Titulo'>
    <div class="jqx-hideborder">LISTADOS DE CLASIFICADORES PRESUPUESTALES</div>
    <div>        
        <div id="div_Detalle" class="maincen"></div>
    </div>
</div>