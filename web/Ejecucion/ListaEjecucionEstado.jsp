<%-- 
    Document   : ListaEjecucionEstado
    Created on : 09/11/2017, 08:38:57 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var opcion = $("#cbo_opcion").val();
    var desde = $("#div_Desde").val();
    var hasta = $("#div_Hasta").val();
    var msg = '';
    var lista = new Array();
    <c:forEach var="d" items="${objEjecucionEstado}">
    var result = {codigo: '${d.opcion}', unidadOperativa: '${d.unidadOperativa}', habilitado: '${d.tipo}', desde: '${d.desde}', hasta: '${d.hasta}'};
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
                        {name: 'unidadOperativa', type: "string"},
                        {name: 'habilitado', type: "bool"},
                        {name: 'desde', type: "string"},
                        {name: 'hasta', type: "string"},
                        {name: 'blanco', type: "string"}

                    ],
            root: "HabilitarEjecucion",
            record: "HabilitarEjecucion",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "codigo") {
                return "RowBrown";
            }
        };
        //DEFINIMOS LOS CAMPOS Y DATOS DE LA GRILLA
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 80),
            source: dataAdapter,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            showtoolbar: true,
            sortable: true,
            pageable: true,
            columnsresize: true,
            editable: true,
            enabletooltips: true,
            selectionmode: 'singlerow',
            editmode: 'selectedrow',            
            rendertoolbar: function (toolbar) {
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonGuardar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/save42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonGuardar);
                container.append(ButtonExportar);
                toolbar.append(container);
                ButtonGuardar.jqxButton({width: 30, height: 22});
                ButtonGuardar.jqxTooltip({position: 'bottom', content: "Guardar Datos"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON GUARDAR DATOS
                ButtonGuardar.click(function (event) {
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: '¿Desea Guardar los Cambios?',
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
                                    fn_GrabarDatos();
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'HabilitarEjecucion');
                });
            },
            columns: [
                {text: 'NRO', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', align: 'center', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'UNIDAD OPERATIVA', dataField: 'unidadOperativa', editable: false, width: '30%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'HABILITAR', datafield: 'habilitado', columntype: 'checkbox', width: '10%', align: 'center', cellsAlign: 'center'},
                {text: 'DESDE', dataField: 'desde', editable: false, width: '12%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'HASTA', dataField: 'hasta', editable: false, width: '12%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: '', dataField: 'blanco', editable: false, width: '34%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../EjecucionEstado",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, opcion: opcion},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var msg = "";
            var lista = new Array();
            var result;
            var rows = $('#div_GrillaPrincipal').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                result = row.codigo + "---" + row.habilitado;
                lista.push(result);
            }
            if (lista.length === 0)
                msg += "Dele seleccionar al menos un registro.<br>";
            if (msg === "") {
                $.ajax({
                    type: "POST",
                    url: "../IduEjecucionEstado",
                    data: {periodo: periodo, presupuesto: presupuesto, opcion: opcion, desde: desde, hasta: hasta, lista: JSON.stringify(lista)},
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
    });
</script>
<div id="div_GrillaPrincipal"></div>