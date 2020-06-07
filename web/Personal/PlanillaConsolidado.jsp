<%-- 
    Document   : PlanillaConsolidado
    Created on : 31/01/2018, 02:28:07 PM
    Author     : hateccsiv
--%>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#cbo_Mes").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 220, height: 20});
        var fecha = new Date();
        $("#cbo_Periodo").jqxComboBox('selectItem', fecha.getFullYear());
        $("#cbo_Mes").jqxComboBox('selectIndex', fecha.getMonth());
        $('#cbo_Periodo').on('change', function () {
            fn_CargarBusqueda();
        });
        $('#cbo_Mes').on('change', function () {
            fn_CargarBusqueda();
        });
        fn_CargarBusqueda();
    });
    function fn_CargarBusqueda() {
        var msg = "";
        if (msg === "")
            msg = fn_validaCombos('#cbo_Periodo', "Seleccione el Periodo.");
        if (msg === "")
            msg = fn_validaCombos('#cbo_Mes', "Seleccione el Mes.");
        if (msg === "") {
            var periodo = $("#cbo_Periodo").val();
            var mes = $("#cbo_Mes").val();
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_GrillaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../PlanillaConsolidado",
                data: {mode: "G", periodo: periodo, mes: mes},
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
    <div class="jqx-hideborder">CONSOLIDADO PLANILLA MOVILIDAD</div>
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
                        <td>Mes : </td>
                        <td>
                            <select id="cbo_Mes" name="cbo_Mes">
                                <c:forEach var="c" items="${objMes}">
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
