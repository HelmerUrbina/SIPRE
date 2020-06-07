<%-- 
    Document   : ListaPriorizacionPCA
    Created on : 23/11/2017, 03:11:31 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var genericaGasto = $("#cbo_GenericaGasto").val();
    var mode = null;
    var codigo = null;
    var indice = -1;
    var indiceDetalle = -1;
    var fecha = null;
    var lista = new Array();
    <c:forEach var="d" items="${objPriorizacion}">
    var result = {cadenaGasto: '${d.cadenaGasto}', pim: '${d.PIM}', priorizado: '${d.priorizado}', certificado: '${d.certificado}',
        priorizadoCertificado: '${d.priorizado-d.certificado}', saldoPriorizado: '${d.PIM-d.priorizado}', saldoCertificado: '${d.PIM-d.certificado}',
        incremento: '${d.incremento}', disminucion: '${d.disminucion}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA ADICIONAR DETALLE
        var sourceAdiciona = {
            datafields: [
                {name: "solicitud", type: "string"},
                {name: "unidad", type: "string"},
                {name: "sectorista", type: "string"},
                {name: "solicitado", type: "number"},
                {name: "tipo", type: "string"}
            ],
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
        var dataAdiciona = new $.jqx.dataAdapter(sourceAdiciona);
        //PARA LA GRILLA REGISTRO DETALLE
        var sourceRegistro = {
            datafields: [
                {name: "solicitud", type: "string"},
                {name: "unidad", type: "string"},
                {name: "sectorista", type: "string"},
                {name: "solicitado", type: "number"},
                {name: "tipo", type: "string"}
            ],
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
        var dataRegistro = new $.jqx.dataAdapter(sourceRegistro);
        //PARA LA GRILLA DETALLE
        var sourceDetalle = {
            datafields: [
                {name: "codigo", type: "string"},
                {name: "fecha", type: "string"},
                {name: "siaf", type: "string"},
                {name: "estado", type: "string"},
                {name: "incremento", type: "number"},
                {name: "decremento", type: "number"},
                {name: "creado", type: "string"},
                {name: "aprobado", type: "string"}
            ],
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
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: "cadenaGasto", type: "string"},
                        {name: "pim", type: "number"},
                        {name: "priorizado", type: "number"},
                        {name: "certificado", type: "number"},
                        {name: "priorizadoCertificado", type: "number"},
                        {name: "saldoPriorizado", type: "number"},
                        {name: "saldoCertificado", type: "number"},
                        {name: "incremento", type: "number"},
                        {name: "disminucion", type: "number"}
                    ],
            root: "PriorizacionPCA",
            record: "PriorizacionPCA",
            id: 'codigo'
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "pim" || datafield === "siaf") {
                return "RowBold";
            }
            if (datafield === "priorizado" || datafield === "incremento") {
                return "RowBlue";
            }
            if (datafield === "disminucion" || datafield === "decremento") {
                return "RowRed";
            }
            if (datafield === "solicitado" && rowdata['solicitado'] < 0.0) {
                return "RowRed";
            }
            if (datafield === "solicitado" && rowdata['solicitado'] > 0.0) {
                return "RowBold";
            }
            if (datafield === "certificado") {
                return "RowGreen";
            }
            if (datafield === "saldoPriorizado") {
                return "RowPurple";
            }
            if (datafield === "priorizadoCertificado") {
                return "RowBrown";
            }
        };
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 60),
            source: sourceCab,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            editable: false,
            showstatusbar: true,
            showtoolbar: true,
            showaggregates: true,
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonDetalle = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/especifica42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonSubir = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pecosa42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonDetalle);
                container.append(ButtonExportar);
                container.append(ButtonSubir);
                toolbar.append(container);
                ButtonDetalle.jqxButton({width: 30, height: 22});
                ButtonDetalle.jqxTooltip({position: 'bottom', content: "Detalle"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonSubir.jqxButton({width: 30, height: 22});
                ButtonSubir.jqxTooltip({position: 'bottom', content: "Subir Archivos"});
                // Adicionar un Nuevo Registro en la Cabecera.
                ButtonDetalle.click(function (event) {
                    fn_RefrescarDetalle();
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //export to excel
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'PriorizacionPCA');
                });
                ButtonSubir.click(function (event) {
                    $('#div_VentanaSubir').jqxWindow({isModal: true});
                    $('#div_VentanaSubir').jqxWindow('open');
                });
            },
            columns: [
                {
                    text: 'N°', sortable: false, filterable: false, editable: false, align: 'center',
                    groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', pinned: true,
                    cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'CADENA GASTO', dataField: 'cadenaGasto', filtertype: 'checkedlist', width: '25%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'P.I.M.', dataField: 'pim', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PRIORIZADO', dataField: 'priorizado', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CERTIFICADO', dataField: 'certificado', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: '(PRIO-CERT)', dataField: 'priorizadoCertificado', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: '(PIM-PRIO)', dataField: 'saldoPriorizado', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: '(PIM-CERT)', dataField: 'saldoCertificado', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SOLICITADO (+)', dataField: 'incremento', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SOLICITADO (-)', dataField: 'disminucion', width: '9%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            ]
        });
        $("#div_GrillaDetalle").jqxGrid({
            width: '100%',
            height: '565',
            source: dataDetalle,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            sortable: true,
            pageable: true,
            columnsresize: true,
            editable: false,
            showtoolbar: true,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var addButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var editButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/update42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var deleteButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/delete42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var reportButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var checkButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pecosa42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                var refreshButtonDet = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                container.append(addButtonDet);
                container.append(editButtonDet);
                container.append(deleteButtonDet);
                container.append(reportButtonDet);
                container.append(checkButtonDet);
                container.append(refreshButtonDet);
                toolbar.append(container);
                addButtonDet.jqxButton({width: 30, height: 22});
                addButtonDet.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                editButtonDet.jqxButton({width: 30, height: 22});
                editButtonDet.jqxTooltip({position: 'bottom', content: "Editar Registro"});
                deleteButtonDet.jqxButton({width: 30, height: 22});
                deleteButtonDet.jqxTooltip({position: 'bottom', content: "Anular Registro"});
                reportButtonDet.jqxButton({width: 30, height: 22});
                reportButtonDet.jqxTooltip({position: 'bottom', content: "Reporte"});
                checkButtonDet.jqxButton({width: 30, height: 22});
                checkButtonDet.jqxTooltip({position: 'bottom', content: "Aprobar Registro"});
                refreshButtonDet.jqxButton({width: 30, height: 22});
                refreshButtonDet.jqxTooltip({position: 'bottom', content: "Actualizar Datos"});
                // add new row.
                addButtonDet.click(function (event) {
                    mode = 'I';
                    $.ajax({
                        type: "GET",
                        url: "../PriorizacionPCA",
                        data: {mode: 'N', periodo: periodo, presupuesto: presupuesto, genericaGasto: genericaGasto},
                        success: function (data) {
                            $("#txt_Consolidado").val(data);
                            $("#txt_Fecha").val(new Date());
                            $('#div_GrillaRegistro').jqxGrid('clear');
                        }
                    });
                    $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaDetalle').jqxWindow('open');
                });
                editButtonDet.click(function (event) {
                    mode = 'U';
                    if (codigo !== null) {
                        $("#txt_Consolidado").val(codigo);
                        $("#txt_Fecha").val(fecha);
                        $('#div_GrillaRegistro').jqxGrid('clear');
                        $.ajax({
                            type: "GET",
                            url: "../PriorizacionPCA",
                            data: {mode: 'U', periodo: periodo, presupuesto: presupuesto, genericaGasto: genericaGasto, codigo: codigo},
                            success: function (data) {
                                data = data.replace("[", "");
                                var fila = data.split("[");
                                var rows = new Array();
                                for (i = 1; i < fila.length; i++) {
                                    var columna = fila[i];
                                    var datos = columna.split("+++");
                                    while (datos[4].indexOf(']') > 0) {
                                        datos[4] = datos[4].replace("]", "");
                                    }
                                    while (datos[4].indexOf(',') > 0) {
                                        datos[4] = datos[4].replace(",", "");
                                    }
                                    var row = {solicitud: datos[0], unidad: datos[1], sectorista: datos[2], solicitado: parseFloat(datos[3]), tipo: datos[4]};
                                    rows.push(row);
                                }
                                if (rows.length > 0)
                                    $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
                            }
                        });
                        $('#div_VentanaDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $('#div_VentanaDetalle').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Debe Seleccionar un Registro!!',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                });
                // delete selected row.
                deleteButtonDet.click(function (event) {
                    if (codigo !== null) {
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: '¿Desea Anular este Registro?',
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
                                        mode = 'D';
                                        fn_GrabarDatosEstados('');
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
                            content: 'Debe Seleccionar un Registro!!',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                });
                reportButtonDet.click(function (event) {
                    if (codigo !== null) {
                        var url = '../Reportes?reporte=SIAF0001&periodo=' + periodo + '&presupuesto=' + presupuesto + '&codigo=' + codigo;
                        window.open(url, '_blank');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Debe Seleccionar un Registro!!',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                });
                checkButtonDet.click(function (event) {
                    mode = 'A';
                    if (codigo !== null) {
                        $.confirm({
                            theme: 'material',
                            title: 'INGRESE EL NUMERO DE PRIORIZACIÓN SIAF',
                            content: '' +
                                    '<form action="" class="formName">' +
                                    '<div class="form-group">' +
                                    '<input type="text" placeholder="Ingrese el Nro. SIAF" class="siaf form-control" required />' +
                                    '</div>' +
                                    '</form>',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'blue',
                            typeAnimated: true,
                            buttons: {
                                aceptar: {
                                    text: 'Aceptar',
                                    btnClass: 'btn-primary',
                                    keys: ['enter', 'shift'],
                                    action: function () {
                                        var siaf = this.$content.find('.siaf').val();
                                        if (isNaN(siaf)) {
                                            $.alert('Número SIAF invalido!!');
                                            return false;
                                        }
                                        if (!siaf) {
                                            $.alert('Ingrese el Nro. de Nota SIAF!!');
                                            return false;
                                        }
                                        fn_GrabarDatosEstados(siaf);
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
                            content: 'Debe Seleccionar un Registro!!',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                });
                refreshButtonDet.click(function (event) {
                    fn_RefrescarDetalle();
                });
            },
            columns: [
                {text: 'N°', datafield: 'codigo', width: "8%", align: 'center', cellsAlign: 'center'},
                {text: 'FECHA', datafield: 'fecha', width: "13%", align: 'center', cellsAlign: 'center'},
                {text: 'SIAF', datafield: 'siaf', width: "16%", align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ESTADO', datafield: 'estado', width: "14%", align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'SOLICITADO (+)', datafield: 'incremento', width: "20%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'SOLICITADO (-)', datafield: 'decremento', width: "20%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'CREADO POR', datafield: 'creado', width: "25%", align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'APROBADO POR', datafield: 'aprobado', width: "25%", align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        $("#div_GrillaDetalle").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaDetalle").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
            fecha = row['fecha'];
        });
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: '415',
            source: dataRegistro,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            sortable: true,
            pageable: true,
            columnsresize: true,
            editable: false,
            showtoolbar: true,
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
                deleteButtonDet.jqxTooltip({position: 'bottom', content: "Anular Registro"});
                // add new row.
                addButtonDet.click(function (event) {
                    $('#div_GrillaAdiciona').jqxGrid('clear');
                    $.ajax({
                        type: "GET",
                        url: "../PriorizacionPCA",
                        data: {mode: 'B', periodo: periodo, presupuesto: presupuesto, genericaGasto: genericaGasto},
                        success: function (data) {
                            data = data.replace("[", "");
                            var fila = data.split("[");
                            var rows = new Array();
                            for (i = 1; i < fila.length; i++) {
                                var columna = fila[i];
                                var datos = columna.split("+++");
                                while (datos[4].indexOf(']') > 0) {
                                    datos[4] = datos[4].replace("]", "");
                                }
                                while (datos[4].indexOf(',') > 0) {
                                    datos[4] = datos[4].replace(",", "");
                                }
                                var row = {solicitud: datos[0], unidad: datos[1], sectorista: datos[2], solicitado: parseFloat(datos[3]), tipo: datos[4]};
                                rows.push(row);
                            }
                            if (rows.length > 0)
                                $("#div_GrillaAdiciona").jqxGrid('addrow', null, rows);
                        }
                    });
                    $('#div_VentanaDetalleRegistro').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaDetalleRegistro').jqxWindow('open');
                });
                // delete selected row.
                deleteButtonDet.click(function (event) {
                    if (indiceDetalle >= 0) {
                        var rowid = $("#div_GrillaRegistro").jqxGrid('getrowid', indiceDetalle);
                        $("#div_GrillaRegistro").jqxGrid('deleterow', rowid);
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
                {text: 'SOLICITUD', datafield: 'solicitud', width: "15%", align: 'center', cellsAlign: 'center'},
                {text: 'UU/OO', datafield: 'unidad', width: "15%", align: 'center', cellsAlign: 'center'},
                {text: 'SECTORISTA', datafield: 'sectorista', width: "45%", align: 'center', cellsAlign: 'center'},
                {text: 'SOLICITADO', datafield: 'solicitado', width: "25%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass}
            ]
        });
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
        });
        $("#div_GrillaAdiciona").jqxGrid({
            width: '100%',
            height: '325',
            source: dataAdiciona,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            sortable: true,
            pageable: true,
            columnsresize: true,
            editable: false,
            selectionmode: 'checkbox',
            columns: [
                {text: 'SOLICITUD', datafield: 'solicitud', width: "18%", align: 'center', cellsAlign: 'center'},
                {text: 'UU/OO', datafield: 'unidad', width: "15%", align: 'center', cellsAlign: 'center'},
                {text: 'SECTORISTA', datafield: 'sectorista', width: "32%", align: 'center', cellsAlign: 'center'},
                {text: 'SOLICITADO', datafield: 'solicitado', width: "20%", align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'Ver', datafield: 'ver', width: "10%", columntype: 'button', align: 'center', cellsAlign: 'center',
                    cellsrenderer: function () {
                        return 'Ver';
                    }, buttonclick: function (row) {
                        var editrow = row;
                        var dataRecord = $("#div_GrillaAdiciona").jqxGrid('getrowdata', editrow);
                        var url = '../Reportes?reporte=EJE0001&periodo=' + periodo + '&presupuesto=' + presupuesto + '&unidadOperativa=' + (dataRecord.unidad).substring(0, 4) + '&codigo=' + dataRecord.solicitud + '&codigo2=' + dataRecord.solicitud;
                        window.open(url, '_blank');
                    }
                }
            ]
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA PRINCIPAL
                var posicionX, posicionY;
                var ancho = 900;
                var alto = 600;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    initContent: function () {
                    }
                });
                $('#div_VentanaPrincipal').on('close', function (event) {
                    fn_Refrescar();
                });
                //INICIA LOS VALORES DE LA VENTANA DETALLE
                ancho = 800;
                alto = 500;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaDetalle').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_Consolidado").jqxInput({width: 130, height: 20, disabled: true});
                        $("#txt_Fecha").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20, disabled: true});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function (event) {
                            fn_GrabarDatos();
                        });
                    }
                });
                //INICIA LOS VALORES DE LA VENTANA DETALLE REGISTRO
                ancho = 700;
                alto = 400;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaDetalleRegistro').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarDetalle'),
                    initContent: function () {
                        $("#txt_Consolidado").jqxInput({width: 130, height: 20, disabled: true});
                        $("#txt_Fecha").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20, disabled: true});
                        $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').on('click', function (event) {
                            var dataRows = new Array();
                            var rows = $('#div_GrillaAdiciona').jqxGrid('getselectedrowindexes');
                            for (var i = 0; i < rows.length; i++) {
                                var row = $('#div_GrillaAdiciona').jqxGrid('getrowdata', rows[i]);
                                if (fn_validaRegistro(row.solicitud) !== null) {
                                    var data = {solicitud: row.solicitud, unidad: row.unidad, sectorista: row.sectorista, solicitado: parseFloat(row.solicitado), tipo: row.tipo};
                                    dataRows.push(data);
                                }
                            }
                            if (dataRows.length > 0)
                                $("#div_GrillaRegistro").jqxGrid('addrow', null, dataRows);
                            $('#div_VentanaDetalleRegistro').jqxWindow('close');
                        });
                    }
                });
                ancho = 600;
                alto = 120;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaSubir').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarSubir'),
                    initContent: function () {
                        $('#btn_CancelarSubir').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarSubir').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarSubir').on('click', function () {
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
        //FUNCION PARA REFRESCAR LA PANTALLA
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_VentanaDetalleRegistro").remove();
            $("#div_VentanaSubir").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../PriorizacionPCA",
                data: {mode: "G", periodo: periodo, presupuesto: presupuesto, genericaGasto: genericaGasto},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA REFRESCAR EL DETALLE
        function fn_RefrescarDetalle() {
            $('#div_GrillaDetalle').jqxGrid('clear');
            $.ajax({
                type: "GET",
                url: "../PriorizacionPCA",
                data: {mode: 'A', periodo: periodo, presupuesto: presupuesto, genericaGasto: genericaGasto},
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
                        var row = {codigo: datos[0], fecha: datos[1], siaf: datos[2], estado: datos[3], incremento: parseFloat(datos[4]), decremento: parseFloat(datos[5]), creado: datos[6], aprobado: datos[7]};
                        rows.push(row);
                    }
                    if (rows.length > 0)
                        $("#div_GrillaDetalle").jqxGrid('addrow', null, rows);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var msg = "";
            var codigo = $('#txt_Consolidado').val();
            var lista = new Array();
            var result;
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                result = row.uid + "---" + row.unidad.substring(0, 4) + "---" + row.solicitud + "---" + row.tipo;
                lista.push(result);
            }
            if (lista.length === 0)
                msg += "Ingrese el Detalle de la Priorización <br>";
            if (msg === "") {
                $.ajax({
                    type: "POST",
                    url: "../IduPriorizacionPCA",
                    data: {mode: mode, periodo: periodo, presupuesto: presupuesto, genericaGasto: genericaGasto, codigo: codigo, lista: JSON.stringify(lista)},
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
                                            $('#div_VentanaDetalle').jqxWindow('close');
                                            fn_RefrescarDetalle();
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
        //FUNCION PARA GRABAR LOS ESTADOS DE LA PRIORIZACION
        function fn_GrabarDatosEstados(siaf) {
            $.ajax({
                type: "POST",
                url: "../IduPriorizacionPCA",
                data: {mode: mode, periodo: periodo, presupuesto: presupuesto, genericaGasto: genericaGasto, codigo: codigo, siaf: siaf},
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
                                        $('#div_VentanaDetalle').jqxWindow('close');
                                        fn_RefrescarDetalle();
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
        //FUNCION PARA VALIDAR QUE NO SE REPITAN LOS REGISTROS DEL DETALLE
        function fn_validaRegistro(solicitud) {
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (row.solicitud.trim() === solicitud.trim()) {
                    return null;
                }
            }
            return "";
        }
        //FUNCION PARA SUBIR EL ARCHIVO DE PRIORIZACION
        function fn_subirArchivo() {
            var msg = "";
            var priorizacion = $("#txt_Priorizacion").val();
            if (priorizacion === '')
                msg = "Seleccione un Archivo para Subir";
            if (msg === "") {
                var formData = new FormData(document.getElementById("frm_SubirArchivosSIAF"));
                formData.append("mode", "S");
                formData.append("periodo", periodo);
                var $contenidoAjax = $('#div_VentanaSubir').html('<img src="../Imagenes/Fondos/cargando.gif">');
                $.ajax({
                    type: "POST",
                    url: "../IduSubirArchivosSIAF",
                    data: formData,
                    dataType: "html",
                    cache: false,
                    contentType: false,
                    processData: false,
                    success: function (data) {
                        $contenidoAjax.html('');
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
                                            $('#div_VentanaSubir').jqxWindow('close');
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
                    content: msg,
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            }
        }
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">LISTADO DE PRIORIZACIONES DE PCA</span>
    </div>
    <div style="overflow: hidden">
        <div id="div_GrillaDetalle"></div>
    </div>
</div>
<div id="div_VentanaDetalle" style="display: none;">
    <div>
        <span style="float: left">REGISTRO DE PRIORIZACIÓN DE PCA</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_PriorizacionPCA" name="frm_PriorizacionPCA" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Consolidado N° : </td>
                    <td><input type="text" id="txt_Consolidado" name="txt_Consolidado"/></td>
                    <td class="inputlabel">Fecha : </td>
                    <td><div id="txt_Fecha"></div></td>
                </tr> 
                <tr>
                    <td colspan="4"><div id="div_GrillaRegistro"></div></td>
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
            <div id='div_VentanaDetalleRegistro' style='display: none;'>
                <div>
                    <span style="float: left">SELECCIONE LA SOLICITUD DE CREDITO</span>
                </div>
                <div style="overflow: hidden">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td ><div id="div_GrillaAdiciona"></div></td>
                        </tr>
                        <tr>
                            <td class="Summit">
                                <div>
                                    <input type="button" id="btn_GuardarDetalle" value="Adicionar" style="margin-right: 20px"/>
                                    <input type="button" id="btn_CancelarDetalle" value="Cancelar" style="margin-right: 20px"/>
                                </div>
                            </td>
                        </tr>
                    </table> 
                </div>
            </div>
        </form>
    </div>
</div>
<div id="div_VentanaSubir" style="display: none">
    <div>
        <span style="float: left">SUBIR ARCHIVOS</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_SubirArchivosSIAF" name="frm_SubirArchivosSIAF" enctype="multipart/form-data" action="javascript:fn_subirArchivo();" method="post">
            <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                <tr>
                    <td class="inputlabel">Priorización : </td>
                    <td><input type="file" name="txt_Priorizacion" id="txt_Priorizacion" style="text-transform: uppercase; width: 400px;height: 30px" class="form-control"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="Summit" colspan="4">
                        <div>
                            <input type="button" id="btn_GuardarSubir"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarSubir" value="Cancelar" style="margin-right: 20px"/>
                        </div>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
