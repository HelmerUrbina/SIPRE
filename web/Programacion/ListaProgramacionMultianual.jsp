<%-- 
    Document   : ListaProgramacionMultianual
    Created on : 04/03/2017, 06:57:29 PM
    Author     : H-URBINA-M
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    if (autorizacion === 'false') {
        window.location = "../Error/PaginaMantenimiento.jsp";
    }
    var codigo = null;
    var mode = null;
    var tipo = null;
    var indiceDetalle = -1;
    var valor = periodo;
    var msg = "";
    var lista = new Array();
    <c:forEach var="c" items="${objProgramacionMultianual}">
    var result = {codigo: '${c.codigo}', descripcion: '${c.tarea}',
        importeA: '${c.enero}', detalleA: '${c.abril}', saldoA: '${c.enero-c.abril}',
        importeB: '${c.febrero}', detalleB: '${c.mayo}', saldoB: '${c.febrero-c.mayo}',
        importeC: '${c.marzo}', detalleC: '${c.junio}', saldoC: '${c.marzo-c.junio}',
        estado: '${c.estado}', tipoCalendario: '${c.tipoCalendario}', categoriaPresupuestal: '${c.categoriaPresupuestal}',
        actividad: '${c.actividad}', producto: '${c.producto}', ubigeo: '${c.distrito}'};
    lista.push(result);
    </c:forEach>
    var detalle = new Array();
    <c:forEach var="d" items="${objProgramacionMultianualDetalle}">
    var result = {codigo: '${d.codigo}', cadenaGasto: '${d.cadenaGasto}', dependencia: '${d.dependencia}',
        datoA: '${d.enero}', datoB: '${d.febrero}', datoC: '${d.marzo}', importe: '${d.importe}'};
    detalle.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA NUEVO DETALLE
        var sourceNuevo = {
            datatype: "array",
            datafields:
                    [
                        {name: "cadenaGasto", type: "string"},
                        {name: "dependencia", type: "string"},
                        {name: "datoA", type: "number"},
                        {name: "datoB", type: "number"},
                        {name: "datoC", type: "number"},
                        {name: "importe", type: "number"}
                    ],
            pagesize: 50,
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            },
            updaterow: function (rowid, rowdata, commit) {
                commit(true);
            }
        };
        var dataNuevo = new $.jqx.dataAdapter(sourceNuevo);
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA CABECERA
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigo', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'importeA', type: "number"},
                        {name: 'detalleA', type: "number"},
                        {name: 'saldoA', type: "number"},
                        {name: 'importeB', type: "number"},
                        {name: 'detalleB', type: "number"},
                        {name: 'saldoB', type: "number"},
                        {name: 'importeC', type: "number"},
                        {name: 'detalleC', type: "number"},
                        {name: 'saldoC', type: "number"},
                        {name: 'estado', type: "string"},
                        {name: 'tipoCalendario', type: "string"},
                        {name: 'categoriaPresupuestal', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'actividad', type: "string"},
                        {name: 'ubigeo', type: "string"}
                    ],
            root: "ProgramacionMultianual",
            record: "ProgramacionMultianual",
            id: 'codigo'
        };
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA DETALLE 
        var sourceDet = {
            localdata: detalle,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "dependencia", type: "string"},
                        {name: "datoA", type: "number"},
                        {name: "datoB", type: "number"},
                        {name: "datoC", type: "number"},
                        {name: "importe", type: "number"}
                    ],
            root: "ProgramacionMultianualDetalle",
            record: "ProgramacionMultianualDetalle",
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
                    {name: "cadenaGasto", type: "string"},
                    {name: "dependencia", type: "string"},
                    {name: "datoA", type: "number"},
                    {name: "datoB", type: "number"},
                    {name: "datoC", type: "number"},
                    {name: "importe", type: "number"}
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
                    showstatusbar: true,
                    statusbarheight: 25,
                    columns: [
                        {text: 'DEPENDENCIA', datafield: 'dependencia', width: '20%', filtertype: 'checkedlist'},
                        {text: 'CADENA DE GASTO', datafield: 'cadenaGasto', width: '35%', filtertype: 'checkedlist', aggregates: [{'<b>Totales : </b>':
                                            function () {
                                                return  "";
                                            }}]},
                        {text: parseInt(periodo), dataField: 'datoA', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: parseInt(periodo) + 1, dataField: 'datoB', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: parseInt(periodo) + 2, dataField: 'datoC', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'IMPORTE', dataField: 'importe', width: '15%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
                    ]
                });
            }
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "importeA" || datafield === "importeB" || datafield === "importeC" || datafield === "importe") {
                return "RowBold";
            }
            if (datafield === "detalleA" || datafield === "detalleB" || datafield === "detalleC") {
                return "RowBlue";
            }
            if (datafield === "saldoA" || datafield === "saldoB" || datafield === "saldoC") {
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
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonReporte = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonExportar);
                container.append(ButtonReporte);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonReporte.jqxButton({width: 30, height: 22});
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reporte"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    if (presupuesto === '1' && autorizacion !== 'true') {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Usuario no Autorizado para realizar este Tipo de Operación',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    } else {
                        mode = 'I';
                        codigo = 0;
                        $("#cbo_Tarea").jqxDropDownList({disabled: false});
                        $("#cbo_Tarea").jqxDropDownList('setContent', 'Seleccione');
                        $("#cbo_Departamento").jqxDropDownList('setContent', 'Seleccione');
                        $("#cbo_Provincia").jqxDropDownList('clear');
                        $("#cbo_Distrito").jqxDropDownList('clear');
                        if (presupuesto === '6')
                            fn_verSaldoUtilidadEnte();
                        $("#div_Importe").val(0);
                        $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_VentanaPrincipal').jqxWindow('open');
                    }
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ProgramacionPresupuestal');
                });
                ButtonReporte.click(function (event) {
                    /* $.alert({
                     theme: 'material',
                     title: 'AVISO DEL SISTEMA',
                     content: 'La impresión se encuentra deshabilitada, coordine con el Dpto de Programación.',
                     animation: 'zoom',
                     closeAnimation: 'zoom',
                     type: 'red',
                     typeAnimated: true
                     });*/
                    var url = '../Reportes?reporte=PROG0005&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto;
                    window.open(url, '_blank');
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 350, rowdetailshidden: true},
            columns: [
                {text: 'TAREA', dataField: 'descripcion', filtertype: 'checkedlist', width: '31%', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'PROGRA. ' + valor, dataField: 'importeA', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DETALLE ' + valor, dataField: 'detalleA', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO ' + valor, dataField: 'saldoA', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PROGRA. ' + ++valor, dataField: 'importeB', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DETALLE ' + valor, dataField: 'detalleB', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO ' + valor, dataField: 'saldoB', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PROGRA. ' + ++valor, dataField: 'importeC', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DETALLE ' + valor, dataField: 'detalleC', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO ' + valor, dataField: 'saldoC', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'CALENDARIO', dataField: 'tipoCalendario', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'CAT. PPTAL', dataField: 'categoriaPresupuestal', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'PRODUCTO', dataField: 'producto', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ACTIVIDAD', dataField: 'actividad', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'UBIGEO', dataField: 'ubigeo', filtertype: 'checkedlist', width: '10%', align: 'center', cellsAlign: 'left', cellclassname: cellclass}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 155, autoOpenPopup: false, mode: 'popup'});
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
            } else {
                if ($.trim($(opcion).text()) === "Editar") {
                    if (autorizacion !== 'true' && presupuesto === '1') {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Usuario no Autorizado para realizar este Tipo de Operación',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    } else if (presupuesto === '6' && codigo === '0001' && autorizacion !== 'true') {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Usuario no Autorizado para realizar este Tipo de Operación',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    } else {
                        mode = 'U';
                        fn_EditarRegistro();
                    }
                } else if ($.trim($(opcion).text()) === "Eliminar") {
                    if (autorizacion !== 'true' && presupuesto === '1') {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Usuario no Autorizado para realizar este Tipo de Operación',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    } else {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Eliminar este registro?',
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
                    }
                } else if ($.trim($(opcion).text()) === "Ingresar Detalle") {
                    mode = "C";
                    fn_cargarDetalle();
                } else if ($.trim($(opcion).text()) === "Metas Fisicas") {
                    fn_verCantidadesFisicas();
                } else if ($.trim($(opcion).text()) === "Cerrar") {
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: '¿Desea Cerrar esta Tarea?',
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
                                    mode = 'F';
                                    fn_GrabarDatos();
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                } else if ($.trim($(opcion).text()) === "Activar") {
                    if (autorizacion === 'true') {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Activar esta Tarea?',
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
                                        mode = 'A';
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
                }
            }
        });
        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
            $("#cbo_Tarea").jqxDropDownList('selectItem', codigo.substr(0, 4));
        });
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: 350,
            source: dataNuevo,
            pageable: true,
            columnsresize: true,
            showtoolbar: true,
            showstatusbar: true,
            showaggregates: true,
            altrows: false,
            editable: false,
            statusbarheight: 20,
            autoheight: false,
            autorowheight: false,
            sortable: true,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var containerRegistro = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevoRegistro = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var ButtonEditarRegistro = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/update42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var ButtonEliminaRegistro = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/delete42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                containerRegistro.append(ButtonNuevoRegistro);
                containerRegistro.append(ButtonEditarRegistro);
                containerRegistro.append(ButtonEliminaRegistro);
                toolbar.append(containerRegistro);
                ButtonNuevoRegistro.jqxButton({width: 30, height: 22});
                ButtonNuevoRegistro.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonEditarRegistro.jqxButton({width: 30, height: 22});
                ButtonEditarRegistro.jqxTooltip({position: 'bottom', content: "Editar Registro"});
                ButtonEliminaRegistro.jqxButton({width: 30, height: 22});
                ButtonEliminaRegistro.jqxTooltip({position: 'bottom', content: "Eliminar Registro"});
                ButtonNuevoRegistro.click(function (event) {
                    fn_cargarComboAjax("#cbo_Dependencia", {mode: 'dependenciaFuerzaOperativa', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa});
                    tipo = 'I';
                    $("#cbo_Dependencia").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_CadenaGasto").jqxDropDownList('setContent', 'Seleccione');
                    $('#div_ImporteRegistroA').val(0);
                    $('#div_ImporteRegistroB').val(0);
                    $('#div_ImporteRegistroC').val(0);
                    $('#div_RegistroDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_RegistroDetalle').jqxWindow('open');
                });
                // add new row.
                ButtonEditarRegistro.click(function (event) {
                    fn_cargarComboAjax("#cbo_Dependencia", {mode: 'dependenciaFuerzaOperativa', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa});
                    tipo = 'U';
                    if (indiceDetalle >= 0) {
                        var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                        $("#cbo_Dependencia").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.dependencia, ':'));
                        $("#cbo_CadenaGasto").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.cadenaGasto, ':'));
                        $('#div_ImporteRegistroA').val(dataRecord.datoA);
                        $('#div_ImporteRegistroB').val(dataRecord.datoB);
                        $('#div_ImporteRegistroC').val(dataRecord.datoC);
                        $('#div_RegistroDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_RegistroDetalle').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'DEBE SELECCIONAR UN REGISTRO',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }
                });
                // delete selected row.
                ButtonEliminaRegistro.click(function (event) {
                    tipo = 'D';
                    if (indiceDetalle >= 0) {
                        var rowid = $("#div_GrillaRegistro").jqxGrid('getrowid', indiceDetalle);
                        $("#div_GrillaRegistro").jqxGrid('deleterow', rowid);
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'DEBE SELECCIONAR UN REGISTRO',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }
                });
            },
            columns: [
                {text: 'DEPENDENCIA', datafield: 'dependencia', width: '15%', align: 'center'},
                {text: 'CADENA DE GASTO', datafield: 'cadenaGasto', width: '30%', align: 'center', aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: (periodo), dataField: 'datoA', width: '13%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: parseInt(periodo) + 1, dataField: 'datoB', width: '13%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: parseInt(periodo) + 2, dataField: 'datoC', width: '13%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'importe', width: '16%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
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
                var ancho = 550;
                var alto = 240;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_Tarea").jqxDropDownList({width: 430, height: 20, dropDownWidth: 550, promptText: "Seleccione"});
                        $("#cbo_Departamento").jqxDropDownList({width: 200, height: 20, promptText: "Seleccione"});
                        $('#cbo_Departamento').on('select', function (event) {
                            $("#cbo_Provincia").jqxDropDownList('clear');
                            $("#cbo_Distrito").jqxDropDownList('clear');
                            fn_cargarComboAjax("#cbo_Provincia", {mode: 'provincia', departamento: $("#cbo_Departamento").val()});
                        });
                        $("#cbo_Provincia").jqxDropDownList({width: 250, height: 20, promptText: "Seleccione"});
                        $('#cbo_Provincia').on('select', function (event) {
                            $("#cbo_Distrito").jqxDropDownList('clear');
                            fn_cargarComboAjax("#cbo_Distrito", {mode: 'distrito', departamento: $("#cbo_Departamento").val(), provincia: $("#cbo_Provincia").val()});
                        });
                        $("#cbo_Distrito").jqxDropDownList({width: 300, height: 20, promptText: "Seleccione"});
                        $("#div_Incremento").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 2, decimalDigits: 0, symbolPosition: 'right', symbol: '%', spinButtons: true});
                        $('#div_Incremento').on('textchanged', function (event) {
                            fn_verIncremento();
                        });
                        $("#div_ImporteA").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_ImporteA').on('textchanged', function (event) {
                            fn_verIncremento();
                        });
                        $("#div_ImporteB").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $("#div_ImporteC").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            fn_GrabarDatos();
                        });
                    }
                });
                //INICIA VALORES PARA LA VENTA SECUNDARIA
                ancho = 750;
                alto = 505;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaDetalle').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarDetalle'),
                    initContent: function () {
                        $("#txt_TareaDetalle").jqxInput({placeHolder: 'TAREA PRESUPUESTAL', width: 550, height: 20, disabled: true});
                        $("#div_ImporteDetalleA").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_ImporteDetalleB").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_ImporteDetalleC").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').on('click', function () {
                            fn_GrabarDatosDetalle();
                        });
                    }
                });
                //INICIA VALORES PARA LA VENTANA REGISTRO DETALLE
                ancho = 550;
                alto = 175;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_RegistroDetalle').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarRegistro'),
                    initContent: function () {
                        $("#cbo_CadenaGasto").jqxDropDownList({width: 400, height: 20, dropDownWidth: 500, promptText: "Seleccione"});
                        $("#cbo_Dependencia").jqxDropDownList({width: 400, height: 20, dropDownWidth: 500, promptText: "Seleccione"});
                        $('#cbo_Dependencia').on('select', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_ImporteRegistroA").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_ImporteRegistroA').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_ImporteRegistroB").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_ImporteRegistroB').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_ImporteRegistroC").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_ImporteRegistroC').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_SaldoRegistroA").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoRegistroB").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoRegistroC").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $('#btn_CancelarRegistro').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRegistro').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRegistro').on('click', function () {
                            var cadenaGasto = $("#cbo_CadenaGasto").jqxDropDownList('getSelectedItem');
                            var dependencia = $("#cbo_Dependencia").jqxDropDownList('getSelectedItem');
                            var importeA = parseFloat($("#div_ImporteRegistroA").val());
                            var importeB = parseFloat($("#div_ImporteRegistroB").val());
                            var importeC = parseFloat($("#div_ImporteRegistroC").val());
                            var total = importeA + importeB + importeC;
                            var msg = "";
                            if (msg === "")
                                msg = fn_validaSaldos();
                            if (msg === "")
                                msg = fn_validaDetalle(dependencia.label, cadenaGasto.label);
                            if (msg === "") {
                                var row = {cadenaGasto: cadenaGasto.label, dependencia: dependencia.label, datoA: importeA, datoB: importeB, datoC: importeC, importe: parseFloat(total)};
                                if (tipo === 'I') {
                                    $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
                                }
                                if (tipo === 'U') {
                                    var rowindex = $("#div_GrillaRegistro").jqxGrid('getselectedrowindex');
                                    var rowID = $('#div_GrillaRegistro').jqxGrid('getrowid', rowindex);
                                    $('#div_GrillaRegistro').jqxGrid('updaterow', rowID, row);
                                }
                                tipo = null;
                                $("#div_RegistroDetalle").jqxWindow('hide');
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
                //INICIA VALORES PARA REGISTRAR LAS METAS FISICAS
                ancho = 500;
                alto = 175;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaMetaFisica').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarMetaFisica'),
                    initContent: function () {
                        $("#txt_TareaMetaFisica").jqxInput({placeHolder: 'TAREA PRESUPUESTAL', width: 400, height: 20, disabled: true});
                        $("#txt_UnidadMedidaMetaFisica").jqxInput({placeHolder: 'UNIDAD DE MEDIDA', width: 400, height: 20, disabled: true});
                        $("#div_MetaFisicaA").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 7, decimalDigits: 0});
                        $("#div_MetaFisicaB").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 7, decimalDigits: 0});
                        $("#div_MetaFisicaC").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 7, decimalDigits: 0});
                        $('#btn_CancelarMetaFisica').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarMetaFisica').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarMetaFisica').on('click', function () {
                            mode = 'M';
                            fn_GrabarMetaFisica();
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
            $("#cbo_Tarea").jqxDropDownList('clear');
            fn_cargarComboAjax("#cbo_Tarea", {mode: 'tarea'});
        });
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_VentanaMetaFisica").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../ProgramacionMultianual",
                data: {mode: "G", periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../ProgramacionMultianual",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 9) {
                        fn_cargarComboAjax("#cbo_Distrito", {mode: 'distrito', departamento: dato[0], provincia: dato[1]});
                        $("#cbo_Departamento").jqxDropDownList('selectItem', dato[0]);
                        $("#cbo_Provincia").jqxDropDownList('addItem', {label: dato[7], value: dato[1]});
                        $("#cbo_Provincia").jqxDropDownList('selectItem', dato[1]);
                        $("#cbo_Tarea").jqxDropDownList({disabled: true});
                        $("#div_Incremento").val(parseFloat(dato[3]));
                        $("#div_ImporteA").val(parseFloat(dato[4]));
                        $("#div_ImporteB").val(parseFloat(dato[5]));
                        $("#div_ImporteC").val(parseFloat(dato[6]));
                        $("#cbo_Distrito").jqxDropDownList('addItem', {label: dato[8], value: dato[2]});
                        $("#cbo_Distrito").jqxDropDownList('selectItem', dato[2]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var tarea = $("#cbo_Tarea").val();
            var departamento = $("#cbo_Departamento").val();
            var provincia = $("#cbo_Provincia").val();
            var distrito = $("#cbo_Distrito").val();
            var incremento = $("#div_Incremento").val();
            var importeA = $("#div_ImporteA").val();
            var importeB = $("#div_ImporteB").val();
            var importeC = $("#div_ImporteC").val();
            $.ajax({
                type: "POST",
                url: "../IduProgramacionMultianual",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo, tarea: tarea,
                    departamento: departamento, provincia: provincia, distrito: distrito, incremento: incremento,
                    importeA: importeA, importeB: importeB, importeC: importeC},
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
        }
        $("#cbo_Departamento").jqxDropDownList('clear');
        fn_cargarComboAjax("#cbo_Departamento", {mode: 'departamento'});
        //FUNCION PARA CARGAR VENTANA DETALLE PARA EDITAR REGISTRO
        function fn_cargarDetalle() {
            $('#div_GrillaRegistro').jqxGrid('clear');
            $.ajax({
                type: "GET",
                url: "../ProgramacionMultianual",
                data: {mode: 'B', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (detalle) {
                    detalle = detalle.replace("[", "");
                    var fila = detalle.split("[");
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
                        var row = {cadenaGasto: datos[0], dependencia: datos[1], datoA: parseFloat(datos[3]), datoB: parseFloat(datos[4]), datoC: parseFloat(datos[5]), importe: parseFloat(datos[2])};
                        rows.push(row);
                    }
                    if (rows.length > 0) {
                        $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
                    }
                    $.ajax({
                        type: "GET",
                        url: "../ProgramacionMultianual",
                        data: {mode: 'A', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                        success: function (data) {
                            var dato = data.split("+++");
                            if (dato.length === 4) {
                                $("#txt_TareaDetalle").val(dato[0]);
                                $("#div_ImporteDetalleA").val(parseFloat(dato[1]));
                                $("#div_ImporteDetalleB").val(parseFloat(dato[2]));
                                $("#div_ImporteDetalleC").val(parseFloat(dato[3]));
                            }
                        }
                    });
                }
            });
            fn_cargarComboAjax("#cbo_CadenaGasto", {mode: 'cadenaGastoTarea', periodo: periodo, tarea: codigo.substr(0, 4)});
            $('#div_VentanaDetalle').jqxWindow({isModal: true});
            $('#div_VentanaDetalle').jqxWindow('open');
        }
        //FUNCION QUE PERMITE GRABAR LOS DETALLES 
        function fn_GrabarDatosDetalle() {
            var msg = "";
            var lista = new Array();
            var result;
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                result = fn_extraerDatos(row.cadenaGasto, ':') + "---" + fn_extraerDatos(row.dependencia, ':') + "---" + row.datoA + "---" + row.datoB + "---" + row.datoC;
                lista.push(result);
            }
            $.ajax({
                type: "POST",
                url: "../IduProgramacionMultianualDetalle",
                data: {periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo,
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
                                        $('#div_VentanaDetalle').jqxWindow('close');
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
        //FUNCION PARA VER LOS SALDOS
        function fn_verSaldos() {
            var totalA = parseFloat($("#div_ImporteDetalleA").val());
            var totalB = parseFloat($("#div_ImporteDetalleB").val());
            var totalC = parseFloat($("#div_ImporteDetalleC").val());
            var montoA, montoB, montoC;
            var saldoA, saldoB, saldoC;
            montoA = montoB = montoC = saldoA = saldoB = saldoC = 0;
            var importeA = parseFloat($("#div_ImporteRegistroA").val());
            var importeB = parseFloat($("#div_ImporteRegistroB").val());
            var importeC = parseFloat($("#div_ImporteRegistroC").val());
            if ((presupuesto === '1' && codigo.substr(0, 4) === '0013') && (unidadOperativa === '0802' || unidadOperativa === '0804' || unidadOperativa === '0806' || unidadOperativa === '0809'
                    || unidadOperativa === '0810' || unidadOperativa === '0812' || unidadOperativa === '0820' || unidadOperativa === '0822' || unidadOperativa === '0824'
                    || unidadOperativa === '0826' || unidadOperativa === '0828' || unidadOperativa === '0834' || unidadOperativa === '0838' || unidadOperativa === '0840'
                    || unidadOperativa === '0842' || unidadOperativa === '0843' || unidadOperativa === '0844' || unidadOperativa === '0845' || unidadOperativa === '0846'
                    || unidadOperativa === '0848' || unidadOperativa === '0854' || unidadOperativa === '0858' || unidadOperativa === '0860' || unidadOperativa === '0865'
                    || unidadOperativa === '0870' || unidadOperativa === '0871' || unidadOperativa === '0872' || unidadOperativa === '0875' || unidadOperativa === '0878'
                    || unidadOperativa === '6998' || unidadOperativa === '0832')) {
                $.ajax({
                    type: "GET",
                    url: "../ProgramacionMultianual",
                    data: {mode: 'S', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, dependencia: $("#cbo_Dependencia").val(), codigo: codigo},
                    success: function (data) {
                        var dato = data.split("+++");
                        if (dato.length === 3) {
                            totalA = (parseFloat(dato[0]));
                            totalB = (parseFloat(dato[1]));
                            totalC = (parseFloat(dato[2]));
                        }
                        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
                        for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                            if (row.dependencia.trim().substr(0, 3) === $("#cbo_Dependencia").val().trim()) {
                                montoA = montoA + row.datoA;
                                montoB = montoB + row.datoB;
                                montoC = montoC + row.datoC;
                            }
                        }
                        if (tipo === 'U') {
                            var rowindex = $("#div_GrillaRegistro").jqxGrid('getselectedrowindex');
                            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', rowindex);
                            saldoA = totalA - montoA - importeA + dataRecord.datoA;
                            saldoB = totalB - montoB - importeB + dataRecord.datoB;
                            saldoC = totalC - montoC - importeC + dataRecord.datoC;
                        } else {
                            saldoA = totalA - montoA - importeA;
                            saldoB = totalB - montoB - importeB;
                            saldoC = totalC - montoC - importeC;
                        }
                        $("#div_SaldoRegistroA").val(saldoA);
                        $("#div_SaldoRegistroB").val(saldoB);
                        $("#div_SaldoRegistroC").val(saldoC);
                    }
                });
            } else {
                var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    montoA = montoA + row.datoA;
                    montoB = montoB + row.datoB;
                    montoC = montoC + row.datoC;
                }
                if (tipo === 'U') {
                    var rowindex = $("#div_GrillaRegistro").jqxGrid('getselectedrowindex');
                    var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', rowindex);
                    saldoA = totalA - montoA - importeA + dataRecord.datoA;
                    saldoB = totalB - montoB - importeB + dataRecord.datoB;
                    saldoC = totalC - montoC - importeC + dataRecord.datoC;
                } else {
                    saldoA = totalA - montoA - importeA;
                    saldoB = totalB - montoB - importeB;
                    saldoC = totalC - montoC - importeC;
                }
                $("#div_SaldoRegistroA").val(saldoA);
                $("#div_SaldoRegistroB").val(saldoB);
                $("#div_SaldoRegistroC").val(saldoC);
            }
        }
        //FUNCION QUE VALIDA LOS SALDOS
        function fn_validaSaldos() {
            var saldoA = parseFloat($("#div_SaldoRegistroA").val());
            var saldoB = parseFloat($("#div_SaldoRegistroB").val());
            var saldoC = parseFloat($("#div_SaldoRegistroC").val());
            if (saldoA < 0 || saldoB < 0 || saldoC < 0) {
                return "SALDO MENOR A LO SOLICITADO. REVISE!!!";
            } else {
                return "";
            }
        }
        //FUNCION PARA VER LOS SALDO DE LA UTILIDAD DEL ENTE GENERADOR
        function fn_verSaldoUtilidadEnte() {
            $.ajax({
                type: "GET",
                url: "../ProgramacionMultianual",
                data: {mode: 'E', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 3) {
                        $("#div_SaldoA").html("SALDO : " + dato[0]);
                        $("#div_SaldoB").html("SALDO : " + dato[1]);
                        $("#div_SaldoC").html("SALDO : " + dato[2]);
                    }
                }
            });
        }
        //FUNCION PARA ACTUALIZAR LAS CANTIDADES FISICAS
        function fn_verCantidadesFisicas() {
            $.ajax({
                type: "GET",
                url: "../ProgramacionMultianual",
                data: {mode: 'C', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 5) {
                        $("#txt_TareaMetaFisica").val(dato[0]);
                        $("#txt_UnidadMedidaMetaFisica").val(dato[1]);
                        $("#div_MetaFisicaA").val(parseFloat(dato[2]));
                        $("#div_MetaFisicaB").val(parseFloat(dato[3]));
                        $("#div_MetaFisicaC").val(parseFloat(dato[4]));
                    }
                }
            });
            $('#div_VentanaMetaFisica').jqxWindow({isModal: true});
            $('#div_VentanaMetaFisica').jqxWindow('open');
        }
        function fn_GrabarMetaFisica() {
            var importeA = $("#div_MetaFisicaA").val();
            var importeB = $("#div_MetaFisicaB").val();
            var importeC = $("#div_MetaFisicaC").val();
            $.ajax({
                type: "POST",
                url: "../IduProgramacionMultianual",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo,
                    importeA: importeA, importeB: importeB, importeC: importeC},
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
    });
    //FUNCION PARA VALIDAR QUE NO SE REPITAN LOS REGISTROS DEL DETALLE
    function fn_validaDetalle(dependencia, cadenaGasto) {
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        if (tipo === 'I') {
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (row.dependencia.trim() === dependencia && row.cadenaGasto.trim() === cadenaGasto) {
                    return "Los Datos que desea registrar ya existen, Revise!!";
                }
            }
        }
        if (tipo === 'U') {
            if (rows[indiceDetalle].dependencia.trim() === dependencia && rows[indiceDetalle].cadenaGasto.trim() === cadenaGasto) {
                return "";
            } else {
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (i !== indiceDetalle && row.dependencia.trim() === dependencia && row.cadenaGasto.trim() === cadenaGasto) {
                        return "Los Datos que desea registrar ya existen, Revise!!";
                    }
                }
            }
        }
        return "";
    }
    function fn_verIncremento() {
        var incremento = $("#div_Incremento").val();
        var importeA = $("#div_ImporteA").val();
        $("#div_ImporteB").val(parseFloat(importeA + importeA * incremento / 100));
        var importeB = $("#div_ImporteB").val();
        $("#div_ImporteC").val(parseFloat(importeB + importeB * incremento / 100));
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">PROGRAMACIÓN MULTIANUAL DE GASTOS</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_ProgramacionMultianual" name="frm_ProgramacionMultianual" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Tarea : </td>
                    <td colspan="3">
                        <select id="cbo_Tarea" name="cbo_Tarea">
                            <option value="0">Seleccione</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Departamento : </td>
                    <td colspan="2">
                        <select id="cbo_Departamento" name="cbo_Departamento">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Provincia : </td>
                    <td colspan="2">
                        <select id="cbo_Provincia" name="cbo_Provincia">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Distrito : </td>
                    <td colspan="2">
                        <select id="cbo_Distrito" name="cbo_Distrito">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>  
                <tr>
                    <td class="inputlabel">Incremento: </td>
                    <td><div id="div_Incremento"></div></td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="inputlabel">Importe ${objBnProgramacionMultianual.periodo} : </td>
                    <td><div id="div_ImporteA"></div></td> 
                    <td class="bluelabel"><div id="div_SaldoA"></div></td> 
                </tr>  
                <tr>
                    <td class="inputlabel">Importe ${objBnProgramacionMultianual.periodo+1} : </td>
                    <td><div id="div_ImporteB"></div></td> 
                    <td class="bluelabel"><div id="div_SaldoB"></div></td> 
                </tr>
                <tr>
                    <td class="inputlabel">Importe ${objBnProgramacionMultianual.periodo+2} : </td>
                    <td><div id="div_ImporteC"></div></td>
                    <td class="bluelabel"><div id="div_SaldoC"></div></td>
                </tr>
                <tr>
                    <td class="Summit" colspan="3">
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
<div id="div_VentanaDetalle" style="display: none">
    <div>
        <span style="float: left">DETALLE DE PROGRAMACIÓN MULTIANUAL DE GASTOS</span>
    </div>
    <div style="overflow: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="inputlabel">Tarea : </td>
                <td><input type="text" id="txt_TareaDetalle" name="txt_TareaDetalle" style="text-transform: uppercase;"/></td>
            </tr>
            <tr>
                <td class="inputlabel">Importe ${objBnProgramacionMultianual.periodo} S/.: </td>
                <td><div id="div_ImporteDetalleA"></div></td> 
            </tr>
            <tr>
                <td class="inputlabel">Importe ${objBnProgramacionMultianual.periodo+1} S/.: </td>
                <td><div id="div_ImporteDetalleB"></div></td> 
            </tr> 
            <tr>
                <td class="inputlabel">Importe ${objBnProgramacionMultianual.periodo+2} S/.: </td>
                <td><div id="div_ImporteDetalleC"></div></td> 
            </tr> 
            <tr>
                <td colspan="2"><div id="div_GrillaRegistro"> </div></td>
            </tr>
            <tr>
                <td class="Summit" colspan="2">
                    <div>
                        <input type="button" id="btn_GuardarDetalle"  value="Guardar" style="margin-right: 20px"/>
                        <input type="button" id="btn_CancelarDetalle" value="Cancelar" style="margin-right: 20px"/>
                    </div>
                </td>
            </tr>
        </table> 
        <div style="display: none" id="div_RegistroDetalle">
            <div>
                <span style="float: left">REGISTRO DE LA PROGRAMACIÓN MULTIANUAL DE GASTOS</span>
            </div>
            <div style="overflow: hidden">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="inputlabel">Dependencia : </td>
                        <td colspan="3">
                            <select id="cbo_Dependencia" name="cbo_Dependencia">
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
                        <td class="inputlabel">Importe ${objBnProgramacionMultianual.periodo} S/. : </td>
                        <td><div id="div_ImporteRegistroA"></div></td>  
                        <td class="inputlabel">Saldo S/. : </td>
                        <td><div id="div_SaldoRegistroA"></div></td> 
                    </tr> 
                    <tr>
                        <td class="inputlabel">Importe ${objBnProgramacionMultianual.periodo+1} S/. : </td>
                        <td><div id="div_ImporteRegistroB"></div></td> 
                        <td class="inputlabel">Saldo S/. : </td>
                        <td><div id="div_SaldoRegistroB"></div></td> 
                    </tr> 
                    <tr>
                        <td class="inputlabel">Importe ${objBnProgramacionMultianual.periodo+2} S/. : </td>
                        <td><div id="div_ImporteRegistroC"></div></td>    
                        <td class="inputlabel">Saldo S/. : </td>
                        <td><div id="div_SaldoRegistroC"></div></td> 
                    </tr>
                    <tr>
                        <td class="Summit" colspan="4">
                            <div>
                                <input type="button" id="btn_GuardarRegistro" value="Guardar" style="margin-right: 20px" />
                                <input type="button" id="btn_CancelarRegistro"  value="Cancelar" style="margin-right: 20px"/>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>
<div id='div_VentanaMetaFisica' style='display: none;'>
    <div>
        <span style="float: left">PROGRAMACIÓN MULTIANUAL DE GASTOS - METAS FISICAS</span>
    </div>
    <div style="overflow: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
            <tr>
                <td class="inputlabel">Tarea : </td>
                <td><input type="text" id="txt_TareaMetaFisica" name="txt_TareaMetaFisica" style="text-transform: uppercase;"/></td>
            </tr> 
            <tr>
                <td class="inputlabel">Uni. Med. : </td>
                <td><input type="text" id="txt_UnidadMedidaMetaFisica" name="txt_UnidadMedidaMetaFisica" style="text-transform: uppercase;"/></td>
            </tr> 
            <tr>
                <td class="inputlabel">Meta ${objBnProgramacionMultianual.periodo} : </td>
                <td><div id="div_MetaFisicaA"></div></td> 
            </tr> 
            <tr>
                <td class="inputlabel">Meta ${objBnProgramacionMultianual.periodo+1} : </td>
                <td><div id="div_MetaFisicaB"></div></td>
            </tr> 
            <tr>
                <td class="inputlabel">Meta ${objBnProgramacionMultianual.periodo+2} : </td>
                <td><div id="div_MetaFisicaC"></div></td> 
            </tr>
            <tr>
                <td class="Summit" colspan="4">
                    <div>
                        <input type="button" id="btn_GuardarMetaFisica" value="Guardar" style="margin-right: 20px" />
                        <input type="button" id="btn_CancelarMetaFisica"  value="Cancelar" style="margin-right: 20px"/>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Eliminar</li>
        <li>Ingresar Detalle</li>
        <li>Metas Fisicas</li>
        <li>Cerrar</li>
        <li type='separator'></li>
        <li style="font-weight: bold;">Activar</li>
    </ul>
</div>
