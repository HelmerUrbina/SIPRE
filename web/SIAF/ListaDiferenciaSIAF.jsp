<%-- 
    Document   : ListaDiferenciaSIAF
    Created on : 14/11/2017, 01:58:38 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var opcion = $("#cbo_opcion").val();
    var lista = new Array();
    <c:forEach var="d" items="${objDiferencia}">
    var result = {unidadOperativa: '${d.unidadOperativa}', regSIAF: '${d.certificado}', sectorista: '${d.sectorista}', secFuncional: '${d.secuenciaFuncional}',
        categoria: '${d.categoriaPresupuestal}', producto: '${d.producto}', actividad: '${d.actividad}', generica: '${d.genericaGasto}',
        cadenaGasto: '${d.cadenaGasto}', sipe: '${d.SIPE}', siaf: '${d.SIAF}', diferencia: '${d.diferencia}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA DE LA CABECERA  
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'unidadOperativa', type: "string"},
                        {name: 'regSIAF', type: "string"},
                        {name: 'sectorista', type: "string"},
                        {name: 'secFuncional', type: "string"},
                        {name: 'categoria', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'actividad', type: "string"},
                        {name: 'generica', type: "string"},
                        {name: 'cadenaGasto', type: "string"},
                        {name: 'sipe', type: "number"},
                        {name: 'siaf', type: "number"},
                        {name: 'diferencia', type: "number"}
                    ],
            root: "DierenciaSIAF",
            record: "DierenciaSIAF"
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "regSIAF") {
                return "RowBold";
            }
            if (datafield === "diferencia") {
                return "RowRed";
            }
            if (datafield === "sipe") {
                return "RowBlue";
            }
            if (datafield === "siaf") {
                return "RowGreen";
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
            showstatusbar: true,
            showtoolbar: true,
            showaggregates: true,
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonSubir = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pecosa42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonExportar);
                container.append(ButtonSubir);
                toolbar.append(container);
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonSubir.jqxButton({width: 30, height: 22});
                ButtonSubir.jqxTooltip({position: 'bottom', content: "Subir Archivos"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'DiferenciasSIAF-' + opcion);
                });
                ButtonSubir.click(function (event) {
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
            },
            columns: [
                {text: 'N°', align: 'center', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'UNIDAD OPERATIVA', dataField: 'unidadOperativa', filtertype: 'checkedlist', width: '13%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'SECTORISTA', dataField: 'sectorista', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'CERTIFICADO', dataField: 'regSIAF', filtertype: 'checkedlist', width: '9%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'SEC. FUNCIONAL', dataField: 'secFuncional', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'CADENA GASTO', dataField: 'cadenaGasto', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'SIPE', dataField: 'sipe', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SIAF', dataField: 'siaf', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DIFERENCIA', dataField: 'diferencia', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'GENERICA', dataField: 'generica', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'PROGRAMA', dataField: 'categoria', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'PRODUCTO', dataField: 'producto', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'ACTIVIDAD', dataField: 'actividad', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass}
            ]
        });
    });
    //CREA LOS ELEMENTOS DE LAS VENTANAS
    var customButtonsDemo = (function () {
        function _createElements() {
            //INICIA LOS VALORES DE LA VENTANA
            var posicionX, posicionY;
            var ancho = 600;
            var alto = 110;
            posicionX = ($(window).width() / 2) - (ancho / 2);
            posicionY = ($(window).height() / 2) - (alto / 2);
            $('#div_VentanaPrincipal').jqxWindow({
                position: {x: posicionX, y: posicionY},
                width: ancho, height: alto, resizable: false,
                cancelButton: $('#btn_Cancelar'),
                initContent: function () {
                    $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                    $('#btn_Guardar').on('click', function () {
                        fn_subirArchivo();
                    });
                }
            });
        }
        return {init: function () {
                _createElements();
            }
        };
    }());
    $(document).ready(function () {
        customButtonsDemo.init();
    });
    function fn_subirArchivo() {
        var msg = "";
        var periodo = $("#cbo_Periodo").val();
        var certificado = $("#txt_Certificado").val();
        if (certificado === '')
            msg = "Seleccione un Archivo para Subir";
        if (msg === "") {
            var $contenidoAjax = $('#div_VentanaPrincipal').html('<img src="../Imagenes/Fondos/cargando.gif">');
            var formData = new FormData(document.getElementById("frm_SubirArchivosSIAF"));
            formData.append("mode", "S");
            formData.append("periodo", periodo);
            $.ajax({
                type: "POST",
                url: "../IduSubirArchivosSIAF",
                data: formData,
                dataType: "html",
                cache: false,
                contentType: false,
                processData: false,
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
                                        $contenidoAjax.jqxWindow('close');
                                        fn_CargarBusqueda();
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
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">SUBIR ARCHIVOS</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_SubirArchivosSIAF" name="frm_SubirArchivosSIAF" enctype="multipart/form-data" action="javascript:fn_subirArchivo();" method="post">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Certificados : </td>
                    <td><input type="file" name="txt_Certificado" id="txt_Certificado" style="text-transform: uppercase; width: 400px;height: 30px" class="name form-control"/></td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td class="Summit" colspan="2">
                        <div>
                            <input type="button" id="btn_Guardar"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_Cancelar" value="Cancelar" style="margin-right: 20px"/>
                        </div>
                    </td>
                </tr>
            </table>  
        </form>
    </div>
</div>