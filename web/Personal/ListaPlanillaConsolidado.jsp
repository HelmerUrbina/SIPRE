<%-- 
    Document   : ListaPlanillaConsolidado
    Created on : 31/01/2018, 05:15:30 PM
    Author     : hateccsiv
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnPlanillaMovilidad.periodo}';
    var mes = '${objBnPlanillaMovilidad.mes}';
    var codigo = "";
    var mode = null;
    var msg = '';
    var lista = new Array();
    <c:forEach var="d" items="${objPlanillaMovilidad}">
    var result = {codigoUsuario: '${d.usuarioPlanilla}', usuario: '${d.justificacion}', importe: '${d.importe}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigoUsuario', type: "string"},
                        {name: 'usuario', type: "string"},
                        {name: 'importe', type: "number"}
                    ],
            root: "PlanillaConsolidado",
            record: "PlanillaConsolidado",
            id: 'codigoUsuario'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {

        };
        var cellclassDet = function (row, datafield, value, rowdata) {

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
            showaggregates: true,
            showstatusbar: true,
            editable: false,
            pagesize: 30,
            rendertoolbar: function (toolbar) {
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonReporte = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonExportar);
                container.append(ButtonReporte);
                toolbar.append(container);
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonReporte.jqxButton({width: 30, height: 22});
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reporte Planilla"});

                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'DecretoDocumentos');
                });
                ButtonReporte.click(function (event) {
                    var url = '../Reportes?periodo=' + periodo + '&tipo=' + mes + "&reporte=PER0002";
                    window.open(url, '_blank');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: 10, pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'DNI', dataField: 'codigoUsuario', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'USUARIO', dataField: 'usuario', filtertype: 'checkedlist', width: '35%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'importe', width: '10%', align: 'center', cellsAlign: 'center', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
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
            codigo = row['codigoUsuario'];
        });
        //DEFINIMOS LOS EVENTOS SEGUN LA OPCION DEL MENU CONTEXTUAL  
        $("#div_ContextMenu").on('itemclick', function (event) {
            var opcion = event.args;
            if ($.trim($(opcion).text()) === "Rechazar") {
                mode = 'R';
                $.confirm({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'Desea rechazar la planilla seleccionada?',
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
                                $("#div_FechaMovilidad").val('01/01/2017');
                                fn_GrabarDatos();
                            }
                        },
                        cancelar: function () {
                        }
                    }
                });
            }
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 250;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
            }
            return {init: function () {
                    _createElements();
                }
            };
        }());
        $(document).ready(function () {
            customButtonsDemo.init();
        });
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {

            $.ajax({
                type: "POST",
                url: "../IduConsolidadoMovilidad",
                data: {mode: mode, periodo: periodo, mes: mes, codigo: codigo},
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
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_GrillaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../PlanillaConsolidado",
                data: {mode: 'G', periodo: periodo, mes: mes},
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
        <li>Rechazar</li>
    </ul>
</div>
