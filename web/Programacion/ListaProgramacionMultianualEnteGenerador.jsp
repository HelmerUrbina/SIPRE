<%-- 
    Document   : ListaProgramacionMultianualEnteGenerador
    Created on : 09/03/2017, 10:50:46 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var codigo = null;
    var mode = null;
    var estado = '';
    var msg = "";
    var lista = new Array();
    <c:forEach var="c" items="${objProgramacionMultianualEnteGenerador}">
    var result = {codigo: '${c.codigo}', descripcion: '${c.descripcion}', cadenaIngreso: '${c.cadenaIngreso}', estado: '${c.estado}'};
    lista.push(result);
    </c:forEach>
    var detalle = new Array();
    <c:forEach var="d" items="${objProgramacionMultianualEnteGeneradorDetalle}">
    var result = {codigo: '${d.codigo}', periodo: '${d.periodo}', recaudacion: '${d.enero}', igv: '${d.febrero}', costo: '${d.marzo}',
        utilidadNeta: '${d.abril}', utilidadUO: '${d.mayo}', utilidadUE: '${d.junio}'};
    detalle.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA CABECERA
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigo', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'cadenaIngreso', type: "string"},
                        {name: 'estado', type: "number"}
                    ],
            root: "ProgramacionMultianualEnteGenerador",
            record: "ProgramacionMultianualEnteGenerador",
            id: 'codigo'
        };
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA DETALLE 
        var sourceDet = {
            localdata: detalle,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "periodo", type: "string"},
                        {name: 'recaudacion', type: "number"},
                        {name: 'igv', type: "number"},
                        {name: 'costo', type: "number"},
                        {name: 'utilidadNeta', type: "number"},
                        {name: 'utilidadUO', type: "number"},
                        {name: 'utilidadUE', type: "number"}
                    ],
            root: "ProgramacionMultianualEnteGeneradorDetalle",
            record: "ProgramacionMultianualEnteGeneradorDetalle",
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
                    {name: "periodo", type: "string"},
                    {name: 'recaudacion', type: "number"},
                    {name: 'igv', type: "number"},
                    {name: 'costo', type: "number"},
                    {name: 'utilidadNeta', type: "number"},
                    {name: 'utilidadUO', type: "number"},
                    {name: 'utilidadUE', type: "number"}
                ],
                id: 'codigo',
                localdata: ordersbyid
            };
            var nestedGridAdapter = new $.jqx.dataAdapter(sourceNested);
            if (grid !== null) {
                grid.jqxGrid({
                    source: nestedGridAdapter,
                    width: '98%',
                    height: 200,
                    pageable: true,
                    filterable: true,
                    autoshowfiltericon: true,
                    columnsresize: true,
                    showaggregates: true,
                    showfilterrow: true,
                    showstatusbar: true,
                    statusbarheight: 25,
                    columns: [
                        {text: 'PERIODO', dataField: 'periodo', width: '15%', filtertype: 'checkedlist', align: 'center', cellsAlign: 'center', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                            function () {
                                                return  "";
                                            }}]},
                        {text: 'RECAUDACIÓN', dataField: 'recaudacion', width: '20%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'IGV', dataField: 'igv', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'COSTO', dataField: 'costo', width: '15%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'SALDO NETO', dataField: 'utilidadNeta', width: '20%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'SALDO UO', dataField: 'utilidadUO', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'SALDO UE', dataField: 'utilidadUE', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
                    ]
                });
            }
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (rowdata['estado'] === "ANULADO") {
                return "RowAnulado";
            }
            if (datafield === "recaudacion" || datafield === "utilidadNeta") {
                return "RowBold";
            }
            if (datafield === "costo") {
                return "RowBrown";
            }
            if (datafield === "utilidadUO") {
                return "RowBlue";
            }
            if (datafield === "utilidadUE") {
                return "RowGreen";
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
            showstatusbar: false,
            showtoolbar: true,
            pagesize: 50,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonReporte = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonCerrar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/parametro42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonExportar);
                container.append(ButtonReporte);
                container.append(ButtonCerrar);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonReporte.jqxButton({width: 30, height: 22});
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reporte"});
                ButtonCerrar.jqxButton({width: 30, height: 22});
                ButtonCerrar.jqxTooltip({position: 'bottom', content: "Cerrar"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    codigo = 0;
                    $("#cbo_CadenaIngreso").jqxDropDownList('setContent', 'Seleccione');
                    $('#txt_Descripcion').val('');
                    $("#div_RecaudacionA").val(0);
                    $("#div_RecaudacionB").val(0);
                    $("#div_RecaudacionC").val(0);
                    $("#div_CostoA").val(0);
                    $("#div_CostoB").val(0);
                    $("#div_CostoC").val(0);
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ProgramacionMultianualEnteGenerador');
                });
                ButtonReporte.click(function () {
                    var url = '../Reportes?reporte=PROG0006&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto;
                    window.open(url, '_blank');
                });
                ButtonCerrar.click(function (event) {
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: '¿Desea Cerrar los Registros?',
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
                                    mode = 'C';
                                    fn_GrabarDatos();
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });

                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 220, rowdetailshidden: true},
            columns: [
                {text: 'ACTIVIDAD GENERADORA', dataField: 'descripcion', filtertype: 'checkedlist', width: '50%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'CADENA INGRESO', dataField: 'cadenaIngreso', filtertype: 'checkedlist', width: '35%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 215, height: 80, autoOpenPopup: false, mode: 'popup'});
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
            if (estado === 'ANULADO') {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'SELECCIONE UN REGISTRO QUE NO ESTE ANULADO',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            } else {
                if ($.trim($(opcion).text()) === "Editar") {
                    mode = 'U';
                    fn_EditarRegistro();
                } else if ($.trim($(opcion).text()) === "Anular") {
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: '¿Desea Anular este registro?',
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
                } else if ($.trim($(opcion).text()) === "Activar") {
                    if (autorizacion === 'true') {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Activar este registro?',
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
            }
        });
        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
            estado = row['estado'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 230;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_CadenaIngreso").jqxDropDownList({width: 400, height: 20});
                        $("#txt_Descripcion").jqxInput({placeHolder: 'ACTIVIDAD GENERADORA', width: 400, height: 20});
                        $("#div_RecaudacionA").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionA').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionB").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionB').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionC").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionC').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoA").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoA').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoB").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoB').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoC").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoC').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_SaldoA").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoB").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoC").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_TotalRecaudacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_TotalCosto").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_TotalSaldo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function (event) {
                            $('#frm_EnteGenerador').jqxValidator('validate');
                        });
                        $('#frm_EnteGenerador').jqxValidator({
                            rules: [
                                {input: '#txt_Descripcion', message: 'Ingrese la Actividad Generadora!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_EnteGenerador').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatos();
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
        fn_cargarComboAjax("#cbo_CadenaIngreso", {mode: 'cadenaIngresoEstimacionUnidad', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa});
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../ProgramacionMultianualEnteGenerador",
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
                url: "../ProgramacionMultianualEnteGenerador",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 8) {
                        $("#cbo_CadenaIngreso").jqxDropDownList('selectItem', dato[0]);
                        $('#txt_Descripcion').val(dato[1]);
                        $("#div_RecaudacionA").val(dato[2]);
                        $("#div_RecaudacionB").val(dato[3]);
                        $("#div_RecaudacionC").val(dato[4]);
                        $("#div_CostoA").val(dato[5]);
                        $("#div_CostoB").val(dato[6]);
                        $("#div_CostoC").val(dato[7]);
                        fn_verSaldos();
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var cadenaIngreso = $("#cbo_CadenaIngreso").val();
            var descripcion = $("#txt_Descripcion").val();
            var enero = $("#div_RecaudacionA").val();
            var febrero = $("#div_RecaudacionB").val();
            var marzo = $("#div_RecaudacionC").val();
            var costoEnero = $("#div_CostoA").val();
            var costoFebrero = $("#div_CostoB").val();
            var costoMarzo = $("#div_CostoC").val();
            var costoTotal = $("#div_TotalCosto").val();
            var costoRecaudacion = $("#div_TotalRecaudacion").val();
            if (costoTotal > costoRecaudacion && (mode === 'I' || mode === 'U')) {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'LOS COSTOS NO DEBEN SUPERAR LA RECAUDACIÓN',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            } else {
                $.ajax({
                    type: "POST",
                    url: "../IduProgramacionMultianualEnteGenerador",
                    data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo,
                        cadenaIngreso: cadenaIngreso, descripcion: descripcion, enero: enero, febrero: febrero, marzo: marzo,
                        costoEnero: costoEnero, costoFebrero: costoFebrero, costoMarzo: costoMarzo},
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
        }
    });
    //FUNCION PARA VER LOS SALDOS 
    function fn_verSaldos() {
        $("#div_SaldoA").val(parseFloat($("#div_RecaudacionA").val()) - parseFloat($("#div_CostoA").val()));
        $("#div_SaldoB").val(parseFloat($("#div_RecaudacionB").val()) - parseFloat($("#div_CostoB").val()));
        $("#div_SaldoC").val(parseFloat($("#div_RecaudacionC").val()) - parseFloat($("#div_CostoC").val()));
        $("#div_TotalRecaudacion").val($("#div_RecaudacionA").val() + $("#div_RecaudacionB").val() + $("#div_RecaudacionC").val());
        $("#div_TotalCosto").val($("#div_CostoA").val() + $("#div_CostoB").val() + $("#div_CostoC").val());
        $("#div_TotalSaldo").val($("#div_SaldoA").val() + $("#div_SaldoB").val() + $("#div_SaldoC").val());
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">PROGRAMACIÓN MULTIANUAL DE INGRESOS</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_EnteGenerador" name="frm_EnteGenerador" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Cadena de Ingreso : </td>
                    <td colspan="3">
                        <select id="cbo_CadenaIngreso" name="cbo_CadenaIngreso">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Descripción : </td>
                    <td colspan="3"><input type="text" id="txt_Descripcion" name="txt_Descripcion" style="text-transform: uppercase;"/></td>
                </tr> 
                <tr>
                    <td colspan="4" class="TituloFocus">Detalle de la Recaudación</td>
                </tr> 
                <tr>
                    <td class="bluelabel" style="text-align: center">PERIODO</td>
                    <td class="bluelabel" style="text-align: center">RECAUDACIÓN</td>
                    <td class="bluelabel" style="text-align: center">COSTO OPERATIVO</td>
                    <td class="bluelabel" style="text-align: center">SALDO UTILIDAD</td>
                </tr>
                <tr>
                    <td class="inputlabel">${objBnProgramacionMultianualEnteGenerador.periodo} : </td>
                    <td><div id="div_RecaudacionA"></div></td>  
                    <td><div id="div_CostoA"></div></td>
                    <td><div id="div_SaldoA"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">${objBnProgramacionMultianualEnteGenerador.periodo+1} : </td>
                    <td><div id="div_RecaudacionB"></div></td>  
                    <td><div id="div_CostoB"></div></td>
                    <td><div id="div_SaldoB"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">${objBnProgramacionMultianualEnteGenerador.periodo+2} : </td>
                    <td><div id="div_RecaudacionC"></div></td>  
                    <td><div id="div_CostoC"></div></td>
                    <td><div id="div_SaldoC"></div></td>
                </tr>
                <tr>
                    <td class="bluelabel" style="text-align: center">Totales : </td>
                    <td><div id="div_TotalRecaudacion"></div></td>  
                    <td><div id="div_TotalCosto"></div></td>
                    <td><div id="div_TotalSaldo"></div></td>
                </tr>
                <tr>
                    <td class="Summit" colspan="4">
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
        <li>Editar</li>
        <li>Anular</li>
        <li type='separator'></li>
        <li style="font-weight: bold;">Activar</li>
    </ul>
</div>