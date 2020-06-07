<%-- 
    Document   : ListaEstimacionIngresosUnidadOperativa
    Created on : 11/03/2017, 08:31:48 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnEstimacionUnidad.periodo}';
    var unidadOperativa = '${objBnEstimacionUnidad.unidadOperativa}';
    var presupuesto = '${objBnEstimacionUnidad.presupuesto}';
    var codigo = '${objBnEstimacionUnidad.codigo}';
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objEstimacionUnidad}">
    var result = {codigo: '${d.codigo}', cadenaIngreso: '${d.cadenaIngreso}', descripcion: '${d.descripcion}', impuesto: '${d.impuesto}', importeUnidadOperativa: '${d.importeUnidadOperativa}', importeUnidadEjecutora: '${d.importeUnidadEjecutora}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigo', type: "number"},
                        {name: 'cadenaIngreso', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'impuesto', type: "string"},
                        {name: 'importeUnidadOperativa', type: "number"},
                        {name: 'importeUnidadEjecutora', type: "number"}
                    ],
            root: "EstimacionUnidad",
            record: "EstimacionUnidad",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "cadenaIngreso") {
                return "RowBold";
            }
            if (datafield === "importeUnidadOperativa") {
                return "RowBlue";
            }
            if (datafield === "importeUnidadEjecutora") {
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
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            showtoolbar: true,
            editable: false,
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
                    codigo = 0;
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'EstimacionIngresosUnidadOperativa');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '2%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'CADENA DE INGRESO', dataField: 'cadenaIngreso', filtertype: 'checkedlist', width: '46%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DESCRIPCIÓN', dataField: 'descripcion', width: '30%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'IMPUESTO', dataField: 'impuesto', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: '% UO', dataField: 'importeUnidadOperativa', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'f2', cellclassname: cellclass},
                {text: '% UE', dataField: 'importeUnidadEjecutora', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'f2', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 37, autoOpenPopup: false, mode: 'popup'});
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
                if ($.trim($(opcion).text()) === "Eliminar") {
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
            }
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: 400, y: 100},
                    width: 500, height: 400, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $('#div_EstimacionIngresos').jqxTree({height: '340px', width: '480px', checkboxes: true});
                        $('#div_EstimacionIngresos').css('visibility', 'visible');
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
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../EstimacionIngresosUnidadOperativa",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var lista = new Array();
            var items = $('#div_EstimacionIngresos').jqxTree('getCheckedItems');
            for (var i = 0; i < items.length; i++) {
                var item = items[i];
                lista.push(item.id);
            }
            if (lista.length > 0 || mode === 'D') {
                $.ajax({
                    type: "POST",
                    url: "../IduEstimacionIngresosUnidadOperativa",
                    data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, presupuesto: presupuesto,
                        codigo: codigo, lista: JSON.stringify(lista)},
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
            } else {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'Debe Seleccionar los Elementos',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            }
        }
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">LISTA DE ESTIMACIÓN DE INGRESOS</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_EstimacionIngresos" name="frm_EstimacionIngresos" method="post" >
            <div id='div_EstimacionIngresos' style='visibility: hidden; float: left; margin-left: 5px;'>
                <ul style="padding: 10px 0px 0px 0px">
                    <c:forEach var="e" items="${objEstimacionIngresos}"> 
                        <li id='${e.codigo}' >${e.descripcion}</li>
                        </c:forEach>                  
                </ul>        
            </div>
            <div style="text-align: right">
                <input type="button" id="btn_Guardar"  value="Guardar" style="margin-right: 20px"/>
                <input type="button" id="btn_Cancelar" value="Cancelar" style="margin-right: 20px"/>                            
            </div>
        </form>
    </div>
</div>
<div id="cbo_Ajax" style='display: none;'></div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Eliminar</li>        
    </ul>
</div>