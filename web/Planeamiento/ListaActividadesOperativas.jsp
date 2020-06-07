<%-- 
    Document   : ListaActividadesOperativas
    Created on : 21/11/2019, 07:20:44 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var objetivo = $("#cbo_Objetivo").val();
    var accion = $("#cbo_Accion").val();
    var codigo = null;
    var detalle = null;
    var mode = null;
    var modeDetalle = null;
    var categoria = null;
    var producto = null;
    var actividad = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objActividadesOperativas}">
    var result = {codigo: '${d.codigo}', descripcion: '${d.descripcion}', prioridad: '${d.prioridad}',
        categoriaPresupuestal: '${d.categoriaPresupuestal}', producto: '${d.producto}', actividad: '${d.actividad}',
        unidadMedida: '${d.unidadMedida}', estado: '${d.estado}'};
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
                        {name: 'prioridad', type: "number"},
                        {name: 'categoriaPresupuestal', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'actividad', type: "string"},
                        {name: 'unidadMedida', type: "string"},
                        {name: 'estado', type: "string"}
                    ],
            root: "ActividadesOperativas",
            record: "ActividadesOperativas",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //PARA GRILLA DE LA VENTANA SECUNDARIA - DETALLE
        var sourceDetalle = {
            datafields:
                    [
                        {name: "detalle", type: "string"},
                        {name: "tareaOperativa", type: "string"},
                        {name: "ubigeo", type: "string"},
                        {name: "montoA", type: "number"},
                        {name: "montoB", type: "number"},
                        {name: "montoC", type: "number"},
                        {name: "cantidadA", type: "number"},
                        {name: "cantidadB", type: "number"},
                        {name: "cantidadC", type: "number"}
                    ],
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            },
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            },
            updaterow: function (rowid, rowdata, commit) {
                commit(true);
            }
        };
        var dataDetalle = new $.jqx.dataAdapter(sourceDetalle);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (rowdata['estado'] === "ANULADO") {
                return "RowAnulado";
            }
            if (datafield === "prioridad") {
                return "RowBold";
            }
        };
        //DEFINIMOS LOS CAMPOS Y DATOS DE LA GRILLA
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 79),
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
            showtoolbar: true,
            editable: false,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonExportar);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    codigo = 0;
                    $.ajax({
                        type: "GET",
                        url: "../ActividadesOperativas",
                        data: {mode: mode, periodo: periodo, objetivo: objetivo, accion: accion},
                        success: function (data) {
                            $("#div_Prioridad").val(data);
                        }
                    });
                    $("#txt_Descripcion").val('');
                    $("#cbo_CategoriaPresupuestal").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_Producto").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_Actividad").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_UnidadMedida").jqxDropDownList('setContent', 'Seleccione');
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'POI-ActividadesOperativas');
                });
            },
            columns: [
                {text: 'PRIORIDAD', dataField: 'prioridad', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DESCRIPCIÓN', dataField: 'descripcion', width: '30%', align: 'center', cellclassname: cellclass},
                {text: 'ACTIVIDAD PPTAL', dataField: 'actividad', width: '22%', align: 'center', cellclassname: cellclass},
                {text: 'PRODUCTO', dataField: 'producto', filtertype: 'checkedlist', width: '12%', align: 'center', cellclassname: cellclass},
                {text: 'CAT. PPTAL', dataField: 'categoriaPresupuestal', width: '12%', align: 'center', cellclassname: cellclass},
                {text: 'UNI. MEDIDA', dataField: 'unidadMedida', filtertype: 'checkedlist', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var alto = 82;
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
                if (parseInt(event.args.originalEvent.clientY) > 700) {
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
                } else if ($.trim($(opcion).text()) === "Ingresar Detalle") {
                    fn_CargarGrillaDetalle();
                    $('#div_VentanaSecundaria').jqxWindow({isModal: true, modalOpacity: 0.5});
                    $('#div_VentanaSecundaria').jqxWindow('open');
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'Opcion no Valida',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
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
            categoria = row['categoriaPresupuestal'].substring(0, 4);
            producto = row['producto'].substring(0, 7);
            actividad = row['actividad'].substring(0, 7);
            $("#cbo_CategoriaPresupuestal").val(categoria);
        });
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: '100%',
            source: dataDetalle,
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
                    detalle = 0;
                    $("#cbo_TareaOperativa").jqxDropDownList('setContent', "Seleccione");
                    $("#cbo_Ubigeo").jqxDropDownList('setContent', "Seleccione");
                    $('#div_MontoEneroA').val(0);
                    $('#div_MontoFebreroA').val(0);
                    $('#div_MontoMarzoA').val(0);
                    $('#div_MontoAbrilA').val(0);
                    $('#div_MontoMayoA').val(0);
                    $('#div_MontoJunioA').val(0);
                    $('#div_MontoJulioA').val(0);
                    $('#div_MontoAgostoA').val(0);
                    $('#div_MontoSetiembreA').val(0);
                    $('#div_MontoOctubreA').val(0);
                    $('#div_MontoNoviembreA').val(0);
                    $('#div_MontoDiciembreA').val(0);
                    $('#div_MontoEneroB').val(0);
                    $('#div_MontoFebreroB').val(0);
                    $('#div_MontoMarzoB').val(0);
                    $('#div_MontoAbrilB').val(0);
                    $('#div_MontoMayoB').val(0);
                    $('#div_MontoJunioB').val(0);
                    $('#div_MontoJulioB').val(0);
                    $('#div_MontoAgostoB').val(0);
                    $('#div_MontoSetiembreB').val(0);
                    $('#div_MontoOctubreB').val(0);
                    $('#div_MontoNoviembreB').val(0);
                    $('#div_MontoDiciembreB').val(0);
                    $('#div_MontoEneroC').val(0);
                    $('#div_MontoFebreroC').val(0);
                    $('#div_MontoMarzoC').val(0);
                    $('#div_MontoAbrilC').val(0);
                    $('#div_MontoMayoC').val(0);
                    $('#div_MontoJunioC').val(0);
                    $('#div_MontoJulioC').val(0);
                    $('#div_MontoAgostoC').val(0);
                    $('#div_MontoSetiembreC').val(0);
                    $('#div_MontoOctubreC').val(0);
                    $('#div_MontoNoviembreC').val(0);
                    $('#div_MontoDiciembreC').val(0);
                    $('#div_CantidadEneroA').val(0);
                    $('#div_CantidadFebreroA').val(0);
                    $('#div_CantidadMarzoA').val(0);
                    $('#div_CantidadAbrilA').val(0);
                    $('#div_CantidadMayoA').val(0);
                    $('#div_CantidadJunioA').val(0);
                    $('#div_CantidadJulioA').val(0);
                    $('#div_CantidadAgostoA').val(0);
                    $('#div_CantidadSetiembreA').val(0);
                    $('#div_CantidadOctubreA').val(0);
                    $('#div_CantidadNoviembreA').val(0);
                    $('#div_CantidadDiciembreA').val(0);
                    $('#div_CantidadEneroB').val(0);
                    $('#div_CantidadFebreroB').val(0);
                    $('#div_CantidadMarzoB').val(0);
                    $('#div_CantidadAbrilB').val(0);
                    $('#div_CantidadMayoB').val(0);
                    $('#div_CantidadJunioB').val(0);
                    $('#div_CantidadJulioB').val(0);
                    $('#div_CantidadAgostoB').val(0);
                    $('#div_CantidadSetiembreB').val(0);
                    $('#div_CantidadOctubreB').val(0);
                    $('#div_CantidadNoviembreB').val(0);
                    $('#div_CantidadDiciembreB').val(0);
                    $('#div_CantidadEneroC').val(0);
                    $('#div_CantidadFebreroC').val(0);
                    $('#div_CantidadMarzoC').val(0);
                    $('#div_CantidadAbrilC').val(0);
                    $('#div_CantidadMayoC').val(0);
                    $('#div_CantidadJunioC').val(0);
                    $('#div_CantidadJulioC').val(0);
                    $('#div_CantidadAgostoC').val(0);
                    $('#div_CantidadSetiembreC').val(0);
                    $('#div_CantidadOctubreC').val(0);
                    $('#div_CantidadNoviembreC').val(0);
                    $('#div_CantidadDiciembreC').val(0);
                    $("#cbo_TareaOperativa").jqxDropDownList({disabled: false});
                    $("#cbo_Ubigeo").jqxDropDownList({disabled: false});
                    $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaDetalle').jqxWindow('open');
                });
                editButtonDet.click(function (event) {
                    modeDetalle = 'U';
                    if (indiceDetalle >= 0) {
                        $.ajax({
                            type: "GET",
                            url: "../ActividadesOperativas",
                            data: {mode: 'M', periodo: periodo, objetivo: objetivo, accion: accion, actividades: codigo, codigo: detalle},
                            success: function (data) {
                                var dato = data.split("+++");
                                if (dato.length === 74) {
                                    $("#cbo_TareaOperativa").jqxDropDownList('selectItem', dato[0]);
                                    $("#cbo_Ubigeo").jqxDropDownList('selectItem', dato[1]);
                                    $('#div_MontoEneroA').val(parseFloat(dato[2]));
                                    $('#div_MontoFebreroA').val(parseFloat(dato[3]));
                                    $('#div_MontoMarzoA').val(parseFloat(dato[4]));
                                    $('#div_MontoAbrilA').val(parseFloat(dato[5]));
                                    $('#div_MontoMayoA').val(parseFloat(dato[6]));
                                    $('#div_MontoJunioA').val(parseFloat(dato[7]));
                                    $('#div_MontoJulioA').val(parseFloat(dato[8]));
                                    $('#div_MontoAgostoA').val(parseFloat(dato[9]));
                                    $('#div_MontoSetiembreA').val(parseFloat(dato[10]));
                                    $('#div_MontoOctubreA').val(parseFloat(dato[11]));
                                    $('#div_MontoNoviembreA').val(parseFloat(dato[12]));
                                    $('#div_MontoDiciembreA').val(parseFloat(dato[13]));
                                    $('#div_MontoEneroB').val(parseFloat(dato[14]));
                                    $('#div_MontoFebreroB').val(parseFloat(dato[15]));
                                    $('#div_MontoMarzoB').val(parseFloat(dato[16]));
                                    $('#div_MontoAbrilB').val(parseFloat(dato[17]));
                                    $('#div_MontoMayoB').val(parseFloat(dato[18]));
                                    $('#div_MontoJunioB').val(parseFloat(dato[19]));
                                    $('#div_MontoJulioB').val(parseFloat(dato[20]));
                                    $('#div_MontoAgostoB').val(parseFloat(dato[21]));
                                    $('#div_MontoSetiembreB').val(parseFloat(dato[22]));
                                    $('#div_MontoOctubreB').val(parseFloat(dato[23]));
                                    $('#div_MontoNoviembreB').val(parseFloat(dato[24]));
                                    $('#div_MontoDiciembreB').val(parseFloat(dato[25]));
                                    $('#div_MontoEneroC').val(parseFloat(dato[26]));
                                    $('#div_MontoFebreroC').val(parseFloat(dato[27]));
                                    $('#div_MontoMarzoC').val(parseFloat(dato[28]));
                                    $('#div_MontoAbrilC').val(parseFloat(dato[29]));
                                    $('#div_MontoMayoC').val(parseFloat(dato[30]));
                                    $('#div_MontoJunioC').val(parseFloat(dato[31]));
                                    $('#div_MontoJulioC').val(parseFloat(dato[32]));
                                    $('#div_MontoAgostoC').val(parseFloat(dato[33]));
                                    $('#div_MontoSetiembreC').val(parseFloat(dato[34]));
                                    $('#div_MontoOctubreC').val(parseFloat(dato[35]));
                                    $('#div_MontoNoviembreC').val(parseFloat(dato[36]));
                                    $('#div_MontoDiciembreC').val(parseFloat(dato[37]));
                                    $('#div_CantidadEneroA').val(parseFloat(dato[38]));
                                    $('#div_CantidadFebreroA').val(parseFloat(dato[39]));
                                    $('#div_CantidadMarzoA').val(parseFloat(dato[40]));
                                    $('#div_CantidadAbrilA').val(parseFloat(dato[41]));
                                    $('#div_CantidadMayoA').val(parseFloat(dato[42]));
                                    $('#div_CantidadJunioA').val(parseFloat(dato[43]));
                                    $('#div_CantidadJulioA').val(parseFloat(dato[44]));
                                    $('#div_CantidadAgostoA').val(parseFloat(dato[45]));
                                    $('#div_CantidadSetiembreA').val(parseFloat(dato[46]));
                                    $('#div_CantidadOctubreA').val(parseFloat(dato[47]));
                                    $('#div_CantidadNoviembreA').val(parseFloat(dato[48]));
                                    $('#div_CantidadDiciembreA').val(parseFloat(dato[49]));
                                    $('#div_CantidadEneroB').val(parseFloat(dato[50]));
                                    $('#div_CantidadFebreroB').val(parseFloat(dato[51]));
                                    $('#div_CantidadMarzoB').val(parseFloat(dato[52]));
                                    $('#div_CantidadAbrilB').val(parseFloat(dato[53]));
                                    $('#div_CantidadMayoB').val(parseFloat(dato[54]));
                                    $('#div_CantidadJunioB').val(parseFloat(dato[55]));
                                    $('#div_CantidadJulioB').val(parseFloat(dato[56]));
                                    $('#div_CantidadAgostoB').val(parseFloat(dato[57]));
                                    $('#div_CantidadSetiembreB').val(parseFloat(dato[58]));
                                    $('#div_CantidadOctubreB').val(parseFloat(dato[59]));
                                    $('#div_CantidadNoviembreB').val(parseFloat(dato[60]));
                                    $('#div_CantidadDiciembreB').val(parseFloat(dato[61]));
                                    $('#div_CantidadEneroC').val(parseFloat(dato[62]));
                                    $('#div_CantidadFebreroC').val(parseFloat(dato[63]));
                                    $('#div_CantidadMarzoC').val(parseFloat(dato[64]));
                                    $('#div_CantidadAbrilC').val(parseFloat(dato[65]));
                                    $('#div_CantidadMayoC').val(parseFloat(dato[66]));
                                    $('#div_CantidadJunioC').val(parseFloat(dato[67]));
                                    $('#div_CantidadJulioC').val(parseFloat(dato[68]));
                                    $('#div_CantidadAgostoC').val(parseFloat(dato[69]));
                                    $('#div_CantidadSetiembreC').val(parseFloat(dato[70]));
                                    $('#div_CantidadOctubreC').val(parseFloat(dato[71]));
                                    $('#div_CantidadNoviembreC').val(parseFloat(dato[72]));
                                    $('#div_CantidadDiciembreC').val(parseFloat(dato[73]));
                                    $("#cbo_TareaOperativa").jqxDropDownList({disabled: true});
                                    $("#cbo_Ubigeo").jqxDropDownList({disabled: true});
                                }
                            }
                        });
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
                    if (indiceDetalle >= 0) {
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
                                        modeDetalle = 'D';
                                        fn_GrabarDatosDetalle();
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
            },
            columns: [
                {text: 'N°', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', align: 'center', columntype: 'number', width: '4%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'TAREA OPERATIVA', datafield: 'tareaOperativa', width: "30%", align: 'center'},
                {text: 'UBIGEO', datafield: 'ubigeo', width: "20%", align: 'center', cellsAlign: 'center'},
                {text: 'MONTO ' + parseInt(parseInt(periodo)), dataField: 'montoA', width: "15%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MET FIS ' + parseInt(parseInt(periodo)), dataField: 'cantidadA', width: "13%", align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MONTO ' + parseInt(parseInt(periodo) + 1), dataField: 'montoB', width: "15%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MET FIS ' + parseInt(parseInt(periodo) + 1), dataField: 'cantidadB', width: "13%", align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MONTO ' + parseInt(parseInt(periodo) + 2), dataField: 'montoC', width: "15%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MET FIS ' + parseInt(parseInt(periodo) + 2), dataField: 'cantidadC', width: "13%", align: 'center', cellsAlign: 'right', cellsFormat: 'number', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA DETALLE
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
            var row = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
            detalle = row['detalle'];
            $("#cbo_TareaOperativa").val(detalle.substring(0, detalle.indexOf('-')));
            $("#cbo_Ubigeo").val(detalle.substring(detalle.indexOf('-') + 1));
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 300;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#div_Prioridad").jqxNumberInput({width: 70, height: 20, inputMode: 'simple', digits: 4, decimalDigits: 0, min: 0, max: 9999, spinButtons: false});
                        $("#txt_Descripcion").jqxInput({placeHolder: 'DESCRIPCIÓN', width: 460, height: 95, minLength: 1, maxLength: 500});
                        $("#cbo_CategoriaPresupuestal").jqxDropDownList({width: 350, height: 20, dropDownWidth: 450});
                        $('#cbo_CategoriaPresupuestal').on('change', function () {
                            if (mode === 'I') {
                                $("#cbo_Producto").jqxDropDownList('clear');
                                $("#cbo_Actividad").jqxDropDownList('clear');
                            }
                            fn_cargarComboAjax("#cbo_Producto", {mode: 'productoTarea', periodo: periodo, codigo: $("#cbo_CategoriaPresupuestal").val()});
                        });
                        $("#cbo_Producto").jqxDropDownList({width: 350, height: 20, dropDownWidth: 450});
                        $('#cbo_Producto').on('change', function () {
                            if (mode === 'I') {
                                $("#cbo_Actividad").jqxDropDownList('clear');
                            }
                            fn_cargarComboAjax("#cbo_Actividad", {mode: 'actividadTarea', periodo: periodo, categoriaPresupuestal: $("#cbo_CategoriaPresupuestal").val(), producto: $("#cbo_Producto").val()});
                        });
                        $("#cbo_Actividad").jqxDropDownList({width: 350, height: 20, dropDownWidth: 450});
                        $("#cbo_UnidadMedida").jqxDropDownList({width: 210, height: 20, dropDownWidth: 250});
                        $("#cbo_Estado").jqxDropDownList({width: 150, height: 20});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            fn_GrabarDatos();
                        });
                    }
                });
                ancho = 750;
                alto = 500;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaSecundaria').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false
                });
                //Inicia los Valores de Ventana del Detalle
                ancho = 650;
                alto = 415;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaDetalle').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarDetalle'),
                    initContent: function () {
                        $("#cbo_TareaOperativa").jqxDropDownList({width: 420, height: 20, dropDownWidth: 550, animationType: 'fade', promptText: "Seleccione"});
                        $('#cbo_TareaOperativa').on('change', function () {
                            fn_cargarComboAjax("#cbo_Ubigeo", {mode: 'ubigeoActividad', periodo: periodo, categoriaPresupuestal: categoria,
                                producto: producto, actividad: actividad});
                        });
                        $("#cbo_Ubigeo").jqxDropDownList({width: 420, height: 20, dropDownWidth: 550, animationType: 'fade', promptText: "Seleccione"});
                        $("#div_MontoEneroA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoEneroA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoEneroB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoEneroB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoEneroC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoEneroC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_MontoFebreroA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoFebreroA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoFebreroB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoFebreroB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoFebreroC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoFebreroC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_MontoMarzoA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoMarzoA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoMarzoB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoMarzoB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoMarzoC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoMarzoC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_MontoAbrilA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoAbrilA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoAbrilB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoAbrilB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoAbrilC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoAbrilC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_MontoMayoA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoMayoA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoMayoB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoMayoB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoMayoC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoMayoC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_MontoJunioA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoJunioA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoJunioB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoJunioB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoJunioC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoJunioC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_MontoJulioA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoJulioA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoJulioB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoJulioB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoJulioC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoJulioC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_MontoAgostoA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoAgostoA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoAgostoB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoAgostoB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoAgostoC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoAgostoC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_MontoSetiembreA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoSetiembreA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoSetiembreB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoSetiembreB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoSetiembreC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoSetiembreC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_MontoOctubreA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoOctubreA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoOctubreB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoOctubreB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoOctubreC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoOctubreC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_MontoNoviembreA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoNoviembreA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoNoviembreB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoNoviembreB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoNoviembreC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoNoviembreC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_MontoDiciembreA").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoDiciembreA').on('textchanged', function (event) {
                            fn_TotalMensualizacion('A');
                        });
                        $("#div_MontoDiciembreB").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoDiciembreB').on('textchanged', function (event) {
                            fn_TotalMensualizacion('B');
                        });
                        $("#div_MontoDiciembreC").jqxNumberInput({width: 100, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#div_MontoDiciembreC').on('textchanged', function (event) {
                            fn_TotalMensualizacion('C');
                        });
                        $("#div_TotalA").jqxNumberInput({width: 100, height: 20, max: 9999999999, digits: 10, decimalDigits: 0, disabled: true});
                        $("#div_TotalB").jqxNumberInput({width: 100, height: 20, max: 9999999999, digits: 10, decimalDigits: 0, disabled: true});
                        $("#div_TotalC").jqxNumberInput({width: 100, height: 20, max: 9999999999, digits: 10, decimalDigits: 0, disabled: true});
                        $("#div_CantidadEneroA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadEneroA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadEneroB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadEneroB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadEneroC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadEneroC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadFebreroA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadFebreroA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadFebreroB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadFebreroB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadFebreroC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadFebreroC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadMarzoA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadMarzoA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadMarzoB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadMarzoB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadMarzoC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadMarzoC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadAbrilA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadAbrilA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadAbrilB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadAbrilB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadAbrilC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadAbrilC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadMayoA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadMayoA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadMayoB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadMayoB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadMayoC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadMayoC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadJunioA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadJunioA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadJunioB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadJunioB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadJunioC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadJunioC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadJulioA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadJulioA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadJulioB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadJulioB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadJulioC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadJulioC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadAgostoA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadAgostoA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadAgostoB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadAgostoB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadAgostoC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadAgostoC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadSetiembreA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadSetiembreA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadSetiembreB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadSetiembreB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadSetiembreC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadSetiembreC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadOctubreA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadOctubreA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadOctubreB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadOctubreB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadOctubreC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadOctubreC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadNoviembreA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadNoviembreA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadNoviembreB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadNoviembreB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadNoviembreC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadNoviembreC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadDiciembreA").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadDiciembreA').on('textchanged', function (event) {
                            fn_TotalMetaFisica('A');
                        });
                        $("#div_CantidadDiciembreB").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadDiciembreB').on('textchanged', function (event) {
                            fn_TotalMetaFisica('B');
                        });
                        $("#div_CantidadDiciembreC").jqxNumberInput({width: 70, height: 20, max: 999999, digits: 6, decimalDigits: 0});
                        $('#div_CantidadDiciembreC').on('textchanged', function (event) {
                            fn_TotalMetaFisica('C');
                        });
                        $("#div_CantidadTotalA").jqxNumberInput({width: 70, height: 20, max: 9999999, digits: 7, decimalDigits: 0, disabled: true});
                        $("#div_CantidadTotalB").jqxNumberInput({width: 70, height: 20, max: 9999999, digits: 7, decimalDigits: 0, disabled: true});
                        $("#div_CantidadTotalC").jqxNumberInput({width: 70, height: 20, max: 9999999, digits: 7, decimalDigits: 0, disabled: true});
                        $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').on('click', function (event) {
                            fn_GrabarDatosDetalle();
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
            fn_cargarComboAjax("#cbo_UnidadMedida", {mode: 'unidadMedida'});
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaSecundaria").remove();
            $("#div_GrillaRegistro").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../ActividadesOperativas",
                data: {mode: 'G', periodo: periodo, objetivo: objetivo, accion: accion},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../ActividadesOperativas",
                data: {mode: mode, periodo: periodo, objetivo: objetivo, accion: accion, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 7) {
                        $("#cbo_Producto").val(dato[3]);
                        $("#txt_Descripcion").val(dato[0]);
                        $("#div_Prioridad").val(dato[1]);
                        $("#cbo_UnidadMedida").val(dato[5]);
                        $("#cbo_Estado").val(dato[6]);
                        $("#cbo_Actividad").jqxDropDownList('addItem', {label: dato[4], value: dato[4].substring(0, 7)});
                        $("#cbo_Actividad").val(dato[4].substring(0, 7));
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var prioridad = $("#div_Prioridad").val();
            var descripcion = $("#txt_Descripcion").val();
            var categoriaPresupuestal = $("#cbo_CategoriaPresupuestal").val();
            var producto = $("#cbo_Producto").val();
            var actividad = $("#cbo_Actividad").val();
            var unidadMedida = $("#cbo_UnidadMedida").val();
            var estado = $("#cbo_Estado").val();
            $.ajax({
                type: "POST",
                url: "../IduActividadesOperativas",
                data: {mode: mode, periodo: periodo, objetivo: objetivo, accion: accion, codigo: codigo,
                    prioridad: prioridad, descripcion: descripcion, categoriaPresupuestal: categoriaPresupuestal,
                    producto: producto, actividad: actividad, unidadMedida: unidadMedida, estado: estado},
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
    function fn_CargarGrillaDetalle() {
        fn_cargarComboAjax("#cbo_TareaOperativa", {mode: 'tareaOperativa'});
        $('#div_GrillaRegistro').jqxGrid('clear');
        $.ajax({
            type: "GET",
            url: "../ActividadesOperativas",
            data: {mode: 'B', periodo: periodo, objetivo: objetivo, accion: accion, codigo: codigo},
            success: function (data) {
                data = data.replace("[", "");
                var fila = data.split("[");
                var rows = new Array();
                for (i = 1; i < fila.length; i++) {
                    var columna = fila[i];
                    var datos = columna.split("+++");
                    while (datos[8].indexOf(']') > 0) {
                        datos[8] = datos[8].replace("]", "");
                    }
                    while (datos[8].indexOf(',') > 0) {
                        datos[8] = datos[8].replace(",", "");
                    }
                    var row = {detalle: datos[0], tareaOperativa: datos[1], ubigeo: datos[2],
                        montoA: parseFloat(datos[3]), cantidadA: parseInt(datos[6]),
                        montoB: parseFloat(datos[4]), cantidadB: parseInt(datos[7]),
                        montoC: parseFloat(datos[5]), cantidadC: parseInt(datos[8])};
                    rows.push(row);
                }
                if (rows.length > 0)
                    $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
            }
        });
    }
    //FUNCION PARA VALIDAR EL TOTAL DE CREDITO Y NO GENERE SALDO NEGATIVO
    function fn_TotalMensualizacion(valor) {
        var total = $("#div_MontoEnero" + valor).val() + $("#div_MontoFebrero" + valor).val() +
                $("#div_MontoMarzo" + valor).val() + $("#div_MontoAbril" + valor).val() + $("#div_MontoMayo" + valor).val() +
                $("#div_MontoJunio" + valor).val() + $("#div_MontoJulio" + valor).val() + $("#div_MontoAgosto" + valor).val() +
                $("#div_MontoSetiembre" + valor).val() + $("#div_MontoOctubre" + valor).val() + $("#div_MontoNoviembre" + valor).val() +
                $("#div_MontoDiciembre" + valor).val();
        $("#div_Total" + valor).val(parseFloat(total));
    }
    function fn_TotalMetaFisica(valor) {
        var total = $("#div_CantidadEnero" + valor).val() + $("#div_CantidadFebrero" + valor).val() +
                $("#div_CantidadMarzo" + valor).val() + $("#div_CantidadAbril" + valor).val() + $("#div_CantidadMayo" + valor).val() +
                $("#div_CantidadJunio" + valor).val() + $("#div_CantidadJulio" + valor).val() + $("#div_CantidadAgosto" + valor).val() +
                $("#div_CantidadSetiembre" + valor).val() + $("#div_CantidadOctubre" + valor).val() + $("#div_CantidadNoviembre" + valor).val() +
                $("#div_CantidadDiciembre" + valor).val();
        $("#div_CantidadTotal" + valor).val(parseFloat(total));
    }
    function fn_GrabarDatosDetalle() {
        var tareaOperativa = $("#cbo_TareaOperativa").val();
        var ubigeo = $("#cbo_Ubigeo").val();
        var montoEneroA = parseFloat($("#div_MontoEneroA").jqxNumberInput('decimal'));
        var montoFebreroA = parseFloat($("#div_MontoFebreroA").jqxNumberInput('decimal'));
        var montoMarzoA = parseFloat($("#div_MontoMarzoA").jqxNumberInput('decimal'));
        var montoAbrilA = parseFloat($("#div_MontoAbrilA").jqxNumberInput('decimal'));
        var montoMayoA = parseFloat($("#div_MontoMayoA").jqxNumberInput('decimal'));
        var montoJunioA = parseFloat($("#div_MontoJunioA").jqxNumberInput('decimal'));
        var montoJulioA = parseFloat($("#div_MontoJulioA").jqxNumberInput('decimal'));
        var montoAgostoA = parseFloat($("#div_MontoAgostoA").jqxNumberInput('decimal'));
        var montoSetiembreA = parseFloat($("#div_MontoSetiembreA").jqxNumberInput('decimal'));
        var montoOctubreA = parseFloat($("#div_MontoOctubreA").jqxNumberInput('decimal'));
        var montoNoviembreA = parseFloat($("#div_MontoNoviembreA").jqxNumberInput('decimal'));
        var montoDiciembreA = parseFloat($("#div_MontoDiciembreA").jqxNumberInput('decimal'));
        var montoEneroB = parseFloat($("#div_MontoEneroB").jqxNumberInput('decimal'));
        var montoFebreroB = parseFloat($("#div_MontoFebreroB").jqxNumberInput('decimal'));
        var montoMarzoB = parseFloat($("#div_MontoMarzoB").jqxNumberInput('decimal'));
        var montoAbrilB = parseFloat($("#div_MontoAbrilB").jqxNumberInput('decimal'));
        var montoMayoB = parseFloat($("#div_MontoMayoB").jqxNumberInput('decimal'));
        var montoJunioB = parseFloat($("#div_MontoJunioB").jqxNumberInput('decimal'));
        var montoJulioB = parseFloat($("#div_MontoJulioB").jqxNumberInput('decimal'));
        var montoAgostoB = parseFloat($("#div_MontoAgostoB").jqxNumberInput('decimal'));
        var montoSetiembreB = parseFloat($("#div_MontoSetiembreB").jqxNumberInput('decimal'));
        var montoOctubreB = parseFloat($("#div_MontoOctubreB").jqxNumberInput('decimal'));
        var montoNoviembreB = parseFloat($("#div_MontoNoviembreB").jqxNumberInput('decimal'));
        var montoDiciembreB = parseFloat($("#div_MontoDiciembreB").jqxNumberInput('decimal'));
        var montoEneroC = parseFloat($("#div_MontoEneroC").jqxNumberInput('decimal'));
        var montoFebreroC = parseFloat($("#div_MontoFebreroC").jqxNumberInput('decimal'));
        var montoMarzoC = parseFloat($("#div_MontoMarzoC").jqxNumberInput('decimal'));
        var montoAbrilC = parseFloat($("#div_MontoAbrilC").jqxNumberInput('decimal'));
        var montoMayoC = parseFloat($("#div_MontoMayoC").jqxNumberInput('decimal'));
        var montoJunioC = parseFloat($("#div_MontoJunioC").jqxNumberInput('decimal'));
        var montoJulioC = parseFloat($("#div_MontoJulioC").jqxNumberInput('decimal'));
        var montoAgostoC = parseFloat($("#div_MontoAgostoC").jqxNumberInput('decimal'));
        var montoSetiembreC = parseFloat($("#div_MontoSetiembreC").jqxNumberInput('decimal'));
        var montoOctubreC = parseFloat($("#div_MontoOctubreC").jqxNumberInput('decimal'));
        var montoNoviembreC = parseFloat($("#div_MontoNoviembreC").jqxNumberInput('decimal'));
        var montoDiciembreC = parseFloat($("#div_MontoDiciembreC").jqxNumberInput('decimal'));
        var cantidadEneroA = parseInt($("#div_CantidadEneroA").val());
        var cantidadFebreroA = parseInt($("#div_CantidadFebreroA").val());
        var cantidadMarzoA = parseInt($("#div_CantidadMarzoA").val());
        var cantidadAbrilA = parseInt($("#div_CantidadAbrilA").val());
        var cantidadMayoA = parseInt($("#div_CantidadMayoA").val());
        var cantidadJunioA = parseInt($("#div_CantidadJunioA").val());
        var cantidadJulioA = parseInt($("#div_CantidadJulioA").val());
        var cantidadAgostoA = parseInt($("#div_CantidadAgostoA").val());
        var cantidadSetiembreA = parseInt($("#div_CantidadSetiembreA").val());
        var cantidadOctubreA = parseInt($("#div_CantidadOctubreA").val());
        var cantidadNoviembreA = parseInt($("#div_CantidadNoviembreA").val());
        var cantidadDiciembreA = parseInt($("#div_CantidadDiciembreA").val());
        var cantidadEneroB = parseInt($("#div_CantidadEneroB").val());
        var cantidadFebreroB = parseInt($("#div_CantidadFebreroB").val());
        var cantidadMarzoB = parseInt($("#div_CantidadMarzoB").val());
        var cantidadAbrilB = parseInt($("#div_CantidadAbrilB").val());
        var cantidadMayoB = parseInt($("#div_CantidadMayoB").val());
        var cantidadJunioB = parseInt($("#div_CantidadJunioB").val());
        var cantidadJulioB = parseInt($("#div_CantidadJulioB").val());
        var cantidadAgostoB = parseInt($("#div_CantidadAgostoB").val());
        var cantidadSetiembreB = parseInt($("#div_CantidadSetiembreB").val());
        var cantidadOctubreB = parseInt($("#div_CantidadOctubreB").val());
        var cantidadNoviembreB = parseInt($("#div_CantidadNoviembreB").val());
        var cantidadDiciembreB = parseInt($("#div_CantidadDiciembreB").val());
        var cantidadEneroC = parseInt($("#div_CantidadEneroC").val());
        var cantidadFebreroC = parseInt($("#div_CantidadFebreroC").val());
        var cantidadMarzoC = parseInt($("#div_CantidadMarzoC").val());
        var cantidadAbrilC = parseInt($("#div_CantidadAbrilC").val());
        var cantidadMayoC = parseInt($("#div_CantidadMayoC").val());
        var cantidadJunioC = parseInt($("#div_CantidadJunioC").val());
        var cantidadJulioC = parseInt($("#div_CantidadJulioC").val());
        var cantidadAgostoC = parseInt($("#div_CantidadAgostoC").val());
        var cantidadSetiembreC = parseInt($("#div_CantidadSetiembreC").val());
        var cantidadOctubreC = parseInt($("#div_CantidadOctubreC").val());
        var cantidadNoviembreC = parseInt($("#div_CantidadNoviembreC").val());
        var cantidadDiciembreC = parseInt($("#div_CantidadDiciembreC").val());
        $.ajax({
            type: "POST",
            url: "../IduActividadesOperativasDetalle",
            data: {mode: modeDetalle, periodo: periodo, objetivo: objetivo, accion: accion, actividades: codigo,
                tareaOperativa: tareaOperativa, ubigeo: ubigeo,
                montoEneroA: montoEneroA, montoFebreroA: montoFebreroA, montoMarzoA: montoMarzoA,
                montoAbrilA: montoAbrilA, montoMayoA: montoMayoA, montoJunioA: montoJunioA, montoJulioA: montoJulioA,
                montoAgostoA: montoAgostoA, montoSetiembreA: montoSetiembreA, montoOctubreA: montoOctubreA,
                montoNoviembreA: montoNoviembreA, montoDiciembreA: montoDiciembreA,
                montoEneroB: montoEneroB, montoFebreroB: montoFebreroB, montoMarzoB: montoMarzoB,
                montoAbrilB: montoAbrilB, montoMayoB: montoMayoB, montoJunioB: montoJunioB, montoJulioB: montoJulioB,
                montoAgostoB: montoAgostoB, montoSetiembreB: montoSetiembreB, montoOctubreB: montoOctubreB,
                montoNoviembreB: montoNoviembreB, montoDiciembreB: montoDiciembreB,
                montoEneroC: montoEneroC, montoFebreroC: montoFebreroC, montoMarzoC: montoMarzoC,
                montoAbrilC: montoAbrilC, montoMayoC: montoMayoC, montoJunioC: montoJunioC, montoJulioC: montoJulioC,
                montoAgostoC: montoAgostoC, montoSetiembreC: montoSetiembreC, montoOctubreC: montoOctubreC,
                montoNoviembreC: montoNoviembreC, montoDiciembreC: montoDiciembreC,
                cantidadEneroA: cantidadEneroA, cantidadFebreroA: cantidadFebreroA, cantidadMarzoA: cantidadMarzoA,
                cantidadAbrilA: cantidadAbrilA, cantidadMayoA: cantidadMayoA, cantidadJunioA: cantidadJunioA, cantidadJulioA: cantidadJulioA,
                cantidadAgostoA: cantidadAgostoA, cantidadSetiembreA: cantidadSetiembreA, cantidadOctubreA: cantidadOctubreA,
                cantidadNoviembreA: cantidadNoviembreA, cantidadDiciembreA: cantidadDiciembreA,
                cantidadEneroB: cantidadEneroB, cantidadFebreroB: cantidadFebreroB, cantidadMarzoB: cantidadMarzoB,
                cantidadAbrilB: cantidadAbrilB, cantidadMayoB: cantidadMayoB, cantidadJunioB: cantidadJunioB, cantidadJulioB: cantidadJulioB,
                cantidadAgostoB: cantidadAgostoB, cantidadSetiembreB: cantidadSetiembreB, cantidadOctubreB: cantidadOctubreB,
                cantidadNoviembreB: cantidadNoviembreB, cantidadDiciembreB: cantidadDiciembreB,
                cantidadEneroC: cantidadEneroC, cantidadFebreroC: cantidadFebreroC, cantidadMarzoC: cantidadMarzoC,
                cantidadAbrilC: cantidadAbrilC, cantidadMayoC: cantidadMayoC, cantidadJunioC: cantidadJunioC, cantidadJulioC: cantidadJulioC,
                cantidadAgostoC: cantidadAgostoC, cantidadSetiembreC: cantidadSetiembreC, cantidadOctubreC: cantidadOctubreC,
                cantidadNoviembreC: cantidadNoviembreC, cantidadDiciembreC: cantidadDiciembreC},
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
                                    fn_CargarGrillaDetalle();
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
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">POI - ACTIVIDADES OPERATIVAS INSTITUCIONAL</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_ActividadesOperativas" name="frm_ActividadesOperativas" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Prioridad : </td> 
                    <td colspan="3"><div id="div_Prioridad" name="div_Prioridad"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Descripción : </td>
                    <td colspan="3"><textarea id="txt_Descripcion" name="txt_Descripcion" style="text-transform: uppercase;"/></textarea></td>
                </tr>
                <tr>
                    <td class="inputlabel">Cat. Pptal. : </td>
                    <td colspan="3">
                        <select id="cbo_CategoriaPresupuestal" name="cbo_CategoriaPresupuestal">
                            <c:forEach var="e" items="${objCategoriaPresupuestal}">
                                <option value="${e.codigo}">${e.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Producto : </td>
                    <td colspan="3">
                        <select id="cbo_Producto" name="cbo_Producto">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Actividad : </td>
                    <td colspan="3">
                        <select id="cbo_Actividad" name="cbo_Actividad">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">UU MM : </td>
                    <td colspan="3">
                        <select id="cbo_UnidadMedida" name="cbo_UnidadMedida">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Estado : </td>
                    <td colspan="3">
                        <select id="cbo_Estado" name="cbo_Estado">
                            <option value="AC">ACTIVO</option> 
                            <option value="AN">ANULADO</option> 
                        </select>
                    </td>
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
<div id="div_VentanaSecundaria" style="display: none">
    <div>
        <span style="float: left">DETALLE DE ACTIVIDADES OPERATIVAS INSTITUCIONAL</span>
    </div>
    <div style="overflow: hidden">
        <div id="div_GrillaRegistro"></div>
        <div id="div_VentanaDetalle" style="display: none" >
            <div>
                <span style="float: left">REGISTRO DE ACTIVIDADES OPERATIVAS INSTITUCIONAL</span>
            </div>
            <div style="overflow: hidden">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td colspan="2" class="inputlabel">Tarea Operativa : </td>
                        <td colspan="5">
                            <select id="cbo_TareaOperativa" name="cbo_TareaOperativa">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="inputlabel">Ubigeo : </td>
                        <td colspan="5">
                            <select id="cbo_Ubigeo" name="cbo_Ubigeo">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                    </tr>
                    <tr class="TituloDetalle" style="text-align: center">
                        <td>Mes</td>
                        <td>Monto S/</td>
                        <td>Meta Fisica</td>
                        <td>Monto S/</td>
                        <td>Meta Fisica</td>
                        <td>Monto S/</td>
                        <td>Meta Fisica</td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Enero : </td>
                        <td><div id="div_MontoEneroA"></div></td>
                        <td><div id="div_CantidadEneroA"></div></td>
                        <td><div id="div_MontoEneroB"></div></td>
                        <td><div id="div_CantidadEneroB"></div></td>
                        <td><div id="div_MontoEneroC"></div></td>
                        <td><div id="div_CantidadEneroC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Febrero : </td>
                        <td><div id="div_MontoFebreroA"></div></td>
                        <td><div id="div_CantidadFebreroA"></div></td>
                        <td><div id="div_MontoFebreroB"></div></td>
                        <td><div id="div_CantidadFebreroB"></div></td>
                        <td><div id="div_MontoFebreroC"></div></td>
                        <td><div id="div_CantidadFebreroC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Marzo : </td>
                        <td><div id="div_MontoMarzoA"></div></td>
                        <td><div id="div_CantidadMarzoA"></div></td>
                        <td><div id="div_MontoMarzoB"></div></td>
                        <td><div id="div_CantidadMarzoB"></div></td>
                        <td><div id="div_MontoMarzoC"></div></td>
                        <td><div id="div_CantidadMarzoC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Abril : </td>
                        <td><div id="div_MontoAbrilA"></div></td>
                        <td><div id="div_CantidadAbrilA"></div></td>
                        <td><div id="div_MontoAbrilB"></div></td>
                        <td><div id="div_CantidadAbrilB"></div></td>
                        <td><div id="div_MontoAbrilC"></div></td>
                        <td><div id="div_CantidadAbrilC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Mayo : </td>
                        <td><div id="div_MontoMayoA"></div></td>
                        <td><div id="div_CantidadMayoA"></div></td>
                        <td><div id="div_MontoMayoB"></div></td>
                        <td><div id="div_CantidadMayoB"></div></td>
                        <td><div id="div_MontoMayoC"></div></td>
                        <td><div id="div_CantidadMayoC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Junio : </td>
                        <td><div id="div_MontoJunioA"></div></td>
                        <td><div id="div_CantidadJunioA"></div></td>
                        <td><div id="div_MontoJunioB"></div></td>
                        <td><div id="div_CantidadJunioB"></div></td>
                        <td><div id="div_MontoJunioC"></div></td>
                        <td><div id="div_CantidadJunioC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Julio : </td>
                        <td><div id="div_MontoJulioA"></div></td>
                        <td><div id="div_CantidadJulioA"></div></td>
                        <td><div id="div_MontoJulioB"></div></td>
                        <td><div id="div_CantidadJulioB"></div></td>
                        <td><div id="div_MontoJulioC"></div></td>
                        <td><div id="div_CantidadJulioC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Agosto : </td>
                        <td><div id="div_MontoAgostoA"></div></td>
                        <td><div id="div_CantidadAgostoA"></div></td>
                        <td><div id="div_MontoAgostoB"></div></td>
                        <td><div id="div_CantidadAgostoB"></div></td>
                        <td><div id="div_MontoAgostoC"></div></td>
                        <td><div id="div_CantidadAgostoC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Setiembre : </td>
                        <td><div id="div_MontoSetiembreA"></div></td>
                        <td><div id="div_CantidadSetiembreA"></div></td>
                        <td><div id="div_MontoSetiembreB"></div></td>
                        <td><div id="div_CantidadSetiembreB"></div></td>
                        <td><div id="div_MontoSetiembreC"></div></td>
                        <td><div id="div_CantidadSetiembreC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Octubre : </td>
                        <td><div id="div_MontoOctubreA"></div></td>
                        <td><div id="div_CantidadOctubreA"></div></td>
                        <td><div id="div_MontoOctubreB"></div></td>
                        <td><div id="div_CantidadOctubreB"></div></td>
                        <td><div id="div_MontoOctubreC"></div></td>
                        <td><div id="div_CantidadOctubreC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Noviembre : </td>
                        <td><div id="div_MontoNoviembreA"></div></td>
                        <td><div id="div_CantidadNoviembreA"></div></td>
                        <td><div id="div_MontoNoviembreB"></div></td>
                        <td><div id="div_CantidadNoviembreB"></div></td>
                        <td><div id="div_MontoNoviembreC"></div></td>
                        <td><div id="div_CantidadNoviembreC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Diciembre : </td>
                        <td><div id="div_MontoDiciembreA"></div></td>
                        <td><div id="div_CantidadDiciembreA"></div></td>
                        <td><div id="div_MontoDiciembreB"></div></td>
                        <td><div id="div_CantidadDiciembreB"></div></td>
                        <td><div id="div_MontoDiciembreC"></div></td>
                        <td><div id="div_CantidadDiciembreC"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Total : </td>
                        <td><div id="div_TotalA"></div></td>
                        <td><div id="div_CantidadTotalA"></div></td>
                        <td><div id="div_TotalB"></div></td>
                        <td><div id="div_CantidadTotalB"></div></td>
                        <td><div id="div_TotalC"></div></td>
                        <td><div id="div_CantidadTotalC"></div></td>
                    </tr>
                    <tr>
                        <td class="Summit" colspan="7">
                            <div>
                                <input type="button" id="btn_GuardarDetalle" value="Guardar" style="margin-right: 20px"/>
                                <input type="button" id="btn_CancelarDetalle" value="Cancelar" style="margin-right: 20px"/>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li style="font-weight: bold;">Editar</li>
        <li style="color: red; font-weight: bold;">Anular</li>
        <li type='separator'></li>
        <li style="color: blue; font-weight: bold;">Ingresar Detalle</li>
    </ul>
</div>