<%-- 
    Document   : ListaNotaModificatoria
    Created on : 01/08/2017, 10:04:12 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = $("#cbo_Periodo").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var mes = $("#cbo_Mes").val();
    var codigo = null;
    var estado = null;
    var mode = null;
    var indiceDetalle = -1;
    var modeDetalle = null;
    var msg = null;
    var lista = new Array();
    <c:forEach var="c" items="${objNotaModificatoria}">
    var result = {codigo: '${c.codigo}', tipo: '${c.tipo}', credito: '${c.importeCredito}',
        anulacion: '${c.importeAnulacion}', justificacion: '${c.justificacion}', fecha: '${c.fecha}', estado: '${c.estado}',
        usuarioCierre: '${c.usuarioCierre}', fechaCierre: '${c.fechaCierre}', usuarioVerifica: '${c.usuarioVerifica}', fechaVerifica: '${c.fechaVerifica}',
        usuarioAprueba: '${c.usuarioAprobacion}', fechaAprueba: '${c.fechaAprobacion}', usuarioRechazo: '${c.usuarioRechazo}',
        fechaRechazo: '${c.fechaRechazo}', justificaRechazo: '${c.dependencia}', SIAF: '${c.SIAF}', consolidado: '${c.consolidado}'};
    lista.push(result);
    </c:forEach>
    var listaDet = new Array();
    <c:forEach var="d" items="${objNotaModificatoriaDetalle}">
    var result = {codigo: '${d.codigo}', detalle: '${d.detalle}', unidad: '${d.unidad}',
        dependencia: '${d.dependencia}', presupuesto: '${d.presupuesto}', tipoCalendario: '${d.tipoCalendario}',
        secuenciaFuncional: '${d.secuenciaFuncional}', tarea: '${d.tarea}', cadenaGasto: '${d.cadenaGasto}',
        anulacion: '${d.importeAnulacion}', credito: '${d.importeCredito}', justificacion: '${d.justificacion}'};
    listaDet.push(result);
    </c:forEach>
    $(document).ready(function () {
        var sourceNuevo = {
            datafields:
                    [
                        {name: "tipo", type: "string"},
                        {name: "unidad", type: "string"},
                        {name: "dependencia", type: "string"},
                        {name: "presupuesto", type: "string"},
                        {name: "tipoCalendario", type: "string"},
                        {name: "secuenciaFuncional", type: "string"},
                        {name: "tarea", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "anulacion", type: "number"},
                        {name: "credito", type: "number"},
                        {name: "justificacion", type: "string"}
                    ],
            pagesize: 20,
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            }
        };
        var dataNuevo = new $.jqx.dataAdapter(sourceNuevo);
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA DE META FISICA
        var sourceMeta = {
            datatype: "array",
            datafields:
                    [
                        {name: "presupuesto", type: "string"},
                        {name: "categoria", type: "string"},
                        {name: "producto", type: "string"},
                        {name: "actividad", type: "string"},
                        {name: "tarea", type: "string"},
                        {name: "generica", type: "string"},
                        {name: "unidad", type: "string"},
                        {name: "programado", type: "int"},
                        {name: "variacion", type: "int"},
                        {name: "nuevo", type: "int"}
                    ],
            pagesize: 10,
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            },
            updaterow: function (rowid, rowdata, commit) {
                var programado = $('#div_GrillaMetaFisica').jqxGrid('getcelltext', rowid, 'programado');
                var variacion = $('#div_GrillaMetaFisica').jqxGrid('getcelltext', rowid, 'variacion');
                $("#div_GrillaMetaFisica").jqxGrid('setcellvalue', rowid, "nuevo", parseInt(programado + variacion));
                commit(true);
            }
        };
        var dataMeta = new $.jqx.dataAdapter(sourceMeta);
        //PARA LA GRILLA DE LA CABECERA        
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "tipo", type: "string"},
                        {name: "credito", type: "number"},
                        {name: "anulacion", type: "number"},
                        {name: "justificacion", type: "string"},
                        {name: "fecha", type: "string"},
                        {name: "estado", type: "string"},
                        {name: "usuarioCierre", type: "string"},
                        {name: "fechaCierre", type: "string"},
                        {name: "usuarioVerifica", type: "string"},
                        {name: "fechaVerifica", type: "string"},
                        {name: "usuarioAprueba", type: "string"},
                        {name: "fechaAprueba", type: "string"},
                        {name: "usuarioRechazo", type: "string"},
                        {name: "fechaRechazo", type: "string"},
                        {name: "justificaRechazo", type: "string"},
                        {name: "SIAF", type: "string"},
                        {name: "consolidado", type: "string"}
                    ],
            root: "NotaModificatoria",
            record: "NotaModificatoria",
            id: 'codigo'
        };
        //PARA LA GRILLA DEL DETALLE 
        var sourceDet = {
            localdata: listaDet,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "detalle", type: "number"},
                        {name: "unidad", type: "string"},
                        {name: "dependencia", type: "string"},
                        {name: "presupuesto", type: "string"},
                        {name: "tipoCalendario", type: "string"},
                        {name: "secuenciaFuncional", type: "string"},
                        {name: "tarea", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "anulacion", type: "number"},
                        {name: "credito", type: "number"},
                        {name: "justificacion", type: "string"}
                    ],
            root: "NotaModificatoriaDetalle",
            record: "Detalle",
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
                    {name: "detalle", type: "number"},
                    {name: "unidad", type: "string"},
                    {name: "dependencia", type: "string"},
                    {name: "presupuesto", type: "string"},
                    {name: "tipoCalendario", type: "string"},
                    {name: "secuenciaFuncional", type: "string"},
                    {name: "tarea", type: "string"},
                    {name: "cadenaGasto", type: "string"},
                    {name: "anulacion", type: "number"},
                    {name: "credito", type: "number"},
                    {name: "justificacion", type: "string"}
                ],
                id: 'codigo',
                localdata: ordersbyid
            };
            var nestedGridAdapter = new $.jqx.dataAdapter(sourceNested);
            if (grid !== null) {
                grid.jqxGrid({
                    source: nestedGridAdapter,
                    width: '97%',
                    height: 320,
                    pageable: true,
                    filterable: true,
                    autoshowfiltericon: true,
                    columnsresize: true,
                    showaggregates: true,
                    showfilterrow: true,
                    showstatusbar: true,
                    statusbarheight: 20,
                    columns: [
                        {text: 'NRO', datafield: 'detalle', filterable: false, width: '2%', align: 'center', cellsAlign: 'center'},
                        {text: 'UU/OO', datafield: 'unidad', filtertype: 'checkedlist', width: '8%', align: 'center'},
                        {text: 'DEPENDENCIA', datafield: 'dependencia', filtertype: 'checkedlist', width: '8%', align: 'center'},
                        {text: 'PPTO', datafield: 'presupuesto', filtertype: 'list', width: '5%', align: 'center', cellsAlign: 'center'},
                        {text: 'SECUENCIA', datafield: 'secuenciaFuncional', filtertype: 'checkedlist', width: '15%', align: 'center'},
                        {text: 'TAREA', datafield: 'tarea', filtertype: 'checkedlist', width: '15%', align: 'center'},
                        {text: 'CADENA', datafield: 'cadenaGasto', filtertype: 'checkedlist', width: '20%', align: 'center', aggregates: [{'<b>Totales : </b>':
                                            function () {
                                                return  "";
                                            }}]},
                        {text: 'ANULACION', dataField: 'anulacion', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'CREDITO', dataField: 'credito', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'JUSTIFICACIÓN', datafield: 'justificacion', width: '20%', align: 'center'},
                        {text: 'CALENDARIO', datafield: 'tipoCalendario', filtertype: 'checkedlist', width: '8%', align: 'center'}
                    ]
                });
            }
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (rowdata['estado'] === "ANULADO") {
                return "RowAnulado";
            }
            if (datafield === "codigo" || datafield === "consolidado" || datafield === "usuarioCierre" || datafield === "variacion") {
                return "RowBold";
            }
            if (datafield === "SIAF") {
                return "RowGreen";
            }
            if (datafield === "credito" || datafield === "programado") {
                return "RowBlue";
            }
            if (datafield === "anulacion" || datafield === "nuevo") {
                return "RowBrown";
            }
            if (datafield === "usuarioAprueba") {
                return "RowPurple";
            }
            if (datafield === "usuarioRechazo") {
                return "RowRed";
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
            showtoolbar: true,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var addCabeceraButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var exportButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var reporteButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(addCabeceraButton);
                container.append(exportButton);
                container.append(reporteButton);
                toolbar.append(container);
                addCabeceraButton.jqxButton({width: 30, height: 22});
                addCabeceraButton.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                exportButton.jqxButton({width: 30, height: 22});
                exportButton.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                reporteButton.jqxButton({width: 30, height: 22});
                reporteButton.jqxTooltip({position: 'bottom', content: "Reporte"});
                // Adicionar un Nuevo Registro en la Cabecera.
                addCabeceraButton.click(function (event) {
                    mode = 'I';
                    $('#div_GrillaRegistro').jqxGrid('clear');
                    $('#txt_Motivo').val('');
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //export to excel
                exportButton.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'NotasModificatorias');
                });
                reporteButton.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 350, rowdetailshidden: true},
            columns: [
                {text: 'CODIGO', dataField: 'codigo', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'JUSTIFICACIÓN', dataField: 'justificacion', width: '25%', align: 'center', cellclassname: cellclass},
                {text: 'TIPO', dataField: 'tipo', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ANULACION', dataField: 'anulacion', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'CREDITO', dataField: 'credito', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'CONSOL.', dataField: 'consolidado', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'N° SIAF', dataField: 'SIAF', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FECHA', dataField: 'fecha', columntype: 'datetimeinput', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'CERRADO POR : ', dataField: 'usuarioCierre', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'FECHA CIERRE', dataField: 'fechaCierre', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'VERIFICADO POR : ', dataField: 'usuarioVerifica', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'FECHA VERI.', dataField: 'fechaVerifica', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'APROBADO POR : ', dataField: 'usuarioAprueba', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'FECHA APRO.', dataField: 'fechaAprueba', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'RECHAZADO POR : ', dataField: 'usuarioRechazo', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'FECHA RECHA.', dataField: 'fechaRechazo', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'MOTIVO', dataField: 'justificaRechazo', width: '15%', align: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL 
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 185, autoOpenPopup: false, mode: 'popup'});
        $("#div_GrillaPrincipal").on('contextmenu', function () {
            return false;
        });
        $("#div_GrillaPrincipal").on('rowclick', function (event) {
            if (event.args.rightclick) {
                $("#div_GrillaPrincipal").jqxGrid('selectrow', event.args.rowindex);
                var scrollTop = $(window).scrollTop();
                var scrollLeft = $(window).scrollLeft();
                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
                return false;
            }
        });
        // handle context menu clicks.
        $("#div_ContextMenu").on('itemclick', function (event) {
            var opcion = event.args;
            if (codigo === null || codigo === '') {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'Debe Seleccionar un Registro',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
            } else if (estado !== 'ANULADO') {
                if ($.trim($(opcion).text()) === "Editar") {
                    mode = 'U';
                    fn_EditarCab();
                } else if ($.trim($(opcion).text()) === "Anular") {
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: '¿Desea Anular este Registro?',
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
                                    fn_GrabarDatosEstados('');
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                } else if ($.trim($(opcion).text()) === "Meta Fisica") {
                    mode = 'M';
                    fn_verMetaFisica();
                } else if ($.trim($(opcion).text()) === "Informe") {
                    mode = 'A';
                    fn_verInforme();
                } else if ($.trim($(opcion).text()) === "Cerrar") {
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: '¿Desea Cerrar esta Nota Modificatoria?',
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
                                    mode = 'C';
                                    fn_GrabarDatosEstados('');
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                } else if ($.trim($(opcion).text()) === "Rechazar") {
                    if (autorizacion === 'true') {
                        $.confirm({
                            theme: 'material',
                            title: 'RECHAZAR NOTA',
                            content: '' +
                                    '<form action="" class="formName">' +
                                    '<div class="form-group">' +
                                    '<label>Motivo : </label>' +
                                    '<input type="text" placeholder="Ingrese Motivo de Rechazo" class="motivo form-control" required />' +
                                    '</div>' +
                                    '</form>',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'blue',
                            typeAnimated: true,
                            buttons: {
                                aceptar: {
                                    text: 'Aceptar',
                                    btnClass: 'btn-primary',
                                    keys: ['enter', 'shift'],
                                    action: function () {
                                        var motivo = this.$content.find('.motivo').val();
                                        if (!motivo) {
                                            $.alert('Ingrese el Motivo del Rechazo');
                                            return false;
                                        }
                                        mode = 'R';
                                        fn_GrabarDatosEstados(motivo);
                                    }
                                },
                                cancelar: function () {
                                }
                            }
                        });
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Usuario no Autorizado para realizar este Tipo de Operación',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                } else if ($.trim($(opcion).text()) === "Verificar") {
                    if (autorizacion === 'true') {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Verificar esta Nota Modificatoria?',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'blue',
                            typeAnimated: true,
                            buttons: {
                                aceptar: {
                                    text: 'Aceptar',
                                    btnClass: 'btn-primary',
                                    keys: ['enter', 'shift'],
                                    action: function () {
                                        mode = 'V';
                                        fn_GrabarDatosEstados('');
                                    }
                                },
                                cancelar: function () {
                                }
                            }
                        });
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Usuario no Autorizado para realizar este Tipo de Operación',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                }
            } else {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'No puede realizar este Tipo de Operación, Registro Anulado',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            }
        });
        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
            estado = row['estado'];
        });
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: 395,
            source: dataNuevo,
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
                var addButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var editButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/update42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var deleteButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/delete42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                container.append(addButtonDet);
                container.append(editButtonDet);
                container.append(deleteButtonDet);
                toolbar.append(container);
                addButtonDet.jqxButton({width: 30, height: 22});
                addButtonDet.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                editButtonDet.jqxButton({width: 30, height: 22});
                editButtonDet.jqxTooltip({position: 'bottom', content: "Editar Registro"});
                deleteButtonDet.jqxButton({width: 30, height: 22});
                deleteButtonDet.jqxTooltip({position: 'bottom', content: "Anular Registro"});
                // add new row.
                addButtonDet.click(function (event) {
                    msg = '';
                    modeDetalle = 'I';
                    var tipoNota = $("#cbo_TipoNotaModificatoria").val();
                    if (tipoNota === '0')
                        msg += "Seleccione el Tipo de Modificación a realizar";
                    if (unidadOperativa !== '0003' && (tipoNota === '001' || tipoNota === '002'))
                        msg += "Unidad Operativa no autorizada para este Tipo de Modificación";
                    if (msg === '') {
                        if (tipoNota === '001') {
                            $("#cbo_Tipo").jqxDropDownList('selectItem', 'A');
                            $("#cbo_Tipo").jqxDropDownList({disabled: true});
                            $("#cbo_DependenciaAbono").jqxDropDownList({disabled: true});
                            fn_cargarComboAjax("#cbo_Unidad", {mode: 'unidadNotaModificatoria', unidadOperativa: unidadOperativa, tipoNota: tipoNota, tipo: 'A'});
                        } else if (tipoNota === '002' || tipoNota === '005') {
                            $("#cbo_Tipo").jqxDropDownList('selectItem', 'C');
                            $("#cbo_Tipo").jqxDropDownList({disabled: true});
                            $("#cbo_DependenciaAbono").jqxDropDownList({disabled: false});
                            fn_cargarComboAjax("#cbo_Unidad", {mode: 'unidadNotaModificatoria', unidadOperativa: unidadOperativa, tipoNota: tipoNota, tipo: 'C'});
                        } else {
                            $("#cbo_Tipo").jqxDropDownList('selectItem', 0);
                            $("#cbo_Tipo").jqxDropDownList({disabled: false});
                            $("#cbo_DependenciaAbono").jqxDropDownList({disabled: true});
                        }
                        $("#cbo_Unidad").jqxDropDownList('clear');
                        $("#cbo_Presupuesto").jqxDropDownList('clear');
                        $("#cbo_Resolucion").jqxDropDownList('clear');
                        $("#cbo_TipoCalendario").jqxDropDownList('clear');
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        $('#div_Importe').val(0);
                        $('#txt_Justificacion').val('');
                        $("#cbo_Unidad").jqxDropDownList({disabled: false});
                        $("#cbo_Presupuesto").jqxDropDownList({disabled: false});
                        $("#cbo_Resolucion").jqxDropDownList({disabled: false});
                        $("#cbo_TipoCalendario").jqxDropDownList({disabled: false});
                        $("#cbo_Dependencia").jqxDropDownList({disabled: false});
                        $("#cbo_SecuenciaFuncional").jqxDropDownList({disabled: false});
                        $("#cbo_Tarea").jqxDropDownList({disabled: false});
                        $("#cbo_CadenaGasto").jqxDropDownList({disabled: false});
                        $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.5});
                        $('#div_VentanaDetalle').jqxWindow('open');
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
                });
                editButtonDet.click(function (event) {
                    modeDetalle = 'U';
                    if (indiceDetalle >= 0) {
                        var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                        $("#cbo_Tipo").jqxDropDownList('setContent', dataRecord.tipo);
                        $("#cbo_Tipo").jqxDropDownList({disabled: true});
                        $("#cbo_Unidad").jqxDropDownList('clear');
                        $("#cbo_Unidad").jqxDropDownList({disabled: true});
                        $("#cbo_Unidad").jqxDropDownList('setContent', dataRecord.unidad);
                        $("#cbo_Presupuesto").jqxDropDownList('clear');
                        $("#cbo_Presupuesto").jqxDropDownList({disabled: true});
                        $("#cbo_Presupuesto").jqxDropDownList('setContent', dataRecord.presupuesto);
                        $("#cbo_Resolucion").jqxDropDownList('clear');
                        $("#cbo_Resolucion").jqxDropDownList({disabled: true});
                        $("#cbo_Resolucion").jqxDropDownList('setContent', dataRecord.resolucion);
                        $("#cbo_TipoCalendario").jqxDropDownList('clear');
                        $("#cbo_TipoCalendario").jqxDropDownList({disabled: true});
                        $("#cbo_TipoCalendario").jqxDropDownList('setContent', dataRecord.tipoCalendario);
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_Dependencia").jqxDropDownList('setContent', dataRecord.dependencia);
                        $("#cbo_Dependencia").jqxDropDownList({disabled: true});
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('setContent', dataRecord.secuenciaFuncional);
                        $("#cbo_SecuenciaFuncional").jqxDropDownList({disabled: true});
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('setContent', dataRecord.tarea);
                        $("#cbo_Tarea").jqxDropDownList({disabled: true});
                        $("#cbo_CadenaGasto").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.cadenaGasto, ':'));
                        $("#cbo_CadenaGasto").jqxDropDownList({disabled: true});
                        $('#div_Importe').val(dataRecord.anulacion + dataRecord.credito);
                        $('#txt_Justificacion').val(dataRecord.justificacion);
                        $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_VentanaDetalle').jqxWindow('open');
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
                // delete selected row.
                deleteButtonDet.click(function (event) {
                    modeDetalle = 'D';
                    if (indiceDetalle >= 0) {
                        var rowid = $("#div_GrillaRegistro").jqxGrid('getrowid', indiceDetalle);
                        $("#div_GrillaRegistro").jqxGrid('deleterow', rowid);
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
            },
            columns: [
                {text: 'UU/OO', datafield: 'unidad', width: '10%', align: 'center'},
                {text: 'DEPENDENCIA', datafield: 'dependencia', width: '10%', align: 'center'},
                {text: 'PPTO', datafield: 'presupuesto', width: '5%', align: 'center', cellsAlign: 'center'},
                {text: 'SECUENCIA', datafield: 'secuenciaFuncional', width: '15%', align: 'center'},
                {text: 'TAREA', datafield: 'tarea', width: '15%', align: 'center'},
                {text: 'CADENA', datafield: 'cadenaGasto', width: '20%', align: 'center'},
                {text: 'ANULACION', dataField: 'anulacion', width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CREDITO', dataField: 'credito', width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'JUSTIFICACIÓN', datafield: 'justificacion', width: '20%', align: 'center'},
                {text: 'RESOLUCION', datafield: 'resolucion', width: '15%', align: 'center'},
                {text: 'CALENDARIO', datafield: 'tipoCalendario', width: '10%', align: 'center'},
                {text: 'TIPO', datafield: 'tipo', width: '8%', align: 'center', cellsAlign: 'center'}
            ]
        });
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
            fn_cargarComboAjax("#cbo_CadenaGasto", {mode: 'cadenaGastoNotaModificatoria', periodo: periodo, unidadOperativa: unidadOperativa,
                tipoNota: $("#cbo_TipoNotaModificatoria").val(), tipo: dataRecord.tipo.substring(0, 1), presupuesto: fn_extraerDatos(dataRecord.presupuesto, ':'), resolucion: fn_extraerDatos(dataRecord.resolucion, ':'),
                tipoCalendario: fn_extraerDatos(dataRecord.tipoCalendario, ':'), dependencia: fn_extraerDatos(dataRecord.dependencia, ':'), secuenciaFuncional: fn_extraerDatos(dataRecord.secuenciaFuncional, ':'), tarea: fn_extraerDatos(dataRecord.tarea, ':')});
        });
        //INCIAMOS LOS VALORES DE GRILLA META FISICA
        $("#div_GrillaMetaFisica").jqxGrid({
            width: '100%',
            height: 350,
            source: dataMeta,
            pageable: true,
            columnsresize: true,
            enabletooltips: true,
            altrows: false,
            editable: true,
            autoheight: false,
            autorowheight: false,
            sortable: true,
            filterable: true,
            columns: [
                {text: 'UNIDAD', datafield: 'unidad', editable: false, width: '18%', align: 'center'},
                {text: 'TAREA', datafield: 'tarea', editable: false, width: '25%', align: 'center'},
                {text: 'PROGRAMADO', dataField: 'programado', editable: false, width: '12%', align: 'center', cellsAlign: 'right', cellclassname: cellclass, columntype: 'numberinput'},
                {text: 'VARIACION', dataField: 'variacion', width: '12%', align: 'center', cellsAlign: 'right', cellclassname: cellclass, columntype: 'numberinput',
                    createeditor: function (row, cellvalue, editor) {
                        editor.jqxNumberInput({decimalDigits: 0, digits: 6});
                    }
                },
                {text: 'NUEVO', dataField: 'nuevo', editable: false, width: '12%', align: 'center', cellsAlign: 'right', cellclassname: cellclass, columntype: 'numberinput'},
                {text: 'CATEGORIA', datafield: 'categoria', editable: false, width: '20%', align: 'center', cellsAlign: 'center'},
                {text: 'PRODUCTO', datafield: 'producto', editable: false, width: '20%', align: 'center', cellsAlign: 'center'},
                {text: 'ACTIVIDAD', datafield: 'actividad', editable: false, width: '20%', align: 'center', cellsAlign: 'center'},
                {text: 'PRESUPUESTO', datafield: 'presupuesto', editable: false, width: '20%', align: 'center', cellsAlign: 'center'}
            ]
        });
    });
    //Funcion de Refrescar o Actulizar los datos de la Grilla.
    function fn_EditarCab() {
        if (estado !== 'ANULADA') {
            mode = 'U';
            $.ajax({
                type: "GET",
                url: "../NotaModificatoria",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 4) {
                        $("#cbo_TipoNotaModificatoria").jqxDropDownList('selectItem', dato[0]);
                        $('#txt_Motivo').val(dato[1]);
                        var d = new Date(dato[2]);
                        d.setDate(d.getDate() + 1);
                        $('#txt_Fecha ').jqxDateTimeInput('setDate', d);
                        $('#div_GrillaRegistro').jqxGrid('clear');
                        $("#cbo_TipoNotaModificatoria").jqxDropDownList({disabled: true});
                        $.ajax({
                            type: "GET",
                            url: "../NotaModificatoria",
                            data: {mode: 'B', periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo},
                            success: function (data) {
                                data = data.replace("[", "");
                                var fila = data.split("[");
                                var rows = new Array();
                                for (i = 1; i < fila.length; i++) {
                                    var columna = fila[i];
                                    var datos = columna.split("+++");
                                    while (datos[23].indexOf(']') > 0) {
                                        datos[23] = datos[23].replace("]", "");
                                    }
                                    while (datos[23].indexOf(',') > 0) {
                                        datos[23] = datos[23].replace(",", "");
                                    }
                                    var row = {tipo: datos[0], unidad: datos[1], presupuesto: datos[2], tipoCalendario: datos[3], dependencia: datos[4],
                                        secuenciaFuncional: datos[5], tarea: datos[6], cadenaGasto: datos[7], anulacion: parseFloat(datos[8]), credito: parseFloat(datos[9]),
                                        justificacion: datos[10], resolucion: datos[11]};
                                    rows.push(row);
                                }
                                if (rows.length > 0)
                                    $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
                            }
                        });
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        } else {
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: 'No se puede realizar la Operacion, \nRegistro ANULADO!!',
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'red',
                typeAnimated: true
            });
        }
    }
    //FUNCION PARA CARGAR VENTANA DE METAS FISICAS
    function fn_verMetaFisica() {
        $.ajax({
            type: "GET",
            url: "../NotaModificatoria",
            data: {mode: 'U', periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo},
            success: function (result) {
                var dato = result.split("+++");
                if (dato.length === 4) {
                    $("#txt_MotivoMetaFisica").val(dato[1]);
                    $('#div_GrillaMetaFisica').jqxGrid('clear');
                    $.ajax({
                        type: "GET",
                        url: "../NotaModificatoria",
                        data: {mode: 'M', periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo},
                        success: function (data) {
                            data = data.replace("[", "");
                            var fila = data.split("[");
                            var rows = new Array();
                            for (i = 1; i < fila.length; i++) {
                                var columna = fila[i];
                                var datos = columna.split("+++");
                                while (datos[8].indexOf(']') > 0) {
                                    datos[8] = datos[8].replace("]", "");
                                }
                                while (datos[8].indexOf(',') > 0) {
                                    datos[8] = datos[8].replace(",", "");
                                }
                                var row = {categoria: datos[0], producto: datos[1], actividad: datos[2], tarea: datos[3], generica: datos[4], unidad: datos[5],
                                    programado: parseInt(datos[6]), variacion: parseInt(datos[7]), nuevo: parseInt(datos[6]) + parseInt(datos[7]), presupuesto: datos[8]};
                                rows.push(row);
                            }
                            if (rows.length > 0)
                                $("#div_GrillaMetaFisica").jqxGrid('addrow', null, rows);
                        }
                    });
                }
            }
        });
        $('#div_VentanaMetaFisica').jqxWindow({isModal: true});
        $('#div_VentanaMetaFisica').jqxWindow('open');
    }
    //FUNCION PARA CARGAR VENTANA DE INFORME (ANEXO 3)
    function fn_verInforme() {
        $.ajax({
            type: "GET",
            url: "../NotaModificatoria",
            data: {mode: 'A', periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo},
            success: function (result) {
                var dato = result.split("+++");
                if (dato.length === 4) {
                    $("#txt_Importancia").val(dato[0]);
                    $('#txt_Financiamiento').val(dato[1]);
                    $('#txt_Consecuencias').val(dato[2]);
                    $('#txt_Variacion').val(dato[3]);
                }
            }
        });
        $('#div_VentanaInforme').jqxWindow({isModal: true});
        $('#div_VentanaInforme').jqxWindow('open');
    }
    //FUNCION PARA ACTUALIZAR LOS DATOS DE LA NOTA MODIFICATORIA
    function fn_Refrescar() {
        $("#div_ContextMenu").remove();
        $("#div_RegistroDetalle").remove();
        $("#div_GrillaPrincipal").remove();
        $("#div_VentanaPrincipal").remove();
        $("#div_VentanaDetalle").remove();
        $("#div_VentanaMetaFisica").remove();
        $("#div_VentanaInforme").remove();
        $("#div_Reporte").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "POST",
            url: "../NotaModificatoria",
            data: {mode: 'G', periodo: periodo, unidadOperativa: unidadOperativa, mes: mes},
            success: function (data) {
                $contenidoAjax.html(data);
            }
        });
    }
    //Crea los Elementos de las Ventanas
    var customButtonsDemo = (function () {
        function _createElements() {
            //Inicia los Valores de Ventana de la Cabecera
            var posicionX, posicionY;
            var ancho = 850;
            var alto = 700;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaPrincipal').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_Cancelar'),
                initContent: function () {
                    $("#cbo_TipoNotaModificatoria").jqxDropDownList({animationType: 'fade', width: 650, height: 20});
                    $('#cbo_TipoNotaModificatoria').on('change', function () {
                        if ($("#cbo_TipoNotaModificatoria").val() === '005' || autorizacion === 'true') {
                            $("#div_Importe").jqxNumberInput({decimalDigits: 2});
                        } else {
                            $("#div_Importe").jqxNumberInput({decimalDigits: 0});
                        }
                    });
                    $("#txt_Fecha").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20, disabled: true});
                    $("#txt_Motivo").jqxInput({placeHolder: "MOTIVO", width: 650, height: 80, minLength: 1});
                    $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').on('click', function (event) {
                        $('#frm_NotaModificatoria').jqxValidator('validate');
                    });
                    $('#frm_NotaModificatoria').jqxValidator({
                        rules: [
                            {input: '#txt_Motivo', message: 'Ingrese Motivo de la Modificación!', action: 'keyup, blur', rule: 'required'}
                        ]
                    });
                    $('#frm_NotaModificatoria').jqxValidator({
                        onSuccess: function () {
                            fn_GrabarDatos();
                        }
                    });
                }
            });
            //Inicia los Valores de Ventana del Detalle
            ancho = 750;
            alto = 340;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaDetalle').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CancelarDetalle'),
                initContent: function () {
                    $("#cbo_Tipo").jqxDropDownList({animationType: 'fade', width: 150, height: 20});
                    $('#cbo_Tipo').on('change', function () {
                        $("#cbo_Unidad").jqxDropDownList('clear');
                        $("#cbo_DependenciaAbono").jqxDropDownList('clear');
                        $("#cbo_Presupuesto").jqxDropDownList('clear');
                        $("#cbo_Resolucion").jqxDropDownList('clear');
                        $("#cbo_TipoCalendario").jqxDropDownList('clear');
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_Unidad", {mode: 'unidadNotaModificatoria', unidadOperativa: unidadOperativa,
                            tipoNota: $("#cbo_TipoNotaModificatoria").val(), tipo: $("#cbo_Tipo").val()});
                    });
                    $("#cbo_Unidad").jqxDropDownList({animationType: 'fade', width: 200, dropDownWidth: 250, height: 20});
                    $('#cbo_Unidad').on('change', function () {
                        $("#cbo_DependenciaAbono").jqxDropDownList('clear');
                        $("#cbo_Presupuesto").jqxDropDownList('clear');
                        $("#cbo_Resolucion").jqxDropDownList('clear');
                        $("#cbo_TipoCalendario").jqxDropDownList('clear');
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        if ($("#cbo_TipoNotaModificatoria").val() === '005') {
                            fn_cargarComboAjax("#cbo_DependenciaAbono", {mode: 'dependencia', unidadOperativa: $("#cbo_Unidad").val()});
                        } else {
                            fn_cargarComboAjax("#cbo_Presupuesto", {mode: 'presupuestoNotaModificatoria', periodo: periodo, unidadOperativa: unidadOperativa,
                                tipoNota: $("#cbo_TipoNotaModificatoria").val(), tipo: $("#cbo_Tipo").val()});
                        }
                    });
                    $("#cbo_DependenciaAbono").jqxDropDownList({animationType: 'fade', width: 200, dropDownWidth: 250, height: 20});
                    $('#cbo_DependenciaAbono').on('change', function () {
                        $("#cbo_Presupuesto").jqxDropDownList('clear');
                        $("#cbo_Resolucion").jqxDropDownList('clear');
                        $("#cbo_TipoCalendario").jqxDropDownList('clear');
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_Presupuesto", {mode: 'presupuestoNotaModificatoria', periodo: periodo, unidadOperativa: unidadOperativa,
                            tipoNota: $("#cbo_TipoNotaModificatoria").val(), tipo: $("#cbo_Tipo").val()});
                    });
                    $("#cbo_Presupuesto").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                    $('#cbo_Presupuesto').on('change', function () {
                        $("#cbo_Resolucion").jqxDropDownList('clear');
                        $("#cbo_TipoCalendario").jqxDropDownList('clear');
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_Resolucion", {mode: 'resolucionNotaModificatoria', periodo: periodo, unidadOperativa: unidadOperativa,
                            tipoNota: $("#cbo_TipoNotaModificatoria").val(), presupuesto: $("#cbo_Presupuesto").val(), tipo: $("#cbo_Tipo").val()});
                    });
                    $("#cbo_Resolucion").jqxDropDownList({animationType: 'fade', width: 630, dropDownWidth: 750, height: 20});
                    $('#cbo_Resolucion').on('change', function () {
                        $("#cbo_TipoCalendario").jqxDropDownList('clear');
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_TipoCalendario", {mode: 'tipoCalendarioNotaModificatoria', periodo: periodo, unidadOperativa: unidadOperativa,
                            tipoNota: $("#cbo_TipoNotaModificatoria").val(), tipo: $("#cbo_Tipo").val(), presupuesto: $("#cbo_Presupuesto").val(), resolucion: $("#cbo_Resolucion").val()});
                    });
                    $("#cbo_TipoCalendario").jqxDropDownList({animationType: 'fade', width: 630, height: 20});
                    $('#cbo_TipoCalendario').on('change', function () {
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_Dependencia", {mode: 'dependenciaNotaModificatoria', periodo: periodo, unidadOperativa: unidadOperativa,
                            tipoNota: $("#cbo_TipoNotaModificatoria").val(), tipo: $("#cbo_Tipo").val(), presupuesto: $("#cbo_Presupuesto").val(), resolucion: $("#cbo_Resolucion").val(),
                            tipoCalendario: $("#cbo_TipoCalendario").val()});
                    });
                    $("#cbo_Dependencia").jqxDropDownList({animationType: 'fade', width: 630, height: 20});
                    $('#cbo_Dependencia').on('change', function () {
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_SecuenciaFuncional", {mode: 'secuenciaFuncionalNotaModificatoria', periodo: periodo, unidadOperativa: unidadOperativa,
                            tipoNota: $("#cbo_TipoNotaModificatoria").val(), tipo: $("#cbo_Tipo").val(), presupuesto: $("#cbo_Presupuesto").val(), resolucion: $("#cbo_Resolucion").val(),
                            tipoCalendario: $("#cbo_TipoCalendario").val(), dependencia: $("#cbo_Dependencia").val()});
                    });
                    $("#cbo_SecuenciaFuncional").jqxDropDownList({animationType: 'fade', width: 630, dropDownWidth: 750, height: 20});
                    $('#cbo_SecuenciaFuncional').on('change', function () {
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_Tarea", {mode: 'tareaNotaModificatoria', periodo: periodo, unidadOperativa: unidadOperativa,
                            tipoNota: $("#cbo_TipoNotaModificatoria").val(), tipo: $("#cbo_Tipo").val(), presupuesto: $("#cbo_Presupuesto").val(), resolucion: $("#cbo_Resolucion").val(),
                            tipoCalendario: $("#cbo_TipoCalendario").val(), dependencia: $("#cbo_Dependencia").val(), secuenciaFuncional: $("#cbo_SecuenciaFuncional").val()});
                    });
                    $("#cbo_Tarea").jqxDropDownList({animationType: 'fade', width: 630, dropDownWidth: 750, height: 20});
                    $('#cbo_Tarea').on('change', function () {
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_CadenaGasto", {mode: 'cadenaGastoNotaModificatoria', periodo: periodo, unidadOperativa: unidadOperativa,
                            tipoNota: $("#cbo_TipoNotaModificatoria").val(), tipo: $("#cbo_Tipo").val(), presupuesto: $("#cbo_Presupuesto").val(), resolucion: $("#cbo_Resolucion").val(),
                            tipoCalendario: $("#cbo_TipoCalendario").val(), dependencia: $("#cbo_Dependencia").val(), secuenciaFuncional: $("#cbo_SecuenciaFuncional").val(), tarea: $("#cbo_Tarea").val()});
                    });
                    $("#cbo_CadenaGasto").jqxDropDownList({animationType: 'fade', width: 630, dropDownWidth: 750, height: 20});
                    $("#div_Importe").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                    $("#txt_Justificacion").jqxInput({placeHolder: "JUSTIFICACION", width: 630, height: 50, minLength: 10});
                    $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarDetalle').on('click', function () {
                        var tipo = $("#cbo_Tipo").val();
                        var unidad = $("#cbo_Unidad").jqxDropDownList('getSelectedItem');
                        var presupuesto = $("#cbo_Presupuesto").jqxDropDownList('getSelectedItem');
                        var resolucion = $("#cbo_Resolucion").jqxDropDownList('getSelectedItem');
                        var tipoCalendario = $("#cbo_TipoCalendario").jqxDropDownList('getSelectedItem');
                        var dependencia = $("#cbo_Dependencia").jqxDropDownList('getSelectedItem');
                        var dependenciaAbono = $("#cbo_DependenciaAbono").jqxDropDownList('getSelectedItem');
                        var secuenciaFuncional = $("#cbo_SecuenciaFuncional").jqxDropDownList('getSelectedItem');
                        var tarea = $("#cbo_Tarea").jqxDropDownList('getSelectedItem');
                        var cadenaGasto = $("#cbo_CadenaGasto").jqxDropDownList('getSelectedItem');
                        var anulacion = 0.0;
                        var credito = 0.0;
                        var result = "";
                        if (modeDetalle === 'I') {
                            if (tipo === null)
                                result += "Debe Seleccionar el Tipo de Operación.<br>";
                            if (unidad === null)
                                result += "Debe Seleccionar la Unidad Operativa.<br>";
                            if (presupuesto === null)
                                result += "Debe Seleccionar la Fuente de Financiamiento.<br>";
                            if (resolucion === null)
                                result += "Debe Seleccionar la Resolución.<br>";
                            if (tipoCalendario === null)
                                result += "Debe Seleccionar el Tipo de Calendario.<br>";
                            if (dependencia === null)
                                result += "Debe Seleccionar la Dependencia.<br>";
                            if (secuenciaFuncional === null)
                                result += "Debe Seleccionar la Secuencia Funcional.<br>";
                            if (tarea === null)
                                result += "Debe Seleccionar la Tarea Presupuestal.<br>";
                            if (cadenaGasto === null)
                                result += "Debe Seleccionar la Cadena de Gasto.<br>";
                        }
                        if ($("#txt_Justificacion").val().length <= 10)
                            result += "Debe Ingresar una Justificación concisa.<br>";
                        if (parseFloat($("#div_Importe").jqxNumberInput('decimal')) <= 0.0)
                            result += "Ingrese un Importe valido.<br>";
                        if (result === "")
                            result += fn_validaSaldo();
                        if (result === "") {
                            if (modeDetalle === 'I') {
                                if (tipo === 'A') {
                                    tipo = 'Anulación';
                                    anulacion = parseFloat($("#div_Importe").jqxNumberInput('decimal'));
                                    unidad = unidad.label;
                                    presupuesto = presupuesto.label;
                                    resolucion = fn_extraerDatos(resolucion.label, 'S/.');
                                    tipoCalendario = fn_extraerDatos(tipoCalendario.label, 'S/.');
                                    dependencia = fn_extraerDatos(dependencia.label, 'S/.');
                                    secuenciaFuncional = fn_extraerDatos(secuenciaFuncional.label, 'S/.');
                                    tarea = fn_extraerDatos(tarea.label, 'S/.');
                                    cadenaGasto = fn_extraerDatos(cadenaGasto.label, 'S/.');
                                }
                                if (tipo === 'C') {
                                    tipo = 'Crédito';
                                    credito = parseFloat($("#div_Importe").jqxNumberInput('decimal'));
                                    unidad = unidad.label;
                                    presupuesto = presupuesto.label;
                                    resolucion = resolucion.label;
                                    tipoCalendario = tipoCalendario.label;
                                    dependencia = dependencia.label;
                                    if ($("#cbo_TipoNotaModificatoria").val() === '005') {
                                        dependencia = dependenciaAbono.label;
                                        resolucion = fn_extraerDatos(resolucion, 'S/.');
                                    }
                                    secuenciaFuncional = secuenciaFuncional.label;
                                    tarea = tarea.label;
                                    cadenaGasto = cadenaGasto.label;
                                }
                            }
                        }
                        if (result === "" && modeDetalle === 'I') {
                            result += fn_ValidaSaldoAnulacion(credito, 0);
                            result += fn_validaDetalle(tipo, unidad, presupuesto, resolucion, tipoCalendario, dependencia, secuenciaFuncional, tarea, cadenaGasto);
                        }
                        if (result === "" && modeDetalle === 'U') {
                            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                            result += fn_ValidaSaldoAnulacion(credito, dataRecord.credito);
                            result += fn_validaDetalle(dataRecord.tipo, dataRecord.unidad, dataRecord.presupuesto, dataRecord.resolucion, dataRecord.tipoCalendario, dataRecord.dependencia, dataRecord.secuenciaFuncional, dataRecord.tarea, dataRecord.cadenaGasto);
                        }
                        if (result === "" && $("#cbo_TipoNotaModificatoria").val() === '005') {
                            var dependenciaAnulacion = $("#cbo_Dependencia").jqxDropDownList('getSelectedItem');
                            dependenciaAnulacion = dependenciaAnulacion.label;
                            var unidadAnulacion = $("#cbo_UnidadOperativa").jqxComboBox('getSelectedItem');
                            unidadAnulacion = unidadAnulacion.label;
                            result += fn_registraAnulaciones('Anulacion', unidadAnulacion, presupuesto, resolucion, tipoCalendario, dependenciaAnulacion, secuenciaFuncional, tarea, cadenaGasto, credito);
                        }
                        if (result === "") {
                            if (modeDetalle === 'I') {
                                var row = {tipo: tipo, unidad: unidad, presupuesto: presupuesto, resolucion: resolucion, tipoCalendario: tipoCalendario,
                                    dependencia: dependencia, secuenciaFuncional: secuenciaFuncional, tarea: tarea, cadenaGasto: cadenaGasto,
                                    anulacion: anulacion, credito: credito, justificacion: $("#txt_Justificacion").val().toUpperCase()};
                                $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
                            }
                            if (modeDetalle === 'U') {
                                var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                                if (dataRecord.tipo === 'Anulación')
                                    anulacion = parseFloat($("#div_Importe").jqxNumberInput('decimal'));
                                if (dataRecord.tipo === 'Crédito')
                                    credito = parseFloat($("#div_Importe").jqxNumberInput('decimal'));
                                var row = {tipo: dataRecord.tipo, unidad: dataRecord.unidad, presupuesto: dataRecord.presupuesto, resolucion: dataRecord.resolucion, tipoCalendario: dataRecord.tipoCalendario, dependencia: dataRecord.dependencia,
                                    secuenciaFuncional: dataRecord.secuenciaFuncional, tarea: dataRecord.tarea, cadenaGasto: dataRecord.cadenaGasto, anulacion: anulacion, credito: credito, justificacion: $("#txt_Justificacion").val().toUpperCase()};
                                var rowID = $('#div_GrillaRegistro').jqxGrid('getrowid', indiceDetalle);
                                $('#div_GrillaRegistro').jqxGrid('updaterow', rowID, row);
                            }
                            $("#cbo_TipoNotaModificatoria").jqxDropDownList({disabled: true});
                            modeDetalle = null;
                            $("#div_VentanaDetalle").jqxWindow('hide');
                        } else {
                            $.alert({
                                theme: 'material',
                                title: 'AVISO DEL SISTEMA',
                                content: result,
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
                    $("#div_EJE0022").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0022').on('checked', function (event) {
                        reporte = 'EJE0022';
                    });
                    $("#div_EJE0023").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0023').on('checked', function (event) {
                        reporte = 'EJE0023';
                    });
                    $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').on('click', function (event) {
                        var msg = "";
                        switch (reporte) {
                            case "EJE0022":
                                if (codigo === null)
                                    msg += "Seleccione la Nota Modificatoria.<br>";
                                break;
                            case "EJE0023":
                                if (codigo === null)
                                    msg += "Seleccione la Nota Modificatoria.<br>";
                                break;
                            default:
                                msg += "Debe selecciona una opción.<br>";
                                break;
                        }
                        if (msg === "") {
                            var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + "&codigo=" + codigo;
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
            //INICIA LOS VALORES DE LA VENTANA DE META FISICA
            ancho = 650;
            alto = 500;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaMetaFisica').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CancelarMetaFisica'),
                initContent: function () {
                    $('#txt_MotivoMetaFisica').jqxInput({height: 80, width: 480, disabled: true});
                    $('#btn_CancelarMetaFisica').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarMetaFisica').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarMetaFisica').on('click', function (event) {
                        fn_GrabarDatosMetaFisica();
                    });
                }
            });
            //INICIA LOS VALORES DE LA VENTANA DE INFORME (ANEXO 3)
            ancho = 550;
            alto = 480;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaInforme').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CancelarInforme'),
                initContent: function () {
                    $("#txt_Importancia").jqxInput({width: 540, height: 80, minLength: 1});
                    $("#txt_Financiamiento").jqxInput({width: 540, height: 80, minLength: 1});
                    $("#txt_Consecuencias").jqxInput({width: 540, height: 80, minLength: 1});
                    $("#txt_Variacion").jqxInput({width: 540, height: 80, minLength: 1});
                    $('#btn_CancelarInforme').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarInforme').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarInforme').on('click', function (event) {
                        $('#frm_NotaModificatoriaInforme').jqxValidator('validate');
                    });
                    $('#frm_NotaModificatoriaInforme').jqxValidator({
                        rules: [
                            {input: '#txt_Importancia', message: 'Ingrese detalle requerido!', action: 'keyup, blur', rule: 'required'},
                            {input: '#txt_Financiamiento', message: 'Ingrese detalle requerido!', action: 'keyup, blur', rule: 'required'},
                            {input: '#txt_Consecuencias', message: 'Ingrese detalle requerido!', action: 'keyup, blur', rule: 'required'},
                            {input: '#txt_Variacion', message: 'Ingrese detalle requerido!', action: 'keyup, blur', rule: 'required'}
                        ]
                    });
                    $('#frm_NotaModificatoriaInforme').jqxValidator({
                        onSuccess: function () {
                            fn_GrabarDatosInforme();
                        }
                    });
                }
            });
        }
        return {
            init: function () {
                _createElements();
            }
        };
    }());
    $(document).ready(function () {
        customButtonsDemo.init();
        fn_cargarComboAjax("#cbo_TipoNotaModificatoria", {mode: 'tipoNotaModificatoria', unidadOperativa: unidadOperativa});
    });
    //FUNCION PARA GRABAR LOS DATOS DE LA NOTA MODIFICATORIA
    function fn_GrabarDatos() {
        var msg = "";
        var tipo = $("#cbo_TipoNotaModificatoria").val();
        var fecha = $('#txt_Fecha').val();
        var motivo = $("#txt_Motivo").val();
        var lista = new Array();
        var result;
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            result = row.uid + "---" + row.tipo.substring(0, 1) + "---" + fn_extraerDatos(row.unidad, ':') + "---" + fn_extraerDatos(row.presupuesto, ':') + "---" + fn_extraerDatos(row.resolucion, ':') + "---" +
                    fn_extraerDatos(row.tipoCalendario, ':') + "---" + fn_extraerDatos(row.dependencia, ':') + "---" + fn_extraerDatos(row.secuenciaFuncional, ':') + "---" +
                    fn_extraerDatos(row.tarea, ':') + "---" + fn_extraerDatos(row.cadenaGasto, ':') + "---" + parseFloat(row.anulacion + row.credito) + "---" + row.justificacion;
            lista.push(result);
        }
        if (lista.length === 0)
            msg += "Ingrese el Detalle de la Nota Modificatoria.<br>";
        if (msg === "") {
            msg += fn_DetalleNotaModificatoria();
        }
        if (msg === "") {
            $.ajax({
                type: "POST",
                url: "../IduNotaModificatoria",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, mes: mes, codigo: codigo,
                    tipo: tipo, fecha: fecha, motivo: motivo, lista: JSON.stringify(lista)},
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
    //FUNCION PARA GRABAR LOS DATOS DE LA NOTA MODIFICATORIA - META FISICA
    function fn_GrabarDatosMetaFisica() {
        $.confirm({
            theme: 'material',
            title: 'AVISO DEL SISTEMA',
            content: '¿Desea Grabar la Variación de Metas Fisicas?',
            animation: 'zoom',
            closeAnimation: 'zoom',
            type: 'blue',
            typeAnimated: true,
            buttons: {
                aceptar: {
                    text: 'Aceptar',
                    btnClass: 'btn-primary',
                    keys: ['enter', 'shift'],
                    action: function () {
                        var lista = new Array();
                        var result;
                        var rows = $('#div_GrillaMetaFisica').jqxGrid('getrows');
                        for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                            result = fn_extraerDatos(row.generica, ':') + "" + fn_extraerDatos(row.categoria, ':') + "" + fn_extraerDatos(row.producto, ':') + "" +
                                    fn_extraerDatos(row.actividad, ':') + "" + fn_extraerDatos(row.tarea, ':') + "" + fn_extraerDatos(row.unidad, ':') + "---" +
                                    fn_extraerDatos(row.presupuesto, ':') + "---" + parseFloat(row.variacion);
                            lista.push(result);
                        }
                        $.ajax({
                            type: "POST",
                            url: "../IduNotaModificatoria",
                            data: {mode: 'M', periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo, lista: JSON.stringify(lista)},
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
                                                    $('#div_VentanaMetaFisica').jqxWindow('close');
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
                    }
                },
                cancelar: function () {
                }
            }
        });
    }
    //FUNCION PARA GRABAR LOS DATOS ESTADOS DE LA NOTA MODIFICATORIA
    function fn_GrabarDatosEstados(motivo) {
        $.ajax({
            type: "POST",
            url: "../IduNotaModificatoria",
            data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo, motivo: motivo},
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
                                    //$('#div_VentanaInforme').jqxWindow('close');
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
    }
    //FUNCION PARA GRABAR LOS DATOS DEL INFORME
    function fn_GrabarDatosInforme() {
        var importancia = $("#txt_Importancia").val();
        var financiamiento = $("#txt_Financiamiento").val();
        var consecuencias = $("#txt_Consecuencias").val();
        var variacion = $("#txt_Variacion").val();
        $.ajax({
            type: "POST",
            url: "../IduNotaModificatoria",
            data: {mode: 'A', periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo,
                importancia: importancia, financiamiento: financiamiento, consecuencias: consecuencias, variacion: variacion},
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
                                    $('#div_VentanaInforme').jqxWindow('close');
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
    }
    //FUNCION PARA VALIDAR LOS DATOS DE LA NOTA MODIFICATORIA
    function fn_DetalleNotaModificatoria() {
        var totalAnulacion, totalCredito, cantidad, unidad, totalUnidad, resolucion, totalResolucion, totalFuente, fuente;
        var result = "";
        totalAnulacion = totalCredito = cantidad = totalUnidad = totalResolucion = totalFuente = 0;
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            totalAnulacion = totalAnulacion + parseFloat(row.anulacion);
            totalCredito = totalCredito + parseFloat(row.credito);
            cantidad++;
            if (i === 0) {
                unidad = row.unidad.trim();
                resolucion = row.resolucion.trim().substring(0, row.resolucion.trim().indexOf(":") + 1);
                fuente = row.presupuesto.trim();
            } else {
                if (unidad !== row.unidad.trim())
                    totalUnidad++;
                if (resolucion !== row.resolucion.trim().substring(0, row.resolucion.trim().indexOf(":") + 1))
                    totalResolucion++;
                if (fuente !== row.presupuesto.trim())
                    totalFuente++;
            }
        }
        if (cantidad === 0)
            result = "Ingrese el Detalle de la Nota Modificatoria.<br>";
        //if (totalResolucion > 0)
          //  result = "La Nota Modificatoria solo debe contener una Resolucion, Revise.<br>";
        if (totalFuente > 0)
            result = "La Nota Modificatoria solo debe contener una Fuente de Financiamiento, Revise.<br>";
        switch ($("#cbo_TipoNotaModificatoria").val()) {
            case '001':
                if (parseFloat(totalCredito) > 0.0)
                    result += "No debe Ingresar Credito en este Tipo de Nota Modificatoria, Revise.<br>";
                break;
            case '002':
                if (parseFloat(totalAnulacion) > 0.0)
                    result += "No debe Ingresar Anulalcion en este Tipo de Nota Modificatoria, Revise.<br>";
                break;
            case '003':
                if (parseFloat(totalAnulacion) !== parseFloat(totalCredito))
                    result += "Los Totales de la Anulación con el Credito deben coincidir, Verifique.<br>";
                if (totalUnidad > 0)
                    result += "Revise las Unidades Operativas de la Nota Modificatoria.<br>";
                break;
            case '005':
                if (parseFloat(totalAnulacion) !== parseFloat(totalCredito))
                    result += "Los Totales de la Anulación con el Credito deben coincidir.<br>";
                if (totalUnidad === 0)
                    result += "Revise las Unidades Operativas de la Nota Modificatoria.<br>";
                break;
            default:
                result += "Opción Invalida, por favor revise el Tipo de Nota Modificatoria.<br>";
                break;
        }
        return result;
    }
    //FUNCION PARA VALIDAR EL SALDO DE LA NOTA MODIFICATORIA
    function fn_validaSaldo() {
        var cadena = $("#cbo_CadenaGasto").val();
        if (cadena.length !== 0) {
            if ($("#cbo_Tipo").val() === 'A') {
                var saldo = $("#cbo_CadenaGasto").jqxDropDownList('getSelectedItem');
                saldo = saldo.label;
                var importe = parseFloat($("#div_Importe").jqxNumberInput('decimal'));
                var monto = "";
                var len = 0;
                len = saldo.length;
                var pos = saldo.indexOf('S/.');
                monto = saldo.substring(pos + 3, len);
                monto = fn_reemplazarTodo(monto, ',', '');
                monto = parseFloat(monto);
                if (modeDetalle === 'U') {
                    var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                    monto = monto + parseFloat(dataRecord.importe);
                }
                if (importe > monto) {
                    return "No puede ingresar un importe superior a S/. " + monto + ". Revise!!!";
                } else if (importe === parseFloat('0')) {
                    return "No puede ingresar un importe Cero. Revise!!!";
                } else if (importe < 0) {
                    return "Debe ingresar un importe superior a Cero!!!";
                }
            } else {
                var importe = parseFloat($("#div_Importe").jqxNumberInput('decimal'));
                if (importe === parseFloat('0')) {
                    return "No puede ingresar un importe Cero. Revise!!!";
                } else if (importe < 0) {
                    return "Debe ingresar un importe superior a Cero!!!";
                }
            }
        } else {
            return "Seleccione la Cadena de Gasto";
        }
        return "";
    }
    //FUNCION PARA VALIDAR QUE NO SE REPITAN LOS REGISTROS DEL DETALLE
    function fn_validaDetalle(tipo, unidad, presupuesto, resolucion, tipoCalendario, dependencia, secuencia, tarea, cadenaGasto) {
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        if (modeDetalle === 'I') {
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (row.tipo.trim() === tipo.trim() && row.unidad.trim() === unidad.trim() && row.presupuesto.trim() === presupuesto.trim() && row.resolucion.trim() === resolucion.trim() &&
                        row.tipoCalendario.trim() === tipoCalendario.trim() && row.dependencia.trim() === dependencia.trim() && row.secuenciaFuncional.trim() === secuencia.trim() &&
                        row.tarea.trim() === tarea.trim() && row.cadenaGasto.trim() === cadenaGasto.trim()) {
                    return "Los Datos que desea registrar ya existen, Revise!!";
                }
            }
        }
        if (modeDetalle === 'U') {
            if (rows[indiceDetalle].tipo.trim() === tipo.trim() && rows[indiceDetalle].unidad.trim() === unidad.trim() && rows[indiceDetalle].presupuesto.trim() === presupuesto.trim() &&
                    rows[indiceDetalle].resolucion.trim() === resolucion.trim() && rows[indiceDetalle].tipoCalendario.trim() === tipoCalendario.trim() && rows[indiceDetalle].dependencia.trim() === dependencia.trim() &&
                    rows[indiceDetalle].secuenciaFuncional.trim() === secuencia.trim() && rows[indiceDetalle].tarea.trim() === tarea.trim() && rows[indiceDetalle].cadenaGasto.trim() === cadenaGasto.trim()) {
                return "";
            } else {
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (i !== indiceDetalle && row.tipo.trim() === tipo.trim() && row.unidad.trim() === unidad.trim() && row.presupuesto.trim() === presupuesto.trim() && row.resolucion.trim() === resolucion.trim() &&
                            row.tipoCalendario.trim() === tipoCalendario.trim() && row.dependencia.trim() === dependencia.trim() && row.secuenciaFuncional.trim() === secuencia.trim() && row.tarea.trim() === tarea.trim() &&
                            row.cadenaGasto.trim() === cadenaGasto.trim()) {
                        return "Los Datos que desea registrar ya existen, Revise!!";
                    }
                }
            }
        }
        return "";
    }
    function fn_registraAnulaciones(tipo, unidad, presupuesto, resolucion, tipoCalendario, dependencia, secuencia, tarea, cadenaGasto, importe) {
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        var anulacion = 0.0;
        var indice = null;
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            if (row.tipo.trim() === tipo.trim() && row.unidad.trim() === unidad.trim() && row.presupuesto.trim() === presupuesto.trim() && row.resolucion.trim() === resolucion.trim() &&
                    row.tipoCalendario.trim() === tipoCalendario.trim() && row.dependencia.trim() === dependencia.trim() && row.secuenciaFuncional.trim() === secuencia.trim() &&
                    row.tarea.trim() === tarea.trim() && row.cadenaGasto.trim() === cadenaGasto.trim()) {
                anulacion += parseFloat(row.anulacion);
                indice = i;
            }
        }
        var saldo = $("#cbo_CadenaGasto").jqxDropDownList('getSelectedItem');
        saldo = saldo.label;
        var importe = parseFloat($("#div_Importe").jqxNumberInput('decimal'));
        var len = 0;
        len = saldo.length;
        var pos = saldo.indexOf('S/.');
        saldo = saldo.substring(pos + 3, len);
        saldo = fn_reemplazarTodo(saldo, ',', '');
        saldo = parseFloat(saldo);
        if (parseFloat(importe + anulacion) > saldo) {
            return "No puede ingresar un importe superior a S/. " + parseFloat(saldo - anulacion) + ". Revise!!!";
        }
        var row = {tipo: tipo, unidad: unidad, presupuesto: presupuesto, resolucion: resolucion, tipoCalendario: tipoCalendario, dependencia: dependencia,
            secuenciaFuncional: secuencia, tarea: tarea, cadenaGasto: cadenaGasto, anulacion: parseFloat(importe + anulacion), credito: 0.0, justificacion: $("#txt_Justificacion").val().toUpperCase()};
        if (indice === null) {
            $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
        } else {
            var rowID = $('#div_GrillaRegistro').jqxGrid('getrowid', indice);
            $('#div_GrillaRegistro').jqxGrid('updaterow', rowID, row);
        }
        return "";
    }
    //FUNCION PARA VALIDAR EL TOTAL DE CREDITO Y NO GENERE SALDO NEGATIVO
    function fn_ValidaSaldoAnulacion(importeNuevo, importeAnterior) {
        if ($("#cbo_TipoNotaModificatoria").val() === '005' || $("#cbo_TipoNotaModificatoria").val() === '002') {
            return "";
        } else {
            if ($("#cbo_Tipo").val() === 'C') {
                var totalAnulacion, totalCredito;
                totalAnulacion = totalCredito = 0;
                var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    totalAnulacion += parseFloat(row.anulacion);
                    totalCredito += parseFloat(row.credito);
                }
                if (parseFloat(totalAnulacion - (totalCredito + importeNuevo - importeAnterior)) < 0)
                    return "Saldo Insuficiente para ingresar el detalle. Revise!!";
            }
        }
        return "";
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">REGISTRO DE NOTA MODIFICATORIA</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_NotaModificatoria" name="frm_NotaModificatoria" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Tipo : </td>
                    <td >
                        <select id="cbo_TipoNotaModificatoria" name="cbo_TipoNotaModificatoria">
                            <option value="0">Seleccione</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Fecha : </td>
                    <td ><div id="txt_Fecha"></div></td>
                </tr> 
                <tr>
                    <td class="inputlabel">Motivo : </td>
                    <td colspan="5"><textarea id="txt_Motivo" name="txt_Motivo" style="text-transform: uppercase;"/></textarea></td>
                </tr>          
                <tr>
                    <td class="Summit" colspan="6">
                        <div>
                            <input type="button" id="btn_Guardar"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_Cancelar" value="Cancelar" style="margin-right: 20px"/>
                        </div>
                    </td>
                </tr>
            </table>
            <div id="div_GrillaRegistro"></div>
            <div style="display: none" id="div_VentanaDetalle">
                <div>
                    <span style="float: left">DETALLE DE LA NOTA MODIFICATORIA</span>
                </div>
                <div style="overflow: hidden">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="inputlabel">Tipo : </td>
                            <td colspan="3">
                                <select id="cbo_Tipo" name="cbo_Tipo">
                                    <option value="0">Seleccione</option>
                                    <option value="A">Anulación</option>
                                    <option value="C">Crédito</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Unidad : </td>
                            <td>
                                <select id="cbo_Unidad" name="cbo_Unidad">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                            <td class="inputlabel">Dependencia : </td>
                            <td>
                                <select id="cbo_DependenciaAbono" name="cbo_DependenciaAbono">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Presupuesto : </td>
                            <td colspan="3">
                                <select id="cbo_Presupuesto" name="cbo_Presupuesto">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Resoluci&oacute;n : </td>
                            <td colspan="3">
                                <select id="cbo_Resolucion" name="cbo_Resolucion">
                                    <option value="0">Seleccione</option>
                                    <c:forEach var="a" items="${objResoluciones}">
                                        <option value="${a.codigo}">${a.descripcion}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Calendario : </td>
                            <td colspan="3">
                                <select id="cbo_TipoCalendario" name="cbo_TipoCalendario">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Dependencia : </td>
                            <td colspan="3">
                                <select id="cbo_Dependencia" name="cbo_Dependencia">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Sec. Func. : </td>
                            <td colspan="3">
                                <select id="cbo_SecuenciaFuncional" name="cbo_SecuenciaFuncional">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Tarea : </td>
                            <td colspan="3">
                                <select id="cbo_Tarea" name="cbo_Tarea">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Cad. Gasto : </td>
                            <td colspan="3">
                                <select id="cbo_CadenaGasto" name="cbo_CadenaGasto">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Importe S/. : </td>
                            <td colspan="3"><div id="div_Importe"></div></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Justificación : </td>
                            <td colspan="3"><textarea id="txt_Justificacion" name="txt_Justificacion" style="text-transform: uppercase;"/></textarea></td>
                        </tr>
                        <tr>
                            <td class="Summit" colspan="4" >
                                <div>
                                    <input type="button" id="btn_GuardarDetalle" name="btn_GuardarDetalle" value="Guardar" style="margin-right: 20px"/>
                                    <input type="button" id="btn_CancelarDetalle" name="btn_CancelarDetalle" value="Cancelar" style="margin-right: 20px"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </form>
    </div>
</div>
<div id="div_Reporte" style="display: none">
    <div>
        <span style="float: left">LISTADO DE REPORTES</span>
    </div>
    <div style="overflow: hidden">
        <div id='div_EJE0022'>Nota Modificatoria</div>
        <div id='div_EJE0023'>Informe - Anexo N° 3</div>
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>
<div id="div_VentanaMetaFisica" style="display: none">
    <div>
        <span style="float: left">NOTA MODIFICATORIA - META FISICA</span>
    </div>
    <div style="overflow: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="inputlabel">Descripción : </td>
                <td colspan="3"><textarea id="txt_MotivoMetaFisica" name="txt_MotivoMetaFisica" style="text-transform: uppercase;"/></textarea></td>
            </tr>
            <tr>
                <td colspan="4"><div id="div_GrillaMetaFisica"> </div></td>
            </tr>
            <tr>
                <td class="Summit" colspan="4">
                    <div>
                        <input type="button" id="btn_GuardarMetaFisica"  value="Guardar" style="margin-right: 20px"/>
                        <input type="button" id="btn_CancelarMetaFisica" value="Cancelar" style="margin-right: 20px"/>
                    </div>
                </td>
            </tr>
        </table> 
    </div>
</div>
<div id="div_VentanaInforme" style="display: none">
    <div>
        <span style="float: left">NOTA MODIFICATORIA - ANEXO N° 3</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_NotaModificatoriaInforme" name="frm_NotaModificatoriaInforme" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="TituloDetalle">¿Por qué es importante financiar la necesidad de gasto que se presenta?</td>
                </tr>
                <tr>
                    <td><textarea id="txt_Importancia" name="txt_Importancia"/></textarea></td>
                </tr>
                <tr>
                    <td class="TituloDetalle">¿Por qué no se cuenta con el financiamiento requerido?</td>
                </tr>
                <tr>
                    <td><textarea id="txt_Financiamiento" name="txt_Financiamiento"/></textarea></td>
                </tr>
                <tr>
                    <td class="TituloDetalle">¿Que gastos estamos desfinanciando y cuales serian las consecuencias de ello?</td>
                </tr>
                <tr>
                    <td><textarea id="txt_Consecuencias" name="txt_Consecuencias"/></textarea></td>
                </tr> 
                <tr>
                    <td class="TituloDetalle">¿La modificación presupuestal implica la variación de metas presupuestales y las metas fisicas del Plan Operativo?</td>
                </tr>
                <tr>
                    <td><textarea id="txt_Variacion" name="txt_Variacion"/></textarea></td>
                </tr> 
                <tr>
                    <td class="Summit">
                        <div>
                            <input type="button" id="btn_GuardarInforme"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarInforme" value="Cancelar" style="margin-right: 20px"/>
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
        <li>Anular</li> 
        <li>Meta Fisica</li> 
        <li>Informe</li>
        <li>Cerrar</li>
        <li type='separator'></li>
        <li style="font-weight: bold">Verificar</li>
        <li style="font-weight: bold;color: red">Rechazar</li>
    </ul>
</div>