<%-- 
    Document   : ListaDeclaracionJurada
    Created on : 18/07/2017, 10:16:43 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var mes = $("#cbo_Mes").val();
    var tipoCalendario = null;
    var codigo = null;
    var detalle = null;
    var estado = null;
    var mode = null;
    var indiceDetalle = -1;
    var indiceNominal = -1;
    var modeDetalle = null;
    var modeNominal = null;
    var cobertura = null;
    var firmaJefe = null;
    var firmaSubJefe = null;
    var codigoJadpe = null;
    var archivo = '';
    var lista = new Array();
    <c:forEach var="c" items="${objDeclaracionJurada}">
    var result = {declaracionJurada: '${c.declaracionJurada}', compromisoAnual: '${c.compromisoAnual}', cobertura: '${c.cobertura}',
        detalle: '${c.detalle}', documentoReferencia: '${c.documentoReferencia}', fecha: '${c.fecha}', importe: '${c.importe}',
        tipoCambio: '${c.tipoCambio}', monedaExtranjera: '${c.monedaExtranjera}', estado: '${c.estado}', opinion: '${c.tipo}',
        firmaJefe: '${c.firmaJefe}', firmaSubJefe: '${c.firmaSubJefe}', sectorista: '${c.sectorista}', archivo: '${c.archivo}'};
    lista.push(result);
    </c:forEach>
    var listaDet = new Array();
    <c:forEach var="d" items="${objDeclaracionJuradaDetalle}">
    var result = {declaracionJurada: '${d.declaracionJurada}', correlativo: '${d.correlativo}', dependencia: '${d.dependencia}',
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
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            }
        };
        var dataNuevo = new $.jqx.dataAdapter(sourceNuevo);
        //PARA LA GRILLA RELACION NOMINAL
        var sourceNominal = {
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "beneficiario", type: "string"},
                        {name: "grado", type: "string"},
                        {name: "importe", type: "number"},
                        {name: "beneficio", type: "string"}
                    ],
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            }
        };
        var dataNominal = new $.jqx.dataAdapter(sourceNominal);
        //para la grilla de registro de jadpe
        var sourceJadpe = {
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "oficio", type: "string"},
                        {name: "resolucion", type: "string"},
                        {name: "grado", type: "string"},
                        {name: "beneficiario", type: "string"},
                        {name: "importe", type: "number"},
                        {name: "subTipo", type: "string"}
                    ],
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            }
        };
        var dataJadpe = new $.jqx.dataAdapter(sourceJadpe);
        //PARA LA GRILLA DE LA CABECERA
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: "declaracionJurada", type: "string"},
                        {name: "cobertura", type: "string"},
                        {name: "compromisoAnual", type: "string"},
                        {name: "detalle", type: "string"},
                        {name: "documentoReferencia", type: "string"},
                        {name: "fecha", type: "string", format: 'dd/MM/yyyy'},
                        {name: "importe", type: "number"},
                        {name: "tipoCambio", type: "number"},
                        {name: "monedaExtranjera", type: "number"},
                        {name: "estado", type: "string"},
                        {name: "opinion", type: "string"},
                        {name: "firmaJefe", type: "string"},
                        {name: "firmaSubJefe", type: "string"},
                        {name: "sectorista", type: "string"},
                        {name: "archivo", type: "string"}
                    ],
            root: "DeclaracionJuarada",
            record: "DeclaracionJuarada",
            id: 'declaracionJurada'
        };
        //PARA LA GRILLA DEL DETALLE 
        var sourceDet = {
            localdata: listaDet,
            datatype: "array",
            datafields:
                    [
                        {name: "declaracionJurada", type: "string"},
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
            root: "DetalleDeclaracionJuarada",
            record: "Detalle",
            id: 'declaracionJurada',
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
                var result = filter.evaluate(nested[m]["declaracionJurada"]);
                if (result)
                    ordersbyid.push(nested[m]);
            }
            var sourceNested = {
                datafields: [
                    {name: "declaracionJurada", type: "string"},
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
                id: 'declaracionJurada',
                localdata: ordersbyid
            };
            var nestedGridAdapter = new $.jqx.dataAdapter(sourceNested);
            if (grid !== null) {
                grid.jqxGrid({
                    source: nestedGridAdapter,
                    width: '97%',
                    height: 300,
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
            if (datafield === "codigo" || datafield === "declaracionJurada" || datafield === "tipoCambio") {
                return "RowBold";
            }
            if (datafield === "compromisoAnual") {
                return "RowPurple";
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
                    mode = 'I';
                    $("#cbo_CompromisoAnual").jqxDropDownList({disabled: false});
                    $('#div_GrillaRegistro').jqxGrid('clear');
                    $.ajax({
                        type: "GET",
                        url: "../DeclaracionJurada",
                        data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
                        success: function (data) {
                            $('#txt_DeclaracionJurada').val(data);
                            $('#txt_DocumentoReferencia').val('');
                            $('#txt_Detalle').val('');
                            $('#txt_Observacion').val('');
                            $("#cbo_TipoMoneda").jqxDropDownList('selectItem', '01');
                            $('#div_TipoCambio').val(0);
                        }
                    });
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //export to excel
                exportButton.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'DeclaracionJurada');
                });
                reporteButton.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 350, rowdetailshidden: true},
            columns: [
                {text: 'PEDIDO', dataField: 'declaracionJurada', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'COMPR. ANUAL', dataField: 'compromisoAnual', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'COBERTURA', dataField: 'cobertura', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DETALLE', dataField: 'detalle', width: '30%', align: 'center', cellclassname: cellclass},
                {text: 'DOCU. REFERENCIA', dataField: 'documentoReferencia', width: '20%', align: 'center', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return "";
                                    }}]},
                {text: 'FECHA', dataField: 'fecha', columntype: 'datetimeinput', filtertype: 'date', width: '8%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'importe', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'T/CAMBIO', dataField: 'tipoCambio', width: '4%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'EXTRANJERA', dataField: 'monedaExtranjera', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'I.D.P.', dataField: 'opinion', filtertype: 'checkedlist', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'SECTORISTA', dataField: 'sectorista', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
                
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL 
        var alto = 235;
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: alto, autoOpenPopup: false, mode: 'popup'});
        $("#div_GrillaPrincipal").on('contextmenu', function () {
            return false;
        });
        $("#div_GrillaPrincipal").on('rowclick', function (event) {
            if (event.args.rightclick) {
                $("#div_GrillaPrincipal").jqxGrid('selectrow', event.args.rowindex);
                var scrollTop = $(window).scrollTop();
                var scrollLeft = $(window).scrollLeft();
                if (parseInt(event.args.originalEvent.clientY) > 500) {
                    scrollTop = scrollTop - alto;
                }
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
                var scrollTop = $(window).scrollTop();
                var scrollLeft = $(window).scrollLeft();
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
                                        url: "../IduDeclaracionJurada",
                                        data: {mode: 'D', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes, declaracionJurada: codigo},
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
                    $.confirm({
                        title: 'CERRAR DECLARACIÓN JURADA',
                        type: 'blue',
                        content: '' +
                                '<form method="post"  name="frm_DeclaracionJuradaCerrar" id="frm_DeclaracionJuradaCerrar" action="../IduDeclaracionJurada" enctype="multipart/form-data">' +
                                '<label>Anexos : </label>' +
                                '<input type="file" name="fichero" id="fichero" style="text-transform: uppercase;" class="name form-control" multiple/>' +
                                '</form>',
                        buttons: {
                            formSubmit: {
                                text: 'Enviar',
                                btnClass: 'btn-blue',
                                action: function () {
                                    fn_GuardarCerrar();
                                }
                            },
                            cancel: function () {
                            }
                        },
                        onContentReady: function () {
                            // bind to events
                            var jc = this;
                            this.$content.find('form').on('submit', function (e) {
                                // if the user submits the form by pressing enter in the field.
                                e.preventDefault();
                                jc.$$formSubmit.trigger('click'); // reference the button and click it
                            });
                        }
                    });
                } else if ($.trim($(opcion).text()) === "Ver Anexos") {
                    if (archivo !== '') {
                        document.location.target = "_blank";
                        document.location.href = "../Descarga?opcion=DeclaracionJurada&periodo=" + periodo + "&unidadOperativa=" + unidadOperativa + "&presupuesto=" + presupuesto + "&codigo=" + codigo + "&documento=" + archivo;
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
                } else if ($.trim($(opcion).text()) === "Relación Nominal") {
                    if (unidadOperativa === '0702') {
                        fn_DatosRelacionNominal();
                        $('#div_VentanaPedidoJadpe').jqxWindow({isModal: true});
                        $('#div_VentanaPedidoJadpe').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Usuario no Autorizado para realizar este Tipo de Operación.',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                } else if (autorizacion === 'true') {
                    if ($.trim($(opcion).text()) === "Generar Cobertura") {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Generar la Cobertura de la Declaración Jurada?',
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
                                            url: "../IduDeclaracionJurada",
                                            data: {mode: 'A', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, declaracionJurada: codigo},
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
                    } else if ($.trim($(opcion).text()) === "Transferir OEE") {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Transferir la Cobertura?',
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
                                            url: "../IduDeclaracionJurada",
                                            data: {mode: 'T', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes, declaracionJurada: cobertura},
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
                                                                    var url = '../Reportes?reporte=EJE0031&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto + "&codigo=" + cobertura + "&codigo2=" + cobertura;
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
                    } else if ($.trim($(opcion).text()) === "Reversiones") {
                        mode = 'R';
                        fn_ReversionesCab();
                    } else if ($.trim($(opcion).text()) === "Rechazar") {
                        if (autorizacion === 'true') {
                            $.confirm({
                                theme: 'material',
                                title: 'AVISO DEL SISTEMA',
                                content: '¿Desea RECHAZAR la Declaración Jurada?',
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
                                                url: "../IduDeclaracionJurada",
                                                data: {mode: 'V', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, declaracionJurada: codigo},
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
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Operación no Valida',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
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
            codigo = row['declaracionJurada'];
            estado = row['estado'];
            cobertura = row['cobertura'];
            firmaJefe = row['firmaJefe'];
            firmaSubJefe = row['firmaSubJefe'];
            archivo = row['archivo'];
        });
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: '330',
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
                    var compromisoAnual = $("#cbo_CompromisoAnual").val();
                    if (compromisoAnual !== '0') {
                        $("#cbo_Proveedor").jqxDropDownList('clear');
                        $("#cbo_Resolucion").jqxDropDownList('clear');
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_Proveedor", {mode: 'proveedorDeclaracionJurada', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                            compromisoAnual: compromisoAnual, tipoCalendario: tipoCalendario, cobertura: cobertura});
                        $('#div_Importe').val(0);
                        $('#div_MonedaExtranjera').val(0);
                        $("#cbo_Proveedor").jqxDropDownList({disabled: false});
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
                            content: 'Seleccione el Compromiso Anual',
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
                        var solicitudCredito = $("#cbo_CompromisoAnual").val();
                        if (solicitudCredito !== '0') {
                            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                            $("#cbo_Proveedor").jqxDropDownList('clear');
                            $("#cbo_Proveedor").jqxDropDownList({disabled: true});
                            $("#cbo_Proveedor").jqxDropDownList('setContent', dataRecord.proveedor);
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
        //GRILLA RELACION NOMINAL
        $("#div_GrillaRelacionNominal").jqxGrid({
            width: '100%',
            height: '400',
            source: dataNominal,
            pageable: true,
            columnsresize: true,
            showstatusbar: true,
            autoheight: false,
            autorowheight: false,
            showtoolbar: true,
            altrows: true,
            editable: false,
            sortable: true,
            filterable: true,
            showaggregates: true,
            statusbarheight: 25,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var addButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var deleteButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/delete42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var reporteButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(addButtonDet);
                container.append(deleteButtonDet);
                container.append(reporteButton);
                toolbar.append(container);
                addButtonDet.jqxButton({width: 30, height: 22});
                addButtonDet.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                deleteButtonDet.jqxButton({width: 30, height: 22});
                deleteButtonDet.jqxTooltip({position: 'bottom', content: "Anular Registro"});
                reporteButton.jqxButton({width: 30, height: 22});
                reporteButton.jqxTooltip({position: 'bottom', content: "Reporte"});
                // add new row.
                addButtonDet.click(function (event) {
                    modeNominal = 'I';
                    $('#div_VentanaRegistroJadpe').jqxWindow({isModal: true});
                    $('#div_VentanaRegistroJadpe').jqxWindow('open');
                    $("#div_GrillaRegistroJadpe").jqxGrid('clear');
                    $("#cbo_PeriodoJadpe").jqxDropDownList('clear');
                    $("#cbo_TipoBeneficio").jqxDropDownList('clear');
                    fn_cargarComboAjax("#cbo_PeriodoJadpe", {mode: 'periodoResolucion', codigo: $("#cbo_ResolucionJadpe").val()});
                    $('#div_GrillaRegistroJadpe').jqxGrid('clearselection');
                });
                // delete selected row.
                deleteButtonDet.click(function (event) {
                    modeNominal = 'D';
                    if (indiceNominal >= 0) {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Desea borrar el registro seleccionado?',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true,
                            buttons: {
                                aceptar: {
                                    text: 'Aceptar',
                                    btnClass: 'btn-primary',
                                    keys: ['enter', 'shift'],
                                    action: function () {
                                        var dataRecord = $("#div_GrillaRelacionNominal").jqxGrid('getrowdata', indiceNominal);
                                        codigoJadpe = dataRecord.codigo;
                                        fn_BorrarJadpe();
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
                            content: 'SELECCIONE UN REGISTRO',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                });
                reporteButton.click(function (event) {
                    var url = '../Reportes?reporte=EJE0042&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto + "&codigo=" + codigo;
                    window.open(url, '_blank');
                });
            },
            columns: [
                {text: 'N°', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', align: 'center', columntype: 'number', width: '4%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'BENEFICIARIO', datafield: 'beneficiario', width: "40%", align: 'center'},
                {text: 'GRADO', datafield: 'grado', width: "10%", align: 'center'},
                {text: 'IMPORTE', datafield: 'importe', width: "15%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', aggregates: ['sum']},
                {text: 'BENEFICIO', datafield: 'beneficio', width: "36%", align: 'center'}
            ]
        });
        $("#div_GrillaRegistroJadpe").jqxGrid({
            width: '100%',
            height: '370',
            source: dataJadpe,
            pageable: true,
            columnsresize: true,
            autoheight: false,
            autorowheight: false,
            autoshowfiltericon: true,
            showfilterrow: true,
            filterable: true,
            altrows: true,
            editable: false,
            sortable: true,
            showstatusbar: false,
            selectionmode: 'checkbox',
            columns: [
                {text: 'OFICIO', datafield: 'oficio', filtertype: 'textbox', width: "10%", align: 'center', cellsAlign: 'center'},
                {text: 'RESOLUCIÓN', datafield: 'resolucion', filtertype: 'textbox', width: "13%", align: 'center', cellsAlign: 'center'},
                {text: 'GRADO', datafield: 'grado', filtertype: 'checkedlist', width: "15%", align: 'center', cellsAlign: 'center'},
                {text: 'BENEFICIARIO', datafield: 'beneficiario', filtertype: 'textbox', width: "42%", align: 'center'},
                {text: 'IMPORTE', datafield: 'importe', filtertype: 'textbox', width: "15%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2'}
            ]
        });
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
            fn_cargarComboAjax("#cbo_CadenaGasto", {mode: 'cadenaGastoDeclaracionJurada', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                compromisoAnual: $("#cbo_CompromisoAnual").val(), proveedor: fn_extraerDatos(dataRecord.proveedor, ':'), resolucion: fn_extraerDatos(dataRecord.resolucion, ':'),
                dependencia: fn_extraerDatos(dataRecord.dependencia, ':'), secuenciaFuncional: fn_extraerDatos(dataRecord.secuencia, ':'), tarea: fn_extraerDatos(dataRecord.tarea, ':'), cobertura: cobertura});
        });
        $("#div_GrillaRelacionNominal").on('rowselect', function (event) {
            indiceNominal = event.args.rowindex;
        });
    });
    //funcion para datos de la relacion nominal
    function fn_DatosRelacionNominal() {
        $("#div_GrillaRelacionNominal").jqxGrid('clear');
        $.ajax({
            type: "GET",
            url: "../ResolucionJADPE",
            data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, mes: mes, pedido: codigo},
            success: function (data) {
                data = data.replace("[", "");
                var fila = data.split("[");
                var rows = new Array();
                for (i = 1; i < fila.length; i++) {
                    var columna = fila[i];
                    var datos = columna.split("+++");
                    while (datos[4].indexOf(']') > 0) {
                        datos[4] = datos[4].replace("]", "");
                    }
                    while (datos[4].indexOf(',') > 0) {
                        datos[4] = datos[4].replace(",", "");
                    }
                    var row = {codigo: datos[0], beneficiario: datos[1], grado: datos[2], importe: parseFloat(datos[3]), beneficio: datos[4]};
                    rows.push(row);
                }
                if (rows.length > 0)
                    $("#div_GrillaRelacionNominal").jqxGrid('addrow', null, rows);
            }
        });
    }
    //funcion para beneficiarios jadpe
    function fn_DatosRelacionJadpe() {
        $("#div_GrillaRegistroJadpe").jqxGrid('clear');
        $.ajax({
            type: "GET",
            url: "../ResolucionJADPE",
            data: {mode: 'B', periodo: periodo, tipo: $("#cbo_ResolucionJadpe").val(), periodoResolucion: $("#cbo_PeriodoJadpe").val(), codBeneficio: $("#cbo_TipoBeneficio").val()},
            success: function (data) {
                data = data.replace("[", "");
                var fila = data.split("[");
                var rows = new Array();
                for (i = 1; i < fila.length; i++) {
                    var columna = fila[i];
                    var datos = columna.split("+++");
                    while (datos[5].indexOf(']') > 0) {
                        datos[5] = datos[5].replace("]", "");
                    }
                    while (datos[5].indexOf(',') > 0) {
                        datos[5] = datos[5].replace(",", "");
                    }
                    var row = {codigo: datos[0], oficio: datos[1], resolucion: datos[2], beneficiario: datos[3], importe: parseFloat(datos[4]), grado: datos[5], subTipo: datos[6]};
                    rows.push(row);
                }
                if (rows.length > 0)
                    $("#div_GrillaRegistroJadpe").jqxGrid('addrow', null, rows);
            }
        });
    }
    //Funcion de Refrescar o Actulizar los datos de la Grilla.
    function fn_EditarCab() {
        if (estado !== 'ANULADA') {
            mode = 'U';
            $('#txt_DeclaracionJurada').val(codigo);
            $.ajax({
                type: "GET",
                url: "../DeclaracionJurada",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 9) {
                        $("#cbo_CompromisoAnual").jqxDropDownList('selectItem', dato[0]);
                        $('#txt_DocumentoReferencia').val(dato[1]);
                        $('#txt_Detalle').val(dato[2]);
                        $('#txt_Observacion').val(dato[3]);
                        var d = new Date(dato[5]);
                        d.setDate(d.getDate() + 1);
                        $('#txt_Fecha ').jqxDateTimeInput('setDate', d);
                        $('#div_GrillaRegistro').jqxGrid('clear');
                        tipoCalendario = dato[4];
                        $("#cbo_SubTipoCalendario").jqxDropDownList('selectItem', dato[8]);
                        $('#div_TipoCambio').jqxGrid('clear');
                        $("#cbo_CompromisoAnual").jqxDropDownList({disabled: true});
                        $.ajax({
                            type: "GET",
                            url: "../DeclaracionJurada",
                            data: {mode: 'B', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes, codigo: codigo},
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
    //Funcion de Refrescar o Actulizar los datos de la Grilla.
    function fn_ReversionesCab() {
        if (estado !== 'ANULADA') {
            mode = 'R';
            $('#txh_Reversion').html("Reversión DJ : " + codigo);
            $.ajax({
                type: "GET",
                url: "../DeclaracionJurada",
                data: {mode: 'R', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 4) {
                        tipoCalendario = '50';
                        $('#txt_DeclaracionJurada').val(dato[0]);
                        $('#cbo_CompromisoAnual').jqxDropDownList('selectItem', dato[1]);
                        $('#txt_DocumentoReferencia').val('');
                        $('#txt_Detalle').val('');
                        $('#txt_Observacion').val(dato[2]);
                        $('#div_GrillaRegistro').jqxGrid('clear');
                        $('#div_TipoCambio').jqxGrid(dato[3]);
                        $('#cbo_CompromisoAnual').jqxDropDownList({disabled: true});
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
    //Funcion para Actualizar la Pantalla
    function fn_Refrescar() {
        $("#div_GrillaPrincipal").remove();
        $("#div_VentanaPrincipal").remove();
        $("#div_VentanaDetalle").remove();
        $("#div_Reporte").remove();
        $("#div_ContextMenu").remove();
        $("#div_VentanaPedidoJadpe").remove();
        $("#div_VentanaRegistroJadpe").remove();
        $("#div_GrillaRegistro").remove();
        $("#div_GrillaRelacionNominal").remove();
        $("#div_GrillaRegistroJadpe").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "POST",
            url: "../DeclaracionJurada",
            data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes},
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
            var alto = 750;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaPrincipal').jqxWindow({
                position: {x: posicionX, y: posicionY+50},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_Cancelar'),
                initContent: function () {
                    $("#txt_DeclaracionJurada").jqxInput({width: 130, height: 20, disabled: true});
                    $("#txt_Fecha").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                    $("#cbo_CompromisoAnual").jqxDropDownList({animationType: 'fade', width: 650, height: 20, dropDownWidth: 700});
                    $('#cbo_CompromisoAnual').on('change', function () {
                        $.ajax({
                            type: "GET",
                            url: "../DeclaracionJurada",
                            data: {mode: 'CAL', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, compromisoAnual: $("#cbo_CompromisoAnual").val()},
                            success: function (data) {
                                var dato = data.split("+++");
                                if (dato.length === 2) {
                                    if (mode === 'I') {
                                        tipoCalendario = dato[0];
                                    }
                                    if (presupuesto === '3') {
                                        $("#txt_Detalle").val('');
                                        $("#txt_Detalle").val(dato[1]);
                                    }
                                    fn_cargarComboAjax("#cbo_SubTipoCalendario", {mode: 'subTipoCalendario', presupuesto: presupuesto, codigo: tipoCalendario});
                                }
                            }
                        });
                    });
                    $("#cbo_SubTipoCalendario").jqxDropDownList({animationType: 'fade', width: 500, height: 20});
                    $('#cbo_SubTipoCalendario').on('change', function () {
                        var codigo = $("#cbo_SubTipoCalendario").val();
                        if (codigo === '55') {
                            fn_cargarComboAjax("#cbo_InformeDisponibilidad", {mode: 'idpCertificado', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa});
                            $("#cbo_InformeDisponibilidad").jqxDropDownList({width: 500, dropDownWidth: 680});
                        } else {
                            $("#cbo_InformeDisponibilidad").jqxDropDownList('clear');
                            $("#cbo_InformeDisponibilidad").jqxDropDownList({width: 100});
                        }
                    });
                    $("#cbo_InformeDisponibilidad").jqxDropDownList({animationType: 'fade', height: 20});
                    $("#txt_DocumentoReferencia").jqxInput({placeHolder: "Ingrese Documento de Referencia", width: 650, height: 20, minLength: 1});
                    $("#txt_Detalle").jqxInput({placeHolder: "Ingrese detalle de la Solicitud", width: 650, height: 20, minLength: 1});
                    $("#txt_Observacion").jqxInput({placeHolder: "Ingrese las Observaciones", width: 650, height: 20, minLength: 1});
                    $("#cbo_TipoMoneda").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                    $('#cbo_TipoMoneda').on('change', function () {
                        fn_verTipoMoneda();
                    });
                    $("#div_TipoCambio").jqxNumberInput({width: 80, height: 20, digits: 3, decimalDigits: 3, disabled: true});
                    $("#div_TotalNacional").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                    $("#div_TotalExtranjera").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                    $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').on('click', function (event) {
                        $('#frm_DeclaracionJurada').jqxValidator('validate');
                    });
                    $('#frm_DeclaracionJurada').jqxValidator({
                        rules: [
                            {input: '#txt_DocumentoReferencia', message: 'Ingrese el Documento de Referencia!', action: 'keyup, blur', rule: 'required'},
                            {input: '#txt_Detalle', message: 'Ingrese el Detalle!', action: 'keyup, blur', rule: 'required'}
                        ]
                    });
                    $('#frm_DeclaracionJurada').jqxValidator({
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
                    $("#cbo_Proveedor").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                    $('#cbo_Proveedor').on('change', function () {
                        $("#cbo_Resolucion").jqxDropDownList('clear');
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_Resolucion", {mode: 'resolucionDeclaracionJurada', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                            compromisoAnual: $("#cbo_CompromisoAnual").val(), proveedor: $("#cbo_Proveedor").val(), cobertura: cobertura});
                    });
                    $("#cbo_Resolucion").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                    $('#cbo_Resolucion').on('change', function () {
                        $("#cbo_Dependencia").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_Dependencia", {mode: 'dependenciaDeclaracionJurada', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                            compromisoAnual: $("#cbo_CompromisoAnual").val(), proveedor: $("#cbo_Proveedor").val(), resolucion: $("#cbo_Resolucion").val(), cobertura: cobertura});
                    });
                    $("#cbo_Dependencia").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                    $('#cbo_Dependencia').on('change', function () {
                        $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        var resolucion = $("#cbo_Resolucion").val();
                        fn_cargarComboAjax("#cbo_SecuenciaFuncional", {mode: 'secuenciaFuncionalDeclaracionJurada', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                            compromisoAnual: $("#cbo_CompromisoAnual").val(), proveedor: $("#cbo_Proveedor").val(), resolucion: resolucion, dependencia: $("#cbo_Dependencia").val(), cobertura: cobertura});
                    });
                    $("#cbo_SecuenciaFuncional").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                    $('#cbo_SecuenciaFuncional').on('change', function () {
                        $("#cbo_Tarea").jqxDropDownList('clear');
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        var resolucion = $("#cbo_Resolucion").val();
                        var dependencia = $("#cbo_Dependencia").val();
                        fn_cargarComboAjax("#cbo_Tarea", {mode: 'tareaDeclaracionJurada', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                            compromisoAnual: $("#cbo_CompromisoAnual").val(), proveedor: $("#cbo_Proveedor").val(), resolucion: resolucion, dependencia: dependencia, secuenciaFuncional: $("#cbo_SecuenciaFuncional").val(), cobertura: cobertura});
                    });
                    $("#cbo_Tarea").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                    $('#cbo_Tarea').on('change', function () {
                        $("#cbo_CadenaGasto").jqxDropDownList('clear');
                        var resolucion = $("#cbo_Resolucion").val();
                        var dependencia = $("#cbo_Dependencia").val();
                        var secuenciaFuncional = $("#cbo_SecuenciaFuncional").val();
                        fn_cargarComboAjax("#cbo_CadenaGasto", {mode: 'cadenaGastoDeclaracionJurada', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipoCalendario: tipoCalendario,
                            compromisoAnual: $("#cbo_CompromisoAnual").val(), proveedor: $("#cbo_Proveedor").val(), resolucion: resolucion, dependencia: dependencia, secuenciaFuncional: secuenciaFuncional, tarea: $("#cbo_Tarea").val(), cobertura: cobertura});
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
                        var proveedor = $("#cbo_Proveedor").jqxDropDownList('getSelectedItem');
                        var resolucion = $("#cbo_Resolucion").jqxDropDownList('getSelectedItem');
                        var dependencia = $("#cbo_Dependencia").jqxDropDownList('getSelectedItem');
                        var secuenciaFuncional = $("#cbo_SecuenciaFuncional").jqxDropDownList('getSelectedItem');
                        var tarea = $("#cbo_Tarea").jqxDropDownList('getSelectedItem');
                        var cadenaGasto = $("#cbo_CadenaGasto").jqxDropDownList('getSelectedItem');
                        var msg = "";
                        if (msg === "")
                            msg = fn_validaSaldo();
                        if (msg === "" && modeDetalle === 'I') {
                            msg = fn_validaDetalle(fn_extraerDatos(proveedor.label, 'S/.'), fn_extraerDatos(resolucion.label, 'S/.'), fn_extraerDatos(dependencia.label, 'S/.'), fn_extraerDatos(secuenciaFuncional.label, 'S/.'),
                                    fn_extraerDatos(tarea.label, 'S/.'), fn_extraerDatos(cadenaGasto.label, 'S/.'));
                        }
                        if (msg === "" && modeDetalle === 'U') {
                            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                            msg = fn_validaDetalle(dataRecord.proveedor, dataRecord.resolucion, dataRecord.dependencia, dataRecord.secuencia, dataRecord.tarea, dataRecord.cadena);
                        }
                        if (msg === "") {
                            var importeNacional = parseFloat($("#div_Importe").jqxNumberInput('decimal'));
                            var importeExtranjero = parseFloat($("#div_MonedaExtranjera").jqxNumberInput('decimal'));
                            if (tipoCalendario === '50') {
                                importeNacional = Math.abs(importeNacional) * (-1);
                                importeExtranjero = Math.abs(importeExtranjero) * (-1);
                            }
                            if (modeDetalle === 'I') {
                                var row = {dependencia: fn_extraerDatos(dependencia.label, 'S/.'), proveedor: proveedor.label, secuencia: fn_extraerDatos(secuenciaFuncional.label, 'S/.'),
                                    tarea: fn_extraerDatos(tarea.label, 'S/.'), cadena: fn_extraerDatos(cadenaGasto.label, 'S/.'), importe: importeNacional,
                                    extranjera: importeExtranjero, resolucion: fn_extraerDatos(resolucion.label, 'S/.')};
                                $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
                            }
                            if (modeDetalle === 'U') {
                                var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                                var row = {dependencia: dataRecord.dependencia, proveedor: dataRecord.proveedor, secuencia: dataRecord.secuencia, tarea: dataRecord.tarea, cadena: dataRecord.cadena,
                                    importe: importeNacional, extranjera: importeExtranjero,
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
            ancho = 400;
            alto = 120;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_Reporte').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CerrarImprimir'),
                initContent: function () {
                    $("#div_EJE0012").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0012').on('checked', function (event) {
                        reporte = 'EJE0012';
                    });
                    $("#div_EJE0014").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0014').on('checked', function (event) {
                        reporte = 'EJE0014';
                    });
                    $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').on('click', function (event) {
                        var msg = "";
                        switch (reporte) {
                            case "EJE0012":
                                if (codigo === null)
                                    msg += "Seleccione la Declaración Jurada.<br>";
                                break;
                            case "EJE0014":
                                codigo = cobertura;
                                if (codigo === null)
                                    msg += "Seleccione la Declaración Jurada.<br>";
                                if (!autorizacion)
                                    msg += "Usuario no Autorizado para este Tipo de Reporte.<br>";
                                //  if (firmaJefe !== 'SI')
                                //      msg += "No puede imprimir esta Registro, Falta Firmar el Jefe de la OPRE.<br>";
                                //   if (firmaSubJefe !== 'SI')
                                //        msg += "No puede imprimir esta Registro, Falta Firmar el Sub Jefe de la OPRE.<br>";
                                break;
                            default:
                                msg += "Debe selecciona una opción.<br>";
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
            //ventana lista relacion nominal jadpe
            ancho = 800;
            alto = 400;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaPedidoJadpe').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                initContent: function () {
                    $('#div_VentanaPedidoJadpe').on('close', function (event) {
                        $('#div_VentanaPedidoJadpe').jqxWindow({isModal: false});
                    });
                }
            });
            //Inicia los Valores de Ventana registro jadpe
            var posicionX, posicionY;
            var ancho = 700;
            var alto = 500;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaRegistroJadpe').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CancelarJadpe'),
                initContent: function () {
                    $("#cbo_ResolucionJadpe").jqxDropDownList({animationType: 'fade', width: 250, height: 20});
                    fn_cargarComboAjax("#cbo_PeriodoJadpe", {mode: 'periodoResolucion', codigo: $("#cbo_ResolucionJadpe").val()});
                    $('#cbo_ResolucionJadpe').on('change', function () {
                        $("#cbo_PeriodoJadpe").jqxDropDownList('clear');
                        $("#cbo_TipoBeneficio").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_PeriodoJadpe", {mode: 'periodoResolucion', codigo: $("#cbo_ResolucionJadpe").val()});
                    });
                    $("#cbo_PeriodoJadpe").jqxDropDownList({animationType: 'fade', width: 250, height: 20});
                    $("#cbo_PeriodoJadpe").jqxDropDownList('clear');
                    $('#cbo_PeriodoJadpe').on('change', function () {
                        $("#cbo_TipoBeneficio").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_TipoBeneficio", {mode: 'beneficioJADPE', codigo: $("#cbo_ResolucionJadpe").val(), periodo: $("#cbo_PeriodoJadpe").val()});
                    });
                    $("#cbo_TipoBeneficio").jqxDropDownList({animationType: 'fade', width: 450, height: 20});
                    $("#cbo_TipoBeneficio").jqxDropDownList('clear');
                    $('#cbo_TipoBeneficio').on('change', function () {
                        fn_DatosRelacionJadpe();
                    });
                    $('#btn_CancelarJadpe').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarJadpe').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarJadpe').on('click', function (event) {
                        var msg = "";
                        if (msg === "")
                            msg = fn_verificarTipoJadpe();
                        if (msg === "")
                            msg = fn_verificarPeriodoJadpe();
                        if (msg === "")
                            msg = fn_verificarTipoBeneficio();
                        if (msg === "")
                            fn_GrabarJadpe();
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
    function fn_RefrescarJadpe() {
        $("#div_GrillaRelacionNominal").jqxGrid('clear');
        $("#div_GrillaRegistroJadpe").jqxGrid('clear');
        fn_DatosRelacionNominal();
    }
    //FUNCION PARA VERIFICAR TIPO JADPE
    function fn_verificarTipoJadpe() {
        var msg = "";
        var dato = "";
        dato = $("#cbo_ResolucionJadpe").val();
        if (dato === "" || dato === "0" || dato === null) {
            msg = "Seleccione el tipo";
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: msg,
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'orange',
                typeAnimated: true
            });
            return "ERROR";
        } else {
            return "";
        }
    }
    //FUNCION PARA VERIFICAR PERIODO JADPE
    function fn_verificarPeriodoJadpe() {
        var msg = "";
        var dato = "";
        dato = $("#cbo_PeriodoJadpe").val();
        if (dato === "" || dato === "0" || dato === null) {
            msg = "Seleccione el periodo";
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: msg,
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'orange',
                typeAnimated: true
            });
            return "ERROR";
        } else {
            return "";
        }
    }
    //FUNCION PARA VERIFICAR TIPO BENEFICIO
    function fn_verificarTipoBeneficio() {
        var msg = "";
        var dato = "";
        dato = $("#cbo_TipoBeneficio").val();
        if (dato === "" || dato === "0" || dato === null) {
            msg = "Seleccione el tipo de beneficio";
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: msg,
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'orange',
                typeAnimated: true
            });
            return "ERROR";
        } else {
            return "";
        }
    }
    //para borrar el detalle
    function fn_BorrarJadpe() {
        var msg = "";
        if (msg === "") {
            $.ajax({
                type: "POST",
                url: "../IduResolucionJADPE",
                data: {mode: modeNominal, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                    mes: mes, codigo: codigoJadpe,
                    pedido: codigo},
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
                                        $('#div_VentanaPedidoJadpe').jqxWindow({isModal: true});
                                        fn_RefrescarJadpe();
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
    }
    //funcion para grabar datos de la relacion nominal
    function fn_GrabarJadpe() {
        var tipo = $("#cbo_ResolucionJadpe").val();
        var periodoResolucion = $("#cbo_PeriodoJadpe").val();
        var codigoBeneficio = $("#cbo_TipoBeneficio").val();
        var msg = "";
        var lista = new Array();
        var result;
        var rows = $('#div_GrillaRegistroJadpe').jqxGrid('getselectedrowindexes');
        for (var i = 0; i < rows.length; i++) {
            var row = $('#div_GrillaRegistroJadpe').jqxGrid('getrowdata', rows[i]);
            result = row.uid + "---" + row.oficio + "---" + row.resolucion + "---" + row.subTipo + "---" + row.codigo;
            lista.push(result);
        }
        if (lista.length === 0) {
            msg += "Dele seleccionar al menos un registro.<br>";
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
        if (msg === "") {
            $.ajax({
                type: "POST",
                url: "../IduResolucionJADPE",
                data: {mode: modeNominal, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                    tipo: tipo, periodoResolucion: periodoResolucion, codigoBeneficio: codigoBeneficio, mes: mes,
                    pedido: codigo,
                    lista: JSON.stringify(lista)},
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
                                        $('#div_VentanaPedidoJadpe').jqxWindow({isModal: true});
                                        fn_RefrescarJadpe();
                                        $("#div_VentanaRegistroJadpe").jqxWindow('close');
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
    }
    function fn_GrabarDatos() {
        var msg = "";
        var declaracionJurada = $('#txt_DeclaracionJurada').val();
        var fecha = $('#txt_Fecha').val();
        var compromisoAnual = $("#cbo_CompromisoAnual").val();
        var subTipoCalendario = $("#cbo_SubTipoCalendario").val();
        var idp = $("#cbo_InformeDisponibilidad").val();
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
        if (compromisoAnual === '0')
            msg += "Seleccione un Compromiso Anual <br>";
        if (lista.length === 0)
            msg += "Ingrese el Detalle de la Declaración Jurada <br>";
        if (msg === "") {
            $.ajax({
                type: "POST",
                url: "../IduDeclaracionJurada",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes, declaracionJurada: declaracionJurada, fecha: fecha,
                    tipoCalendario: tipoCalendario, compromisoAnual: compromisoAnual, subTipoCalendario: subTipoCalendario, idp: idp,
                    documentoReferencia: documentoReferencia, detalle: detalle, observacion: observacion, tipoMoneda: tipoMoneda, tipoCambio: tipoCambio,
                    importe: importe, monedaExtranjera: monedaExtranjera, lista: JSON.stringify(lista)},
                success: function (data) {
                    msg = data;
                    if (msg === "GUARDO") {
                        $('#div_VentanaPrincipal').jqxWindow('close');
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
                content: msg,
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'red',
                typeAnimated: true
            });
        }
    }
    function fn_GuardarCerrar() {
        var fichero = $("#fichero").val();
        if (fichero === '')
            fichero = "SIN ARCHIVO";
        var formData = new FormData(document.getElementById("frm_DeclaracionJuradaCerrar"));
        formData.append("mode", "C");
        formData.append("periodo", periodo);
        formData.append("unidadOperativa", unidadOperativa);
        formData.append("presupuesto", presupuesto);
        formData.append("declaracionJurada", codigo);
        $.ajax({
            type: "POST",
            url: "../IduDeclaracionJurada",
            data: formData,
            dataType: "html",
            cache: false,
            contentType: false,
            processData: false,
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
            if (rows[indiceDetalle].proveedor.trim() === proveedor.trim() && rows[indiceDetalle].resolucion.trim() === dependencia.trim() && rows[indiceDetalle].dependencia.trim() === dependencia.trim() &&
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
        totalNacional = totalExtranjera = 0;
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
        <span style="float: left">GESTION DE DECLARACIÓN JURADA</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_DeclaracionJurada" name="frm_DeclaracionJurada" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">N&deg; DJ : </td>
                    <td><input type="text" id="txt_DeclaracionJurada" name="txt_DeclaracionJurada"/></td>
                    <td><span style="font-weight: bold;"><div id="txh_Reversion" name="txh_Reversion"></div></span></td>
                    <td class="inputlabel">Fecha : </td>
                    <td ><div id="txt_Fecha"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Nro. C.A. : </td>
                    <td colspan="4" >
                        <select id="cbo_CompromisoAnual" name="cbo_CompromisoAnual">
                            <option value="0">Seleccione</option>
                            <c:forEach var="e" items="${objCompromisosAnuales}">
                                <option value="${e.codigo}">${e.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Motivo : </td>
                    <td colspan="4">
                        <select id="cbo_SubTipoCalendario" name="cbo_SubTipoCalendario">
                            <option value="0">Seleccione</option>   
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">I.D.P. : </td>
                    <td colspan="4">
                        <select id="cbo_InformeDisponibilidad" name="cbo_InformeDisponibilidad">
                            <option value="0">Seleccione</option>   
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Doc. Ref. : </td>
                    <td colspan="4"><input type="text" id="txt_DocumentoReferencia" name="txt_DocumentoReferencia" style="text-transform: uppercase;"/></td>
                </tr>
                <tr> 
                    <td class="inputlabel">Detalle : </td>
                    <td colspan="4"><input type="text" id="txt_Detalle" name="txt_Detalle" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Observaci&oacute;n : </td>
                    <td colspan="4"><input type="text" id="txt_Observacion" name="txt_Observacion" style="text-transform: uppercase;"/></td>
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
                    <td colspan="2"><div id="div_TipoCambio"></div></td>
                </tr> 
                <tr>
                    <td class="inputlabel">TOTAL S/. : </td>
                    <td><div id="div_TotalNacional"></div></td>
                    <td class="inputlabel">TOTAL ME : </td>
                    <td colspan="2"><div id="div_TotalExtranjera"></div></td>
                </tr> 
                <tr>
                    <td class="Summit" colspan="5">
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
                    <span style="float: left">DETALLE DE LA DECLARACIÓN JURADA</span>
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
<div style="display: none" id="div_Reporte">
    <div>
        <span style="float: left">LISTADO DE REPORTES</span>
    </div>
    <div style="overflow: hidden">
        <div id='div_EJE0012'>Solicitud de Requerimiento Mensual</div>        
        <div id='div_EJE0014'>Anexo al Calendario de Pago</div>        
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
        <li style="color: teal; font-weight: bold;">Relación Nominal</li>
        <li type='separator'></li>
        <li style="font-weight: bold;">Generar Cobertura</li>
        <li style="font-weight: bold;">Transferir OEE</li>        
        <li style="font-weight: bold;">Reversiones</li>
        <li style="font-weight: bold; color: red;">Rechazar</li>
    </ul>
</div>
<div style="display: none" id="div_VentanaPedidoJadpe">
    <div>
        <span style="float: left">GESTIÓN RELACIÓN NOMINAL JADPE</span>
    </div>
    <div style="overflow: hidden">
        <div id="div_GrillaRelacionNominal"></div>    
    </div>
</div>
<div id="div_VentanaRegistroJadpe" style="display: none">
    <div>
        <span style="float: left">Datos Relación Nominal : </span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_RelacionNominal" name="frm_RelacionNominal" method="POST"  onsubmit="return false;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Resolución : </td>
                    <td>
                        <select id="cbo_ResolucionJadpe" name="cbo_ResolucionJadpe">
                            <option value="J">JADPE</option>
                            <option value="T">TESORERIA</option>
                        </select>
                    </td> 
                </tr>
                <tr>
                    <td class="inputlabel">Periodo : </td>
                    <td>
                        <select id="cbo_PeriodoJadpe" name="cbo_PeriodoJadpe">
                            <option value="0">Seleccione</option>
                        </select>
                    </td> 
                </tr>
                <tr>
                    <td class="inputlabel">Tipo Beneficio : </td>
                    <td>
                        <select id="cbo_TipoBeneficio" name="cbo_TipoBeneficio">
                            <option value="0">Seleccione</option>
                        </select>
                    </td> 
                </tr>
                <tr>
                    <td class="Summit" colspan="6">
                        <div>
                            <input type="button" id="btn_GuardarJadpe"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarJadpe" value="Cancelar" style="margin-right: 20px"/>
                        </div>
                    </td>
                </tr>
            </table>
            <div id="div_GrillaRegistroJadpe"></div>
        </form>
    </div>
</div>
