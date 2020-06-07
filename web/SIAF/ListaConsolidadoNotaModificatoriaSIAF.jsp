<%-- 
    Document   : ListaConsolidadoNotaModificatoriaSIAF
    Created on : 06/07/2017, 12:51:46 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnConsolidado.periodo}';
    var codigo = '${objBnConsolidado.codigo}';
    var lista = new Array();
    <c:forEach var="d" items="${objConsolidado}">
    var result = {catPresupuestal: '${d.categoriaPresupuestal}', producto: '${d.producto}', actividad: '${d.actividad}', secFuncional: '${d.secuenciaFuncional}',
        fteFinanciamiento: '${d.fuenteFinanciamiento}', cadenaGasto: '${d.cadenaGasto}', finalidad: '${d.descripcion}', especifica: '${d.consecuencia}',
        pia: '${d.enero}', pim: '${d.febrero}', certificado: '${d.marzo}',
        saldoCertificado: '${d.abril}', habilitador: '${d.importeAnulacion}', habilitado: '${d.importeCredito}', nuevoPim: '${d.saldo}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA DE LA CABECERA  
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'catPresupuestal', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'actividad', type: "string"},
                        {name: 'secFuncional', type: "string"},
                        {name: 'fteFinanciamiento', type: "string"},
                        {name: 'cadenaGasto', type: "string"},
                        {name: 'finalidad', type: "string"},
                        {name: 'especifica', type: "string"},
                        {name: 'pia', type: "number"},
                        {name: 'pim', type: "number"},
                        {name: 'certificado', type: "number"},
                        {name: 'saldoCertificado', type: "number"},
                        {name: 'habilitador', type: "number"},
                        {name: 'habilitado', type: "number"},
                        {name: 'nuevoPim', type: "number"}
                    ],
            root: "ConsolidadoNotaModificatoria",
            record: "ConsolidadoNotaModificatoria"
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "nuevoPim" || datafield === "certificado") {
                return "RowBold";
            }
            if (datafield === "habilitador") {
                return "RowRed";
            }
            if (datafield === "habilitado") {
                return "RowBlue";
            }
            if (datafield === "pim") {
                return "RowGreen";
            }
            if (datafield === "pia") {
                return "RowBrown";
            }
            if (datafield === "saldoCertificado") {
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
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ConsolidadoNotaModificatoria' + codigo);
                });
                ButtonSubir.click(function (event) {
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
            },
            columns: [
                {text: 'N°', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '30', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'FTE. FINAC.', dataField: 'fteFinanciamiento', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'SEC. FUNCIONAL', dataField: 'secFuncional', width: '7%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'CAT. PPTAL', dataField: 'catPresupuestal', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'PRODUCTO', dataField: 'producto', width: '7%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ACTIVIDAD', dataField: 'actividad', width: '7%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'FINALIDAD', dataField: 'finalidad', width: '7%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ESPECIFICA', dataField: 'especifica', width: '7%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'CONCEPTO', dataField: 'cadenaGasto', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'PIA', dataField: 'pia', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PIM', dataField: 'pim', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CERTIF.', dataField: 'certificado', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO CERTIF.', dataField: 'saldoCertificado', width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'HABILITADOR', dataField: 'habilitador', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'HABILITADO', dataField: 'habilitado', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'NUEVO PIM', dataField: 'nuevoPim', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
    });
//CREA LOS ELEMENTOS DE LAS VENTANAS
    var customButtonsDemo = (function () {
        function _createElements() {
            //INICIA LOS VALORES DE LA VENTANA
            var posicionX, posicionY;
            var ancho = 600;
            var alto = 155;
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
        var marco = $("#txt_Marco").val();
        var certificado = $("#txt_Certificado").val();
        var priorizacion = $("#txt_Priorizacion").val();
        if (marco === '' || certificado === '' || priorizacion === '')
            msg = "Seleccione un Archivo para Subir";
        if (msg === "") {
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
                                        $('#div_VentanaPrincipal').jqxWindow('close');
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
                    <td class="inputlabel">Marco Presupuestal : </td>
                    <td><input type="file" name="txt_Marco" id="txt_Marco" style="text-transform: uppercase; width: 400px;height: 30px" class="name form-control"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Certificados : </td>
                    <td><input type="file" name="txt_Certificado" id="txt_Certificado" style="text-transform: uppercase; width: 400px;height: 30px" class="name form-control"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Priorización : </td>
                    <td><input type="file" name="txt_Priorizacion" id="txt_Priorizacion" style="text-transform: uppercase; width: 400px;height: 30px" class="name form-control"/></td>
                </tr>
                <tr>
                    <td class="Summit" colspan="4">
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