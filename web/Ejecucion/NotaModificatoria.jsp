<%-- 
    Document   : NotaModificatoria
    Created on : 31/07/2017, 04:27:49 PM
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
        $("#cbo_UnidadOperativa").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 180, dropDownWidth: 220, height: 20});
        $("#cbo_Mes").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 180, dropDownWidth: 220, height: 20});
        var fecha = new Date();
        $("#cbo_Periodo").jqxComboBox('selectItem', fecha.getFullYear());
        $("#cbo_Mes").jqxComboBox('selectIndex', fecha.getMonth());
        $('#cbo_Periodo').on('change', function () {
            if (unidad === '0003') {
                $("#cbo_UnidadOperativa").jqxComboBox('clear');
                fn_cargarComboxCabecera("#cbo_UnidadOperativa", {mode: 'unidadOperativa', periodo: $("#cbo_Periodo").val(), presupuesto: "0"});
            } else {
                fn_CargarBusqueda();
            }
        });
        $('#cbo_UnidadOperativa').on('change', function () {
            fn_CargarBusqueda();
        });
        $('#cbo_Mes').on('change', function () {
            fn_CargarBusqueda();
        });
        if (unidad === '0003') {
            $("#cbo_UnidadOperativa").jqxComboBox('clear');
            fn_cargarComboxCabecera("#cbo_UnidadOperativa", {mode: 'unidadOperativa', periodo: $("#cbo_Periodo").val(), presupuesto: "0"});
        } else {
            fn_CargarBusqueda();
        }
    });
    function fn_CargarBusqueda() {
        var periodo = $("#cbo_Periodo").val();
        var unidadOperativa = $("#cbo_UnidadOperativa").val();
        var mes = $("#cbo_Mes").val();
        var msg = "";
        if (msg === "")
            msg = fn_validaCombos('#cbo_UnidadOperativa', "Seleccione la Unidad Operativa.");
        if (msg === "")
            msg = fn_validaCombos('#cbo_Mes', "Seleccione el Mes.");
        if (msg === "") {
            $("#div_ContextMenu").remove();
            $("#div_RegistroDetalle").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_VentanaMetaFisica").remove();
            $("#div_VentanaInforme").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../NotaModificatoria",
                data: {mode: "G", periodo: periodo, unidadOperativa: unidadOperativa, mes: mes},
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
                type: 'orange',
                typeAnimated: true
            });
        }
    }
</script>
<div style="border: none;" id='div_Titulo'>
    <div class="jqx-hideborder">REGISTRO DE NOTAS MODIFICATORIAS</div>
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
                        <td>UU/OO : </td>
                        <td>
                            <select id="cbo_UnidadOperativa" name="cbo_UnidadOperativa">
                                <c:forEach var="c" items="${objUnidadesOperativas}">
                                    <option value="${c.codigo}">${c.descripcion}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td>Mes : </td>
                        <td>
                            <select id="cbo_Mes" name="cbo_Mes">
                                <c:forEach var="d" items="${objMes}">
                                    <option value="${d.codigo}" >${d.descripcion}</option>
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