<%-- 
    Document   : ListaHojaTrabajo
    Created on : 06/02/2017, 09:40:17 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnHojaTrabajo.periodo}';
    var presupuesto = '${objBnHojaTrabajo.presupuesto}';
    var unidadOperativa = '${objBnHojaTrabajo.unidadOperativa}';
    var tarea = '${objBnHojaTrabajo.tarea}';
    var eventoPrincipal = '${objBnHojaTrabajo.eventoPrincipal}';
    var eventoFinal = '${objBnHojaTrabajo.eventoFinal}';
    var codigo = '${objBnHojaTrabajo.correlativo}';
    var nivel = '${objBnHojaTrabajo.nivel}';
    var tareaDescripcion = '${objBnHojaTrabajo.descripcion}';
    var dependencia = '${objBnHojaTrabajo.dependencia}';
    var codigoItem = null;
    var mode = null;
    var lista = new Array();
    <c:forEach var="d" items="${objHojaTrabajo}">
    var result = {codigo: '${d.correlativo}', item: '${d.item}', unidadMedida: '${d.unidadMedida}', precio: '${d.precio}',
        cantidad: '${d.cantidad}', total: '${d.total}', cadenaGasto: '${d.cadenaGasto}', genericaGasto: '${d.genericaGasto}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA DE LA CABECERA  
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "item", type: "string"},
                        {name: "unidadMedida", type: "string"},
                        {name: "precio", type: "number"},
                        {name: "cantidad", type: "number"},
                        {name: "total", type: "number"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "genericaGasto", type: "string"}
                    ],
            root: "HojaTrabajo",
            record: "HojaTrabajo",
            id: 'codigo'
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "codigo" || datafield === "total") {
                return "RowBold";
            }
            if (datafield === "precio") {
                return "RowBlue";
            }
            if (datafield === "cantidad") {
                return "RowGreen";
            }
        };
        $("#div_GrillaHojaTrabajo").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 60),
            source: sourceCab,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            editable: false,
            showstatusbar: true,
            showtoolbar: true,
            showaggregates: true,
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonCargar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonReporte = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonCargar);
                container.append(ButtonExportar);
                container.append(ButtonReporte);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonCargar.jqxButton({width: 30, height: 22});
                ButtonCargar.jqxTooltip({position: 'bottom', content: "Actualiza Pantalla"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonReporte.jqxButton({width: 30, height: 22});
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reporte"});
                // Adicionar un Nuevo Registro en la Cabecera.
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    codigo = 0;
                    codigoItem = null;
                    fn_NuevoRegistroHojaTrabajo();
                });
                // Recarga la Data en la Grilla
                ButtonCargar.click(function (event) {
                    fn_Refrescar();
                });
                //export to excel
                ButtonExportar.click(function (event) {
                    $("#div_GrillaHojaTrabajo").jqxGrid('exportdata', 'xls', 'CNVHojaTrabajo');
                });
                //reporte
                ButtonReporte.click(function (event) {
                    var url = '../Reportes?reporte=PROG0003&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto + '&codigo=' + eventoPrincipal + '&codigo2=' + eventoFinal;
                    window.open(url, '_blank');
                });
            },
            columns: [
                {
                    text: 'N°', sortable: false, filterable: false, editable: false, align: 'center',
                    groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', pinned: true,
                    cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'ITEM', dataField: 'item', columngroup: 'Tarea', width: '40%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'UU/MM', dataField: 'unidadMedida', columngroup: 'EventoPrincipal', width: '8%', filtertype: 'checkedlist', align: 'center', cellsAlign: 'center', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'CANTIDAD', dataField: 'cantidad', columngroup: 'EventoPrincipal', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'VAL. REF.', dataField: 'precio', columngroup: 'EventoPrincipal', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'TOTAL', dataField: 'total', columngroup: 'EventoFinal', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CADENA GASTO', dataField: 'cadenaGasto', columngroup: 'EventoFinal', width: '26%', filtertype: 'checkedlist', align: 'center', cellsAlign: 'left', cellclassname: cellclass}
            ],
            columngroups: [
                {text: '<strong>CUADRO DE NECESIDADES VALORIZADA</strong>', name: 'Titulo', align: 'center'},
                {text: '<strong>TAREA : </strong>' + tareaDescripcion, name: 'Tarea', parentgroup: 'Titulo', height: '52px'},
                {text: '<strong>EVENTO : </strong>' + eventoPrincipal, name: 'EventoPrincipal', parentgroup: 'Titulo', height: '52px'},
                {text: '<strong>EVENTO FINAL : </strong>' + eventoFinal, name: 'EventoFinal', parentgroup: 'Titulo', height: '52px'}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 83, autoOpenPopup: false, mode: 'popup'});
        $("#div_GrillaHojaTrabajo").on('contextmenu', function () {
            return false;
        });
        // handle context menu clicks.
        $("#div_GrillaHojaTrabajo").on('rowclick', function (event) {
            if (event.args.rightclick) {
                $("#div_GrillaHojaTrabajo").jqxGrid('selectrow', event.args.rowindex);
                var scrollTop = $(window).scrollTop();
                var scrollLeft = $(window).scrollLeft();
                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
                return false;
            }
        });
        $("#div_ContextMenu").on('itemclick', function (event) {
            var opcion = event.args;
            if (codigo !== null || codigo === '') {
                if ($.trim($(opcion).text()) === "Editar") {
                    mode = 'U';
                    fn_EditarRegistro();
                } else if ($.trim($(opcion).text()) === "Eliminar") {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Desea Eliminar este registro!',
                        theme: 'material',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true,
                        buttons: {
                            aceptar: {
                                text: 'Aceptar',
                                btnClass: 'btn-primary',
                                keys: ['enter', 'shift'],
                                action: function () {
                                    mode = 'D';
                                    fn_GrabarDatosHojaTrabajo();
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                } else if ($.trim($(opcion).text()) === "<-- Regresar") {
                    fn_RegresarEventoFinal();
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'No hay Opcion a Mostar',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'orange',
                        typeAnimated: true
                    });
                }
            } else {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'Debe Seleccionar un Registro',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            }
        });
        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaHojaTrabajo").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaHojaTrabajo").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 550;
                var alto = 200;
                posicionX = (screen.width / 2) - (ancho / 2);
                posicionY = (screen.height / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarHojaTrabajo'),
                    initContent: function () {
                        $("#cbo_CadenaGastoHojaTrabajo").jqxDropDownList({animationType: 'fade', width: 400, dropDownWidth: 500, height: 20});
                        $('#cbo_CadenaGastoHojaTrabajo').on('select', function (event) {
                            if (mode === 'I') {
                                var cadenaGasto = $('#cbo_CadenaGastoHojaTrabajo').val();
                                $.ajax({
                                    type: "GET",
                                    url: "../HojaTrabajo",
                                    data: {mode: 'S', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea,
                                        dependencia: dependencia, eventoPrincipal: eventoPrincipal, eventoFinal: eventoFinal, cadenaGasto: cadenaGasto},
                                    success: function (data) {
                                        $("#div_SaldoHojaTrabajo").val(parseFloat(data));
                                    }
                                });
                            }
                        });
                        $("#txt_ItemHojaTrabajo").jqxInput({width: 400, height: 20});
                        $("#txt_ItemHojaTrabajo").keypress(function (event) {
                            var texto = $("#txt_ItemHojaTrabajo").val();
                            if (event.which === 13 || event.keyCode === 13) {
                                fn_BuscaItem(texto);
                            } else if (event.which === 32 || event.keyCode === 32) {
                                fn_BuscaItem(texto);
                            } else if (texto.length === 4) {
                                fn_BuscaItem(texto);
                            }
                        });
                        $('#txt_ItemHojaTrabajo').on('select', function (event) {
                            if (event.args) {
                                var item = event.args.item;
                                if (item) {
                                    codigoItem = item.value;
                                }
                            }
                        });
                        $("#cbo_UnidadMedidaHojaTrabajo").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                        $("#div_CantidadHojaTrabajo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_CantidadHojaTrabajo').on('textchanged', function (event) {
                            fn_VerTotal();
                        });
                        $("#div_PrecioHojaTrabajo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_PrecioHojaTrabajo').on('textchanged', function (event) {
                            fn_VerTotal();
                        });
                        $("#div_TotalHojaTrabajo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                        $("#div_SaldoHojaTrabajo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                        $('#btn_CancelarHojaTrabajo').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarHojaTrabajo').jqxButton({width: '65px', height: 25});

                        $('#btn_GuardarHojaTrabajo').on('click', function (event) {
                            $('#frm_HojaTrabajo').jqxValidator('validate');
                        });
                        $('#frm_HojaTrabajo').jqxValidator({
                            rules: [
                                {input: '#txt_ItemHojaTrabajo', message: 'Ingrese el Item!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_HojaTrabajo').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatosHojaTrabajo();
                            }
                        });
                    }
                });
            }
            return {init: function () {
                    _createElements();
                }
            };
        }());
        $(document).ready(function () {
            customButtonsDemo.init();
        });
        //FUNCION PARA REFRESCAR LA PANTALLA
        function fn_Refrescar() {
            $("#div_ContextMenu").remove();
            $("#div_GrillaTotales").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../HojaTrabajo",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, nivel: nivel, eventoPrincipal: eventoPrincipal, eventoFinal: eventoFinal, dependencia: dependencia},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA DE NUEVO REGISTRO
        function fn_NuevoRegistroHojaTrabajo() {
            $("#cbo_CadenaGastoHojaTrabajo").jqxDropDownList('selectItem', 0);
            $('#txt_ItemHojaTrabajo').val('');
            $("#cbo_UnidadMedidaHojaTrabajo").jqxDropDownList('selectItem', 0);
            $('#div_CantidadHojaTrabajo').val(0);
            $('#div_PrecioHojaTrabajo').val(0);
            $('#div_TotalHojaTrabajo').val(0);
            $("#txt_ItemHojaTrabajo").jqxInput({disabled: false});
            $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../HojaTrabajo",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea,
                    eventoPrincipal: eventoPrincipal, eventoFinal: eventoFinal, correlativo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 6) {
                        $("#cbo_CadenaGastoHojaTrabajo").jqxDropDownList('selectItem', dato[0]);
                        codigoItem = dato[1];
                        $('#txt_ItemHojaTrabajo').val(dato[2]);
                        $("#cbo_UnidadMedidaHojaTrabajo").jqxDropDownList('selectItem', dato[3]);
                        $('#div_CantidadHojaTrabajo').val(dato[4]);
                        $('#div_PrecioHojaTrabajo').val(dato[5]);
                        fn_BuscaItem(dato[2].substring(0, 4));
                        fn_VerTotal();
                        $("#txt_ItemHojaTrabajo").jqxInput({disabled: true});
                        $.ajax({
                            type: "GET",
                            url: "../HojaTrabajo",
                            data: {mode: 'S', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea,
                                dependencia: dependencia, eventoPrincipal: eventoPrincipal, eventoFinal: eventoFinal, cadenaGasto: dato[0]},
                            success: function (data) {
                                $("#div_SaldoHojaTrabajo").val(data);
                                var total = (parseFloat(data)) + (parseFloat($("#div_TotalHojaTrabajo").val()));
                                $('#div_SaldoHojaTrabajo').val(parseFloat(total));
                            }
                        });
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatosHojaTrabajo() {
            if (codigoItem !== null || mode === 'D') {
                var cadenaGasto = $("#cbo_CadenaGastoHojaTrabajo").val();
                var item = $('#txt_ItemHojaTrabajo').val();
                var unidadMedida = $("#cbo_UnidadMedidaHojaTrabajo").val();
                var cantidad = $("#div_CantidadHojaTrabajo").val();
                var precio = $("#div_PrecioHojaTrabajo").val();
                var total = (parseFloat($("#div_SaldoHojaTrabajo").val())) - (parseFloat($("#div_TotalHojaTrabajo").val()));
                if (parseFloat(total) >= 0.0) {
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'Saldo Insuficiente. Revise!!',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                    return;
                }
                var msg = "";
                $.ajax({
                    type: "POST",
                    url: "../IduHojaTrabajo",
                    data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea,
                        eventoPrincipal: eventoPrincipal, eventoFinal: eventoFinal, correlativo: codigo, cadenaGasto: cadenaGasto,
                        codigoItem: codigoItem, item: item, unidadMedida: unidadMedida, cantidad: cantidad, precio: precio},
                    success: function (data) {
                        msg = data;
                        if (msg === "GUARDO") {
                            $('#div_VentanaPrincipal').jqxWindow('close');
                            fn_Refrescar();
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
                });
            } else {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'Debe Seleccionar un Registro',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'blue',
                    typeAnimated: true
                });
            }
        }
        function fn_RegresarEventoFinal() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../EventoFinal",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, nivel: nivel, codigo: eventoPrincipal},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        function fn_VerTotal() {
            var total = (parseFloat($("#div_PrecioHojaTrabajo").val())) * (parseFloat($("#div_CantidadHojaTrabajo").val()));
            $("#div_TotalHojaTrabajo").val(parseFloat(total).toFixed(2));
        }
    });

    function fn_BuscaItem(busca) {
        $.ajax({
            type: "POST",
            url: "../TextoAjax",
            data: {mode: 'item', codigo: busca},
            success: function (data) {
                $("#txt_ItemHojaTrabajo").html(data);
            }
        });
    }
