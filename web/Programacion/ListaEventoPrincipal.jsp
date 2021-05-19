<%-- 
    Document   : ListaEventoPrincipal
    Created on : 03/02/2017, 04:07:38 PM
    Author     : H-URBINA-M
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnEvento.periodo}';
    var presupuesto = '${objBnEvento.presupuesto}';
    var unidadOperativa = '${objBnEvento.unidadOperativa}';
    var tarea = '${objBnEvento.tarea}';
    var evento = '${objBnEvento.comentario}';
    var codigo = null;
    var mode = null;
    var lista = new Array();
    <c:forEach var="d" items="${objEvento}">
    var result = {codigo: '${d.codigo}', nombreEvento: '${d.nombreEvento}', nivel: '${d.nivel}', cantidad: '${d.cantidad}',
        enero: '${d.enero}', febrero: '${d.febrero}', marzo: '${d.marzo}', abril: '${d.abril}', mayo: '${d.mayo}', junio: '${d.junio}',
        julio: '${d.julio}', agosto: '${d.agosto}', setiembre: '${d.setiembre}', octubre: '${d.octubre}', noviembre: '${d.noviembre}',
        diciembre: '${d.diciembre}', monto: '${d.programado}', total: '${d.total}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA DE LA CABECERA  
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
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
            root: "EventoPrincipal",
            record: "Evento",
            id: 'codigo'
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "codigo" || datafield === "total") {
                return "RowBold";
            }
            if (datafield === "monto") {
                return "RowBlue";
            }
        };
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 60),
            source: sourceCab,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            showtoolbar: true,
            editable: false,
            showstatusbar: true,
            showaggregates: true,
            statusbarheight: 25,            
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonCargar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonReporte = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonCargar);
                container.append(ButtonExportar);
                container.append(ButtonReporte);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonCargar.jqxButton({width: 30, height: 22});
                ButtonCargar.jqxTooltip({position: 'bottom', content: "Actualiza Pantalla"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonReporte.jqxButton({width: 30, height: 22});
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reporte"});
                // Adicionar un Nuevo Registro en la Cabecera.
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    fn_NuevoRegistro();
                });
                // Recarga la Data en la Grilla
                ButtonCargar.click(function (event) {
                    fn_Refrescar();
                });
                //export to excel
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'CNVEventosPrincipales');
                });
                //reporte
                ButtonReporte.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            columns: [
                {text: 'CODIGO', dataField: 'codigo', width: '10%', filtertype: 'checkedlist', columngroup: 'Tarea', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'EVENTO', dataField: 'nombreEvento', width: '27%', columngroup: 'Tarea', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'NIVEL', dataField: 'nivel', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EVE. FINAL', dataField: 'cantidad', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MONTO', dataField: 'monto', columngroup: 'Tarea', width: '11%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ENE', dataField: 'enero', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'FEB', dataField: 'febrero', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MAR', dataField: 'marzo', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ABR', dataField: 'abril', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MAY', dataField: 'mayo', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'JUN', dataField: 'junio', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'JUL', dataField: 'julio', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'AGO', dataField: 'agosto', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SET', dataField: 'setiembre', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'OCT', dataField: 'octubre', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'NOV', dataField: 'noviembre', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DIC', dataField: 'diciembre', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'TOTAL', dataField: 'total', columngroup: 'Tarea', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']}
            ],
            columngroups: [
                {text: '<strong>LISTADO DE EVENTOS PRINCIPALES</strong>', name: 'Titulo', align: 'center'},
                {text: '<strong>TAREA : </strong>' + evento, name: 'Tarea', parentgroup: 'Titulo'}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 105, autoOpenPopup: false, mode: 'popup'});
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
            if ($.trim($(opcion).text()) === "Editar") {
                if (codigo !== null || codigo === '') {
                    mode = 'U';
                    fn_EditarRegistro();
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
            } else if ($.trim($(opcion).text()) === "Eliminar") {
                if (codigo !== null || codigo === '') {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Desea Eliminar este registro!',
                        theme: 'material',
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
                                    $('#txt_Codigo').val(codigo);
                                    $("#chk_EventoFinal").jqxCheckBox({checked: false});
                                    mode = 'D';
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
                        content: 'Debe Seleccionar un Registro',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                }
            } else if ($.trim($(opcion).text()) === "Cantidades Fisicas") {
                if (codigo !== null || codigo === '') {
                    mode = 'CF';
                    fn_DetalleRegistro();
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'Debe Seleccionar un Registro',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'blue',
                        typeAnimated: true
                    });
                }
            } else if ($.trim($(opcion).text()) === "Ver Evento") {
                if (codigo !== null || codigo === '') {
                    fn_GeneradorGasto();
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'Debe Seleccionar un Registro',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'blue',
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
        });
        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 550;
                var alto = 250;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_Codigo").jqxInput({width: 120, height: 20, disabled: true});
                        $("#txt_Evento").jqxInput({placeHolder: 'INGRESE NOMBRE DEL EVENTO', width: 400, height: 20});
                        $("#div_Niveles").jqxNumberInput({width: 50, height: 20, max: 99, digits: 2, decimalDigits: 0});
                        $('#txt_Comentario').jqxInput({placeHolder: 'INGRESE COMENTARIO', height: 90, width: 400, minLength: 1});
                        $("#chk_EventoFinal").jqxCheckBox({height: 25});
                        $("#chk_EventoFinal").on('change', function (event) {
                            var checked = event.args.checked;
                            if (checked) {
                                $('#div_Niveles').val(0);
                                $('#div_Niveles').jqxNumberInput({disabled: true});
                            } else {
                                $('#div_Niveles').jqxNumberInput({disabled: false});
                                $('#div_Niveles').jqxNumberInput('focus');
                            }
                        });
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function (event) {
                            $('#frm_Evento').jqxValidator('validate');
                        });
                        $('#frm_Evento').jqxValidator({
                            rules: [
                                {input: '#txt_Evento', message: 'Ingrese el Nombre del Evento!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_Evento').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatos();
                            }
                        });
                    }
                });
                ancho = 450;
                alto = 280;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                //INICIA LOS VALORES DE LA VENTANA DETALLE
                $('#div_VentanaDetalle').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarDetalle'),
                    initContent: function () {
                        $("#txt_Tarea").jqxInput({width: 300, height: 20, disabled: true});
                        $("#txt_UnidadMedida").jqxInput({width: 300, height: 20, disabled: true});
                        $("#div_Enero").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Enero').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Febrero").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Febrero').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Marzo").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Marzo').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Abril").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Abril').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Mayo").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Mayo').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Junio").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Junio').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Julio").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Julio').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Agosto").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Agosto').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Setiembre").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Setiembre').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Octubre").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Octubre').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Noviembre").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Noviembre').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Diciembre").jqxNumberInput({width: 80, height: 20, max: 99999, digits: 5, decimalDigits: 0});
                        $('#div_Diciembre').on('textchanged', function (event) {
                            fn_verTotales();
                        });
                        $("#div_Total").jqxNumberInput({width: 80, height: 20, max: 9999999, digits: 6, decimalDigits: 0, disabled: true});
                        $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').on('click', function (event) {
                            fn_GrabarDatosDetalle();
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
                        $("#div_PROG0001").jqxRadioButton({width: 200, height: 20});
                        $('#div_PROG0001').on('checked', function (event) {
                            reporte = 'PROG0013';
                        });
                        $("#div_PROG0002").jqxRadioButton({width: 200, height: 20});
                        $('#div_PROG0002').on('checked', function (event) {
                            reporte = 'PROG0002';
                        });
                        $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').on('click', function (event) {
                            var msg = "";
                            var variable = null;
                            switch (reporte) {
                                case "PROG0013":
                                    variable = codigo;
                                    break;
                                case "PROG0002":
                                    if (codigo === null)
                                        msg += "Seleccione un Registro.<br>";
                                    else
                                        variable = codigo;
                                    break;
                                default:
                                    msg += "Debe selecciona una opción.<br>";
                                    break;
                            }
                            if (msg === "") {
                                var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto + '&codigo=' + variable+ '&codigo2=' + tarea;
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
        //FUNCION PARA REFRESCAR LA PANTALLA
        function fn_Refrescar() {
            $("#div_ContextMenu").remove();
            $("#div_GrillaTotales").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../EventoPrincipal",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA DE NUEVO REGISTRO
        function fn_NuevoRegistro() {
            $.ajax({
                type: "POST",
                url: "../EventoPrincipal",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea},
                success: function (data) {
                    $('#txt_Codigo').val(data);
                    $('#txt_Evento').val('');
                    $('#div_Niveles').val(0);
                    $('#txt_Comentario').val('');
                    $('#txt_Evento').jqxInput('focus');
                    $("#chk_EventoFinal").jqxCheckBox({checked: false});
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $('#txt_Codigo').val(codigo);
            $.ajax({
                type: "GET",
                url: "../EventoPrincipal",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 4) {
                        $('#txt_Evento').val(dato[0]);
                        $('#div_Niveles').val(dato[1]);
                        $('#txt_Comentario').val(dato[2]);
                        $("#chk_EventoFinal").jqxCheckBox('val', dato[3]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA CARGAR VENTANA DE DETALLE DE REGISTRO
        function fn_DetalleRegistro() {
            $.ajax({
                type: "GET",
                url: "../EventoPrincipal",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 15) {
                        $('#txt_Tarea').val(dato[0]);
                        $('#txt_UnidadMedida').val(dato[1]);
                        $('#div_Enero').val(dato[2]);
                        $('#div_Febrero').val(dato[3]);
                        $('#div_Marzo').val(dato[4]);
                        $('#div_Abril').val(dato[5]);
                        $('#div_Mayo').val(dato[6]);
                        $('#div_Junio').val(dato[7]);
                        $('#div_Julio').val(dato[8]);
                        $('#div_Agosto').val(dato[9]);
                        $('#div_Setiembre').val(dato[10]);
                        $('#div_Octubre').val(dato[11]);
                        $('#div_Noviembre').val(dato[12]);
                        $('#div_Diciembre').val(dato[13]);
                        $('#div_Total').val(dato[14]);
                    }
                }
            });
            $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
            $('#div_VentanaDetalle').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var codigo = $('#txt_Codigo').val();
            var evento = $("#txt_Evento").val();
            var niveles = $("#div_Niveles").val();
            var comentario = $("#txt_Comentario").val();
            var eventoFinal = $("#chk_EventoFinal").jqxCheckBox('checked');
            $.ajax({
                type: "POST",
                url: "../IduEventoPrincipal",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea,
                    codigo: codigo, evento: evento, niveles: niveles, comentario: comentario, eventoFinal: eventoFinal},
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
                                        if (mode === 'I')
                                            fn_EventoFinal(codigo, eventoFinal);
                                        else
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
        //FUNCION PARA OBTENER EL ULTIMO EVENTO CREADO
        function fn_EventoFinal(codigo, eventoFinal) {
            if (eventoFinal) {
                $.ajax({
                    type: "POST",
                    url: "../EventoFinal",
                    data: {mode: 'C', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, nivel: 0, codigo: codigo},
                    success: function (data) {
                        fn_HojaTrabajo(codigo, data);
                    }
                });
            } else {
                fn_Refrescar();
            }
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA DETALLE
        function fn_GrabarDatosDetalle() {
            var enero = $('#div_Enero').val();
            var febrero = $('#div_Febrero').val();
            var marzo = $('#div_Marzo').val();
            var abril = $('#div_Abril').val();
            var mayo = $('#div_Mayo').val();
            var junio = $('#div_Junio').val();
            var julio = $('#div_Julio').val();
            var agosto = $('#div_Agosto').val();
            var setiembre = $('#div_Setiembre').val();
            var octubre = $('#div_Octubre').val();
            var noviembre = $('#div_Noviembre').val();
            var diciembre = $('#div_Diciembre').val();
            var msg = "";
            $.ajax({
                type: "POST",
                url: "../IduEventoPrincipal",
                data: {mode: 'CF', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea,
                    codigo: codigo, enero: enero, febrero: febrero, marzo: marzo, abril: abril, mayo: mayo, junio: junio, julio: julio,
                    agosto: agosto, setiembre: setiembre, octubre: octubre, noviembre: noviembre, diciembre: diciembre},
                success: function (data) {
                    msg = data;
                    if (msg === "GUARDO") {
                        $('#div_VentanaDetalle').jqxWindow('close');
                        fn_Refrescar();
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
        function fn_GeneradorGasto() {
            $("#div_ContextMenu").remove();
            $("#div_GrillaTotales").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../EventoSecundario",
                data: {mode: 'ES', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, codigo: codigo},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        function fn_HojaTrabajo(eventoPrincipal, eventoFinal) {
            $("#div_ContextMenu").remove();
            $("#div_GrillaTotales").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../HojaTrabajo",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, nivel: 0, eventoPrincipal: eventoPrincipal, eventoFinal: eventoFinal},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        function fn_verTotales() {
            var total = parseFloat($("#div_Enero").val()) + parseFloat($("#div_Febrero").val()) + parseFloat($("#div_Marzo").val()) + parseFloat($("#div_Abril").val()) +
                    parseFloat($("#div_Mayo").val()) + parseFloat($("#div_Junio").val()) + parseFloat($("#div_Julio").val()) + parseFloat($("#div_Agosto").val()) +
                    parseFloat($("#div_Setiembre").val()) + parseFloat($("#div_Octubre").val()) + parseFloat($("#div_Noviembre").val()) + parseFloat($("#div_Diciembre").val());
            $("#div_Total").val(parseFloat(total));
        }
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">REGISTRO DE EVENTO PRINCIPAL</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_Evento" name="frm_Evento" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Codigo : </td>
                    <td><input type="text" id="txt_Codigo" name="txt_Codigo"/></td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Evento : </td>
                    <td><input type="text" id="txt_Evento" name="txt_Evento" style="text-transform: uppercase;"/></td>
                </tr> 
                <tr>
                    <td class="inputlabel">Comentario : </td>
                    <td><textarea id="txt_Comentario" name="txt_Comentario" style="text-transform: uppercase;"/></textarea></td>                          
                </tr>
                <tr>
                    <td class="inputlabel"># Niveles : </td>
                    <td><div id="div_Niveles"></div></td>                          
                </tr>
                <tr>
                    <td class="inputlabel">Ultimo Evento : </td>
                    <td><div id='chk_EventoFinal'> </div></td>                          
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
<div id="div_VentanaDetalle" style="display: none">
    <div>
        <span style="float: left">EVENTO PRINCIPAL - CANTIDADES FISICAS</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_EventoDetalle" name="frm_EventoDetalle" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Tarea : </td>
                    <td colspan="3"><input type="text" id="txt_Tarea" name="txt_Tarea"/></td>                    
                </tr>
                <tr>
                    <td class="inputlabel">UU/MM : </td>
                    <td colspan="3"><input type="text" id="txt_UnidadMedida" name="txt_UnidadMedida"/></td>                    
                </tr>
                <tr>
                    <td colspan="4"><div class="bluelabel">Ingrese las Cantidades Físicas : </div></td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Enero : </td>
                    <td><div id="div_Enero"></div></td>    
                    <td class="inputlabel">Febrero : </td>
                    <td><div id="div_Febrero"></div></td>    
                </tr>
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
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>    
                    <td class="inputlabel">Total : </td>
                    <td><div id="div_Total"></div></td>    
                </tr>
                <tr>
                    <td class="Summit" colspan="4">
                        <div>
                            <input type="button" id="btn_GuardarDetalle"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarDetalle" value="Cancelar" style="margin-right: 20px"/>                            
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
        <li>Eliminar</li> 
        <li>Cantidades Fisicas</li> 
        <li>Ver Evento</li> 
    </ul>
</div>
<div style="display: none" id="div_Reporte">
    <div>
        <span style="float: left">LISTADO DE REPORTES</span>
    </div>
    <div style="overflow: hidden">
        <div id='div_PROG0001'>Resumen</div>
        <div id='div_PROG0002'>CNV</div>        
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>