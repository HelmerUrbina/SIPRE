<%-- 
    Document   : ListaCertificadoPresupuestalConsulta
    Created on : 10/04/2021, 09:51:14 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = "";
    var codigo = null;
    var detalle = null;
    var estado = null;
    var mode = null;
    var tipoSolicitud = null;
    var indiceDetalle = -1;
    var modeDetalle = null;
    var tipoCertificado = null;
    var reporte = null;
    var cobertura = null;
    var firmaJefe = null;
    var firmaSubJefe = null;
    var archivo = '';
    var subTipoCal = null;
    var TipoCalendario = null;
    var sustento = null;
    var lista = new Array();
    <c:forEach var="c" items="${objCertificado}">
    var result = {solicitud: '${c.solicitudCredito}', unidad: '${c.tipoMoneda}' + "-" + '${c.solicitudCredito}', unidadOperativa: '${c.unidadOperativa}', certificado: '${c.certificado}', cobertura: '${c.cobertura}',
        detalle: "${c.detalle}", documentoReferencia: "${c.documentoReferencia}", fecha: '${c.mes}', paac: '${c.procesoSeleccion}',
        importe: '${c.importe}', tipoCambio: '${c.tipoCambio}', monedaExtranjera: '${c.monedaExtranjera}', estado: '${c.estado}',
        tipo: '${c.tipo}', tipoCalendario: '${c.tipoCalendario}', subTipoCalendario: '${c.subTipoCalendario}', nroSolicitud: '${c.cadenaGasto}',
        opinion: '${c.dependencia}', firmaJefe: '${c.firmaJefe}', firmaSubJefe: '${c.firmaSubJefe}', fechaAprobacion: '${c.unidad}',
        priorizacion: '${c.tareaPresupuestal}', sectorista: '${c.sectorista}', archivo: '${c.archivo}'};
    lista.push(result);
    </c:forEach>
    var listaDet = new Array();
    <c:forEach var="d" items="${objCertificadoDetalle}">
    var result = {solicitud: '${d.solicitudCredito}', unidad: '${d.unidadOperativa}' + "-" + '${d.solicitudCredito}', correlativo: '${d.correlativo}', dependencia: '${d.dependencia}',
        secuenciaFuncional: '${d.secuenciaFuncional}', tareaPresupuestal: '${d.tareaPresupuestal}', cadenaGasto: '${d.cadenaGasto}',
        importe: '${d.importe}', tipoCambio: '${d.tipoCambio}', monedaExtranjera: '${d.monedaExtranjera}'};
    listaDet.push(result);
    </c:forEach>
    $(document).ready(function () {
        var sourceNuevo = {
            datafields: [
                {name: "correlativo", type: "string"},
                {name: "dependencia", type: "string"},
                {name: "secuencia", type: "string"},
                {name: "tarea", type: "string"},
                {name: "cadena", type: "string"},
                {name: "importe", type: "number"},
                {name: "extranjera", type: "number"},
                {name: "resolucion", type: "string"}
            ],
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            }
        };
        var dataNuevo = new $.jqx.dataAdapter(sourceNuevo);
        //PARA LA GRILLA DE LA CABECERA        
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields: [
                {name: "solicitud", type: "string"},
                {name: "certificado", type: "string"},
                {name: "unidad", type: "string"},
                {name: "unidadOperativa", type: "string"},
                {name: "certificado", type: "string"},
                {name: "cobertura", type: "string"},
                {name: "detalle", type: "string"},
                {name: "documentoReferencia", type: "string"},
                {name: "fecha", type: "string"},
                {name: "importe", type: "number"},
                {name: "tipoCambio", type: "number"},
                {name: "monedaExtranjera", type: "number"},
                {name: "estado", type: "string"},
                {name: "tipo", type: "string"},
                {name: "tipoCalendario", type: "string"},
                {name: "subTipoCalendario", type: "string"},
                {name: "nroSolicitud", type: "string"},
                {name: "opinion", type: "string"},
                {name: "paac", type: "string"},
                {name: "firmaJefe", type: "string"},
                {name: "firmaSubJefe", type: "string"},
                {name: "fechaAprobacion", type: "string"},
                {name: "sectorista", type: "string"},
                {name: "priorizacion", type: "string"},
                {name: "archivo", type: "string"}
            ],
            root: "CertificadoPresupuestal",
            record: "Certificado",
            id: 'unidad'
        };
        //PARA LA GRILLA DEL DETALLE 
        var sourceDet = {
            localdata: listaDet,
            datatype: "array",
            datafields: [
                {name: "solicitud", type: "string"},
                {name: "unidad", type: "string"},
                {name: "correlativo", type: "string"},
                {name: "dependencia", type: "string"},
                {name: "secuenciaFuncional", type: "string"},
                {name: "tareaPresupuestal", type: "string"},
                {name: "cadenaGasto", type: "string"},
                {name: "importe", type: "number"},
                {name: "tipoCambio", type: "number"},
                {name: "monedaExtranjera", type: "number"}
            ],
            root: "DetalleCertificado",
            record: "Detalle",
            id: 'unidad',
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
                var result = filter.evaluate(nested[m]["unidad"]);
                if (result)
                    ordersbyid.push(nested[m]);
            }
            var sourceNested = {
                datafields: [
                    {name: "solicitud", type: "string"},
                    {name: "unidad", type: "string"},
                    {name: "correlativo", type: "string"},
                    {name: "dependencia", type: "string"},
                    {name: "secuenciaFuncional", type: "string"},
                    {name: "tareaPresupuestal", type: "string"},
                    {name: "cadenaGasto", type: "string"},
                    {name: "importe", type: "number"},
                    {name: "tipoCambio", type: "number"},
                    {name: "monedaExtranjera", type: "number"}
                ],
                id: 'unidad',
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
                        {text: 'SECUENCIA', datafield: 'secuenciaFuncional', filtertype: 'checkedlist', width: '19%', align: 'center'},
                        {text: 'TAREA', datafield: 'tareaPresupuestal', filtertype: 'checkedlist', width: '19%', align: 'center'},
                        {text: 'CADENA', datafield: 'cadenaGasto', filtertype: 'checkedlist', width: '27%', align: 'center', aggregates: [{'<b>Totales : </b>':
                                            function () {
                                                return  "";
                                            }}]},
                        {text: 'IMPORTE', dataField: 'importe', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'T/CAMBIO', dataField: 'tipoCambio', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                        {text: 'EXTRANJERA', dataField: 'monedaExtranjera', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
                    ]
                });
            }
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (rowdata['estado'] === "ANULADA") {
                return "RowAnulado";
            }
            if (datafield === "codigo" || datafield === "certificado" || datafield === "tipoCambio") {
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
                // Appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var exportButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var reporteButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(exportButton);
                container.append(reporteButton);
                toolbar.append(container);
                exportButton.jqxButton({width: 30, height: 22});
                exportButton.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                reporteButton.jqxButton({width: 30, height: 22});
                reporteButton.jqxTooltip({position: 'bottom', content: "Reportes"});
                //EXPORTAR A EXCEL
                exportButton.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'SolicitudCreditoPresupuestal');
                });
                //ABRIR LOS REPORTES
                reporteButton.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 350, rowdetailshidden: true},
            columns: [
                {text: 'UNIDAD', dataField: 'unidadOperativa', filtertype: 'checkedlist', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'SOLICITUD', dataField: 'solicitud', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'CERT. SIAF', dataField: 'certificado', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'COBERTURA', dataField: 'cobertura', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DETALLE', dataField: 'detalle', width: '25%', align: 'center', cellclassname: cellclass},
                {text: 'DOCU. REFERENCIA', dataField: 'documentoReferencia', width: '15%', align: 'center', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return "";
                                    }}]},
                {text: 'FECHA', dataField: 'fecha', columntype: 'datetimeinput', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'importe', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'T/CAMBIO', dataField: 'tipoCambio', width: '4%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'EXTRANJERA', dataField: 'monedaExtranjera', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'TIPO', dataField: 'tipo', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'NRO SOLICITUD', dataField: 'nroSolicitud', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'PAC', dataField: 'paac', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'I.D.P.', dataField: 'opinion', width: '4%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'PRIORIZA.', dataField: 'priorizacion', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FECHA APROB', dataField: 'fechaAprobacion', columntype: 'datetimeinput', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'SECTORISTA', dataField: 'sectorista', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var alto = 60;
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: alto, autoOpenPopup: false, mode: 'popup'});
        $("#div_GrillaPrincipal").on('contextmenu', function () {
            return false;
        });
        // handle context menu clicks.
        $('#div_GrillaPrincipal').on('rowclick', function (event) {
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
        $('#div_ContextMenu').on('itemclick', function (event) {
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
                if ($.trim($(opcion).text()) === "Ver Detalle") {
                    mode = 'U';
                    fn_EditarCab();
                } else if ($.trim($(opcion).text()) === "Ver Anexos") {
                    if (archivo !== '') {
                        document.location.target = "_blank";
                        document.location.href = "../Descarga?opcion=CertificadoPresupuestal&periodo=" + periodo + "&unidadOperativa=" + unidadOperativa + "&presupuesto=" + presupuesto + "&codigo=" + codigo + "&documento=" + archivo;
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
                }
            } else {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'No puede realizar este Tipo de Operaci�n, Registro Anulado',
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
            codigo = row['solicitud'];
            unidadOperativa=row['unidad'].substring(0, 4);
            estado = row['estado'];
            tipoCertificado = row['tipo'];
            tipoSolicitud = tipoCertificado.substring(0, 2);
            sustento = row['detalle'];
            tipoCalendario = row['tipoCalendario'];
            subTipoCalendario = row['subTipoCalendario'];
            cobertura = row['cobertura'];
            firmaJefe = row['firmaJefe'];
            firmaSubJefe = row['firmaSubJefe'];
            archivo = row['archivo'];
        });
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: '310',
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
                var editButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/update42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                container.append(editButtonDet);
                toolbar.append(container);
                editButtonDet.jqxButton({width: 30, height: 22});
                editButtonDet.jqxTooltip({position: 'bottom', content: "Editar Registro"});
                editButtonDet.click(function (event) {
                    modeDetalle = 'U';
                    if (indiceDetalle >= 0) {
                        var tipoCalendario = $("#cbo_TipoCalendario").val();
                        if (tipoCalendario !== '0') {
                            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
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
            },
            columns: [
                {text: 'N�', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', align: 'center', columntype: 'number', width: '4%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'DEPENDENCIA', datafield: 'dependencia', width: "8%", align: 'center'},
                {text: 'SECUENCIA', datafield: 'secuencia', width: "20%", align: 'center'},
                {text: 'TAREA', datafield: 'tarea', width: "20%", align: 'center'},
                {text: 'CADENA', datafield: 'cadena', width: "20%", align: 'center'},
                {text: 'IMPORTE', dataField: 'importe', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EXTRANJERA', dataField: 'extranjera', width: "10%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'RESOLUCION', datafield: 'resolucion', width: "6%", align: 'center'}
            ]
        });
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
            var tipoCalendario = $("#cbo_TipoCalendario").val();
            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
            fn_cargarComboAjax("#cbo_CadenaGasto", {mode: 'cadenaGastoCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                tipoCalendario: tipoCalendario, resolucion: fn_extraerDatos(dataRecord.resolucion, ':'), dependencia: fn_extraerDatos(dataRecord.dependencia, ':'),
                tipoCertificado: tipoSolicitud, secuenciaFuncional: fn_extraerDatos(dataRecord.secuencia, ':'), tarea: fn_extraerDatos(dataRecord.tarea, ':')});
        });
    });
    //Funcion de Refrescar o Actulizar los datos de la Grilla.
    function fn_EditarCab() {
        if (estado !== 'ANULADA') {
            fn_cargarComboAjax("#cbo_TipoCalendario", {mode: 'tipoCalendarioCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa});
            fn_cargarComboAjax("#cbo_PAACProcesos", {mode: 'PAACProcesos', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCertificado: 'AM'});
            $.ajax({
                type: "GET",
                url: "../CertificadoPresupuestal",
                data: {mode: 'U', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo, tipsol: 'CE'},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 13) {
                        $('#txt_NumeroSolicitud').val(dato[0]);
                        var d = new Date(dato[1]);
                        d.setDate(d.getDate() + 1);
                        $('#txt_Fecha ').jqxDateTimeInput('setDate', d);
                        $("#cbo_TipoCalendario").jqxDropDownList('selectItem', dato[2]);
                        $('#txt_DocumentoReferencia').val(dato[4]);
                        $('#txt_Detalle').val(dato[5]);
                        $('#txt_Observacion').val(dato[6].trim());
                        $("#cbo_PAACProcesos").jqxDropDownList('selectItem', dato[7]);
                        $('#txt_solicitudCredito').val(dato[8].trim());
                        $('#div_GrillaRegistro').jqxGrid('clear');
                        $("#cbo_InformeDisponibilidad").jqxDropDownList('selectItem', dato[12]);
                        $.ajax({
                            type: "GET",
                            url: "../CertificadoPresupuestal",
                            data: {mode: 'B', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                            success: function (data) {
                                data = data.replace("[", "");
                                var fila = data.split("[");
                                var rows = new Array();
                                for (i = 1; i < fila.length; i++) {
                                    var columna = fila[i];
                                    var datos = columna.split("+++");
                                    while (datos[6].indexOf(']') > 0) {
                                        datos[6] = datos[6].replace("]", "");
                                    }
                                    while (datos[6].indexOf(',') > 0) {
                                        datos[6] = datos[6].replace(",", "");
                                    }
                                    var row = {dependencia: datos[0], secuencia: datos[1], tarea: datos[2], cadena: datos[3],
                                        importe: parseFloat(datos[4]), extranjera: parseFloat(datos[5]), resolucion: datos[6]};
                                    rows.push(row);
                                }
                                if (rows.length > 0)
                                    $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
                                fn_verTotal();
                                if (parseInt(dato[7]) === 0) {
                                    $("#cbo_PAACProcesos").jqxDropDownList('setContent', 'Seleccione');
                                }
                                $("#cbo_SubTipoCalendario").jqxDropDownList('selectItem', dato[3]);
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
        $("#div_VentanaPrincipal").remove();
        $("#div_VentanaDetalle").remove();
        $("#div_ContextMenu").remove();
        $("#div_Reporte").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "POST",
            url: "../CertificadoPresupuestal",
            data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: "%"},
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
            var alto = 670;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaPrincipal').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_Cancelar'),
                initContent: function () {
                    $("#txt_NumeroSolicitud").jqxInput({width: 130, height: 20, disabled: true});
                    $("#txt_solicitudCredito").jqxInput({width: 130, height: 20, disabled: true});
                    $("#txt_Fecha").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                    $("#cbo_TipoCalendario").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                    $('#cbo_TipoCalendario').on('change', function () {
                        var tipoCalendario = $("#cbo_TipoCalendario").val();
                        $("#cbo_SubTipoCalendario").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_SubTipoCalendario", {mode: 'subTipoCalendario', presupuesto: presupuesto, codigo: tipoCalendario});
                    });
                    $("#cbo_TipoMoneda").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                    $('#cbo_TipoMoneda').on('change', function () {
                        fn_verTipoMoneda();
                    });
                    $("#div_TipoCambio").jqxNumberInput({width: 80, height: 20, digits: 3, decimalDigits: 3, disabled: true});
                    $("#cbo_SubTipoCalendario").jqxDropDownList({animationType: 'fade', width: 650, height: 20});
                    $('#cbo_SubTipoCalendario').on('change', function () {
                        var codigo = $("#cbo_SubTipoCalendario").val();
                        if (codigo === '55') {
                            fn_cargarComboAjax("#cbo_InformeDisponibilidad", {mode: 'idpCertificado', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa});
                            $("#cbo_InformeDisponibilidad").jqxDropDownList({width: 650});
                        } else {
                            $("#cbo_InformeDisponibilidad").jqxDropDownList('clear');
                            $("#cbo_InformeDisponibilidad").jqxDropDownList({width: 80});
                        }
                    });
                    $("#cbo_PAACProcesos").jqxDropDownList({animationType: 'fade', width: 650, height: 20});
                    $("#cbo_InformeDisponibilidad").jqxDropDownList({animationType: 'fade', height: 20});
                    $("#txt_DocumentoReferencia").jqxInput({placeHolder: "Ingrese Documento de Referencia", width: 670, height: 20, minLength: 1});
                    $("#txt_Detalle").jqxInput({placeHolder: "Ingrese detalle de la Solicitud", width: 670, height: 20, minLength: 1});
                    $("#txt_Observacion").jqxInput({placeHolder: "Ingrese las Observaciones", width: 670, height: 20, minLength: 1});
                    $("#div_TotalNacional").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                    $("#div_TotalExtranjera").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                    $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                }
            });
            //Inicia los Valores de Ventana del Detalle
            ancho = 600;
            alto = 200;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaDetalle').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CancelarDetalle'),
                initContent: function () {
                    $("#cbo_Resolucion").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 550, height: 20});
                    $('#cbo_Resolucion').on('change', function () {
                        var tipoCalendario = $("#cbo_TipoCalendario").val();
                        fn_cargarComboAjax("#cbo_Dependencia", {mode: 'dependenciaCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                            tipoCalendario: tipoCalendario, resolucion: $("#cbo_Resolucion").val(), tipoCertificado: tipoSolicitud, solicitudCredito: $("#txt_solicitudCredito").val(), informeDisponibilidad: $("#cbo_InformeDisponibilidad").val()});
                    });
                    $("#cbo_Dependencia").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 550, height: 20});
                    $('#cbo_Dependencia').on('change', function () {
                        var tipoCalendario = $("#cbo_TipoCalendario").val();
                        var resolucion = $("#cbo_Resolucion").val();
                        fn_cargarComboAjax("#cbo_SecuenciaFuncional", {mode: 'secuenciaFuncionalCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                            tipoCalendario: tipoCalendario, resolucion: resolucion, dependencia: $("#cbo_Dependencia").val(), tipoCertificado: tipoSolicitud, solicitudCredito: $("#txt_solicitudCredito").val(), informeDisponibilidad: $("#cbo_InformeDisponibilidad").val()});
                    });
                    $("#cbo_SecuenciaFuncional").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 600, height: 20});
                    $('#cbo_SecuenciaFuncional').on('change', function () {
                        var tipoCalendario = $("#cbo_TipoCalendario").val();
                        var resolucion = $("#cbo_Resolucion").val();
                        var dependencia = $("#cbo_Dependencia").val();
                        fn_cargarComboAjax("#cbo_Tarea", {mode: 'tareaCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                            tipoCalendario: tipoCalendario, resolucion: resolucion, dependencia: dependencia, secuenciaFuncional: $("#cbo_SecuenciaFuncional").val(), tipoCertificado: tipoSolicitud, solicitudCredito: $("#txt_solicitudCredito").val(), informeDisponibilidad: $("#cbo_InformeDisponibilidad").val()});
                    });
                    $("#cbo_Tarea").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 600, height: 20});
                    $('#cbo_Tarea').on('change', function () {
                        var tipoCalendario = $("#cbo_TipoCalendario").val();
                        var resolucion = $("#cbo_Resolucion").val();
                        var dependencia = $("#cbo_Dependencia").val();
                        var secuenciaFuncional = $("#cbo_SecuenciaFuncional").val();
                        fn_cargarComboAjax("#cbo_CadenaGasto", {mode: 'cadenaGastoCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                            tipoCalendario: tipoCalendario, resolucion: resolucion, dependencia: dependencia, secuenciaFuncional: secuenciaFuncional, tarea: $("#cbo_Tarea").val(), tipoCertificado: tipoSolicitud, solicitudCredito: $("#txt_solicitudCredito").val(), informeDisponibilidad: $("#cbo_InformeDisponibilidad").val()});
                    });
                    $("#cbo_CadenaGasto").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 600, height: 20});
                    $("#div_Importe").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                    $("#div_MonedaExtranjera").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                    $('#div_MonedaExtranjera').on('textchanged', function (event) {
                        fn_verTipoCambio();
                    });
                    $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                }
            });
            /**/
            ancho = 400;
            alto = 220;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_Reporte').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CerrarImprimir'),
                initContent: function () {
                    $("#div_EJE0001").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0001').on('checked', function (event) {
                        reporte = 'EJE0001';
                    });
                    $("#div_EJE0002").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0002').on('checked', function (event) {
                        reporte = 'EJE0002';
                    });
                    $("#div_EJE0003").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0003').on('checked', function (event) {
                        reporte = 'EJE0003';
                    });
                    $("#div_EJE0004").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0004').on('checked', function (event) {
                        reporte = 'EJE0004';
                    });
                    $("#div_EJE0005").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0005').on('checked', function (event) {
                        reporte = 'EJE0005';
                    });
                    $("#div_EJE0006").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0006').on('checked', function (event) {
                        reporte = 'EJE0006';
                    });
                    $("#div_EJE0007").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0007').on('checked', function (event) {
                        reporte = 'EJE0007';
                    });
                    $("#div_EJE0039").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0039').on('checked', function (event) {
                        reporte = 'EJE0039';
                    });
                    $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').on('click', function (event) {
                        var msg = "";
                        switch (reporte) {
                            case "EJE0001":
                                if (codigo === null)
                                    msg += "Seleccione la Solicitud de Credito Presupuestario.<br>";
                                break;
                            case "EJE0002":
                                if (codigo === null)
                                    msg += "Seleccione la Solicitud de Credito Presupuestario.<br>";
                                if (tipoCertificado !== 'CERTIFICADO')
                                    msg += "Seleccione la S.C.P. Tipo CERTIFICADO.<br>";
                                break;
                            case "EJE0003":
                                if (codigo === null)
                                    msg += "Seleccione la Solicitud de Credito Presupuestario.<br>";
                                if (tipoCertificado !== 'CERTIFICADO')
                                    msg += "Seleccione la S.C.P. Tipo CERTIFICADO.<br>";
                                break;
                            case "EJE0004":
                                if (codigo !== null && tipoCertificado !== 'CERTIFICADO')
                                    msg += "Seleccione la S.C.P. Tipo CERTIFICADO.<br>";
                                break;
                            case "EJE0005":
                                break;
                            case "EJE0039":
                                codigo = cobertura;
                                codigo = codigo.substr(0, codigo.indexOf("-"));
                                if (codigo === null)
                                    msg += "Seleccione la Solicitud de Credito Presupuestario.<br>";
                                if (tipoCertificado !== 'CERTIFICADO')
                                    msg += "Seleccione la S.C.P. Tipo CERTIFICADO.<br>";
                                break;
                            case "EJE0006":
                                codigo = cobertura;
                                codigo = codigo.substr(0, codigo.indexOf("-"));
                                if (codigo === null)
                                    msg += "Seleccione la Solicitud de Credito Presupuestario.<br>";
                                if (!autorizacion)
                                    msg += "Usuario no Autorizado para este Tipo de Reporte.<br>";
                                //  if (firmaJefe !== 'SI')
                                //       msg += "No puede imprimir esta Registro, Falta Firmar el Jefe de la OPRE.<br>";
                                //  if (firmaSubJefe !== 'SI')
                                //       msg += "No puede imprimir esta Registro, Falta Firmar el Sub Jefe de la OPRE.<br>";
                                break;
                            case "EJE0007":
                                codigo = cobertura;
                                codigo = codigo.substr(0, codigo.indexOf("-"));
                                if (codigo === null)
                                    msg += "Seleccione la Solicitud de Credito Presupuestario.<br>";
                                if (!autorizacion)
                                    msg += "Usuario no Autorizado para este Tipo de Reporte.<br>";
                                //  if (firmaJefe !== 'SI')
                                //       msg += "No puede imprimir esta Registro, Falta Firmar el Jefe de la OPRE.<br>";
                                //  if (firmaSubJefe !== 'SI')
                                //       msg += "No puede imprimir esta Registro, Falta Firmar el Sub Jefe de la OPRE.<br>";
                                break;
                            default:
                                msg += "Debe selecciona una opci�n.<br>";
                                break;
                        }
                        if (msg === "") {
                            var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto + "&codigo=" + codigo + "&codigo2=" + codigo;
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
        };
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
            } else {
                return "";
            }
        } else {
            return "Seleccione la Cadena de Gasto";
        }
    }
    //FUNCION PARA VALIDAR QUE NO SE REPITAN LOS REGISTROS DEL DETALLE
    function fn_validaDetalle(resolucion, dependencia, secuencia, tarea, cadenaGasto) {
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        if (modeDetalle === 'I') {
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (row.resolucion.trim() === resolucion.trim() && row.dependencia.trim() === dependencia.trim() && row.secuencia.trim() === secuencia.trim() &&
                        row.tarea.trim() === tarea.trim() && row.cadena.trim() === cadenaGasto.trim()) {
                    return "Los Datos que desea registrar ya existen, Revise!!";
                }
            }
        }
        if (modeDetalle === 'U') {
            if (rows[indiceDetalle].resolucion.trim() === dependencia.trim() && rows[indiceDetalle].dependencia.trim() === dependencia.trim() && rows[indiceDetalle].secuencia.trim() === secuencia.trim() &&
                    rows[indiceDetalle].tarea.trim() === tarea.trim() && rows[indiceDetalle].cadena.trim() === cadenaGasto.trim()) {
                return "";
            } else {
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (i !== indiceDetalle && row.resolucion.trim() === resolucion.trim() && row.dependencia.trim() === dependencia.trim() && row.secuencia.trim() === secuencia.trim() &&
                            row.tarea.trim() === tarea.trim() && row.cadena.trim() === cadenaGasto.trim()) {
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
<div id="div_VentanaPrincipal" style="display: none;">
    <div>
        <span style="float: left">SOLICITUD DE CERTIFICADO DE CREDITO PRESUPUESTAL</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_Certificado" name="frm_Certificado" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">N&deg; Solicitud : </td>
                    <td><input type="text" id="txt_NumeroSolicitud" name="txt_NumeroSolicitud"/></td>
                    <td class="inputlabel">Solicitud : </td>
                    <td><input type="text" id="txt_solicitudCredito" name="txt_solicitudCredito"/></td>
                    <td class="inputlabel">Fecha : </td>
                    <td ><div id="txt_Fecha"></div>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Presupuesto : </td>
                    <td colspan="5" >
                        <select id="cbo_TipoCalendario" name="cbo_TipoCalendario">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objTipoCalendario}">   
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Motivo : </td>
                    <td colspan="5">
                        <select id="cbo_SubTipoCalendario" name="cbo_SubTipoCalendario">
                            <option value="0">Seleccione</option>   
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">PAAC : </td>
                    <td colspan="5" >
                        <select id="cbo_PAACProcesos" name="cbo_PAACProcesos">
                            <option value="0">Seleccione</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">IDP : </td>
                    <td colspan="5">
                        <select id="cbo_InformeDisponibilidad" name="cbo_InformeDisponibilidad">
                            <option value="0">Seleccione</option>   
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
                            <input type="button" id="btn_Cancelar" value="Cancelar" style="margin-right: 20px"/>
                        </div>
                    </td>
                </tr>
            </table>
            <div id="div_GrillaRegistro"></div>
            <div id='div_VentanaDetalle' style='display: none;'>
                <div>
                    <span style="float: left">DETALLE DE SOLICITUD DE CERTIFICADO DE CREDITO PRESUPUESTAL</span>
                </div>
                <div style="overflow: hidden">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="inputlabel">Resoluci&oacute;n : </td>
                            <td colspan="3">
                                <select id="cbo_Resolucion" name="cbo_Resolucion">
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
                            <td><div id="div_Importe"></div></td>
                            <td class="inputlabel">Extranjera : </td>
                            <td><div id="div_MonedaExtranjera"></div></td>
                        </tr>
                        <tr>
                            <td class="Summit" colspan="4">
                                <div>
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
<div id="div_Reporte" style="display: none;">
    <div>
        <span style="float: left">LISTADO DE REPORTES</span>
    </div>
    <div style="overflow: hidden">
        <div id='div_EJE0001'>Solicitud de Credito Presupuestal</div>
        <div id='div_EJE0002'>Control de Solicitud</div>
        <div id='div_EJE0003'>Control de Solicitud - Dependencia</div>
        <div id='div_EJE0004'>Listado de Compromisos Anuales</div>
        <div id='div_EJE0005'>Certificados vs Compromiso Anual</div>
        <div id='div_EJE0039'>Avance Presupuestal del Certificado</div>
        <div id='div_EJE0006'>Anexo a la PCA</div>
        <div id='div_EJE0007'>Memorando de Certificaci�n</div>
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li style=" font-weight: bold;">Ver Detalle</li>
        <li type='separator'></li>
        <li  style="color: blue; font-weight: bold;">Ver Anexos</li>
    </ul>
</div>