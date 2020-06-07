<%-- 
    Document   : ListaPIMInforme
    Created on : 22/01/2018, 02:44:09 PM
    Author     : heurbinam
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var lista = new Array();
    <c:forEach var="d" items="${objPIMInforme}">
    var result = {tipoCalendario: '${d.tipoCalendario}', resolucion: '${d.resolucion}', actividad: '${d.actividad}', secuencia: '${d.secuencia}',
        tarea: '${d.tarea}', cadenaGasto: '${d.cadenaGasto}', genericaGasto: '${d.genericaGasto}', subGenerica: '${d.subGenerica}',
        subGenericaDetalle: '${d.subGenericaDetalle}', categoriaPresupuestal: '${d.categoriaPresupuestal}', producto: '${d.producto}',
        dependencia: '${d.dependencia}', tipoClasificador: '${d.tipoClasificador}', pia: '${d.PIA}', notaModificatoria: '${d.notaModificatoria}',
        pim: '${d.PIM}', informe: '${d.informe}', notaPendiente: '${d.notaPendiente}', certificado: '${d.certificado}', saldoCertificado: '${d.saldoCertificado}',
        saldo: '${d.saldo}', saldoSinCertificado: '${d.saldoSinCertificado}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA DE LA CABECERA  
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'tipoCalendario', type: "string"},
                        {name: 'resolucion', type: "string"},
                        {name: 'actividad', type: "string"},
                        {name: 'secuencia', type: "string"},
                        {name: 'tarea', type: "string"},
                        {name: 'cadenaGasto', type: "string"},
                        {name: 'genericaGasto', type: "string"},
                        {name: 'subGenerica', type: "string"},
                        {name: 'subGenericaDetalle', type: "string"},
                        {name: 'categoriaPresupuestal', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'tipoClasificador', type: "string"},
                        {name: 'pia', type: "number"},
                        {name: 'notaModificatoria', type: "number"},
                        {name: 'pim', type: "number"},
                        {name: 'informe', type: "number"},
                        {name: 'notaPendiente', type: "number"},
                        {name: 'certificado', type: "number"},
                        {name: 'saldoCertificado', type: "number"},
                        {name: 'saldo', type: "number"},
                        {name: 'saldoSinCertificado', type: "number"}
                    ],
            root: "PIMInforme",
            record: "PIMInforme"
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "pia" || datafield === "pim" || datafield === "saldo") {
                return "RowBold";
            }
            if (datafield === "notaModificatoria") {
                return "RowBlue";
            }
            if (datafield === "informe") {
                return "RowBrown";
            }
            if (datafield === "notaPendiente") {
                return "RowRed";
            }
            if (datafield === "certificado") {
                return "RowPurple";
            }
            if (datafield === "saldoCertificado") {
                return "RowGreen";
            }
            if (datafield === "saldoSinCertificado") {
                return "RowDarkBlue";
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
            groupable: true,
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            showtoolbar: true,
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
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'PIMVSInforme');
                });
            },
            columns: [
                {text: 'TIPO CLASIF.', dataField: 'tipoClasificador', filtertype: 'checkedlist', width: '8%', align: 'center', cellclassname: cellclass},
                {text: 'PROGRAMA', dataField: 'categoriaPresupuestal', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'PRODUCTO', dataField: 'producto', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'ACTIVIDAD', dataField: 'actividad', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'SEC. FUNCIONAL', dataField: 'secuencia', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'TAREA', dataField: 'tarea', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'CADENA GASTO', dataField: 'cadenaGasto', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'PIA', dataField: 'pia', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'NOTA MODIF.', dataField: 'notaModificatoria', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'PIM', dataField: 'pim', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'INFORME', dataField: 'informe', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'NOTA PEND.', dataField: 'notaPendiente', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'CERTIF.', dataField: 'certificado', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'SALDO CERTIF.', dataField: 'saldoCertificado', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'SALDO SIN CERTIF.', dataField: 'saldoSinCertificado', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'SALDO', dataField: 'saldo', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'GENERICA GASTO', dataField: 'genericaGasto', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'SUB GENERICA', dataField: 'subGenerica', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'SUB GENERICA DETA.', dataField: 'subGenericaDetalle', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'TIPO CALENDARIO', dataField: 'tipoCalendario', filtertype: 'checkedlist', width: '13%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'RESOLUCION', dataField: 'resolucion', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass}
            ]
        });
    });
</script>
<div id="div_GrillaPrincipal"></div>