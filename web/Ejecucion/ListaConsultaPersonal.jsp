<%-- 
    Document   : ListaConsultaPersonal
    Created on : 01/03/2018, 10:54:15 AM
    Author     : H-TECCSI-V
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var usuario = null;
    var mode = null;
    var periodo = '${objBnConsulta.periodo}';
    var nombres = '${objBnConsulta.referencia}';
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objConsultaJadpe}">
    var result = {periodo: '${d.periodo}', beneficio: '${d.codigoBeneficio}', codAdm: '${d.codigoAdministrativo}',
        beneficiario: '${d.referencia}', grado: '${d.asunto}', resol: '${d.resolucion}', oficio: '${d.oficio}',
        importe: '${d.importeBeneficiario}', cobertura: '${d.cobertura}', regSiaf: '${d.codigo}', fecComp: '${d.fecOficio}',
        fecDeveng: '${d.fecResolucion}', fecGird: '${d.mes}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'periodo', type: "string"},
                        {name: 'beneficio', type: "string"},
                        {name: 'codAdm', type: "string"},
                        {name: 'beneficiario', type: "string"},
                        {name: 'grado', type: "string"},
                        {name: 'resol', type: "string"},
                        {name: 'oficio', type: "string"},
                        {name: 'importe', type: "number"},
                        {name: 'cobertura', type: "string"},
                        {name: 'regSiaf', type: "string"},
                        {name: 'fecComp', type: "string"},
                        {name: 'fecDeveng', type: "string"},
                        {name: 'FecGird', type: "string"}
                    ],
            root: "ConsultaDerechoPersonal",
            record: "ConsultaDerechoPersonal"
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "cobertura" || datafield === "regSiaf") {
                return "RowBold";
            }
            if (datafield === "importe") {
                return "RowBlue";
            }
        };
        //DEFINIMOS LOS CAMPOS Y DATOS DE LA GRILLA
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 60),
            source: dataAdapter,
            pageable: true,
            columnsresize: true,
            autoheight: false,
            autorowheight: false,
            autoshowfiltericon: true,
            showfilterrow: true,
            filterable: true,
            altrows: true,
            editable: false,
            sortable: true,
            showstatusbar: false,
            showtoolbar: true,
            pagesize: 100,
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
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ConsultaDerechoPersonal');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '2%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'PERIODO', dataField: 'periodo', filtertype: 'checkedlist', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'BENEFICIO', dataField: 'beneficio', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'COD. ADM', dataField: 'codAdm', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'BENEFICIARIO', dataField: 'beneficiario', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'GRADO', dataField: 'grado', filtertype: 'checkedlist', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'RESOL', dataField: 'resol', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'OFICIO', dataField: 'oficio', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'importe', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'COBERTURA', dataField: 'cobertura', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'REG. SIAF', dataField: 'regSiaf', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FEC. COMP', dataField: 'fecComp', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FEC. DEVENG', dataField: 'fecDeveng', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FEC. GIRD', dataField: 'fecGird', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../ConsultaDerechoPersonal",
                data: {mode: 'G', periodo: periodo, nombres: nombres},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
    });
</script>
<div id="div_GrillaPrincipal"></div>


