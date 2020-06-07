<%-- 
    Document   : ListaProgramacionPresupuestal
    Created on : 14/02/2017, 03:37:02 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnProgramacionPresupuestal.periodo}';
    var presupuesto = '${objBnProgramacionPresupuestal.presupuesto}';
    var unidadOperativa = '${objBnProgramacionPresupuestal.unidadOperativa}';
    var saldo = parseFloat('${objBnProgramacionPresupuestal.programado}');    
    var codigo = null;
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="c" items="${objProgramacionPresupuestal}">
    var result = {tarea: '${c.codigo}', descripcion: '${c.tarea}', cadenaFuncional: '${c.cadenaFuncional}',
        programado: '${c.programado}', importe: '${c.importe}', diferencia: '${c.programado-c.importe}',
        estado: '${c.estado}', genericaGasto: '${c.genericaGasto}', unidadMedida: '${c.unidadMedida}', tipo: '${c.tipoCalendario}'};
    lista.push(result);
    </c:forEach>
    var detalle = new Array();
    <c:forEach var="d" items="${objProgramacionDetalle}">
    var result = {tarea: '${d.tarea}', codigo: '${d.codigo}', dependencia: '${d.dependencia}', cadenaGasto: '${d.cadenaGasto}',
        importe: '${d.importe}', enero: '${d.enero}', febrero: '${d.febrero}', marzo: '${d.marzo}', abril: '${d.abril}',
        mayo: '${d.mayo}', junio: '${d.junio}', julio: '${d.julio}', agosto: '${d.agosto}', setiembre: '${d.setiembre}',
        octubre: '${d.octubre}', noviembre: '${d.noviembre}', diciembre: '${d.diciembre}'};
    detalle.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA CABECERA
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'tarea', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'cadenaFuncional', type: "string"},
                        {name: 'programado', type: "number"},
                        {name: 'importe', type: "number"},
                        {name: 'diferencia', type: "number"},
                        {name: 'estado', type: "string"},
                        {name: 'genericaGasto', type: "string"},
                        {name: 'unidadMedida', type: "string"},
                        {name: 'tipo', type: "string"}
                    ],
            root: "ProgramacionPresupuestal",
            record: "ProgramacionPresupuestal",
            id: 'tarea'
        };
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA DETALLE 
        var sourceDet = {
            localdata: detalle,
            datatype: "array",
            datafields:
                    [
                        {name: "tarea", type: "string"},
                        {name: "codigo", type: "string"},
                        {name: "dependencia", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "importe", type: "number"},
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
                        {name: "diciembre", type: "number"}
                    ],
            root: "ProgramacionDetalle",
            record: "Detalle",
            id: 'tarea',
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
                var result = filter.evaluate(nested[m]["tarea"]);
                if (result)
                    ordersbyid.push(nested[m]);
            }
            var sourceNested = {
                datafields: [
                    {name: "tarea", type: "string"},
                    {name: "codigo", type: "string"},
                    {name: "dependencia", type: "string"},
                    {name: "cadenaGasto", type: "string"},
                    {name: "importe", type: "number"},
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
                    {name: "diciembre", type: "number"}
                ],
                id: 'tarea',
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
                    showfilterrow: true,
                    showstatusbar: true,
                    statusbarheight: 25,
                    columns: [
                        {text: 'DEPENDENCIA', datafield: 'dependencia', width: '6%', filtertype: 'checkedlist'},
                        {text: 'CADENA DE GASTO', datafield: 'cadenaGasto', width: '15%', filtertype: 'checkedlist', aggregates: [{'<b>Totales : </b>':
                                            function () {
                                                return  "";
                                            }}]},
                        {text: 'IMPORTE', dataField: 'importe', width: '7%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'ENERO', dataField: 'enero', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'FEBRERO', dataField: 'febrero', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'MARZO', dataField: 'marzo', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'ABRIL', dataField: 'abril', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'MAYO', dataField: 'mayo', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'JUNIO', dataField: 'junio', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'JULIO', dataField: 'julio', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'AGOSTO', dataField: 'agosto', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'SETIEMBRE', dataField: 'setiembre', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'OCTUBRE', dataField: 'octubre', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'NOVIEMBRE', dataField: 'noviembre', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                        {text: 'DICIEMBRE', dataField: 'diciembre', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
                    ]
                });
            }
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "programado") {
                return "RowBold";
            }
            if (datafield === "importe") {
                return "RowBlue";
            }
            if (datafield === "diferencia") {
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
            statusbarheight: 25,
            pagesize: 30,
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
                    $("#cbo_Tarea").jqxDropDownList('selectItem', 0);
                    $("#cbo_CadenaFuncional").jqxDropDownList('selectItem', 0);
                    $("#cbo_TipoCalendario").jqxDropDownList('selectItem', 0);
                    $("#cbo_GenericaGasto").jqxDropDownList('selectItem', 0);
                    $("#div_Importe").val(0);
                    if (presupuesto === '6') {
                        $("#div_Saldo").val(saldo);
                    }else{
                        
                    }
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ProgramacionPresupuestal');
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 350, rowdetailshidden: true},
            columns: [
                {text: 'TAREA', dataField: 'descripcion', filtertype: 'checkedlist', width: '25%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'CADENA FUNCIONAL', dataField: 'cadenaFuncional', filtertype: 'checkedlist', width: '22%', align: 'center', cellsAlign: 'center', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'PROGRAMADO', dataField: 'programado', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE MENSUAL', dataField: 'importe', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DIFERENCIA', dataField: 'diferencia', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'UNIDAD MEDIDA', dataField: 'unidadMedida', filtertype: 'checkedlist', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'GENERICA GASTO', dataField: 'genericaGasto', filtertype: 'checkedlist', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'TIPO', dataField: 'tipo', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 58, autoOpenPopup: false, mode: 'popup'});
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
                if (codigo !== null) {
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
                if (codigo.trim() !== '') {
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
            codigo = row['tarea'];
            $("#cbo_Tarea").jqxDropDownList('selectItem', fn_extraerDatos(row['descripcion'], '-'));
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 180;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_Tarea").jqxDropDownList({width: 400, height: 20, promptText: "Seleccione"});
                        $('#cbo_Tarea').on('change', function () {
                            var tarea = $("#cbo_Tarea").val();
                            fn_cargarComboAjax("#cbo_CadenaFuncional", {mode: 'cadenaFuncionalProgramacion', periodo: periodo, presupuesto: presupuesto, tarea:tarea});                            
                        });
                        $("#cbo_CadenaFuncional").jqxDropDownList({width: 400, height: 20, promptText: "Seleccione"});
                        $("#cbo_TipoCalendario").jqxDropDownList({width: 400, height: 20, promptText: "Seleccione"});
                        $("#cbo_GenericaGasto").jqxDropDownList({width: 400, height: 20, promptText: "Seleccione"});
                        $("#div_Importe").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $("#div_Saldo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0, disabled: true});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            fn_GrabarDatos();
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
        function fn_Refrescar() {
            $("#div_ContextMenu").remove();
            $("#div_VentanaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../ProgramacionPresupuestal",
                data: {mode: "G", periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $("#cbo_Tarea").jqxDropDownList({disabled: true});
            $.ajax({
                type: "GET",
                url: "../ProgramacionPresupuestal",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 5) {
                        $("#cbo_CadenaFuncional").jqxDropDownList('selectItem', dato[0]);
                        $("#cbo_TipoCalendario").jqxDropDownList('selectItem', dato[1]);
                        $("#div_Importe").val(parseFloat(dato[2]));
                        $("#cbo_GenericaGasto").jqxDropDownList('selectItem', dato[3]);
                        if (presupuesto === '6') {
                            $("#div_Saldo").val(parseFloat(saldo) + parseFloat($("#div_Importe").val()));
                        }
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var msg = "";
            var tarea = $("#cbo_Tarea").val();
            var cadenaFuncional = $("#cbo_CadenaFuncional").val();
            var tipoCalendario = $("#cbo_TipoCalendario").val();
            var genericaGasto = $("#cbo_GenericaGasto").val();
            var importe = $("#div_Importe").val();
            msg += fn_validaCombos('#cbo_Tarea', "Seleccione la Tarea.");
            msg += fn_validaCombos('#cbo_CadenaFuncional', "Seleccione la Cadena Funcional.");
            msg += fn_validaCombos('#cbo_TipoCalendario', "Seleccione el Tipo de Calendario.");
            msg += fn_validaCombos('#cbo_GenericaGasto', "Seleccione la Generica de Gasto.");
            if (msg !== "") {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: msg,
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
                return;
            }
            if (importe > saldo && mode !== 'D' && presupuesto==='6') {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: "No cuenta con saldo suficiente (SALDO : " + saldo + ")",
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
                return;
            }
            $.ajax({
                type: "POST",
                url: "../IduProgramacionPresupuestal",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea,
                    cadenaFuncional: cadenaFuncional, tipoCalendario: tipoCalendario, genericaGasto: genericaGasto, importe: importe},
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
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">PROGRAMACION PRESUPUESTAL</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_Programacion" name="frm_Programacion" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Tarea : </td>
                    <td colspan="3">
                        <select id="cbo_Tarea" name="cbo_Tarea">
                            <option value="0">SELECCIONE</option> 
                            <c:forEach var="e" items="${objTarea}">   
                                <option value="${e.codigo}">${e.descripcion}</option>
                            </c:forEach>  
                        </select>
                    </td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Meta : </td>
                    <td colspan="3">
                        <select id="cbo_CadenaFuncional" name="cbo_CadenaFuncional">
                            <option value="0">SELECCIONE</option> 
                        </select>
                    </td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Tipo Calendario : </td>
                    <td colspan="3">
                        <select id="cbo_TipoCalendario" name="cbo_TipoCalendario">
                            <option value="2">FUNCIONAMIENTO</option> 
                            <option value="21">DEMANDA ADICIONAL</option> 
                        </select>
                    </td>                    
                </tr>                
                <tr>
                    <td class="inputlabel">Generica de Gasto : </td>
                    <td colspan="3">
                        <select id="cbo_GenericaGasto" name="cbo_GenericaGasto">
                            <option value="0">SELECCIONE</option> 
                            <c:forEach var="g" items="${objGenericaGasto}">   
                                <option value="${g.codigo}">${g.descripcion}</option>
                            </c:forEach>   
                        </select>
                    </td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Importe : </td>
                    <td><div id="div_Importe"></div></td> 
                    <td class="inputlabel">Saldo : </td>
                    <td><div id="div_Saldo"></div></td> 
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
<div id="cbo_Ajax" style='display: none;' ></div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Eliminar</li>
    </ul>
</div>