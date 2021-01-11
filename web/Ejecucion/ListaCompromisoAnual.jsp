<%-- 
    Document   : ListaCompromisoAnual
    Created on : 11/07/2017, 04:43:39 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var tipoCalendario = null;
    var codigo = null;
    var detalle = null;
    var estado = null;
    var mode = null;
    var tipoCompromiso = null;
    var indiceDetalle = -1;
    var modeDetalle = null;
    var tipoCertificado = null;
    var solicitud = null;
    var firmaJefe = null;
    var firmaSubJefe = null;
    var archivo = '';
    var lista = new Array();
    <c:forEach var="c" items="${objCompromisoAnual}">
    var result = {compromisoAnual: '${c.compromisoAnual}', cobertura: '${c.cobertura}', certificado: '${c.certificado}',
        detalle: '${c.detalle}', documentoReferencia: '${c.documentoReferencia}', fecha: '${c.mes}',
        importe: '${c.importe}', tipoCambio: '${c.tipoCambio}', monedaExtranjera: '${c.monedaExtranjera}',
        estado: '${c.estado}', tipo: '${c.tipo}', solicitud: '${c.solicitudCredito}', nroCompromiso: '${c.subTipoCalendario}',
        firmaJefe: '${c.firmaJefe}', firmaSubJefe: '${c.firmaSubJefe}', sectorista: '${c.sectorista}', archivo: '${c.archivo}'};
    lista.push(result);
    </c:forEach>
    var listaDet = new Array();
    <c:forEach var="d" items="${objCompromisoAnualDetalle}">
    var result = {compromisoAnual: '${d.compromisoAnual}', correlativo: '${d.correlativo}', dependencia: '${d.dependencia}',
        proveedor: '${d.unidad}', secuenciaFuncional: '${d.secuenciaFuncional}', tareaPresupuestal: '${d.tareaPresupuestal}',
        cadenaGasto: '${d.cadenaGasto}', importe: '${d.importe}', tipoCambio: '${d.tipoCambio}', monedaExtranjera: '${d.monedaExtranjera}'};
    listaDet.push(result);
    </c:forEach>
    $(document).ready(function () {
        var sourceNuevo = {
            datafields:
                    [
                        {name: "correlativo", type: "string"},
                        {name: "dependencia", type: "string"},
                        {name: "proveedor", type: "string"},
                        {name: "secuencia", type: "string"},
                        {name: "tarea", type: "string"},
                        {name: "cadena", type: "string"},
                        {name: "importe", type: "number"},
                        {name: "extranjera", type: "number"},
                        {name: "resolucion", type: "string"}
                    ],
            pagesize: 20,
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            }
        };
        var dataNuevo = new $.jqx.dataAdapter(sourceNuevo);
        //PARA LA GRILLA DE LA CABECERA        
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: "compromisoAnual", type: "string"},
                        {name: "cobertura", type: "string"},
                        {name: "certificado", type: "string"},
                        {name: "detalle", type: "string"},
                        {name: "documentoReferencia", type: "string"},
                        {name: "fecha", type: "string", format: 'dd/MM/yyyy'},
                        {name: "importe", type: "number"},
                        {name: "tipoCambio", type: "number"},
                        {name: "monedaExtranjera", type: "number"},
                        {name: "estado", type: "string"},
                        {name: "tipo", type: "string"},
                        {name: "solicitud", type: "string"},
                        {name: "nroCompromiso", type: "string"},
                        {name: "firmaJefe", type: "string"},
                        {name: "firmaSubJefe", type: "string"},
                        {name: "sectorista", type: "string"},
                        {name: "archivo", type: "string"}
                    ],
            root: "CompromisoAnual",
            record: "CompromisoAnual",
            id: 'compromisoAnual'
        };
        //PARA LA GRILLA DEL DETALLE 
        var sourceDet = {
            localdata: listaDet,
            datatype: "array",
            datafields:
                    [
                        {name: "compromisoAnual", type: "string"},
                        {name: "correlativo", type: "string"},
                        {name: "dependencia", type: "string"},
                        {name: "proveedor", type: "string"},
                        {name: "secuenciaFuncional", type: "string"},
                        {name: "tareaPresupuestal", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "importe", type: "number"},
                        {name: "tipoCambio", type: "number"},
                        {name: "monedaExtranjera", type: "number"}
                    ],
            root: "DetalleCompromisoAnual",
            record: "Detalle",
            id: 'compromisoAnual',
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
                var result = filter.evaluate(nested[m]["compromisoAnual"]);
                if (result)
                    ordersbyid.push(nested[m]);
            }
            var sourceNested = {
                datafields: [
                    {name: "compromisoAnual", type: "string"},
                    {name: "correlativo", type: "string"},
                    {name: "dependencia", type: "string"},
                    {name: "proveedor", type: "string"},
                    {name: "secuenciaFuncional", type: "string"},
                    {name: "tareaPresupuestal", type: "string"},
                    {name: "cadenaGasto", type: "string"},
                    {name: "importe", type: "number"},
                    {name: "tipoCambio", type: "number"},
                    {name: "monedaExtranjera", type: "number"}
                ],
                id: 'compromisoAnual',
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
                        {text: 'NRO', datafield: 'correlativo', filterable: false, width: '2%', align: 'center', cellsAlign: 'center'},
                        {text: 'DEPENDENCIA', datafield: 'dependencia', filtertype: 'checkedlist', width: '8%', align: 'center'},
                        {text: 'PROVEEDOR', datafield: 'proveedor', filtertype: 'checkedlist', width: '15%', align: 'center'},
                        {text: 'SECUENCIA', datafield: 'secuenciaFuncional', filtertype: 'checkedlist', width: '15%', align: 'center'},
                        {text: 'TAREA', datafield: 'tareaPresupuestal', filtertype: 'checkedlist', width: '15%', align: 'center'},
                        {text: 'CADENA', datafield: 'cadenaGasto', filtertype: 'checkedlist', width: '20%', align: 'center', aggregates: [{'<b>Totales : </b>':
                                            function () {
                                                return  "";
                                            }}]},
                        {text: 'IMPORTE', dataField: 'importe', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'T/CAMBIO', dataField: 'tipoCambio', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'f3', cellclassname: cellclass},
                        {text: 'EXTRANJERA', dataField: 'monedaExtranjera', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f3', cellclassname: cellclass, aggregates: ['sum']}
                    ]
                });
            }
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (rowdata['estado'] === "ANULADO") {
                return "RowAnulado";
            }
            if (datafield === "codigo" || datafield === "compromisoAnual" || datafield === "tipoCambio" || datafield === "certificado") {
                return "RowBold";
            }
            if (datafield === "cobertura") {
                return "RowGreen";
            }
            if (datafield === "importe" && rowdata['importe'] >= 0.0) {
                return "RowBlue";
            }
            if (datafield === "importe" && rowdata['importe'] < 0.0) {
                return "RowRed";
            }
            if (datafield === "monedaExtranjera") {
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
                    tipoCompromiso = 'CE';
                    mode = 'I';
                    fn_NuevoCab('');
                    $("#cbo_SolicitudCredito").jqxDropDownList({disabled: false});
                });
                //export to excel
                exportButton.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'SolicitudCreditoPresupuestal');
                });
                reporteButton.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 350, rowdetailshidden: true},
            columns: [
                {text: 'COMP. ANUAL', dataField: 'compromisoAnual', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'COBERTURA', dataField: 'cobertura', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'CERT. SIAF', dataField: 'certificado', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DETALLE', dataField: 'detalle', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'DOCU. REFERENCIA', dataField: 'documentoReferencia', width: '15%', align: 'center', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return "";
                                    }}]},
                {text: 'FECHA', dataField: 'fecha', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'importe', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'T/CAMBIO', dataField: 'tipoCambio', width: '4%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'EXTRANJERA', dataField: 'monedaExtranjera', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'TIPO', dataField: 'tipo', filtertype: 'checkedlist', width: '9%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'SOL. CERT.', dataField: 'solicitud', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'N° S.C.A.', dataField: 'nroCompromiso', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'SECTORISTA', dataField: 'sectorista', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL 
        var alto = 240;
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: alto, autoOpenPopup: false, mode: 'popup'});
        $("#div_GrillaPrincipal").on('contextmenu', function () {
            return false;
        });
        // HABILITAMOS LA OPCION DE CLICK DEL MENU CONTEXTUAL.
        $("#div_GrillaPrincipal").on('rowclick', function (event) {
            if (event.args.rightclick) {
                $("#div_GrillaPrincipal").jqxGrid('selectrow', event.args.rowindex);
                var scrollTop = $(window).scrollTop();
                var scrollLeft = $(window).scrollLeft();
                if (parseInt(event.args.originalEvent.clientY) > 600) {
                    scrollTop = scrollTop - alto;
                }
                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
                return false;
            }
        });
        //DEFINIMOS LOS EVENTOS SEGUN LA OPCION DEL MENU CONTEXTUAL
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
                                    $.ajax({
                                        type: "POST",
                                        url: "../IduCompromisoAnual",
                                        data: {mode: 'D', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, nroCompromisoAnual: codigo},
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
                } else if ($.trim($(opcion).text()) === "Cerrar") {
                    $('#div_VentanaCerrar').jqxWindow({isModal: true});
                    $('#div_VentanaCerrar').jqxWindow('open');
                } else if ($.trim($(opcion).text()) === "Ver Anexos") {
                    if (archivo !== '') {
                        document.location.target = "_blank";
                        document.location.href = "../Descarga?opcion=CompromisoAnual&periodo=" + periodo + "&unidadOperativa=" + unidadOperativa + "&presupuesto=" + presupuesto + "&codigo=" + codigo + "&documento=" + archivo;
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'No existe Archivo a Vizualizar!!!',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                } else if ($.trim($(opcion).text()) === "Ampliaciones") {
                    if (estado === 'ATENDIDO' && tipoCertificado === 'COMPROMISO') {
                        tipoCompromiso = 'AM';
                        mode = 'I';
                        fn_NuevoCab(codigo);
                        $("#cbo_SolicitudCredito").jqxDropDownList('selectItem', solicitud);
                        $("#cbo_SolicitudCredito").jqxDropDownList({disabled: true});
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Debe seleccionar un registro Atendido y Tipo Compromiso.',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                } else if ($.trim($(opcion).text()) === "Rebajas") {
                    if (estado === 'ATENDIDO' && tipoCertificado === 'COMPROMISO') {
                        tipoCompromiso = 'RE';
                        mode = 'I';
                        fn_NuevoCab(codigo);
                        $("#cbo_SolicitudCredito").jqxDropDownList('selectItem', solicitud);
                        $("#cbo_SolicitudCredito").jqxDropDownList({disabled: true});
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Debe seleccionar un registro Atendido y Tipo Compromiso.',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                } else if ($.trim($(opcion).text()) === "Generar Compromiso") {
                    if (autorizacion === 'true') {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Generar la Cobertura de Compromiso Anual?',
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
                                        $.ajax({
                                            type: "POST",
                                            url: "../IduCompromisoAnual",
                                            data: {mode: 'A', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, nroCompromisoAnual: codigo},
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
                } else if ($.trim($(opcion).text()) === "Transferir OEE") {
                    if (autorizacion === 'true') {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Transferir el Compromiso Anual?',
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
                                        $.ajax({
                                            type: "POST",
                                            url: "../IduCompromisoAnual",
                                            data: {mode: 'T', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, nroCompromisoAnual: codigo},
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
                                                                    var url = '../Reportes?reporte=EJE0032&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto + "&codigo=" + codigo;
                                                                    window.open(url, '_blank');
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
                } else if ($.trim($(opcion).text()) === "Rechazar") {
                    if (autorizacion === 'true') {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea RECHAZAR el Compromiso Anual?',
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
                                        $.ajax({
                                            type: "POST",
                                            url: "../IduCompromisoAnual",
                                            data: {mode: 'R', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, nroCompromisoAnual: codigo},
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
            codigo = row['compromisoAnual'];
            estado = row['estado'];
            tipoCertificado = row['tipo'];
            solicitud = row['solicitud'];
            firmaJefe = row['firmaJefe'];
            firmaSubJefe = row['firmaSubJefe'];
            archivo = row['archivo'];
        });
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: '375',
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
                    modeDetalle = 'I';
                    if (tipoCompromiso !== 'CE')
                        codigo = $("#txt_solicitudCompromiso").val();
                    var solicitudCredito = $("#cbo_SolicitudCredito").val();
                    if (solicitudCredito !== '0') {
                        $("#cbo_Proveedor").jqxComboBox('clear');
                        $("#cbo_Resolucion").jqxDropDownList('clear');
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboxCabecera("#cbo_Proveedor", {mode: 'proveedorCompromiso', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCompromiso: tipoCompromiso, compromisoAnual: codigo});
                        $('#div_Importe').val(0);
                        $('#div_MonedaExtranjera').val(0);
                        $("#cbo_Proveedor").jqxComboBox({disabled: false});
                        $("#cbo_Resolucion").jqxDropDownList({disabled: false});
                        $("#cbo_Dependencia").jqxDropDownList({disabled: false});
                        $("#cbo_SecuenciaFuncional").jqxDropDownList({disabled: false});
                        $("#cbo_Tarea").jqxDropDownList({disabled: false});
                        $("#cbo_CadenaGasto").jqxDropDownList({disabled: false});
                        $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_VentanaDetalle').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Seleccione la Solicitud de Credito Presupuestario',
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
                        var solicitudCredito = $("#cbo_SolicitudCredito").val();
                        if (solicitudCredito !== '0') {
                            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                            $("#cbo_Proveedor").jqxComboBox('clear');
                            $("#cbo_Proveedor").jqxComboBox({disabled: true});
                            $("#cbo_Proveedor").jqxComboBox('setContent', dataRecord.proveedor);
                            $("#cbo_Resolucion").jqxDropDownList('clear');
                            $("#cbo_Resolucion").jqxDropDownList({disabled: true});
                            $("#cbo_Resolucion").jqxDropDownList('setContent', dataRecord.resolucion);
                            $("#cbo_Dependencia").jqxDropDownList('clear');
                            $("#cbo_Dependencia").jqxDropDownList('setContent', dataRecord.dependencia);
                            $("#cbo_Dependencia").jqxDropDownList({disabled: true});
                            $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                            $("#cbo_SecuenciaFuncional").jqxDropDownList('setContent', dataRecord.secuencia);
                            $("#cbo_SecuenciaFuncional").jqxDropDownList({disabled: true});
                            $("#cbo_Tarea").jqxDropDownList('clear');
                            $("#cbo_Tarea").jqxDropDownList('setContent', dataRecord.tarea);
                            $("#cbo_Tarea").jqxDropDownList({disabled: true});
                            $("#cbo_CadenaGasto").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.cadena, ':'));
                            $("#cbo_CadenaGasto").jqxDropDownList({disabled: true});
                            $('#div_Importe').val(dataRecord.importe);
                            $('#div_MonedaExtranjera').val(dataRecord.extranjera);
                            $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                            $('#div_VentanaDetalle').jqxWindow('open');
                        } else {
                            $.alert({
                                theme: 'material',
                                title: 'AVISO DEL SISTEMA',
                                content: 'SELECCIONE EL TIPO DE CALENDARIO',
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
                    fn_verTotal();
                });
            },
            columns: [
                {text: 'N°', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', align: 'center', columntype: 'number', width: '4%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'PROVEEDOR', datafield: 'proveedor', width: "15%", align: 'center'},
                {text: 'DEPENDENCIA', datafield: 'dependencia', width: "10%", align: 'center'},
                {text: 'SECUENCIA', datafield: 'secuencia', width: "15%", align: 'center'},
                {text: 'TAREA', datafield: 'tarea', width: "15%", align: 'center'},
                {text: 'CADENA', datafield: 'cadena', width: "15%", align: 'center'},
                {text: 'IMPORTE', dataField: 'importe', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EXTRANJERA', dataField: 'extranjera', width: "8%", align: 'center', cellsAlign: 'right', cellsFormat: 'f3', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'RESOLUCION', datafield: 'resolucion', width: "6%", align: 'center'}
            ]
        });
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
            fn_cargarComboAjax("#cbo_CadenaGasto", {mode: 'cadenaGastoCompromiso', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                resolucion: fn_extraerDatos(dataRecord.resolucion, ':'), dependencia: fn_extraerDatos(dataRecord.dependencia, ':'), secuenciaFuncional: fn_extraerDatos(dataRecord.secuencia, ':'),
                tarea: fn_extraerDatos(dataRecord.tarea, ':'), solicitudCredito: $("#cbo_SolicitudCredito").val(), proveedor: fn_extraerDatos(dataRecord.proveedor, ':'), tipoCompromiso: tipoCompromiso, compromisoAnual: codigo});
        });
    });
    //Funcion para Insertar un Nuevo Registro.
    function fn_NuevoCab(compromiso) {
        $('#div_GrillaRegistro').jqxGrid('clear');
        $.ajax({
            type: "GET",
            url: "../CompromisoAnual",
            data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
            success: function (data) {
                $('#txt_NumeroCompromisoAnual').val(data);
                $('#txt_solicitudCompromiso').val(compromiso);
                $('#txt_DocumentoReferencia').val('');
                $('#txt_Detalle').val('');
                $('#txt_Observacion').val('');
                $("#cbo_TipoMoneda").jqxDropDownList('selectItem', '01');
                $('#div_TipoCambio').val(0);
            }
        });
        if (tipoCompromiso === 'CE')
            detalle = 'COMPROMISO';
        if (tipoCompromiso === 'AM')
            detalle = 'AMPLACION';
        if (tipoCompromiso === 'RE')
            detalle = 'REBAJA';
        $('#div_VentanaPrincipal').jqxWindow({title: 'SOLICITUD DE COMPROMISO ANUAL - ' + detalle});
        $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
        $('#div_VentanaPrincipal').jqxWindow('open');
    }
    //Funcion de Refrescar o Actulizar los datos de la Grilla.
    function fn_EditarCab() {
        if (estado !== 'ANULADA') {
            mode = 'U';
            $('#txt_NumeroCompromisoAnual').val(codigo);
            $.ajax({
                type: "GET",
                url: "../CompromisoAnual",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 11) {
                        $("#cbo_SolicitudCredito").jqxDropDownList('selectItem', dato[0]);
                        var d = new Date(dato[1]);
                        d.setDate(d.getDate() + 1);
                        $('#txt_Fecha ').jqxDateTimeInput('setDate', d);
                        $('#txt_DocumentoReferencia').val(dato[2]);
                        $('#txt_Detalle').val(dato[3]);
                        $('#txt_Observacion').val(dato[4]);
                        tipoCompromiso = dato[9];
                        if (tipoCompromiso !== 'CE')
                            $('#txt_solicitudCompromiso').val(dato[10]);
                        $('#div_GrillaRegistro').jqxGrid('clear');
                        $("#cbo_SolicitudCredito").jqxDropDownList({disabled: true});
                        $.ajax({
                            type: "GET",
                            url: "../CompromisoAnual",
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
                                    var row = {dependencia: datos[0], proveedor: datos[1], secuencia: datos[2], tarea: datos[3], cadena: datos[4],
                                        importe: parseFloat(datos[5]), extranjera: parseFloat(datos[6]), resolucion: datos[7]};
                                    rows.push(row);
                                }
                                if (rows.length > 0)
                                    $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
                                fn_verTotal();
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
    function fn_Refrescar() {
        $("#div_RegistroDetalle").remove();
        $("#div_GrillaRegistro").remove();
        $("#div_GrillaPrincipal").remove();
        $("#div_VentanaCerrar").remove();
        $("#div_VentanaPrincipal").remove();
        $("#div_VentanaDetalle").remove();
        $("#div_ContextMenu").remove();
        $("#div_Reporte").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "POST",
            url: "../CompromisoAnual",
            data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
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
            var ancho = 800;
            var alto = 700;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaPrincipal').jqxWindow({
                position: {x: posicionX, y: posicionY + 40},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_Cancelar'),
                initContent: function () {
                    $("#txt_NumeroCompromisoAnual").jqxInput({width: 130, height: 20, disabled: true});
                    $("#txt_solicitudCompromiso").jqxInput({width: 130, height: 20, disabled: true});
                    $("#txt_Fecha").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                    $("#cbo_SolicitudCredito").jqxDropDownList({animationType: 'fade', width: 650, height: 20});
                    $('#cbo_SolicitudCredito').on('change', function () {
                        $.ajax({
                            type: "GET",
                            url: "../CompromisoAnual",
                            data: {mode: 'CAL', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: $("#cbo_SolicitudCredito").val()},
                            success: function (data) {
                                tipoCalendario = data;
                            }
                        });
                    });
                    $("#cbo_TipoMoneda").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                    $('#cbo_TipoMoneda').on('change', function () {
                        fn_verTipoMoneda();
                    });
                    $("#div_TipoCambio").jqxNumberInput({width: 80, height: 20, digits: 3, decimalDigits: 3, disabled: true});
                    $("#txt_DocumentoReferencia").jqxInput({placeHolder: "Ingrese Documento de Referencia", width: 650, height: 20, minLength: 1});
                    $("#txt_Detalle").jqxInput({placeHolder: "Ingrese detalle de la Solicitud", width: 650, height: 20, minLength: 1});
                    $("#txt_Observacion").jqxInput({placeHolder: "Ingrese las Observaciones", width: 650, height: 20, minLength: 1});
                    $("#div_TotalNacional").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                    $("#div_TotalExtranjera").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                    $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').on('click', function (event) {
                        $('#frm_CompromisoAnual').jqxValidator('validate');
                    });
                    $('#frm_CompromisoAnual').jqxValidator({
                        rules: [
                            {input: '#txt_DocumentoReferencia', message: 'Ingrese el Documento de Referencia!', action: 'keyup, blur', rule: 'required'},
                            {input: '#txt_Detalle', message: 'Ingrese el Detalle!', action: 'keyup, blur', rule: 'required'}
                        ]
                    });
                    $('#frm_CompromisoAnual').jqxValidator({
                        onSuccess: function () {
                            fn_GrabarDatos();
                        }
                    });
                }
            });
            //Inicia los Valores de Ventana del Detalle
            ancho = 600;
            alto = 230;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaDetalle').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CancelarDetalle'),
                initContent: function () {
                    $("#cbo_Proveedor").jqxComboBox({animationType: 'fade', width: 480, height: 20});
                    $('#cbo_Proveedor').on('change', function () {
                        $("#cbo_Resolucion").jqxDropDownList('clear');
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_Resolucion", {mode: 'resolucionCompromiso', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                            solicitudCredito: $("#cbo_SolicitudCredito").val(), proveedor: $("#cbo_Proveedor").val(), tipoCompromiso: tipoCompromiso, compromisoAnual: codigo});
                    });
                    $("#cbo_Resolucion").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                    $('#cbo_Resolucion').on('change', function () {
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_Dependencia", {mode: 'dependenciaCompromiso', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                            resolucion: $("#cbo_Resolucion").val(), solicitudCredito: $("#cbo_SolicitudCredito").val(), proveedor: $("#cbo_Proveedor").val(), tipoCompromiso: tipoCompromiso, compromisoAnual: codigo});
                    });
                    $("#cbo_Dependencia").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                    $('#cbo_Dependencia').on('change', function () {
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        var resolucion = $("#cbo_Resolucion").val();
                        fn_cargarComboAjax("#cbo_SecuenciaFuncional", {mode: 'secuenciaFuncionalCompromiso', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                            resolucion: resolucion, dependencia: $("#cbo_Dependencia").val(), solicitudCredito: $("#cbo_SolicitudCredito").val(), proveedor: $("#cbo_Proveedor").val(),
                            tipoCompromiso: tipoCompromiso, compromisoAnual: codigo});
                    });
                    $("#cbo_SecuenciaFuncional").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                    $('#cbo_SecuenciaFuncional').on('change', function () {
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        var resolucion = $("#cbo_Resolucion").val();
                        var dependencia = $("#cbo_Dependencia").val();
                        fn_cargarComboAjax("#cbo_Tarea", {mode: 'tareaCompromiso', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                            resolucion: resolucion, dependencia: dependencia, secuenciaFuncional: $("#cbo_SecuenciaFuncional").val(), solicitudCredito: $("#cbo_SolicitudCredito").val(),
                            proveedor: $("#cbo_Proveedor").val(), tipoCompromiso: tipoCompromiso, compromisoAnual: codigo});
                    });
                    $("#cbo_Tarea").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                    $('#cbo_Tarea').on('change', function () {
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        var resolucion = $("#cbo_Resolucion").val();
                        var dependencia = $("#cbo_Dependencia").val();
                        var secuenciaFuncional = $("#cbo_SecuenciaFuncional").val();
                        fn_cargarComboAjax("#cbo_CadenaGasto", {mode: 'cadenaGastoCompromiso', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                            resolucion: resolucion, dependencia: dependencia, secuenciaFuncional: secuenciaFuncional, tarea: $("#cbo_Tarea").val(), solicitudCredito: $("#cbo_SolicitudCredito").val(),
                            proveedor: $("#cbo_Proveedor").val(), tipoCompromiso: tipoCompromiso, compromisoAnual: codigo});
                    });
                    $("#cbo_CadenaGasto").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                    $("#div_Importe").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                    $("#div_MonedaExtranjera").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 10, decimalDigits: 3, disabled: true});
                    $('#div_MonedaExtranjera').on('textchanged', function (event) {
                        fn_verTipoCambio();
                    });
                    $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarDetalle').on('click', function (event) {
                        var proveedor = $("#cbo_Proveedor").jqxComboBox('getSelectedItem');
                        var resolucion = $("#cbo_Resolucion").jqxDropDownList('getSelectedItem');
                        var dependencia = $("#cbo_Dependencia").jqxDropDownList('getSelectedItem');
                        var secuenciaFuncional = $("#cbo_SecuenciaFuncional").jqxDropDownList('getSelectedItem');
                        var tarea = $("#cbo_Tarea").jqxDropDownList('getSelectedItem');
                        var cadenaGasto = $("#cbo_CadenaGasto").jqxDropDownList('getSelectedItem');
                        var msg = "";
                        if (msg === "")
                            msg = fn_validaSaldo();
                        if (msg === "" && modeDetalle === 'I') {
                            msg = fn_validaDetalle(proveedor.label, fn_extraerDatos(resolucion.label, 'S/.'), fn_extraerDatos(dependencia.label, 'S/.'), fn_extraerDatos(secuenciaFuncional.label, 'S/.'),
                                    fn_extraerDatos(tarea.label, 'S/.'), fn_extraerDatos(cadenaGasto.label, 'S/.'));
                        }
                        if (msg === "" && modeDetalle === 'U') {
                            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                            msg = fn_validaDetalle(dataRecord.proveedor, dataRecord.resolucion, dataRecord.dependencia, dataRecord.secuencia, dataRecord.tarea, dataRecord.cadena);
                        }
                        if (msg === "") {
                            if (modeDetalle === 'I') {
                                var row = {dependencia: fn_extraerDatos(dependencia.label, 'S/.'), proveedor: proveedor.label, secuencia: fn_extraerDatos(secuenciaFuncional.label, 'S/.'),
                                    tarea: fn_extraerDatos(tarea.label, 'S/.'), cadena: fn_extraerDatos(cadenaGasto.label, 'S/.'), importe: parseFloat($("#div_Importe").jqxNumberInput('decimal')),
                                    extranjera: parseFloat($("#div_MonedaExtranjera").jqxNumberInput('decimal')), resolucion: fn_extraerDatos(resolucion.label, 'S/.')};
                                $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
                            }
                            if (modeDetalle === 'U') {
                                var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                                var row = {dependencia: dataRecord.dependencia, proveedor: dataRecord.proveedor, secuencia: dataRecord.secuencia, tarea: dataRecord.tarea, cadena: dataRecord.cadena,
                                    importe: parseFloat($("#div_Importe").jqxNumberInput('decimal')), extranjera: parseFloat($("#div_MonedaExtranjera").jqxNumberInput('decimal')),
                                    resolucion: dataRecord.resolucion};
                                var rowID = $('#div_GrillaRegistro').jqxGrid('getrowid', indiceDetalle);
                                $('#div_GrillaRegistro').jqxGrid('updaterow', rowID, row);
                            }
                            modeDetalle = null;
                            fn_verTotal();
                            $("#div_VentanaDetalle").jqxWindow('hide');
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
            ancho = 500;
            alto = 100;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            //Ventana Cerrar Compromiso Anual
            $('#div_VentanaCerrar').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CancelarCerrar'),
                initContent: function () {
                    $("#txt_Fichero").jqxInput({placeHolder: "Seleccione el Documento", width: 400, height: 20, minLength: 1});
                    $('#btn_CancelarCerrar').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarCerrar').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarCerrar').on('click', function (event) {
                        fn_GuardarCerrar();
                    });
                }
            });
            ancho = 400;
            alto = 150;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_Reporte').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CerrarImprimir'),
                initContent: function () {
                    $("#div_EJE0008").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0008').on('checked', function (event) {
                        reporte = 'EJE0008';
                    });
                    $("#div_EJE0009").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0009').on('checked', function (event) {
                        reporte = 'EJE0009';
                    });
                    $("#div_EJE0010").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0010').on('checked', function (event) {
                        reporte = 'EJE0010';
                    });
                    $("#div_EJE0011").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0011').on('checked', function (event) {
                        reporte = 'EJE0011';
                    });
                    $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').on('click', function (event) {
                        var msg = "";
                        switch (reporte) {
                            case "EJE0008":
                                if (codigo === null)
                                    msg += "Seleccione la Solicitud de Compromiso Anual.<br>";
                                break;
                            case "EJE0009":
                                if (codigo === null)
                                    msg += "Seleccione la Solicitud de Compromiso Anual.<br>";
                                if (tipoCertificado !== 'COMPROMISO')
                                    msg += "Seleccione la S.C.A. Tipo COMPROMISO.<br>";
                                break;
                            case "EJE0010":
                                if (codigo !== null && tipoCertificado !== 'COMPROMISO')
                                    msg += "Seleccione la S.C.P. Tipo COMPROMISO.<br>";
                                break;
                            case "EJE0011":
                                // if (firmaJefe !== 'SI')
                                //     msg += "No puede imprimir esta Registro, Falta Firmar el Jefe de la OPRE.<br>";
                                //  if (firmaSubJefe !== 'SI')
                                //      msg += "No puede imprimir esta Registro, Falta Firmar el Sub Jefe de la OPRE.<br>";
                                if (codigo === null)
                                    msg += "Seleccione la Solicitud de Compromiso Anual.<br>";
                                if (!autorizacion)
                                    msg += "Usuario no Autorizado para este Tipo de Reporte.<br>";
                                break;
                            default:
                                msg += "Debe selecciona una opción.<br>";
                                break;
                        }
                        if (msg === "") {
                            var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto + "&codigo=" + codigo;
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
        return {
            init: function () {
                _createElements();
            }
        }
        ;
    }());
    $(document).ready(function () {
        customButtonsDemo.init();
    });
    function fn_verTipoMoneda() {
        var codmon = $("#cbo_TipoMoneda").val();
        if (codmon === '01') {
            $('#div_MonedaExtranjera').val("0");
            $('#div_TipoCambio').val("0");
            $('#div_TipoCambio').jqxNumberInput({disabled: true});
            $('#div_MonedaExtranjera').jqxNumberInput({disabled: true});
            $('#div_Importe').jqxNumberInput({disabled: false});
            $('#div_Importe').jqxNumberInput('focus');
        } else {
            $('#div_Importe').jqxNumberInput({disabled: true});
            $('#div_TipoCambio').jqxNumberInput({disabled: false});
            $('#div_MonedaExtranjera').jqxNumberInput({disabled: false});
            $('#div_TipoCambio').jqxNumberInput('focus');
        }
    }
    function fn_verTipoCambio() {
        var tipoMoneda = $("#cbo_TipoMoneda").val();
        var tipoCambio = $("#div_TipoCambio").val();
        var extranjera = $("#div_MonedaExtranjera").val();
        tipoCambio = parseFloat(tipoCambio);
        extranjera = parseFloat(extranjera);
        var importe = extranjera * tipoCambio;
        if (tipoMoneda !== '01') {
            if (isNaN(importe))
                importe = '0';
            importe = Math.round(importe * 100) / 100;
            $('#div_Importe').val(importe);
        }
    }
    function fn_GrabarDatos() {
        var msg = "";
        var nroCompromisoAnual = $('#txt_NumeroCompromisoAnual').val();
        var solicitudCompromiso = $("#txt_solicitudCompromiso").val();
        var fecha = $('#txt_Fecha').val();
        var solicitudCredito = $("#cbo_SolicitudCredito").val();
        var documentoReferencia = $("#txt_DocumentoReferencia").val();
        var detalle = $("#txt_Detalle").val();
        var observacion = $("#txt_Observacion").val();
        var tipoMoneda = $("#cbo_TipoMoneda").val();
        var tipoCambio = $("#div_TipoCambio").val();
        var importe = $("#div_TotalNacional").val();
        var monedaExtranjera = $("#div_TotalExtranjera").val();
        var msg = "";
        var lista = new Array();
        var result;
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            result = row.uid + "---" + fn_extraerDatos(row.proveedor, ':') + "---" + fn_extraerDatos(row.dependencia, ':') + "---" + fn_extraerDatos(row.secuencia, ':') + "---" + fn_extraerDatos(row.tarea, ':') + "---" +
                    fn_extraerDatos(row.cadena, ':') + "---" + row.importe + "---" + row.extranjera + "---" + fn_extraerDatos(row.resolucion, ':');
            lista.push(result);
        }
        if (solicitudCredito === '0')
            msg += "Seleccione una Solicitud de Credito <br>";
        if (lista.length === 0)
            msg += "Ingrese el Detalle del Compromiso Anual <br>";
        if (msg === "") {
            $.ajax({
                type: "POST",
                url: "../IduCompromisoAnual",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, nroCompromisoAnual: nroCompromisoAnual, tipoCalendario: tipoCalendario,
                    tipoCompromiso: tipoCompromiso, solicitudCredito: solicitudCredito, fecha: fecha, solicitudCompromiso: solicitudCompromiso,
                    documentoReferencia: documentoReferencia, detalle: detalle, observacion: observacion, tipoMoneda: tipoMoneda, tipoCambio: tipoCambio,
                    importe: importe, monedaExtranjera: monedaExtranjera, lista: JSON.stringify(lista)},
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
    function fn_GuardarCerrar() {
        var fichero = $("#txt_Fichero").val();
        if (fichero !== '' ) {
            var formData = new FormData(document.getElementById("frm_CompromisoAnualCerrar"));
            formData.append("mode", "C");
            formData.append("periodo", periodo);
            formData.append("unidadOperativa", unidadOperativa);
            formData.append("presupuesto", presupuesto);
            formData.append("nroCompromisoAnual", codigo);
            $.ajax({
                type: "POST",
                url: "../IduCompromisoAnual",
                data: formData,
                dataType: "html",
                cache: false,
                contentType: false,
                processData: false,
                success: function (data) {
                    msg = data;
                    if (msg === "GUARDO") {
                        $('#div_VentanaCerrar').jqxWindow('close');
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
                content: "Debe seleccionar el archivo con la documentacion sustentatoria\n PROCESO CANCELADO!!!.",
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'red',
                typeAnimated: true
            });
        }
    }
    function fn_validaSaldo() {
        var cadena = $("#cbo_CadenaGasto").val();
        if (cadena.length !== 0) {
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
            } else {
                return "";
            }
        } else {
            return "Seleccione la Cadena de Gasto";
        }
    }
    //FUNCION PARA VALIDAR QUE NO SE REPITAN LOS REGISTROS DEL DETALLE
    function fn_validaDetalle(proveedor, resolucion, dependencia, secuencia, tarea, cadenaGasto) {
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        if (modeDetalle === 'I') {
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (row.proveedor.trim() === proveedor.trim() && row.resolucion.trim() === resolucion.trim() && row.dependencia.trim() === dependencia.trim() &&
                        row.secuencia.trim() === secuencia.trim() && row.tarea.trim() === tarea.trim() && row.cadena.trim() === cadenaGasto.trim()) {
                    return "Los Datos que desea registrar ya existen, Revise!!";
                }
            }
        }
        if (modeDetalle === 'U') {
            if (rows[indiceDetalle].proveedor.trim() === proveedor.trim() && rows[indiceDetalle].resolucion.trim() === resolucion.trim() && rows[indiceDetalle].dependencia.trim() === dependencia.trim() &&
                    rows[indiceDetalle].secuencia.trim() === secuencia.trim() && rows[indiceDetalle].tarea.trim() === tarea.trim() && rows[indiceDetalle].cadena.trim() === cadenaGasto.trim()) {
                return "";
            } else {
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (i !== indiceDetalle && row.proveedor.trim() === proveedor.trim() && row.resolucion.trim() === resolucion.trim() && row.dependencia.trim() === dependencia.trim() &&
                            row.secuencia.trim() === secuencia.trim() && row.tarea.trim() === tarea.trim() && row.cadena.trim() === cadenaGasto.trim()) {
                        return "Los Datos que desea registrar ya existen, Revise!!";
                    }
                }
            }
        }
        return "";
    }
    //FUNCION PARA OBTENER LA SUMATORIA TOTAL DEL DETALLE
    function fn_verTotal() {
        var totalNacional, totalExtranjera;
        totalNacional = totalExtranjera = 0.0;
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            totalNacional += parseFloat(row.importe);
            totalExtranjera += parseFloat(row.extranjera);
        }
        $("#div_TotalNacional").val(Math.round(parseFloat(totalNacional) * 100) / 100);
        $("#div_TotalExtranjera").val(Math.round(parseFloat(totalExtranjera) * 100) / 100);
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">SOLICITUD DE COMPROMISO ANUAL</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_CompromisoAnual" name="frm_CompromisoAnual" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">N&deg; Compromiso : </td>
                    <td><input type="text" id="txt_NumeroCompromisoAnual" name="txt_NumeroCompromisoAnual"/></td>
                    <td class="inputlabel">Compr. Anual : </td>
                    <td><input type="text" id="txt_solicitudCompromiso" name="txt_solicitudCompromiso"/></td>
                    <td class="inputlabel">Fecha : </td>
                    <td><div id="txt_Fecha"></div>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Nro. Sol. Cred. : </td>
                    <td colspan="5" >
                        <select id="cbo_SolicitudCredito" name="cbo_SolicitudCredito">
                            <option value="0">Seleccione</option>
                            <c:forEach var="e" items="${objSolicitudCredito}">
                                <option value="${e.codigo}">${e.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr> 
                <tr>
                    <td class="inputlabel">Doc. Ref. : </td>
                    <td colspan="5"><input type="text" id="txt_DocumentoReferencia" name="txt_DocumentoReferencia" style="text-transform: uppercase;"/></td>
                </tr>
                <tr> 
                    <td class="inputlabel">Detalle : </td>
                    <td colspan="5"><input type="text" id="txt_Detalle" name="txt_Detalle" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Observaci&oacute;n : </td>
                    <td colspan="5"><input type="text" id="txt_Observacion" name="txt_Observacion" style="text-transform: uppercase;"/></td>
                </tr> 
                <tr>
                    <td class="inputlabel">Tipo Moneda : </td>
                    <td>
                        <select id="cbo_TipoMoneda" name="cbo_TipoMoneda">
                            <c:forEach var="f" items="${objTipoMoneda}">
                                <option value="${f.codigo}">${f.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td class="inputlabel">Tipo Cambio : </td>
                    <td><div id="div_TipoCambio"></div></td>
                </tr> 
                <tr>
                    <td class="inputlabel">TOTAL S/. : </td>
                    <td><div id="div_TotalNacional"></div></td>
                    <td class="inputlabel">TOTAL ME : </td>
                    <td><div id="div_TotalExtranjera"></div></td>
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
                    <span style="float: left">DETALLE DE LA SOLICITUD DE COMPROMISO ANUAL</span>
                </div>
                <div style="overflow: hidden">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="inputlabel">Proveedor : </td>
                            <td colspan="3">
                                <select id="cbo_Proveedor" name="cbo_Proveedor">
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
                            <td><div id="div_Importe"></div></td>
                            <td class="inputlabel">Extranjera : </td>
                            <td><div id="div_MonedaExtranjera"></div></td>
                        </tr>
                        <tr>
                            <td class="Summit" colspan="4">
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
<div id="div_VentanaCerrar" style="display: none">
    <div>
        <span style="float: left">CERRAR COMPROMISO ANUAL</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_CompromisoAnualCerrar" name="frm_CompromisoAnualCerrar" enctype="multipart/form-data" action="javascript:fn_GuardarCerrar();" method="post">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Anexos : </td>
                    <td>
                        <input type="file" id="txt_Fichero" name="txt_Fichero" style="text-transform: uppercase;"/>
                    </td> 
                </tr>
                <tr>
                    <td class="Summit" colspan="2">
                        <div>
                            <input type="button" id="btn_GuardarCerrar"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarCerrar" value="Cancelar" style="margin-right: 20px"/>
                        </div>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<div style="display: none" id="div_Reporte">
    <div>
        <span style="float: left">LISTADO DE REPORTES</span>
    </div>
    <div style="overflow: hidden">
        <div id='div_EJE0008'>Solicitud de Compromiso Anual</div>
        <div id='div_EJE0009'>Control de Compromiso Anual</div>
        <div id='div_EJE0010'>Listado de Pedidos Mensuales</div>
        <div id='div_EJE0011'>Anexo al Compromiso Anual</div>        
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Anular</li>
        <li style="color: blue; font-weight: bold;">Cerrar</li>
        <li>Ver Anexos</li>
        <li type='separator'></li>
        <li style="color: green; font-weight: bold;">Ampliaciones</li>
        <li style="color: green; font-weight: bold;">Rebajas</li>
        <li type='separator'></li>
        <li style="font-weight: bold;">Generar Compromiso</li>
        <li style="font-weight: bold;">Transferir OEE</li>
        <li style="font-weight: bold; color: red;">Rechazar</li>
    </ul>
</div>