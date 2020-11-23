<%-- 
    Document   : ConceptoIngresos
    Created on : 17/02/2017, 02:34:00 PM
    Author     : H-TECCSI-V
--%>
<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#cbo_Concepto").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 400, dropDownWidth: 350, height: 20});
        $('#cbo_Periodo').on('change', function () {
            fn_CargarBusqueda();
        });
        $('#cbo_Concepto').on('change', function () {
            fn_CargarBusqueda();
        });
        fn_CargarBusqueda();
    });
    function fn_CargarBusqueda() {
        var msg = "";
        if (msg === "") {
            var periodo = $("#cbo_Periodo").val();
            var codConcepto=$("#cbo_Concepto").val();
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_GrillaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../ConceptoIngresos",
                data: {mode: "G",codConcepto: codConcepto,periodo: periodo},
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
    <div class="jqx-hideborder">CONCEPTO REMUNERACIONES</div>
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
                         <td>Concepto : </td>
                        <td>
                            <select id="cbo_Concepto" name="cbo_Concepto">
                                <c:forEach var="a" items="${objListaConceptos}">
                                    <option value="${a.codigo}">${a.descripcion}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="div_Detalle" class="maincen"></div>
    </div>
</div>