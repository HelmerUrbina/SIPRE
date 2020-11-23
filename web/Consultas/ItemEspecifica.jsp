<%-- 
    Document   : ItemEspecifica
    Created on : 23/05/2017, 10:11:26 AM
    Author     : H-URBINA-M
--%>

<!DOCTYPE html>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_CadenaGasto").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 350, dropDownWidth: 500, height: 20});
        $('#cbo_CadenaGasto').on('change', function () {
            fn_CargarBusqueda();
        });
        fn_cargarComboxCabecera("#cbo_CadenaGasto", {mode: 'cadenaGasto'});
    });
    function fn_CargarBusqueda() {
        var msg = "";
        if (msg === "")
            msg = fn_validaCombos('#cbo_CadenaGasto', "Seleccione la Unidad Operativa.");
        if (msg === "") {
            var cadenaGasto = $("#cbo_CadenaGasto").val();
            $("#div_ContextMenu").remove();
            $("#div_VentanaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../ItemEspecifica",
                data: {mode: "G", cadenaGasto: cadenaGasto},
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
    <div class="jqx-hideborder">LISTADOS DE ITEM - ESPECIFICA DE GASTO</div>
    <div>
        <div id="div_Cabecera">
            <table class="navy">
                <tbody>
                    <tr>
                        <td>Cadena Gasto : </td>
                        <td>
                            <select id="cbo_CadenaGasto" name="cbo_CadenaGasto">
                                <c:forEach var="c" items="${objCadenaGasto}">
                                    <option value="${c.codigo}">${c.descripcion}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td><a href="javascript: fn_CargarBusqueda();"><img src="../Imagenes/Botones/refresh42.gif" alt="Buscar Datos" name="imgrefresh" width="30" height="28" border="0" id="imgrefresh"></a></td>
                        <td><a href="javascript: fn_MenuPrincipal();"><img src="../Imagenes/Botones/exit42.gif" alt="Salir de pantalla" name="imgexit" width="30" height="28"  border="0" id="imgexit" /></a></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="div_Detalle" class="maincen"></div>
    </div>
</div>