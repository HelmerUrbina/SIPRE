<%-- 
    Document   : ListaHoraVuelo
    Created on : 08/05/2017, 11:53:06 AM
    Author     : hateccsiv
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnHoraVuelo.periodo}';
    var mode = null;
    var codigoAeronave = "";
    var modeloAeronave = "";
    var tipoAeronave = "";
    var msg = "";
    var cont = 0;
    var contDetalle = 1;
    var lista = new Array();
    <c:forEach var="d" items="${objHoraVuelo}">
    var result = {codigo: '${d.codigoAeronave}', descripcion: '${d.aeronave}', tipoAeronave: '${d.tipoAeronave}',
        costo: '${d.importe}', costoCCFFAA: '${d.costoCCFFAA}', costoEntidades: '${d.costoEntidades}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LOS ELEMENTOS DE LA GRILLA REGISTRO
        $("#jqxInformativo").jqxNotification({width: "auto", appendContainer: "#container", position: "top-right", opacity: 0.9, autoOpen: false, autoClose: true, template: "info"});
        $("#jqxExitoso").jqxNotification({width: "350", appendContainer: "#exitoso", position: "top-right", opacity: 0.9, autoCloseDelay: 1000, autoOpen: false, animationOpenDelay: 800, autoClose: true, template: "success"});
        $('#jqxExitoso').on('close', function () {
            $('#div_VentanaPrincipal').jqxWindow('close');
            fn_Refrescar();
        });
        var sourceNuevo = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: "placa", type: "string"},
                        {name: "tarea", type: "string"},
                        {name: "comeop", type: "string"},
                        {name: "costo", type: "number"},
                        {name: "cantidad", type: "number"},
                        {name: "total", type: "number"}
                    ],
            pagesize: 20,
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            }
        };
        var dataNuevo = new $.jqx.dataAdapter(sourceNuevo);

        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigo', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'tipoAeronave', type: "string"},
                        {name: 'costo', type: "number"},
                        {name: 'costoCCFFAA', type: "number"},
                        {name: 'costoEntidades', type: "number"}
                    ],
            root: "HoraVuelo",
            record: "HoraVuelo",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "descripcion") {
                return "RowBold";
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
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            showaggregates: true,
            showstatusbar: true,
            showtoolbar: true,
            editable: false,
            pagesize: 30,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonEliminar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/delete42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonEliminar);
                container.append(ButtonExportar);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonEliminar.jqxButton({width: 30, height: 22});
                ButtonEliminar.jqxTooltip({position: 'bottom', content: "Anular Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    $("#cbo_tipoAeronave").jqxDropDownList('selectItem', 0);
                    $("#txt_descripcion").val('');
                    codigoAeronave = "0";
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                // ASIGNAMOS LAS FUNCIONES PARA EL BOTON CARGAR
                ButtonEliminar.click(function (event) {
                    fn_Eliminar();
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'HoraVuelo');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '10', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'MODELO AERONAVE', dataField: 'descripcion', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'TIPO AERONAVE', dataField: 'tipoAeronave', filtertype: 'checkedlist', width: '17%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'SIN IGV', dataField: 'costo', columngroup: 'Titulo', align: 'center', width: '15%', cellsAlign: 'right', cellsFormat: 'f2', columntype: 'numberinput', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CCFFAA/INSTITUTO', dataField: 'costoCCFFAA', columngroup: 'Titulo', align: 'center', width: '15%', cellsAlign: 'right', cellsFormat: 'f2', columntype: 'numberinput', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'OTRAS ENTIDADES', dataField: 'costoEntidades', columngroup: 'Titulo', align: 'center', width: '15%', cellsAlign: 'right', cellsFormat: 'f2', columntype: 'numberinput', cellclassname: cellclass, aggregates: ['sum']}
            ],
            columngroups: [
                {text: '<strong>COSTO X HORA DE VUELO</strong>', name: 'Titulo', align: 'center'}
            ]
        });
        //DEFINIMOS UNA GRILLA DE REGISTRO
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: '450',
            source: dataNuevo,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            showstatusbar: true,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            editable: false,
            renderstatusbar: function (statusbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var addButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'>Nuevo</span></div>");
                var deleteButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/delete42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'>Anular</span></div>");
                container.append(addButtonDet);
                container.append(deleteButtonDet);
                statusbar.append(container);
                addButtonDet.jqxButton({width: 60, height: 22});
                addButtonDet.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                deleteButtonDet.jqxButton({width: 70, height: 22});
                deleteButtonDet.jqxTooltip({position: 'bottom', content: "Anular Registro"});
                // add new row.
                addButtonDet.click(function (event) {

                    var msg = "";

                    if (msg === "") {
                        //$("#cbo_tarea").jqxDropDownList('clear');
                        //fn_cargarComboAjax("#cbo_tarea", 'departamento', 0, 0, 0, 0, 0, 0, 0, 0);

                        $('#txt_placa').val('');
                        $('#div_costo').val(0);
                        $('#div_cantidad').val(0);
                        $('#div_total').val(0);
                        $("#cbo_tarea").jqxDropDownList('selectItem', 0);
                        fn_CostoHoraVuelo();
                        fn_calcularTotal();

                        $('#div_VentanaDetalleRegistro').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_VentanaDetalleRegistro').jqxWindow('open');
                    }
                });
                // delete selected row.
                deleteButtonDet.click(function (event) {
                    var rowindex = $("#div_GrillaRegistro").jqxGrid('getselectedrowindex');
                    var rowid = $("#div_GrillaRegistro").jqxGrid('getrowid', rowindex);
                    if (rowindex >= 0) {
                        $("#div_GrillaRegistro").jqxGrid('deleterow', rowid);
                    } else {
                        $("#jqxInformativo").text("Seleccione un Registro");
                        $("#jqxInformativo").jqxNotification("open");
                    }
                });
            },
            columns: [
                {text: 'PLACA', datafield: 'placa', width: '15%', align: 'center', cellsAlign: 'center'},
                {text: 'TAREA', datafield: 'tarea', width: '40%', align: 'center', cellsAlign: 'center'},
                {text: 'COSTO', dataField: 'costo', width: "15%", align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'CANTIDAD', dataField: 'cantidad', width: "15%", align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'TOTAL', dataField: 'total', width: "15%", align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass}
            ]
        });


        // DEFINIMOS EL MENU CONTEXTUAL
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 80, autoOpenPopup: false, mode: 'popup'});
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
            if (codigoAeronave === null || codigoAeronave === '') {
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
                    mode = 'U';
                    $("#cbo_tipoAeronave").jqxDropDownList('selectItem', 0);
                    $("#txt_descripcion").val('');
                    fn_EditarRegistro();

                } else if ($.trim($(opcion).text()) === "Ingresar Costos") {
                    fn_registrarDetalle();
                } else if ($.trim($(opcion).text()) === "Programar Horas de Vuelo") {
                    fn_progHorasVuelo();
                }
            }
        });

        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigoAeronave = row['codigo'];
            modeloAeronave = row['descripcion'];
            tipoAeronave = row['tipoAeronave'];
        });

        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: 400, y: 200},
                    width: 450, height: 128, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_tipoAeronave").jqxDropDownList({width: 300, height: 20});
                        $("#txt_descripcion").jqxInput({placeHolder: "Ingrese modelo Aeronave", width: 300, height: 20});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            var msg = "";
                            if (msg === "")
                                msg = fn_verificarTipoAeronave();
                            if (msg === "")
                                msg = fn_verificarDescripcion();
                            if (msg === "")
                                fn_GrabarDatos();
                        });
                    }
                });
                //INICIA LOS VALORES DE LA VENTANA DETALLE
                $('#div_VentanaDetalle').jqxWindow({
                    position: {x: 400, y: 200},
                    width: 650, height: 580, resizable: false,
                    cancelButton: $('#btn_CancelarDet'),
                    initContent: function () {
                        $('#div_GrillaRegistro').jqxGrid('clear');

                        $("#txt_tipoAeronave").jqxInput({width: 200, height: 20, disabled: true});
                        $("#txt_modelo").jqxInput({width: 200, height: 20, disabled: true});

                        $('#btn_CancelarDet').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDet').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDet').on('click', function () {
                            var msg = "";
                            fn_GrabarDetalle();


                        });
                    }
                });
                //INICIALIZA LA VENTA DE REGISTRO DE DETALLE
                $('#div_VentanaDetalleRegistro').jqxWindow({
                    position: {x: 400, y: 200},
                    width: 600, height: 180, resizable: false,
                    cancelButton: $('#btn_CancelarDetalle'),
                    initContent: function () {
                        fn_CostoHoraVuelo();
                        $('#div_costo').val(0);
                        $('#div_cantidad').val(0);
                        $('#div_total').val(0);
                        $("#cbo_tarea").jqxDropDownList({animationType: 'fade', width: 370, height: 20});
                        $("#cbo_tarea").on('change', function () {
                            fn_CostoHoraVuelo();
                            fn_calcularTotal();
                        });
                        $("#txt_placa").jqxInput({placeHolder: 'Ingrese el Nro de Placa', width: 200, height: 20});
                        $("#div_costo").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                        $("#div_cantidad").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $("#div_total").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                        $("#div_cantidad").on('textchanged', function () {
                            fn_calcularTotal();
                        });

                        $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});

                        //desTarea=desTarea.label;
                        $('#btn_GuardarDetalle').on('click', function () {
                            var desTarea = $("#cbo_tarea").jqxDropDownList('getSelectedItem');
                            var desPlaca = $("#txt_placa").val();
                            var msg = "";
                            if (msg === "")
                                msg = fn_verificarTarea();
                            if (msg === "")
                                msg = fn_verificarPlaca();
                            if (msg === "")
                                msg = fn_validarCantidad();
                            if (msg === "")
                                msg = fn_validarTotal();
                            if (msg === "")
                                msg = fn_verificarDatosGrilla();
                            if (msg === "") {
                                var row = {
                                    placa: desPlaca.toUpperCase(), comeop: $("#cbo_tarea").val(), tarea: desTarea.label,
                                    costo: parseFloat($("#div_costo").jqxNumberInput('decimal')),
                                    cantidad: parseFloat($("#div_cantidad").jqxNumberInput('decimal')),
                                    total: parseFloat($("#div_total").jqxNumberInput('decimal'))};
                                $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
                                $("#div_VentanaDetalleRegistro").jqxWindow('hide');
                                contDetalle = contDetalle + 1;
                            }
                        });
                    }
                });
            }


            return {init: function () {
                    _createElements();

                    fn_cargarComboAjax("#cbo_tarea", 'tareaHoraVuelo', periodo, 0, 0, 0, 0, 0, 0, 0);

                }
            };
        }());
        $(document).ready(function () {
            customButtonsDemo.init();
        });
        //FUNCION PARA GRABAR DETALLE DE HORAS DE VUELO
        function fn_GrabarDetalle() {
            mode = "I";
            var lista = new Array();
            var result;
            var modelo = $('#txt_modelo').val();
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                result = row.placa + "---" + row.comeop + "---" + row.costo + "---" + row.cantidad + "---"
                        + row.total;
                lista.push(result);
            }
            $.ajax({
                type: "POST",
                url: "../IduProgramacionHorasVuelo",
                data: {mode: mode, periodo: periodo, codigoAeronave: codigoAeronave, tipoAeronave: tipoAeronave,
                    modelo: modelo,
                    lista: JSON.stringify(lista)},
                success: function (data) {
                    msg = data;

                    if (msg === "GUARDO") {
                        $.confirm({
                            title: 'AVISO DEL SISTEMA',
                            content: 'Datos procesados correctamente!!',
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
        //FUNCION PARA INGRESAR DETALLE DE LA AERONAVE
        function fn_registrarDetalle() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_VentanaDetalle").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../HoraVuelo",
                data: {mode: 'GD', periodo: periodo, codigoAeronave: codigoAeronave, aeronave: modeloAeronave},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA VERIFICAR LOS DATOS DE LA GRILLA NO SEAN REPETIDOS
        function fn_verificarDatosGrilla(){
            
            var comeop=$("#cbo_tarea").val();
            var placa=$("#txt_placa").val();
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            var grilla="";
            var msg="";
            for(var i=0;i<rows.length;i++){
                var row=rows[i];
                grilla=row.comeop+"-"+row.placa;
                if(grilla===comeop+"-"+placa){
                    msg = "Datos ya se encuentran registrados en la lista";
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
                    break;
                }
            }
            return "";
        }
        //FUNCION PARA VERIFICAR LA SELECCION DE UNA TAREA
        function fn_verificarTarea() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_tarea").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione la Tarea";
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
        //FUNCION PARA VERIFICAR EL INGRESO DE UNA PLACA
        function fn_verificarPlaca() {
            var msg = "";
            var dato = "";
            dato = $("#txt_placa").val();
            if (dato === "" || dato.length === 0 || dato === null) {
                msg = "Ingrese el Nro de Placa de la Aeronave";
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
        //FUNCION PARA VERIFICAR EL REGISTRO DE AL MENOS UNA HORA DE VUELO
        function fn_validarCantidad() {
            var msg = "";
            var cantidad = $("#div_cantidad").val();
            cantidad = parseFloat(cantidad);
            if (cantidad <= 0) {
                msg = "Ingrese la cantidad de Horas de Vuelo.";
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
        //FUNCION VALIDAR TOTAL DE HORA DE VUELO
        function fn_validarTotal() {
            var msg = "";
            var total = $("#div_total").val();
            total = parseFloat(total);
            if (total <= 0) {
                msg = "El importe total de Hora de Vuelo no puede ser cero (0), revise.";
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
        //FUNCION TRAER DATOS DE COSTO DE HORA DE VUELO
        function fn_CostoHoraVuelo() {
            var tarea = $("#cbo_tarea").val();
            $.ajax({
                type: "GET",
                url: "../HoraVuelo",
                data: {mode: 'C', periodo: periodo, codigoAeronave: codigoAeronave, tarea: tarea},
                success: function (data) {
                    $("#div_costo").val(data);
                }
            });
        }
        //FUNCTION PARA LOS TOTALES DE LA GRILLA
        function fn_TotalCostoGrilla(){
            var totalGrilla="0";
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');            
            for(var i=0;i<rows.length;i++){
                var row=rows[i];
                totalGrilla=parseFloat(totalGrilla)+parseFloat(row.total);
            }
            return totalGrilla;
        }
        //FUNCION CALCULAR TOTAL DE HORAS DE VUELO
        function fn_calcularTotal() {
            $('#div_total').val('0');
            var cantidad = $("#div_cantidad").val();
            var costo = $("#div_costo").val();
            cantidad = parseFloat(cantidad);
            costo = parseFloat(costo);
            var total = cantidad * costo;
            if (isNaN(total))
                total = '0';
            $('#div_total').val(total);
        }
        //FUNCION PARA VERIFICAR SE SELECCIONE UN TIPO DE AERONAVE
        function fn_verificarTipoAeronave() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_tipoAeronave").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el tipo de Aeronave";
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
        //FUNCION PARA VERIFICAR SE INGRESE EL MODELO DE LA AERONAVE
        function fn_verificarDescripcion() {
            var msg = "";
            var dato = "";
            dato = $("#txt_descripcion").val();
            if (dato === "" || dato.length === 0 || dato === null) {
                msg = "Ingrese el modelo de la Aeronave";
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
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_VentanaDetalleRegistro").remove();

            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../HoraVuelo",
                data: {mode: 'G', periodo: periodo},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA ANULAR LOS REGISTROS
        function fn_Eliminar() {
            if (codigoAeronave === null || codigoAeronave === "") {
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
                $.confirm({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: '¿Desea borrar este registro y todo el detalle que hubiera?',
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
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../HoraVuelo",
                data: {mode: mode, periodo: periodo, codigoAeronave: codigoAeronave},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 2) {
                        $("#cbo_tipoAeronave").jqxDropDownList('selectItem', dato[0]);
                        $("#txt_descripcion").val(dato[1]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA VENTANA DE PROGRAMACION DE HORAS DE VUELO
        function fn_progHorasVuelo() {
            $("#txt_tipoAeronave").val(tipoAeronave);
            $("#txt_modelo").val(modeloAeronave);
            $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
            $('#div_VentanaDetalle').jqxWindow('open');
        }


        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var tipoAeronave = $("#cbo_tipoAeronave").val();
            var descripcion = $("#txt_descripcion").val();
            $.ajax({
                type: "POST",
                url: "../IduHoraVuelo",
                data: {mode: mode, periodo: periodo, tipoAeronave: tipoAeronave, descripcion: descripcion,
                    codigo: codigoAeronave},
                success: function (data) {
                    msg = data;
                    if (msg === "GUARDO") {
                        $.confirm({
                            title: 'AVISO DEL SISTEMA',
                            content: 'Datos procesados correctamente!!',
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

    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">REGISTRO DE AERONAVES</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_HoraVuelo" name="frm_HoraVuelo" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Tipo Aeronave : </td>
                    <td>
                        <select id="cbo_tipoAeronave" name="cbo_tipoAeronave">
                            <option value="0">Seleccione</option>
                            <option value="H">HELICOPTEROS</option>
                            <option value="T">TRANSPORTES</option>
                            <option value="G">DE COMBATE</option>                            
                        </select>
                    </td>                    
                </tr>

                <tr>
                    <td class="inputlabel">Modelo : </td>
                    <td><input type="text" id="txt_descripcion" name="txt_descripcion" style="text-transform: uppercase;"/></td>   
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
        <span style="float: left">PROGRAMACION DE HORAS DE VUELO</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_progHorasVuelo" name="frm_progHorasVuelo" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Tipo Aeronave : </td>

                    <td><input type="text" id="txt_tipoAeronave" name="txt_tipoAeronave" style="text-transform: uppercase;"/></td>                       

                    <td>
                        <div id="exitoso" style="position: fixed"></div>  
                        <div id="container" style="position: fixed"></div>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Modelo Aeronave : </td>
                    <td><input type="text" id="txt_modelo" name="txt_modelo" style="text-transform: uppercase;"/></td>   
                </tr>                
                <tr>
                    <td class="Summit" colspan="2">
                        <div>
                            <input type="button" id="btn_GuardarDet"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarDet" value="Cancelar" style="margin-right: 20px"/>                            
                        </div>
                    </td>
                </tr>
            </table>  
            <table id="div_GrillaRegistro">
                <thead>
                    <tr>
                        <th>placa</th>
                        <th>tarea</th>
                        <th>costo</th>
                        <th>cantidad</th>                                                
                        <th>total</th>                        
                    </tr>
                </thead>                
            </table>
            <div style="display: none" id="div_VentanaDetalleRegistro">
                <div>
                    <span style="float: left">REGISTRO PROGRAMACIÓN DE HORAS DE VUELO</span>
                </div>
                <div style="overflow: hidden"> 

                    <table width="100%" border="0" cellspacing="0" cellpadding="0">   

                        <tr>
                            <td class="inputlabel">Tarea : </td>
                            <td >
                                <select id="cbo_tarea" name="cbo_tarea">
                                    <option value="0">Seleccione</option>

                                </select>
                            </td>

                        </tr>

                        <tr>
                            <td class="inputlabel">Nro Placa : </td>
                            <td><input type="text" id="txt_placa" name="txt_placa" style="text-transform: uppercase;"/></td>                           
                        </tr> 
                        <tr>
                            <td class="inputlabel">Cantidad Horas de Vuelo: </td>
                            <td><div id="div_cantidad"></div>  
                            </td>  

                        </tr> 
                        <tr>
                            <td class="inputlabel">Costo X Hora de Vuelo S/. : </td>
                            <td><div id="div_costo"></div></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Total : </td>
                            <td><div id="div_total"></div></td> 
                            
                        </tr>                        
                        <tr>
                            <td class="Summit" colspan="8">
                                <div>
                                    <input type="button" id="btn_CancelarDetalle" name="btn_CancelarDetalle" value="Cancelar" style="margin-right: 20px"/>
                                    <input type="button" id="btn_GuardarDetalle" name="btn_GuardarDetalle" value="Guardar" style="margin-right: 20px" />                                    
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>  
            </div>
        </form>
    </div>
</div>
<div id="cbo_Ajax" style='display: none;'></div>
<div id="jqxInformativo"></div>
<div id="jqxExitoso">Datos Guardados Exitosamente!!</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>        
        <li>Ingresar Costos</li>
        <li>Programar Horas de Vuelo</li>
    </ul>
</div>
