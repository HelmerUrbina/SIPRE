<%-- 
    Document   : ListaSistemaCambio
    Created on : 12/03/2018, 08:11:09 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var setel = '${usuario}';
    var codigo = null;
    var usuario = null;
    var mode = null;
    var indice = -1;
    var lista = new Array();
    <c:forEach var="d" items="${objSistemaCambio}">
    var result = {codigo: '${d.codigo}', usuario: '${d.usuario}', unidadOperativa: '${d.unidadOperativa}', fecha: '${d.fecha}', fase: '${d.fase}',
        asunto: '${d.asunto}', descripcion: '${d.descripcion}', observaciones: '${d.observacion}', estado: '${d.estado}',
        responsable: '${d.responsable}', fechaSolucion: '${d.fechaSolucion}', solucion: '${d.accion}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA DE LA CABECERA  
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigo', type: "string"},
                        {name: 'usuario', type: "string"},
                        {name: 'unidadOperativa', type: "string"},
                        {name: 'fecha', type: "string"},
                        {name: 'fase', type: "string"},
                        {name: 'asunto', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'observaciones', type: "string"},
                        {name: 'estado', type: "string"},
                        {name: 'responsable', type: "string"},
                        {name: 'fechaSolucion', type: "string"},
                        {name: 'solucion', type: "string"}
                    ],
            root: "SistemaCambio",
            record: "SistemaCambio",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "estado") {
                return "RowBold";
            }
            if (datafield === "unidadOperativa") {
                return "RowBlue";
            }
            if (datafield === "usuario") {
                return "RowPurple";
            }
            if (datafield === "usuario") {
                return "responsable";
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
            pagesize: 50,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
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
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    codigo = null;
                    $("#txt_Fecha").val("");
                    $("#cbo_UnidadOperativa").jqxDropDownList('selectItem', "0")
                    $("#cbo_Fase").jqxDropDownList('selectItem', "0");
                    $("#txt_Asunto").val("");
                    $("#txt_Descripcion").val("");
                    $("#txt_Observacion").val("");
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'SolicitudesCambio');
                });
                ButtonReporte.click(function (event) {
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
                        var url = '../Reportes?reporte=MAY0001&periodo=' + periodo + '&usuario=' + usuario + '&codigo=' + codigo;
                        window.open(url, '_blank');
                    }
                });
            },
            columns: [
                {text: 'N°', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '30', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'USUARIO', dataField: 'usuario', filtertype: 'checkedlist', width: '12%', align: 'center', cellclassname: cellclass},
                {text: 'UU/OO', dataField: 'unidadOperativa', filtertype: 'checkedlist', width: '9%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FECHA', dataField: 'fecha', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FASE', dataField: 'fase', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ASUNTO', dataField: 'asunto', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'DESCRIPCION', dataField: 'descripcion', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'OBSERVACIONES', dataField: 'observaciones', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'RESPONSABLE', dataField: 'responsable', filtertype: 'checkedlist', width: '12%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FECHA SOLUCION', dataField: 'fechaSolucion', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'SOLUCION', dataField: 'solucion', width: '15%', align: 'center', cellclassname: cellclass}
            ]
        }
        );
        // DEFINIMOS EL MENU CONTEXTUAL
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 85, autoOpenPopup: false, mode: 'popup'});
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
                    if (indice >= 0) {
                        var dataRecord = $("#div_GrillaPrincipal").jqxGrid('getrowdata', indice);
                        $("#div_Fecha").val(dataRecord.fecha);
                        $("#cbo_Fase").jqxDropDownList('selectItem', dataRecord.fase.substring(0, 2));
                        $("#cbo_UnidadOperativa").jqxDropDownList('selectItem', dataRecord.unidadOperativa.substring(0, 4));
                        $("#txt_Asunto").val(dataRecord.asunto);
                        $("#txt_Descripcion").val(dataRecord.descripcion);
                        $("#txt_Observacion").val(dataRecord.observaciones);
                    }
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true});
                    $('#div_VentanaPrincipal').jqxWindow('open');
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
                } else if ($.trim($(opcion).text()) === "Respuesta") {
                    if (setel === '43305891' || setel === '44469132' || setel === '10714635' || setel === '125534700') {
                        mode = 'V';
                        if (indice >= 0) {
                            var dataRecord = $("#div_GrillaPrincipal").jqxGrid('getrowdata', indice);
                            $("#div_Fecha").val(dataRecord.fecha);
                            $("#cbo_Fase").jqxDropDownList('selectItem', dataRecord.fase.substring(0, 2));
                            $("#cbo_UnidadOperativa").jqxDropDownList('selectItem', dataRecord.unidadOperativa.substring(0, 4));
                            $("#txt_Asunto").val(dataRecord.asunto);
                            $("#txt_Descripcion").val(dataRecord.descripcion);
                            $("#txt_Observacion").val(dataRecord.observaciones);
                        }
                        $('#div_VentanaRespuesta').jqxWindow({isModal: true});
                        $('#div_VentanaRespuesta').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Usuario no Autorizado para esta Operacion',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }
                }
            }
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            indice = event.args.rowindex;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', indice);
            usuario = row['codigo'].substring(0, row['codigo'].indexOf('.'));
            codigo = row['codigo'].substring(row['codigo'].indexOf('.') + 1);
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
                        $("#div_Fecha").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 110, height: 20, disabled: true});
                        $("#cbo_Fase").jqxDropDownList({width: 200, height: 20, animationType: 'fade', promptText: "Seleccione"});
                        $("#cbo_UnidadOperativa").jqxDropDownList({width: 380, height: 20, dropDownWidth: 450, animationType: 'fade', promptText: "Seleccione"});
                        $("#txt_Asunto").jqxInput({placeHolder: "Asunto del cambio", width: 450, height: 60, minLength: 1});
                        $("#txt_Descripcion").jqxInput({placeHolder: "Descripcion del cambio", width: 450, height: 60, minLength: 1});
                        $("#txt_Observacion").jqxInput({placeHolder: "Observaciones del cambio", width: 450, height: 60, minLength: 1});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            fn_GrabarDatos();
                        });
                    }
                });
                ancho = 600;
                alto = 170;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaRespuesta').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarRespuesta'),
                    initContent: function () {
                        $("#div_FechaSolucion").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 110, height: 20, disabled: true});
                        $("#txt_Solucion").jqxInput({placeHolder: "Solucion del cambio", width: 480, height: 80, minLength: 1});
                        $('#btn_CancelarRespuesta').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRespuesta').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRespuesta').on('click', function () {
                            fn_GrabarDatosRespuesta();
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
            fn_cargarComboAjax("#cbo_UnidadOperativa", {mode: 'unidadOperativa', periodo: periodo, presupuesto: 0});
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_ContextMenu").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaRespuesta").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../SistemaCambio",
                data: {mode: 'G', periodo: periodo},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var fecha = $("#div_Fecha").val();
            var unidadOperativa = $("#cbo_UnidadOperativa").val();
            var fase = $("#cbo_Fase").val();
            var asunto = $("#txt_Asunto").val();
            var descripcion = $("#txt_Descripcion").val();
            var observacion = $("#txt_Observacion").val();
            $.ajax({
                type: "POST",
                url: "../IduSistemaCambio",
                data: {mode: mode, periodo: periodo, usuario: usuario, codigo: codigo, fecha: fecha, unidadOperativa: unidadOperativa,
                    fase: fase, asunto: asunto, descripcion: descripcion, observacion: observacion},
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
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA RESPUESTA
        function fn_GrabarDatosRespuesta() {
            var fechaSolucion = $("#div_FechaSolucion").val();
            var solucion = $("#txt_Solucion").val();
            $.ajax({
                type: "POST",
                url: "../IduSistemaCambio",
                data: {mode: mode, periodo: periodo, usuario: usuario, codigo: codigo, fechaSolucion: fechaSolucion, solucion: solucion},
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
                                        $('#div_VentanaRespuesta').jqxWindow('close');
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
        <span style="float: left">REGISTRO DE SOLICITUD DEL CAMBIO</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_SistemaCambio" name="frm_SistemaCambio" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Fecha : </td>
                    <td><div id="div_Fecha"></div></td>
                    <td class="inputlabel">Fase : </td>
                    <td>
                        <select id="cbo_Fase" name="cbo_Fase">
                            <option value="0">Seleccione</option>
                            <option value="CE">Certificado</option>
                            <option value="CO">Compromiso Anual</option>
                            <option value="DE">Declaración Jurada</option>
                            <option value="NO">Nota Modificatoria</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">UU/OO : </td>
                    <td colspan="3">
                        <select id="cbo_UnidadOperativa" name="cbo_UnidadOperativa">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr> 
                <tr>
                    <td class="inputlabel">Asunto : </td>
                    <td colspan="3"><textarea id="txt_Asunto" name="txt_Asunto" style="text-transform: uppercase;"/></textarea></td>
                </tr>
                <tr>
                    <td class="inputlabel">Descripción : </td>
                    <td colspan="3"><textarea id="txt_Descripcion" name="txt_Descripcion" style="text-transform: uppercase;"/></textarea></td>
                </tr>
                <tr>
                    <td class="inputlabel">Observaciones : </td>
                    <td colspan="3"><textarea id="txt_Observacion" name="txt_Observacion" style="text-transform: uppercase;"/></textarea></td>
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
<div id="div_VentanaRespuesta" style="display: none">
    <div>
        <span style="float: left">RESPUESTA DEL CAMBIO</span>
    </div>
    <div style="overflow: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="inputlabel">Fecha : </td>
                <td><div id="div_FechaSolucion"></div></td>
            </tr>
            <tr>
                <td class="inputlabel">Solucion : </td>
                <td><textarea id="txt_Solucion" name="txt_Solucion" style="text-transform: uppercase;"/></textarea></td>
            </tr>          
            <tr>
                <td class="Summit" colspan="2">
                    <div>
                        <input type="button" id="btn_GuardarRespuesta"  value="Guardar" style="margin-right: 20px"/>
                        <input type="button" id="btn_CancelarRespuesta" value="Cancelar" style="margin-right: 20px"/>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Anular</li>
        <li type='separator'></li>
        <li style="font-weight: bold;">Respuesta</li>
    </ul>
</div>