<%-- 
    Document   : ListaFirmaElectronica
    Created on : 31/08/2017, 02:48:42 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var opcion = $("#cbo_opcion").val();
    var estado = $("#cbo_Estado").val();
    var msg = '';
    var lista = new Array();
    <c:forEach var="d" items="${objFirmaElectronica}">
    var result = {codigo: '${d.codigo}', SIAF: '${d.SIAF}', unidadOperativa: '${d.unidadOperativa}', documento: '${d.documento}',
        concepto: '${d.concepto}', fecha: '${d.fecha}', importe: '${d.importe}', tipo: '${d.opcion}', usuario: '${d.periodo}'};
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
                        {name: 'SIAF', type: "string"},
                        {name: 'unidadOperativa', type: "string"},
                        {name: 'documento', type: "string"},
                        {name: 'concepto', type: "string"},
                        {name: "fecha", type: "date", format: 'dd/MM/yyyy'},
                        {name: 'importe', type: "number"},
                        {name: 'tipo', type: "string"},
                        {name: 'usuario', type: "string"}
                    ],
            root: "FirmaElectronica",
            record: "FirmaElectronica",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "SIAF") {
                return "RowBold";
            }
            if (datafield === "codigo") {
                return "RowBrown";
            }
            if (datafield === "importe" && rowdata['importe'] >= 0.0) {
                return "RowBlue";
            }
            if (datafield === "importe" && rowdata['importe'] < 0.0) {
                return "RowRed";
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
            editable: true,
            enabletooltips: true,
            selectionmode: 'checkbox',
            pagesize: 100,
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
                        content: '¿Desea Realizar la Firma Electronica?',
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
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'FirmaElectronica_' + periodo + "_" + opcion);
                });
            },
            columns: [
                {text: 'CODIGO', dataField: 'codigo', filtertype: 'checkedlist', editable: false, width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'NRO SIAF', dataField: 'SIAF', filtertype: 'checkedlist', editable: false, width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'UNIDAD OPERATIVA', dataField: 'unidadOperativa', filtertype: 'checkedlist', editable: false, width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DOC. REFERENCIA', dataField: 'documento', editable: false, width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'CONCEPTO', dataField: 'concepto', editable: false, width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'importe', editable: false, width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'Ver', datafield: 'ver', width: "4%", columntype: 'button', align: 'center', cellsAlign: 'center',
                    cellsrenderer: function () {
                        return 'Ver';
                    }, buttonclick: function (row) {
                        var editrow = row;
                        var dataRecord = $("#div_GrillaPrincipal").jqxGrid('getrowdata', editrow);
                        fn_Reporte(dataRecord.unidadOperativa, dataRecord.codigo);
                    }
                },
                {text: 'FECHA', dataField: 'fecha', columntype: 'datetimeinput', filtertype: 'date', editable: false, width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'SECTORISTA', dataField: 'usuario', filtertype: 'checkedlist', editable: false, width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'TIPO', dataField: 'tipo', filtertype: 'checkedlist', editable: false, width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
        });
        function fn_Reporte(uuoo, codigo) {
            var reporte = "";
            if (opcion === 'CP')
                reporte = "EJE0007";
            if (opcion === 'CA')
                reporte = "EJE0011";
            if (opcion === 'DJ')
                reporte = "EJE0014";
            var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&presupuesto=' + presupuesto + '&unidadOperativa=' + uuoo.substring(0, 4) + '&codigo=' + codigo + '&codigo2=' + codigo;
            window.open(url, '_blank');
        }
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../FirmaElectronica",
                data: {mode: opcion, periodo: periodo, presupuesto: presupuesto, estado: estado},
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
            var rows = $('#div_GrillaPrincipal').jqxGrid('getselectedrowindexes');
            for (var i = 0; i < rows.length; i++) {
                var row = $('#div_GrillaPrincipal').jqxGrid('getrowdata', rows[i]);
                result = row.uid + "---" + row.codigo;
                lista.push(result);
            }
            if (lista.length === 0)
                msg += "Dele seleccionar al menos un registro.<br>";
            if (msg === "") {
                $.ajax({
                    type: "POST",
                    url: "../IduFirmaElectronica",
                    data: {periodo: periodo, presupuesto: presupuesto, opcion: opcion, lista: JSON.stringify(lista)},
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