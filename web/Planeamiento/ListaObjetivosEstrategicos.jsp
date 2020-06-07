<%-- 
    Document   : ListaObjetivosEstrategicos
    Created on : 01/11/2019, 09:28:56 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var codigo = null;
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objObjetivosEstrategicos}">
    var result = {codigo: '${d.codigo}', descripcion: '${d.descripcion}', abreviatura: '${d.abreviatura}', prioridad: '${d.prioridad}',
        fechaInicio: '${d.fechaInicio}', fechaFinal: '${d.fechaFinal}', unidadMedida: '${d.unidadMedida}', estado: '${d.estado}'};
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
                        {name: 'abreviatura', type: "string"},
                        {name: 'prioridad', type: "number"},
                        {name: 'fechaInicio', type: "string"},
                        {name: 'fechaFinal', type: "string"},
                        {name: 'unidadMedida', type: "string"},
                        {name: 'estado', type: "string"}
                    ],
            root: "ObjetivosEstrategicos",
            record: "ObjetivosEstrategicos",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
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
                    codigo = 0;
                    $.ajax({
                        type: "GET",
                        url: "../ObjetivosEstrategicos",
                        data: {mode: mode, periodo: periodo},
                        success: function (data) {
                            $("#div_Prioridad").val(data);
                        }
                    });
                    $("#txt_Descripcion").val('');
                    $("#txt_Abreviatura").val('');
                    $("#div_FechaInicio").val('');
                    $("#div_FechaFin").val('');
                    $("#cbo_UnidadMedida").jqxDropDownList('setContent', 'Seleccione');
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'POI-ObjetivosEstrategicos');
                });
            },
            columns: [
                {text: 'PRIORIDAD', dataField: 'prioridad', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DESCRIPCIÓN', dataField: 'descripcion', width: '35%', align: 'center', cellclassname: cellclass},
                {text: 'ABREVIATURA', dataField: 'abreviatura', width: '25%', align: 'center', cellclassname: cellclass},
                {text: 'FEC. INICIO', dataField: 'fechaInicio', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FEC. FINAL', dataField: 'fechaFinal', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'UNI. MEDIDA', dataField: 'unidadMedida', filtertype: 'checkedlist', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var alto = 57;
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
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 280;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#div_Prioridad").jqxNumberInput({width: 70, height: 20, inputMode: 'simple', digits: 4, decimalDigits: 0, min: 0, max: 9999, spinButtons: false});
                        $("#txt_Descripcion").jqxInput({placeHolder: 'DESCRIPCIÓN', width: 460, height: 95, minLength: 1, maxLength: 500});
                        $("#txt_Abreviatura").jqxInput({placeHolder: 'ABREVIATURA', width: 460, height: 20, maxLength: 50});
                        $("#div_FechaInicio").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_FechaFin").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#cbo_UnidadMedida").jqxDropDownList({width: 200, height: 20});
                        $("#cbo_Estado").jqxDropDownList({width: 150, height: 20});
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
            fn_cargarComboAjax("#cbo_UnidadMedida", {mode: 'unidadMedida'});
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../ObjetivosEstrategicos",
                data: {mode: 'G', periodo: periodo},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../ObjetivosEstrategicos",
                data: {mode: mode, periodo: periodo, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 7) {
                        $("#txt_Descripcion").val(dato[0]);
                        $("#txt_Abreviatura").val(dato[1]);
                        $("#div_Prioridad").val(dato[2]);
                        $("#div_FechaInicio").val(dato[3]);
                        $("#div_FechaFin").val(dato[4]);
                        $("#cbo_UnidadMedida").val(dato[5]);
                        $("#cbo_Estado").jqxDropDownList('selectItem', dato[6]);
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
            var abreviatura = $("#txt_Abreviatura").val();
            var fechaInicio = $("#div_FechaInicio").val();
            var fechaFin = $("#div_FechaFin").val();
            var unidadMedida = $("#cbo_UnidadMedida").val();
            var estado = $("#cbo_Estado").val();
            $.ajax({
                type: "POST",
                url: "../IduObjetivosEstrategicos",
                data: {mode: mode, periodo: periodo, codigo: codigo, prioridad: prioridad, descripcion: descripcion,
                    abreviatura: abreviatura, fechaInicio: fechaInicio, fechaFin: fechaFin, unidadMedida: unidadMedida,
                    estado: estado},
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
        <span style="float: left">PEI - OBJETIVOS ESTRATEGIVOS INSTITUCIONAL</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_ObjetivosEstrategicos" name="frm_ObjetivosEstrategicos" method="post" >
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
                    <td class="inputlabel">Abreviatura : </td>
                    <td colspan="3"><input type="text" id="txt_Abreviatura" name="txt_Abreviatura" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Fecha Inicio : </td>
                    <td><div id="div_FechaInicio" name="div_FechaInicio"></div></td>
                    <td class="inputlabel">Fecha Fin : </td>
                    <td><div id="div_FechaFin" name="div_FechaFin"> </div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Unidad Medida : </td>
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
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li style="font-weight: bold;">Editar</li>
        <li style="color: red; font-weight: bold;">Anular</li>
    </ul>
</div>