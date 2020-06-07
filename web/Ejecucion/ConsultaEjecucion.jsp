<%-- 
    Document   : ConsultaEjecucion
    Created on : 27/03/2018, 10:34:10 AM
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
        $("#cbo_CategoriaPresupuestal").jqxComboBox({theme: theme, checkboxes: true, autoOpen: true, promptText: "Seleccione", width: 300, dropDownWidth: 450, height: 20});
        $("#cbo_Producto").jqxComboBox({theme: theme, checkboxes: true, autoOpen: true, promptText: "Seleccione", width: 300, dropDownWidth: 450, height: 20});
        $("#chk_pip").jqxCheckBox({width: 120, height: 25});
        var fecha = new Date();
        $("#cbo_Periodo").jqxComboBox('selectItem', fecha.getFullYear());
        $('#cbo_Periodo').on('change', function () {
            fn_cargarComboxCabecera("#cbo_CategoriaPresupuestal", {mode: 'categoriaPresupuestalEjecucion', periodo: $("#cbo_Periodo").val()});
        });
        $('#cbo_Presupuesto').on('change', function () {
            fn_CargarBusqueda();
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
        $('#chk_pip').on('change', function (event) {
            var checked = event.args.checked;
            if (checked) {
                $("#cbo_CategoriaPresupuestal").jqxComboBox('uncheckAll');
                $("#cbo_Producto").jqxComboBox('uncheckAll');
                $("#cbo_CategoriaPresupuestal").jqxComboBox({disabled: true, autoOpen: false});
                $("#cbo_Producto").jqxComboBox({disabled: true, autoOpen: false});
            } else {
                $("#cbo_CategoriaPresupuestal").jqxComboBox({disabled: false, autoOpen: true});
                $("#cbo_Producto").jqxComboBox({disabled: false, autoOpen: true});
            }
        });
        fn_cargarComboxCabecera("#cbo_CategoriaPresupuestal", {mode: 'categoriaPresupuestalEjecucion', periodo: $("#cbo_Periodo").val()});
    });
    function fn_CargarBusqueda() {
        var periodo = $("#cbo_Periodo").val();
        var presupuesto = $("#cbo_Presupuesto").val();
        var categoriaPresupuestal = "";
        var producto = "";
        var pip = $("#chk_pip").val();
        if (pip) {
            categoriaPresupuestal = "";
            producto = "";
        } else {
            var itemsCategoria = $("#cbo_CategoriaPresupuestal").jqxComboBox('getCheckedItems');
            $.each(itemsCategoria, function (index) {
                categoriaPresupuestal += ", " + this.value;
            });
            var itemsProducto = $("#cbo_Producto").jqxComboBox('getCheckedItems');
            $.each(itemsProducto, function (index) {
                producto += ", " + this.value;
            });
        }
        $("#div_GrillaPrincipal").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "GET",
            url: "../ConsultaEjecucion",
            data: {mode: "G", periodo: periodo, presupuesto: presupuesto, pip: pip, categoriaPresupuestal: categoriaPresupuestal, producto: producto},
            success: function (data) {
                $contenidoAjax.html(data);
            }
        });
    }
</script>
<div style="border: none;" id='div_Titulo'>
    <div class="jqx-hideborder">CONSULTA DE EJECUCIÓN PRESUPUESTAL</div>
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
                                <option value="0">Todos</option>
                                <c:forEach var="b" items="${objPresupuesto}">
                                    <option value="${b.codigo}">${b.descripcion}</option>
                                </c:forEach>
                            </select>
                        </td>  
                        <td>CAT. PPTAL. : </td>
                        <td>
                            <select id="cbo_CategoriaPresupuestal" name="cbo_CategoriaPresupuestal">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                        <td rowspan="2"><a href="javascript: fn_CargarBusqueda();" ><img src="../Imagenes/Botones/refresh42.gif" alt="Buscar Datos" name="imgrefresh" width="30" height="28" border="0" id="imgrefresh"></a></td>
                        <td rowspan="2"><a href="../Login/Principal.jsp" target="_parent"><img src="../Imagenes/Botones/exit42.gif" alt="Salir de pantalla" name="imgexit" width="30" height="28"  border="0" id="imgexit" /></a></td>                        
                    </tr>
                    <tr>
                        <td>Producto : </td>
                        <td colspan="3">
                            <select id="cbo_Producto" name="cbo_Producto">
                                <option value="*">TODOS</option>
                            </select>
                        </td>
                        <td colspan="2">
                            <div id='chk_pip' style='margin-left: 10px; float: left;'>Solo PIP's</div>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="div_Detalle" class="maincen"></div>
    </div>
</div>