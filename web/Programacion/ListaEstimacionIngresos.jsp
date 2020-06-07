<%-- 
    Document   : ListaEstimacionIngresos
    Created on : 10/02/2017, 12:19:38 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnEstimacionIngresos.periodo}';
    var presupuesto = '${objBnEstimacionIngresos.presupuesto}';
    var codigo = '${objBnEstimacionIngresos.codigo}';
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objEstimacionIngresos}">
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
            root: "EstimacionIngresos",
            record: "EstimacionIngresos",
            id: 'cadenaIngreso'
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
                    $("#cbo_CadenaIngreso").jqxDropDownList('setContent', 'Seleccione');
                    $("#txt_Descripcion").val('');
                    $("#cbo_Impuesto").jqxDropDownList('setContent', 'Seleccione');
                    $("#div_ImporteUnidadOperativa").val(0);
                    $("#div_ImporteUnidadEjecutora").val(0);
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });                
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'EstimacionIngresos');
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
                } else if ($.trim($(opcion).text()) === "Eliminar") {
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
                    position: {x: 400, y: 200},
                    width: 600, height: 175, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_CadenaIngreso").jqxDropDownList({width: 400, height: 20});
                        $("#txt_Descripcion").jqxInput({placeHolder: 'DESCRIPCIÓN', width: 400, height: 20});
                        $("#cbo_Impuesto").jqxDropDownList({width: 150, height: 20});
                        $("#div_ImporteUnidadOperativa").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 3, decimalDigits: 2});
                        $("#div_ImporteUnidadEjecutora").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 3, decimalDigits: 2});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            var msg = fn_validarPorcentaje();
                            if (msg === '')
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
                url: "../EstimacionIngresos",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../EstimacionIngresos",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 5) {
                        $("#cbo_CadenaIngreso").jqxDropDownList('selectItem', dato[0]);
                        $("#txt_Descripcion").val(dato[1]);
                        $("#cbo_Impuesto").jqxDropDownList('selectItem', dato[2]);
                        $('#div_ImporteUnidadEjecutora').val(dato[3]);
                        $("#div_ImporteUnidadOperativa").val(dato[4]);
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
            var impuestos = $("#cbo_Impuesto").val();
            var importeUnidadOperativa = $("#div_ImporteUnidadOperativa").val();
            var importeUnidadEjecutora = $("#div_ImporteUnidadEjecutora").val();            
            $.ajax({
                type: "POST",
                url: "../IduEstimacionIngresos",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, codigo: codigo, cadenaIngreso: cadenaIngreso,
                    descripcion: descripcion, impuestos: impuestos, importeUnidadOperativa: importeUnidadOperativa, importeUnidadEjecutora: importeUnidadEjecutora},
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
    }
    );
    //CARGAMOS EL COMBO DE LAS CADENAS DE INGRESO
    fn_cargarComboAjax("#cbo_CadenaIngreso", {mode: 'cadenaIngreso', periodo: periodo, presupuesto: presupuesto}); 
    //FUNCION PARA VALIDAD EL PORCENTAJE
    function fn_validarPorcentaje() {
        var porcentajeOgre = parseFloat($("#div_ImporteUnidadOperativa").val()) + parseFloat($("#div_ImporteUnidadEjecutora").val());
        porcentajeOgre = parseFloat(porcentajeOgre);
        if (porcentajeOgre !== 100.0) {
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: 'Los Porcentajes no suman el 100% exigidos segun la Directiva OGRE',
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'red',
                typeAnimated: true
            });
            return "Error";
        }
        return "";
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">PORCENTAJES DE ESTIMACIÓN</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_EstimacionIngresos" name="frm_EstimacionIngresos" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Cadena de Ingreso : </td>
                    <td>
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
                    <td class="inputlabel">Impuesto : </td>
                    <td>
                        <select id="cbo_Impuesto" name="cbo_Impuesto">
                            <option value="A">AFECTO</option>
                            <option value="E">EXONERADO</option>
                        </select>
                    </td>                    
                </tr>
                <tr>
                    <td class="inputlabel">% OGRE(UO) : </td>
                    <td><div id="div_ImporteUnidadOperativa"></div></td> 
                </tr>
                <tr>
                    <td class="inputlabel">% OGRE(UE) : </td>
                    <td><div id="div_ImporteUnidadEjecutora"></div></td>
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
<div id="cbo_Ajax" style='display: none;'></div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Eliminar</li>        
    </ul>
</div>
