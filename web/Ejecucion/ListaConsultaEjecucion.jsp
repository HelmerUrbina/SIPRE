<%-- 
    Document   : ListaConsultaEjecucion
    Created on : 28/03/2018, 08:37:06 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var lista = new Array();
    <c:forEach var="d" items="${objConsultaEjecucion}">
    var result = {periodo: '${d.periodo}', fuenteFinanciamiento: '${d.presupuesto}', unidadOperativa: '${d.unidadOperativa}', categoriaPresupuestal: '${d.categoriaPresupuestal}',
        producto: '${d.producto}', actividad: '${d.actividad}', finalidad: '${d.funcion}', secuencia: '${d.secuencia}', tarea: '${d.tarea}', cadenaGasto: '${d.cadenaGasto}',
        genericaGasto: '${d.genericaGasto}', subGenerica: '${d.subGenerica}', subGenericaDetalle: '${d.subGenericaDetalle}', pia: '${d.PIA}', pim: '${d.PIM}', certificado: '${d.certificado}',
        saldoCertificado: '${d.PIM-d.certificado}', compromisoAnual: '${d.notaModificatoria}', saldoCompromisoAnual: '${d.PIM-d.notaModificatoria}',
        compromisoMensual: '${d.informe}', saldoCompromisoMensual: '${d.PIM-d.informe}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA DE LA CABECERA  
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'periodo', type: "string"},
                        {name: 'fuenteFinanciamiento', type: "string"},
                        {name: 'unidadOperativa', type: "string"},
                        {name: 'categoriaPresupuestal', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'actividad', type: "string"},
                        {name: 'secuencia', type: "string"},
                        {name: 'finalidad', type: "string"},
                        {name: 'tarea', type: "string"},
                        {name: 'cadenaGasto', type: "string"},
                        {name: 'genericaGasto', type: "string"},
                        {name: 'subGenerica', type: "string"},
                        {name: 'subGenericaDetalle', type: "string"},
                        {name: 'pia', type: "number"},
                        {name: 'pim', type: "number"},
                        {name: 'certificado', type: "number"},
                        {name: 'saldoCertificado', type: "number"},
                        {name: 'compromisoAnual', type: "number"},
                        {name: 'saldoCompromisoAnual', type: "number"},
                        {name: 'compromisoMensual', type: "number"},
                        {name: 'saldoCompromisoMensual', type: "number"}
                    ],
            root: "ConsultaEjecucion",
            record: "ConsultaEjecucion"
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "pia" || datafield === "pim") {
                return "RowBold";
            }
            if (datafield === "certificado") {
                return "RowBlue";
            }
            if (datafield === "compromisoAnual") {
                return "RowDarkBlue";
            }
            if (datafield === "compromisoMensual") {
                return "RowGreen";
            }
            if (datafield === "saldoCertificado" || datafield === "saldoCompromisoAnual" || datafield === "saldoCompromisoMensual") {
                return "RowRed";
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
            groupable: true,
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            columnsreorder: true,
            showfilterrow: true,
            showtoolbar: true,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonReporte = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonExportar);
                container.append(ButtonReporte);
                toolbar.append(container);
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonReporte.jqxButton({width: 30, height: 22});
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reportes"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    // $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ConsultaEjecucion');
                    var periodo = $("#cbo_Periodo").val();
                    var presupuesto = $("#cbo_Presupuesto").val();
                    var categoriaPresupuestal = "";
                    var producto = "";
                    var pip = $("#chk_pip").val();
                    if (pip) {
                        categoriaPresupuestal = "";
                        producto = "";
                    } else {
                        var itemsCategoria = $("#cbo_CategoriaPresupuestal").jqxComboBox('getCheckedItems');
                        $.each(itemsCategoria, function (index) {
                            categoriaPresupuestal += ", " + this.value;
                        });
                        var itemsProducto = $("#cbo_Producto").jqxComboBox('getCheckedItems');
                        $.each(itemsProducto, function (index) {
                            producto += ", " + this.value;
                        });
                    }
                    var url = '../ConsultaEjecucion?mode=E&periodo=' + periodo + '&presupuesto=' + presupuesto + '&pip=' + pip + '&categoriaPresupuestal=' + categoriaPresupuestal + '&producto=' + producto;
                    window.open(url, '_blank');
                });
                ButtonReporte.click(function (event) {
                    var codigo = " ";
                    var periodo = $("#cbo_Periodo").val();
                    var presupuesto = $("#cbo_Presupuesto").val();
                    var categoriaPresupuestal = "";
                    var producto = "";
                    var pip = $("#chk_pip").val();
                    if (pip) {
                        categoriaPresupuestal = "";
                        producto = "";
                    } else {
                        var itemsCategoria = $("#cbo_CategoriaPresupuestal").jqxComboBox('getCheckedItems');
                        $.each(itemsCategoria, function (index) {
                            categoriaPresupuestal += "," + this.value;
                        });
                        var itemsProducto = $("#cbo_Producto").jqxComboBox('getCheckedItems');
                        $.each(itemsProducto, function (index) {
                            producto += "," + this.value;
                        });
                    }
                    if (pip) {
                        codigo = " AND UTIL_NEW.FUN_CODIGO_SECFUN(CODPER, COPPTO, SECFUN, 'CODACT') IN ('6000005','6000008') ";
                    } else {
                        if (categoriaPresupuestal.length > 0) {
                            codigo = " AND UTIL_NEW.FUN_CODIGO_SECFUN(CODPER, COPPTO, SECFUN, 'COPRES') IN (" + categoriaPresupuestal.replace(',', '') + ") ";
                            if (producto.length > 0) {
                                codigo += " AND UTIL_NEW.FUN_CODIGO_SECFUN(CODPER, COPPTO, SECFUN, 'CODCOM') IN (" + producto.replace(',', '') + ") ";
                            }
                        }
                    }
                    var url = '../Reportes?reporte=EJE0043&periodo=' + periodo + '&presupuesto=' + presupuesto + '&codigo=' + codigo;
                    window.open(url, '_blank');
                });
            },
            columns: [
                {text: 'PERIODO', dataField: 'periodo', width: '4%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FTE. FTO.', dataField: 'fuenteFinanciamiento', filtertype: 'checkedlist', width: '4%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'UU/OO', dataField: 'unidadOperativa', filtertype: 'checkedlist', width: '8%', align: 'center', cellclassname: cellclass},
                {text: 'CAT. PPTAL.', dataField: 'categoriaPresupuestal', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'PRODUCTO', dataField: 'producto', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'ACTIVIDAD', dataField: 'actividad', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'SEC. FUNCIONAL', dataField: 'secuencia', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'FINALIDAD', dataField: 'finalidad', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'TAREA', dataField: 'tarea', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'CADENA GASTO', dataField: 'cadenaGasto', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'PIA', dataField: 'pia', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'PIM', dataField: 'pim', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'CERTIF.', dataField: 'certificado', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'SALDO CERTIF.', dataField: 'saldoCertificado', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'COMPRO. ANUAL', dataField: 'compromisoAnual', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'SALDO COMPRO. ANUAL', dataField: 'saldoCompromisoAnual', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'EJECUTADO', dataField: 'compromisoMensual', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'SALDO EJECT.', dataField: 'saldoCompromisoMensual', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'GENERICA GASTO', dataField: 'genericaGasto', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'SUB GENERICA', dataField: 'subGenerica', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'SUB GENERICA DETA.', dataField: 'subGenericaDetalle', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass}
            ]
        });
    });
</script>
<div id="div_GrillaPrincipal"></div>