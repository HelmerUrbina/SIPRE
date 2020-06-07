<%-- 
    Document   : ConsultaPersonal
    Created on : 01/03/2018, 10:21:43 AM
    Author     : H-TECCSI-V
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#txt_Nombres").jqxInput({placeHolder: "Ingrese los apellidos y nombres", width: 350, height: 20});
        $('#cbo_Periodo').on('change', function () {
            fn_CargarBusqueda();
        });
    });
    function fn_verificarNombres() {
        var msg = "";
        var dato = "";
        dato = $("#txt_Nombres").val();
        if (dato === "" || dato.length === 0 || dato === null) {
            msg = "Ingrese los apellidos y nombres del personal";
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
            msg = fn_verificarNombres();
        if (msg === "") {
            var periodo = $("#cbo_Periodo").val();
            var nombres = $("#txt_Nombres").val();
            $("#div_GrillaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../ConsultaDerechoPersonal",
                data: {mode: "G", periodo: periodo, codigo: nombres},
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
    <div class="jqx-hideborder">CONSULTA DERECHO PERSONAL</div>
    <div>
        <div id="div_Cabecera">
            <table class="navy">                
                <tbody>
                    <tr>
                        <td>Periodo : </td>
                        <td>
                            <select id="cbo_Periodo" name="cbo_Periodo">
                                <option value="*" selected>TODOS</option>
                                <c:forEach var="a" items="${objPeriodo}">
                                    <option value="${a.codigo}">${a.codigo}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td>Apellidos y Nombres: </td>
                        <td>
                            <input type="text" id="txt_Nombres" name="txt_Nombres" style="text-transform: uppercase;"/>
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

