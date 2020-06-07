<%-- 
    Document   : ListaEventoSecundario
    Created on : 05/02/2017, 04:25:39 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnEvento.periodo}';
    var presupuesto = '${objBnEvento.presupuesto}';
    var unidadOperativa = '${objBnEvento.unidadOperativa}';
    var tarea = '${objBnEvento.tarea}';
    var codigo = '${objBnEvento.codigo}';
    var tareaDescripcion = '${objBnEvento.comentario}';
    var nivel = '${objBnEvento.nivel}';
    var niveles = '${objBnEvento.niveles}';
    var tipo = '${objBnEvento.mode}';
    var mode = null;
    var lista = new Array();
    <c:forEach var="d" items="${objEvento}">
    var result = {codigo: '${d.codigo}', nombreEvento: '${d.nombreEvento}', monto: '${d.total}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA DE LA CABECERA  
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "nombreEvento", type: "string"},
                        {name: "monto", type: "number"},
                        {name: "blanco", type: "string"}
                    ],
            root: "EventoSecundario",
            record: "EventoSecundario",
            id: 'codigo'
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "codigo" || datafield === "monto") {
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
            editable: false,
            showtoolbar: true,
            showstatusbar: true,
            showaggregates: true,
            statusbarheight: 25,
            pagesize: 30,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var addButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var reloadButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var exportButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonReporte = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(addButton);
                container.append(reloadButton);
                container.append(exportButton);
                container.append(ButtonReporte);
                toolbar.append(container);
                addButton.jqxButton({width: 30, height: 22});
                addButton.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                reloadButton.jqxButton({width: 30, height: 22});
                reloadButton.jqxTooltip({position: 'bottom', content: "Actualiza Pantalla"});
                exportButton.jqxButton({width: 30, height: 22});
                exportButton.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonReporte.jqxButton({width: 30, height: 22});
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reporte"});
                // Adicionar un Nuevo Registro en la Cabecera.
                addButton.click(function (event) {
                    mode = 'I';
                    evento = 0;
                    $('#txt_NombreEvento').val('');
                    $.ajax({
                        type: "GET",
                        url: "../EventoSecundario",
                        data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, codigo: codigo, nivel: nivel},
                        success: function (data) {
                            $('#txt_CodigoEvento').val(data);
                        }
                    });
                    $('#txt_NombreEvento').jqxInput('focus');
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.8});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                // Recarga la Data en la Grilla
                reloadButton.click(function (event) {
                    fn_Refrescar();
                });
                //export to excel
                exportButton.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'CNVEventosSecundarios');
                });
                //reporte
                ButtonReporte.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            columns: [
                {
                    text: 'N°', sortable: false, filterable: false, editable: false,
                    groupable: false, draggable: false, resizable: false, align: 'center',
                    datafield: '', columntype: 'number', width: '3%', pinned: true,
                    cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'CODIGO', dataField: 'codigo', columngroup: 'EventoPrincipal', filtertype: 'checkedlist', width: '24%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'EVENTO SECUNDARIO', dataField: 'nombreEvento', columngroup: 'Tarea', width: '45%', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'MONTO', dataField: 'monto', columngroup: 'Tarea', width: '15%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: '', dataField: 'blanco', columngroup: 'Nivel', filterable: false, width: '13%', align: 'center', cellsAlign: 'left', cellclassname: cellclass}
            ],
            columngroups: [
                {text: '<strong>LISTADO DE EVENTOS SECUNDARIOS</strong>', name: 'Titulo', align: 'center'},
                {text: '<strong>EVENTO ANTERIOR : </strong>' + codigo, name: 'EventoPrincipal', parentgroup: 'Titulo'},
                {text: '<strong>TAREA : </strong>' + tareaDescripcion, name: 'Tarea', parentgroup: 'Titulo'},
                {text: '<strong>NIVEL : </strong>' + nivel + '<strong> de </strong>' + niveles, name: 'Nivel', parentgroup: 'Titulo', height: '80px'}

            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 105, autoOpenPopup: false, mode: 'popup'});
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
            if (codigo !== null || codigo === '') {
                if ($.trim($(opcion).text()) === "Editar") {
                    mode = 'U';
                    fn_EditarRegistro();
                } else if ($.trim($(opcion).text()) === "Eliminar") {
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
                                    $('#txt_CodigoEvento').val(codigo);
                                    mode = 'D';
                                    fn_GrabarDatos();
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                } else if ($.trim($(opcion).text()) === "<-- Anterior") {
                    fn_Regresar();
                } else if ($.trim($(opcion).text()) === "Siguiente -->") {
                    fn_Siguiente();
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
        });
        //Seleccionar un Registro de la Cabecera
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
                var ancho = 550;
                var alto = 110;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_CodigoEvento").jqxInput({width: 150, height: 20, disabled: true});
                        $("#txt_NombreEvento").jqxInput({width: 400, height: 20});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function (event) {
                            $('#frm_EventoSecundario').jqxValidator('validate');
                        });
                        $('#frm_EventoSecundario').jqxValidator({
                            rules: [
                                {input: '#txt_NombreEvento', message: 'Ingrese el Nombre del Evento!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_EventoSecundario').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatos();
                            }
                        });
                    }
                });
                ancho = 400;
                alto = 105;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_Reporte').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CerrarImprimir'),
                    initContent: function () {
                        $("#div_PROG0001").jqxRadioButton({width: 200, height: 20});
                        $('#div_PROG0001').on('checked', function (event) {
                            reporte = 'PROG0013';
                        });
                        $("#div_PROG0002").jqxRadioButton({width: 200, height: 20});
                        $('#div_PROG0002').on('checked', function (event) {
                            reporte = 'PROG0002';
                        });
                        $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').on('click', function (event) {
                            var msg = "";
                            switch (reporte) {
                                case "PROG0002":
                                    break;
                                case "PROG0013":
                                    break;
                                default:
                                    msg += "Debe selecciona una opción.<br>";
                                    break;
                            }
                            if (msg === "") {
                                var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto + '&codigo=' + codigo;
                                window.open(url, '_blank');
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
        //FUNCION PARA REFRESCAR LA PANTALLA
        function fn_Refrescar() {
            $("#div_ContextMenu").remove();
            $("#div_GrillaTotales").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../EventoSecundario",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, codigo: '${objBnEvento.codigo}', nivel: nivel},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../EventoSecundario",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, codigo: codigo, nivel: nivel},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 2) {
                        $('#txt_CodigoEvento').val(dato[0]);
                        $('#txt_NombreEvento').val(dato[1]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.8});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var codigoEvento = $("#txt_CodigoEvento").val();
            var nombreEvento = $("#txt_NombreEvento").val();
            var msg = "";
            $.ajax({
                type: "POST",
                url: "../IduEventoSecundario",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea,
                    codigoEvento: codigoEvento, nombreEvento: nombreEvento, nivel: nivel, niveles: niveles},
                success: function (data) {
                    msg = data;
                    if (msg === "GUARDO") {
                        $('#div_VentanaPrincipal').jqxWindow('close');
                        fn_Refrescar();
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
        function fn_Siguiente() {
            $("#div_ContextMenu").remove();
            $("#div_GrillaTotales").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../EventoSecundario",
                data: {mode: 'ES', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, codigo: codigo, nivel: nivel},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        function fn_Regresar() {
            $("#div_ContextMenu").remove();
            $("#div_GrillaTotales").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../EventoSecundario",
                data: {mode: 'EP', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, codigo: codigo, nivel: nivel},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">EVENTO SECUNDARIO - Nivel : ${objBnEvento.nivel}</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_EventoSecundario" name="frm_EventoSecundario" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Evento : </td>
                    <td><input type="text" id="txt_CodigoEvento" name="txt_CodigoEvento" style="text-transform: uppercase;"/></td>
                </tr> 
                <tr>
                    <td class="inputlabel">Nombre : </td>
                    <td><input type="text" id="txt_NombreEvento" name="txt_NombreEvento" style="text-transform: uppercase;"/></td>
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
<div id='div_ContextMenu' style='display: none; '>
    <ul>
        <li>Editar</li>
        <li>Eliminar</li>
        <li><-- Anterior</li>
        <li>Siguiente --></li>
    </ul>
</div>
<div style="display: none" id="div_Reporte">
    <div>
        <span style="float: left">LISTADO DE REPORTES</span>
    </div>
    <div style="overflow: hidden">
        <div id='div_PROG0001'>Resumen</div>
        <div id='div_PROG0002'>CNV</div>        
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>
