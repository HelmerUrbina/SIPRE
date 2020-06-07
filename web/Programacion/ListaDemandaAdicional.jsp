<%-- 
    Document   : ListaDemandaAdicional
    Created on : 11/04/2017, 04:22:28 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = '${objBnDemandaAdicional.periodo}';
    var presupuesto = '${objBnDemandaAdicional.presupuesto}';
    var unidadOperativa = '${objBnDemandaAdicional.unidadOperativa}';
    var codigo = '${objBnDemandaAdicional.codigo}';
    var estado = '';
    var archivo = '';
    var mode = null;
    var indiceDetalle = -1;
    var modeDetalle = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objDemandaAdicional}">
    var result = {codigo: '${d.codigo}', descripcion: '${d.descripcion}', solicitado: '${d.importe}', aprobado: '${d.cantidad}',
        estado: '${d.estado}', archivo: '${d.tarea}', fecha: '${d.cadenaGasto}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA NUEVO DETALLE
        var sourceNuevo = {
            datatype: "array",
            datafields:
                    [
                        {name: "dependencia", type: "string"},
                        {name: "tarea", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "importe", type: "number"}
                    ],
            pagesize: 10,
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            },
            updaterow: function (rowid, rowdata, commit) {
                commit(true);
            }
        };
        var dataNuevo = new $.jqx.dataAdapter(sourceNuevo);
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA DE META FISICA
        var sourceMeta = {
            datatype: "array",
            datafields:
                    [
                        {name: "tarea", type: "string"},
                        {name: "unidadMedida", type: "string"},
                        {name: "cantidad", type: "int"}
                    ],
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            },
            updaterow: function (rowid, rowdata, commit) {
                commit(true);
            }
        };
        var dataMeta = new $.jqx.dataAdapter(sourceMeta);
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA PARA APROBACION
        var sourceAprobar = {
            datatype: "array",
            datafields:
                    [
                        {name: "dependencia", type: "string"},
                        {name: "tarea", type: "string"},
                        {name: "unidadMedida", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "importePedido", type: "number"},
                        {name: "cantidadPedida", type: "number"},
                        {name: "importe", type: "number"},
                        {name: "cantidad", type: "number"}
                    ],
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            },
            updaterow: function (rowid, rowdata, commit) {
                commit(true);
            }
        };
        var dataAprobar = new $.jqx.dataAdapter(sourceAprobar);
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA PRINCIPAL
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigo', type: "number"},
                        {name: 'descripcion', type: "string"},
                        {name: 'solicitado', type: "number"},
                        {name: 'aprobado', type: "number"},
                        {name: 'estado', type: "string"},
                        {name: 'archivo', type: "string"},
                        {name: 'fecha', type: "date", format: 'dd/MMM/yyyy'}
                    ],
            root: "DemandaAdicional",
            record: "DemandaAdicional",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (rowdata['estado'] === "ANULADO") {
                return "RowAnulado";
            }
            if (datafield === "importe" || datafield === 'cantidad' || datafield === 'solicitado') {
                return "RowBold";
            }
            if (datafield === "importePedido" || datafield === 'cantidadPedida' || datafield === 'aprobado') {
                return "RowBlue";
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
            showstatusbar: true,
            showaggregates: true,
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonReporte = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonExportar);
                container.append(ButtonReporte);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonReporte.jqxButton({width: 30, height: 22});
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reporte"});
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    codigo = 0;
                    $("#txt_Descripcion").val("");
                    $('#div_GrillaRegistro').jqxGrid('clear');
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                    fn_cargarComboAjax("#cbo_Dependencia", {mode: 'dependencia', unidadOperativa: unidadOperativa});
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'DemandaAdicional');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON REPORTE
                ButtonReporte.click(function (event) {
                    if (codigo !== '0') {
                        var url = '../Reportes?reporte=PROG0011&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&codigo=' + codigo;
                        window.open(url, '_blank');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Seleccione un Registro',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: 10, pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'DESCRIPCIÓN', dataField: 'descripcion', width: '47%', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'FECHA', dataField: 'fecha', width: '8%', columntype: 'datetimeinput', filtertype: 'date', cellsFormat: 'd', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'IMP. SOLICI.', dataField: 'solicitado', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMP. APROBADO', dataField: 'aprobado', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ESTADO', dataField: 'estado', width: '8%', filtertype: 'checkedlist', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ARCHIVO', dataField: 'archivo', width: '15%', align: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL 
        var alto = 185;
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: alto, autoOpenPopup: false, mode: 'popup'});
        $("#div_GrillaPrincipal").on('contextmenu', function () {
            return false;
        });
        // HABILITAMOS LA OPCION DE CLICK DEL MENU CONTEXTUAL.
        $("#div_GrillaPrincipal").on('rowclick', function (event) {
            if (event.args.rightclick) {
                $("#div_GrillaPrincipal").jqxGrid('selectrow', event.args.rowindex);
                var scrollTop = $(window).scrollTop();
                var scrollLeft = $(window).scrollLeft();
                if (parseInt(event.args.originalEvent.clientY) > 600) {
                    scrollTop = scrollTop - alto;
                }
                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
                return false;
            }
        });
        //DEFINIMOS LOS EVENTOS SEGUN LA OPCION DEL MENU CONTEXTUAL
        $("#div_ContextMenu").on('itemclick', function (event) {
            var opcion = event.args;
            if (estado === 'ANULADO') {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'SELECCIONE UN REGISTRO QUE NO ESTE ANULADO',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            } else {
                if ($.trim($(opcion).text()) === "Editar") {
                    mode = 'U';
                    fn_EditarRegistro();
                } else if ($.trim($(opcion).text()) === "Meta Fisica") {
                    mode = 'M';
                    fn_verMetaFisica();
                } else if ($.trim($(opcion).text()) === "Anular") {
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: '¿Desea Anular este registro?',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true,
                        buttons: {
                            aceptar: {
                                text: 'Aceptar',
                                btnClass: 'btn-primary',
                                keys: ['enter', 'shift'],
                                action: function () {
                                    mode = 'D';
                                    fn_GrabarDatos();
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                } else if ($.trim($(opcion).text()) === "Cerrar") {
                    $.confirm({
                        title: 'CERRAR DEMANDA ADICIONAL',
                        type: 'blue',
                        content: '' +
                                '<form method="post"  name="frm_DemandaAdicionalCerrar" id="frm_DemandaAdicionalCerrar" action="../IduDemandaAdicional" enctype="multipart/form-data">' +
                                '<label>Documento de Referencia : </label>' +
                                '<input type="file" name="fichero" id="fichero" style="text-transform: uppercase; width=800px" class="name form-control"/>' +
                                '</form>',
                        buttons: {
                            formSubmit: {
                                text: 'Enviar',
                                btnClass: 'btn-blue',
                                action: function () {
                                    fn_GuardarCerrar();
                                }
                            },
                            cancel: function () {
                            },
                        },
                        onContentReady: function () {
                            // bind to events
                            var jc = this;
                            this.$content.find('form').on('submit', function (e) {
                                // if the user submits the form by pressing enter in the field.
                                e.preventDefault();
                                jc.$$formSubmit.trigger('click'); // reference the button and click it
                            });
                        }
                    });
                } else if ($.trim($(opcion).text()) === "Aprobar") {
                    if (autorizacion === 'true') {
                        mode = 'A';
                        fn_verDatosAprobacion();
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Usuario no Autorizado para realizar este Tipo de Operación',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                } else if ($.trim($(opcion).text()) === "Activar") {
                    if (autorizacion === 'true') {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Activar esta Demanda Adicional?',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true,
                            buttons: {
                                aceptar: {
                                    text: 'Aceptar',
                                    btnClass: 'btn-primary',
                                    keys: ['enter', 'shift'],
                                    action: function () {
                                        mode = 'Z';
                                        fn_GrabarDatos();
                                    }
                                },
                                cancelar: function () {
                                }
                            }
                        });
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Usuario no Autorizado para realizar este Tipo de Operación',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                } else if ($.trim($(opcion).text()) === "Ver Documento") {
                    if (archivo !== '') {
                        document.location.target = "_blank";
                        document.location.href = "../Descarga?opcion=DemandaAdicional&periodo=" + periodo + "&presupuesto=" + presupuesto + "&unidadOperativa=" + unidadOperativa + "&codigo=" + codigo + "&documento=" + archivo;
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
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'No hay Opcion a Mostar',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'orange',
                        typeAnimated: true
                    });
                }
            }
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
            estado = row['estado'];
            archivo = row['archivo'];
        });
        //INCIAMOS LOS VALORES DE GRILLA DETALLE
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: 350,
            source: dataNuevo,
            pageable: true,
            columnsresize: true,
            showtoolbar: true,
            showstatusbar: true,
            showaggregates: true,
            altrows: false,
            editable: false,
            statusbarheight: 20,
            autoheight: false,
            autorowheight: false,
            sortable: true,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var containerRegistro = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevoRegistro = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var ButtonEditarRegistro = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/update42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var ButtonEliminaRegistro = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/delete42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                containerRegistro.append(ButtonNuevoRegistro);
                containerRegistro.append(ButtonEditarRegistro);
                containerRegistro.append(ButtonEliminaRegistro);
                toolbar.append(containerRegistro);
                ButtonNuevoRegistro.jqxButton({width: 30, height: 22});
                ButtonNuevoRegistro.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonEditarRegistro.jqxButton({width: 30, height: 22});
                ButtonEditarRegistro.jqxTooltip({position: 'bottom', content: "Editar Registro"});
                ButtonEliminaRegistro.jqxButton({width: 30, height: 22});
                ButtonEliminaRegistro.jqxTooltip({position: 'bottom', content: "Eliminar Registro"});
                // ADICIONAMOS UNA NUEVO REGISTRO
                ButtonNuevoRegistro.click(function (event) {
                    modeDetalle = 'I';
                    $('#div_ImporteDetalle').val(0);
                    $('#div_RegistroDetalle').jqxWindow({isModal: true, modalOpacity: 0.7});
                    $('#div_RegistroDetalle').jqxWindow('open');
                });
                // EDITAMOS UNA NUEVO REGISTRO
                ButtonEditarRegistro.click(function (event) {
                    modeDetalle = 'U';
                    if (indiceDetalle >= 0) {
                        var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                        $("#cbo_CadenaGasto").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.cadenaGasto, ':'));
                        $('#div_RegistroDetalle').jqxWindow({isModal: true, modalOpacity: 0.7});
                        $('#div_RegistroDetalle').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'DEBE SELECCIONAR UN REGISTRO',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }
                });
                // ELIMINAMOS EL REGISTRO.
                ButtonEliminaRegistro.click(function (event) {
                    modeDetalle = 'D';
                    if (indiceDetalle >= 0) {
                        var rowid = $("#div_GrillaRegistro").jqxGrid('getrowid', indiceDetalle);
                        $("#div_GrillaRegistro").jqxGrid('deleterow', rowid);
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'DEBE SELECCIONAR UN REGISTRO',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }
                });
            },
            columns: [
                {text: 'DEPENDENCIA', datafield: 'dependencia', width: '15%', align: 'center'},
                {text: 'TAREA', datafield: 'tarea', width: '30%', align: 'center'},
                {text: 'CADENA GASTO', datafield: 'cadenaGasto', width: '35%', align: 'center', aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'IMPORTE', dataField: 'importe', width: '20%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
            var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
            $("#cbo_Tarea").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.tarea, '-'));
            $("#cbo_Dependencia").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.dependencia, ':'));
            $('#div_ImporteDetalle').val(dataRecord.importe);
            $("#cbo_CadenaGasto").jqxDropDownList('selectItem', fn_extraerDatos(dataRecord.cadenaGasto, ':'));
        });
        //INCIAMOS LOS VALORES DE GRILLA META FISICA
        $("#div_GrillaMetaFisica").jqxGrid({
            width: '100%',
            height: 350,
            source: dataMeta,
            pageable: true,
            columnsresize: true,
            enabletooltips: true,
            altrows: false,
            editable: true,
            autoheight: false,
            autorowheight: false,
            sortable: true,
            filterable: true,
            columns: [
                {text: 'TAREA', datafield: 'tarea', editable: false, width: '60%', align: 'center'},
                {text: 'UNI. MED.', datafield: 'unidadMedida', editable: false, width: '20%', align: 'center', cellsAlign: 'center'},
                {text: 'CANTIDAD', dataField: 'cantidad', width: '20%', align: 'center', cellsAlign: 'right', cellclassname: cellclass, columntype: 'numberinput',
                    validation: function (cell, value) {
                        if (value < 0 || value > 999999) {
                            return {result: false, message: "La cantidad debe estar en el intervalo de 0 a 999,999"};
                        }
                        return true;
                    },
                    createeditor: function (row, cellvalue, editor) {
                        editor.jqxNumberInput({decimalDigits: 0, digits: 6});
                    }
                }
            ]
        });
        //INCIAMOS LOS VALORES DE GRILLA DE APROBACION
        $("#div_GrillaAprobacion").jqxGrid({
            width: '100%',
            height: 350,
            source: dataAprobar,
            pageable: true,
            columnsresize: true,
            enabletooltips: true,
            altrows: false,
            editable: true,
            autoheight: false,
            autorowheight: false,
            showstatusbar: true,
            showaggregates: true,
            statusbarheight: 20,
            sortable: true,
            filterable: true,
            columns: [
                {text: 'DEPENDENCIA', datafield: 'dependencia', editable: false, width: '10%', align: 'center'},
                {text: 'TAREA', datafield: 'tarea', editable: false, width: '15%', align: 'center'},
                {text: 'CADENA GASTO', datafield: 'cadenaGasto', editable: false, width: '20%', align: 'center', aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'UNI. MED.', datafield: 'unidadMedida', editable: false, width: '9%', align: 'center', cellsAlign: 'center'},
                {text: 'IMP. REQ.', dataField: 'importePedido', editable: false, width: '15%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CANT. REQ.', dataField: 'cantidadPedida', editable: false, width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'IMP. APROB.', dataField: 'importe', width: '15%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum'], columntype: 'numberinput',
                    validation: function (cell, value) {
                        if (value < 0 || value > 999999999999) {
                            return {result: false, message: "El importe debe estar en el intervalo de 0 a 999,999,999,999.00"};
                        }
                        return true;
                    },
                    createeditor: function (row, cellvalue, editor) {
                        editor.jqxNumberInput({decimalDigits: 0, digits: 12});
                    }},
                {text: 'CANT. APROB.', dataField: 'cantidad', editable: true, width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass, columntype: 'numberinput',
                    validation: function (cell, value) {
                        if (value < 0 || value > 999999) {
                            return {result: false, message: "La cantidad debe estar en el intervalo de 0 a 999,999"};
                        }
                        return true;
                    },
                    createeditor: function (row, cellvalue, editor) {
                        editor.jqxNumberInput({decimalDigits: 0, digits: 6});
                    }
                }
            ]
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA PRINCIPAL
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 500;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $('#txt_Descripcion').jqxInput({placeHolder: 'INGRESE DESCRIPCION', height: 80, width: 480, minLength: 1});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function (event) {
                            $('#frm_DemandaAdicional').jqxValidator('validate');
                        });
                        $('#frm_DemandaAdicional').jqxValidator({
                            rules: [
                                {input: '#txt_Descripcion', message: 'Ingrese la Descripción de la Demanda Adicional!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_DemandaAdicional').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatos();
                            }
                        });
                    }
                });
                //INICIA VALORES PARA LA VENTANA REGISTRO DETALLE
                ancho = 550;
                alto = 175;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_RegistroDetalle').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarRegistro'),
                    initContent: function () {
                        $("#cbo_Dependencia").jqxDropDownList({width: 400, height: 20, promptText: "Seleccione"});
                        $("#cbo_Tarea").jqxDropDownList({width: 400, height: 20, promptText: "Seleccione"});
                        $('#cbo_Tarea').on('select', function (event) {
                            var tarea = $("#cbo_Tarea").val();
                            fn_cargarComboAjax("#cbo_CadenaGasto", {mode: 'cadenaGastoTarea', periodo: periodo, tarea: tarea});
                        });
                        $("#cbo_CadenaGasto").jqxDropDownList({width: 400, height: 20, promptText: "Seleccione"});
                        $("#div_ImporteDetalle").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 0});
                        $('#btn_CancelarRegistro').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRegistro').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRegistro').on('click', function () {
                            var dependencia = $("#cbo_Dependencia").jqxDropDownList('getSelectedItem');
                            var tarea = $("#cbo_Tarea").jqxDropDownList('getSelectedItem');
                            var cadenaGasto = $("#cbo_CadenaGasto").jqxDropDownList('getSelectedItem');
                            var importe = parseFloat($("#div_ImporteDetalle").val());
                            var msg = "";
                            if (msg === "")
                                msg = fn_validaDetalle(dependencia.label, tarea.label, cadenaGasto.label);
                            if (msg === "") {
                                var row = {dependencia: dependencia.label, tarea: tarea.label, cadenaGasto: cadenaGasto.label, importe: importe};
                                if (modeDetalle === 'I') {
                                    $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
                                }
                                if (modeDetalle === 'U') {
                                    var rowID = $('#div_GrillaRegistro').jqxGrid('getrowid', indiceDetalle);
                                    $('#div_GrillaRegistro').jqxGrid('updaterow', rowID, row);
                                }
                                $("#div_RegistroDetalle").jqxWindow('hide');
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
                        });
                    }
                });
                //INICIA LOS VALORES DE LA VENTANA DE META FISICA
                ancho = 650;
                alto = 500;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaMetaFisica').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarMetaFisica'),
                    initContent: function () {
                        $('#txt_DescripcionMetaFisica').jqxInput({height: 80, width: 480, disabled: true});
                        $('#btn_CancelarMetaFisica').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarMetaFisica').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarMetaFisica').on('click', function (event) {
                            fn_GrabarDatosMetaFisica();
                        });
                    }
                });
                //INICIA LOS VALORES DE LA VENTANA DE META FISICA
                ancho = 800;
                alto = 500;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaAprobar').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarAprobacion'),
                    initContent: function () {
                        $('#txt_DescripcionAprobacion').jqxInput({height: 80, width: 600, disabled: true});
                        $('#btn_CancelarAprobacion').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarAprobacion').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarAprobacion').on('click', function (event) {
                            fn_GrabarDatosAprobacion();
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
            fn_cargarComboAjax("#cbo_Tarea", {mode: 'tarea'});
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_RegistroDetalle").remove();
            $("#div_VentanaMetaFisica").remove();
            $("#div_VentanaAprobar").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../DemandaAdicional",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../DemandaAdicional",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (result) {
                    var dato = result.split("+++");
                    if (dato.length === 1) {
                        $("#txt_Descripcion").val(dato[0]);
                        $('#div_GrillaRegistro').jqxGrid('clear');
                        $.ajax({
                            type: "GET",
                            url: "../DemandaAdicional",
                            data: {mode: 'B', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                            success: function (data) {
                                data = data.replace("[", "");
                                var fila = data.split("[");
                                var rows = new Array();
                                for (i = 1; i < fila.length; i++) {
                                    var columna = fila[i];
                                    var datos = columna.split("+++");
                                    while (datos[7].indexOf(']') > 0) {
                                        datos[7] = datos[7].replace("]", "");
                                    }
                                    while (datos[7].indexOf(',') > 0) {
                                        datos[7] = datos[7].replace(",", "");
                                    }
                                    var row = {dependencia: datos[0], tarea: datos[1], cadenaGasto: datos[3], importe: parseFloat(datos[4])};
                                    rows.push(row);
                                }
                                if (rows.length > 0)
                                    $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
                            }
                        });
                    }
                }
            });
            fn_cargarComboAjax("#cbo_Dependencia", {mode: 'dependencia', unidadOperativa: unidadOperativa});
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_verDatosAprobacion() {
            $.ajax({
                type: "GET",
                url: "../DemandaAdicional",
                data: {mode: 'U', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (result) {
                    var dato = result.split("+++");
                    if (dato.length === 1) {
                        $("#txt_DescripcionAprobacion").val(dato[0]);
                        $('#div_GrillaAprobacion').jqxGrid('clear');
                        $.ajax({
                            type: "GET",
                            url: "../DemandaAdicional",
                            data: {mode: 'B', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                            success: function (data) {
                                data = data.replace("[", "");
                                var fila = data.split("[");
                                var rows = new Array();
                                for (i = 1; i < fila.length; i++) {
                                    var columna = fila[i];
                                    var datos = columna.split("+++");
                                    while (datos[7].indexOf(']') > 0) {
                                        datos[7] = datos[7].replace("]", "");
                                    }
                                    while (datos[7].indexOf(',') > 0) {
                                        datos[7] = datos[7].replace(",", "");
                                    }
                                    var row = {dependencia: datos[0], tarea: datos[1], unidadMedida: datos[2], cadenaGasto: datos[3], importePedido: parseFloat(datos[4]), cantidadPedida: parseInt(datos[5]), importe: parseFloat(datos[6]), cantidad: parseInt(datos[7])};
                                    rows.push(row);
                                }
                                if (rows.length > 0)
                                    $("#div_GrillaAprobacion").jqxGrid('addrow', null, rows);
                            }
                        });
                    }
                }
            });
            $('#div_VentanaAprobar').jqxWindow({isModal: true});
            $('#div_VentanaAprobar').jqxWindow('open');
        }
        //FUNCION PARA CARGAR VENTANA DE METAS FISICAS
        function fn_verMetaFisica() {
            $.ajax({
                type: "GET",
                url: "../DemandaAdicional",
                data: {mode: 'U', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (result) {
                    var dato = result.split("+++");
                    if (dato.length === 1) {
                        $("#txt_DescripcionMetaFisica").val(dato[0]);
                        $('#div_GrillaMetaFisica').jqxGrid('clear');
                        $.ajax({
                            type: "GET",
                            url: "../DemandaAdicional",
                            data: {mode: 'M', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
                            success: function (data) {
                                data = data.replace("[", "");
                                var fila = data.split("[");
                                var rows = new Array();
                                for (i = 1; i < fila.length; i++) {
                                    var columna = fila[i];
                                    var datos = columna.split("+++");
                                    while (datos[2].indexOf(']') > 0) {
                                        datos[2] = datos[2].replace("]", "");
                                    }
                                    while (datos[2].indexOf(',') > 0) {
                                        datos[2] = datos[2].replace(",", "");
                                    }
                                    var row = {tarea: datos[0], unidadMedida: datos[1], cantidad: parseInt(datos[2])};
                                    rows.push(row);
                                }
                                if (rows.length > 0)
                                    $("#div_GrillaMetaFisica").jqxGrid('addrow', null, rows);
                            }
                        });
                    }
                }
            });
            $('#div_VentanaMetaFisica').jqxWindow({isModal: true});
            $('#div_VentanaMetaFisica').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var descripcion = $("#txt_Descripcion").val();
            var msg = "";
            var lista = new Array();
            var result;
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                result = fn_extraerDatos(row.dependencia, ':') + "---" + fn_extraerDatos(row.tarea, '-') + "---" + fn_extraerDatos(row.cadenaGasto, ':') + "---" + row.importe;
                lista.push(result);
            }
            if (lista.length !== 0 || (mode === 'D' || mode === 'Z')) {
                $.ajax({
                    type: "POST",
                    url: "../IduDemandaAdicional",
                    data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo,
                        descripcion: descripcion, lista: JSON.stringify(lista)},
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
            } else {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'DEBE INGRESAR EL DETALLE DE LA DEMANDA ADICIONAL',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
            }

        }
        //FUNCION PARA GRABAR LOS DATOS DE LA META FISICA DE LA VENTANA META FISICA
        function fn_GrabarDatosMetaFisica() {
            var msg = "";
            var lista = new Array();
            var result;
            var rows = $('#div_GrillaMetaFisica').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                result = fn_extraerDatos(row.tarea, '-') + "---" + row.cantidad;
                lista.push(result);
            }
            $.ajax({
                type: "POST",
                url: "../IduDemandaAdicional",
                data: {mode: 'M', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo,
                    lista: JSON.stringify(lista)},
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
                                        $('#div_VentanaMetaFisica').jqxWindow('close');
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
        //FUNCION PARA GRABAR LOS DATOS DE LA APROBACION DE DEMANDA ADICIONAL
        function fn_GrabarDatosAprobacion() {
            var msg = "";
            var lista = new Array();
            var result;
            var rows = $('#div_GrillaAprobacion').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                result = fn_extraerDatos(row.dependencia, ':') + "---" + fn_extraerDatos(row.tarea, '-') + "---" + fn_extraerDatos(row.cadenaGasto, ':') + "---" + row.importe + "---" + row.cantidad;
                lista.push(result);
            }
            $.ajax({
                type: "POST",
                url: "../IduDemandaAdicional",
                data: {mode: 'A', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo,
                    lista: JSON.stringify(lista)},
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
                                        $('#div_VentanaAprobar').jqxWindow('close');
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
        function fn_GuardarCerrar() {
            var fichero = $("#fichero").val();
            if (fichero !== '') {
                var formData = new FormData(document.getElementById("frm_DemandaAdicionalCerrar"));
                formData.append("mode", "C");
                formData.append("periodo", periodo);
                formData.append("presupuesto", presupuesto);
                formData.append("unidadOperativa", unidadOperativa);
                formData.append("codigo", codigo);
                $.ajax({
                    type: "POST",
                    url: "../IduDemandaAdicional",
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
            } else {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: "Debe Seleccionar un Archivo a subir\n Proceso cancelado!!!.",
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            }
        }
        //FUNCION PARA VALIDAR QUE NO SE REPITAN LOS REGISTROS DEL DETALLE
        function fn_validaDetalle(dependencia, tarea, cadenaGasto) {
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            if (modeDetalle === 'I') {
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.dependencia.trim() === dependencia && row.tarea.trim() === tarea && row.cadenaGasto.trim() === cadenaGasto) {
                        return "Los Datos que desea registrar ya existen, Revise!!";
                    }
                }
            }
            if (modeDetalle === 'U') {
                if (rows[indiceDetalle].dependencia.trim() === dependencia && rows[indiceDetalle].tarea.trim() === tarea && rows[indiceDetalle].cadenaGasto.trim() === cadenaGasto) {
                    return "";
                } else {
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        if (i !== indiceDetalle && row.dependencia.trim() === dependencia && row.tarea.trim() === tarea && row.cadenaGasto.trim() === cadenaGasto) {
                            return "Los Datos que desea registrar ya existen, Revise!!";
                        }
                    }
                }
            }
            return "";
        }
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">DEMANDA ADICIONAL</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_DemandaAdicional" name="frm_DemandaAdicional" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Descripción : </td>
                    <td colspan="3"><textarea id="txt_Descripcion" name="txt_Descripcion" style="text-transform: uppercase;"/></textarea></td>                    
                </tr>                 
                <tr>                      
                    <td colspan="4"><div id="div_GrillaRegistro"> </div></td>                    
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
<div id="div_RegistroDetalle" style="display: none">
    <div>
        <span style="float: left">DEMANDA ADICIONAL - DETALLE</span>
    </div>
    <div style="overflow: hidden">                    
        <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
            <tr>
                <td class="inputlabel">Dependencia : </td>
                <td >
                    <select id="cbo_Dependencia" name="cbo_Dependencia">
                        <option value="0">Seleccione</option>                                
                    </select>
                </td>                   
            </tr>
            <tr>
                <td class="inputlabel">Tarea : </td>
                <td >
                    <select id="cbo_Tarea" name="cbo_Tarea">
                        <option value="0">Seleccione</option>                                
                    </select>
                </td>                   
            </tr>
            <tr>
                <td class="inputlabel">Cad. Gasto : </td>
                <td>
                    <select id="cbo_CadenaGasto" name="cbo_CadenaGasto">
                        <option value="0">Seleccione</option>                                
                    </select>
                </td>                   
            </tr>
            <tr>
                <td class="inputlabel">Importe S/. : </td>
                <td><div id="div_ImporteDetalle"></div></td>   

            </tr>                     
            <tr>
                <td class="Summit" colspan="4">
                    <div>
                        <input type="button" id="btn_GuardarRegistro" value="Guardar" style="margin-right: 20px" />                                    
                        <input type="button" id="btn_CancelarRegistro"  value="Cancelar" style="margin-right: 20px"/>
                    </div>
                </td>
            </tr>
        </table>
    </div>                
</div>
<div id="div_VentanaMetaFisica" style="display: none">
    <div>
        <span style="float: left">DEMANDA ADICIONAL - META FISICA</span>
    </div>
    <div style="overflow: hidden">                
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="inputlabel">Descripción : </td>
                <td colspan="3"><textarea id="txt_DescripcionMetaFisica" name="txt_DescripcionMetaFisica" style="text-transform: uppercase;"/></textarea></td>                    
            </tr>                 
            <tr>                      
                <td colspan="4"><div id="div_GrillaMetaFisica"> </div></td>                    
            </tr>                 
            <tr>
                <td class="Summit" colspan="4">
                    <div>
                        <input type="button" id="btn_GuardarMetaFisica"  value="Guardar" style="margin-right: 20px"/>
                        <input type="button" id="btn_CancelarMetaFisica" value="Cancelar" style="margin-right: 20px"/>                            
                    </div>
                </td>
            </tr>
        </table> 
    </div>
</div>
<div id="div_VentanaAprobar" style="display: none">
    <div>
        <span style="float: left">DEMANDA ADICIONAL - APROBACIÓN</span>
    </div>
    <div style="overflow: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="inputlabel">Descripción : </td>
                <td colspan="3"><textarea id="txt_DescripcionAprobacion" name="txt_DescripcionAprobacion" style="text-transform: uppercase;"/></textarea></td>
            </tr>
            <tr>
                <td colspan="4"><div id="div_GrillaAprobacion"> </div></td>
            </tr>
            <tr>
                <td class="Summit" colspan="4">
                    <div>
                        <input type="button" id="btn_GuardarAprobacion"  value="Guardar" style="margin-right: 20px"/>
                        <input type="button" id="btn_CancelarAprobacion" value="Cancelar" style="margin-right: 20px"/>
                    </div>
                </td>
            </tr>
        </table> 
    </div>
</div>
<div id="cbo_Ajax" style='display:none;'></div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Meta Fisica</li>
        <li>Anular</li>
        <li style="color: blue; font-weight: bold;">Cerrar</li>
        <li>Ver Documento</li>
        <li type='separator'></li>
        <li style="font-weight: bold;">Activar</li>
        <li style="font-weight: bold;">Aprobar</li>
    </ul>
</div>
