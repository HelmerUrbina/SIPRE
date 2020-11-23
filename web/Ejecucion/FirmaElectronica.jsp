<%-- 
    Document   : FirmaElectronica
    Created on : 31/08/2017, 02:17:42 PM
    Author     : H-URBINA-M
--%>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#cbo_Presupuesto").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 200, dropDownWidth: 350, height: 20});
        $("#cbo_Estado").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 120, dropDownWidth: 180, height: 20});
        $("#cbo_opcion").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 200, dropDownWidth: 250, height: 20});
        var fecha = new Date();
        $("#cbo_Periodo").jqxComboBox('selectItem', fecha.getFullYear());
        $('#cbo_Periodo').on('change', function () {
            fn_CargarBusqueda();
        });
        $('#cbo_Presupuesto').on('change', function () {
            fn_CargarBusqueda();
        });
        $('#cbo_opcion').on('change', function () {
            fn_CargarBusqueda();
        });
        $('#cbo_Estado').on('change', function () {
            fn_CargarBusqueda();
        });
    });
    function fn_CargarBusqueda() {
        var periodo = $("#cbo_Periodo").val();
        var presupuesto = $("#cbo_Presupuesto").val();
        var opcion = $("#cbo_opcion").val();
        var estado = $("#cbo_Estado").val();
        var msg = "";
        if (msg === "")
            msg = fn_validaCombos('#cbo_opcion', "Seleccione la Opcion a realizar.");
        if (msg === "") {
            $("#div_GrillaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../FirmaElectronica",
                data: {mode: opcion, periodo: periodo, presupuesto: presupuesto, estado: estado},
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
    <div class="jqx-hideborder">FIRMA ELECTRONICA</div>
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
                        <td>PPTO. : </td>
                        <td>
                            <select id="cbo_Presupuesto" name="cbo_Presupuesto">
                                <c:forEach var="b" items="${objPresupuesto}">
                                    <option value="${b.codigo}">${b.descripcion}</option>
                                </c:forEach>
                            </select>
                        </td>  
                        <td>Estado : </td>
                        <td>
                            <select id="cbo_Estado" name="cbo_Estado">
                                <option value="IS NULL" selected="selected">PENDIENTE</option>
                                <option value="IS NOT NULL" >ATENDIDO</option>
                            </select>
                        </td>
                        <td>Opcion: </td>
                        <td>
                            <select id="cbo_opcion" name="cbo_opcion">
                                <option value="0">Seleccione</option>
                                <option value="CP">Certificación Presupuestal</option>
                                <option value="CA">Compromiso Anual</option>
                                <option value="DJ">Declaracion Jurada</option>
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