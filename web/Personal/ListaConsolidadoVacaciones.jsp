<%-- 
    Document   : ListaConsolidadoVacaciones
    Created on : 12/06/2018, 04:08:43 PM
    Author     : H-TECCSI-V
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
    .btn {
        border: none; /* Remove borders */
        color: white; /* Add a text color */
        padding: 1px 10px; /* Add some padding */
        cursor: pointer; /* Add a pointer cursor on mouse-over */
        border-radius: 8px;
    }
    .success {background-color: #4CAF50;} /* Green */
    .success:hover {background-color: #46a049;}
</style>
<script type="text/javascript">
    var periodo = '${objBnConsolidadoVacaciones.periodo}';
    var codigo = "";
    var nombres = "";
    var mode = null;
    var msg = '';
    var lista = new Array();
    var indiceDetalle = -1;
    var codigoVacaciones = "";
    <c:forEach var="d" items="${objConsolidadoVacaciones}">
    var result = {codigoPersonal: '${d.codigoPersonal}', nombres: '${d.nombres}', diasSolicitados: '${d.diasSolicitado}', diasRestantes: '${d.diasRestantes}', diasHabiles: '${d.diasDisponible}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigoPersonal', type: "string"},
                        {name: 'nombres', type: "string"},
                        {name: 'diasSolicitados', type: "number"},
                        {name: 'diasRestantes', type: "number"},
                        {name: 'diasHabiles', type: "number"}
                    ],
            root: "ConsolidadoVacaciones",
            record: "ConsolidadoVacaciones",
            id: 'codigoPersonal'
        };
        //PARA LA GRILLA DE DETALLE VACACIONES
        var sourceDetalleVacaciones = {
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "empieza", type: "string"},
                        {name: "termina", type: "string"},
                        {name: "dias", type: "number"},
                        {name: "estado", type: "string"}
                    ],
            pagesize: 50,
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            }
        };
        var dataDetalle = new $.jqx.dataAdapter(sourceDetalleVacaciones);
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (rowdata['estado'] === "APROBADO") {
                return "RowBlue";
            }
            if (datafield === "dias") {
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
            showtoolbar: true,
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            editable: false,
            pagesize: 30,
            rendertoolbar: function (toolbar) {
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");

                container.append(ButtonExportar);
                toolbar.append(container);
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});

                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ConsolidadoVacaciones');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: 10, pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'DNI', dataField: 'codigoPersonal', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'NOMBRES Y APELLIDOS', dataField: 'nombres', width: '35%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DIAS HÁBILES', dataField: 'diasHabiles', width: '10%', align: 'center', cellsAlign: 'center'},
                {text: 'DIAS SOLICITADOS', dataField: 'diasSolicitados', width: '10%', align: 'center', cellsAlign: 'center',
                    cellsrenderer: function (row, column, value) {
                        var dSolicitados = 30 - parseInt(value);
                        return "<div style='margin:4px; text-align: center;'>" + dSolicitados + "</div>";
                    }
                },
                {text: 'QUEDAN', dataField: 'diasRestantes', width: '10%', align: 'center', cellsAlign: 'center'}
            ]
        });

        //GRILLA RELACION NOMINAL
        $("#div_GrillaRelacionVacaciones").jqxGrid({
            width: '100%',
            height: '400',
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
            filterable: true,
            showaggregates: true,
            statusbarheight: 25,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var reporteButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(reporteButton);
                toolbar.append(container);
                reporteButton.jqxButton({width: 30, height: 22});
                reporteButton.jqxTooltip({position: 'bottom', content: "Reporte"});
                reporteButton.click(function (event) {
                    if (indiceDetalle >= 0) {
                        var dataRecord = $("#div_GrillaRelacionVacaciones").jqxGrid('getrowdata', indiceDetalle);
                        codigoVacaciones = dataRecord.codigo;
                        var url = '../Reportes?periodo=' + periodo + '&codigo=' + codigoVacaciones + "&reporte=PER0003&codigo2=" + codigo;
                        window.open(url, '_blank');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'SELECCIONE UN REGISTRO',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }

                });
            },
            columns: [
                {text: 'N°', datafield: 'codigo', width: "6%", align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'EMPIEZA', datafield: 'empieza', width: "25%", align: 'center', cellclassname: cellclass},
                {text: 'TERMINA', datafield: 'termina', width: "25%", align: 'center', cellclassname: cellclass},
                {text: 'DIAS SOLICITADO', datafield: 'dias', width: "15%", align: 'center', cellsFormat: 'f0', aggregates: ['sum'], cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ESTADO', datafield: 'estado', width: "10%", align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: '', datafield: 'Rechazar', align: 'center', width: "10%", columntype: 'button',
                    cellsrenderer: function () {
                        return "Rechazar";
                    },
                    buttonclick: function (row) {
                        editrow = row;
                        var dataRecord = $("#div_GrillaRelacionVacaciones").jqxGrid('getrowdata', editrow);
                        codigoVacaciones = dataRecord.codigo;
                        $('#div_ObservacionVacaciones').jqxWindow({isModal: true});
                        $('#div_ObservacionVacaciones').jqxWindow('open');
                    }
                },
                {text: '', datafield: 'Aprobar', align: 'center', width: "10%", columntype: 'button',
                    cellsrenderer: function () {
                        return "Aprobar";
                    },
                    buttonclick: function (row) {
                        editrow = row;
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea aprobar el registro seleccionado?',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'blue',
                            typeAnimated: true,
                            buttons: {
                                aceptar: {
                                    action: function () {
                                        mode = 'A';
                                        var dataRecord = $("#div_GrillaRelacionVacaciones").jqxGrid('getrowdata', editrow);
                                        codigoVacaciones = dataRecord.codigo;
                                        fn_GrabarDatos();
                                    }
                                },
                                cancelar: function () {
                                }
                            }
                        });


                    }
                }
            ]
        });
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
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigoPersonal'];
            nombres = row['nombres'];
        });

        $("#div_GrillaRelacionVacaciones").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;

        });

        //DEFINIMOS LOS EVENTOS SEGUN LA OPCION DEL MENU CONTEXTUAL  
        $("#div_ContextMenu").on('itemclick', function (event) {
            var opcion = event.args;
            if ($.trim($(opcion).text()) === "Ver Detalle") {
                $('#txt_NombrePersonal').val('');
                $('#txt_NombrePersonal').val(nombres);
                fn_DatosVacacionesPersonal();
                $('#div_VentanaDetalleVacaciones').jqxWindow({isModal: true});
                $('#div_VentanaDetalleVacaciones').jqxWindow('open');
            } else {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'Debe seleccionar un registro.',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            }
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                //ventana lista relacion nominal jadpe
                ancho = 800;
                alto = 500;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaDetalleVacaciones').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    initContent: function () {
                        $('#div_VentanaDetalleVacaciones').on('close', function (event) {
                            $('#div_VentanaDetalleVacaciones').jqxWindow({isModal: false});
                        });
                        $("#txt_NombrePersonal").jqxInput({placeHolder: "Nombre", width: 450, height: 20, disabled: true});
                    }
                });

                //VENTANA DE OBSERVACION
                ancho = 500;
                alto = 175;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_ObservacionVacaciones').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarObservacion'),
                    initContent: function () {
                        $('#div_ObservacionVacaciones').on('close', function (event) {
                            $('#div_ObservacionVacaciones').jqxWindow({isModal: false});
                        });
                        $("#txt_Observacion").jqxInput({placeHolder: 'Ingrese observacion', height: 90, width: 400, maxLength: 1000, minLength: 1});
                        $("#txt_Observacion").val("");
                        $('#btn_CancelarObservacion').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarObservacion').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarObservacion').on('click', function (event) {
                            var msg = "";
                            if (msg === "") {
                                $('#frm_IngresoObservacion').jqxValidator('validate');
                            }
                        });
                        $('#frm_IngresoObservacion').jqxValidator({
                            rules: [
                                {input: '#txt_Observacion', message: 'Ingrese la observacion', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Observacion', message: 'Ingrese sustento de la observacion', action: 'keyup', rule: 'length=5,1000'}
                            ]
                        });
                        $('#frm_IngresoObservacion').jqxValidator({
                            onSuccess: function () {
                                mode = 'R';
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
        //funcion para listar todas las vacaciones del personal
        function fn_DatosVacacionesPersonal() {
            $("#div_GrillaRelacionVacaciones").jqxGrid('clear');
            $.ajax({
                type: "GET",
                url: "../ConsolidadoVacaciones",
                data: {mode: 'B', periodo: periodo, codigoPersonal: codigo},
                success: function (data) {
                    data = data.replace("[", "");
                    var fila = data.split("[");
                    var rows = new Array();
                    for (i = 1; i < fila.length; i++) {
                        var columna = fila[i];
                        var datos = columna.split("+++");
                        while (datos[4].indexOf(']') > 0) {
                            datos[4] = datos[4].replace("]", "");
                        }
                        while (datos[4].indexOf(',') > 0) {
                            datos[4] = datos[4].replace(",", "");
                        }
                        var row = {codigo: datos[0], empieza: datos[1], termina: datos[2], dias: parseInt(datos[3]), estado: datos[4]};
                        rows.push(row);
                    }
                    if (rows.length > 0)
                        $("#div_GrillaRelacionVacaciones").jqxGrid('addrow', null, rows);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var observacion = $("#txt_Observacion").val();
            $.ajax({
                type: "POST",
                url: "../IduConsolidadoVacaciones",
                data: {mode: mode, periodo: periodo, codigoPersonal: codigo, correlativo: codigoVacaciones, observacion: observacion},
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
                                        $('#div_VentanaDetalleVacaciones').jqxWindow({isModal: true});
                                        fn_RefrescarConsolidado();
                                        $('#div_ObservacionVacaciones').jqxWindow('close');
                                        //();
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
        //
        function fn_RefrescarConsolidado() {
            $("#div_GrillaRelacionVacaciones").jqxGrid('clear');
            fn_DatosVacacionesPersonal();
        }
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_GrillaPrincipal").remove();
            //$("#div_VentanaDetalleVacaciones").remove();
            //$("#div_GrillaRelacionVacaciones").remove();
            $("#div_ObservacionVacaciones").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../ConsolidadoVacaciones",
                data: {mode: 'G', periodo: periodo},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }

    });

</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal"></div>
<div id='div_ContextMenu' style='display:none;'>
    <ul>
        <li>Ver Detalle</li>
    </ul>
</div>
<div style="display: none" id="div_VentanaDetalleVacaciones">
    <div>
        <span style="float: left">GESTIÓN VACACIONES DEL PERSONAL</span>
    </div>
    <div style="overflow: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="inputlabel">Personal : </td>
                <td><input type="text" id="txt_NombrePersonal" name="txt_NombrePersonal" style="text-transform: uppercase;"/></td> 
            </tr>
            <tr>
                <td class="inputlabel">&zwj;</td>
            </tr>
            <tr>
                <td colspan="4">
                    <div id="div_GrillaRelacionVacaciones">         
                    </div>
                </td>  
            </tr>
        </table>          
    </div>
</div>
<div id="div_ObservacionVacaciones" style="display: none">
    <div>
        <span style="float: left">OBSERVACION VACACIONES</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_IngresoObservacion" name="frm_IngresoObservacion" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Observación : </td>
                    <td><textarea id="txt_Observacion" name="txt_Observacion" style="text-transform: uppercase;"/></textarea></td> 
                </tr>
                <tr>
                    <td class="Summit" colspan="2">
                        <div>
                            <input type="button" id="btn_GuardarObservacion"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarObservacion" value="Cancelar" style="margin-right: 20px"/>                            
                        </div>
                    </td>
                </tr>
            </table>  
        </form>
    </div>
</div>

