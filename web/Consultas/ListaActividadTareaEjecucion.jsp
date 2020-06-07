<%-- 
    Document   : ListaActividadTarea
    Created on : 08/02/2018, 11:09:43 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var codigo = 0;
    var mode = null;
    var dataRecord = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objActividadTarea}">
    var result = {codigo: '${d.codigo}', categoriaPresupuestal: '${d.categoriaPresupuestal}', producto: '${d.producto}',
        actividad: '${d.actividad}', tarea: '${d.tarea}', finalidad: '${d.finalidad}'};
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
                        {name: 'categoriaPresupuestal', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'actividad', type: "string"},
                        {name: 'tarea', type: "string"},
                        {name: 'finalidad', type: "string"}
                    ],
            root: "ActividadTareaEjecucion",
            record: "ActividadTareaEjecucion",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "tarea") {
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
                    codigo = null;
                    $("#cbo_CategoriaPresupuestal").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_CategoriaPresupuestal").jqxDropDownList({disabled: false});
                    $("#cbo_Producto").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_Producto").jqxDropDownList({disabled: false});
                    $("#cbo_Actividad").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_Actividad").jqxDropDownList({disabled: false});
                    $("#cbo_Tarea").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_Finalidad").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_Finalidad").jqxDropDownList({disabled: false});
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ActividadTarea');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '30', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'CAT. PPTAL.', dataField: 'categoriaPresupuestal', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'PROD/PROY', dataField: 'producto', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ACT/ACCION INV./OBR', dataField: 'actividad', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'TAREA', dataField: 'tarea', filtertype: 'checkedlist', width: '23%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'FINALIDAD', dataField: 'finalidad', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass}
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
            dataRecord = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = dataRecord['codigo'];
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
                        $("#cbo_CategoriaPresupuestal").jqxDropDownList({width: 400, height: 20, dropDownWidth: 500, promptText: "Seleccione"});
                        $('#cbo_CategoriaPresupuestal').on('select', function (event) {
                            fn_cargarComboAjax("#cbo_Producto", {mode: 'productoTareaEjecucion', periodo: periodo, codigo: $('#cbo_CategoriaPresupuestal').val()});
                            $("#cbo_Producto").jqxDropDownList('clear');
                            $("#cbo_Actividad").jqxDropDownList('clear');
                            $("#cbo_Finalidad").jqxDropDownList('clear');
                        });
                        $("#cbo_Producto").jqxDropDownList({width: 400, height: 20, dropDownWidth: 500, promptText: "Seleccione"});
                        $('#cbo_Producto').on('select', function (event) {
                            fn_cargarComboAjax("#cbo_Actividad", {mode: 'actividadTareaEjecucion', periodo: periodo, categoriaPresupuestal: $('#cbo_CategoriaPresupuestal').val(), producto: $('#cbo_Producto').val()});
                            $("#cbo_Actividad").jqxDropDownList('clear');
                            $("#cbo_Finalidad").jqxDropDownList('clear');
                        });
                        $("#cbo_Actividad").jqxDropDownList({width: 400, height: 20, dropDownWidth: 500, promptText: "Seleccione"});
                        $('#cbo_Actividad').on('select', function (event) {
                            fn_cargarComboAjax("#cbo_Finalidad", {mode: 'finalidadTareaEjecucion', periodo: periodo, categoriaPresupuestal: $('#cbo_CategoriaPresupuestal').val(), producto: $('#cbo_Producto').val(), codigo: $('#cbo_Actividad').val()});
                            $("#cbo_Finalidad").jqxDropDownList('clear');
                        });
                        $("#cbo_Tarea").jqxDropDownList({width: 400, height: 20, promptText: "Seleccione"});
                        $("#cbo_Finalidad").jqxDropDownList({width: 400, height: 20, promptText: "Seleccione"});
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
            fn_cargarComboAjax("#cbo_Tarea", {mode: 'tarea'});
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../ActividadTareaEjecucion",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $("#cbo_CategoriaPresupuestal").jqxDropDownList('setContent', dataRecord.categoriaPresupuestal);
            $("#cbo_CategoriaPresupuestal").jqxDropDownList({disabled: true});
            $("#cbo_Producto").jqxDropDownList('clear');
            $("#cbo_Producto").jqxDropDownList('setContent', dataRecord.producto);
            $("#cbo_Producto").jqxDropDownList({disabled: true});
            $("#cbo_Actividad").jqxDropDownList('clear');
            $("#cbo_Actividad").jqxDropDownList('setContent', dataRecord.actividad);
            $("#cbo_Actividad").jqxDropDownList({disabled: true});
            $("#cbo_Tarea").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.tarea, ':'));
            $("#cbo_Finalidad").jqxDropDownList('clear');
            $("#cbo_Finalidad").jqxDropDownList('setContent', dataRecord.finalidad);
            $("#cbo_Finalidad").jqxDropDownList({disabled: true});
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var categoriaPresupuestal = $("#cbo_CategoriaPresupuestal").val();
            var producto = $("#cbo_Producto").val();
            var actividad = $("#cbo_Actividad").val();
            var tarea = $("#cbo_Tarea").val();
            var finalidad = $("#cbo_Finalidad").val();
            $.ajax({
                type: "POST",
                url: "../IduActividadTareaEjecucion",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, codigo: codigo, categoriaPresupuestal: categoriaPresupuestal,
                    producto: producto, actividad: actividad, tarea: tarea, finalidad: finalidad},
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
        <span style="float: left">ACTIVIDAD - TAREA PRESUPUESTAL - EJECUCIÓN PRESUPUESTAL</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_ActividadTareaPresupuestal" name="frm_ActividadTareaPresupuestal" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">                
                <tr>
                    <td class="inputlabel">Categoria Presupuestal : </td>
                    <td>
                        <select id="cbo_CategoriaPresupuestal" name="cbo_CategoriaPresupuestal">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objCategoriaPresupuestal}">
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Producto/Proyecto : </td>
                    <td>
                        <select id="cbo_Producto" name="cbo_Producto">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Act./Ac. de Inver./Obra : </td>
                    <td>
                        <select id="cbo_Actividad" name="cbo_Actividad">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td> 
                </tr>                
                <tr>
                    <td class="inputlabel">Tarea : </td>
                    <td>
                        <select id="cbo_Tarea" name="cbo_Tarea">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td> 
                </tr>
                <tr>
                    <td class="inputlabel">Finalidad : </td>
                    <td>
                        <select id="cbo_Finalidad" name="cbo_Finalidad">
                            <option value="0">Seleccione</option> 
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
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Eliminar</li>        
    </ul>
</div>