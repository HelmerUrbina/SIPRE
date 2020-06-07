<%-- 
    Document   : ListaPAAC
    Created on : 03/04/2017, 10:38:46 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnPAAC.periodo}';
    var unidadOperativa = '${objBnPAAC.unidadOperativa}';
    var codigo = '${objBnPAAC.codigo}';
    var mode = null;
    var lista = new Array();
    <c:forEach var="d" items="${objPAAC}">
    var result = {codigo: '${d.codigo}', tipo: '${d.tipo}', numero: '${d.numero}', objeto: '${d.objeto}', fecha: '${d.fecha}',
        certificado: '${d.certificado}', valorReferencial: '${d.valorReferencial}', estado: '${d.estado}', compra: '${d.compra}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA LA GRILLA DE LA CABECERA  
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigo', type: "string"},
                        {name: 'tipo', type: "string"},
                        {name: 'numero', type: "string"},
                        {name: 'objeto', type: "string"},
                        {name: 'fecha', type: "time", format: 'dd/MM/yyyy'},
                        {name: 'certificado', type: "string"},
                        {name: 'valorReferencial', type: "number"},
                        {name: 'estado', type: "string"},
                        {name: 'compra', type: "string"}
                    ],
            root: "PAAC",
            record: "PAAC",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (rowdata['estado'] === "ANULADO") {
                return "RowAnulado";
            }
            if (datafield === "valorReferencial") {
                return "RowBold";
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
            editable: false,
            pagesize: 30,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
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
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    codigo = null;
                    $("#cbo_TipoProceso").jqxDropDownList('setContent', "Seleccione");
                    $("#txt_NumeroProceso").val("");
                    $("#txt_ObjetoProceso").val("");
                    $("#txt_Fecha").val("");
                    $("#txt_Certificado").val("");
                    $("#div_ValorReferencial").val("");
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'PAAC');
                });
                ButtonReporte.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            columns: [
                {text: 'N°', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '30', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'TIPO PROCESO', dataField: 'tipo', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'Nº DE PROCESO/ORDEN/CONTRATO', dataField: 'numero', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'OBJETO', dataField: 'objeto', width: '27%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'FECHA DE EMISION/SUSCRIPCIÓN', dataField: 'fecha', filtertype: 'date', width: '8%', align: 'center', cellsAlign: 'center', cellsformat: 'dd/MM/yyyy', cellclassname: cellclass},
                {text: 'N° CERTIFICADO', dataField: 'certificado', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'VALOR REFERENCIAL', dataField: 'valorReferencial', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'A. COMPRAS', dataField: 'compra', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 80, autoOpenPopup: false, mode: 'popup'});
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
                } else if ($.trim($(opcion).text()) === "Mensualizar") {
                    mode = 'M';
                    fn_MensualizarRegistro();
                }
            }
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 550;
                var alto = 200;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_TipoProceso").jqxDropDownList({width: 350, height: 20, animationType: 'fade', promptText: "Seleccione"});
                        $("#txt_NumeroProceso").jqxInput({placeHolder: "N° DEL PROCESO/ORDEN/CONTRATO", width: 300, height: 20});
                        $("#txt_ObjetoProceso").jqxInput({placeHolder: "OBJETO DEL PROCESO", width: 380, height: 20});
                        $("#txt_Fecha").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 100, height: 20});
                        $("#txt_Certificado").jqxInput({width: 120, height: 20});
                        $("#div_ACompras").jqxCheckBox({width: 120, height: 20});
                        $("#div_ValorReferencial").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            fn_GrabarDatos();
                        });
                    }
                });
                ancho = 420;
                alto = 240;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaSecundaria').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarMensualizar'),
                    initContent: function () {
                        $("#txt_ProcesoMensualizar").jqxInput({width: 320, height: 20, disabled: true});
                        $("#div_Enero").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Febrero").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Marzo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Abril").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Mayo").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Junio").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Julio").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Agosto").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Setiembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Octubre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Noviembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $("#div_Diciembre").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2});
                        $('#btn_CancelarMensualizar').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarMensualizar').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarMensualizar').on('click', function () {                            
                            var msg = validaTotal();
                            if (msg === '') {
                                fn_GrabarDatosMensualizar();
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
                ancho = 400;
                alto = 105;
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
                        $("#div_LOG0002").jqxRadioButton({width: 200, height: 20});
                        $('#div_LOG0002').on('checked', function (event) {
                            reporte = 'LOG0002';
                        });
                        $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').on('click', function (event) {
                            var msg = "";
                            switch (reporte) {
                                case "LOG0001":
                                    break;
                                case "LOG0002":
                                    break;
                                default:
                                    msg += "Debe selecciona una opción.<br>";
                                    break;
                            }
                            if (msg === "") {
                                var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&unidadOperativa=' + unidadOperativa;
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
            fn_cargarComboAjax("#cbo_TipoProceso", {mode: 'tipoProceso'});
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_Reporte").remove();
            $("#div_VentanaSecundaria").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../PAAC",
                data: {mode: 'G', periodo: periodo, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../PAAC",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 7) {
                        $("#cbo_TipoProceso").jqxDropDownList('selectItem', dato[0]);
                        $("#txt_NumeroProceso").val(dato[1]);
                        $("#txt_ObjetoProceso").val(dato[2]);
                        $("#txt_Fecha").val(dato[3]);
                        $("#txt_Certificado").val(dato[4]);
                        $("#div_ValorReferencial").val(dato[5]);
                        $("#div_ACompras").val(parseInt(dato[6]));
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA CARGAR VENTANA PARA MENSUALIZAR REGISTRO
        function fn_MensualizarRegistro() {
            $.ajax({
                type: "GET",
                url: "../PAAC",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 14) {
                        $("#txt_ProcesoMensualizar").val(dato[0]);
                        $("#div_ValorReferencial").val(dato[1]);
                        $("#div_Enero").val(dato[2]);
                        $("#div_Febrero").val(dato[3]);
                        $("#div_Marzo").val(dato[4]);
                        $("#div_Abril").val(dato[5]);
                        $("#div_Mayo").val(dato[6]);
                        $("#div_Junio").val(dato[7]);
                        $("#div_Julio").val(dato[8]);
                        $("#div_Agosto").val(dato[9]);
                        $("#div_Setiembre").val(dato[10]);
                        $("#div_Octubre").val(dato[11]);
                        $("#div_Noviembre").val(dato[12]);
                        $("#div_Diciembre").val(dato[13]);
                    }
                }
            });
            $('#div_VentanaSecundaria').jqxWindow({isModal: true});
            $('#div_VentanaSecundaria').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var tipoProceso = $("#cbo_TipoProceso").val();
            var numeroProceso = $("#txt_NumeroProceso").val();
            var objetoProceso = $("#txt_ObjetoProceso").val();
            var fecha = $("#txt_Fecha").val();
            var certificado = $("#txt_Certificado").val();
            var valorReferencial = $("#div_ValorReferencial").val();
            var compras = $("#div_ACompras").val();
            if (compras)
                compras = 1;
            else
                compras = 0;
            $.ajax({
                type: "POST",
                url: "../IduPAAC",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo, tipoProceso: tipoProceso, fecha: fecha,
                    numeroProceso: numeroProceso, objetoProceso: objetoProceso, certificado: certificado, valorReferencial: valorReferencial, compras: compras},
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
        function fn_GrabarDatosMensualizar() {
            var enero = $("#div_Enero").val();
            var febrero = $("#div_Febrero").val();
            var marzo = $("#div_Marzo").val();
            var abril = $("#div_Abril").val();
            var mayo = $("#div_Mayo").val();
            var junio = $("#div_Junio").val();
            var julio = $("#div_Julio").val();
            var agosto = $("#div_Agosto").val();
            var setiembre = $("#div_Setiembre").val();
            var octubre = $("#div_Octubre").val();
            var noviembre = $("#div_Noviembre").val();
            var diciembre = $("#div_Diciembre").val();
            $.ajax({
                type: "POST",
                url: "../IduPAAC",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo, enero: enero, febrero: febrero,
                    marzo: marzo, abril: abril, mayo: mayo, junio: junio, julio: julio, agosto: agosto, setiembre: setiembre,
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
                                        $('#div_VentanaSecundaria').jqxWindow('close');
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
    });
    function validaTotal() {
        var total = parseFloat($("#div_Enero").val()) + parseFloat($("#div_Febrero").val()) + parseFloat($("#div_Marzo").val()) + parseFloat($("#div_Abril").val()) +
                parseFloat($("#div_Mayo").val()) + parseFloat($("#div_Junio").val()) + parseFloat($("#div_Julio").val()) + parseFloat($("#div_Agosto").val()) +
                parseFloat($("#div_Setiembre").val()) + parseFloat($("#div_Octubre").val()) + parseFloat($("#div_Noviembre").val()) + parseFloat($("#div_Diciembre").val());
        var valorReferencial = parseFloat($("#div_ValorReferencial").val());
        if (total === valorReferencial) {
            return "";
        } else {
            return 'FALTA MENSUALIZAR:' + parseFloat(valorReferencial - total) + ' , REVISE!!';
        }
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">PROGRAMACIÓN ANUAL DE ADQUISICIONES Y CONTRATACIONES</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_PAAC" name="frm_PAAC" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">                
                <tr>
                    <td class="inputlabel">Tipo Proceso : </td>
                    <td colspan="2">
                        <select id="cbo_TipoProceso" name="cbo_TipoProceso">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>                    
                </tr>
                <tr>
                    <td class="inputlabel">N° Proceso/Contrato : </td>
                    <td colspan="2"><input type="text" id="txt_NumeroProceso" name="txt_NumeroProceso" style="text-transform: uppercase;"/></td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Objeto : </td>
                    <td colspan="2"><input type="text" id="txt_ObjetoProceso" name="txt_ObjetoProceso" style="text-transform: uppercase;"/></td>                    
                </tr>    
                <tr>
                    <td class="inputlabel">Fecha : </td>
                    <td colspan="2"><div id="txt_Fecha"></div>
                </tr>                
                <tr>
                    <td class="inputlabel">N° Certificado : </td>
                    <td><input type="text" id="txt_Certificado" name="txt_Certificado"/></td> 
                    <td><div id='div_ACompras'>A. Compras</div></td> 
                </tr>
                <tr>
                    <td class="inputlabel">Valor Ref. : </td>
                    <td><div id="div_ValorReferencial"></div></td> 
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
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Anular</li>  
        <li>Mensualizar</li>  
    </ul>
</div>
<div id="cbo_Ajax" style='display: none;'></div>
<div id="div_VentanaSecundaria" style="display: none">
    <div>
        <span style="float: left">MENSUALIZAR PROCESO</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_PAAC_Mensualizado" name="frm_PAAC_Mensualizado" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Proceso : </td>
                    <td colspan="3"><input type="text" id="txt_ProcesoMensualizar" name="txt_ProcesoMensualizar" style="text-transform: uppercase;"/></td>                    
                </tr>                
                <tr>                    
                    <td colspan="4" class="TituloFocus">Mensualizar Proceso</td>
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
                    <td class="Summit" colspan="4">
                        <div>
                            <input type="button" id="btn_GuardarMensualizar"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarMensualizar" value="Cancelar" style="margin-right: 20px"/>                            
                        </div>
                    </td>
                </tr>
            </table>  
        </form>
    </div>
</div>
<div style="display: none" id="div_Reporte">
    <div>
        <span style="float: left">LISTADO DE REPORTES</span>
    </div>
    <div style="overflow: hidden">
        <div id='div_LOG0001'>Certificado VS PAAC</div>
        <div id='div_LOG0002'>Relación PAAC </div>        
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>