<%-- 
    Document   : ListaEventoPrincipalTotal
    Created on : 03/02/2017, 01:33:50 PM
    Author     : H-UTBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    if (autorizacion === 'false') {
        window.location = "../Error/PaginaMantenimiento.jsp";
    }
    var codigo = null;
    var lista = new Array();
    <c:forEach var="c" items="${objEvento}">
    var result = {codigo: '${c.codigo}', tarea: '${c.tarea}', cantidad: '${c.cantidad}', unidadMedida: '${c.unidadMedida}',
        total: '${c.total}', programado: '${c.programado}', diferencia: '${c.programado-c.total}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA DE LA CABECERA  
        var sourceTotales = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "tarea", type: "string"},
                        {name: "cantidad", type: "number"},
                        {name: "unidadMedida", type: "string"},
                        {name: "total", type: "number"},
                        {name: "programado", type: "number"},
                        {name: "diferencia", type: "number"}
                    ],
            root: "EventoPrincipalTotales",
            record: "EventoPrincipal",
            id: 'codigo'
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "total") {
                return "RowBold";
            }
            if (datafield === "programado") {
                return "RowBlue";
            }
            if (datafield === "diferencia") {
                return "RowBrown";
            }
            if (datafield === "cantidad") {
                return "RowGreen";
            }
        };
        $("#div_GrillaTotales").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 60),
            source: sourceTotales,
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
            pagesize: 30,
            showaggregates: true,
            statusbarheight: 25,
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
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reporte"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaTotales").jqxGrid('exportdata', 'xls', 'TotalCNV');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON REPORTE
                ButtonReporte.click(function (event) {
                    var url = '../Reportes?reporte=PROG0001&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto;
                    window.open(url, '_blank');
                });
            },
            columns: [
                {text: 'N°', align: 'center', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'TAREA', dataField: 'tarea', width: '48%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'META FISICA', dataField: 'cantidad', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'number', cellclassname: cellclass},
                {text: 'UU/MM', dataField: 'unidadMedida', width: '8%', filtertype: 'checkedlist', align: 'center', cellsAlign: 'center', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'TOTAL', dataField: 'total', width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PROGRAMADO', dataField: 'programado', width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DIFERENCIA', dataField: 'diferencia', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 30, autoOpenPopup: false, mode: 'popup'});
        $("#div_GrillaTotales").on('contextmenu', function () {
            return false;
        });
        // handle context menu clicks.
        $("#div_GrillaTotales").on('rowclick', function (event) {
            if (event.args.rightclick) {
                $("#div_GrillaTotales").jqxGrid('selectrow', event.args.rowindex);
                var scrollTop = $(window).scrollTop();
                var scrollLeft = $(window).scrollLeft();
                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
                return false;
            }
        });
        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaTotales").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaTotales").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
        });
    });
    $("#div_ContextMenu").on('itemclick', function (event) {
        var opcion = event.args;
        if ($.trim($(opcion).text()) === "Crear Eventos") {
            fn_verEventos();
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
    function fn_verEventos() {
        $("#div_ContextMenu").remove();
        $("#div_GrillaTotales").remove();
        $("#div_GrillaPrincipal").remove();
        $("#div_VentanaPrincipal").remove();
        $("#div_VentanaDetalle").remove();
        $("#div_Reporte").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "POST",
            url: "../EventoPrincipal",
            data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tarea: codigo},
            success: function (data) {
                $contenidoAjax.html(data);
            }
        });
    }
</script>
<div id="div_GrillaTotales"></div>
<div id='div_ContextMenu'>
    <ul>        
        <li>Crear Eventos</li>
    </ul>
</div>

