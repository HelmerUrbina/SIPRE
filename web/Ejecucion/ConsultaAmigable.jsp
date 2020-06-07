<%-- 
    Document   : ConsultaAmigable
    Created on : 08/06/2018, 04:06:45 PM
    Author     : H-URBINA-M
--%>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#cbo_Presupuesto").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 250, dropDownWidth: 350, height: 20});
        $("#cbo_UnidadOperativa").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 180, dropDownWidth: 220, height: 20});
        $("#txt_Glosa").jqxInput({width: 350, height: 20});
        $("#txt_Cobertura").jqxInput({width: 150, height: 20});
        var fecha = new Date();
        $("#cbo_Periodo").jqxComboBox('selectItem', fecha.getFullYear()); 
        $('#cbo_UnidadOperativa').on('change', function () {
            fn_CargarBusqueda();
        });
    });
    function fn_CargarBusqueda() {
        var periodo = $("#cbo_Periodo").val();
        var presupuesto = $("#cbo_Presupuesto").val();
        var unidadOperativa = $("#cbo_UnidadOperativa").val();
        var glosa = $("#txt_Glosa").val();
        var cobertura = $("#txt_Cobertura").val();
        $("#div_GrillaPrincipal").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "GET",
            url: "../ConsultaAmigable",
            data: {mode: "G", periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, glosa: glosa, cobertura: cobertura},
            success: function (data) {
                $contenidoAjax.html(data);
            }
        });
    }
</script>
<div style="border: none;" id='div_Titulo'>
    <div class="jqx-hideborder">CONSULTA DE AMIGABLE</div>
    <div>
        <div id="div_Cabecera">
            <table class="navy">
                <tbody>
                    <tr>
                        <td>Periodo : </td>
                        <td>
                            <select id="cbo_Periodo" name="cbo_Periodo">
                                <option value="%">TODOS</option>
                                <c:forEach var="a" items="${objPeriodo}">
                                    <option value="${a.codigo}">${a.codigo}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td>PPTO. : </td>
                        <td>
                            <select id="cbo_Presupuesto" name="cbo_Presupuesto">
                                <option value="%">TODOS</option>
                                <c:forEach var="b" items="${objPresupuesto}">
                                    <option value="${b.codigo}">${b.descripcion}</option>
                                </c:forEach>
                            </select>
                        </td>  
                        <td>UU/OO : </td>
                        <td>
                            <select id="cbo_UnidadOperativa" name="cbo_UnidadOperativa">
                                <option value="%">TODOS</option>
                                <c:forEach var="c" items="${objUnidadesOperativas}">
                                    <option value="${c.codigo}">${c.descripcion}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td rowspan="2"><a href="javascript: fn_CargarBusqueda();" ><img src="../Imagenes/Botones/refresh42.gif" alt="Buscar Datos" name="imgrefresh" width="30" height="28" border="0" id="imgrefresh"></a></td>
                        <td rowspan="2"><a href="../Login/Principal.jsp" target="_parent"><img src="../Imagenes/Botones/exit42.gif" alt="Salir de pantalla" name="imgexit" width="30" height="28"  border="0" id="imgexit" /></a></td>                        
                    </tr>
                    <tr>
                        <td>Glosa : </td>
                        <td colspan="3">
                            <input type="text" id="txt_Glosa" name="txt_Glosa" style="text-transform: uppercase;"/>
                        </td>
                        <td>Nro SIAF : </td>
                        <td colspan="2">
                            <input type="text" id="txt_Cobertura" name="txt_Cobertura" style="text-transform: uppercase;"/>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="div_Detalle" class="maincen"></div>
    </div>
</div>