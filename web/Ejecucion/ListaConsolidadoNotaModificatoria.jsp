<%-- 
    Document   : ListaConsolidadoNotaModificatoria
    Created on : 16/08/2017, 10:05:25 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = $("#cbo_Periodo").val();
    var mes = $("#cbo_Mes").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var codigo = null;
    var estado = null;
    var mode = null;
    var indiceDetalle = -1;
    var modeDetalle = null;
    var msg = null;
    var lista = new Array();
    <c:forEach var="c" items="${objConsolidadoNota}">
    var result = {codigo: '${c.consolidado}', anulacion: '${c.importeAnulacion}', credito: '${c.importeCredito}', SIAF: '${c.SIAF}', estado: '${c.estado}',
        proceso: '${c.actividad}', fecha: '${c.fecha}', usuario: '${c.usuario}', fechaAprueba: '${c.fechaAprobacion}', usuarioAprueba: '${c.usuarioAprobacion}',
        fechaCierre: '${c.fechaCierre}', usuarioCierre: '${c.usuarioCierre}', metaFisica: '${c.tipo}'};
    lista.push(result);
    </c:forEach>
    var listaDet = new Array();
    <c:forEach var="d" items="${objConsolidadoNotaDetalle}">
    var result = {codigo: '${d.consolidado}', unidad: '${d.unidad}', notaModificatoria: '${d.notaModificatoria}',
        justificacion: '${d.justificacion}', tipoNota: '${d.tipo}', anulacion: '${d.importeAnulacion}', credito: '${d.importeCredito}',
        sectorista: '${d.usuario}', fecha: '${d.fecha}', estado: '${d.estado}'};
    listaDet.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA DE LA NUEVO        
        var sourceNuevo = {
            datafields:
                    [
                        {name: "notaModificatoria", type: "string"},
                        {name: "unidad", type: "string"},
                        {name: "justificacion", type: "string"},
                        {name: "tipoNota", type: "string"},
                        {name: "anulacion", type: "number"},
                        {name: "credito", type: "number"},
                        {name: "sectorista", type: "string"},
                        {name: "estado", type: "string"}
                    ],
            pagesize: 20,
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            },
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            }
        };
        var dataNuevo = new $.jqx.dataAdapter(sourceNuevo);
        //PARA LA GRILLA DE LA NUEVO AÑADIR       
        var sourceAdd = {
            datafields:
                    [
                        {name: "notaModificatoria", type: "string"},
                        {name: "unidad", type: "string"},
                        {name: "justificacion", type: "string"},
                        {name: "tipoNota", type: "string"},
                        {name: "anulacion", type: "number"},
                        {name: "credito", type: "number"},
                        {name: "sectorista", type: "string"},
                        {name: "estado", type: "string"}
                    ],            
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            },
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            }
        };
        var dataAdd = new $.jqx.dataAdapter(sourceAdd);
        //PARA LA GRILLA DE LA CABECERA        
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "anulacion", type: "number"},
                        {name: "credito", type: "number"},
                        {name: "SIAF", type: "string"},
                        {name: "estado", type: "string"},
                        {name: "proceso", type: "string"},
                        {name: "fecha", type: "string"},
                        {name: "usuario", type: "string"},
                        {name: "fechaAprueba", type: "string"},
                        {name: "usuarioAprueba", type: "string"},
                        {name: "fechaCierre", type: "string"},
                        {name: "usuarioCierre", type: "string"},
                        {name: "metaFisica", type: "string"}
                    ],
            root: "ConsolidadoNotaModificatoria",
            record: "ConsolidadoNotaModificatoria",
            id: 'codigo'
        };
        //PARA LA GRILLA DEL DETALLE 
        var sourceDet = {
            localdata: listaDet,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "unidad", type: "string"},
                        {name: "notaModificatoria", type: "string"},
                        {name: "justificacion", type: "string"},
                        {name: "tipoNota", type: "string"},
                        {name: "anulacion", type: "number"},
                        {name: "credito", type: "number"},
                        {name: "sectorista", type: "string"},
                        {name: "fecha", type: "string"},
                        {name: "estado", type: "string"}
                    ],
            root: "ConsolidadoNotaModificatoriaDetalle",
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
                    {name: "unidad", type: "string"},
                    {name: "notaModificatoria", type: "string"},
                    {name: "justificacion", type: "string"},
                    {name: "tipoNota", type: "string"},
                    {name: "anulacion", type: "number"},
                    {name: "credito", type: "number"},
                    {name: "sectorista", type: "string"},
                    {name: "fecha", type: "string"},
                    {name: "estado", type: "string"}
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
                        {text: 'N° NOTA', datafield: 'notaModificatoria', width: '5%', align: 'center', cellsAlign: 'center'},
                        {text: 'UU/OO', datafield: 'unidad', filtertype: 'checkedlist', width: '8%', align: 'center'},
                        {text: 'JUSTIFICACIÓN', datafield: 'justificacion', width: '30%', align: 'center'},
                        {text: 'TIPO NOTA', datafield: 'tipoNota', filtertype: 'checkedlist', width: '15%', align: 'center', aggregates: [{'<b>Totales : </b>':
                                            function () {
                                                return "";
                                            }}]},
                        {text: 'ANULACION', dataField: 'anulacion', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'CREDITO', dataField: 'credito', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'SECTORISTA', datafield: 'sectorista', filtertype: 'checkedlist', width: '15%', align: 'center'},
                        {text: 'FECHA VERIF.', dataField: 'fecha', columntype: 'datetimeinput', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                        {text: 'ESTADO', datafield: 'estado', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center'}
                    ]
                });
            }
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (rowdata['estado'] === "ANULADO") {
                return "RowAnulado";
            }
            if (datafield === "codigo" || datafield === "consolidado" || datafield === "usuarioCierre") {
                return "RowBold";
            }
            if (datafield === "SIAF") {
                return "RowGreen";
            }
            if (datafield === "credito") {
                return "RowBlue";
            }
            if (datafield === "anulacion") {
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
                    $('#div_GrillaAdiciona').jqxGrid('clear');
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //export to excel
                exportButton.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ConsolidadoNotasModificatorias');
                });
                reporteButton.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 350, rowdetailshidden: true},
            columns: [
                {text: 'CONSOLIDADO', dataField: 'codigo', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ANULACION', dataField: 'anulacion', width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'CREDITO', dataField: 'credito', width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'N° SIAF', dataField: 'SIAF', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'PROCESO', dataField: 'proceso', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'META FISICA', dataField: 'metaFisica', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FECHA APRO.', dataField: 'fechaAprueba', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'APROBADO POR : ', dataField: 'usuarioAprueba', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'FECHA CIERRE', dataField: 'fechaCierre', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'CERRADO POR : ', dataField: 'usuarioCierre', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'FECHA CONSOL.', dataField: 'fecha', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'CONSOLIDADO POR : ', dataField: 'usuario', width: '15%', align: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL 
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 135, autoOpenPopup: false, mode: 'popup'});
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
                    mode = 'M';
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
                } else if ($.trim($(opcion).text()) === "Informe") {
                    mode = 'A';
                    fn_verInforme();
                } else if ($.trim($(opcion).text()) === "Cerrar") {
                    if (autorizacion === 'true') {
                        $.confirm({
                            theme: 'material',
                            title: 'CERRAR CONSOLIDADO DE NOTA MODIFICATORIA',
                            content: '' +
                                    '<form action="" class="formName">' +
                                    '<div class="form-group">' +
                                    '<label>Nro. SIAF : </label>' +
                                    '<input type="text" placeholder="Ingrese el Nro. SIAF" class="siaf form-control" required />' +
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
                                        var siaf = this.$content.find('.siaf').val();
                                        if (isNaN(siaf)) {
                                            $.alert('Número SIAF invalido!!');
                                            return false;
                                        }
                                        if (!siaf) {
                                            $.alert('Ingrese el Nro. de Nota SIAF!!');
                                            return false;
                                        }
                                        mode = 'C';
                                        fn_GrabarDatosEstados(siaf);
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
                } else if ($.trim($(opcion).text()) === "Aprobar") {
                    if (autorizacion === 'true') {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Aprobar el Consolidado de Nota Modificatoria?',
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
                                        mode = 'U';
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
            height: '380',
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
                var deleteButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/delete42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var reportButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                container.append(addButtonDet);
                container.append(deleteButtonDet);
                container.append(reportButtonDet);
                toolbar.append(container);
                addButtonDet.jqxButton({width: 30, height: 22});
                addButtonDet.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                deleteButtonDet.jqxButton({width: 30, height: 22});
                deleteButtonDet.jqxTooltip({position: 'bottom', content: "Reporte"});
                reportButtonDet.jqxButton({width: 30, height: 22});
                reportButtonDet.jqxTooltip({position: 'bottom', content: "Reporte"});
                // add new row.
                addButtonDet.click(function (event) {
                    msg = '';
                    modeDetalle = 'I';
                    $('#div_GrillaAdiciona').jqxGrid('clear');
                    $.ajax({
                        type: "GET",
                        url: "../ConsolidadoNotaModificatoria",
                        data: {mode: 'N', periodo: periodo, presupuesto: presupuesto},
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
                                var row = {unidad: datos[0], notaModificatoria: datos[1], justificacion: datos[2], tipoNota: datos[3],
                                    anulacion: parseFloat(datos[4]), credito: parseFloat(datos[5]), estado: datos[6], sectorista: datos[7]};
                                rows.push(row);
                            }
                            if (rows.length > 0)
                                $("#div_GrillaAdiciona").jqxGrid('addrow', null, rows);
                        }
                    });
                    $('#div_VentanaDetalle').jqxWindow({isModal: true});
                    $('#div_VentanaDetalle').jqxWindow('open');
                });
                // delete selected row.
                deleteButtonDet.click(function (event) {
                    modeDetalle = 'D';
                    if (indiceDetalle >= 0) {
                        $("#div_GrillaRegistro").jqxGrid('deleterow', indiceDetalle);
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
                reportButtonDet.click(function (event) {
                    if (indiceDetalle >= 0) {
                        var row = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                        var notaModificatoria = row['notaModificatoria'];
                        var unidad = row['unidad'].substring(0, 4);
                        var url = '../Reportes?reporte=EJE0022&periodo=' + periodo + '&unidadOperativa=' + unidad + "&codigo=" + notaModificatoria;
                        window.open(url, '_blank');
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
                {text: 'N° NOTA', datafield: 'notaModificatoria', width: '8%', align: 'center', cellsAlign: 'center'},
                {text: 'UU/OO', datafield: 'unidad', width: '20%', align: 'center'},
                {text: 'JUSTIFICACIÓN', datafield: 'justificacion', width: '40%', align: 'center'},
                {text: 'ANULACION', dataField: 'anulacion', width: '15%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CREDITO', dataField: 'credito', width: '15%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ESTADO', dataField: 'estado', width: '12%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'TIPO NOTA', datafield: 'tipoNota', width: '20%', align: 'center'},
                {text: 'SECTORISTA', datafield: 'sectorista', width: '20%', align: 'center'}
            ]
        });
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
        });
        $("#div_GrillaAdiciona").jqxGrid({
            width: '100%',
            height: '240',
            source: dataAdd,
            pageable: true,
            autoheight: false,
            autorowheight: true,
            columnsresize: true,
            altrows: true,
            editable: true,
            sortable: true,
            enabletooltips: true,
            selectionmode: 'checkbox',
            columns: [
                {text: 'UU/OO', datafield: 'unidad', editable: false, width: '20%', align: 'center'},
                {text: 'N° NOTA', datafield: 'notaModificatoria', editable: false, width: '10%', align: 'center', cellsAlign: 'center'},
                {text: 'JUSTIFICACIÓN', datafield: 'justificacion', editable: false, width: '35%', align: 'center'},
                {text: 'ANULACION', dataField: 'anulacion', editable: false, width: '15%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'CREDITO', dataField: 'credito', editable: false, width: '15%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass}
            ]
        });
    });
    //Funcion de Refrescar o Actulizar los datos de la Grilla.
    function fn_EditarCab() {
        if (estado !== 'ANULADA') {
            $('#div_GrillaRegistro').jqxGrid('clear');
            $.ajax({
                type: "GET",
                url: "../ConsolidadoNotaModificatoria",
                data: {mode: 'B', periodo: periodo, codigo: codigo},
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
                        var row = {unidad: datos[0], notaModificatoria: datos[1], justificacion: datos[2], tipoNota: datos[3],
                            anulacion: parseFloat(datos[4]), credito: parseFloat(datos[5]), estado: datos[6], sectorista: datos[7]};
                        rows.push(row);
                    }
                    if (rows.length > 0)
                        $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
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
    //FUNCION PARA CARGAR VENTANA DE INFORME (ANEXO 3)
    function fn_verInforme() {
        $.ajax({
            type: "GET",
            url: "../ConsolidadoNotaModificatoria",
            data: {mode: 'A', periodo: periodo, codigo: codigo},
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
            url: "../ConsolidadoNotaModificatoria",
            data: {mode: 'G', periodo: periodo, mes: mes, presupuesto: presupuesto},
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
            var alto = 450;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaPrincipal').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_Cancelar'),
                initContent: function () {
                    $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').on('click', function (event) {
                        fn_GrabarDatos();
                    });
                }
            });
            ancho = 700;
            alto = 300;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaDetalle').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CancelarDetalle'),
                initContent: function () {
                    $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 20});
                    $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 20});
                    $('#btn_GuardarDetalle').on('click', function (event) {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Añadir las Nota Modificatoria?',
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
                                        var rows = $('#div_GrillaAdiciona').jqxGrid('getselectedrowindexes');
                                        for (x = 0; x < rows.length; x++) {
                                            var data = $('#div_GrillaAdiciona').jqxGrid('getrowdata', rows[x]);
                                            var msg = fn_validaDetalle(data.unidad, data.notaModificatoria);
                                            if (msg === '') {
                                                var row = {notaModificatoria: data.notaModificatoria, unidad: data.unidad, justificacion: data.justificacion, anulacion: data.anulacion,
                                                    credito: data.credito, tipoNota: data.tipoNota, sectorista: data.sectorista, estado: data.estado};
                                                $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
                                            }
                                        }
                                        $('#div_VentanaDetalle').jqxWindow('close');
                                    }
                                },
                                cancelar: function () {
                                }
                            }
                        });
                    });
                }
            });
            ancho = 400;
            alto = 145;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_Reporte').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CerrarImprimir'),
                initContent: function () {
                    $("#div_EJE0024").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0024').on('checked', function (event) {
                        reporte = 'EJE0024';
                    });
                    $("#div_EJE0025").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0025').on('checked', function (event) {
                        reporte = 'EJE0025';
                    });
                    $("#div_EJE0026").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0026').on('checked', function (event) {
                        reporte = 'EJE0026';
                    });
                    $("#div_EJE0027").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0027').on('checked', function (event) {
                        reporte = 'EJE0027';
                    });

                    $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').on('click', function (event) {
                        var msg = "";
                        switch (reporte) {
                            case "EJE0024":
                                if (codigo === null)
                                    msg += "Seleccione el Consolidado de Nota Modificatoria.<br>";
                                break;
                            case "EJE0025":
                                if (codigo === null)
                                    msg += "Seleccione el Consolidado de Nota Modificatoria.<br>";
                                break;
                            case "EJE0026":
                                if (codigo === null)
                                    msg += "Seleccione el Consolidado de Nota Modificatoria.<br>";
                                break;
                            case "EJE0027":
                                if (codigo === null)
                                    msg += "Seleccione el Consolidado de Nota Modificatoria.<br>";
                                break;
                            default:
                                msg += "Debe selecciona una opción.<br>";
                                break;
                        }
                        if (msg === "") {
                            var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&presupuesto=' + presupuesto + '&codigo=' + codigo;
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
                    $('#btn_CancelarInforme').jqxButton({width: '65px', height: 20});
                    $('#btn_GuardarInforme').jqxButton({width: '65px', height: 20});
                    $('#btn_GuardarInforme').on('click', function (event) {
                        $('#frm_ConsolidadoNotaModificatoriaInforme').jqxValidator('validate');
                    });
                    $('#frm_ConsolidadoNotaModificatoriaInforme').jqxValidator({
                        rules: [
                            {input: '#txt_Importancia', message: 'Ingrese detalle requerido!', action: 'keyup, blur', rule: 'required'},
                            {input: '#txt_Financiamiento', message: 'Ingrese detalle requerido!', action: 'keyup, blur', rule: 'required'},
                            {input: '#txt_Consecuencias', message: 'Ingrese detalle requerido!', action: 'keyup, blur', rule: 'required'},
                            {input: '#txt_Variacion', message: 'Ingrese detalle requerido!', action: 'keyup, blur', rule: 'required'}
                        ]
                    });
                    $('#frm_ConsolidadoNotaModificatoriaInforme').jqxValidator({
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
    });
    //FUNCION PARA GRABAR LOS DATOS DE LA NOTA MODIFICATORIA
    function fn_GrabarDatos() {
        var msg = "";
        var lista = new Array();
        var result;
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            result = row.uid + "---" + fn_extraerDatos(row.unidad, ':') + "---" + row.notaModificatoria;
            lista.push(result);
        }
        if (lista.length === 0)
            msg += "Ingrese las Notas Modificatorias para su Consolidado.<br>";
        if (estado === 'ENVIADO')
            msg += "No puede Realizar este Tipo de Operación, <br>Consolidado APROBADO!!";
        if (msg === "") {
            $.ajax({
                type: "POST",
                url: "../IduConsolidadoNotaModificatoria",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, mes: mes, codigo: codigo, lista: JSON.stringify(lista)},
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
    //FUNCION PARA GRABAR LOS DATOS ESTADOS DE LA NOTA MODIFICATORIA
    function fn_GrabarDatosEstados(siaf) {
        $.ajax({
            type: "POST",
            url: "../IduConsolidadoNotaModificatoria",
            data: {mode: mode, periodo: periodo, presupuesto: presupuesto, codigo: codigo, siaf: siaf},
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
    //FUNCION PARA GRABAR LOS DATOS DEL INFORME
    function fn_GrabarDatosInforme() {
        var importancia = $("#txt_Importancia").val();
        var financiamiento = $("#txt_Financiamiento").val();
        var consecuencias = $("#txt_Consecuencias").val();
        var variacion = $("#txt_Variacion").val();
        $.ajax({
            type: "POST",
            url: "../IduConsolidadoNotaModificatoria",
            data: {mode: 'A', periodo: periodo, codigo: codigo,
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
    //FUNCION PARA VALIDAR QUE NO SE REPITAN LOS REGISTROS DEL DETALLE
    function fn_validaDetalle(unidad, notaModificatoria) {
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        if (modeDetalle === 'I') {
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (row.unidad.trim() === unidad.trim() && row.notaModificatoria.trim() === notaModificatoria.trim()) {
                    return unidad + " - " + notaModificatoria;
                }
            }
        }
        return "";
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">CONSOLIDAR NOTA MODIFICATORIA</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_ConsolidadoNota" name="frm_ConsolidadoNota" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><div id="div_GrillaRegistro"></div></td>
                </tr>
                <tr>
                    <td class="Summit">
                        <div>
                            <input type="button" id="btn_Guardar"  value="Guardar" style="margin-right: 20px"/>                            
                            <input type="button" id="btn_Cancelar" value="Cancelar" style="margin-right: 20px"/>
                        </div>
                    </td>
                </tr>
            </table>
            <div style="display: none" id="div_VentanaDetalle">
                <div>
                    <span style="float: left">AÑADIR NOTA MODIFICATORIA</span>
                </div>
                <div style="overflow: hidden">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                        
                        <tr>
                            <td><div id="div_GrillaAdiciona"></div></td>                            
                        </tr>
                        <tr>
                            <td class="Summit">
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
        <div id='div_EJE0024'>Consolidad de Notas Modificatorias</div>
        <div id='div_EJE0025'>Resumen por Unidades</div>
        <div id='div_EJE0026'>Resumen SIAF</div>
        <div id='div_EJE0027'>Informe - Anexo N° 3</div>
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>
<div id="div_VentanaInforme" style="display: none">
    <div>
        <span style="float: left">CONSOLIDADO DE NOTA MODIFICATORIA - ANEXO N° 3</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_ConsolidadoNotaModificatoriaInforme" name="frm_ConsolidadoNotaModificatoriaInforme" method="post" >
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
        <li>Informe</li>
        <li>Cerrar</li>       
        <li type='separator'></li>
        <li>Aprobar</li>
    </ul>
</div>