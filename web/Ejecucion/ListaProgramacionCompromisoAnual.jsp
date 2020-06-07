<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var presupuesto = $("#cbo_Presupuesto").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var codigo = null;
    var evento = null;
    var mode = null;
    var tarea = null;
    var indiceDetalle = -1;
    var msg = "";
    var lista = new Array();
    <c:forEach var="c" items="${objPCA}">
    var result = {dependencia: '${c.dependencia}', tareaPresupuestal: '${c.tareaPresupuestal}', cadenaGasto: '${c.cadenaGasto}',
        secuenciaFuncional: '${c.secuenciaFuncional}',
        pia: '${c.PIA}', pim: '${c.PIM}', pca: '${c.PCA}', certificado: '${c.certificado}', solicitud: '${c.solicitud}', nota: '${c.nota}',
        saldo: '${c.saldo}', genericaGasto: '${c.genericaGasto}', resolucion: '${c.resolucion}',
        programa: '${c.categoriaPresupuestal}', producto: '${c.producto}', actividad: '${c.actividad}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA CABECERA
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'dependencia', type: "string"},
                        {name: 'cadenaGasto', type: "string"},
                        {name: 'tareaPresupuestal', type: "string"},
                        {name: 'secuenciaFuncional', type: "string"},
                        {name: 'pia', type: "number"},
                        {name: 'pim', type: "number"},
                        {name: 'pca', type: "number"},
                        {name: 'certificado', type: "number"},
                        {name: 'solicitud', type: "number"},
                        {name: 'nota', type: "number"},
                        {name: 'saldo', type: "number"},
                        {name: 'tipoCalendario', type: "string"},
                        {name: 'genericaGasto', type: "string"},
                        {name: 'resolucion', type: "string"},
                        {name: 'programa', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'actividad', type: "string"}
                    ],
            root: "PCA",
            record: "PCA",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(sourceCab);
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA DETALLE 
        var sourceDet = {
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "resolucion", type: "string"},
                        {name: "dependencia", type: "string"},
                        {name: "secuenciaFuncional", type: "string"},
                        {name: "tareaPresupuestal", type: "string"},
                        {name: "cadenaGasto", type: "string"},
                        {name: "pim", type: "number"},
                        {name: "pca", type: "number"},
                        {name: "disponible", type: "number"},
                        {name: "anulacion", type: "number"},
                        {name: "credito", type: "number"}
                    ],
            updaterow: function (rowid, rowdata, commit) {
                //condición ? expr1 : expr2  undefined
                var pim = parseFloat(rowdata['pim']);
                var pca = parseFloat(rowdata['pca']);
                var disponible = parseFloat(rowdata['disponible']);
                var anulacion = (isNaN(rowdata['anulacion'])) ? parseFloat(0) : parseFloat(rowdata['anulacion']);
                var credito = (isNaN(rowdata['credito'])) ? parseFloat(0) : parseFloat(rowdata['credito']);
                var msg = "";
                if (parseFloat(anulacion) !== 0 && parseFloat(credito) !== 0)
                    msg = "Solo debe ingresar la Anulación o Credito. Revise!!";
                if (parseFloat(anulacion) > Math.abs(parseFloat(disponible)) || parseFloat(credito) > Math.abs(parseFloat(disponible)))
                    msg = "Monto ingresado supera el Monto Disponible. Revise!!";
                if (parseFloat(anulacion) !== 0) {
                    if (parseFloat(disponible) > 0)
                        msg += "Monto no permitido!!";
                }
                if (parseFloat(credito) !== 0) {
                    if (parseFloat(credito) > (parseFloat(pim) - parseFloat(pca)))
                        msg += "Monto no permitido!!.";
                }
                if (msg !== "") {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: msg,
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                    commit(false);
                } else {
                    commit(true);
                }
            }
        };
        var dataVariacion = new $.jqx.dataAdapter(sourceDet);
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "pia" || datafield === "pca") {
                return "RowBold";
            }
            if (datafield === "pim") {
                return "RowBlue";
            }
            if (datafield === "saldoPCA") {
                return "RowRed";
            }
            if (datafield === "anual") {
                return "RowGreen";
            }
            if (datafield === "compromiso") {
                return "RowDarkBlue";
            }
            if (datafield === "mensual") {
                return "RowPurple";
            }
            if (datafield === "saldoAnual" || datafield === "saldoCompromiso" || datafield === "saldoMensual") {
                return "RowBrown";
            }
        };
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
            editable: false,
            showstatusbar: true,
            showtoolbar: true,
            showaggregates: true,
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonDetalle = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/especifica42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var reporteButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonDetalle);
                container.append(ButtonExportar);
                container.append(reporteButton);
                toolbar.append(container);
                ButtonDetalle.jqxButton({width: 30, height: 22});
                ButtonDetalle.jqxTooltip({position: 'bottom', content: "Detalle"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                reporteButton.jqxButton({width: 30, height: 22});
                reporteButton.jqxTooltip({position: 'bottom', content: "Reportes"});
                ButtonDetalle.click(function (event) {
                    fn_CargarVariacionPCA();
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'CalendarioGastos');
                });
                reporteButton.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            columns: [
                {text: 'DEPENDENCIA', dataField: 'dependencia', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'TAREA', dataField: 'tareaPresupuestal', filtertype: 'checkedlist', width: '12%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'CADENA GASTO', dataField: 'cadenaGasto', filtertype: 'checkedlist', width: '18%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'PIA', dataField: 'pia', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PIM', dataField: 'pim', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PCA', dataField: 'pca', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'CERTIF', dataField: 'certificado', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SOL. CRED.', dataField: 'solicitud', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'NOTA MODIF.', dataField: 'nota', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SALDO PCA.', dataField: 'saldo', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'SECUENCIA FUNCIONAL', dataField: 'secuenciaFuncional', filtertype: 'checkedlist', width: '22%', align: 'center', cellclassname: cellclass},
                {text: 'GENERICA GASTO', dataField: 'genericaGasto', filtertype: 'checkedlist', width: '10%', align: 'center', cellclassname: cellclass},
                {text: 'RESOLUCION', dataField: 'resolucion', filtertype: 'checkedlist', width: '10%', align: 'center', cellclassname: cellclass},
                {text: 'CAT. PPTAL.', dataField: 'programa', filtertype: 'checkedlist', width: '15%', align: 'center', cellclassname: cellclass},
                {text: 'PRODUCTO', dataField: 'producto', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass},
                {text: 'ACTIVIDAD', dataField: 'actividad', filtertype: 'checkedlist', width: '20%', align: 'center', cellclassname: cellclass}
            ]
        });
        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
            tarea = row['tarea'];
        });
        //EVENTOS GRILLA DETALLE
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: 455,
            source: dataVariacion,
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
                {text: 'DEPENDENCIA', datafield: 'dependencia', editable: false, width: '8%', align: 'center'},
                {text: 'TAREA', datafield: 'tareaPresupuestal', editable: false, width: '14%', align: 'center'},
                {text: 'CADENA GASTO', datafield: 'cadenaGasto', editable: false, width: '18%', align: 'center', aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'PIM', datafield: 'pim', editable: false, width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'PCA', dataField: 'pca', editable: false, width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'DISPONIBLE', dataField: 'disponible', editable: false, width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ANULACIÓN', dataField: 'anulacion', editable: true, width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum'], columntype: 'numberinput',
                    validation: function (cell, value) {
                        if (value < 0 || value > 999999999999) {
                            return {result: false, message: "El importe debe estar en el intervalo de 0 a 999,999,999,999.00"};
                        }
                        return true;
                    },
                    createeditor: function (row, cellvalue, editor) {
                        editor.jqxNumberInput({decimalDigits: 2, digits: 15});
                    }},
                {text: 'CREDITO', dataField: 'credito', editable: true, width: '12%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum'], columntype: 'numberinput',
                    validation: function (cell, value) {
                        if (value < 0 || value > 999999999999) {
                            return {result: false, message: "El importe debe estar en el intervalo de 0 a 999,999,999,999.00"};
                        }
                        return true;
                    },
                    createeditor: function (row, cellvalue, editor) {
                        editor.jqxNumberInput({decimalDigits: 2, digits: 15});
                    }},
                {text: 'SEC. FUNC.', datafield: 'secuenciaFuncional', editable: false, width: '35%', align: 'center'},
                {text: 'RESOLUCIÓN', datafield: 'resolucion', editable: false, width: '15%', align: 'center'}
            ]
        });
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 950;
                var alto = 550;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_DocumentoReferencia").jqxInput({placeHolder: "Ingrese Documento de Referencia", width: 650, height: 20, minLength: 1});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            fn_GrabarDatos();
                        });
                    }
                });
                ancho = 400;
                alto = 165;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_Reporte').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CerrarImprimir'),
                    initContent: function () {
                        $("#div_EJE0001").jqxRadioButton({width: 200, height: 20});
                        $('#div_EJE0001').on('checked', function (event) {
                            reporte = 'EJE0015';
                        });
                        $("#div_EJE0002").jqxRadioButton({width: 200, height: 20});
                        $('#div_EJE0002').on('checked', function (event) {
                            reporte = 'EJE0016';
                        });
                        $("#div_EJE0003").jqxRadioButton({width: 200, height: 20});
                        $('#div_EJE0003').on('checked', function (event) {
                            reporte = 'EJE0017';
                        });
                        $("#div_EJE0004").jqxRadioButton({width: 200, height: 20});
                        $('#div_EJE0004').on('checked', function (event) {
                            reporte = 'EJE0018';
                        });
                        $("#div_EJE0013").jqxRadioButton({width: 200, height: 20});
                        $('#div_EJE0013').on('checked', function (event) {
                            reporte = 'EJE0013';
                        });
                        $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').on('click', function (event) {
                            var msg = "";
                            switch (reporte) {
                                case "EJE0013":
                                    break;
                                case "EJE0015":
                                    break;
                                case "EJE0016":
                                    break;
                                case "EJE0017":
                                    break;
                                case "EJE0018":
                                    break;
                                default:
                                    msg += "Debe selecciona una opción.<br>";
                                    break;
                            }
                            if (msg === "") {
                                var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa + '&presupuesto=' + presupuesto;
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
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../CalendarioGastos",
                data: {mode: "G", periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_CargarVariacionPCA() {
            $('#div_GrillaRegistro').jqxGrid('clear');
            $.ajax({
                type: "GET",
                url: "../ProgramacionCompromisoAnual",
                data: {mode: 'V', periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa},
                success: function (data) {
                    data = data.replace("[", "");
                    var fila = data.split("[");
                    var rows = new Array();
                    for (i = 1; i < fila.length; i++) {
                        var columna = fila[i];
                        var datos = columna.split("+++");
                        while (datos[8].indexOf(']') > 0) {
                            datos[8] = datos[8].replace("]", "");
                        }
                        while (datos[8].indexOf(',') > 0) {
                            datos[8] = datos[8].replace(",", "");
                        }
                        var row = {codigo: datos[0], dependencia: datos[1], resolucion: datos[2], secuenciaFuncional: datos[3], tareaPresupuestal: datos[4],
                            cadenaGasto: datos[5], pim: parseFloat(datos[6]), pca: parseFloat(datos[7]), disponible: parseFloat(datos[8])};
                        rows.push(row);
                    }
                    if (rows.length > 0)
                        $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var msg = "";
            var lista = new Array();
            var result;
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (row.modifica === 'Y') {
                    result = row.uid + "---" + fn_extraerDatos(row.dependencia, ':') + "---" + fn_extraerDatos(row.cadenaGasto, ':') +
                            "---" + parseFloat(row.enero) + "---" + parseFloat(row.febrero) + "---" + parseFloat(row.marzo) + "---" + parseFloat(row.abril) +
                            "---" + parseFloat(row.mayo) + "---" + parseFloat(row.junio) + "---" + parseFloat(row.julio) + "---" + parseFloat(row.agosto) +
                            "---" + parseFloat(row.setiembre) + "---" + parseFloat(row.octubre) + "---" + parseFloat(row.noviembre) + "---" + parseFloat(row.diciembre) + "---" + parseFloat(row.importe);
                    lista.push(result);
                }
            }
            if (lista.length === 0)
                msg += "No se ha realizado ninguna modificación <br>";
            if (msg === "") {
                $.ajax({
                    type: "POST",
                    url: "../IduCalendarioGastos",
                    data: {mode: mode, periodo: periodo, presupuesto: presupuesto, unidadOperativa: unidadOperativa, codigo: codigo, lista: JSON.stringify(lista)},
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
                    content: msg,
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            }
        }
    });
    //FUNCION PARA VALIDAR EL TOTAL DE CREDITO Y NO GENERE SALDO NEGATIVO
    function fn_TotalMensualizacion() {
        var total = $("#div_Enero").val() + $("#div_Febrero").val() + $("#div_Marzo").val() + $("#div_Abril").val() + $("#div_Mayo").val() + $("#div_Junio").val() +
                $("#div_Julio").val() + $("#div_Agosto").val() + $("#div_Setiembre").val() + $("#div_Octubre").val() + $("#div_Noviembre").val() + $("#div_Diciembre").val();
        $("#div_Total").val(parseFloat(total));
        if (parseFloat(total) > parseFloat($("#div_Importe").val())) {
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
        <span style="float: left">PROGRAMACIÓN DE COMPROMISO ANUAL</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_CalendarioGastos" name="frm_CalendarioGastos" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Documento : </td>
                    <td><input type="text" id="txt_DocumentoReferencia" name="txt_DocumentoReferencia" style="text-transform: uppercase;"/></td> 
                </tr> 
                <tr>
                    <td colspan="2"><div id="div_GrillaRegistro"></div>  </td>
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
<div id="div_Reporte" style="display: none;">
    <div>
        <span style="float: left">LISTADO DE REPORTES</span>
    </div>
    <div style="overflow: hidden">
        <div id='div_EJE0001'>Calendario de Gastos</div>
        <div id='div_EJE0002'>Calendario de Gastos - Dependencias</div>
        <div id='div_EJE0003'>Listado de Notas Modificatorias</div>
        <div id='div_EJE0004'>Avance de Ejecución Presupuestal</div>
        <div id='div_EJE0013'>Listado de Informes de Disponibilidad Presupuestal</div>
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>