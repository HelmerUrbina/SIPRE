<%-- 
    Document   : ListaDisponibilidadPresupuestal
    Created on : 24/08/2017, 10:42:17 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var mes = $("#cbo_Mes").val();
    var codigo = null;
    var estado = null;
    var mode = null;
    var indiceDetalle = -1;
    var modeDetalle = null;
    var msg = null;
    var lista = new Array();
    <c:forEach var="c" items="${objDisponibilidadPresupuestal}">
    var result = {codigo: '${c.codigo}', unidad: '${c.unidad}', oficio: '${c.oficio}', tipo: '${c.tipo}', numero: '${c.periodo}',
        concepto: '${c.concepto}', importe: '${c.importe}', estado: '${c.estado}', fecha: '${c.fecha}',
        fechaAprobacion: '${c.fechaAprobacion}', nota: '${c.tarea}',
        SIAF: '${c.cadenaGasto}', cerrado: '${c.secuencia}', fechaCierre: '${c.fechaCierre}'};
    lista.push(result);
    </c:forEach>
    var listaDet = new Array();
    <c:forEach var="d" items="${objDisponibilidadPresupuestalDetalle}">
    var result = {codigo: '${d.codigo}', unidad: '${d.unidad}', dependencia: '${d.dependencia}', secuenciaFuncional: '${d.secuencia}',
        tarea: '${d.tarea}', cadenaGasto: '${d.cadenaGasto}', importe: '${d.importe}'};
    listaDet.push(result);
    </c:forEach>
    $(document).ready(function () {
        var sourceNuevo = {
            datafields:
                    [
                        {name: "resolucionCargo", type: "string"},
                        {name: "dependenciaCargo", type: "string"},
                        {name: "secuenciaFuncionalCargo", type: "string"},
                        {name: "tareaCargo", type: "string"},
                        {name: "cadenaGastoCargo", type: "string"},
                        {name: "unidadAbono", type: "string"},
                        {name: "dependenciaAbono", type: "string"},
                        {name: "secuenciaFuncionalAbono", type: "string"},
                        {name: "tareaAbono", type: "string"},
                        {name: "cadenaGastoAbono", type: "string"},
                        {name: "importe", type: "number"}
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
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "numero", type: "string"},
                        {name: "unidad", type: "string"},
                        {name: "tipo", type: "string"},
                        {name: "oficio", type: "string"},
                        {name: "concepto", type: "string"},
                        {name: "importe", type: "number"},
                        {name: "estado", type: "string"},
                        {name: "fecha", type: "string"},
                        {name: "fechaAprobacion", type: "string"},
                        {name: "nota", type: "string"},
                        {name: "SIAF", type: "string"},
                        {name: "cerrado", type: "string"},
                        {name: "fechaCierre", type: "string"}
                    ],
            root: "DisponibilidadPresupuestal",
            record: "DisponibilidadPresupuestal",
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
                        {name: "dependencia", type: "string"},
                        {name: "secuenciaFuncional", type: "string"},
                        {name: "tarea", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "importe", type: "number"}
                    ],
            root: "DisponibilidadPresupuestalDetalle",
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
                    {name: "dependencia", type: "string"},
                    {name: "secuenciaFuncional", type: "string"},
                    {name: "tarea", type: "string"},
                    {name: "cadenaGasto", type: "string"},
                    {name: "importe", type: "number"}
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
                        {text: 'UNIDAD', datafield: 'unidad', filtertype: 'checkedlist', width: '10%', align: 'center'},
                        {text: 'DEPENDENCIA', datafield: 'dependencia', filtertype: 'checkedlist', width: '10%', align: 'center'},
                        {text: 'SECUENCIA', datafield: 'secuenciaFuncional', filtertype: 'checkedlist', width: '20%', align: 'center'},
                        {text: 'TAREA', datafield: 'tarea', filtertype: 'checkedlist', width: '20%', align: 'center'},
                        {text: 'CADENA', datafield: 'cadenaGasto', filtertype: 'checkedlist', width: '30%', align: 'center', aggregates: [{'<b>Totales : </b>':
                                            function () {
                                                return  "";
                                            }}]},
                        {text: 'IMPORTE', dataField: 'importe', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
                    ]
                });
            }
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (rowdata['estado'] === "ANULADO") {
                return "RowAnulado";
            }
            if (datafield === "codigo") {
                return "RowBold";
            }
            if (datafield === "importe") {
                return "RowBlue";
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
                    if (unidadOperativa !== '*   ') {
                        mode = 'I';
                        $('#div_GrillaRegistro').jqxGrid('clear');
                        $('#txt_Oficio').val('La Oficina de Presupuesto del Ejército, en base al pedido del              , mediante         , solicita la Asignación Presupuestal para               ');
                        $('#txt_Concepto').val('');
                        $('#cbo_TipoInforme').jqxDropDownList('setContent', 'Seleccione');
                        $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_VentanaPrincipal').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Seleccione una Unidad Operativa valida!!',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }
                });
                //export to excel
                exportButton.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'DisponiblidadPresupuestal');
                });
                reporteButton.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 350, rowdetailshidden: true},
            columns: [
                {text: 'TIPO', dataField: 'tipo', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'NUMERO', dataField: 'numero', width: '4%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'UU/OO', dataField: 'unidad', width: '8%', align: 'center', cellclassname: cellclass},
                
                {text: 'DOC. GESTION', dataField: 'oficio', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'REQUERIMIENTO', dataField: 'concepto', width: '30%', align: 'center', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'importe', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FECHA', dataField: 'fecha', columntype: 'datetimeinput', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'FECHA PROCESO', dataField: 'fechaAprobacion', columntype: 'datetimeinput', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'NOTA SIPE', dataField: 'nota', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'NRO SIAF', dataField: 'SIAF', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'CERRADO', dataField: 'cerrado', width: '4%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FECHA CIERRE', dataField: 'fechaCierre', columntype: 'datetimeinput', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL 
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 110, autoOpenPopup: false, mode: 'popup'});
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
            var msg = "";
            if (codigo === null || codigo === '')
                msg = "Debe Selecciona un Registro";
            if (estado === 'ANULADO')
                msg = "Debe Selecciona un Registro que no se encuentre ANULADO";
            if (unidadOperativa === '*   ')
                msg = "Seleccione una Unidad Operativa valida!!";
            if (msg === "") {
                switch ($.trim($(opcion).text())) {
                    case "Editar":
                        mode = 'U';
                        fn_EditarCab();
                        break;
                    case "Anular":
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
                                        fn_GrabarDatos();
                                    }
                                },
                                cancelar: function () {
                                }
                            }
                        });
                        break;
                    case "Cerrar":
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
                                        fn_GrabarDatos();
                                    }
                                },
                                cancelar: function () {
                                }
                            }
                        });
                        break;
                    case "Enviar a Nota":
                        if (autorizacion === 'true') {
                            $.confirm({
                                theme: 'material',
                                title: 'AVISO DEL SISTEMA',
                                content: '¿Desea Enviar a Nota Modificatoria?',
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
                                            fn_GrabarDatos();
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
                        break;
                    default:
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'No puede realizar este Tipo de Operación, Registro Anulado',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                        break;
                }
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
                    $("#cbo_ResolucionCargo").jqxDropDownList('clear');
                    $("#cbo_DependenciaCargo").jqxDropDownList('clear');
                    $("#cbo_SecuenciaFuncionalCargo").jqxDropDownList('clear');
                    $("#cbo_TareaCargo").jqxDropDownList('clear');
                    $("#cbo_CadenaGastoCargo").jqxDropDownList('clear');
                    $("#cbo_UnidadAbono").jqxDropDownList('clear');
                    $("#cbo_DependenciaAbono").jqxDropDownList('clear');
                    $("#cbo_SecuenciaFuncionalAbono").jqxDropDownList('clear');
                    $("#cbo_TareaAbono").jqxDropDownList('clear');
                    $("#cbo_CadenaGastoAbono").jqxDropDownList('clear');
                    $('#div_Importe').val(0);
                    $("#cbo_ResolucionCargo").jqxDropDownList({disabled: false});
                    $("#cbo_DependenciaCargo").jqxDropDownList({disabled: false});
                    $("#cbo_SecuenciaFuncionalCargo").jqxDropDownList({disabled: false});
                    $("#cbo_TareaCargo").jqxDropDownList({disabled: false});
                    $("#cbo_CadenaGastoCargo").jqxDropDownList({disabled: false});
                    fn_cargarComboAjax("#cbo_ResolucionCargo", {mode: 'informeResolucionCargo', periodo: periodo, presupuesto: presupuesto, unidadOperativa: '0003'});
                    $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaDetalle').jqxWindow('open');
                });
                editButtonDet.click(function (event) {
                    modeDetalle = 'U';
                    if (indiceDetalle >= 0) {
                        var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                        $("#cbo_ResolucionCargo").jqxDropDownList('clear');
                        $("#cbo_ResolucionCargo").jqxDropDownList({disabled: true});
                        $("#cbo_ResolucionCargo").jqxDropDownList('setContent', dataRecord.resolucionCargo);
                        $("#cbo_DependenciaCargo").jqxDropDownList('clear');
                        $("#cbo_DependenciaCargo").jqxDropDownList({disabled: true});
                        $("#cbo_DependenciaCargo").jqxDropDownList('setContent', dataRecord.dependenciaCargo);
                        $("#cbo_SecuenciaFuncionalCargo").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncionalCargo").jqxDropDownList({disabled: true});
                        $("#cbo_SecuenciaFuncionalCargo").jqxDropDownList('setContent', dataRecord.secuenciaFuncionalCargo);
                        $("#cbo_TareaCargo").jqxDropDownList('clear');
                        $("#cbo_TareaCargo").jqxDropDownList({disabled: true});
                        $("#cbo_TareaCargo").jqxDropDownList('setContent', dataRecord.tareaCargo);
                        $("#cbo_CadenaGastoCargo").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.cadenaGastoCargo, ':'));
                        $("#cbo_CadenaGastoCargo").jqxDropDownList({disabled: true});
                        $("#cbo_UnidadAbono").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.unidadAbono, ':'));
                        $("#cbo_DependenciaAbono").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.dependenciaAbono, ':'));
                        $('#div_Importe').val(dataRecord.importe);
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
            },
            columns: [
                {text: 'UU/OO', datafield: 'unidadAbono', width: '12%', align: 'center'},
                {text: 'DEPENDENCIA', datafield: 'dependenciaAbono', width: '10%', align: 'center'},
                {text: 'SECUENCIA', datafield: 'secuenciaFuncionalAbono', width: '20%', align: 'center'},
                {text: 'TAREA', datafield: 'tareaAbono', width: '20%', align: 'center'},
                {text: 'CADENA', datafield: 'cadenaGastoAbono', width: '25%', align: 'center'},
                {text: 'IMPORTE', dataField: 'importe', width: '13%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
            fn_cargarComboAjax("#cbo_CadenaGastoCargo", {mode: 'informeCadenaGastoCargo', periodo: periodo, presupuesto: presupuesto, unidadOperativa: '0003',
                resolucion: fn_extraerDatos(dataRecord.resolucionCargo, ':'), dependencia: fn_extraerDatos(dataRecord.dependenciaCargo, ':'),
                secuenciaFuncional: fn_extraerDatos(dataRecord.secuenciaFuncionalCargo, ':'), tarea: fn_extraerDatos(dataRecord.tareaCargo, ':')});
        });
    });
    //Funcion de Refrescar o Actulizar los datos de la Grilla.
    function fn_EditarCab() {
        if (estado !== 'ANULADA') {
            mode = 'U';
            $.ajax({
                type: "GET",
                url: "../DisponibilidadPresupuestal",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, presupuesto: presupuesto, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 4) {
                        $('#cbo_TipoInforme').jqxDropDownList('selectItem', dato[0]);
                        $('#txt_Oficio').val(dato[1]);
                        $('#txt_Concepto').val(dato[2]);
                        var d = new Date(dato[3]);
                        d.setDate(d.getDate() + 1);
                        $('#txt_Fecha ').jqxDateTimeInput('setDate', d);
                        $('#div_GrillaRegistro').jqxGrid('clear');
                        $.ajax({
                            type: "GET",
                            url: "../DisponibilidadPresupuestal",
                            data: {mode: 'B', periodo: periodo, unidadOperativa: unidadOperativa, presupuesto: presupuesto, codigo: codigo},
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
                                    var row = {resolucionCargo: datos[1], dependenciaCargo: datos[2], secuenciaFuncionalCargo: datos[3], tareaCargo: datos[4], cadenaGastoCargo: datos[5],
                                        unidadAbono: datos[6], dependenciaAbono: datos[7], secuenciaFuncionalAbono: datos[8], tareaAbono: datos[9], cadenaGastoAbono: datos[10],
                                        importe: parseFloat(datos[11])};
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
    //FUNCION PARA ACTUALIZAR LOS DATOS DE LA NOTA MODIFICATORIA
    function fn_Refrescar() {
        $("#div_ContextMenu").remove();
        $("#div_RegistroDetalle").remove();
        $("#div_GrillaPrincipal").remove();
        $("#div_VentanaPrincipal").remove();
        $("#div_VentanaDetalle").remove();
        $("#div_Reporte").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "POST",
            url: "../DisponibilidadPresupuestal",
            data: {mode: "G", periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes},
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
            var alto = 650;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaPrincipal').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_Cancelar'),
                initContent: function () {
                    $("#cbo_TipoInforme").jqxDropDownList({animationType: 'fade', width: 350, height: 20});
                    $("#txt_Fecha").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                    $("#txt_Oficio").jqxInput({width: 670, height: 45, minLength: 1});
                    $("#txt_Concepto").jqxInput({width: 670, height: 45, minLength: 1});
                    $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').on('click', function (event) {
                        $('#frm_DisponibilidadPresupuestal').jqxValidator('validate');
                    });
                    $('#frm_DisponibilidadPresupuestal').jqxValidator({
                        rules: [
                            {input: '#txt_Oficio', message: 'Ingrese Oficio de la Disponibilidad Presupuestal!', action: 'keyup, blur', rule: 'required'},
                            {input: '#txt_Concepto', message: 'Ingrese Concepto de la Disponibilidad Presupuestal!', action: 'keyup, blur', rule: 'required'}
                        ]
                    });
                    $('#frm_DisponibilidadPresupuestal').jqxValidator({
                        onSuccess: function () {
                            fn_GrabarDatos();
                        }
                    });
                }
            });
            //Inicia los Valores de Ventana del Detalle
            ancho = 750;
            alto = 300;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaDetalle').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CancelarDetalle'),
                initContent: function () {
                    $("#cbo_ResolucionCargo").jqxDropDownList({animationType: 'fade', width: 590, height: 20});
                    $('#cbo_ResolucionCargo').on('change', function () {
                        $("#cbo_DependenciaCargo").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncionalCargo").jqxDropDownList('clear');
                        $("#cbo_TareaCargo").jqxDropDownList('clear');
                        $("#cbo_CadenaGastoCargo").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_DependenciaCargo", {mode: 'informeDependenciaCargo', periodo: periodo, presupuesto: presupuesto, unidadOperativa: '0003',
                            resolucion: $("#cbo_ResolucionCargo").val()});
                    });
                    $("#cbo_DependenciaCargo").jqxDropDownList({animationType: 'fade', width: 590, height: 20});
                    $('#cbo_DependenciaCargo').on('change', function () {
                        $("#cbo_SecuenciaFuncionalCargo").jqxDropDownList('clear');
                        $("#cbo_TareaCargo").jqxDropDownList('clear');
                        $("#cbo_CadenaGastoCargo").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_SecuenciaFuncionalCargo", {mode: 'informeSecuenciaFuncionalCargo', periodo: periodo, presupuesto: presupuesto, unidadOperativa: '0003',
                            resolucion: $("#cbo_ResolucionCargo").val(), dependencia: $("#cbo_DependenciaCargo").val()});
                    });
                    $("#cbo_SecuenciaFuncionalCargo").jqxDropDownList({animationType: 'fade', width: 590, height: 20});
                    $('#cbo_SecuenciaFuncionalCargo').on('change', function () {
                        $("#cbo_TareaCargo").jqxDropDownList('clear');
                        $("#cbo_CadenaGastoCargo").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_TareaCargo", {mode: 'informeTareaCargo', periodo: periodo, presupuesto: presupuesto, unidadOperativa: '0003',
                            resolucion: $("#cbo_ResolucionCargo").val(), dependencia: $("#cbo_DependenciaCargo").val(), secuenciaFuncional: $("#cbo_SecuenciaFuncionalCargo").val()});
                    });
                    $("#cbo_TareaCargo").jqxDropDownList({animationType: 'fade', width: 590, height: 20});
                    $('#cbo_TareaCargo').on('change', function () {
                        $("#cbo_CadenaGastoCargo").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_CadenaGastoCargo", {mode: 'informeCadenaGastoCargo', periodo: periodo, presupuesto: presupuesto, unidadOperativa: '0003',
                            resolucion: $("#cbo_ResolucionCargo").val(), dependencia: $("#cbo_DependenciaCargo").val(), secuenciaFuncional: $("#cbo_SecuenciaFuncionalCargo").val(),
                            tarea: $("#cbo_TareaCargo").val()});
                    });
                    $("#cbo_CadenaGastoCargo").jqxDropDownList({animationType: 'fade', width: 590, height: 20});
                    $('#cbo_CadenaGastoCargo').on('change', function () {
                        $("#cbo_UnidadAbono").jqxDropDownList('clear');
                        $("#cbo_DependenciaAbono").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncionalAbono").jqxDropDownList('clear');
                        $("#cbo_TareaAbono").jqxDropDownList('clear');
                        $("#cbo_CadenaGastoAbono").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_UnidadAbono", {mode: 'unidadOperativa', periodo: periodo, unidadOperativa: '0003'});
                    });
                    $("#cbo_UnidadAbono").jqxDropDownList({animationType: 'fade', width: 590, height: 20});
                    $('#cbo_UnidadAbono').on('change', function () {
                        $("#cbo_DependenciaAbono").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncionalAbono").jqxDropDownList('clear');
                        $("#cbo_TareaAbono").jqxDropDownList('clear');
                        $("#cbo_CadenaGastoAbono").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_DependenciaAbono", {mode: 'dependencia', unidadOperativa: $("#cbo_UnidadAbono").val()});
                    });
                    $("#cbo_DependenciaAbono").jqxDropDownList({animationType: 'fade', width: 590, height: 20});
                    $('#cbo_DependenciaAbono').on('change', function () {
                        $("#cbo_SecuenciaFuncionalAbono").jqxDropDownList('clear');
                        $("#cbo_TareaAbono").jqxDropDownList('clear');
                        $("#cbo_CadenaGastoAbono").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_SecuenciaFuncionalAbono", {mode: 'secuenciaFuncionalNotaModificatoria', periodo: periodo, tipo: 'C', presupuesto: presupuesto,
                            resolucion: $("#cbo_ResolucionCargo").val(), tipoCalendario: '2', tipoNota: '002'});
                    });
                    $("#cbo_SecuenciaFuncionalAbono").jqxDropDownList({animationType: 'fade', width: 590, height: 20});
                    $('#cbo_SecuenciaFuncionalAbono').on('change', function () {
                        $("#cbo_TareaAbono").jqxDropDownList('clear');
                        $("#cbo_CadenaGastoAbono").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_TareaAbono", {mode: 'tareaNotaModificatoria', periodo: periodo, tipo: 'C', presupuesto: presupuesto,
                            resolucion: $("#cbo_ResolucionCargo").val(), tipoCalendario: '2', tipoNota: '002', secuenciaFuncional: $("#cbo_SecuenciaFuncionalAbono").val()});
                    });
                    $("#cbo_TareaAbono").jqxDropDownList({animationType: 'fade', width: 590, height: 20});
                    $('#cbo_TareaAbono').on('change', function () {
                        $("#cbo_CadenaGastoAbono").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_CadenaGastoAbono", {mode: 'cadenaGastoNotaModificatoria', periodo: periodo, tipo: 'C', presupuesto: presupuesto,
                            resolucion: $("#cbo_ResolucionCargo").val(), tipoCalendario: '2', tipoNota: '002', secuenciaFuncional: $("#cbo_SecuenciaFuncionalAbono").val(), tarea: $("#cbo_TareaAbono").val()});
                    });
                    $("#cbo_CadenaGastoAbono").jqxDropDownList({animationType: 'fade', width: 590, height: 20});
                    $("#div_Importe").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                    $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarDetalle').on('click', function (event) {
                        var resolucionCargo = $("#cbo_ResolucionCargo").jqxDropDownList('getSelectedItem');
                        var dependenciaCargo = $("#cbo_DependenciaCargo").jqxDropDownList('getSelectedItem');
                        var secuenciaFuncionalCargo = $("#cbo_SecuenciaFuncionalCargo").jqxDropDownList('getSelectedItem');
                        var tareaCargo = $("#cbo_TareaCargo").jqxDropDownList('getSelectedItem');
                        var cadenaGastoCargo = $("#cbo_CadenaGastoCargo").jqxDropDownList('getSelectedItem');
                        var unidadAbono = $("#cbo_UnidadAbono").jqxDropDownList('getSelectedItem');
                        var dependenciaAbono = $("#cbo_DependenciaAbono").jqxDropDownList('getSelectedItem');
                        var secuenciaFuncionalAbono = $("#cbo_SecuenciaFuncionalAbono").jqxDropDownList('getSelectedItem');
                        var tareaAbono = $("#cbo_TareaAbono").jqxDropDownList('getSelectedItem');
                        var cadenaGastoAbono = $("#cbo_CadenaGastoAbono").jqxDropDownList('getSelectedItem');
                        var importe = parseFloat($("#div_Importe").jqxNumberInput('decimal'));
                        var msg = "";
                        if (modeDetalle === 'I') {
                            if (resolucionCargo === null)
                                msg += "Debe Seleccionar la Resolución Cargo.<br>";
                            if (dependenciaCargo === null)
                                msg += "Debe Seleccionar la Dependencia Cargo.<br>";
                            if (secuenciaFuncionalCargo === null)
                                msg += "Debe Seleccionar la Sec. Funcional Cargo.<br>";
                            if (tareaCargo === null)
                                msg += "Debe Seleccionar la Tarea Cargo.<br>";
                            if (cadenaGastoCargo === null)
                                msg += "Debe Seleccionar la Cadena Gasto Cargo.<br>";
                        }
                        if (unidadAbono === null)
                            msg += "Debe Seleccionar la Unidad Abono.<br>";
                        if (dependenciaAbono === null)
                            msg += "Debe Seleccionar la Dependencia Abono.<br>";
                        if (secuenciaFuncionalAbono === null)
                            msg += "Debe Seleccionar la Sec. Funcional Abono.<br>";
                        if (tareaAbono === null)
                            msg += "Debe Seleccionar la Tarea Abono.<br>";
                        if (cadenaGastoAbono === null)
                            msg += "Debe Seleccionar la Cadena de Gasto Abono.<br>";
                        if (msg === "")
                            msg += fn_validaSaldo();
                        if (modeDetalle === 'I') {
                            resolucionCargo = fn_extraerDatos(resolucionCargo.label, 'S/.');
                            dependenciaCargo = fn_extraerDatos(dependenciaCargo.label, 'S/.');
                            secuenciaFuncionalCargo = fn_extraerDatos(secuenciaFuncionalCargo.label, 'S/.');
                            tareaCargo = fn_extraerDatos(tareaCargo.label, 'S/.');
                            cadenaGastoCargo = fn_extraerDatos(cadenaGastoCargo.label, 'S/.');
                        }
                        unidadAbono = unidadAbono.label;
                        dependenciaAbono = dependenciaAbono.label;
                        secuenciaFuncionalAbono = secuenciaFuncionalAbono.label;
                        tareaAbono = tareaAbono.label;
                        cadenaGastoAbono = cadenaGastoAbono.label;
                        if (msg === "" && modeDetalle === 'I') {
                            msg += fn_validaDetalle(resolucionCargo, dependenciaCargo, secuenciaFuncionalCargo, tareaCargo, cadenaGastoCargo,
                                    unidadAbono, dependenciaAbono, secuenciaFuncionalAbono, tareaAbono, cadenaGastoAbono);
                        }
                        if (msg === "" && modeDetalle === 'U') {
                            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                            msg += fn_validaDetalle(dataRecord.resolucionCargo, dataRecord.dependenciaCargo, dataRecord.secuenciaFuncionalCargo, dataRecord.tareaCargo, dataRecord.cadenaGastoCargo,
                                    unidadAbono, dependenciaAbono, secuenciaFuncionalAbono, tareaAbono, cadenaGastoAbono);
                        }
                        if (msg === "") {
                            if (modeDetalle === 'I') {
                                var row = {resolucionCargo: resolucionCargo, dependenciaCargo: dependenciaCargo, secuenciaFuncionalCargo: secuenciaFuncionalCargo, tareaCargo: tareaCargo, cadenaGastoCargo: cadenaGastoCargo,
                                    unidadAbono: unidadAbono, dependenciaAbono: dependenciaAbono, secuenciaFuncionalAbono: secuenciaFuncionalAbono, tareaAbono: tareaAbono,
                                    cadenaGastoAbono: cadenaGastoAbono, importe: importe};
                                $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
                            }
                            if (modeDetalle === 'U') {
                                var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                                var row = {resolucionCargo: dataRecord.resolucionCargo, dependenciaCargo: dataRecord.dependenciaCargo, secuenciaFuncionalCargo: dataRecord.secuenciaFuncionalCargo, tareaCargo: dataRecord.tareaCargo,
                                    cadenaGastoCargo: dataRecord.cadenaGastoCargo, unidadAbono: unidadAbono, dependenciaAbono: dependenciaAbono,
                                    secuenciaFuncionalAbono: secuenciaFuncionalAbono, tareaAbono: tareaAbono, cadenaGastoAbono: cadenaGastoAbono, importe: importe};
                                var rowID = $('#div_GrillaRegistro').jqxGrid('getrowid', indiceDetalle);
                                $('#div_GrillaRegistro').jqxGrid('updaterow', rowID, row);
                            }
                            modeDetalle = null;
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
            alto = 110;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_Reporte').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_CerrarImprimir'),
                initContent: function () {
                    $("#div_EJE0028").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0028').on('checked', function (event) {
                        reporte = 'EJE0028';
                    });
                    $("#div_EJE0029").jqxRadioButton({width: 200, height: 20});
                    $('#div_EJE0029').on('checked', function (event) {
                        reporte = 'EJE0029';
                    });
                    $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                    $('#btn_Imprimir').on('click', function (event) {
                        var msg = "";
                        switch (reporte) {
                            case "EJE0028":
                                if (codigo === null)
                                    msg += "Seleccione el Informe de Disponibilidad.<br>";
                                break;
                            case "EJE0029":
                                break;
                            default:
                                msg += "Debe selecciona una opción.<br>";
                                break;
                        }
                        if (msg === "") {
                            var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&presupuesto=' + presupuesto + "&codigo=" + codigo;
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
    //FUNCION PARA GRABAR LOS DATOS DE LA NOTA MODIFICATORIA
    function fn_GrabarDatos() {
        var msg = "";
        var tipo = $("#cbo_TipoInforme").val();
        var fecha = $('#txt_Fecha').val();
        var oficio = $("#txt_Oficio").val();
        var concepto = $("#txt_Concepto").val();
        var lista = new Array();
        var result;
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            result = row.uid + "---" + fn_extraerDatos(row.resolucionCargo, ':') + "---" + fn_extraerDatos(row.dependenciaCargo, ':') + "---" + fn_extraerDatos(row.secuenciaFuncionalCargo, ':') + "---" +
                    fn_extraerDatos(row.tareaCargo, ':') + "---" + fn_extraerDatos(row.cadenaGastoCargo, ':') + "---" + fn_extraerDatos(row.unidadAbono, ':') + "---" + fn_extraerDatos(row.dependenciaAbono, ':') + "---" +
                    fn_extraerDatos(row.secuenciaFuncionalAbono, ':') + "---" + fn_extraerDatos(row.tareaAbono, ':') + "---" + fn_extraerDatos(row.cadenaGastoAbono, ':') + "---" + row.importe;
            lista.push(result);
        }
        if (lista.length === 0 && (mode === 'I' || mode === 'U'))
            msg += "Ingrese el Detalle de la Nota Modificatoria.<br>";
        if (msg === "") {
            $.ajax({
                type: "POST",
                url: "../IduDisponibilidadPresupuestal",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes, codigo: codigo,
                    tipo: tipo, fecha: fecha, oficio: oficio, concepto: concepto, lista: JSON.stringify(lista)},
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
    //FUNCION PARA VALIDAR EL SALDO DE LA NOTA MODIFICATORIA
    function fn_validaSaldo() {
        var cadena = $("#cbo_CadenaGastoCargo").val();
        if (cadena.length !== 0) {
            var saldo = $("#cbo_CadenaGastoCargo").jqxDropDownList('getSelectedItem');
            saldo = saldo.label;
            var importe = parseFloat($("#div_Importe").jqxNumberInput('decimal'));
            var monto = "";
            var len = 0;
            len = saldo.length;
            var pos = saldo.indexOf('S/.');
            monto = saldo.substring(pos + 3, len);
            monto = fn_reemplazarTodo(monto, ',', '');
            monto = parseFloat(monto);
            var resolucion = $("#cbo_ResolucionCargo").jqxDropDownList('getSelectedItem');
            var dependencia = $("#cbo_DependenciaCargo").jqxDropDownList('getSelectedItem');
            var secuenciaFuncional = $("#cbo_SecuenciaFuncionalCargo").jqxDropDownList('getSelectedItem');
            var tarea = $("#cbo_TareaCargo").jqxDropDownList('getSelectedItem');
            var cadenaGasto = $("#cbo_CadenaGastoCargo").jqxDropDownList('getSelectedItem');
            if (modeDetalle === 'I') {
                resolucion = fn_extraerDatos(resolucion.label, 'S/.');
                dependencia = fn_extraerDatos(dependencia.label, 'S/.');
                secuenciaFuncional = fn_extraerDatos(secuenciaFuncional.label, 'S/.');
                tarea = fn_extraerDatos(tarea.label, 'S/.');
                cadenaGasto = fn_extraerDatos(cadenaGasto.label, 'S/.');
            }
            if (modeDetalle === 'U') {
                var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                resolucion = fn_extraerDatos(dataRecord.resolucionCargo, ':');
                dependencia = fn_extraerDatos(dataRecord.dependenciaCargo, ':');
                secuenciaFuncional = fn_extraerDatos(dataRecord.secuenciaFuncionalCargo, ':');
                tarea = fn_extraerDatos(dataRecord.tareaCargo, ':');
                cadenaGasto = fn_extraerDatos(dataRecord.cadenaGastoCargo, ':');
            }
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            var totalCadena = 0.0;
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (i !== indiceDetalle && row.resolucionCargo.trim() === resolucion.trim() && row.dependenciaCargo.trim() === dependencia.trim() && row.secuenciaFuncionalCargo.trim() === secuenciaFuncional.trim() &&
                        row.tareaCargo.trim() === tarea.trim() && row.cadenaGastoCargo.trim() === cadenaGasto.trim()) {
                    totalCadena += parseFloat(row.importe);
                }
            }
            totalCadena += importe;
            if (parseInt(importe) > parseInt(monto)) {
                return "No puede ingresar un importe superior a S/. " + monto + ". Revise!!!";
            } else if (parseInt(importe) === parseInt('0')) {
                return "No puede ingresar un importe Cero. Revise!!!";
            } else if (parseInt(importe) < 0) {
                return "Debe ingresar un importe superior a Cero!!!";
            } else if (parseInt(totalCadena) > parseInt(monto)) {
                return "Cadena de Gasto Cargo sin Saldo S/. " + monto + ". Revise!!!";
            }
        } else {
            return "Seleccione la Cadena de Gasto";
        }
        return "";
    }
    //FUNCION PARA VALIDAR QUE NO SE REPITAN LOS REGISTROS DEL DETALLE
    function fn_validaDetalle(resolucionCargo, dependenciaCargo, secuenciaFuncionalCargo, tareaCargo, cadenaGastoCargo, unidadAbono, dependenciaAbono, secuenciaFuncionalAbono, tareaAbono, cadenaGastoAbono) {
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        if (modeDetalle === 'I') {
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (row.resolucionCargo.trim() === resolucionCargo.trim() && row.dependenciaCargo.trim() === dependenciaCargo.trim() && row.secuenciaFuncionalCargo.trim() === secuenciaFuncionalCargo.trim() && row.tareaCargo.trim() === tareaCargo.trim() &&
                        row.cadenaGastoCargo.trim() === cadenaGastoCargo.trim() && row.unidadAbono.trim() === unidadAbono.trim() && row.dependenciaAbono.trim() === dependenciaAbono.trim() &&
                        row.secuenciaFuncionalAbono.trim() === secuenciaFuncionalAbono.trim() && row.tareaAbono.trim() === tareaAbono.trim() && row.cadenaGastoAbono.trim() === cadenaGastoAbono.trim()) {
                    return "Los Datos que desea registrar ya existen, Revise!!";
                }
            }
        }
        if (modeDetalle === 'U') {
            if (rows[indiceDetalle].resolucionCargo.trim() === resolucionCargo.trim() && rows[indiceDetalle].dependenciaCargo.trim() === dependenciaCargo.trim() && rows[indiceDetalle].secuenciaFuncionalCargo.trim() === secuenciaFuncionalCargo.trim() &&
                    rows[indiceDetalle].tareaCargo.trim() === tareaCargo.trim() && rows[indiceDetalle].cadenaGastoCargo.trim() === cadenaGastoCargo.trim() && rows[indiceDetalle].unidadAbono.trim() === unidadAbono.trim() &&
                    rows[indiceDetalle].dependenciaAbono.trim() === dependenciaAbono.trim() && rows[indiceDetalle].secuenciaFuncionalAbono.trim() === secuenciaFuncionalAbono.trim() && rows[indiceDetalle].tareaAbono.trim() === tareaAbono.trim() && rows[indiceDetalle].cadenaGastoAbono.trim() === cadenaGastoAbono.trim()) {
                return "";
            } else {
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (i !== indiceDetalle && row.resolucionCargo.trim() === resolucionCargo.trim() && row.dependenciaCargo.trim() === dependenciaCargo.trim() && row.secuenciaFuncionalCargo.trim() === secuenciaFuncionalCargo.trim() && row.tareaCargo.trim() === tareaCargo.trim() &&
                            row.cadenaGastoCargo.trim() === cadenaGastoCargo.trim() && row.unidadAbono.trim() === unidadAbono.trim() && row.dependenciaAbono.trim() === dependenciaAbono.trim() && row.secuenciaFuncionalAbono.trim() === secuenciaFuncionalAbono.trim() &&
                            row.tareaAbono.trim() === tareaAbono.trim() && row.cadenaGastoAbono.trim() === cadenaGastoAbono.trim()) {
                        return "Los Datos que desea registrar ya existen, Revise!!";
                    }
                }
            }
        }
        return "";
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">REGISTRO DE DISPONIBILIDAD PRESUPUESTAL</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_DisponibilidadPresupuestal" name="frm_DisponibilidadPresupuestal" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Fecha : </td>
                    <td><div id="txt_Fecha"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Tipo : </td>
                    <td>
                        <select id="cbo_TipoInforme" name="cbo_TipoInforme">                            
                            <option value="IDP">INFORME DE DISPONIBILIDAD PRESUPUESTAL</option>
                            <option value="CDP">CONSTANCIA DE DISPONIBILIDAD PRESUPUESTAL</option>
                        </select>
                    </td>
                </tr>                
                <tr>
                    <td class="inputlabel">Documento : </td>
                    <td><textarea id="txt_Oficio" name="txt_Oficio"/></textarea></td>
                </tr>
                <tr>
                    <td class="inputlabel">Requerimiento : </td>
                    <td><textarea id="txt_Concepto" name="txt_Concepto"/></textarea></td>
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
            <div id="div_GrillaRegistro"></div>
            <div style="display: none" id="div_VentanaDetalle">
                <div>
                    <span style="float: left">DETALLE DE LA DISPONIBILIDAD PRESUPUESTAL</span>
                </div>
                <div style="overflow: hidden">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="inputlabel">Resolución Cargo : </td>
                            <td>
                                <select id="cbo_ResolucionCargo" name="cbo_ResolucionCargo">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Dependencia Cargo : </td>
                            <td>
                                <select id="cbo_DependenciaCargo" name="cbo_DependenciaCargo">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Sec. Func. Cargo : </td>
                            <td>
                                <select id="cbo_SecuenciaFuncionalCargo" name="cbo_SecuenciaFuncionalCargo">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Tarea Cargo : </td>
                            <td>
                                <select id="cbo_TareaCargo" name="cbo_TareaCargo">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Cad. Gasto Cargo : </td>
                            <td>
                                <select id="cbo_CadenaGastoCargo" name="cbo_CadenaGastoCargo">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">U/O Abono : </td>
                            <td>
                                <select id="cbo_UnidadAbono" name="cbo_UnidadAbono">
                                    <option value="0">Seleccione</option>       
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Dependencia Abono : </td>
                            <td>
                                <select id="cbo_DependenciaAbono" name="cbo_DependenciaAbono">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Sec. Func. Abono : </td>
                            <td>
                                <select id="cbo_SecuenciaFuncionalAbono" name="cbo_SecuenciaFuncionalAbono">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Tarea Abono : </td>
                            <td>
                                <select id="cbo_TareaAbono" name="cbo_TareaAbono">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Cad. Gasto Abono : </td>
                            <td>
                                <select id="cbo_CadenaGastoAbono" name="cbo_CadenaGastoAbono">
                                    <option value="0">Seleccione</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Importe S/. : </td>
                            <td><div id="div_Importe"></div></td>
                        </tr>
                        <tr>
                            <td class="Summit" colspan="2" >
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
        <div id='div_EJE0028'>Informes de Disponibilidad Presupuestal</div>
        <div id='div_EJE0029'>Resumen Informes de Disponibilidad</div>
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li style="font-weight: bold;">Editar</li>
        <li style="font-weight: bold;">Anular</li>
        <li style="font-weight: bold; color: brown;">Cerrar</li>
        <li type='separator'></li>
        <li style="font-weight: bold;color: blue;">Enviar a Nota</li>
    </ul>
</div>