<%-- 
    Document   : ListaEventoFinal
    Created on : 03/05/2017, 02:52:13 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnEvento.periodo}';
    var presupuesto = '${objBnEvento.presupuesto}';
    var unidadOperativa = '${objBnEvento.unidadOperativa}';
    var tarea = '${objBnEvento.tarea}';
    var codigo = '${objBnEvento.codigo}';
    var nivel = '${objBnEvento.nivel}';
    var duplica = null;
    var tareaDescripcion = '${objBnEvento.comentario}';
    var dependencia = null;
    var autorizacion = '${autorizacion}';
    var evento = null;
    var mode = null;
    var lista = new Array();
    <c:forEach var="d" items="${objEvento}">
    var result = {codigo: '${d.codigo}', nombreEvento: '${d.nombreEvento}', dependencia: '${d.dependencia}',
        monto: '${d.programado}', orden: '${d.orden}', codigoDependencia: '${d.unidadOperativa}',
        cantidad: '${d.cantidad}', estado: '${d.estado}'};
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
                        {name: "dependencia", type: "string"},
                        {name: "codigoDependencia", type: "string"},
                        {name: "monto", type: "number"},
                        {name: "orden", type: "number"},
                        {name: "cantidad", type: "number"},
                        {name: "estado", type: "string"}
                    ],
            root: "EventoFinal",
            record: "EventoFinal",
            id: 'codigo'
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "orden" || datafield === "monto") {
                return "RowBold";
            }
            if (datafield === "estado") {
                return "RowBlue";
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
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var addButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var reloadButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var exportButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(addButton);
                container.append(reloadButton);
                container.append(exportButton);
                toolbar.append(container);
                addButton.jqxButton({width: 30, height: 22});
                addButton.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                reloadButton.jqxButton({width: 30, height: 22});
                reloadButton.jqxTooltip({position: 'bottom', content: "Actualiza Pantalla"});
                exportButton.jqxButton({width: 30, height: 22});
                exportButton.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                // Adicionar un Nuevo Registro en la Cabecera.
                addButton.click(function (event) {
                    mode = 'I';
                    evento = 0;
                    $('#txt_NombreEvento').val('');
                    $('#div_CantidadFinal').val(0);
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.8});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                // Recarga la Data en la Grilla
                reloadButton.click(function (event) {
                    fn_Refrescar();
                });
                //export to excel
                exportButton.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'CNVGeneradoresGasto');
                });
            },
            columns: [
                {text: 'PRIORIDAD', dataField: 'orden', columngroup: 'Tarea', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'EVENTO FINAL', dataField: 'nombreEvento', columngroup: 'Tarea', width: '36%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DEPENDENCIA', dataField: 'dependencia', filtertype: 'checkedlist', columngroup: 'Tarea', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'MONTO', dataField: 'monto', columngroup: 'EventoPrincipal', width: '17%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CANT. FISICA', dataField: 'cantidad', columngroup: 'EventoPrincipal', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ESTADO', dataField: 'estado', columngroup: 'EventoPrincipal', width: '12%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'COD', dataField: 'codigoDependencia', columngroup: 'EventoPrincipal', width: '1px', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ],
            columngroups: [
                {text: '<strong>LISTADO DE EVENTOS FINALES</strong>', name: 'Titulo', align: 'center'},
                {text: '<strong>TAREA : </strong>' + tareaDescripcion, name: 'Tarea', parentgroup: 'Titulo', height: '52px'},
                {text: '<strong>EVENTO : </strong>' + codigo, name: 'EventoPrincipal', parentgroup: 'Titulo', height: '52px'}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 180, autoOpenPopup: false, mode: 'popup'});
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
            if (evento !== null || evento === '') {
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
                                    $('#txt_Codigo').val(codigo);
                                    mode = 'D';
                                    fn_GrabarDatos();
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                } else if ($.trim($(opcion).text()) === "Cerrar") {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Desea Cerrar este Evento!!',
                        theme: 'material',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'blue',
                        typeAnimated: true,
                        buttons: {
                            aceptar: {
                                text: 'Aceptar',
                                btnClass: 'btn-primary',
                                keys: ['enter', 'shift'],
                                action: function () {
                                    $('#txt_Codigo').val(codigo);
                                    mode = 'C';
                                    fn_GrabarDatos();
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                } else if ($.trim($(opcion).text()) === "Duplicar Evento") {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Desea Duplicar este Evento!!',
                        theme: 'material',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'blue',
                        typeAnimated: true,
                        buttons: {
                            aceptar: {
                                text: 'Aceptar',
                                btnClass: 'btn-primary',
                                keys: ['enter', 'shift'],
                                action: function () {
                                    duplica = evento;
                                    fn_EditarRegistro();
                                    mode = 'B';
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                } else if ($.trim($(opcion).text()) === "<-- Regresar") {
                    fn_Regresar();
                } else if ($.trim($(opcion).text()) === "Registrar Insumos") {
                    fn_Insumos();
                } else if ($.trim($(opcion).text()) === "Activar") {
                    if (autorizacion !== 'true') {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Usuario no Autorizado para realizar este Tipo de Operación',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    } else {
                        $.confirm({
                            title: 'AVISO DEL SISTEMA',
                            content: 'Desea Activar este Evento!!',
                            theme: 'material',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true,
                            buttons: {
                                aceptar: {
                                    text: 'Aceptar',
                                    btnClass: 'btn-primary',
                                    keys: ['enter', 'shift'],
                                    action: function () {
                                        $('#txt_Codigo').val(codigo);
                                        mode = 'A';
                                        fn_GrabarDatos();
                                    }
                                },
                                cancelar: function () {
                                }
                            }
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
            dependencia = row['codigoDependencia'];
            evento = row['codigo'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 550;
                var alto = 160;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarFinal'),
                    initContent: function () {
                        $("#txt_NombreEvento").jqxInput({width: 350, height: 20});
                        $("#cbo_Dependencia").jqxDropDownList({width: 250, height: 20, promptText: "Seleccione"});
                        $("#div_Prioridad").jqxNumberInput({width: 100, height: 20, max: 99, digits: 2, decimalDigits: 0, spinButtons: true});
                        $("#div_CantidadFinal").jqxNumberInput({width: 100, height: 20, max: 999, digits: 3, decimalDigits: 0});
                        $('#btn_CancelarFinal').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarFinal').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarFinal').on('click', function (event) {
                            $('#frm_EventoFinal').jqxValidator('validate');
                        });
                        $('#frm_EventoFinal').jqxValidator({
                            rules: [
                                {input: '#txt_NombreEvento', message: 'Ingrese el Nombre del Evento!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_EventoFinal').jqxValidator({
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
            fn_cargarComboAjax("#cbo_Dependencia", {mode: 'dependenciaProgramacionMultianual', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea});
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
                url: "../EventoFinal",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, codigo: codigo, nivel: nivel},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../EventoFinal",
                data: {mode: 'U', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, codigo: codigo, eventoFinal: evento},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 4) {
                        $('#txt_NombreEvento').val(dato[0]);
                        $("#cbo_Dependencia").jqxDropDownList('selectItem', dato[1]);
                        $('#div_Prioridad').val(dato[2]);
                        $('#div_CantidadFinal').val(dato[3]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var nombreEvento = $("#txt_NombreEvento").val();
            var dependencia = $("#cbo_Dependencia").val();
            var orden = $("#div_Prioridad").val();
            var cantidad = $("#div_CantidadFinal").val();
            var msg = "";
            $.ajax({
                type: "POST",
                url: "../IduEventoFinal",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                    tarea: tarea, codigo: codigo, eventoFinal: evento, dependencia: dependencia,
                    nombreEvento: nombreEvento, orden: orden, cantidad: cantidad},
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
        function fn_Insumos() {
            $("#div_ContextMenu").remove();
            $("#div_GrillaTotales").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../HojaTrabajo",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: tarea, eventoPrincipal: codigo, nivel: nivel, eventoFinal: evento, dependencia: dependencia},
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
        <span style="float: left">EVENTO FINAL</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_EventoFinal" name="frm_EventoFinal" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Nombre Evento : </td>
                    <td><input type="text" id="txt_NombreEvento" name="txt_NombreEvento" style="text-transform: uppercase;"/></td>
                </tr> 
                <tr>
                    <td class="inputlabel">Dependencia : </td>
                    <td>
                        <select id="cbo_Dependencia" name="cbo_Dependencia">
                            <option value="0">Seleccione</option>                                
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Orden : </td>
                    <td><div id="div_Prioridad"></div></td>                          
                </tr>  
                <tr>
                    <td class="inputlabel">Cantidad : </td>
                    <td><div id="div_CantidadFinal"></div></td>                          
                </tr>  
                <tr>
                    <td class="Summit" colspan="2">
                        <div>
                            <input type="button" id="btn_GuardarFinal"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarFinal" value="Cancelar" style="margin-right: 20px"/> 
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
        <li>Cerrar</li> 
        <li>Duplicar Evento</li>         
        <li><-- Regresar</li> 
        <li>Registrar Insumos</li>
        <li>Activar</li>
    </ul>
</div>

