<%-- 
    Document   : TransferirCobertura
    Created on : 05/03/2018, 05:05:43 PM
    Author     : H-TECCSI-V
--%>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20, disabled: true});
        $("#cbo_Presupuesto").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 320, dropDownWidth: 320, height: 20});
        $("#txt_CobInicial").jqxInput({placeHolder: "Cobertura Inicial", width: 150, height: 20, maxLength: 8});
        $("#txt_CobFinal").jqxInput({placeHolder: "Cobertura Final", width: 150, height: 20, maxLength: 8});
        var fecha = new Date();
        $("#cbo_Periodo").jqxComboBox('selectItem', fecha.getFullYear());
        $('#cbo_Periodo').on('change', function () {
            fn_CargarBusqueda();
        });
        $('#cbo_Presupuesto').on('change', function () {
            fn_CargarBusqueda();
        });
    });
    function fn_verificarCobInicial() {
        var msg = "";
        var dato = "";
        dato = $("#txt_CobInicial").val();
        if (dato === "" || dato.length === 0 || dato === null) {
            msg = "Ingrese la coberura inicial";
            return msg;
        } else {
            return "";
        }
    }
    function fn_verificarCobFinal() {
        var msg = "";
        var dato = "";
        dato = $("#txt_CobFinal").val();
        if (dato === "" || dato.length === 0 || dato === null) {
            msg = "Ingrese la coberura final";
            return msg;
        } else {
            return "";
        }
    }
    function fn_CargarBusqueda() {
        var msg = "";
        if (msg === "")
            msg = fn_validaCombos('#cbo_Periodo', "Seleccione el Periodo.");
        if (msg === "")
            msg = fn_validaCombos('#cbo_Presupuesto', "Seleccione la Fuente de Financiamiento.");
        if (msg === "")
            msg = fn_verificarCobInicial();
        if (msg === "")
            msg = fn_verificarCobFinal();
        if (msg === "") {
            var periodo = $("#cbo_Periodo").val();
            var presupuesto = $("#cbo_Presupuesto").val();
            var coberturaInicial = $("#txt_CobInicial").val();
            var coberturaFinal = $("#txt_CobFinal").val();

            $("#div_GrillaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../TransferirCobertura",
                data: {mode: "G", periodo: periodo, presupuesto: presupuesto, coberturaInicial: coberturaInicial, coberturaFinal: coberturaFinal},
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
    <div class="jqx-hideborder">TRANSFERIR COBERTURAS</div>
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
                                <c:forEach var="c" items="${objPresupuesto}">
                                    <option value="${c.codigo}">${c.descripcion}</option>
                                </c:forEach>
                            </select>
                        </td>                   
                        <td><a href="javascript: fn_CargarBusqueda();" ><img src="../Imagenes/Botones/refresh42.gif" alt="Buscar Datos" name="imgrefresh" width="30" height="28" border="0" id="imgrefresh"></a></td>
                        <td><a href="../Login/Principal.jsp" target="_parent"><img src="../Imagenes/Botones/exit42.gif" alt="Salir de pantalla" name="imgexit" width="30" height="28"  border="0" id="imgexit" /></a></td>
                    </tr>
                    <tr>
                        <td>Cobertura Inicial: </td>
                        <td>
                            <input type="text" id="txt_CobInicial" name="txt_CobInicial" style="text-transform: uppercase;"/>
                        </td>
                        <td>Cobertura Final: </td>
                        <td>
                            <input type="text" id="txt_CobFinal" name="txt_CobFinal" style="text-transform: uppercase;"/>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="div_Detalle" class="maincen"></div>
    </div>
</div>
