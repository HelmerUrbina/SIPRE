<%-- 
    Document   : Item
    Created on : 21/09/2017, 04:31:13 PM
    Author     : H-URBINA-M
--%>

<!DOCTYPE html>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#txt_Buscar").jqxInput({placeHolder: "BUSCAR ITEM", height: 20, width: 400, minLength: 5, maxLength: 100});
        $('#txt_Buscar').on('change', function () {
            fn_ValidaBusqueda();
        });
    });
    function fn_ValidaBusqueda() {
        var busqueda = $('#txt_Buscar').val();
        if (busqueda.length >= 4) {
            fn_CargarBusqueda();
        } else {
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: "Debe ingresar más carateres de busqueda",
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'red',
                typeAnimated: true
            });
        }
    }
    function fn_CargarBusqueda() {
        $("#div_GrillaPrincipal").remove();
        $("#div_VentanaPrincipal").remove();
        $("#div_ContextMenu").remove();
        var busqueda = $('#txt_Buscar').val();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "GET",
            url: "../Item",
            data: {mode: "G", item: busqueda},
            success: function (data) {
                $contenidoAjax.html(data);
            }
        });
    }
</script>
<div style="border: none;" id='div_Titulo'>
    <div class="jqx-hideborder">LISTADOS DE ITEM</div>
    <div>
        <div id="div_Cabecera">
            <table class="navy">                
                <tbody>
                    <tr>
                        <td>Item : </td>
                        <td>
                            <input type="text" id="txt_Buscar" name="txt_Buscar" style="text-transform: uppercase;"/>
                        </td>
                        <td><a href="javascript: fn_ValidaBusqueda();"><img src="../Imagenes/Botones/refresh42.gif" alt="Buscar Datos" name="imgrefresh" width="30" height="28" border="0" id="imgrefresh"></a></td>
                        <td><a href="../Login/Principal.jsp" target="_parent"><img src="../Imagenes/Botones/exit42.gif" alt="Salir de pantalla" name="imgexit" width="30" height="28"  border="0" id="imgexit" /></a></td>                        
                    </tr>
                </tbody>
            </table>
        </div>

        <div id="div_Detalle" class="maincen"></div>
    </div>
</div>
