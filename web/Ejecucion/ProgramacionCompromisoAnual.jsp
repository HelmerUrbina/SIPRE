<%-- 
    Document   : ProgramacionCompromisoAnual
    Created on : 02/01/2020, 01:44:07 PM
    Author     : H-URBINA-M
--%>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var unidad = '${unidad}';
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#cbo_Presupuesto").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 300, dropDownWidth: 350, height: 20});
        $("#cbo_UnidadOperativa").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 200, dropDownWidth: 250, height: 20});
        var fecha = new Date();
        $("#cbo_Periodo").jqxComboBox('selectItem', fecha.getFullYear());
        $('#cbo_Periodo').on('change', function () {
            if (unidad === '0003') {
                $("#cbo_Presupuesto").jqxComboBox('clear');
                $("#cbo_UnidadOperativa").jqxComboBox('clear');
                fn_cargarComboxCabecera("#cbo_Presupuesto", {mode: 'presupuesto', periodo: $("#cbo_Periodo").val()});
            } else {
                fn_CargarBusqueda();
            }
        });
        $('#cbo_Presupuesto').on('change', function () {
            if (unidad === '0003') {
                $("#cbo_UnidadOperativa").jqxComboBox('clear');
                fn_cargarComboxCabecera("#cbo_UnidadOperativa", {mode: 'unidadOperativa', periodo: $("#cbo_Periodo").val(), presupuesto: $("#cbo_Presupuesto").val()});
            } else {
                fn_CargarBusqueda();
            }
        });
        $('#cbo_UnidadOperativa').on('change', function () {
            fn_CargarBusqueda();
        });
        fn_CargarBusqueda();
    });
    function fn_CargarBusqueda() {
        var msg = "";
        if (msg === "")
            msg = fn_validaCombos('#cbo_Periodo', "Seleccione el Periodo.");
        if (msg === "")
            msg = fn_validaCombos('#cbo_Presupuesto', "Seleccione la Fuente de Financiamiento.");
        if (msg === "")
            msg = fn_validaCombos('#cbo_UnidadOperativa', "Seleccione la Unidad Operativa.");
        if (msg === "") {
            var periodo = $("#cbo_Periodo").val();
            var presupuesto = $("#cbo_Presupuesto").val();
            var unidadOperativa = $("#cbo_UnidadOperativa").val();
            $("#div_ContextMenu").remove();
            $("#div_Mensualizar").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaPCA").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../ProgramacionCompromisoAnual",
                data: {mode: "G", periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        } else {
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: msg,
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'blue',
                typeAnimated: true
            });
        }
    }
</script>
<div style="border: none;" id='div_Titulo'>
    <div class="jqx-hideborder">PROGRAMACIÓN DE COMPROMISO ANUAL</div>
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
                        <td>Fte. Financ. : </td>
                        <td>
                            <select id="cbo_Presupuesto" name="cbo_Presupuesto">
                                <c:forEach var="b" items="${objPresupuesto}">
                                    <option value="${b.codigo}">${b.descripcion}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td>UU.OO. : </td>
                        <td>
                            <select id="cbo_UnidadOperativa" name="cbo_UnidadOperativa">
                                <c:forEach var="c" items="${objUnidadesOperativas}">
                                    <option value="${c.codigo}">${c.descripcion}</option>
                                </c:forEach>
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