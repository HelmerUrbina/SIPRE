<%-- 
    Document   : Institucion
    Created on : 26/07/2017, 09:23:52 AM
    Author     : H-TECCSI-V
--%>
<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Organismo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 250, dropDownWidth: 250, height: 20});
        $('#cbo_Organismo').on('change', function () {
            fn_CargarBusqueda();
        });
        fn_CargarBusqueda();
    });
    function fn_CargarBusqueda() {
        var msg = "";
        if (msg === "")
            msg = fn_validaCombos('#cbo_Organismo', "Seleccione el Organismo Público.");
        if (msg === "") {
            var organismo = $("#cbo_Organismo").val();
            $("#div_ContextMenu").remove();
            $("#div_VentanaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../Institucion",
                data: {mode: "G", organismo: organismo},
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
    <div class="jqx-hideborder">ORGANISMO - INSTITUCIÓN</div>
    <div>
        <div id="div_Cabecera">
            <table class="navy">                
                <tbody>
                    <tr>                       
                        <td>Organismo: </td>
                        <td>
                            <select id="cbo_Organismo" name="cbo_Organismo">
                                <option value="01">INSTITUCIÓN DEL EJERCITO</option>
                            </select>
                        </td>           
                        <td><a href="javascript: fn_CargarBusqueda();" ><img src="../Imagenes/Botones/refresh42.gif" alt="Buscar Datos" name="imgrefresh" width="30" height="28" border="0" id="imgrefresh"></a></td>
                        <td><a href="../Login/Principal.jsp" target="_parent"><img src="../Imagenes/Botones/exit42.gif" alt="Salir de pantalla" name="imgexit" width="30" height="28"  border="0" id="imgexit" /></a></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="div_Detalle" class="maincen"></div>
    </div>
</div>