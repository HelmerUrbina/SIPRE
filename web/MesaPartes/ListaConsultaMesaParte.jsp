<%-- 
    Document   : ListaConsultaMesaParte
    Created on : 31/07/2017, 10:44:13 AM
    Author     : H-TECCSI-V
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var tipo = $("#cbo_Tipo").val();
    var mes = $("#cbo_Mes").val();
    var archivo = null;
    var codigo = null;
    var lista = new Array();
    <c:forEach var="d" items="${objMesaParte}">
    var result = {numero: '${d.numero}', numeroDocumento: '${d.numeroDocumento}', asunto: '${d.asunto}',
        subGrupo: '${d.subGrupo}', prioridad: '${d.prioridad}', fecha: '${d.fecha}', estado: '${d.estado}', firma: '${d.hora}',
        legajo: '${d.legajo}', folio: '${d.folio}', usuarioResponsable: '${d.usuarioResponsable}', referencia: '${d.referencia}',
        archivo: '${d.archivo}', fechaRegistro: '${d.fechaRegistro}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'numero', type: "string"},
                        {name: 'numeroDocumento', type: "string"},
                        {name: 'asunto', type: "string"},
                        {name: 'subGrupo', type: "string"},
                        {name: 'prioridad', type: "string"},
                        {name: 'fecha', type: "string"},
                        {name: 'fechaRegistro', type: "string"},
                        {name: 'estado', type: "string"},
                        {name: 'firma', type: "string"},
                        {name: 'legajo', type: "number"},
                        {name: 'folio', type: "string"},
                        {name: 'usuarioResponsable', type: "string"},
                        {name: 'referencia', type: "string"},
                        {name: 'archivo', type: "string"}
                    ],
            root: "MesaParte",
            record: "MesaParte",
            id: 'numero'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "numero") {
                return "RowBold";
            }
            if (datafield === "usuarioResponsable") {
                return "RowBlue";
            }
            if (datafield === "subGrupo") {
                return "RowPurple";
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
            rendertoolbar: function (toolbar) {
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonExportar);
                toolbar.append(container);
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ConsultaMesaParte');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: 10, pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'CÓDIGO', dataField: 'numero', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'NRO DOCUMENTO', dataField: 'numeroDocumento', width: '7%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ASUNTO', dataField: 'asunto', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'INSTITUCIÓN', dataField: 'subGrupo', filtertype: 'checkedlist', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'PRIORIDAD', dataField: 'prioridad', filtertype: 'checkedlist', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FEC. DOC', dataField: 'fecha', columntype: 'datetimeinput', filtertype: 'date', width: '6%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'OBSERVACION', dataField: 'firma', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'LEGAJO', dataField: 'legajo', width: '3%', align: 'center', cellsAlign: 'center', cellsFormat: 'f', cellclassname: cellclass},
                {text: 'FOLIO', dataField: 'folio', width: '3%', align: 'center', cellsAlign: 'center', cellsFormat: 'f', cellclassname: cellclass},
                {text: 'USUARIO RESP.', dataField: 'usuarioResponsable', filtertype: 'checkedlist', width: '9%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'REFERENCIA', dataField: 'referencia', width: '9%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FEC. REG.', dataField: 'fechaRegistro', columntype: 'datetimeinput', filtertype: 'date', width: '6%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'ARCHIVO', dataField: 'archivo', width: '9%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL 
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 30, autoOpenPopup: false, mode: 'popup'});
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
        //DEFINIMOS LOS EVENTOS SEGUN LA OPCION DEL MENU CONTEXTUAL      
        $("#div_ContextMenu").on('itemclick', function (event) {
            var opcion = event.args;
            if ($.trim($(opcion).text()) === "Ver Documento") {
                if (archivo !== null && archivo !== '') {
                    document.location.target = "_blank";
                    document.location.href = "../Descarga?opcion=MesaParte&periodo=" + periodo + "&codigo=" + tipo + "-" + codigo + "&documento=" + archivo;
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'No existe Archivo a Vizualizar!!!',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                }
            }
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['numero'];
            estado = row['estado'];
            archivo = row['archivo'];
        });
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id='div_ContextMenu' style='display:none;'>
    <ul>   
        <li style="font-weight: bold">Ver Documento</li>
    </ul>
</div>