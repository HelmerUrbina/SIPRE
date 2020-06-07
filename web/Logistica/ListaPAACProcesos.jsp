<%-- 
    Document   : ListaPAACProcesos
    Created on : 10/01/2018, 02:57:25 PM
    Author     : heurbinam
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var codigo = null;
    var detalle = null;
    var mode = null;
    var modeDetalle = null;
    var certificado = null;
    var solicitudCredito = null;
    var lista = new Array();
    <c:forEach var="d" items="${objPAACProcesos}">
    var result = {codigo: '${d.codigo}', paac: '${d.numeroPAAC}', tipoProcedimiento: '${d.tipoProcedimiento}', descripcion: '${d.descripcion}',
        montoProceso: '${d.montoProceso}', certificado: '${d.certificado}', compras: '${d.compras}',
        codigoTipoProcesoContratacion: '${d.periodo}', codigoProcesoDocumento: '${d.presupuesto}',
        tipoProcesoContratacion: '${d.tipoProcesoContratacion}', procesoEtapa: '${d.procesoEtapa}',
        procesoDocumento: '${d.procesoDocumento}', montoContrato: '${d.montoContrato}', opre: '${d.estado}', 
        solicitudCredito: '${d.dependencia}', mensualizado: '${d.enero}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA GRILLA DE LA VENTANA AFECTACION - DETALLE
        var sourceAfectacion = {
            datafields: [
                {name: "afectacion", type: "string"},
                {name: "dependencia", type: "string"},
                {name: "secuenciaFuncional", type: "string"},
                {name: "tareaPresupuestal", type: "string"},
                {name: "cadenaGasto", type: "string"},
                {name: "importe", type: "number"},
                {name: "tipoCalendario", type: "string"}
            ],
            page: 20,
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            },
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            },
            updaterow: function (rowid, rowdata, commit) {
                commit(true);
            }
        };
        var dataAfectacion = new $.jqx.dataAdapter(sourceAfectacion);
        //PARA GRILLA DE LA VENTANA SECUNDARIA - DETALLE
        var sourceDetalle = {
            datafields:
                    [
                        {name: "detalle", type: "string"},
                        {name: "compromiso", type: "string"},
                        {name: "numeroContrato", type: "string"},
                        {name: "montoContrato", type: "number"},
                        {name: "secuenciaFuncional", type: "string"},
                        {name: "tareaPresupuestal", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "dependencia", type: "string"}
                    ],
            page: 20,
            pager: function (pagenum, pagesize, oldpagenum) {
                // callback called when a page or page size is changed.
            },
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            },
            updaterow: function (rowid, rowdata, commit) {
                commit(true);
            }
        };
        var dataDetalle = new $.jqx.dataAdapter(sourceDetalle);
        //PARA LA GRILLA DE LA CABECERA  
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigo', type: "string"},
                        {name: 'paac', type: "string"},
                        {name: 'tipoProcedimiento', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'montoProceso', type: "number"},
                        {name: 'certificado', type: "string"},
                        {name: 'compras', type: "string"},
                        {name: 'opre', type: "bool"},
                        {name: 'codigoTipoProcesoContratacion', type: "string"},
                        {name: 'codigoProcesoDocumento', type: "string"},
                        {name: 'tipoProcesoContratacion', type: "string"},
                        {name: 'procesoEtapa', type: "string"},
                        {name: 'procesoDocumento', type: "string"},
                        {name: 'contrato', type: "string"},
                        {name: 'montoContrato', type: "number"},
                        {name: 'solicitudCredito', type: "string"},
                        {name: 'mensualizado', type: "number"}
                    ],
            root: "PAACProcesos",
            record: "PAACProcesos",
            id: 'codigo',
            updaterow: function (rowid, rowdata, commit) {
                if (autorizacion) {
                    commit(true);
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'Usuario no Autorizado para esta Operación',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                    commit(false);
                }
            }
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (rowdata['estado'] === "ANULADO") {
                return "RowAnulado";
            }
            if (datafield === "montoProceso" || datafield === "importe") {
                return "RowBold";
            }
            if (datafield === "montoContrato") {
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
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            showtoolbar: true,
            showstatusbar: true,
            showaggregates: true,
            enabletooltips: true,
            editable: true,
            statusbarheight: 20,
            selectionmode: 'singlerow',
            editmode: 'selectedrow',
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonVerificar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/especifica42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonReporte = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonExportar);
                container.append(ButtonVerificar);
                container.append(ButtonReporte);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonVerificar.jqxButton({width: 30, height: 22});
                ButtonVerificar.jqxTooltip({position: 'bottom', content: "Verificación OPRE"});
                ButtonReporte.jqxButton({width: 30, height: 22});
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reporte"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    fn_NuevoRegistro();
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'PAACProcesos');
                });
                ButtonVerificar.click(function (event) {
                    if (autorizacion === 'true') {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Verificar los Procedimiento de Selección?',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'green',
                            typeAnimated: true,
                            buttons: {
                                aceptar: {
                                    text: 'Aceptar',
                                    btnClass: 'btn-primary',
                                    keys: ['enter', 'shift'],
                                    action: function () {
                                        mode = 'A';
                                        fn_VerificacionOPRE();
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
                });
                ButtonReporte.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            columns: [
                {text: 'N°', align: 'center', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '2%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'Nº PAC', dataField: 'paac', editable: false, width: '4%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DESCRIPCION', dataField: 'descripcion', editable: false, width: '25%', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'CERTIFICADO', dataField: 'certificado', editable: false, width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'A. COMPRAS', dataField: 'compras', editable: false, filtertype: 'checkedlist', width: '3%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'VERIFICADO', dataField: 'opre', editable: true, columntype: 'checkbox', width: '2%', align: 'center', cellsAlign: 'center'},
                {text: 'MONTO PROCESO', dataField: 'montoProceso', editable: false, width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'TIPO PROC. CONT.', dataField: 'tipoProcesoContratacion', editable: false, filtertype: 'checkedlist', width: '9%', align: 'center', cellclassname: cellclass},
                {text: 'PROC. ETAPA', dataField: 'procesoEtapa', editable: false, filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'PROC. DOCUMENT.', dataField: 'procesoDocumento', editable: false, filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'TIPO PROCEDIMIENTO', dataField: 'tipoProcedimiento', editable: false, filtertype: 'checkedlist', width: '14%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'MONTO CONTRATO', dataField: 'montoContrato', editable: false, width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'MENSUALIZACION', dataField: 'mensualizado', editable: false, width: '7%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var alto = 135;
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
                if (parseInt(event.args.originalEvent.clientY) > 500) {
                    scrollTop = scrollTop - alto;
                }
                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
                return false;
            }
        });
        //DEFINIMOS LOS EVENTOS SEGUN LA OPCION DEL MENU CONTEXTUAL
        $("#div_ContextMenu").on('itemclick', function (event) {
            var opcion = event.args;
            if (codigo === null || codigo === '') {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'Debe Seleccionar un Registro',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
            } else {
                if ($.trim($(opcion).text()) === "Editar") {
                    mode = 'U';
                    fn_EditarRegistro();
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
                } else if ($.trim($(opcion).text()) === "Certificado") {
                    $.confirm({
                        theme: 'material',
                        title: 'CERTIFICADO SIAF',
                        type: 'blue',
                        content: '' +
                                '<form action="" class="formName">' +
                                '<div class="form-group">' +
                                '<label>Ingrese el Nro. de Certificado</label>' +
                                '<input type="text" class="txt_nroSIAF form-control" required />' +
                                '</div>' +
                                '</form>',
                        buttons: {
                            formSubmit: {
                                text: 'Guardar',
                                btnClass: 'btn-blue',
                                action: function () {
                                    var msg = "";
                                    var nroSIAF = this.$content.find('.txt_nroSIAF').val();
                                    if (!nroSIAF)
                                        msg += "Debe Ingresar un Nro de Certificado valido.";
                                    msg += validarSiNumero(nroSIAF);
                                    if (msg === "") {
                                        mode = 'S';
                                        fn_GrabarCertificado(nroSIAF);
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
                            },
                            cancelar: function () {
                                //close
                            }
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
                } else if ($.trim($(opcion).text()) === "Registrar Contratos") {
                    if (!isNaN(parseInt(certificado))) {
                        fn_CargarGrillaDetalle();
                        fn_cargarComboAjax('#cbo_CompromisoAnual', {mode: 'compromisoAnualCertificado', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: certificado});
                        $("#cbo_CompromisoAnual").jqxDropDownList('setContent', "Seleccione");
                        $('#div_VentanaSecundaria').jqxWindow({title: 'REGISTRO DE CONTRATOS - PAC'});
                        $('#div_VentanaSecundaria').jqxWindow({isModal: true, modalOpacity: 0.5});
                        $('#div_VentanaSecundaria').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Debe registrar el Nro de Certificado Presupuestario',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                } else if ($.trim($(opcion).text()) === "Afectación PPTAL") {
                    if (isNaN(parseInt(certificado))) {
                        fn_CargarGrillaAfectacion();
                        $('#div_VentanaAfectacion').jqxWindow({title: 'AFECTACIÓN PRESUPUESTAL - PAC'});
                        $('#div_VentanaAfectacion').jqxWindow({isModal: true, modalOpacity: 0.5});
                        $('#div_VentanaAfectacion').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'El PAC no debe tener Certificado Presupuestal.',
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
                        content: 'Usuario no Autorizado para realizar este Tipo de Operación',
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
            codigo = row['codigo'];
            certificado = row['certificado'];
            solicitudCredito = row['solicitudCredito'];
            $("#cbo_TipoContratacion").jqxDropDownList('selectItem', row['codigoTipoProcesoContratacion']);
            $("#cbo_ProcesoDocumento").jqxDropDownList('selectItem', row['codigoProcesoDocumento']);
        });
        //CREAMOS UNA GRILLA PARA EL REGISTRO DE DETALLE
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: '100%',
            source: dataDetalle,
            pageable: true,
            columnsresize: true,
            showstatusbar: true,
            autoheight: false,
            autorowheight: false,
            showtoolbar: true,
            altrows: true,
            editable: false,
            sortable: true,
            showaggregates: true,
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var addButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var editButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/update42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var afectacionButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/especifica42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var deleteButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/delete42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                container.append(addButtonDet);
                container.append(editButtonDet);
                container.append(afectacionButtonDet);
                container.append(deleteButtonDet);
                toolbar.append(container);
                addButtonDet.jqxButton({width: 30, height: 22});
                addButtonDet.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                editButtonDet.jqxButton({width: 30, height: 22});
                editButtonDet.jqxTooltip({position: 'bottom', content: "Editar Registro"});
                afectacionButtonDet.jqxButton({width: 30, height: 22});
                afectacionButtonDet.jqxTooltip({position: 'bottom', content: "Afectación Presupuestal"});
                deleteButtonDet.jqxButton({width: 30, height: 22});
                deleteButtonDet.jqxTooltip({position: 'bottom', content: "Anular Registro"});
                // add new row.
                addButtonDet.click(function (event) {
                    modeDetalle = 'I';
                    detalle = 0;
                    $("#cbo_CompromisoAnual").jqxDropDownList('setContent', "Seleccione");
                    $('#txt_NumeroContrato').val("");
                    $('#div_MontoContratoDetalle').val(0);
                    $('#div_Acumulado').val(0);
                    $('#div_Pendiente').val(0);
                    $('#div_Enero').val(0);
                    $('#div_Febrero').val(0);
                    $('#div_Marzo').val(0);
                    $('#div_Abril').val(0);
                    $('#div_Mayo').val(0);
                    $('#div_Junio').val(0);
                    $('#div_Julio').val(0);
                    $('#div_Agosto').val(0);
                    $('#div_Setiembre').val(0);
                    $('#div_Octubre').val(0);
                    $('#div_Noviembre').val(0);
                    $('#div_Diciembre').val(0);
                    $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaDetalle').jqxWindow('open');
                });
                editButtonDet.click(function (event) {
                    modeDetalle = 'U';
                    if (indiceDetalle >= 0) {
                        $.ajax({
                            type: "GET",
                            url: "../PAACProcesos",
                            data: {mode: 'M', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo, detalle: detalle},
                            success: function (data) {
                                var dato = data.split("+++");
                                if (dato.length === 19) {
                                    $("#cbo_CompromisoAnual").jqxDropDownList('selectItem', dato[0]);
                                    $('#txt_NumeroContrato').val(dato[1]);
                                    $('#div_MontoContratoDetalle').val(parseFloat(dato[2]));
                                    $('#div_FechaInicio').val(dato[3]);
                                    $('#div_FechaFin').val(dato[4]);
                                    $('#div_Acumulado').val(parseFloat(dato[5]));
                                    $('#div_Pendiente').val(parseFloat(dato[6]));
                                    $('#div_Enero').val(parseFloat(dato[7]));
                                    $('#div_Febrero').val(parseFloat(dato[8]));
                                    $('#div_Marzo').val(parseFloat(dato[9]));
                                    $('#div_Abril').val(parseFloat(dato[10]));
                                    $('#div_Mayo').val(parseFloat(dato[11]));
                                    $('#div_Junio').val(parseFloat(dato[12]));
                                    $('#div_Julio').val(parseFloat(dato[13]));
                                    $('#div_Agosto').val(parseFloat(dato[14]));
                                    $('#div_Setiembre').val(parseFloat(dato[15]));
                                    $('#div_Octubre').val(parseFloat(dato[16]));
                                    $('#div_Noviembre').val(parseFloat(dato[17]));
                                    $('#div_Diciembre').val(parseFloat(dato[18]));
                                }
                            }
                        });
                        $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_VentanaDetalle').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'SELECCIONE UN REGISTRO',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                });
                afectacionButtonDet.click(function (event) {
                    if (indiceDetalle >= 0) {
                        fn_cargarComboAjax("#cbo_TipoCalendarioContrato", {mode: 'tipoCalendarioCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa});
                        $("#cbo_TipoCalendarioContrato").jqxDropDownList('selectItem', 0);
                        $("#cbo_ResolucionContrato").jqxDropDownList('clear');
                        $("#cbo_DependenciaContrato").jqxDropDownList('clear');
                        $("#cbo_SecuenciaFuncionalContrato").jqxDropDownList('clear');
                        $("#cbo_TareaContrato").jqxDropDownList('clear');
                        $("#cbo_CadenaGastoContrato").jqxDropDownList('clear');
                        $('#div_VentanaRegistroContratoAfectacion').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_VentanaRegistroContratoAfectacion').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'SELECCIONE UN REGISTRO',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                });
                // delete selected row.
                deleteButtonDet.click(function (event) {
                    if (indiceDetalle >= 0) {
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
                                        modeDetalle = 'D';
                                        fn_GrabarDatosDetalle();
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
                            content: 'SELECCIONE UN REGISTRO',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                });
            },
            columns: [
                {text: 'N°', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', align: 'center', columntype: 'number', width: '4%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'COMPROMISO ANUAL', datafield: 'compromiso', width: "30%", align: 'center'},
                {text: 'NRO CONTRATO', datafield: 'numeroContrato', width: "15%", align: 'center', cellsAlign: 'center'},
                {text: 'MONTO CONTRATO', dataField: 'montoContrato', width: "17%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DEPENDENCIA', datafield: 'dependencia', width: "13%", align: 'center', cellsAlign: 'center'},
                {text: 'SECUENCIA', datafield: 'secuenciaFuncional', width: "25%", align: 'center'},
                {text: 'TAREA', datafield: 'tareaPresupuestal', width: "25%", align: 'center'},
                {text: 'CADENA', datafield: 'cadenaGasto', width: "25%", align: 'center'}
            ]
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
            var row = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
            detalle = row['detalle'];
        });
        //PARA LA GRILLA DE AFETACION PRESUPUESTAL
        $("#div_GrillaAfectacion").jqxGrid({
            width: '100%',
            height: '100%',
            source: dataAfectacion,
            pageable: true,
            columnsresize: true,
            showstatusbar: true,
            autoheight: false,
            autorowheight: false,
            showtoolbar: true,
            altrows: true,
            editable: false,
            sortable: true,
            showaggregates: true,
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var addButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var deleteButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/delete42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                container.append(addButtonDet);
                container.append(deleteButtonDet);
                toolbar.append(container);
                addButtonDet.jqxButton({width: 30, height: 22});
                addButtonDet.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                deleteButtonDet.jqxButton({width: 30, height: 22});
                deleteButtonDet.jqxTooltip({position: 'bottom', content: "Eliminar Registro"});
                // add new row.
                addButtonDet.click(function (event) {
                    modeDetalle = 'I';
                    $("#cbo_Resolucion").jqxDropDownList('clear');
                    $("#cbo_TipoCalendario").jqxDropDownList('clear');
                    $("#cbo_Dependencia").jqxDropDownList('clear');
                    $("#cbo_SecuenciaFuncional").jqxDropDownList('clear');
                    $("#cbo_Tarea").jqxDropDownList('clear');
                    $("#cbo_CadenaGasto").jqxDropDownList('clear');
                    fn_cargarComboAjax("#cbo_Resolucion", {mode: 'resolucionNotaModificatoria', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipo: 'A', tipoNota: '005'});
                    $('#div_Importe').val(0);
                    $('#div_EneroAfectacion').val(0);
                    $('#div_FebreroAfectacion').val(0);
                    $('#div_MarzoAfectacion').val(0);
                    $('#div_AbrilAfectacion').val(0);
                    $('#div_MayoAfectacion').val(0);
                    $('#div_JunioAfectacion').val(0);
                    $('#div_JulioAfectacion').val(0);
                    $('#div_AgostoAfectacion').val(0);
                    $('#div_SetiembreAfectacion').val(0);
                    $('#div_OctubreAfectacion').val(0);
                    $('#div_NoviembreAfectacion').val(0);
                    $('#div_DiciembreAfectacion').val(0);
                    $("#cbo_TipoCalendario").jqxDropDownList('selectItem', "0");
                    $('#div_VentanaRegistroAfectacion').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaRegistroAfectacion').jqxWindow('open');
                });
                // delete selected row.
                deleteButtonDet.click(function (event) {
                    if (indiceDetalle >= 0) {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Eliminar este registro?',
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
                                        modeDetalle = 'D';
                                        fn_GrabarDatosAfectacion();
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
                            content: 'SELECCIONE UN REGISTRO',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                });
            },
            columns: [
                {text: 'N°', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', align: 'center', columntype: 'number', width: '4%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'DEPENDENCIA', datafield: 'dependencia', width: "14%", align: 'center'},
                {text: 'SECUENCIA', datafield: 'secuenciaFuncional', width: "20%", align: 'center'},
                {text: 'TAREA', datafield: 'tareaPresupuestal', width: "20%", align: 'center'},
                {text: 'CADENA', datafield: 'cadenaGasto', width: "25%", align: 'center'},
                {text: 'IMPORTE', dataField: 'importe', width: "12%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CALENDARIO', datafield: 'tipoCalendario', width: "15%", align: 'center'}
            ]
        });
        $("#div_GrillaAfectacion").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
            var row = $("#div_GrillaAfectacion").jqxGrid('getrowdata', indiceDetalle);
            detalle = row['afectacion'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 850;
                var alto = 310;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_NumeroPAAC").jqxInput({placeHolder: "N° PAC", width: 200, height: 20});
                        $("#txt_Descripcion").jqxInput({placeHolder: "Procedimiento de Selección", width: 600, height: 20});
                        $("#txt_Descripcion").jqxTooltip({content: '<b>DENOMINACION DE BIEN  O SERVICIO</b><br> <i>(Breve Descripción del Objeto de Contratación)</i>', position: 'mouse', name: 'movieTooltip'});
                        $("#div_ACompras").jqxCheckBox({width: 120, height: 20});
                        $("#cbo_TipoContratacion").jqxDropDownList({width: 220, height: 20, dropDownWidth: 300, animationType: 'fade', promptText: "Seleccione"});
                        $('#cbo_TipoContratacion').on('select', function (event) {
                            $("#cbo_ProcesoEtapa").jqxDropDownList('clear');
                            fn_cargarComboAjax('#cbo_ProcesoEtapa', {mode: 'procesoEtapa', codigo: $("#cbo_TipoContratacion").val()});
                        });
                        $("#cbo_ProcesoEtapa").jqxDropDownList({width: 220, height: 20, dropDownWidth: 350, animationType: 'fade', promptText: "Seleccione"});
                        $("#cbo_ProcesoDocumento").jqxDropDownList({width: 220, height: 20, animationType: 'fade', promptText: "Seleccione"});
                        $('#cbo_ProcesoDocumento').on('select', function (event) {
                            $("#cbo_TipoProcedimiento").jqxDropDownList('clear');
                            fn_cargarComboAjax('#cbo_TipoProcedimiento', {mode: 'tipoProcedimientoTipoDocumento', codigo: $("#cbo_ProcesoDocumento").val()});
                        });
                        $("#cbo_TipoProcedimiento").jqxDropDownList({width: 220, height: 20, dropDownWidth: 400, animationType: 'fade', promptText: "Seleccione"});
                        $("#txt_NumeroProcesoSeleccion").jqxInput({placeHolder: "segun SEACE", width: 220, height: 20});
                        $("#txt_NumeroProcesoSeleccion").jqxTooltip({content: '<b>NÚMERO DE PROCESO DE SELECCIÓN SEGÚN EL SEACE</b>', position: 'mouse', name: 'movieTooltip'});
                        $("#div_MontoProceso").jqxNumberInput({width: 150, height: 20, max: 999999999999, digits: 12, decimalDigits: 2});
                        $("#div_Convocatoria").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_Participantes").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_Observaciones").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_Absolucion").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_Integracion").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_Ofertas").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_Evaluacion").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_BuenaPro").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_Consentimiento").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_Contrato").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_MontoContrato").jqxNumberInput({width: 150, height: 20, max: 999999999999, digits: 12, decimalDigits: 2});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            fn_GrabarDatos();
                        });
                    }
                });
                ancho = 750;
                alto = 450;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaSecundaria').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false
                });
                //Inicia los Valores de Ventana del Detalle
                ancho = 550;
                alto = 320;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaDetalle').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarDetalle'),
                    initContent: function () {
                        $("#cbo_CompromisoAnual").jqxDropDownList({width: 420, height: 20, dropDownWidth: 550, animationType: 'fade', promptText: "Seleccione"});
                        $('#cbo_CompromisoAnual').on('change', function () {
                            if ($("#cbo_CompromisoAnual").val() === '0') {
                                $("#txt_NumeroContrato").jqxInput({disabled: true});
                                $("#div_FechaInicio").jqxDateTimeInput({disabled: true});
                                $("#div_FechaFin").jqxDateTimeInput({disabled: true});
                                $("#div_Acumulado").jqxNumberInput({disabled: true});
                                $("#div_Pendiente").jqxNumberInput({disabled: true});
                            } else {
                                $("#txt_NumeroContrato").jqxInput({disabled: false});
                                $("#div_FechaInicio").jqxDateTimeInput({disabled: false});
                                $("#div_FechaFin").jqxDateTimeInput({disabled: false});
                                $("#div_Acumulado").jqxNumberInput({disabled: false});
                                $("#div_Pendiente").jqxNumberInput({disabled: false});
                                if (unidadOperativa === '0732') {
                                    $.ajax({
                                        type: "GET",
                                        url: "../DeclaracionJurada",
                                        data: {mode: 'CAL', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, compromisoAnual: $("#cbo_CompromisoAnual").val()},
                                        success: function (data) {
                                            var dato = data.split("+++");
                                            if (dato.length === 2) {
                                                $("#txt_NumeroContrato").val(dato[1]);
                                            }
                                        }
                                    });
                                }
                            }
                        });
                        $("#txt_NumeroContrato").jqxInput({placeHolder: "N° Contrato OC/OS", width: 200, height: 20});
                        $("#txt_NumeroContrato").jqxTooltip({content: '<b>NÚMERO DEL CONTRATO/ORDEN DE SERVICIO O COMPRA QUE FORMALIZA LA RELACIÓN CONTRACTUAL</b>', position: 'mouse', name: 'movieTooltip'});
                        $("#div_MontoContratoDetalle").jqxNumberInput({width: 140, height: 20, max: 999999999999, digits: 10, decimalDigits: 2});
                        $("#div_FechaInicio").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 110, height: 20});
                        $("#div_FechaFin").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 110, height: 20});
                        $("#div_Acumulado").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Acumulado").jqxTooltip({content: '<b>EJECUCIÓN ACUMULADA AÑOS ANTERIORES DEL CONTRATO</b>', position: 'mouse', name: 'movieTooltip'});
                        $("#div_Pendiente").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Pendiente").jqxTooltip({content: '<b>SALDO PENDIENTE DE EJECUCIÓN DEL CONTRATO/ORDEN DE SERVICIO O COMPRA AF-2019</b>', position: 'mouse', name: 'movieTooltip'});
                        $("#div_Enero").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Enero').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Febrero").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Febrero').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Marzo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Marzo').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Abril").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Abril').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Mayo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Mayo').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Junio").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Junio').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Julio").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Julio').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Agosto").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Agosto').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Setiembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Setiembre').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Octubre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Octubre').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Noviembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Noviembre').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Diciembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_Diciembre').on('textchanged', function (event) {
                            fn_TotalMensualizacion();
                        });
                        $("#div_Total").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                        $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').on('click', function (event) {
                            if (parseFloat($("#div_Total").val()) === parseFloat($("#div_MontoContratoDetalle").val())) {
                                fn_GrabarDatosDetalle();
                            } else {
                                $.alert({
                                    theme: 'material',
                                    title: 'AVISO DEL SISTEMA',
                                    content: 'Falta Mensualizar, por favor registre la Mensualización!!',
                                    animation: 'zoom',
                                    closeAnimation: 'zoom',
                                    type: 'orange',
                                    typeAnimated: true
                                });
                            }
                        });
                    }
                });
                ancho = 800;
                alto = 550;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaAfectacion').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false
                });
                //Inicia los Valores de Ventana del Detalle del Contrato (Afectacion)
                ancho = 600;
                alto = 200;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaRegistroContratoAfectacion').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarRegistroContratoAfectacion'),
                    initContent: function () {
                        $("#cbo_TipoCalendarioContrato").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                        $('#cbo_TipoCalendarioContrato').on('change', function () {
                            fn_cargarComboAjax("#cbo_ResolucionContrato", {mode: 'resolucionCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                                tipoCalendario: $("#cbo_TipoCalendarioContrato").val(), tipoCertificado: 'RE', solicitudCredito: solicitudCredito, informeDisponibilidad: null});
                        });
                        $("#cbo_ResolucionContrato").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 550, height: 20});
                        $('#cbo_ResolucionContrato').on('change', function () {
                            fn_cargarComboAjax("#cbo_DependenciaContrato", {mode: 'dependenciaCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                                tipoCalendario: $("#cbo_TipoCalendarioContrato").val(), resolucion: $("#cbo_ResolucionContrato").val(), tipoCertificado: 'RE', solicitudCredito: solicitudCredito, informeDisponibilidad: null});
                        });
                        $("#cbo_DependenciaContrato").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 550, height: 20});
                        $('#cbo_DependenciaContrato').on('change', function () {
                            fn_cargarComboAjax("#cbo_SecuenciaFuncionalContrato", {mode: 'secuenciaFuncionalCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                                tipoCalendario: $("#cbo_TipoCalendarioContrato").val(), resolucion: $("#cbo_ResolucionContrato").val(), dependencia: $("#cbo_DependenciaContrato").val(),
                                tipoCertificado: 'RE', solicitudCredito: solicitudCredito, informeDisponibilidad: null});
                        });
                        $("#cbo_SecuenciaFuncionalContrato").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 600, height: 20});
                        $('#cbo_SecuenciaFuncionalContrato').on('change', function () {
                            fn_cargarComboAjax("#cbo_TareaContrato", {mode: 'tareaCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                                tipoCalendario: $("#cbo_TipoCalendarioContrato").val(), resolucion: $("#cbo_ResolucionContrato").val(), dependencia: $("#cbo_DependenciaContrato").val(),
                                secuenciaFuncional: $("#cbo_SecuenciaFuncionalContrato").val(), tipoCertificado: 'RE', solicitudCredito: solicitudCredito, informeDisponibilidad: null});
                        });
                        $("#cbo_TareaContrato").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 600, height: 20});
                        $('#cbo_TareaContrato').on('change', function () {
                            fn_cargarComboAjax("#cbo_CadenaGastoContrato", {mode: 'cadenaGastoCertificacion', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa,
                                tipoCalendario: $("#cbo_TipoCalendarioContrato").val(), resolucion: $("#cbo_ResolucionContrato").val(), dependencia: $("#cbo_DependenciaContrato").val(),
                                secuenciaFuncional: $("#cbo_SecuenciaFuncionalContrato").val(), tarea: $("#cbo_TareaContrato").val(), tipoCertificado: 'RE', solicitudCredito: solicitudCredito, informeDisponibilidad: null});
                        });
                        $("#cbo_CadenaGastoContrato").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 600, height: 20});
                        $('#btn_CancelarRegistroContratoAfectacion').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRegistroContratoAfectacion').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRegistroContratoAfectacion').on('click', function (event) {
                            fn_GrabarDatosDetalleContratoAfectacion();
                        });
                    }
                });
                //Inicia los Valores de Ventana del Detalle
                ancho = 600;
                alto = 390;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaRegistroAfectacion').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarDetalleAfectacion'),
                    initContent: function () {
                        $("#cbo_Resolucion").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 550, height: 20});
                        $('#cbo_Resolucion').on('change', function () {
                            fn_cargarComboAjax("#cbo_TipoCalendario", {mode: 'tipoCalendarioNotaModificatoria', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipo: 'A', tipoNota: '005',
                                resolucion: $("#cbo_Resolucion").val()});
                        });
                        $("#cbo_TipoCalendario").jqxDropDownList({animationType: 'fade', width: 480, height: 20});
                        $('#cbo_TipoCalendario').on('change', function () {
                            fn_cargarComboAjax("#cbo_Dependencia", {mode: 'dependenciaNotaModificatoria', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipo: 'A', tipoNota: '005',
                                tipoCalendario: $("#cbo_TipoCalendario").val(), resolucion: $("#cbo_Resolucion").val()});
                        });
                        $("#cbo_Dependencia").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 550, height: 20});
                        $('#cbo_Dependencia').on('change', function () {
                            fn_cargarComboAjax("#cbo_SecuenciaFuncional", {mode: 'secuenciaFuncionalNotaModificatoria', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipo: 'A', tipoNota: '005',
                                tipoCalendario: $("#cbo_TipoCalendario").val(), resolucion: $("#cbo_Resolucion").val(), dependencia: $("#cbo_Dependencia").val()});
                        });
                        $("#cbo_SecuenciaFuncional").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 600, height: 20});
                        $('#cbo_SecuenciaFuncional').on('change', function () {
                            fn_cargarComboAjax("#cbo_Tarea", {mode: 'tareaNotaModificatoria', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipo: 'A', tipoNota: '005',
                                tipoCalendario: $("#cbo_TipoCalendario").val(), resolucion: $("#cbo_Resolucion").val(), dependencia: $("#cbo_Dependencia").val(),
                                secuenciaFuncional: $("#cbo_SecuenciaFuncional").val()});
                        });
                        $("#cbo_Tarea").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 600, height: 20});
                        $('#cbo_Tarea').on('change', function () {
                            fn_cargarComboAjax("#cbo_CadenaGasto", {mode: 'cadenaGastoNotaModificatoria', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, tipo: 'A', tipoNota: '005',
                                tipoCalendario: $("#cbo_TipoCalendario").val(), resolucion: $("#cbo_Resolucion").val(), dependencia: $("#cbo_Dependencia").val(), secuenciaFuncional: $("#cbo_SecuenciaFuncional").val(),
                                tarea: $("#cbo_Tarea").val()});
                        });
                        $("#cbo_CadenaGasto").jqxDropDownList({animationType: 'fade', width: 480, dropDownWidth: 600, height: 20});
                        $("#div_ImporteAfectacion").jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_EneroAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_EneroAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_FebreroAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_FebreroAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_MarzoAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_MarzoAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_AbrilAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_AbrilAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_MayoAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_MayoAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_JunioAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_JunioAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_JulioAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_JulioAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_AgostoAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_AgostoAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_SetiembreAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_SetiembreAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_OctubreAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_OctubreAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_NoviembreAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_NoviembreAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_DiciembreAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#div_DiciembreAfectacion').on('textchanged', function (event) {
                            fn_TotalMensualizacionAfectacion();
                        });
                        $("#div_TotalAfectacion").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});
                        $('#btn_CancelarDetalleAfectacion').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalleAfectacion').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalleAfectacion').on('click', function (event) {
                            if (parseFloat($("#div_TotalAfectacion").val()) === parseFloat($("#div_ImporteAfectacion").val())) {
                                fn_GrabarDatosAfectacion();
                            } else {
                                $.alert({
                                    theme: 'material',
                                    title: 'AVISO DEL SISTEMA',
                                    content: 'Falta Mensualizar, por favor registre la Mensualización!!',
                                    animation: 'zoom',
                                    closeAnimation: 'zoom',
                                    type: 'orange',
                                    typeAnimated: true
                                });
                            }
                        });
                    }
                });
                ancho = 400;
                alto = 140;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_Reporte').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CerrarImprimir'),
                    initContent: function () {
                        $("#div_LOG0001").jqxRadioButton({width: 200, height: 20});
                        $('#div_LOG0001').on('checked', function (event) {
                            reporte = 'LOG0001';
                        });
                        $("#div_LOG0003").jqxRadioButton({width: 200, height: 20});
                        $('#div_LOG0003').on('checked', function (event) {
                            reporte = 'LOG0003';
                        });
                        $("#div_LOG0004").jqxRadioButton({width: 200, height: 20});
                        $('#div_LOG0004').on('checked', function (event) {
                            reporte = 'LOG0004';
                        });
                        $("#div_LOG0005").jqxRadioButton({width: 200, height: 20});
                        $('#div_LOG0005').on('checked', function (event) {
                            reporte = 'LOG0005';
                        });
                        $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').on('click', function (event) {
                            var msg = "";
                            switch (reporte) {
                                case "LOG0001":
                                    break;
                                case "LOG0003":
                                    break;
                                case "LOG0004":
                                    break;
                                case "LOG0005":
                                    break;
                                default:
                                    msg += "Debe selecciona una opción.<br>";
                                    break;
                            }
                            if (msg === "") {
                                var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&presupuesto=' + presupuesto + '&unidadOperativa=' + unidadOperativa;
                                window.open(url, '_blank');
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
            }
            return {init: function () {
                    _createElements();
                }
            };
        }());
        $(document).ready(function () {
            customButtonsDemo.init();
        });
    });
    //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
    function fn_NuevoRegistro() {
        mode = 'I';
        codigo = 0;
        $("#cbo_TipoContratacion").jqxDropDownList('selectItem', 0);
        $("#cbo_ProcesoDocumento").jqxDropDownList('selectItem', 0);
        $("#txt_NumeroPAAC").val("");
        $("#txt_NumeroProcesoSeleccion").val("");
        $("#txt_Descripcion").val("");
        $("#div_MontoProceso").val(0.0);
        $("#div_MontoContrato").val(0.0);
        $("#div_ACompras").val(0);
        $("#cbo_ProcesoEtapa").jqxDropDownList('setContent', "Seleccione");
        $("#cbo_TipoProcedimiento").jqxDropDownList('setContent', "Seleccione");
        $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
        $('#div_VentanaPrincipal').jqxWindow('open');
    }
    function fn_Refrescar() {
        $("#div_VentanaPrincipal").remove();
        $("#div_VentanaSecundaria").remove();
        $("#div_VentanaDetalle").remove();
        $("#div_VentanaRegistroContratoAfectacion").remove();
        $("#div_VentanaAfectacion").remove();
        $("#div_VentanaRegistroAfectacion").remove();
        $("#div_ContextMenu").remove();
        $("#div_Reporte").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "GET",
            url: "../PAACProcesos",
            data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
            success: function (data) {
                $contenidoAjax.html(data);
            }
        });
    }
    function fn_CargarGrillaDetalle() {
        $('#div_GrillaRegistro').jqxGrid('clear');
        $.ajax({
            type: "GET",
            url: "../PAACProcesos",
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
                    var row = {detalle: datos[0], compromiso: datos[1], numeroContrato: datos[2], montoContrato: parseFloat(datos[3]),
                        secuenciaFuncional: datos[4], tareaPresupuestal: datos[5], cadenaGasto: datos[6], dependencia: datos[7]};
                    rows.push(row);
                }
                if (rows.length > 0)
                    $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
            }
        });
    }
    function fn_CargarGrillaAfectacion() {
        $('#div_GrillaAfectacion').jqxGrid('clear');
        $.ajax({
            type: "GET",
            url: "../PAACProcesos",
            data: {mode: 'C', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
            success: function (data) {
                data = data.replace("[", "");
                var fila = data.split("[");
                var rows = new Array();
                for (i = 1; i < fila.length; i++) {
                    var columna = fila[i];
                    var datos = columna.split("+++");
                    while (datos[6].indexOf(']') > 0) {
                        datos[6] = datos[6].replace("]", "");
                    }
                    while (datos[6].indexOf(',') > 0) {
                        datos[6] = datos[6].replace(",", "");
                    }
                    var row = {afectacion: datos[0], dependencia: datos[1], secuenciaFuncional: datos[2], tareaPresupuestal: datos[3], cadenaGasto: datos[4], importe: parseFloat(datos[5]), tipoCalendario: datos[6]};
                    rows.push(row);
                }
                if (rows.length > 0)
                    $("#div_GrillaAfectacion").jqxGrid('addrow', null, rows);
            }
        });
    }
    //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
    function fn_EditarRegistro() {
        $.ajax({
            type: "GET",
            url: "../PAACProcesos",
            data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo},
            success: function (data) {
                var dato = data.split("+++");
                if (dato.length === 20) {
                    $("#txt_NumeroPAAC").val(dato[0]);
                    $("#cbo_ProcesoEtapa").jqxDropDownList('selectItem', dato[2]);
                    $("#cbo_TipoProcedimiento").jqxDropDownList('selectItem', dato[4]);
                    $("#txt_NumeroProcesoSeleccion").val(dato[5]);
                    $("#txt_Descripcion").val(dato[6]);
                    $("#div_MontoProceso").val(parseFloat(dato[7]));
                    $("#div_Convocatoria").val(dato[8]);
                    $("#div_Participantes").val(dato[9]);
                    $("#div_Observaciones").val(dato[10]);
                    $("#div_Absolucion").val(dato[11]);
                    $("#div_Integracion").val(dato[12]);
                    $("#div_Ofertas").val(dato[13]);
                    $("#div_Evaluacion").val(dato[14]);
                    $("#div_BuenaPro").val(dato[15]);
                    $("#div_Consentimiento").val(dato[16]);
                    $("#div_Contrato").val(dato[17]);
                    $("#div_MontoContrato").val(parseFloat(dato[18]));
                    $("#div_ACompras").val(parseInt(dato[19]));
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                }
            }
        });
    }
    //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
    function fn_GrabarDatos() {
        var numeroPAAC = $("#txt_NumeroPAAC").val();
        var tipoContratacion = $("#cbo_TipoContratacion").val();
        var procesoEtapa = $("#cbo_ProcesoEtapa").val();
        var procesoDocumento = $("#cbo_ProcesoDocumento").val();
        var tipoProcedimiento = $("#cbo_TipoProcedimiento").val();
        var descripcion = $("#txt_Descripcion").val();
        var numeroProceso = $("#txt_NumeroProcesoSeleccion").val();
        var montoProceso = $("#div_MontoProceso").val();
        var convocatoria = $("#div_Convocatoria").val();
        var participantes = $("#div_Participantes").val();
        var observaciones = $("#div_Observaciones").val();
        var absolucion = $("#div_Absolucion").val();
        var integracion = $("#div_Integracion").val();
        var ofertas = $("#div_Ofertas").val();
        var evaluacion = $("#div_Evaluacion").val();
        var buenaPro = $("#div_BuenaPro").val();
        var consentimiento = $("#div_Consentimiento").val();
        var contrato = $("#div_Contrato").val();
        var montoContrato = $("#div_MontoContrato").val();
        var compras = $("#div_ACompras").val();
        if (compras)
            compras = 1;
        else
            compras = 0;
        $.ajax({
            type: "POST",
            url: "../IduPAACProcesos",
            data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo, numeroPAAC: numeroPAAC,
                tipoContratacion: tipoContratacion, procesoEtapa: procesoEtapa, procesoDocumento: procesoDocumento, tipoProcedimiento: tipoProcedimiento,
                descripcion: descripcion, numeroProceso: numeroProceso, montoProceso: montoProceso, convocatoria: convocatoria, participantes: participantes,
                observaciones: observaciones, absolucion: absolucion, integracion: integracion, ofertas: ofertas, evaluacion: evaluacion,
                buenaPro: buenaPro, consentimiento: consentimiento, contrato: contrato, montoContrato: montoContrato, compras: compras},
            success: function (data) {
                msg = data;
                if (msg === "GUARDO") {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Datos procesados correctamente!!',
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
    }
    function fn_GrabarCertificado(nroSIAF) {
        $.ajax({
            type: "POST",
            url: "../IduPAACProcesos",
            data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo, certificado: nroSIAF},
            success: function (data) {
                msg = data;
                if (msg === "GUARDO") {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Datos procesados correctamente!!',
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
    }
    //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
    function fn_GrabarDatosDetalle() {
        var compromisoAnual = $("#cbo_CompromisoAnual").val();
        var numeroContrato = $("#txt_NumeroContrato").val();
        var montoContrato = $("#div_MontoContratoDetalle").val();
        var fechaInicio = $("#div_FechaInicio").val();
        var fechaFin = $("#div_FechaFin").val();
        var acumulado = $("#div_Acumulado").val();
        var pendiente = $("#div_Pendiente").val();
        var enero = parseFloat($("#div_Enero").jqxNumberInput('decimal'));
        var febrero = parseFloat($("#div_Febrero").jqxNumberInput('decimal'));
        var marzo = parseFloat($("#div_Marzo").jqxNumberInput('decimal'));
        var abril = parseFloat($("#div_Abril").jqxNumberInput('decimal'));
        var mayo = parseFloat($("#div_Mayo").jqxNumberInput('decimal'));
        var junio = parseFloat($("#div_Junio").jqxNumberInput('decimal'));
        var julio = parseFloat($("#div_Julio").jqxNumberInput('decimal'));
        var agosto = parseFloat($("#div_Agosto").jqxNumberInput('decimal'));
        var setiembre = parseFloat($("#div_Setiembre").jqxNumberInput('decimal'));
        var octubre = parseFloat($("#div_Octubre").jqxNumberInput('decimal'));
        var noviembre = parseFloat($("#div_Noviembre").jqxNumberInput('decimal'));
        var diciembre = parseFloat($("#div_Diciembre").jqxNumberInput('decimal'));
        $.ajax({
            type: "POST",
            url: "../IduPAACProcesosDetalle",
            data: {mode: modeDetalle, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo, detalle: detalle,
                compromisoAnual: compromisoAnual, numeroContrato: numeroContrato, montoContrato: montoContrato, fechaInicio: fechaInicio, fechaFin: fechaFin,
                acumulado: acumulado, pendiente: pendiente, enero: enero, febrero: febrero, marzo: marzo,
                abril: abril, mayo: mayo, junio: junio, julio: julio, agosto: agosto, setiembre: setiembre,
                octubre: octubre, noviembre: noviembre, diciembre: diciembre},
            success: function (data) {
                msg = data;
                if (msg === "GUARDO") {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Datos procesados correctamente!!',
                        type: 'green',
                        typeAnimated: true,
                        autoClose: 'cerrarAction|1000',
                        buttons: {
                            cerrarAction: {
                                text: 'Cerrar',
                                action: function () {
                                    $('#div_VentanaDetalle').jqxWindow('close');
                                    fn_CargarGrillaDetalle();
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
    //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
    function fn_GrabarDatosAfectacion() {
        var tipoCalendario = $("#cbo_TipoCalendario").val();
        var resolucion = $("#cbo_Resolucion").val();
        var dependencia = $("#cbo_Dependencia").val();
        var secuenciaFuncional = $("#cbo_SecuenciaFuncional").val();
        var tareaPresupuestal = $("#cbo_Tarea").val();
        var cadenaGasto = $("#cbo_CadenaGasto").val();
        var importe = parseFloat($("#div_ImporteAfectacion").jqxNumberInput('decimal'));
        var enero = parseFloat($("#div_EneroAfectacion").jqxNumberInput('decimal'));
        var febrero = parseFloat($("#div_FebreroAfectacion").jqxNumberInput('decimal'));
        var marzo = parseFloat($("#div_MarzoAfectacion").jqxNumberInput('decimal'));
        var abril = parseFloat($("#div_AbrilAfectacion").jqxNumberInput('decimal'));
        var mayo = parseFloat($("#div_MayoAfectacion").jqxNumberInput('decimal'));
        var junio = parseFloat($("#div_JunioAfectacion").jqxNumberInput('decimal'));
        var julio = parseFloat($("#div_JulioAfectacion").jqxNumberInput('decimal'));
        var agosto = parseFloat($("#div_AgostoAfectacion").jqxNumberInput('decimal'));
        var setiembre = parseFloat($("#div_SetiembreAfectacion").jqxNumberInput('decimal'));
        var octubre = parseFloat($("#div_OctubreAfectacion").jqxNumberInput('decimal'));
        var noviembre = parseFloat($("#div_NoviembreAfectacion").jqxNumberInput('decimal'));
        var diciembre = parseFloat($("#div_DiciembreAfectacion").jqxNumberInput('decimal'));
        $.ajax({
            type: "POST",
            url: "../IduPAACProcesosAfectacion",
            data: {mode: modeDetalle, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo, detalle: detalle,
                tipoCalendario: tipoCalendario, resolucion: resolucion, dependencia: dependencia, secuenciaFuncional: secuenciaFuncional,
                tareaPresupuestal: tareaPresupuestal, cadenaGasto: cadenaGasto, importe: importe, enero: enero, febrero: febrero, marzo: marzo,
                abril: abril, mayo: mayo, junio: junio, julio: julio, agosto: agosto, setiembre: setiembre,
                octubre: octubre, noviembre: noviembre, diciembre: diciembre},
            success: function (data) {
                msg = data;
                if (msg === "GUARDO") {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Datos procesados correctamente!!',
                        type: 'green',
                        typeAnimated: true,
                        autoClose: 'cerrarAction|1000',
                        buttons: {
                            cerrarAction: {
                                text: 'Cerrar',
                                action: function () {
                                    $('#div_VentanaRegistroAfectacion').jqxWindow('close');
                                    fn_CargarGrillaAfectacion();
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
    //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
    function fn_GrabarDatosDetalleContratoAfectacion() {
        var tipoCalendario = $("#cbo_TipoCalendarioContrato").val();
        var resolucion = $("#cbo_ResolucionContrato").val();
        var dependencia = $("#cbo_DependenciaContrato").val();
        var secuenciaFuncional = $("#cbo_SecuenciaFuncionalContrato").val();
        var tareaPresupuestal = $("#cbo_TareaContrato").val();
        var cadenaGasto = $("#cbo_CadenaGastoContrato").val();
        $.ajax({
            type: "POST",
            url: "../IduPAACProcesosDetalleContrato",
            data: {mode: modeDetalle, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo, detalle: detalle,
                tipoCalendario: tipoCalendario, resolucion: resolucion, dependencia: dependencia, secuenciaFuncional: secuenciaFuncional,
                tareaPresupuestal: tareaPresupuestal, cadenaGasto: cadenaGasto},
            success: function (data) {
                msg = data;
                if (msg === "GUARDO") {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Datos procesados correctamente!!',
                        type: 'green',
                        typeAnimated: true,
                        autoClose: 'cerrarAction|1000',
                        buttons: {
                            cerrarAction: {
                                text: 'Cerrar',
                                action: function () {
                                    $('#div_VentanaRegistroContratoAfectacion').jqxWindow('close');
                                    fn_CargarGrillaDetalle();
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
    //
    //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
    function fn_VerificacionOPRE() {
        var msg = "";
        var lista = new Array();
        var result;
        var rows = $('#div_GrillaPrincipal').jqxGrid('getrows');
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            result = row.codigo + "---" + row.opre;
            lista.push(result);
        }
        $.ajax({
            type: "POST",
            url: "../IduPAACProcesos",
            data: {mode: 'A', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo, lista: JSON.stringify(lista)},
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
    //FUNCION PARA VALIDAR EL TOTAL DE CREDITO Y NO GENERE SALDO NEGATIVO
    function fn_TotalMensualizacion() {
        var total = $("#div_Enero").val() + $("#div_Febrero").val() + $("#div_Marzo").val() + $("#div_Abril").val() + $("#div_Mayo").val() + $("#div_Junio").val() +
                $("#div_Julio").val() + $("#div_Agosto").val() + $("#div_Setiembre").val() + $("#div_Octubre").val() + $("#div_Noviembre").val() + $("#div_Diciembre").val();
        $("#div_Total").val(parseFloat(total));
        if (parseFloat(total) > parseFloat($("#div_MontoContratoDetalle").val())) {
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: 'Saldo Inferior. Revise!!',
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'orange',
                typeAnimated: true
            });
        }
    }
    //FUNCION PARA VALIDAR EL TOTAL DE CREDITO Y NO GENERE SALDO NEGATIVO
    function fn_TotalMensualizacionAfectacion() {
        var total = $("#div_EneroAfectacion").val() + $("#div_FebreroAfectacion").val() + $("#div_MarzoAfectacion").val() + $("#div_AbrilAfectacion").val() + $("#div_MayoAfectacion").val() + $("#div_JunioAfectacion").val() +
                $("#div_JulioAfectacion").val() + $("#div_AgostoAfectacion").val() + $("#div_SetiembreAfectacion").val() + $("#div_OctubreAfectacion").val() + $("#div_NoviembreAfectacion").val() + $("#div_DiciembreAfectacion").val();
        $("#div_TotalAfectacion").val(parseFloat(total));
        if (parseFloat(total) > parseFloat($("#div_ImporteAfectacion").val())) {
            $.alert({
                theme: 'material',
                title: 'AVISO DEL SISTEMA',
                content: 'Saldo Inferior. Revise!!',
                animation: 'zoom',
                closeAnimation: 'zoom',
                type: 'orange',
                typeAnimated: true
            });
        }
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">PLAN ANUAL DE CONTRATACIONES</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_PAAC" name="frm_PAAC" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">  
                <tr>
                    <td class="inputlabel">N° PAC : </td>
                    <td colspan="2"><input type="text" id="txt_NumeroPAAC" name="txt_NumeroPAAC" style="text-transform: uppercase;"/></td>
                    <td><div id='div_ACompras'>A. Compras</div></div>
                </tr>
                <tr>
                    <td class="inputlabel">Descripción : </td>
                    <td colspan="3"><input type="text" id="txt_Descripcion" name="txt_Descripcion" style="text-transform: uppercase;"/></td>
                </tr> 
                <tr>
                    <td class="inputlabel">Proceso de Contratación : </td>
                    <td >
                        <select id="cbo_TipoContratacion" name="cbo_TipoContratacion">
                            <option value="0">Seleccione</option> 
                            <c:forEach var="e" items="${objTipoProcesoContratacion}">
                                <option value="${e.codigo}">${e.descripcion}</option>
                            </c:forEach>  
                        </select>
                    </td>   
                    <td class="inputlabel">Etapa del Proceso : </td>
                    <td>
                        <select id="cbo_ProcesoEtapa" name="cbo_ProcesoEtapa">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Tipo de Documento : </td>
                    <td>
                        <select id="cbo_ProcesoDocumento" name="cbo_ProcesoDocumento">
                            <option value="0">Seleccione</option> 
                            <c:forEach var="f" items="${objProcesoDocumento}">   
                                <option value="${f.codigo}">${f.descripcion}</option>
                            </c:forEach> 
                        </select>
                    </td> 
                    <td class="inputlabel">Tipo Procedimiento : </td>
                    <td>
                        <select id="cbo_TipoProcedimiento" name="cbo_TipoProcedimiento">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr> 
                <tr>
                    <td class="inputlabel">N° Proceso Selección : </td>
                    <td><input type="text" id="txt_NumeroProcesoSeleccion" name="txt_NumeroProcesoSeleccion" style="text-transform: uppercase;"/></td>
                    <td class="inputlabel">Monto Proceso : </td>
                    <td><div id="div_MontoProceso"></div></td>
                </tr> 
                <tr>
                    <td class="inputlabel">Convocatoria : </td>
                    <td><div id="div_Convocatoria"></div>
                    <td class="inputlabel">Reg. de Participantes : </td>
                    <td><div id="div_Participantes"></div>
                </tr>
                <tr>
                    <td class="inputlabel">Consul. y Obser. : </td>
                    <td><div id="div_Observaciones"></div>
                    <td class="inputlabel">Absol. Consul. y Obser. : </td>
                    <td><div id="div_Absolucion"></div>
                </tr>
                <tr>
                    <td class="inputlabel">Integ. de Bases : </td>
                    <td><div id="div_Integracion"></div>
                    <td class="inputlabel">Present. de Ofertas : </td>
                    <td><div id="div_Ofertas"></div>
                </tr>
                <tr>
                    <td class="inputlabel">Eval. y Calif. : </td>
                    <td><div id="div_Evaluacion"></div></td>
                    <td class="inputlabel">Otor. de B/Pro : </td>
                    <td><div id="div_BuenaPro"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Consent. B/Pro : </td>
                    <td><div id="div_Consentimiento"></div></td>
                    <td class="inputlabel">Firma Contrato : </td>
                    <td><div id="div_Contrato"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Monto Contrato : </td>
                    <td colspan="3"><div id="div_MontoContrato"></div></td> 
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
<div id="div_VentanaSecundaria" style="display: none">
    <div>
        <span style="float: left">CONTRATOS - PLAN ANUAL DE CONTRATACIONES</span>
    </div>
    <div style="overflow: hidden">
        <div id="div_GrillaRegistro"></div>
        <div id="div_VentanaDetalle" style="display: none" >
            <div>
                <span style="float: left">REGISTRO DE CONTRATO - ORDEN COMPRA/SERVICIO</span>
            </div>
            <div style="overflow: hidden">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="inputlabel">Compr. Anual : </td>
                        <td colspan="3">
                            <select id="cbo_CompromisoAnual" name="cbo_CompromisoAnual">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Numero : </td>
                        <td><input type="text" id="txt_NumeroContrato" name="txt_NumeroContrato" style="text-transform: uppercase;"/></td>
                        <td class="inputlabel">Monto : </td>
                        <td><div id="div_MontoContratoDetalle"></div></td>
                    </tr> 
                    <tr>
                        <td class="inputlabel">Inicio : </td>
                        <td><div id="div_FechaInicio"></div>
                        <td class="inputlabel">Fin : </td>
                        <td><div id="div_FechaFin"></div>
                    </tr>
                    <tr>
                        <td class="inputlabel">Acumulado : </td>
                        <td><div id="div_Acumulado"></div></td>
                        <td class="inputlabel">Pendiente : </td>
                        <td><div id="div_Pendiente"></div></td> 
                    </tr>
                    <tr class="TituloDetalle" style="text-align: center">
                        <td>Mes</td>
                        <td>Mensualizar(DEV)</td>
                        <td>Mes</td>
                        <td>Mensualizar(DEV)</td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Enero : </td>
                        <td><div id="div_Enero"></div></td>
                        <td class="inputlabel">Febrero : </td>
                        <td><div id="div_Febrero"></div></td> 
                    </tr>
                    <tr>
                        <td class="inputlabel">Marzo : </td>
                        <td><div id="div_Marzo"></div></td>
                        <td class="inputlabel">Abril : </td>
                        <td><div id="div_Abril"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Mayo : </td>
                        <td><div id="div_Mayo"></div></td>
                        <td class="inputlabel">Junio : </td>
                        <td><div id="div_Junio"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Julio : </td>
                        <td><div id="div_Julio"></div></td>
                        <td class="inputlabel">Agosto : </td>
                        <td><div id="div_Agosto"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Setiembre : </td>
                        <td><div id="div_Setiembre"></div></td>
                        <td class="inputlabel">Octubre : </td>
                        <td><div id="div_Octubre"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Noviembre : </td>
                        <td><div id="div_Noviembre"></div></td>
                        <td class="inputlabel">Diciembre : </td>
                        <td><div id="div_Diciembre"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Total : </td>
                        <td colspan="3"><div id="div_Total"></div></td>
                    </tr>
                    <tr>
                        <td class="Summit" colspan="4">
                            <div>
                                <input type="button" id="btn_GuardarDetalle" value="Guardar" style="margin-right: 20px"/>
                                <input type="button" id="btn_CancelarDetalle" value="Cancelar" style="margin-right: 20px"/>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>      
<div id='div_VentanaRegistroContratoAfectacion' style='display: none;'>
    <div>
        <span style="float: left">REGISTRO CONTRATO - AFECTACIÓN PRESUPUESTAL</span>
    </div>
    <div style="overflow: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="inputlabel">Calendario : </td>
                <td colspan="3">
                    <select id="cbo_TipoCalendarioContrato" name="cbo_TipoCalendarioContrato">
                        <option value="0">Seleccione</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputlabel">Resoluci&oacute;n : </td>
                <td colspan="3">
                    <select id="cbo_ResolucionContrato" name="cbo_ResolucionContrato">
                        <option value="0">Seleccione</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputlabel">Dependencia : </td>
                <td colspan="3">
                    <select id="cbo_DependenciaContrato" name="cbo_DependenciaContrato">
                        <option value="0">Seleccione</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputlabel">Sec. Func. : </td>
                <td colspan="3">
                    <select id="cbo_SecuenciaFuncionalContrato" name="cbo_SecuenciaFuncionalContrato">
                        <option value="0">Seleccione</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputlabel">Tarea : </td>
                <td colspan="3">
                    <select id="cbo_TareaContrato" name="cbo_TareaContrato">
                        <option value="0">Seleccione</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputlabel">Cad. Gasto : </td>
                <td colspan="3">
                    <select id="cbo_CadenaGastoContrato" name="cbo_CadenaGastoContrato">
                        <option value="0">Seleccione</option>
                    </select>
                </td>
            </tr>            
            <tr>
                <td class="Summit" colspan="4">
                    <div>
                        <input type="button" id="btn_GuardarRegistroContratoAfectacion" name="btn_GuardarRegistroContratoAfectacion" value="Guardar" style="margin-right: 20px"/>
                        <input type="button" id="btn_CancelarRegistroContratoAfectacion" name="btn_CancelarRegistroContratoAfectacion" value="Cancelar" style="margin-right: 20px"/>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</div>
<div id="div_VentanaAfectacion" style="display: none;">
    <div>
        <span style="float: left">PAC - AFECTACIÓN PRESUPUESTAL</span>
    </div>
    <div style="overflow: hidden"> 
        <div id="div_GrillaAfectacion"></div>
        <div id='div_VentanaRegistroAfectacion' style='display: none;'>
            <div>
                <span style="float: left">REGISTRO AFECTACIÓN PRESUPUESTAL</span>
            </div>
            <div style="overflow: hidden">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="inputlabel">Resoluci&oacute;n : </td>
                        <td colspan="3">
                            <select id="cbo_Resolucion" name="cbo_Resolucion">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Calendario : </td>
                        <td colspan="3">
                            <select id="cbo_TipoCalendario" name="cbo_TipoCalendario">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Dependencia : </td>
                        <td colspan="3">
                            <select id="cbo_Dependencia" name="cbo_Dependencia">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Sec. Func. : </td>
                        <td colspan="3">
                            <select id="cbo_SecuenciaFuncional" name="cbo_SecuenciaFuncional">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Tarea : </td>
                        <td colspan="3">
                            <select id="cbo_Tarea" name="cbo_Tarea">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Cad. Gasto : </td>
                        <td colspan="3">
                            <select id="cbo_CadenaGasto" name="cbo_CadenaGasto">
                                <option value="0">Seleccione</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Importe S/. : </td>
                        <td colspan="3"><div id="div_ImporteAfectacion"></div></td>
                    </tr>
                    <tr class="TituloDetalle" style="text-align: center">
                        <td>Mes</td>
                        <td>Mensualizar(DEV)</td>
                        <td>Mes</td>
                        <td>Mensualizar(DEV)</td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Enero : </td>
                        <td><div id="div_EneroAfectacion"></div></td>
                        <td class="inputlabel">Febrero : </td>
                        <td><div id="div_FebreroAfectacion"></div></td> 
                    </tr>
                    <tr>
                        <td class="inputlabel">Marzo : </td>
                        <td><div id="div_MarzoAfectacion"></div></td>
                        <td class="inputlabel">Abril : </td>
                        <td><div id="div_AbrilAfectacion"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Mayo : </td>
                        <td><div id="div_MayoAfectacion"></div></td>
                        <td class="inputlabel">Junio : </td>
                        <td><div id="div_JunioAfectacion"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Julio : </td>
                        <td><div id="div_JulioAfectacion"></div></td>
                        <td class="inputlabel">Agosto : </td>
                        <td><div id="div_AgostoAfectacion"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Setiembre : </td>
                        <td><div id="div_SetiembreAfectacion"></div></td>
                        <td class="inputlabel">Octubre : </td>
                        <td><div id="div_OctubreAfectacion"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Noviembre : </td>
                        <td><div id="div_NoviembreAfectacion"></div></td>
                        <td class="inputlabel">Diciembre : </td>
                        <td><div id="div_DiciembreAfectacion"></div></td>
                    </tr>
                    <tr>
                        <td class="inputlabel">Total : </td>
                        <td colspan="3"><div id="div_TotalAfectacion"></div></td>
                    </tr>
                    <tr>
                        <td class="Summit" colspan="4">
                            <div>
                                <input type="button" id="btn_GuardarDetalleAfectacion" name="btn_GuardarDetalleAfectacion" value="Guardar" style="margin-right: 20px"/>
                                <input type="button" id="btn_CancelarDetalleAfectacion" name="btn_CancelarDetalleAfectacion" value="Cancelar" style="margin-right: 20px"/>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Anular</li> 
        <li type='separator'></li>
        <li style="font-weight: bold; color: navy">Certificado</li>
        <li style="font-weight: bold; color: olive">Registrar Contratos</li>
        <li style="font-weight: bold; color: darkgreen">Afectación PPTAL</li>
    </ul>
</div>
<div style="display: none" id="div_Reporte">
    <div>
        <span style="float: left">LISTADO DE REPORTES</span>
    </div>
    <div style="overflow: hidden">
        <div id='div_LOG0001'>Certificado VS PAC</div>
        <div id='div_LOG0003'>Relación PAC</div>
        <div id='div_LOG0004'>Avance Registro PAC</div>
        <div id='div_LOG0005'>Proyección de Gastos AF-${periodo}</div>
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>