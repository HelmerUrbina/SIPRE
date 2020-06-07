<%-- 
    Document   : ListaPersonalPresupuesto
    Created on : 23/02/2017, 03:11:16 PM
    Author     : hateccsiv
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link type="text/css" rel="stylesheet" href="../css/grid.css">
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var codConcepto = $("#cbo_Concepto").val();
    var codigo = null;
    var detalle = null;
    var comeop = "";
    var cocaga = "";
    var mode = null;
    var cont = 0;
    var msg = "";
    var contDetalle = 1;
    var nivelDescripcion = "";

    $(document).ready(function () {

        $("#jqxInformativo").jqxNotification({width: "auto", appendContainer: "#container", position: "top-right", opacity: 0.9, autoOpen: false, autoClose: true, template: "info"});
        $("#jqxExitoso").jqxNotification({width: "350", appendContainer: "#exitoso", position: "top-right", opacity: 0.9, autoCloseDelay: 1000, autoOpen: false, animationOpenDelay: 800, autoClose: true, template: "success"});
        $("#jqxFail").jqxNotification({width: "auto", appendContainer: "#fail", position: "top-right", opacity: 0.9, autoOpen: false, autoClose: true, template: "error"});
        $('#jqxExitoso').on('close', function () {
            $('#div_VentanaPrincipal').jqxWindow('close');
            fn_Refrescar();
        });
        //
        var sourceNuevo = {
            localdata: fn_cargarGrilla("#div_GrillaRegistro"),
            datatype: "array",
            datafields:
                    [
                        {name: "departamento", type: "string"},
                        {name: "unidad", type: "string"},
                        {name: "nivel", type: "string"},
                        {name: "grado", type: "string"},
                        {name: "periodoRee", type: "string"},
                        {name: "cantidad", type: "number"},
                        {name: "importe", type: "number"},
                        {name: "total", type: "number"}
                    ],
            pagesize: 20,
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            }
        };
        var dataNuevo = new $.jqx.dataAdapter(sourceNuevo);
        //PARA LA GRILLA DE LA CABECERA        
        var sourceCab = {
            localdata: fn_cargarGrilla("#div_GrillaCabecera"),
            datatype: "array",
            datafields:
                    [
                        {name: "nivelGrado", type: "number"},
                        {name: "nivelDescripcion", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "tarea", type: "string"},
                        {name: "cantidad", type: "number"},
                        {name: "importe", type: "number"},
                        {name: "total", type: "number"}
                    ],
            root: "PersonalPresupuesto",
            record: "Personal",
            id: 'nivelGrado'
        };


        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "nivelDescripcion" || datafield === "total") {
                return "RowBold";
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
            showaggregates: true,
            showstatusbar: true,
            statusbarheight: 25,
            pagesize: 30,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var addCabeceraButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var deleteButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/delete42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var exportButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                container.append(addCabeceraButton);
                container.append(deleteButton);

                container.append(exportButton);
                toolbar.append(container);
                addCabeceraButton.jqxButton({width: 30, height: 22});
                addCabeceraButton.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                deleteButton.jqxButton({width: 30, height: 22});
                deleteButton.jqxTooltip({position: 'bottom', content: "Eliminar Registro"});

                exportButton.jqxButton({width: 30, height: 22});
                exportButton.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                // Adicionar un Nuevo Registro en la Cabecera.
                addCabeceraButton.click(function (event) {
                    mode = 'I';
                    fn_NuevoCab();
                });

                // delete selected row.
                deleteButton.click(function (event) {
                    mode = 'D';
                    fn_Eliminar();
                });
                // reload grid data.
                /*reloadButton.click(function (event) {
                 fn_Refrescar();
                 });*/
                //export to excel
                exportButton.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'SolicitudCreditoPresupuestal');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '10', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'PERSONAL', dataField: 'nivelDescripcion', filtertype: 'checkedlist', width: '10.4%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'CADENA DE GASTO', dataField: 'cadenaGasto', filtertype: 'checkedlist', width: '24%', align: 'left', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'TAREA', dataField: 'tarea', width: '24%', filtertype: 'checkedlist', align: 'left', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'CANTIDAD', dataField: 'cantidad', width: '10%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'importe', width: '15%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'TOTAL', dataField: 'total', width: '15%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 57, autoOpenPopup: false, mode: 'popup'});
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

        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['nivelGrado'];
            nivelDescripcion = row['nivelDescripcion'];
            cocaga = fn_extraerDatos(row['cadenaGasto'], ':');
            comeop = fn_extraerDatos(row['tarea'], ':');
        });

        //DEFINIMOS LOS EVENTOS SEGUN LA OPCION DEL MENU CONTEXTUAL
        $("#div_ContextMenu").on('itemclick', function (event) {
            var opcion = event.args;

            if ($.trim($(opcion).text()) === "Ver Detalle") {

                fn_verDetalle();
            } else {
                $.alert({
                    theme: 'material',
                    title: 'Mensaje!',
                    content: 'No hay Opcion a Mostar',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
            }
        });

        function fn_verDetalle() {

            $("#div_GrillaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../PersonalPresupuesto",
                data: {mode: 'GD', periodo: periodo, codConcepto: codConcepto, nivelGrado: codigo, nivelDescripcion: nivelDescripcion,
                    tarea: comeop, cadenaGasto: cocaga},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }

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
                    if (msg === "")
                        msg = fn_verificarCadenaGasto();
                    if (msg === "")
                        msg = fn_verificarTarea();
                    if (msg === "") {
                        $("#cbo_departamento").jqxDropDownList('clear');
                        $("#cbo_unidad").jqxDropDownList('clear');
                        $("#cbo_nivelGrado").jqxDropDownList('clear');
                        $("#cbo_grado").jqxDropDownList('clear');
                        $("#cbo_periodoREE").jqxDropDownList('clear');
                        fn_cargarComboAjax("#cbo_departamento", {mode: 'departamento'});
                        $('#div_cantidad').val(0);
                        $('#div_importe').val(0);
                        $('#div_total').val(0);
                        $("#cbo_tarea").jqxDropDownList('selectItem', 0);
                        $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_VentanaDetalle').jqxWindow('open');
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
                {text: 'DEPARTAMENTO', datafield: 'departamento', width: '15%', align: 'center', cellsAlign: 'center'},
                {text: 'UNIDAD', datafield: 'unidad', width: '15%', align: 'center', cellsAlign: 'center'},
                {text: 'PERSONAL', datafield: 'nivel', width: '15%', align: 'center', cellsAlign: 'center'},
                {text: 'GRADO', datafield: 'grado', width: '10%', align: 'center', cellsAlign: 'center'},
                {text: 'PERIODO REE', datafield: 'periodoRee', width: '15%', align: 'center', cellsAlign: 'center'},
                {text: 'CANTIDAD', dataField: 'cantidad', width: "15%", align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'importe', width: "15%", align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'TOTAL', dataField: 'total', width: "15%", align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass}
            ]
        });
    });
    //Funcion para Insertar un Nuevo Registro.
    function fn_NuevoCab() {
        cont = 0;
        contDetalle = 1;
        $('#div_GrillaRegistro').jqxGrid('clear');
        $('#div_VentanaDetalle').jqxGrid('clear');
        $("#cbo_cadenaGasto").jqxDropDownList('clear');
        $("#cbo_tarea").jqxDropDownList('clear');
        $("#cbo_periodoREE").jqxDropDownList({disabled: true});
        fn_cargarComboAjax("#cbo_cadenaGasto", {mode: 'cadenaGastoPers', periodo: periodo});
        $('#div_VentanaPrincipal').jqxWindow({title: 'PERSONAL Y OBLIGACIONES SOCIALES'});
        $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
        $('#div_VentanaPrincipal').jqxWindow('open');
    }
    //Funcion de Refrescar o Actulizar los datos de la Grilla.
    function fn_Eliminar() {

        if (codigo === null || codigo === '' || codigo === '0') {
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
                            fn_Grabar();
                        }
                    },
                    cancelar: function () {
                    }
                }
            });
        }
    }
    function fn_Refrescar() {
        $("#div_GrillaPrincipal").remove();
        $("#div_ContextMenu").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "POST",
            url: "../PersonalPresupuesto",
            data: {mode: 'G', periodo: periodo, codConcepto: codConcepto},
            success: function (data) {

                $contenidoAjax.html(data);
            }
        });
    }
    //Crea los Elementos de las Ventanas
    var customButtonsDemo = (function () {
        function _createElements() {
            //Inicia los Valores de Ventana de la Cabecera
            $('#div_VentanaPrincipal').jqxWindow({
                position: {x: 400, y: 100},
                width: 750, height: 600, resizable: false,
                cancelButton: $('#btn_Cancelar'),
                initContent: function () {
                    var codigo = $("#cbo_cadenaGasto").val();
                    fn_cargarComboAjax("#cbo_tarea", {mode: 'tareaPers', periodo: periodo, codigo: codigo});
                    $("#cbo_cadenaGasto").jqxDropDownList({animationType: 'fade', width: 350, height: 20});
                    $('#cbo_cadenaGasto').on('change', function () {
                        var codigo = $("#cbo_cadenaGasto").val();
                        fn_cargarComboAjax("#cbo_tarea", {mode: 'tareaPers', periodo: periodo, codigo: codigo});
                        $("#cbo_tarea").jqxDropDownList({width: 480, height: 20});
                    });
                    $("#cbo_tarea").jqxDropDownList({animationType: 'fade', width: 150, height: 20});
                    $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                    cocaga = $("#cbo_cadenaGasto").val();
                    comeop = $("#cbo_comeop").val();
                    $('#btn_Guardar').on('click', function () {
                        fn_Grabar();
                    });

                }
            });
            //Inicia los Valores de Ventana del Detalle
            $('#div_VentanaDetalle').jqxWindow({
                position: {x: 400, y: 200},
                width: 680, height: 320, resizable: false,
                cancelButton: $('#btn_CancelarDetalle'),
                initContent: function () {
                    $('#div_importe').val(0);
                    $("#cbo_periodoREE").jqxDropDownList({disabled: true});
                    $("#cbo_departamento").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                    $("#cbo_unidad").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                    $("#cbo_departamento").on('change', function () {
                        fn_cargarComboAjax("#cbo_unidad", {mode: 'unidadFuerza', periodo: periodo, unidadOperativa: $("#cbo_departamento").val()});
                    });
                    $("#cbo_unidad").on('change', function () {
                        fn_cargarComboAjax("#cbo_nivelGrado", {mode: 'nivelPersonal', periodo: periodo, unidadOperativa: codConcepto});
                    });
                    var codigo = $("#cbo_nivelGrado").val();
                    fn_cargarComboAjax("#cbo_nivelGrado", {mode: 'nivelPersonal', periodo: periodo, unidadOperativa: codConcepto, codigo: codigo});
                    $("#cbo_grado").jqxDropDownList({width: 200, height: 20});
                    fn_calcularTotal();
                    $("#cbo_nivelGrado").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                    $('#cbo_nivelGrado').on('change', function () {
                        var codigo = $("#cbo_nivelGrado").val();
                        fn_cargarComboAjax("#cbo_grado", {mode: 'gradoPersonal', periodo: periodo, unidadOperativa: codConcepto, codigo: codigo}); 
                        $("#cbo_grado").jqxDropDownList({width: 200, height: 20});
                        fn_calcularTotal();
                        fn_activarPeriodoREE();
                    });
                    $("#cbo_grado").jqxDropDownList({animationType: 'fade', width: 150, height: 20});
                    $("#cbo_periodoREE").jqxDropDownList({animationType: 'fade', width: 150, height: 20, disabled: true});
                    $('#cbo_grado').on('change', function () {
                        //VERIFICA EL PERSONAL PARA CARGAR EL COMBO O TEXTO
                        fn_verificarREE();
                        fn_calcularTotal();
                    });
                    $('#cbo_periodoREE').on('change', function () {
                        //CARGAR IMPORTE REENGANCHADOS
                        $.ajax({
                            type: "GET",
                            url: "../PersonalPresupuesto",
                            data: {mode: 'reeImp', periodo: periodo, codConcepto: codConcepto, nivelGrado: $("#cbo_nivelGrado").val(),
                                codGrado: $("#cbo_grado").val(), periodoRee: $("#cbo_periodoREE").val()},
                            success: function (data) {
                                $("#div_importe").val(data);
                            }
                        });
                        fn_calcularTotal();
                    });

                    $("#div_importe").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 3, disabled: true});
                    $("#div_importe").on('textchanged', function () {
                        fn_calcularTotal();
                    });
                    $("#div_cantidad").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                    $("#div_total").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 3, disabled: true});
                    $("#div_cantidad").on('textchanged', function () {
                        fn_calcularTotal();
                    });
                    $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});
                    $('#btn_GuardarDetalle').on('click', function (event) {
                        var msg = "";
                        if (msg === "")
                            msg = fn_verificarDepartamento();
                        if (msg === "")
                            msg = fn_verificarUnidad();
                        if (msg === "")
                            msg = fn_verificarNivelGrado();
                        if (msg === "")
                            msg = fn_verificarGrado();
                        if (msg === "")
                            msg = fn_validarCantidad();
                        if (msg === "")
                            msg = fn_verificarPeriodoRee();
                        if (msg === "")
                            msg = fn_verificarDatosGrillaReg();
                        if (msg === "") {
                            var depto = $("#cbo_departamento").jqxDropDownList('getSelectedItem');
                            if (depto === null) {
                                depto = "";
                            } else {
                                depto = depto.label;
                            }
                            var unidadPers = $("#cbo_unidad").jqxDropDownList('getSelectedItem');
                            if (unidadPers === null) {
                                unidadPers = "";
                            } else {
                                unidadPers = unidadPers.label;
                            }
                            var nivelGrado = $("#cbo_nivelGrado").jqxDropDownList('getSelectedItem');
                            if (nivelGrado === null) {
                                nivelGrado = "";
                            } else {
                                nivelGrado = nivelGrado.label;
                            }
                            var grado = $("#cbo_grado").jqxDropDownList('getSelectedItem');
                            if (grado === null) {
                                grado = "";
                            } else {
                                grado = grado.label;
                            }
                            var codNivelGrado = $("#cbo_nivelGrado").val();
                            var periodoRee = $("#cbo_periodoREE").jqxDropDownList('getSelectedItem');
                            if (codNivelGrado === "9") {
                                periodoRee = periodoRee.label;
                            } else {
                                periodoRee = "";
                            }
                            var codPeriodoRee = $("#cbo_periodoREE").val();
                            var codGrado = $("#cbo_grado").val();


                            var flat = "";
                            flat = fn_variableVerificacion();
                            //VALIDAR DATOS QUE NO EXISTAN EN LA GRILLA DETALLE
                            $.ajax({
                                type: "POST",
                                url: "../PersonalPresupuesto",
                                data: {mode: flat, periodo: periodo, codConcepto: codConcepto, nivelGrado: codNivelGrado,
                                    cadenaGasto: $("#cbo_cadenaGasto").val(), tarea: $("#cbo_tarea").val(), codGrado: codGrado,
                                    periodoRee: $("#cbo_periodoREE").val(), departamento: $("#cbo_departamento").val(),
                                    unidad: $("#cbo_unidad").val},
                                success: function (data) {
                                    msg = data;
                                    if (msg === "EXISTE") {
                                        $.alert({
                                            theme: 'material',
                                            title: 'AVISO DEL SISTEMA',
                                            content: "Datos ya se encuentran registrados, revise.",
                                            animation: 'zoom',
                                            closeAnimation: 'zoom',
                                            type: 'red',
                                            typeAnimated: true
                                        });
                                    } else {
                                        var row = {
                                            departamento: depto,
                                            codDepto: $("#cbo_departamento").val(),
                                            unidad: unidadPers,
                                            unidadCod: $("#cbo_unidad").val(),
                                            nivel: nivelGrado,
                                            grado: grado,
                                            codNivel: codNivelGrado, codGrado: codGrado,
                                            periodoRee: periodoRee, codPeriodoRee: codPeriodoRee,
                                            importe: parseFloat($("#div_importe").jqxNumberInput('decimal')),
                                            cantidad: parseFloat($("#div_cantidad").jqxNumberInput('decimal')),
                                            total: parseFloat($("#div_total").jqxNumberInput('decimal'))};
                                        $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
                                        $("#div_VentanaDetalle").jqxWindow('hide');
                                        contDetalle = contDetalle + 1;
                                    }
                                }
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
    function fn_variableVerificacion() {
        var nivel = "";
        var dato = "";
        nivel = $("#cbo_nivelGrado").val();
        //REENGANCHADOS
        if (nivel === "9") {
            dato = "B";
        } else {
            dato = "V";
        }
        return dato;
    }
    function fn_verificarREE() {
        var dato = "";
        $("#div_importe").val(0);

        dato = $("#cbo_nivelGrado").val();
        if (dato === "9") {
            var codgrd = $("#cbo_grado").val();
            fn_cargarComboAjax("#cbo_periodoREE", 'periodoREE', periodo, 0, codConcepto, dato, codgrd, 0, 0, 0);
            $("#cbo_periodoREE").jqxDropDownList({width: 130, height: 20});
            fn_calcularTotal();
        } else {
            $("#cbo_periodoREE").jqxDropDownList('clear');
            $.ajax({
                type: "GET",
                url: "../PersonalPresupuesto",
                data: {mode: 'gradoImp', periodo: periodo, codConcepto: codConcepto, nivelGrado: $("#cbo_nivelGrado").val(), codGrado: $("#cbo_grado").val()},
                success: function (data) {
                    $("#div_importe").val(data);
                }
            });
        }
    }
    function fn_verificarPeriodoRee() {
        var msg = "";
        var dato = "";
        var nivel = "";
        nivel = $("#cbo_nivelGrado").val();
        //NIVEL DE REENGANCHADO
        if (nivel === "9") {
            dato = $("#cbo_periodoREE").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el periodo de reenganche";
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
        } else {
            return "";
        }
    }
    function fn_calcularTotal() {
        $('#div_total').val('0');
        var cantidad = $("#div_cantidad").val();
        var importe = $("#div_importe").val();
        cantidad = parseFloat(cantidad);
        importe = parseFloat(importe);
        var total = cantidad * importe;
        if (isNaN(total))
            total = '0';
        $('#div_total').val(total);
    }
    function fn_verificarCadenaGasto() {
        var msg = "";
        var dato = "";
        dato = $("#cbo_cadenaGasto").val();
        if (dato === "" || dato === "0") {
            msg = "Seleccione la cadena gasto";
            $("#jqxInformativo").text(msg);
            $("#jqxInformativo").jqxNotification("open");
        }
        return msg;
    }
    function fn_verificarTarea() {
        var msg = "";
        var dato = "";
        dato = $("#cbo_tarea").val();
        if (dato === "" || dato === "0") {
            msg = "Seleccione la tarea presupuestal";
            $("#jqxInformativo").text(msg);
            $("#jqxInformativo").jqxNotification("open");
        }
        return msg;
    }
    function fn_verificarDepartamento() {
        var msg = "";
        var dato = "";
        dato = $("#cbo_departamento").val();
        if (dato === "" || dato === "0" || dato === null) {
            msg = "Seleccione el departamento";
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

    function fn_verificarUnidad() {
        var msg = "";
        var dato = "";
        dato = $("#cbo_unidad").val();
        if (dato === "" || dato === "0" || dato === null) {
            msg = "Seleccione la unidad";
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

    function fn_verificarNivelGrado() {
        var msg = "";
        var dato = "";
        dato = $("#cbo_nivelGrado").val();
        if (dato === "" || dato === "0" || dato === null) {
            msg = "Seleccione el nivel personal";
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
    function fn_verificarGrado() {
        var msg = "";
        var dato = "";
        dato = $("#cbo_grado").val();
        if (dato === "" || dato === "0" || dato === null) {
            msg = "Seleccione el grado";
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
    function fn_validarCantidad() {
        var msg = "";
        var cantidad = $("#div_cantidad").val();
        cantidad = parseFloat(cantidad);
        if (cantidad <= 0) {
            msg = "Ingrese la cantidad de efectivos.";
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
    function fn_activarPeriodoREE() {
        var dato = "";
        dato = $("#cbo_nivelGrado").val();
        if (dato === "9") {
            $("#cbo_periodoREE").jqxDropDownList({disabled: false});
        } else {
            $("#cbo_periodoREE").jqxDropDownList({disabled: true});
        }
    }
    //VERIFICAR QUE DATOS NO ESTEN EN LA GRILLA
    function fn_verificarDatosGrillaReg() {
        var depto = $("#cbo_departamento").val();
        var unidad = $("#cbo_unidad").val();
        var nivel = $("#cbo_nivelGrado").val();
        var grado = $("#cbo_grado").val();
        var periodoRee = $("#cbo_periodoREE").val();
        var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
        var grilla = "";
        var msg = "";
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            if (nivel === "9") {
                grilla = row.codDepto + "-" + row.unidadCod + "-" + row.codNivel + "-" + row.codGrado + "-" + row.codPeriodoRee;

                if (grilla === depto + "-" + unidad + "-" + nivel + "-" + grado + "-" + periodoRee) {
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
            } else {
                grilla = row.codDepto + "-" + row.unidadCod + "-" + row.codNivel + "-" + row.codGrado;
                if (grilla === depto + "-" + unidad + "-" + nivel + "-" + grado) {
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
        }
        return "";
    }
    function fn_Grabar() {

        var cadenaGasto = $('#cbo_cadenaGasto').val();
        var tarea = $('#cbo_tarea').val();
        var lista = new Array();
        var result;
        var msgVal = "";
        if (mode === 'I') {

            msgVal = fn_verificarCadenaGasto();
            msgVal = fn_verificarTarea();

            if (msgVal === "") {
                var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    result = row.codDepto + "---" + row.unidadCod + "---" + row.codNivel + "---" + row.codGrado + "---"
                            + row.codPeriodoRee + "---" + row.cantidad + "---" + row.importe;
                    lista.push(result);
                }
                $.ajax({
                    type: "POST",
                    url: "../IduPersonalPresupuesto",
                    data: {mode: mode, periodo: periodo, codConcepto: codConcepto, nivelGrado: $('#cbo_nivelGrado').val(),
                        cadenaGasto: cadenaGasto, tarea: tarea,
                        lista: JSON.stringify(lista)},
                    success: function (data) {
                        msg = data;

                        if (msg === "GUARDO") {
                            $("#jqxExitoso").jqxNotification("open");
                            // 
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
        } else {

            $.ajax({
                type: "POST",
                url: "../IduPersonalPresupuesto",
                data: {mode: mode, periodo: periodo, codConcepto: codConcepto, nivelGrado: codigo},
                success: function (data) {
                    msg = data;
                    if (msg === "GUARDO") {
                        $("#jqxExitoso").jqxNotification("open");
                        // 
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

</script>
<table id='div_GrillaCabecera' style="display: none">
    <thead>
        <tr>
            <th>nivelGrado</th>
            <th>nivelDescripcion</th>
            <th>cadenaGasto</th>
            <th>tarea</th>
            <th>cantidad</th>
            <th>importe</th>
            <th>total</th>            
        </tr>
    </thead>
    <tbody>
        <c:forEach var="c" items="${objPersonalPresupuesto}">
            <tr>
                <td>${c.nivelGrado}</td>
                <td>${c.nivelDescripcion}</td>
                <td>${c.cadenaGasto}</td>
                <td>${c.tarea}</td>
                <td>${c.cantidad}</td>
                <td>${c.importe}</td>
                <td>${c.total}</td>                
            </tr>
        </c:forEach> 
    </tbody>
</table>
<div id="div_GrillaPrincipal"></div>
<div id="cbo_Ajax"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">PERSONAL Y OBLIGACIONES SOCIALES</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_cadenaGasto" name="frm_cadenaGasto" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <div id="exitoso" style="position: fixed"></div>  
                        <div id="fail" style="position: fixed"></div>  
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Cadena de Gasto : </td>
                    <td colspan="5" >
                        <select id="cbo_cadenaGasto" name="cbo_cadenaGasto">
                            <option value="0">Seleccione</option>

                        </select>
                    </td>
                    <td>
                        <div id="container" style="position: fixed"></div>

                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Tarea : </td>
                    <td colspan="5" >
                        <select id="cbo_tarea" name="cbo_tarea">
                            <option value="0">Seleccione</option>

                        </select>
                    </td>
                    <td>
                        <div id="container" style="position: fixed"></div>

                    </td>
                </tr>                 
                <tr>
                    <td class="Summit" colspan="6">
                        <div>

                            <input type="button" id="btn_Cancelar" value="Cancelar" style="margin-right: 20px"/>
                            <input type="button" id="btn_Guardar"  value="Guardar" style="margin-right: 20px" />
                        </div>
                    </td>
                </tr>
            </table>            
            <table id="div_GrillaRegistro">
                <thead>
                    <tr>
                        <th>nivel</th>
                        <th>grado</th>
                        <th>periodoRee</th>
                        <th>cantidad</th>                        
                        <th>importe</th>            
                        <th>total</th>                        
                    </tr>
                </thead>                
            </table>
            <div style="display: none" id="div_VentanaDetalle">
                <div>
                    <span style="float: left">DETALLE PERSONAL Y OBLIGACIONES SOCIALES</span>
                </div>
                <div style="overflow: hidden"> 

                    <table width="100%" border="0" cellspacing="0" cellpadding="0">   

                        <tr>
                            <td class="inputlabel">Departamento : </td>
                            <td >
                                <select id="cbo_departamento" name="cbo_departamento">
                                    <option value="0">Seleccione</option>

                                </select>
                            </td>
                            <td class="inputlabel">Unidad : </td>
                            <td colspan="3">
                                <select id="cbo_unidad" name="cbo_unidad">
                                    <option value="0">Seleccione</option>

                                </select>
                            </td>    
                        </tr>
                        <tr>
                            <td class="inputlabel">Personal : </td>
                            <td colspan="3">
                                <select id="cbo_nivelGrado" name="cbo_nivelGrado">
                                    <option value="0">Seleccione</option>

                                </select>
                            </td>

                        </tr>
                        <tr>
                            <td class="inputlabel">Grado : </td>
                            <td >
                                <select id="cbo_grado" name="cbo_grado">
                                    <option value="0">Seleccione</option>                                
                                </select>
                            </td>
                            <td class="inputlabel">Periodo REE : </td>
                            <td >
                                <select id="cbo_periodoREE" name="cbo_periodoREE" >
                                    <option value="0">Seleccione</option>                                
                                </select>
                            </td>
                        </tr> 
                        <tr>
                            <td class="inputlabel">Cantidad : </td>
                            <td><div id="div_cantidad"></div>  
                            </td>  

                        </tr> 
                        <tr>
                            <td class="inputlabel">Importe S/. : </td>
                            <td><div id="div_importe"></div></td>
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
<div id="jqxInformativo"></div></div>
<div id="jqxExitoso">Datos Guardados Exitosamente!!</div>
<div id="jqxFail"></div>
<div id='div_ContextMenu' style='display: none;' >
    <ul>       
        <li>Ver Detalle</li>        
    </ul>
</div>
