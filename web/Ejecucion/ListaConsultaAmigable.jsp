<%-- 
    Document   : ListaConsultaAmigable
    Created on : 11/06/2018, 10:17:47 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var lista = new Array();
    <c:forEach var="d" items="${objConsultaAmigable}">
    var result = {periodo: '${d.periodo}', presupuesto: '${d.presupuesto}', unidadOperativa: '${d.unidadOperativa}', glosa: '${d.dependencia}',
        categoriaPresupuestal: '${d.categoriaPresupuestal}', producto: '${d.producto}', actividad: '${d.actividad}', secuencia: '${d.secuencia}',
        cadenaGasto: '${d.cadenaGasto}', genericaGasto: '${d.genericaGasto}', subGenerica: '${d.subGenerica}', subGenericaDetalle: '${d.subGenericaDetalle}',
        sipe: '${d.PIA}', compromiso: '${d.PIM}', devengado: '${d.certificado}', girado: '${d.notaModificatoria}', pagado: '${d.informe}'};
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
                        {name: 'presupuesto', type: "string"},
                        {name: 'unidadOperativa', type: "string"},
                        {name: 'glosa', type: "string"},
                        {name: 'categoriaPresupuestal', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'actividad', type: "string"},
                        {name: 'secuencia', type: "string"},
                        {name: 'cadenaGasto', type: "string"},
                        {name: 'genericaGasto', type: "string"},
                        {name: 'subGenerica', type: "string"},
                        {name: 'subGenericaDetalle', type: "string"},
                        {name: 'sipe', type: "number"},
                        {name: 'compromiso', type: "number"},
                        {name: 'devengado', type: "number"},
                        {name: 'girado', type: "number"},
                        {name: 'pagado', type: "number"}
                    ],
            root: "ConsultaAmigable",
            record: "ConsultaAmigable"
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "sipe") {
                return "RowBold";
            }
            if (datafield === "compromiso") {
                return "RowBlue";
            }
            if (datafield === "devengado") {
                return "RowPurple";
            }
            if (datafield === "girado") {
                return "RowGreen";
            }
            if (datafield === "pagado") {
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
            showstatusbar: true,
            showaggregates: true,
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var reporteButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonExportar);
                container.append(reporteButton);
                toolbar.append(container);
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                reporteButton.jqxButton({width: 30, height: 22});
                reporteButton.jqxTooltip({position: 'bottom', content: "Reporte"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ConsultaAmigable');
                });
                reporteButton.click(function (event) {
                    var url = '../Reportes?reporte=EJE0036&periodo=' + $("#cbo_Periodo").val() + '&unidadOperativa=' + $("#cbo_UnidadOperativa").val() + '&presupuesto=' + $("#cbo_Presupuesto").val();
                    window.open(url, '_blank');
                });
            },
            columns: [
                {text: 'PERIODO', dataField: 'periodo', filtertype: 'checkedlist', width: '3%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'PPTO', dataField: 'presupuesto', filtertype: 'checkedlist', width: '3%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'UU/OO', dataField: 'unidadOperativa', filtertype: 'checkedlist', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'SIAF', dataField: 'glosa', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'SEC. FUNCIONAL', dataField: 'secuencia', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'CADENA GASTO', dataField: 'cadenaGasto', filtertype: 'checkedlist', width: '18%', align: 'center', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return "";
                                    }}]},
                {text: 'CERTIFICADO', dataField: 'sipe', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'COMPROMISO', dataField: 'compromiso', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DEVENGADO', dataField: 'devengado', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'GIRADO', dataField: 'girado', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PAGADO', dataField: 'pagado', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PRODUCTO', dataField: 'producto', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'ACTIVIDAD', dataField: 'actividad', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'GENERICA GASTO', dataField: 'genericaGasto', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'SUB GENERICA', dataField: 'subGenerica', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'SUB GENERICA DETA.', dataField: 'subGenericaDetalle', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass}
            ]
        });
    });
</script>
<div id="div_GrillaPrincipal"></div>