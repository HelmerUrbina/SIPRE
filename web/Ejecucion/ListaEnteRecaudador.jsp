<%-- 
Document   : ListaEnteGenerador
Created on : 08/02/2017, 04:50:07 PM
Author     : H-URBINA-M
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var mes = $("#cbo_Mes").val();
    var codigo = null;
    var estado = '';
    var mode = null;
    var msg = '';
    var lista = new Array();
    <c:forEach var="d" items="${objEnteGenerador}">
    var result = {codigo: '${d.codigo}', descripcion: '${d.descripcion}', cadenaIngreso: '${d.cadenaIngreso}', recaudacion: '${d.enero}', igv: '${d.febrero}', costo: '${d.marzo}', utilidadNeta: '${d.abril}', utilidadUO: '${d.mayo}', utilidadUE: '${d.junio}', estado: '${d.estado}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigo', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'cadenaIngreso', type: "string"},
                        {name: 'recaudacion', type: "number"},
                        {name: 'igv', type: "number"},
                        {name: 'costo', type: "number"},
                        {name: 'utilidadNeta', type: "number"},
                        {name: 'utilidadUO', type: "number"},
                        {name: 'utilidadUE', type: "number"},
                        {name: 'estado', type: "string"}
                    ],
            root: "EnteGenerador",
            record: "EnteGenerador",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
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
        //DEFINIMOS LOS CAMPOS Y DATOS DE LA GRILLA
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 60),
            source: dataAdapter,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            showtoolbar: true,
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            editable: false,
            showstatusbar: true,
            showaggregates: true,
            statusbarheight: 20,
            pagesize: 50,
            rendertoolbar: function (toolbar) {
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
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    codigo = 0;
                    $("#cbo_CadenaIngreso").jqxDropDownList('setContent', 'Seleccione');
                    $('#txt_Descripcion').val('');
                    $("#div_RecaudacionEnero").val(0);
                    $("#div_RecaudacionFebrero").val(0);
                    $("#div_RecaudacionMarzo").val(0);
                    $("#div_RecaudacionAbril").val(0);
                    $("#div_RecaudacionMayo").val(0);
                    $("#div_RecaudacionJunio").val(0);
                    $("#div_RecaudacionJulio").val(0);
                    $("#div_RecaudacionAgosto").val(0);
                    $("#div_RecaudacionSetiembre").val(0);
                    $("#div_RecaudacionOctubre").val(0);
                    $("#div_RecaudacionNoviembre").val(0);
                    $("#div_RecaudacionDiciembre").val(0);
                    $("#div_CostoEnero").val(0);
                    $("#div_CostoFebrero").val(0);
                    $("#div_CostoMarzo").val(0);
                    $("#div_CostoAbril").val(0);
                    $("#div_CostoMayo").val(0);
                    $("#div_CostoJunio").val(0);
                    $("#div_CostoJulio").val(0);
                    $("#div_CostoAgosto").val(0);
                    $("#div_CostoSetiembre").val(0);
                    $("#div_CostoOctubre").val(0);
                    $("#div_CostoNoviembre").val(0);
                    $("#div_CostoDiciembre").val(0);
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'EnteGenerador');
                });
                //reporte
                ButtonReporte.click(function (event) {
                    var url = '../Reportes?reporte=PROG0012&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto;
                    window.open(url, '_blank');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'CADENA INGRESO', dataField: 'cadenaIngreso', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DESCRIPCIÓN', dataField: 'descripcion', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', width: '7%', filtertype: 'checkedlist', align: 'center', cellsAlign: 'center', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'RECAUDACIÓN', dataField: 'recaudacion', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IGV', dataField: 'igv', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'COSTO', dataField: 'costo', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO NETO', dataField: 'utilidadNeta', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO UO', dataField: 'utilidadUO', width: '8.5%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO UE', dataField: 'utilidadUE', width: '8.5%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL 
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 105, autoOpenPopup: false, mode: 'popup'});
        $("#div_GrillaPrincipal").on('contextmenu', function () {
            return false;
        });
        // HABILITAMOS LA OPCION DE CLICK DEL MENU CONTEXTUAL.
        $("#div_GrillaPrincipal").on('rowclick', function (event) {
            if (event.args.rightclick) {
                $("#div_GrillaPrincipal").jqxGrid('selectrow', event.args.rowindex);
                var scrollTop = $(window).scrollTop();
                var scrollLeft = $(window).scrollLeft();
                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
                return false;
            }
        });
        //DEFINIMOS LOS EVENTOS SEGUN LA OPCION DEL MENU CONTEXTUAL
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

                } else if ($.trim($(opcion).text()) === "Cerrar Ente Generador") {
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: '¿Desea Cerrar el Ente Generador?',
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
                } else if ($.trim($(opcion).text()) === "Generar CNV") {
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: '¿Desea Generar el CNV?',
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
                                    mode = 'H';
                                    fn_generarCNV();
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
                        content: 'No hay Opcion a Mostar',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'orange',
                        typeAnimated: true
                    });
                }
            }
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
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
                var alto = 430;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_CadenaIngreso").jqxDropDownList({width: 400, height: 20});
                        $("#txt_Descripcion").jqxInput({placeHolder: 'ENTE GENERADOR', width: 400, height: 20});
                        $("#div_RecaudacionEnero").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionEnero').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionFebrero").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionFebrero').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionMarzo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionMarzo').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionAbril").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionAbril').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionMayo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionMayo').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionJunio").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionJunio').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionJulio").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionJulio').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionAgosto").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionAgosto').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionSetiembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionSetiembre').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionOctubre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionOctubre').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionNoviembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionNoviembre').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_RecaudacionDiciembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_RecaudacionDiciembre').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoEnero").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoEnero').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoFebrero").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoFebrero').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoMarzo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoMarzo').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoAbril").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoAbril').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoMayo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoMayo').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoJunio").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoJunio').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoJulio").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoJulio').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoAgosto").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoAgosto').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoSetiembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoSetiembre').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoOctubre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoOctubre').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoNoviembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoNoviembre').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoDiciembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_CostoDiciembre').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_SaldoEnero").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoFebrero").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoMarzo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoAbril").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoMayo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoJunio").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoJulio").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoAgosto").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoSetiembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoOctubre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoNoviembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $("#div_SaldoDiciembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
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
                                {input: '#txt_Descripcion', message: 'Ingrese el Ente Generador!', action: 'keyup, blur', rule: 'required'}
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
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../EnteGenerador",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../EnteGenerador",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 26) {
                        $("#cbo_CadenaIngreso").jqxDropDownList('selectItem', dato[0]);
                        $('#txt_Descripcion').val(dato[1]);
                        $("#div_RecaudacionEnero").val(dato[2]);
                        $("#div_RecaudacionFebrero").val(dato[3]);
                        $("#div_RecaudacionMarzo").val(dato[4]);
                        $("#div_RecaudacionAbril").val(dato[5]);
                        $("#div_RecaudacionMayo").val(dato[6]);
                        $("#div_RecaudacionJunio").val(dato[7]);
                        $("#div_RecaudacionJulio").val(dato[8]);
                        $("#div_RecaudacionAgosto").val(dato[9]);
                        $("#div_RecaudacionSetiembre").val(dato[10]);
                        $("#div_RecaudacionOctubre").val(dato[11]);
                        $("#div_RecaudacionNoviembre").val(dato[12]);
                        $("#div_RecaudacionDiciembre").val(dato[13]);
                        $("#div_CostoEnero").val(dato[14]);
                        $("#div_CostoFebrero").val(dato[15]);
                        $("#div_CostoMarzo").val(dato[16]);
                        $("#div_CostoAbril").val(dato[17]);
                        $("#div_CostoMayo").val(dato[18]);
                        $("#div_CostoJunio").val(dato[19]);
                        $("#div_CostoJulio").val(dato[20]);
                        $("#div_CostoAgosto").val(dato[21]);
                        $("#div_CostoSetiembre").val(dato[22]);
                        $("#div_CostoOctubre").val(dato[23]);
                        $("#div_CostoNoviembre").val(dato[24]);
                        $("#div_CostoDiciembre").val(dato[25]);
                        fn_verSaldos();
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var cadenaIngreso = $("#cbo_CadenaIngreso").val();
            var descripcion = $("#txt_Descripcion").val();
            var enero = $("#div_RecaudacionEnero").val();
            var febrero = $("#div_RecaudacionFebrero").val();
            var marzo = $("#div_RecaudacionMarzo").val();
            var abril = $("#div_RecaudacionAbril").val();
            var mayo = $("#div_RecaudacionMayo").val();
            var junio = $("#div_RecaudacionJunio").val();
            var julio = $("#div_RecaudacionJulio").val();
            var agosto = $("#div_RecaudacionAgosto").val();
            var setiembre = $("#div_RecaudacionSetiembre").val();
            var octubre = $("#div_RecaudacionOctubre").val();
            var noviembre = $("#div_RecaudacionNoviembre").val();
            var diciembre = $("#div_RecaudacionDiciembre").val();
            var costoEnero = $("#div_CostoEnero").val();
            var costoFebrero = $("#div_CostoFebrero").val();
            var costoMarzo = $("#div_CostoMarzo").val();
            var costoAbril = $("#div_CostoAbril").val();
            var costoMayo = $("#div_CostoMayo").val();
            var costoJunio = $("#div_CostoJunio").val();
            var costoJulio = $("#div_CostoJulio").val();
            var costoAgosto = $("#div_CostoAgosto").val();
            var costoSetiembre = $("#div_CostoSetiembre").val();
            var costoOctubre = $("#div_CostoOctubre").val();
            var costoNoviembre = $("#div_CostoNoviembre").val();
            var costoDiciembre = $("#div_CostoDiciembre").val();
            var costoTotal = $("#div_TotalCosto").val();
            var costoRecaudacion = $("#div_TotalRecaudacion").val();
            if (costoTotal === 0.0 && (mode === 'I' || mode === 'U')) {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'DEBE INGRESAR LOS COSTOS DEL ENTE GENERADOR',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            } else if (costoTotal > costoRecaudacion && (mode === 'I' || mode === 'U')) {
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
                    url: "../IduEnteGenerador",
                    data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo,
                        cadenaIngreso: cadenaIngreso, descripcion: descripcion, enero: enero, febrero: febrero, marzo: marzo, abril: abril, mayo: mayo,
                        junio: junio, julio: julio, agosto: agosto, setiembre: setiembre, octubre: octubre, noviembre: noviembre, diciembre: diciembre,
                        costoEnero: costoEnero, costoFebrero: costoFebrero, costoMarzo: costoMarzo, costoAbril: costoAbril, costoMayo: costoMayo,
                        costoJunio: costoJunio, costoJulio: costoJulio, costoAgosto: costoAgosto, costoSetiembre: costoSetiembre, costoOctubre: costoOctubre,
                        costoNoviembre: costoNoviembre, costoDiciembre: costoDiciembre},
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
        fn_cargarComboAjax("#cbo_CadenaIngreso", {mode: 'cadenaIngresoEstimacionUnidad', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa});
    });
    //FUNCION PARA GENERAR EL CNV
    function fn_generarCNV() {
        var eventoPrincipal = '';
        var eventoFinal = '';
        $.ajax({
            type: "POST",
            url: "../IduEnteGenerador",
            data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
            success: function (data) {
                var dato = data.split("+++");
                if (dato.length === 2) {
                    eventoPrincipal = dato[0];
                    eventoFinal = dato[1];
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
                                    fn_HojaTrabajo(eventoPrincipal, eventoFinal);
                                }
                            }
                        }
                    });
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: data,
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                }
            }
        });
    }
    //FUNCION PARA VER LA HOJA DE TRABAJO
    function fn_HojaTrabajo(eventoPrincipal, eventoFinal) {
        $("#div_VentanaPrincipal").remove();
        $("#div_ContextMenu").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "POST",
            url: "../HojaTrabajo",
            data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: '0001', eventoPrincipal: eventoPrincipal, eventoFinal: eventoFinal},
            success: function (data) {
                $contenidoAjax.html(data);
            }
        });
    }
    //FUNCION PARA VER LOS SALDOS 
    function fn_verSaldos() {
        $("#div_SaldoEnero").val(parseFloat($("#div_RecaudacionEnero").val()) - parseFloat($("#div_CostoEnero").val()));
        $("#div_SaldoFebrero").val(parseFloat($("#div_RecaudacionFebrero").val()) - parseFloat($("#div_CostoFebrero").val()));
        $("#div_SaldoMarzo").val(parseFloat($("#div_RecaudacionMarzo").val()) - parseFloat($("#div_CostoMarzo").val()));
        $("#div_SaldoAbril").val(parseFloat($("#div_RecaudacionAbril").val()) - parseFloat($("#div_CostoAbril").val()));
        $("#div_SaldoMayo").val(parseFloat($("#div_RecaudacionMayo").val()) - parseFloat($("#div_CostoMayo").val()));
        $("#div_SaldoJunio").val(parseFloat($("#div_RecaudacionJunio").val()) - parseFloat($("#div_CostoJunio").val()));
        $("#div_SaldoJulio").val(parseFloat($("#div_RecaudacionJulio").val()) - parseFloat($("#div_CostoJulio").val()));
        $("#div_SaldoAgosto").val(parseFloat($("#div_RecaudacionAgosto").val()) - parseFloat($("#div_CostoAgosto").val()));
        $("#div_SaldoSetiembre").val(parseFloat($("#div_RecaudacionSetiembre").val()) - parseFloat($("#div_CostoSetiembre").val()));
        $("#div_SaldoOctubre").val(parseFloat($("#div_RecaudacionOctubre").val()) - parseFloat($("#div_CostoOctubre").val()));
        $("#div_SaldoNoviembre").val(parseFloat($("#div_RecaudacionNoviembre").val()) - parseFloat($("#div_CostoNoviembre").val()));
        $("#div_SaldoDiciembre").val(parseFloat($("#div_RecaudacionDiciembre").val()) - parseFloat($("#div_CostoDiciembre").val()));
        $("#div_TotalRecaudacion").val($("#div_RecaudacionEnero").val() + $("#div_RecaudacionFebrero").val() + $("#div_RecaudacionMarzo").val() + $("#div_RecaudacionAbril").val() +
                $("#div_RecaudacionMayo").val() + $("#div_RecaudacionJunio").val() + $("#div_RecaudacionJulio").val() + $("#div_RecaudacionAgosto").val() + $("#div_RecaudacionSetiembre").val() +
                $("#div_RecaudacionOctubre").val() + $("#div_RecaudacionNoviembre").val() + $("#div_RecaudacionDiciembre").val());
        $("#div_TotalCosto").val($("#div_CostoEnero").val() + $("#div_CostoFebrero").val() + $("#div_CostoMarzo").val() + $("#div_CostoAbril").val() +
                $("#div_CostoMayo").val() + $("#div_CostoJunio").val() + $("#div_CostoJulio").val() + $("#div_CostoAgosto").val() + $("#div_CostoSetiembre").val() +
                $("#div_CostoOctubre").val() + $("#div_CostoNoviembre").val() + $("#div_CostoDiciembre").val());
        $("#div_TotalSaldo").val($("#div_SaldoEnero").val() + $("#div_SaldoFebrero").val() + $("#div_SaldoMarzo").val() + $("#div_SaldoAbril").val() +
                $("#div_SaldoMayo").val() + $("#div_SaldoJunio").val() + $("#div_SaldoJulio").val() + $("#div_SaldoAgosto").val() + $("#div_SaldoSetiembre").val() +
                $("#div_SaldoOctubre").val() + $("#div_SaldoNoviembre").val() + $("#div_SaldoDiciembre").val());
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">GENERADOR DE GASTO</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_EnteGenerador" name="frm_EnteGenerador" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Clasif. de Ingreso : </td>
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
                    <td colspan="4" class="TituloFocus">Detalle de la Decaudación</td>
                </tr> 
                <tr>                    
                    <td class="bluelabel" style="text-align: center">Mes</td>
                    <td class="bluelabel" style="text-align: center">Recaudación</td>  
                    <td class="bluelabel" style="text-align: center">Costo Operativo</td>
                    <td class="bluelabel" style="text-align: center">Saldo Utilidad</td>
                </tr>
                <tr>
                    <td class="inputlabel">Enero : </td>
                    <td><div id="div_RecaudacionEnero"></div></td>  
                    <td><div id="div_CostoEnero"></div></td>
                    <td><div id="div_SaldoEnero"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Febrero : </td>
                    <td><div id="div_RecaudacionFebrero"></div></td>  
                    <td><div id="div_CostoFebrero"></div></td>
                    <td><div id="div_SaldoFebrero"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Marzo : </td>
                    <td><div id="div_RecaudacionMarzo"></div></td>  
                    <td><div id="div_CostoMarzo"></div></td>
                    <td><div id="div_SaldoMarzo"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Abril : </td>
                    <td><div id="div_RecaudacionAbril"></div></td>  
                    <td><div id="div_CostoAbril"></div></td>
                    <td><div id="div_SaldoAbril"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Mayo : </td>
                    <td><div id="div_RecaudacionMayo"></div></td>  
                    <td><div id="div_CostoMayo"></div></td>
                    <td><div id="div_SaldoMayo"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Junio : </td>
                    <td><div id="div_RecaudacionJunio"></div></td>  
                    <td><div id="div_CostoJunio"></div></td>
                    <td><div id="div_SaldoJunio"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Julio : </td>
                    <td><div id="div_RecaudacionJulio"></div></td>  
                    <td><div id="div_CostoJulio"></div></td>
                    <td><div id="div_SaldoJulio"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Agosto : </td>
                    <td><div id="div_RecaudacionAgosto"></div></td>  
                    <td><div id="div_CostoAgosto"></div></td>
                    <td><div id="div_SaldoAgosto"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Setiembre : </td>
                    <td><div id="div_RecaudacionSetiembre"></div></td>  
                    <td><div id="div_CostoSetiembre"></div></td>
                    <td><div id="div_SaldoSetiembre"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Octubre : </td>
                    <td><div id="div_RecaudacionOctubre"></div></td>  
                    <td><div id="div_CostoOctubre"></div></td>
                    <td><div id="div_SaldoOctubre"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Noviembre : </td>
                    <td><div id="div_RecaudacionNoviembre"></div></td>  
                    <td><div id="div_CostoNoviembre"></div></td>
                    <td><div id="div_SaldoNoviembre"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Diciembre : </td>
                    <td><div id="div_RecaudacionDiciembre"></div></td>  
                    <td><div id="div_CostoDiciembre"></div></td>
                    <td><div id="div_SaldoDiciembre"></div></td>
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
<div id="cbo_Ajax" style='display:none;'></div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Anular</li> 
        <li>Cerrar Ente Generador</li> 
        <li>Generar CNV</li> 
    </ul>
</div>