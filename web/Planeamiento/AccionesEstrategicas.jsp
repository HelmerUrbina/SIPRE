<%-- 
    Document   : AccionesEstrategicas
    Created on : 02/11/2019, 06:58:39 PM
    Author     : H-URBINA-M
--%>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#cbo_Objetivo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 400, dropDownWidth: 550, height: 20});
        $('#cbo_Periodo').on('change', function () {
            fn_cargarComboxCabecera("#cbo_Objetivo", {mode: 'objetivosEstrategicos', periodo: $("#cbo_Periodo").val()});
        });
        $('#cbo_Objetivo').on('change', function () {
            fn_CargarBusqueda();
        });
        fn_cargarComboxCabecera("#cbo_Objetivo", {mode: 'objetivosEstrategicos', periodo: $("#cbo_Periodo").val()});
    });
    function fn_CargarBusqueda() {
        var msg = "";
        if (msg === "")
            msg = fn_validaCombos('#cbo_Periodo', "Seleccione el Periodo.");
        if (msg === "")
            msg = fn_validaCombos('#cbo_Objetivo', "Seleccione el Objetivo Estrategico.");
        if (msg === "") {
            var periodo = $("#cbo_Periodo").val();
            var objetivo = $("#cbo_Objetivo").val();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../AccionesEstrategicas",
                data: {mode: "G", periodo: periodo, objetivo: objetivo},
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
    <div class="jqx-hideborder">PEI - ACCIONES ESTRATEGICAS INSTITUCIONALES</div>
    <div>
        <div id="div_Cabecera">
            <table class="navy">
                <tbody>
                    <tr>
                        <td>Periodo : </td>
                        <td>
                            <select id="cbo_Periodo" name="cbo_Periodo">
                                <c:forEach var="a" items="${objPeriodo}">
                                    <option value="${a.codigo}">${a.codigo}</option>
                                </c:forEach>
                            </select>
                        </td> 
                        <td>Obj. Estrateg. : </td>
                        <td>
                            <select id="cbo_Objetivo" name="cbo_Objetivo"> 
                                <option value="0">Seleccione</option>
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