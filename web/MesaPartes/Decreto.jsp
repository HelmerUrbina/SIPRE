<%-- 
    Document   : Decreto
    Created on : 20/07/2017, 10:50:15 AM
    Author     : H-TECCSI-V
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#cbo_Mes").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#cbo_Estado").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 120, dropDownWidth: 150, height: 20});
        var fecha = new Date();
        $("#cbo_Periodo").jqxComboBox('selectItem', fecha.getFullYear());
        $("#cbo_Mes").jqxComboBox('selectIndex', fecha.getMonth());
        $('#cbo_Periodo').on('change', function () {
            fn_CargarBusqueda();
        });
        $('#cbo_Mes').on('change', function () {
            fn_CargarBusqueda();
        });
        $('#cbo_Estado').on('change', function () {
            fn_CargarBusqueda();
        });
        fn_CargarBusqueda();
    });
    function fn_CargarBusqueda() {
        var msg = "";
        if (msg === "")
            msg = fn_validaCombos('#cbo_Periodo', "Seleccione el Periodo.");
        if (msg === "")
            msg = fn_validaCombos('#cbo_Tipo', "Seleccione el Tipo.");
        if (msg === "")
            msg = fn_validaCombos('#cbo_Mes', "Seleccione el Mes.");
        if (msg === "")
            msg = fn_validaCombos('#cbo_Estado', "Seleccione el Estado.");
        if (msg === "") {
            var periodo = $("#cbo_Periodo").val();
            var tipo = 'E';
            var mes = $("#cbo_Mes").val();
            var estado = $("#cbo_Estado").val();
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#cbo_Ajax").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../Decreto",
                data: {mode: "G", periodo: periodo, mes: mes, tipo: tipo, estadoDoc: estado},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        } else {
            $.alert({
                theme: 'material',
                title: 'Alerta!',
                content: msg,
                boxWidth: '50%'});
        }
    }
</script>
<div style="border: none;" id='div_Titulo'>
    <div class="jqx-hideborder">DECRETO DOCUMENTACIÓN</div>
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
                        <td>Estado : </td>
                        <td>
                            <select id="cbo_Estado" name="cbo_Estado">
                                <option value="PE">PENDIENTE</option>
                                <option value="DE">DECRETADO</option>
                                <option value="RE">RECIBIDO</option>
                                <option value="RS">RESPONDIDO</option>
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