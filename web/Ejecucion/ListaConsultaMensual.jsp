<%-- 
    Document   : ListaConsultaMensual
    Created on : 17/09/2018, 11:23:03 AM
    Author     : heurbinam
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var lista = new Array();
    <c:forEach var="d" items="${objConsultaMensual}">
    var result = {periodo: '${d.periodo}', unidadOperativa: '${d.unidadOperativa}', producto: '${d.producto}', actividad: '${d.actividad}',
        secuencia: '${d.secuenciaFuncional}', tarea: '${d.tarea}', cadenaGasto: '${d.cadenaGasto}', genericaGasto: '${d.genericaGasto}',
        dependencia: '${d.dependencia}', pim: '${d.importe}', enero: '${d.enero}', febrero: '${d.febrero}', marzo: '${d.marzo}', abril: '${d.abril}',
        mayo: '${d.mayo}', junio: '${d.junio}', julio: '${d.julio}', agosto: '${d.agosto}', setiembre: '${d.setiembre}',
        octubre: '${d.octubre}', noviembre: '${d.noviembre}', diciembre: '${d.diciembre}', ejecucion: '${d.total}', saldoEjecucion: '${d.importe-d.total}'};
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
                        {name: 'unidadOperativa', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'actividad', type: "string"},
                        {name: 'secuencia', type: "string"},
                        {name: 'tarea', type: "string"},
                        {name: 'cadenaGasto', type: "string"},
                        {name: 'genericaGasto', type: "string"},
                        {name: 'dependencia', type: "string"},
                        {name: 'pim', type: "number"},
                        {name: 'enero', type: "number"},
                        {name: 'febrero', type: "number"},
                        {name: 'marzo', type: "number"},
                        {name: 'abril', type: "number"},
                        {name: 'mayo', type: "number"},
                        {name: 'junio', type: "number"},
                        {name: 'julio', type: "number"},
                        {name: 'agosto', type: "number"},
                        {name: 'setiembre', type: "number"},
                        {name: 'octubre', type: "number"},
                        {name: 'noviembre', type: "number"},
                        {name: 'diciembre', type: "number"},
                        {name: 'ejecucion', type: "number"},
                        {name: 'saldoEjecucion', type: "number"}
                    ],
            root: "ConsultaMensual",
            record: "ConsultaMensual"
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "pim") {
                return "RowBold";
            }
            if (datafield === "ejecucion") {
                return "RowBlue";
            }
            if (datafield === "saldoEjecucion") {
                return "RowGreen";
            }
        };
        //DEFINIMOS LOS CAMPOS Y DATOS DE LA GRILLA
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 62),
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
            showstatusbar: true,
            showtoolbar: true,
            showaggregates: true,
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonExportar);
                toolbar.append(container);
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ConsultaMensual');
                });
            },
            columns: [
                {text: 'PERIODO', dataField: 'periodo', filtertype: 'checkedlist', width: '3%', align: 'center', cellclassname: cellclass},
                {text: 'UU/OO', dataField: 'unidadOperativa', filtertype: 'checkedlist', width: '8%', align: 'center', cellclassname: cellclass},
                {text: 'DEPENDENCIA', dataField: 'dependencia', filtertype: 'checkedlist', width: '10%', align: 'center', cellclassname: cellclass},
                {text: 'PRODUCTO', dataField: 'producto', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'ACTIVIDAD', dataField: 'actividad', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'GENERICA', dataField: 'genericaGasto', filtertype: 'checkedlist', width: '10%', align: 'center', cellclassname: cellclass},                
                {text: 'SEC. FUNCIONAL', dataField: 'secuencia', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'TAREA', dataField: 'tarea', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'CADENA GASTO', dataField: 'cadenaGasto', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass},                
                {text: 'PIM', dataField: 'pim', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ENERO', dataField: 'enero', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'FEBRERO', dataField: 'febrero', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MARZO', dataField: 'marzo', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ABRIL', dataField: 'abril', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MAYO', dataField: 'mayo', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'JUNIO', dataField: 'junio', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'JULIO', dataField: 'julio', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'AGOSTO', dataField: 'agosto', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SETIEMBRE', dataField: 'setiembre', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'OCTUBRE', dataField: 'octubre', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'NOVIEMBRE', dataField: 'noviembre', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DICIEMBRE', dataField: 'diciembre', width: '6%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'TOTAL EJEC.', dataField: 'ejecucion', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO EJEC.', dataField: 'saldoEjecucion', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
    });
</script>
<div id="div_GrillaPrincipal"></div>