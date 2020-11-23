<%-- 
    Document   : Tareas
    Created on : 09/05/2017, 10:39:55 AM
    Author     : H-URBINA-M
--%>

<!DOCTYPE html>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        fn_CargarBusqueda();
    });
    function fn_CargarBusqueda() {
        $("#div_GrillaPrincipal").remove();
        $("#div_VentanaPrincipal").remove();
        $("#div_ContextMenu").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "GET",
            url: "../Tareas",
            data: {mode: "G"},
            success: function (data) {
                $contenidoAjax.html(data);
            }
        });
    }
</script>
<div style="border: none;" id='div_Titulo'>
    <div class="jqx-hideborder">LISTADOS DE TAREAS PRESUPUESTALES</div>
    <div>
        <div id="div_Detalle" class="maincen"></div>
    </div>
</div>