</script>
<div id="div_GrillaHojaTrabajo"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">CUADRO DE NECESIDADES VALORIZADAS</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_HojaTrabajo" name="frm_HojaTrabajo" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">                                    
                <tr>
                    <td class="inputlabel">Item : </td>
                    <td colspan="3"><input type="text" id="txt_ItemHojaTrabajo" name="txt_ItemHojaTrabajo" style="text-transform: uppercase;"/></td>                          
                </tr> 
                <tr>
                    <td class="inputlabel">Cadena Gasto : </td>
                    <td colspan="3">
                        <select id="cbo_CadenaGastoHojaTrabajo" name="cbo_CadenaGastoHojaTrabajo">
                            <option value="0">Seleccione</option>
                            <c:forEach var="e" items="${objCadenaGasto}">   
                                <option value="${e.codigo}">${e.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Unidad Medida : </td>
                    <td colspan="3">
                        <select id="cbo_UnidadMedidaHojaTrabajo" name="cbo_UnidadMedidaHojaTrabajo">
                            <c:forEach var="e" items="${objUnidadMedida}">   
                                <option value="${e.codigo}">${e.descripcion}</option>
                            </c:forEach>                               
                        </select>
                    </td>                          
                </tr>                
                <tr>
                    <td class="inputlabel">Cantidad : </td>
                    <td colspan="3"><div id="div_CantidadHojaTrabajo"></div></td>                          
                </tr>
                <tr>
                    <td class="inputlabel">Val. Ref. S/. : </td>
                    <td colspan="3"><div id="div_PrecioHojaTrabajo"></div></td>                          
                </tr>                
                <tr>
                    <td class="inputlabel">Total : </td>
                    <td><div id="div_TotalHojaTrabajo"></div></td>                          
                    <td class="inputlabel">Saldo : </td>
                    <td><div id="div_SaldoHojaTrabajo"></div></td>  
                </tr>
                <tr>
                    <td class="Summit" colspan="4">
                        <div>                            
                            <input type="button" id="btn_GuardarHojaTrabajo"  value="Guardar" style="margin-right: 20px" />
                            <input type="button" id="btn_CancelarHojaTrabajo" value="Cancelar" style="margin-right: 20px"/>                            
                        </div>
                    </td>
                </tr>
            </table>  
        </form>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Eliminar</li>
        <li><-- Regresar</li>
    </ul>
</div>