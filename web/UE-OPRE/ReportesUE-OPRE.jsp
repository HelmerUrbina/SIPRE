<%-- 
    Document   : ReportesEjecucion
    Created on : 26/12/2017, 08:51:20 AM
    Author     : H-URBINA-M
--%>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var reporte = null;
    var codigo = null;
    var codigo2 = null;
    $(document).ready(function () {
        var source = [
            {id: "UEO0001", label: "1. Avance Ejecución - UE"},
            {id: "UEO0002", label: "2. Resumen - UE"},
            {id: "UEO0003", label: "3. Avance de Ejecución Presupuestal"}
        ];
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#cbo_Presupuesto").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 300, dropDownWidth: 350, height: 20});
        $("#cbo_Generica").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 300, dropDownWidth: 350, height: 20});
        $("#cbo_CategoriaPresupuestal").jqxComboBox({theme: theme, checkboxes: true, autoOpen: true, promptText: "Seleccione", width: 300, dropDownWidth: 450, height: 20});
        $("#cbo_Producto").jqxComboBox({theme: theme, checkboxes: true, autoOpen: true, promptText: "Seleccione", width: 300, dropDownWidth: 450, height: 20});
        var fecha = new Date();
        $("#cbo_Periodo").jqxComboBox('selectItem', fecha.getFullYear());
        $('#cbo_Periodo').on('change', function () {
            $("#cbo_Presupuesto").jqxComboBox('clear');
            fn_cargarComboxCabecera("#cbo_Presupuesto", {mode: 'presupuesto', periodo: $("#cbo_Periodo").val()});
        });
        $('#cbo_Presupuesto').on('change', function () {
            fn_cargarComboxCabecera("#cbo_Generica", {mode: 'genericaUnidad', periodo: $("#cbo_Periodo").val(), presupuesto: $("#cbo_Presupuesto").val(), unidadOperativa: '0003'});
        });
        $('#cbo_Generica').on('change', function () {
            fn_cargarComboxCabecera("#cbo_CategoriaPresupuestal", {mode: 'categoriaPresupuestalEjecucion', periodo: $("#cbo_Periodo").val()});
        });
        $('#cbo_CategoriaPresupuestal').on('checkChange', function (event) {
            if (event.args) {
                var item = event.args.item;
                if (item) {
                    var checkedItems = "";
                    var items = $("#cbo_CategoriaPresupuestal").jqxComboBox('getCheckedItems');
                    $.each(items, function (index) {
                        checkedItems += ", " + this.value;
                    });
                    fn_cargarComboxCabecera("#cbo_Producto", {mode: 'productoTareaEjecucion', periodo: $("#cbo_Periodo").val(), codigo: checkedItems});
                }
            }
        });
        fn_cargarComboxCabecera("#cbo_Generica", {mode: 'genericaUnidad', periodo: $("#cbo_Periodo").val(), presupuesto: $("#cbo_Presupuesto").val(), unidadOperativa: '0003'});
        $('#div_Principal').jqxExpander({showArrow: false, toggleMode: 'none', width: ($(window).width() - 50), height: ($(window).height() - 110)});
        $('#div_Reporte').jqxTree({source: source});
        $('#div_Reporte').on('select', function (event) {
            var args = event.args;
            var item = $('#div_Reporte').jqxTree('getItem', args.element);
            reporte = item.id;
        });
    });
    function fn_CargarReporte() {
        var msg = "";
        switch (reporte) {
            case "UEO0001":
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            case "UEO0003":
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            case "EJE0016":
                break;
            case "EJE0017":
                break;
            case "EJE0018":
                break;
            case "EJE0019":
                break;
            case "EJE0020":
                break;
            case "EJE0021":
                break;
            case "EJE0033":
                codigo = $("#cbo_MesInicial").val();
                codigo2 = $("#cbo_MesFinal").val();
                break;
            case "EJE0034":
                break;
            case "EJE0035":
                break;
            case "EJE0036":
                break;
            case "EJE0037":
                break;
            case "EJE0040":
                break;
            case "EJE0038":
                codigo = $("#cbo_MesInicial").val();
                codigo2 = $("#cbo_MesFinal").val();
                break;
            case "PROG0010":
                if (!autorizacion)
                    msg = "Usuario no Autorizado.";
                break;
            case "EJE0041":
                break;
            case "EJE0045":
                break;
            default:
                msg = "Debe selecciona una opción";
                break;
        }
        if (msg === "") {
            var url = '../Reportes?reporte=' + reporte + '&periodo=' + $("#cbo_Periodo").val() + '&unidadOperativa=' + $("#cbo_UnidadOperativa").val() +
                    '&presupuesto=' + $("#cbo_Presupuesto").val() + '&codigo=' + codigo + '&codigo2=' + codigo2 + '&generica=' + $("#cbo_Generica").val();
            window.open(url, '_blank');
        } else {
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: msg,
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'red',
                typeAnimated: true
            });
        }
    }
</script>
<div style="border: none;" id='div_Titulo'>
    <div class="jqx-hideborder">REPORTES UE-OPRE</div>
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
                        <td>Genérica de Gasto</td>
                        <td>
                            <select id="cbo_Generica" name="cbo_Generica">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>CAT. PPTAL. : </td>
                        <td>
                            <select id="cbo_CategoriaPresupuestal" name="cbo_CategoriaPresupuestal">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                        <td>Producto : </td>
                        <td colspan="3">
                            <select id="cbo_Producto" name="cbo_Producto">
                                <option value="*">TODOS</option>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="div_Detalle" class="maincen">
            <div id='div_Principal' style="margin: 15px">
                <div>
                    <div> LISTADO DE REPORTES - <a href="javascript: fn_CargarReporte();" ><img src="../Imagenes/Botones/printer42.gif" name="imgrefresh" width="30" height="28" border="0" id="imgrefresh"></a> </div>
                </div>
                <div style="overflow: hidden;">
                    <div style="border: none;" id='div_Reporte'>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>