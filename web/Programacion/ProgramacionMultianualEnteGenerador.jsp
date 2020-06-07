<%-- 
    Document   : ProgramacionMultianualEnteGenerador
    Created on : 09/03/2017, 10:49:34 AM
    Author     : H-URBINA-M
--%>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#cbo_Presupuesto").jqxComboBox({theme: theme, promptText: "Seleccione", width: 350, dropDownWidth: 350, height: 20});
        $("#cbo_UnidadOperativa").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 200, dropDownWidth: 220, height: 20});
        $('#cbo_Periodo').on('change', function () {
            fn_CargarBusqueda();
        });
        $('#cbo_Presupuesto').on('change', function () {
            fn_CargarBusqueda();
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
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../ProgramacionMultianualEnteGenerador",
                data: {mode: "G", periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
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
    <div class="jqx-hideborder">PROGRAMACIÓN MULTIANUAL DE INGRESOS</div>
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
                                <option value="6">6:RECURSOS DIRECTAMENTE RECAUDADOS</option>
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
                        <td><a href="javascript: fn_CargarBusqueda();" ><img src="../Imagenes/Botones/refresh42.gif" alt="Buscar Datos" name="imgrefresh" width="30" height="28" border="0" id="imgrefresh"></a></td>
                        <td><a href="../Login/Principal.jsp" target="_parent"><img src="../Imagenes/Botones/exit42.gif" alt="Salir de pantalla" name="imgexit" width="30" height="28"  border="0" id="imgexit" /></a></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="div_Detalle" class="maincen"></div>
    </div>
</div>
