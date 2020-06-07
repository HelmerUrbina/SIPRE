<%-- 
    Document   : ListaResolucionesAdministrativas
    Created on : 17/02/2018, 03:49:55 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var codigo = null;   
    var mode = null;
    var indiceDetalle = -1;
    var msg = "";
    var lista = new Array();
    <c:forEach var="c" items="${objResoluciones}">
    var result = {codigo: '${c.codigo}', cobertura: '${c.cobertura}', siaf: '${c.SIAF}', fechaEmision: '${c.fechaEmision}',
        importe: '${c.importe}', compromiso: '${c.compromiso}', devengado: '${c.devengado}', girado: '${c.girado}',
        revertido: '${c.revertido}', saldo: '${c.importe-(c.devengado+c.revertido)}'};
    lista.push(result);
    </c:forEach>
    var detalle = new Array();
    <c:forEach var="d" items="${objResolucionesDetalle}">
    var result = {codigo: '${d.codigo}', secuenciaFuncional: '${d.secuenciaFuncional}',
        tareaPresupuestal: '${d.tareaPresupuestal}', cadenaGasto: '${d.cadenaGasto}',
        importe: '${d.importe}', compromiso: '${d.compromiso}', devengado: '${d.devengado}', girado: '${d.girado}',
        revertido: '${d.revertido}', saldo: '${d.importe-(d.devengado+d.revertido)}'};
    detalle.push(result);
    </c:forEach>
    $(document).ready(function () {
        var sourceDetalle = {
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: 'secuenciaFuncional', type: "string"},
                        {name: 'tareaPresupuestal', type: "string"},
                        {name: 'cadenaGasto', type: "string"},
                        {name: "importe", type: "number"},
                        {name: "compromiso", type: "number"},
                        {name: "devengado", type: "number"},
                        {name: "girado", type: "number"},
                        {name: "revertido", type: "number"},
                        {name: "saldo", type: "number"},
                        {name: "modifica", type: "string"}
                    ],
            pagesize: 50,
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            },
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            },
            updaterow: function (rowid, rowdata, commit) {
                commit(true);
            }
        };
        var dataDetalle = new $.jqx.dataAdapter(sourceDetalle);
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA CABECERA
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigo', type: "string"},
                        {name: 'cobertura', type: "string"},
                        {name: 'siaf', type: "string"},
                        {name: 'fechaEmision', type: "string"},
                        {name: 'genericaGasto', type: "string"},
                        {name: 'genericaGasto', type: "string"},
                        {name: 'resolucion', type: "string"},
                        {name: "importe", type: "number"},
                        {name: "compromiso", type: "number"},
                        {name: "devengado", type: "number"},
                        {name: "girado", type: "number"},
                        {name: "revertido", type: "number"},
                        {name: "saldo", type: "number"}
                    ],
            root: "ResolucionesAdministrativas",
            record: "ResolucionesAdministrativas",
            id: 'codigo'
        };
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA DETALLE 
        var sourceDet = {
            localdata: detalle,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: 'secuenciaFuncional', type: "string"},
                        {name: 'tareaPresupuestal', type: "string"},
                        {name: 'cadenaGasto', type: "string"},
                        {name: "importe", type: "number"},
                        {name: "compromiso", type: "number"},
                        {name: "devengado", type: "number"},
                        {name: "girado", type: "number"},
                        {name: "revertido", type: "number"},
                        {name: "saldo", type: "number"}
                    ],
            root: "ResolucionesAdministrativasDetalle",
            record: "ResolucionesAdministrativasDetalle",
            id: 'codigo',
            async: false
        };
        var dataAdapter = new $.jqx.dataAdapter(sourceDet, {autoBind: true});
        nested = dataAdapter.records;
        var nestedGrids = new Array();
        // create nested grid.
        var initRowDetails = function (index, parentElement, gridElement, record) {
            var id = record.uid.toString();
            var grid = $($(parentElement).children()[0]);
            nestedGrids[index] = grid;
            var filtergroup = new $.jqx.filter();
            var filterValue = id;
            var filterCondition = 'equal';
            var filter = filtergroup.createfilter('stringfilter', filterValue, filterCondition);
            // fill the orders depending on the id.
            var ordersbyid = [];
            for (var m = 0; m < nested.length; m++) {
                var result = filter.evaluate(nested[m]["codigo"]);
                if (result)
                    ordersbyid.push(nested[m]);
            }
            var sourceNested = {
                datafields: [
                    {name: "codigo", type: "string"},
                    {name: 'secuenciaFuncional', type: "string"},
                    {name: 'tareaPresupuestal', type: "string"},
                    {name: 'cadenaGasto', type: "string"},
                    {name: "importe", type: "number"},
                    {name: "compromiso", type: "number"},
                    {name: "devengado", type: "number"},
                    {name: "girado", type: "number"},
                    {name: "revertido", type: "number"},
                    {name: "saldo", type: "number"}
                ],
                id: 'codigo',
                localdata: ordersbyid
            };
            var nestedGridAdapter = new $.jqx.dataAdapter(sourceNested);
            if (grid !== null) {
                grid.jqxGrid({
                    source: nestedGridAdapter,
                    width: '98%',
                    height: 340,
                    pageable: true,
                    filterable: true,
                    autoshowfiltericon: true,
                    columnsresize: true,
                    showaggregates: true,
                    showfilterrow: true,
                    showstatusbar: true,
                    statusbarheight: 25,
                    columns: [
                        {text: 'SEC. FUN.', datafield: 'secuenciaFuncional', width: '15%', filtertype: 'checkedlist', align: 'center'},
                        {text: 'TAREA', datafield: 'tareaPresupuestal', width: '10%', filtertype: 'checkedlist', align: 'center'},
                        {text: 'CADENA DE GASTO', datafield: 'cadenaGasto', width: '15%', filtertype: 'checkedlist', align: 'center', aggregates: [{'<b>Totales : </b>':
                                            function () {
                                                return  "";
                                            }}]},
                        {text: 'IMPORTE', dataField: 'importe', width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'COMPROMISO', dataField: 'compromiso', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'DEVENGADO', dataField: 'devengado', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'GIRADO', dataField: 'girado', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'REVERTIDO', dataField: 'revertido', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'SALDO', dataField: 'saldo', width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
                    ]
                });
            }
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "importe") {
                return "RowBold";
            }
            if (datafield === "compromiso") {
                return "RowBlue";
            }
            if (datafield === "devengado") {
                return "RowGreen";
            }
            if (datafield === "girado") {
                return "RowDarkBlue";
            }
            if (datafield === "revertido") {
                return "RowPurple";
            }
            if (datafield === "saldo") {
                return "RowBrown";
            }
        };
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 60),
            source: sourceCab,
            rowdetails: true,
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
            pagesize: 100,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var reporteButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonExportar);
                container.append(reporteButton);
                toolbar.append(container);
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                reporteButton.jqxButton({width: 30, height: 22});
                reporteButton.jqxTooltip({position: 'bottom', content: "Reportes"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ResolucionesAdministrativas');
                });
                reporteButton.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 350, rowdetailshidden: true},
            columns: [
                {text: 'RA', dataField: 'codigo', filtertype: 'checkedlist', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'COBERTURA', dataField: 'cobertura', filtertype: 'checkedlist', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'REG. SIAF', dataField: 'siaf', filtertype: 'checkedlist', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FECHA EMISION', dataField: 'fechaEmision', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'importe', width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'COMPROMISO', dataField: 'compromiso', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DEVENGADO', dataField: 'devengado', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'GIRADO', dataField: 'girado', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'REVERTIDO', dataField: 'revertido', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO', dataField: 'saldo', width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 30, autoOpenPopup: false, mode: 'popup'});
        $("#div_GrillaPrincipal").on('contextmenu', function () {
            return false;
        });
        // handle context menu clicks.
        $("#div_GrillaPrincipal").on('rowclick', function (event) {
            if (event.args.rightclick) {
                $("#div_GrillaPrincipal").jqxGrid('selectrow', event.args.rowindex);
                var scrollTop = $(window).scrollTop();
                var scrollLeft = $(window).scrollLeft();
                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
                return false;
            }
        });
        $("#div_ContextMenu").on('itemclick', function (event) {
            var opcion = event.args;
            if (codigo !== null) {
                if ($.trim($(opcion).text()) === "Ver Detalle") {
                    mode = 'U';
                    fn_RefrescarDetalle();
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true});
                    $('#div_VentanaPrincipal').jqxWindow('open');
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
                    type: 'orange',
                    typeAnimated: true
                });
            }
        });
        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
        });
        //GRILLA DETALLE
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: '420',
            source: dataDetalle,
            pageable: true,
            columnsresize: true,
            showstatusbar: true,
            autoheight: false,
            autorowheight: false,
            showtoolbar: true,
            altrows: true,
            editable: false,
            sortable: true,
            showaggregates: true,
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var editButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/update42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var refreshButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                container.append(editButtonDet);
                container.append(refreshButtonDet);
                toolbar.append(container);
                editButtonDet.jqxButton({width: 30, height: 22});
                editButtonDet.jqxTooltip({position: 'bottom', content: "Editar Registro"});
                refreshButtonDet.jqxButton({width: 30, height: 22});
                refreshButtonDet.jqxTooltip({position: 'bottom', content: "Actualizar Pantalla"});
                // add new row.                
                editButtonDet.click(function (event) {
                    modeDetalle = 'U';
                    if (indiceDetalle >= 0) {
                        var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                        $('#txt_SecuenciaFuncional').val(dataRecord.secuenciaFuncional);
                        $('#txt_TareaPresupuestal').val(dataRecord.tareaPresupuestal);
                        $('#txt_CadenaGasto').val(dataRecord.cadenaGasto);
                        $('#div_Importe').val(dataRecord.importe);
                        $('#div_Compromiso').val(dataRecord.compromiso);
                        $('#div_Devengado').val(dataRecord.devengado);
                        $('#div_Girado').val(dataRecord.girado);
                        $('#div_Revertido').val(dataRecord.revertido);
                        $('#div_Saldo').val(dataRecord.saldo);
                        $('#div_DetalleRA').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_DetalleRA').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'SELECCIONE UN REGISTRO',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                });
                refreshButtonDet.click(function (event) {
                    fn_RefrescarDetalle();
                });
            },
            columns: [
                {text: 'N°', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', align: 'center', columntype: 'number', width: '4%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'SEC. FUN.', datafield: 'secuenciaFuncional', width: '10%', filtertype: 'checkedlist', align: 'center'},
                {text: 'TAREA', datafield: 'tareaPresupuestal', width: '10%', filtertype: 'checkedlist', align: 'center'},
                {text: 'CADENA DE GASTO', datafield: 'cadenaGasto', width: '14%', filtertype: 'checkedlist', align: 'center', aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'IMPORTE', dataField: 'importe', width: '11%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'COMPROMISO', dataField: 'compromiso', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DEVENGADO', dataField: 'devengado', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'GIRADO', dataField: 'girado', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'REVERTIDO', dataField: 'revertido', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO', dataField: 'saldo', width: '11%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 800;
                var alto = 490;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            fn_GrabarDatos();
                        });
                    }
                });
                ancho = 550;
                alto = 270;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_DetalleRA').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarRA'),
                    initContent: function () {
                        $("#txt_SecuenciaFuncional").jqxInput({width: 430, height: 20, disabled: true});
                        $("#txt_TareaPresupuestal").jqxInput({width: 430, height: 20, disabled: true});
                        $("#txt_CadenaGasto").jqxInput({width: 430, height: 20, disabled: true});
                        $("#div_Importe").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                        $("#div_Compromiso").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Devengado").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Devengado').on('textchanged', function (event) {
                            fn_SaldoRA();
                        });
                        $("#div_Girado").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Revertido").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Revertido').on('textchanged', function (event) {
                            fn_SaldoRA();
                        });
                        $("#div_Saldo").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                        $('#btn_CancelarRA').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRA').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRA').on('click', function () {
                            var compromiso = parseFloat($("#div_Compromiso").jqxNumberInput('decimal'));
                            var devengado = parseFloat($("#div_Devengado").jqxNumberInput('decimal'));
                            var girado = parseFloat($("#div_Girado").jqxNumberInput('decimal'));
                            var revertido = parseFloat($("#div_Revertido").jqxNumberInput('decimal'));
                            var saldo = parseFloat($("#div_Importe").val()) - (devengado + revertido);
                            var msg = "";
                            if (parseFloat(compromiso) > parseFloat($("#div_Importe").val()))
                                msg = 'Verificar Monto de Compromiso. Saldo = ' + (parseFloat(compromiso) - parseFloat($("#div_Importe").val())) + '.<br>';
                            if (parseFloat(devengado) > parseFloat($("#div_Importe").val()))
                                msg = 'Verificar Monto de Devengado. Saldo = ' + (parseFloat(devengado) - parseFloat($("#div_Importe").val())) + '.<br>';
                            if (parseFloat(girado) > parseFloat($("#div_Importe").val()))
                                msg = 'Verificar Monto de Girado. Saldo = ' + (parseFloat(girado) - parseFloat($("#div_Importe").val())) + '.<br>';
                            if (parseFloat(revertido) > parseFloat($("#div_Importe").val()))
                                msg = 'Verificar Monto de Revertido. Saldo = ' + (parseFloat(revertido) - parseFloat($("#div_Importe").val())) + '.<br>';
                            if (parseFloat(saldo) > parseFloat($("#div_Importe").val()))
                                msg = 'Verificar. Saldo = ' + (parseFloat(saldo) - parseFloat($("#div_Importe").val())) + '.<br>';
                            if (msg === "") {
                                var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                                var row = {secuenciaFuncional: dataRecord.secuenciaFuncional, tareaPresupuestal: dataRecord.tareaPresupuestal,
                                    cadenaGasto: dataRecord.cadenaGasto, importe: parseFloat(dataRecord.importe), compromiso: parseFloat(compromiso),
                                    devengado: parseFloat(devengado), girado: parseFloat(girado), revertido: parseFloat(revertido), saldo: parseFloat(saldo),
                                    modifica: 'Y'};
                                var rowID = $('#div_GrillaRegistro').jqxGrid('getrowid', indiceDetalle);
                                $('#div_GrillaRegistro').jqxGrid('updaterow', rowID, row);
                                $("#div_DetalleRA").jqxWindow('hide');
                                $('#txt_SecuenciaFuncional').val('');
                                $('#txt_TareaPresupuestal').val('');
                                $('#txt_CadenaGasto').val('');
                                $('#div_Importe').val(0.0);
                                $('#div_Compromiso').val(0.0);
                                $('#div_Devengado').val(0.0);
                                $('#div_Girado').val(0.0);
                                $('#div_Revertido').val(0.0);
                                $('#div_Saldo').val(0.0);
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
                        });
                    }
                });
                ancho = 400;
                alto = 105;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_Reporte').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CerrarImprimir'),
                    initContent: function () {
                        $("#div_EVA0001").jqxRadioButton({width: 200, height: 20});
                        $('#div_EVA0001').on('checked', function (event) {
                            reporte = 'EVA0001';
                        });
                        $("#div_EVA0002").jqxRadioButton({width: 200, height: 20});
                        $('#div_EVA0002').on('checked', function (event) {
                            reporte = 'EVA0002';
                        });
                        $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').on('click', function (event) {
                            var msg = "";
                            switch (reporte) {
                                case "EVA0001":
                                    break;
                                case "EVA0002":
                                    break;
                                default:
                                    msg += "Debe selecciona una opción.<br>";
                                    break;
                            }
                            if (msg === "") {
                                var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto;
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
        function fn_Refrescar() {
            $("#div_ContextMenu").remove();
            $("#div_DetalleRA").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../ResolucionesAdministrativas",
                data: {mode: "G", periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_RefrescarDetalle() {
            $('#div_GrillaRegistro').jqxGrid('clear');
            $.ajax({
                type: "GET",
                url: "../ResolucionesAdministrativas",
                data: {mode: 'B', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    data = data.replace("[", "");
                    var fila = data.split("[");
                    var rows = new Array();
                    for (i = 1; i < fila.length; i++) {
                        var columna = fila[i];
                        var datos = columna.split("+++");
                        while (datos[7].indexOf(']') > 0) {
                            datos[7] = datos[7].replace("]", "");
                        }
                        while (datos[7].indexOf(',') > 0) {
                            datos[7] = datos[7].replace(",", "");
                        }
                        var row = {secuenciaFuncional: datos[0], tareaPresupuestal: datos[1],
                            cadenaGasto: datos[2], importe: parseFloat(datos[3]), compromiso: parseFloat(datos[4]),
                            devengado: parseFloat(datos[5]), girado: parseFloat(datos[6]), revertido: parseFloat(datos[7]),
                            saldo: (parseFloat(datos[3]) - (parseFloat(datos[5]) + parseFloat(datos[7])))};
                        rows.push(row);
                    }
                    if (rows.length > 0)
                        $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var msg = "";
            var lista = new Array();
            var result;
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (row.modifica === 'Y') {
                    result = row.uid + "---" + fn_extraerDatos(row.secuenciaFuncional, ':') + "---" + fn_extraerDatos(row.tareaPresupuestal, ':') + "---" +
                            fn_extraerDatos(row.cadenaGasto, ':') + "---" + row.compromiso + "---" + row.devengado + "---" + row.girado
                            + "---" + row.revertido;
                    lista.push(result);
                }
            }
            if (lista.length === 0)
                msg += "No se ha realizado ninguna modificación <br>";
            if (msg === "") {
                $.ajax({
                    type: "POST",
                    url: "../IduResolucionesAdministrativas",
                    data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo, lista: JSON.stringify(lista)},
                    success: function (data) {
                        msg = data;
                        if (msg === "GUARDO") {
                            $.confirm({
                                title: 'AVISO DEL SISTEMA',
                                content: 'Datos procesados correctamente',
                                type: 'green',
                                typeAnimated: true,
                                autoClose: 'cerrarAction|1000',
                                buttons: {
                                    cerrarAction: {
                                        text: 'Cerrar',
                                        action: function () {
                                            $('#div_VentanaPrincipal').jqxWindow('close');
                                            fn_Refrescar();
                                        }
                                    }
                                }
                            });
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
                    content: msg,
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            }
        }
    }
    );
    //FUNCION PARA VALIDAR EL TOTAL DE CREDITO Y NO GENERE SALDO NEGATIVO
    function fn_SaldoRA() {
        var total = parseFloat($("#div_Importe").val()) - ($("#div_Devengado").val() + $("#div_Revertido").val());
        $("#div_Saldo").val(parseFloat(total));
        if (parseFloat(total) > parseFloat($("#div_Importe").val())) {
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: 'Saldo Inferior. Revise!!',
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'orange',
                typeAnimated: true
            });
        }
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">RESOLUCIÓN ADMINISTRATIVA</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_ResolucionAdministrativa" name="frm_ResolucionAdministrativa" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">                
                <tr>
                    <td colspan="2"><div id="div_GrillaRegistro"></div>  </td>

                </tr> 
                <tr>
                    <td class="Summit" colspan="2">
                        <div>
                            <input type="button" id="btn_Guardar"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_Cancelar" value="Cancelar" style="margin-right: 20px"/>                            
                        </div>
                    </td>
                </tr>
            </table>  

        </form>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Ver Detalle</li>      
    </ul>
</div>
<div id='div_DetalleRA' style='display: none;'>
    <div>Detalle de la Resolución Administrativa</div>
    <div>
        <div>
            <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                <tr>
                    <td class="inputlabel">Sec. Fun : </td>
                    <td><input type="text" id="txt_SecuenciaFuncional" name="txt_SecuenciaFuncional" style="text-transform: uppercase;"/></td>                    

                <tr>
                    <td class="inputlabel">Tarea : </td>
                    <td><input type="text" id="txt_TareaPresupuestal" name="txt_TareaPresupuestal" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Cadena Gasto : </td>
                    <td><input type="text" id="txt_CadenaGasto" name="txt_CadenaGasto" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Importe : </td>
                    <td><div id="div_Importe"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Compromiso : </td>
                    <td><div id="div_Compromiso"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Devengado : </td>
                    <td><div id="div_Devengado"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Girado : </td>
                    <td><div id="div_Girado"></td>
                </tr>
                <tr>
                    <td class="inputlabel">Revertido : </td>
                    <td><div id="div_Revertido"></td>
                </tr>                
                <tr>
                    <td class="inputlabel">Saldo : </td>
                    <td><div id="div_Saldo"></td>
                </tr>
                <tr>
                    <td class="Summit" colspan="4">
                        <div>
                            <input type="button" id="btn_GuardarRA" value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarRA" value="Cancelar" style="margin-right: 20px"/>                            
                        </div>
                    </td>
                </tr>
            </table> 
        </div>
    </div>
</div>
<div id="div_Reporte" style="display: none;">
    <div>
        <span style="float: left">LISTADO DE REPORTES</span>
    </div>
    <div style="overflow: hidden">
        <div id='div_EVA0001'>Ejecución Mensual de Egresos</div>
        <div id='div_EVA0002'>Listado de RA Emitidas</div>           
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>
