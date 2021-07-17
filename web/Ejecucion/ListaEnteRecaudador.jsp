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
    var codigo = 0;
    var estado = '';
    var mode = null;
    var msg = '';
    var lista = new Array();
    <c:forEach var="d" items="${objEnteRecaudador}">
    var result = {codigo: '${d.codigo}', clasificador: '${d.clasificador}', descripcion: '${d.descripcion}', recaudacion: '${d.importe}',
        costoOperativo: '${d.costoOperativo}', utilidadNeta: '${d.utilidadNeta}', utilidadUO: '${d.utilidadUO}', utilidadUE: '${d.utilidadUE}', concepto: '${d.estado}'};
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
                        {name: 'clasificador', type: "string"},
                        {name: 'concepto', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'recaudacion', type: "number"},
                        {name: 'costoOperativo', type: "number"},
                        {name: 'utilidadNeta', type: "number"},
                        {name: 'utilidadUO', type: "number"},
                        {name: 'utilidadUE', type: "number"}
                    ],
            root: "EnteRecaudador",
            record: "EnteRecaudador",
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
            if (datafield === "costoOperativo") {
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
                    $("#cbo_EstimacionIngreso").jqxDropDownList('setContent', 'Seleccione');
                    $('#txt_Descripcion').val('');
                    $("#div_Importe").val(0);
                    $("#div_CostoOperativo").val(0);
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'EnteRecaudador');
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
                {text: 'CLASIFICADOR', dataField: 'clasificador', filtertype: 'checkedlist', width: '16%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'CONCEPTO', dataField: 'concepto', filtertype: 'checkedlist', width: '17%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DESCRIPCIÓN', dataField: 'descripcion', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'RECAUDACIÓN', dataField: 'recaudacion', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'COSTO OPERAT.', dataField: 'costoOperativo', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO NETO', dataField: 'utilidadNeta', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO UE', dataField: 'utilidadUE', width: '8.5%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO UO', dataField: 'utilidadUO', width: '8.5%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL 
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 55, autoOpenPopup: false, mode: 'popup'});
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
                var alto = 190;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_EstimacionIngreso").jqxDropDownList({width: 400, height: 20, dropDownWidth: 600});
                        $("#txt_Descripcion").jqxInput({placeHolder: 'ENTE GENERADOR', width: 400, height: 20});
                        $("#div_Importe").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Importe').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_CostoOperativo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_CostoOperativo').on('textchanged', function (event) {
                            fn_verSaldos();
                        });
                        $("#div_Utilidad").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function (event) {
                            $('#frm_EnteRecaudador').jqxValidator('validate');
                        });
                        $('#frm_EnteRecaudador').jqxValidator({
                            rules: [
                                {input: '#txt_Descripcion', message: 'Ingrese el Ente Generador!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_EnteRecaudador').jqxValidator({
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
        fn_cargarComboAjax("#cbo_EstimacionIngreso", {mode: 'cadenaIngresoEstimacionUnidad', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa});
    });
    //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
    function fn_Refrescar() {
        $("#div_GrillaPrincipal").remove();
        $("#div_VentanaPrincipal").remove();
        $("#div_ContextMenu").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "POST",
            url: "../EnteRecaudador",
            data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes},
            success: function (data) {
                $contenidoAjax.html(data);
            }
        });
    }
    //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
    function fn_EditarRegistro() {
        $.ajax({
            type: "GET",
            url: "../EnteRecaudador",
            data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes, codigo: codigo},
            success: function (data) {
                var dato = data.split("+++");
                if (dato.length === 4) {
                    $("#cbo_EstimacionIngreso").jqxDropDownList('selectItem', dato[0]);
                    $('#txt_Descripcion').val(dato[1]);
                    $("#div_Importe").val(dato[2]);
                    $("#div_CostoOperativo").val(dato[3]);
                    fn_verSaldos();
                }
            }
        });
        $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
        $('#div_VentanaPrincipal').jqxWindow('open');
    }
    //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
    function fn_GrabarDatos() {
        var estimacionIngreso = $("#cbo_EstimacionIngreso").val();
        var descripcion = $("#txt_Descripcion").val();
        var importe = $("#div_Importe").val();
        var costoOperativo = $("#div_CostoOperativo").val();
        if (importe === 0.0 && (mode === 'I' || mode === 'U')) {
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: 'DEBE INGRESAR LOS COSTOS DEL ENTE GENERADOR',
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'red',
                typeAnimated: true
            });
        } else {
            $.ajax({
                type: "POST",
                url: "../IduEnteRecaudador",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, mes: mes, codigo: codigo,
                    estimacionIngreso: estimacionIngreso, descripcion: descripcion, importe: importe, costoOperativo: costoOperativo},
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
    function fn_verSaldos() {
        $("#div_Utilidad").val(parseFloat($("#div_Importe").val()) - parseFloat($("#div_CostoOperativo").val()));
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">REGISTRO DE ENTE RECAUDADOR</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_EnteRecaudador" name="frm_EnteRecaudador" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Clasif. de Ingreso : </td>
                    <td>
                        <select id="cbo_EstimacionIngreso" name="cbo_EstimacionIngreso">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Descripción : </td>
                    <td><input type="text" id="txt_Descripcion" name="txt_Descripcion" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Recaudación : </td>
                    <td><div id="div_Importe"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Costo Operativo : </td>
                    <td><div id="div_CostoOperativo"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Utilidad : </td>
                    <td><div id="div_Utilidad"></div></td>
                </tr>
                <tr>
                    <td class="Summit" colspan="4">
                        <div>
                            <input type="button" id="btn_Guardar" value="Guardar" style="margin-right: 20px"/>
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
        <li style="font-weight: bold;">Editar</li>
        <li style="font-weight: bold;">Anular</li>
    </ul>
</div>