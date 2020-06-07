
<%-- 
    Document   : ListaCalendarioGastos
    Created on : 05/10/2017, 12:59:46 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var codigo = null;
    var evento = null;
    var mode = null;
    var tarea = null;
    var indiceDetalle = -1;
    var msg = "";
    var lista = new Array();
    <c:forEach var="c" items="${objCalendarioGastos}">
    var result = {codigo: '${c.codigo}', tarea: '${c.tarea}', secuenciaFuncional: '${c.secuenciaFuncional}',
        pia: '${c.programado}', pim: '${c.importe}', pca: '${c.abril}', saldoPCA: '${c.importe-c.abril}', anual: '${c.enero}', saldoAnual: '${c.abril-c.enero}',
        compromiso: '${c.febrero}', saldoCompromiso: '${c.enero-c.febrero}', mensual: '${c.marzo}', saldoMensual: '${c.febrero-c.marzo}',
        tipoCalendario: '${c.tipoCalendario}', genericaGasto: '${c.genericaGasto}', resolucion: '${c.resolucion}',
        programa: '${c.categoriaPresupuestal}', producto: '${c.producto}', actividad: '${c.actividad}'};
    lista.push(result);
    </c:forEach>
    var detalle = new Array();
    <c:forEach var="d" items="${objCalendarioGastosDetalle}">
    var result = {codigo: '${d.codigo}', dependencia: '${d.dependencia}', cadenaGasto: '${d.cadenaGasto}',
        importe: '${d.importe}', enero: '${d.enero}', febrero: '${d.febrero}', marzo: '${d.marzo}', abril: '${d.abril}',
        mayo: '${d.mayo}', junio: '${d.junio}', julio: '${d.julio}', agosto: '${d.agosto}', setiembre: '${d.setiembre}',
        octubre: '${d.octubre}', noviembre: '${d.noviembre}', diciembre: '${d.diciembre}'};
    detalle.push(result);
    </c:forEach>
    $(document).ready(function () {
        var sourceCNV = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: "evento", type: "string"},
                        {name: "nombreEvento", type: "string"},
                        {name: "nivel", type: "number"},
                        {name: "cantidad", type: "number"},
                        {name: "monto", type: "number"},
                        {name: "enero", type: "number"},
                        {name: "febrero", type: "number"},
                        {name: "marzo", type: "number"},
                        {name: "abril", type: "number"},
                        {name: "mayo", type: "number"},
                        {name: "junio", type: "number"},
                        {name: "julio", type: "number"},
                        {name: "agosto", type: "number"},
                        {name: "setiembre", type: "number"},
                        {name: "octubre", type: "number"},
                        {name: "noviembre", type: "number"},
                        {name: "diciembre", type: "number"},
                        {name: "programado", type: "number"},
                        {name: "total", type: "number"}
                    ],
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            },
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            }
        };
        var sourceDetalle = {
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "dependencia", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "importe", type: "number"},
                        {name: "enero", type: "number"},
                        {name: "febrero", type: "number"},
                        {name: "marzo", type: "number"},
                        {name: "abril", type: "number"},
                        {name: "mayo", type: "number"},
                        {name: "junio", type: "number"},
                        {name: "julio", type: "number"},
                        {name: "agosto", type: "number"},
                        {name: "setiembre", type: "number"},
                        {name: "octubre", type: "number"},
                        {name: "noviembre", type: "number"},
                        {name: "diciembre", type: "number"},
                        {name: "modifica", type: "string"}
                    ],
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
                        {name: 'tarea', type: "string"},
                        {name: 'secuenciaFuncional', type: "string"},
                        {name: 'pia', type: "number"},
                        {name: 'pim', type: "number"},
                        {name: 'pca', type: "number"},
                        {name: 'saldoPCA', type: "number"},
                        {name: 'anual', type: "number"},
                        {name: 'saldoAnual', type: "number"},
                        {name: 'compromiso', type: "number"},
                        {name: 'saldoCompromiso', type: "number"},
                        {name: 'mensual', type: "number"},
                        {name: 'saldoMensual', type: "number"},
                        {name: 'tipoCalendario', type: "string"},
                        {name: 'genericaGasto', type: "string"},
                        {name: 'resolucion', type: "string"},
                        {name: 'programa', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'actividad', type: "string"}
                    ],
            root: "CalendarioGastos",
            record: "CalendarioGastos",
            id: 'codigo'
        };
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA DETALLE 
        var sourceDet = {
            localdata: detalle,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "dependencia", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "importe", type: "number"},
                        {name: "enero", type: "number"},
                        {name: "febrero", type: "number"},
                        {name: "marzo", type: "number"},
                        {name: "abril", type: "number"},
                        {name: "mayo", type: "number"},
                        {name: "junio", type: "number"},
                        {name: "julio", type: "number"},
                        {name: "agosto", type: "number"},
                        {name: "setiembre", type: "number"},
                        {name: "octubre", type: "number"},
                        {name: "noviembre", type: "number"},
                        {name: "diciembre", type: "number"}
                    ],
            root: "CalendarioGastosDetalle",
            record: "CalendarioGastosDetalle",
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
                    {name: "dependencia", type: "string"},
                    {name: "cadenaGasto", type: "string"},
                    {name: "importe", type: "number"},
                    {name: "enero", type: "number"},
                    {name: "febrero", type: "number"},
                    {name: "marzo", type: "number"},
                    {name: "abril", type: "number"},
                    {name: "mayo", type: "number"},
                    {name: "junio", type: "number"},
                    {name: "julio", type: "number"},
                    {name: "agosto", type: "number"},
                    {name: "setiembre", type: "number"},
                    {name: "octubre", type: "number"},
                    {name: "noviembre", type: "number"},
                    {name: "diciembre", type: "number"}
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
                    statusbarheight: 20,
                    columns: [
                        {text: 'DEPENDENCIA', datafield: 'dependencia', width: '6%', filtertype: 'checkedlist'},
                        {text: 'CADENA DE GASTO', datafield: 'cadenaGasto', width: '15%', filtertype: 'checkedlist', aggregates: [{'<b>Totales : </b>':
                                            function () {
                                                return  "";
                                            }}]},
                        {text: 'IMPORTE', dataField: 'importe', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'ENERO', dataField: 'enero', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'FEBRERO', dataField: 'febrero', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'MARZO', dataField: 'marzo', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'ABRIL', dataField: 'abril', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'MAYO', dataField: 'mayo', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'JUNIO', dataField: 'junio', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'JULIO', dataField: 'julio', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'AGOSTO', dataField: 'agosto', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'SETIEMBRE', dataField: 'setiembre', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'OCTUBRE', dataField: 'octubre', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'NOVIEMBRE', dataField: 'noviembre', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'DICIEMBRE', dataField: 'diciembre', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
                    ]
                });
            }
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "pia" || datafield === "pca") {
                return "RowBold";
            }
            if (datafield === "pim") {
                return "RowBlue";
            }
            if (datafield === "saldoPCA") {
                return "RowRed";
            }
            if (datafield === "anual") {
                return "RowGreen";
            }
            if (datafield === "compromiso") {
                return "RowDarkBlue";
            }
            if (datafield === "mensual") {
                return "RowPurple";
            }
            if (datafield === "saldoAnual" || datafield === "saldoCompromiso" || datafield === "saldoMensual") {
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
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'CalendarioGastos');
                });
                reporteButton.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 350, rowdetailshidden: true},
            columns: [
                {text: 'TAREA', dataField: 'tarea', filtertype: 'checkedlist', width: '25%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'PIA', dataField: 'pia', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PIM', dataField: 'pim', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PCA', dataField: 'pca', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DIF. PCA', dataField: 'saldoPCA', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CERTIF.', dataField: 'anual', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO CERTIF.', dataField: 'saldoAnual', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'COMPRO.', dataField: 'compromiso', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO COMPRO.', dataField: 'saldoCompromiso', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EJECUT.', dataField: 'mensual', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO EJECUT.', dataField: 'saldoMensual', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CALENDARIO', dataField: 'tipoCalendario', filtertype: 'checkedlist', width: '8%', align: 'center', cellclassname: cellclass},
                {text: 'SECUENCIA FUNCIONAL', dataField: 'secuenciaFuncional', filtertype: 'checkedlist', width: '22%', align: 'center', cellclassname: cellclass},
                {text: 'GENERICA GASTO', dataField: 'genericaGasto', filtertype: 'checkedlist', width: '10%', align: 'center', cellclassname: cellclass},
                {text: 'RESOLUCION', dataField: 'resolucion', filtertype: 'checkedlist', width: '10%', align: 'center', cellclassname: cellclass},
                {text: 'CAT. PPTAL.', dataField: 'programa', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'PRODUCTO', dataField: 'producto', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'ACTIVIDAD', dataField: 'actividad', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 55, autoOpenPopup: false, mode: 'popup'});
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
                } else if ($.trim($(opcion).text()) === "Ver CNV") {
                    fn_RefrescarCNV();
                    $('#div_VentanaCNV').jqxWindow({isModal: true});
                    $('#div_VentanaCNV').jqxWindow('open');
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
            tarea = row['tarea'];
        });
        //EVENTOS GRILLA DETALLE
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: '410',
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
                        $('#div_Importe').val(dataRecord.importe);
                        $('#div_Enero').val(dataRecord.enero);
                        $('#div_Febrero').val(dataRecord.febrero);
                        $('#div_Marzo').val(dataRecord.marzo);
                        $('#div_Abril').val(dataRecord.abril);
                        $('#div_Mayo').val(dataRecord.mayo);
                        $('#div_Junio').val(dataRecord.junio);
                        $('#div_Julio').val(dataRecord.julio);
                        $('#div_Agosto').val(dataRecord.agosto);
                        $('#div_Setiembre').val(dataRecord.setiembre);
                        $('#div_Octubre').val(dataRecord.octubre);
                        $('#div_Noviembre').val(dataRecord.noviembre);
                        $('#div_Diciembre').val(dataRecord.diciembre);
                        $('#div_Mensualizar').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_Mensualizar').jqxWindow('open');
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
                {text: 'DEPENDENCIA', datafield: 'dependencia', width: "20%", align: 'center'},
                {text: 'SECUENCIA', datafield: 'cadenaGasto', width: "25%", align: 'center'},
                {text: 'IMPORTE', dataField: 'importe', width: "15%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ENE', dataField: 'enero', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'FEB', dataField: 'febrero', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MAR', dataField: 'marzo', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ABR', dataField: 'abril', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MAY', dataField: 'mayo', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'JUN', dataField: 'junio', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'JUL', dataField: 'julio', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'AGO', dataField: 'agosto', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SET', dataField: 'setiembre', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'OCT', dataField: 'octubre', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'NOV', dataField: 'noviembre', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DIC', dataField: 'diciembre', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
        });
        //EVENTOS GRILLA CNV
        $("#div_GrillaCNV").jqxGrid({
            width: '100%',
            height: '410',
            source: sourceCNV,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            sortable: true,
            pageable: true,
            columnsresize: true,
            showtoolbar: true,
            editable: false,
            showstatusbar: true,
            showaggregates: true,
            statusbarheight: 20,
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
                    $("#div_GrillaCNV").jqxGrid('exportdata', 'xls', 'ListadoEventoPrincipales');
                });
                reporteButton.click(function (event) {
                    var url = '../Reportes?reporte=PROG0002&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto + '&codigo=' + evento;
                    window.open(url, '_blank');
                });
            },
            columns: [
                {text: 'CODIGO', dataField: 'evento', width: '11%', filtertype: 'checkedlist', columngroup: 'Tarea', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'EVENTO', dataField: 'nombreEvento', width: '35%', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'MONTO', dataField: 'monto', width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ENE', dataField: 'enero', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'FEB', dataField: 'febrero', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MAR', dataField: 'marzo', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ABR', dataField: 'abril', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MAY', dataField: 'mayo', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'JUN', dataField: 'junio', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'JUL', dataField: 'julio', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'AGO', dataField: 'agosto', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SET', dataField: 'setiembre', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'OCT', dataField: 'octubre', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'NOV', dataField: 'noviembre', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DIC', dataField: 'diciembre', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'TOTAL', dataField: 'total', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaCNV").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaCNV").jqxGrid('getrowdata', args.rowindex);
            evento = row['evento'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 750;
                var alto = 500;
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
                ancho = 950;
                alto = 500;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaCNV').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cerrar'),
                    initContent: function () {
                        $('#btn_Cerrar').jqxButton({width: '65px', height: 25});
                    }
                });
                ancho = 450;
                alto = 240;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_Mensualizar').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarMensualizar'),
                    initContent: function () {
                        $("#div_Enero").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Enero').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Febrero").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Febrero').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Marzo").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Marzo').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Abril").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Abril').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Mayo").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Mayo').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Junio").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Junio').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Julio").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Julio').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Agosto").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Agosto').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Setiembre").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Setiembre').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Octubre").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Octubre').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Noviembre").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Noviembre').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Diciembre").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Diciembre').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Importe").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                        $("#div_Total").jqxNumberInput({width: 130, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                        $('#btn_CancelarMensualizar').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarMensualizar').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarMensualizar').on('click', function () {
                            var enero = parseFloat($("#div_Enero").jqxNumberInput('decimal'));
                            var febrero = parseFloat($("#div_Febrero").jqxNumberInput('decimal'));
                            var marzo = parseFloat($("#div_Marzo").jqxNumberInput('decimal'));
                            var abril = parseFloat($("#div_Abril").jqxNumberInput('decimal'));
                            var mayo = parseFloat($("#div_Mayo").jqxNumberInput('decimal'));
                            var junio = parseFloat($("#div_Junio").jqxNumberInput('decimal'));
                            var julio = parseFloat($("#div_Julio").jqxNumberInput('decimal'));
                            var agosto = parseFloat($("#div_Agosto").jqxNumberInput('decimal'));
                            var setiembre = parseFloat($("#div_Setiembre").jqxNumberInput('decimal'));
                            var octubre = parseFloat($("#div_Octubre").jqxNumberInput('decimal'));
                            var noviembre = parseFloat($("#div_Noviembre").jqxNumberInput('decimal'));
                            var diciembre = parseFloat($("#div_Diciembre").jqxNumberInput('decimal'));
                            var msg = "";
                            if (msg === "") {
                                var total = enero + febrero + marzo + abril + mayo + junio +
                                        julio + agosto + setiembre + octubre + noviembre + diciembre;
                                var saldo = parseFloat(total) - parseFloat($("#div_Importe").val());
                                saldo = Math.round(saldo * 100) / 100;
                                if (saldo !== 0.00)
                                    msg = 'No puede guardar Mensualización. Existen diferencias = ' + saldo;
                            }
                            if (msg === "") {
                                var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                                var row = {dependencia: dataRecord.dependencia, cadenaGasto: dataRecord.cadenaGasto, importe: parseFloat(dataRecord.importe), enero: parseFloat(enero),
                                    febrero: parseFloat(febrero), marzo: parseFloat(marzo), abril: parseFloat(abril), mayo: parseFloat(mayo),
                                    junio: parseFloat(junio), julio: parseFloat(julio), agosto: parseFloat(agosto), setiembre: parseFloat(setiembre),
                                    octubre: parseFloat(octubre), noviembre: parseFloat(noviembre), diciembre: parseFloat(diciembre), modifica: 'Y'};
                                var rowID = $('#div_GrillaRegistro').jqxGrid('getrowid', indiceDetalle);
                                $('#div_GrillaRegistro').jqxGrid('updaterow', rowID, row);
                                $("#div_Mensualizar").jqxWindow('hide');
                                $('#div_Enero').val(0.0);
                                $('#div_Febrero').val(0.0);
                                $('#div_Marzo').val(0.0);
                                $('#div_Abril').val(0.0);
                                $('#div_Mayo').val(0.0);
                                $('#div_Junio').val(0.0);
                                $('#div_Julio').val(0.0);
                                $('#div_Agosto').val(0.0);
                                $('#div_Setiembre').val(0.0);
                                $('#div_Octubre').val(0.0);
                                $('#div_Noviembre').val(0.0);
                                $('#div_Diciembre').val(0.0);
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
                alto = 165;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_Reporte').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CerrarImprimir'),
                    initContent: function () {
                        $("#div_EJE0001").jqxRadioButton({width: 200, height: 20});
                        $('#div_EJE0001').on('checked', function (event) {
                            reporte = 'EJE0015';
                        });
                        $("#div_EJE0002").jqxRadioButton({width: 200, height: 20});
                        $('#div_EJE0002').on('checked', function (event) {
                            reporte = 'EJE0016';
                        });
                        $("#div_EJE0003").jqxRadioButton({width: 200, height: 20});
                        $('#div_EJE0003').on('checked', function (event) {
                            reporte = 'EJE0017';
                        });
                        $("#div_EJE0004").jqxRadioButton({width: 200, height: 20});
                        $('#div_EJE0004').on('checked', function (event) {
                            reporte = 'EJE0018';
                        });
                        $("#div_EJE0013").jqxRadioButton({width: 200, height: 20});
                        $('#div_EJE0013').on('checked', function (event) {
                            reporte = 'EJE0013';
                        });
                        $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').on('click', function (event) {
                            var msg = "";
                            switch (reporte) {
                                case "EJE0013":
                                    break;
                                case "EJE0015":
                                    break;
                                case "EJE0016":
                                    break;
                                case "EJE0017":
                                    break;
                                case "EJE0018":
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
            $("#div_Mensualizar").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaCNV").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../CalendarioGastos",
                data: {mode: "G", periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_RefrescarDetalle() {
            $('#div_Tarea').html(tarea);
            $('#div_GrillaRegistro').jqxGrid('clear');
            $.ajax({
                type: "GET",
                url: "../CalendarioGastos",
                data: {mode: 'B', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    data = data.replace("[", "");
                    var fila = data.split("[");
                    var rows = new Array();
                    for (i = 1; i < fila.length; i++) {
                        var columna = fila[i];
                        var datos = columna.split("+++");
                        while (datos[14].indexOf(']') > 0) {
                            datos[14] = datos[14].replace("]", "");
                        }
                        while (datos[14].indexOf(',') > 0) {
                            datos[14] = datos[14].replace(",", "");
                        }
                        var row = {dependencia: datos[0], cadenaGasto: datos[1], importe: parseFloat(datos[2]), enero: parseFloat(datos[3]),
                            febrero: parseFloat(datos[4]), marzo: parseFloat(datos[5]), abril: parseFloat(datos[6]), mayo: parseFloat(datos[7]),
                            junio: parseFloat(datos[8]), julio: parseFloat(datos[9]), agosto: parseFloat(datos[10]), setiembre: parseFloat(datos[11]),
                            octubre: parseFloat(datos[12]), noviembre: parseFloat(datos[13]), diciembre: parseFloat(datos[14])};
                        rows.push(row);
                    }
                    if (rows.length > 0)
                        $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA DE CNV
        function fn_RefrescarCNV() {
            $('#div_TareaCNV').html(tarea);
            $('#div_GrillaCNV').jqxGrid('clear');
            $.ajax({
                type: "GET",
                url: "../CalendarioGastos",
                data: {mode: 'C', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    data = data.replace("[", "");
                    var fila = data.split("[");
                    var rows = new Array();
                    for (i = 1; i < fila.length; i++) {
                        var columna = fila[i];
                        var datos = columna.split("+++");
                        while (datos[17].indexOf(']') > 0) {
                            datos[17] = datos[17].replace("]", "");
                        }
                        while (datos[17].indexOf(',') > 0) {
                            datos[17] = datos[17].replace(",", "");
                        }
                        var row = {evento: datos[0], nombreEvento: datos[1], nivel: datos[2], cantidad: datos[3], monto: parseFloat(datos[4]),
                            enero: parseFloat(datos[5]), febrero: parseFloat(datos[6]), marzo: parseFloat(datos[7]), abril: parseFloat(datos[8]),
                            mayo: parseFloat(datos[9]), junio: parseFloat(datos[10]), julio: parseFloat(datos[11]), agosto: parseFloat(datos[12]),
                            setiembre: parseFloat(datos[13]), octubre: parseFloat(datos[14]), noviembre: parseFloat(datos[15]), diciembre: parseFloat(datos[16]),
                            total: parseFloat(datos[17])};
                        rows.push(row);
                    }
                    if (rows.length > 0)
                        $("#div_GrillaCNV").jqxGrid('addrow', null, rows);
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
                    result = row.uid + "---" + fn_extraerDatos(row.dependencia, ':') + "---" + fn_extraerDatos(row.cadenaGasto, ':') +
                            "---" + parseFloat(row.enero) + "---" + parseFloat(row.febrero) + "---" + parseFloat(row.marzo) + "---" + parseFloat(row.abril) +
                            "---" + parseFloat(row.mayo) + "---" + parseFloat(row.junio) + "---" + parseFloat(row.julio) + "---" + parseFloat(row.agosto) +
                            "---" + parseFloat(row.setiembre) + "---" + parseFloat(row.octubre) + "---" + parseFloat(row.noviembre) + "---" + parseFloat(row.diciembre) + "---" + parseFloat(row.importe);
                    lista.push(result);
                }
            }
            if (lista.length === 0)
                msg += "No se ha realizado ninguna modificación <br>";
            if (msg === "") {
                $.ajax({
                    type: "POST",
                    url: "../IduCalendarioGastos",
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
    });
    //FUNCION PARA VALIDAR EL TOTAL DE CREDITO Y NO GENERE SALDO NEGATIVO
    function fn_TotalMensualizacion() {
        var total = $("#div_Enero").val() + $("#div_Febrero").val() + $("#div_Marzo").val() + $("#div_Abril").val() + $("#div_Mayo").val() + $("#div_Junio").val() +
                $("#div_Julio").val() + $("#div_Agosto").val() + $("#div_Setiembre").val() + $("#div_Octubre").val() + $("#div_Noviembre").val() + $("#div_Diciembre").val();
        $("#div_Total").val(parseFloat(total));
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
        <span style="float: left">CALENDARIO DE GASTOS</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_CalendarioGastos" name="frm_CalendarioGastos" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Tarea : </td>
                    <td><div id="div_Tarea"></div></td>                    
                </tr> 
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
<div id="div_VentanaCNV" style="display: none">
    <div>
        <span style="float: left">CALENDARIO DE GASTOS - CUADRO DE NECESIDADES VALORIZADAS</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_CalendarioGastosCNV" name="frm_CalendarioGastosCNV" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Tarea : </td>
                    <td><div id="div_TareaCNV"></div></td>                    
                </tr> 
                <tr>
                    <td colspan="2"><div id="div_GrillaCNV"></div>  </td>

                </tr> 
                <tr>
                    <td class="Summit" colspan="2">
                        <div> 
                            <input type="button" id="btn_Cerrar" value="Cerrar" style="margin-right: 20px"/>                            
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
        <li>Ver CNV</li>
    </ul>
</div>
<div id='div_Mensualizar' style='display: none;'>
    <div>
        Mensualización </div>
    <div>
        <div>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">  
                <tr class="TituloDetalle" style="text-align: center">
                    <td>Mes</td>
                    <td>Mensualizar</td>
                    <td>Mes</td>
                    <td>Mensualizar</td>
                </tr>
                <tr>
                    <td class="inputlabel">Enero : </td>
                    <td><div id="div_Enero"></div></td>                    
                    <td class="inputlabel">Febrero : </td>
                    <td><div id="div_Febrero"></div></td>                    
                <tr>
                    <td class="inputlabel">Marzo : </td>
                    <td><div id="div_Marzo"></div></td>
                    <td class="inputlabel">Abril : </td>
                    <td><div id="div_Abril"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Mayo : </td>
                    <td><div id="div_Mayo"></div></td>
                    <td class="inputlabel">Junio : </td>
                    <td><div id="div_Junio"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Julio : </td>
                    <td><div id="div_Julio"></div></td>
                    <td class="inputlabel">Agosto : </td>
                    <td><div id="div_Agosto"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Setiembre : </td>
                    <td><div id="div_Setiembre"></div></td>
                    <td class="inputlabel">Octubre : </td>
                    <td><div id="div_Octubre"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Noviembre : </td>
                    <td><div id="div_Noviembre"></div></td>
                    <td class="inputlabel">Diciembre : </td>
                    <td><div id="div_Diciembre"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Importe : </td>
                    <td><div id="div_Importe"></td>
                    <td class="inputlabel">Total : </td>
                    <td><div id="div_Total"></div></td>
                </tr>
                <tr>
                    <td class="Summit" colspan="4">
                        <div>
                            <input type="button" id="btn_GuardarMensualizar" value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarMensualizar" value="Cancelar" style="margin-right: 20px"/>                            
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
        <div id='div_EJE0001'>Calendario de Gastos</div>
        <div id='div_EJE0002'>Calendario de Gastos - Dependencias</div>
        <div id='div_EJE0003'>Listado de Notas Modificatorias</div>
        <div id='div_EJE0004'>Avance de Ejecución Presupuestal</div>        
        <div id='div_EJE0013'>Listado de Informes de Disponibilidad Presupuestal</div>        
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>
