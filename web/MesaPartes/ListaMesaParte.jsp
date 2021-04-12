<%-- 
    Document   : ListaMesaParteSalida
    Created on : 17/07/2017, 03:00:26 PM
    Author     : H-TECCSI-V
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var tipo = $("#cbo_Tipo").val();
    var mes = $("#cbo_Mes").val();
    var FechaBus = $("#div_diaBus").val();
    var codigo = null;
    var archivo = null;
    var codigoUsuario = '';
    var codInstitucion = '';
    var docReferencia = '';
    var estado = '';
    var mode = null;
    var msg = '';
    var lista = new Array();
    <c:forEach var="d" items="${objMesaParte}">
    var result = {numero: '${d.numero}', numeroDocumento: '${d.numeroDocumento}', asunto: '${d.asunto}',
        subGrupo: '${d.subGrupo}', prioridad: '${d.prioridad}', fecha: '${d.fecha}', estado: '${d.estado}', firma: '${d.hora}',
        legajo: '${d.legajo}', folio: '${d.folio}', usuarioResponsable: '${d.usuarioResponsable}', referencia: "${d.referencia}",
        codigoUsuario: '${d.area}', archivo: '${d.archivo}', correo: '${d.correo}'};
    lista.push(result);
    </c:forEach>
    var listaInstitucion = new Array();
    var rows = '${objInstitucion}';
    <c:forEach var="c" items="${objInstitucion}">
        <c:set value="${c.descripcion}" var="descripcion"></c:set>
        <c:set value="${c.codigo}" var="codigo"></c:set>
    var result = {label: "${descripcion}", value: "${codigo}"};
    listaInstitucion.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA INSTITUCION
        var sourceInstitucion = {
            datafields: [{name: 'label'}, {name: 'value'}],
            localdata: listaInstitucion
        };
        var dataAdapterInstitucion = new $.jqx.dataAdapter(sourceInstitucion);
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
                        {name: 'fecha', type: "String"},
                        {name: 'estado', type: "string"},
                        {name: 'firma', type: "string"},
                        {name: 'legajo', type: "number"},
                        {name: 'folio', type: "string"},
                        {name: 'usuarioResponsable', type: "string"},
                        {name: 'referencia', type: "string"},
                        {name: 'codigoUsuario', type: "string"},
                        {name: 'archivo', type: "string"},
                        {name: 'correo', type: "string"}
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
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reporte Diario"});
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    codigo = 0;
                    fn_NuevoRegistro();
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'MesaParte' + tipo);
                });
                ButtonReporte.click(function (event) {
                    $('#div_Reporte').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_Reporte').jqxWindow('open');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: 10, pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'CÓDIGO', dataField: 'numero', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'NRO DOCUMENTO', dataField: 'numeroDocumento', width: '8%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ASUNTO', dataField: 'asunto', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DEPENDENCIA', dataField: 'subGrupo', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'PRIORIDAD', dataField: 'prioridad', filtertype: 'checkedlist', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FEC. DOC', dataField: 'fecha', columntype: 'datetimeinput', filtertype: 'date', width: '8%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '9%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FIRMA', dataField: 'firma', width: '8%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'LEGAJO', dataField: 'legajo', width: '4%', align: 'center', cellsAlign: 'center', cellsFormat: 'f', cellclassname: cellclass},
                {text: 'FOLIO', dataField: 'folio', width: '4%', align: 'center', cellsAlign: 'center', cellsFormat: 'f', cellclassname: cellclass},
                {text: 'USUARIO RESP.', dataField: 'usuarioResponsable', filtertype: 'checkedlist', width: '9%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'REFERENCIA', dataField: 'referencia', width: '9%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ARCHIVO', dataField: 'archivo', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'CORREO', dataField: 'correo', width: '20%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL 
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 110, autoOpenPopup: false, mode: 'popup'});
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
            if ($.trim($(opcion).text()) === "Editar") {
                if (estado !== "PENDIENTE") {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'El registro no puede ser editado, se encuentra ' + estado,
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                } else {
                    mode = 'U';
                    fn_EditarRegistro();
                }
            } else if ($.trim($(opcion).text()) === "Anular") {
                if (tipo === 'S') {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'El documento no puede ser anulado',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                } else {
                    if (estado !== "PENDIENTE") {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'El registro no puede ser editado, se encuentra ' + estado,
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    } else {
                        if (codigo !== null || codigo === '') {
                            mode = 'D';
                            fn_AnularDocumento();
                        } else {
                            $.alert({
                                theme: 'material',
                                title: 'AVISO DEL SISTEMA',
                                content: 'Debe Seleccionar un Registro',
                                animation: 'zoom',
                                closeAnimation: 'zoom',
                                type: 'red',
                                typeAnimated: true
                            });
                        }
                    }
                }
            } else if ($.trim($(opcion).text()) === "Ver Documento") {
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
            } else if ($.trim($(opcion).text()) === "Adjuntar Documento") {
                if (tipo === 'S') {
                    mode = 'C';
                    fn_AdjuntarArchivo();
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'Opción no permitida para el ingreso de documentos',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'orange',
                        typeAnimated: true
                    });
                }
            } else {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: "No hay Opción a mostrar",
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
            }
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['numero'];
            estado = row['estado'];
            archivo = row['archivo'];
            codigoUsuario = row['codigoUsuario'];
            docReferencia = row['referencia'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 395;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_Numero").jqxInput({width: 120, height: 20, disabled: true});
                        $("#txt_Institucion").jqxInput({width: 300, height: 20});
                        $("#txt_Institucion").jqxInput({height: 20, width: 400, minLength: 1, items: 15, source: dataAdapterInstitucion});
                        $('#txt_Institucion').on('select', function (event) {
                            if (event.args) {
                                var item = event.args.item;
                                if (item) {
                                    codInstitucion = item.value;
                                }
                            }
                        });
                        $("#cbo_Prioridad").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                        $("#cbo_TipoDocumento").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                        $("#txt_NumeroDocumento").jqxInput({width: 120, height: 20});
                        $("#cbo_Clasificacion").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                        $("#txt_FechaDocumento").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#txt_FechaRecepcion").jqxInput({width: 150, height: 20, disabled: true});
                        $("#txt_Asunto").jqxInput({placeHolder: "Ingrese el asunto", width: 450, height: 20});
                        $("#txt_Observacion").jqxInput({placeHolder: "Ingrese la Observación", width: 450, height: 20});
                        $("#txt_PostFirma").jqxInput({placeHolder: "Ingrese la Post Firma", width: 450, height: 20});
                        $("#div_Legajos").jqxNumberInput({width: 50, height: 20, max: 99, digits: 2, decimalDigits: 0});
                        $("#div_Folios").jqxNumberInput({width: 50, height: 20, max: 99, digits: 2, decimalDigits: 0});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            var msg = "";
                            if (msg === "")
                                msg = fn_verificarPrioridad();
                            if (msg === "")
                                msg = fn_verificarTipoDocumento();
                            if (msg === "")
                                msg = fn_verificarClasificacion();
                            if (msg === "")
                                msg = fn_verificarInstitucion();
                            if (msg === "")
                                msg = fn_verificarFolio();
                            if (msg === "") {
                                $('#frm_MesaParte').jqxValidator('validate');
                            }
                        });
                        $('#frm_MesaParte').jqxValidator({
                            rules: [
                                {input: '#txt_Institucion', message: 'Ingrese el nombre de la institución', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_NumeroDocumento', message: 'Ingrese el Numero de Documento!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Asunto', message: 'Ingrese el Asunto!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_FechaDocumento', message: 'Ingrese la fecha de documento', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_FechaRecepcion', message: 'Ingrese la fecha de recepción!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_FechaDocumento', message: 'Ingrese una fecha valida de documento', action: 'valueChanged',
                                    rule: function (input, commit) {
                                        var date = $('#txt_FechaDocumento').jqxDateTimeInput('value');
                                        var result = date.getFullYear() >= 2015 && date.getFullYear() <= 2030;
                                        return result;
                                    }
                                },
                                {input: '#txt_PostFirma', message: 'Ingrese la firma!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_MesaParte').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatos();
                            }
                        });
                    }
                });
                ancho = 400;
                alto = 100;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_Reporte').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CerrarImprimir'),
                    initContent: function () {
                        $("#div_MPA0001").jqxRadioButton({width: 200, height: 20});
                        $('#div_MPA0001').on('checked', function (event) {
                            reporte = 'MPA0001';
                        });
                        $("#div_MPA0002").jqxRadioButton({width: 200, height: 20});
                        $('#div_MPA0002').on('checked', function (event) {
                            reporte = 'MPA0002';
                        });
                        $('#btn_CerrarImprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').jqxButton({width: '65px', height: 25});
                        $('#btn_Imprimir').on('click', function (event) {
                            var msg = "";
                            switch (reporte) {
                                case "MPA0001":
                                    codigo = FechaBus + "/" + mes + "/" + periodo;
                                    break;
                                case "MPA0002":
                                    codigo = mes;
                                    break;
                                default:
                                    msg += "Debe selecciona una opción.<br>";
                                    break;
                            }
                            if (msg === "") {
                                var url = '../Reportes?reporte=' + reporte + '&periodo=' + periodo + '&tipo=' + tipo + '&codigo=' + codigo;
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
                //VENTANA DE DETALLE DE ANULACION
                ancho = 500;
                alto = 175;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_DetalleAnulacion').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarAnulacion'),
                    initContent: function () {
                        $("#txt_ComentarioAnulacion").jqxInput({placeHolder: 'Ingrese detalle de anulación', height: 90, width: 400, maxLength: 500, minLength: 1});
                        $("#txt_ComentarioAnulacion").val("");
                        $('#btn_CancelarAnulacion').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarAnulacion').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarAnulacion').on('click', function (event) {
                            var msg = "";
                            if (msg === "") {
                                $('#frm_AnulacionDocumento').jqxValidator('validate');
                            }
                        });
                        $('#frm_AnulacionDocumento').jqxValidator({
                            rules: [
                                {input: '#txt_ComentarioAnulacion', message: 'Ingrese el detalle de la anulación', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_ComentarioAnulacion', message: 'Ingrese sustento de la anulación', action: 'keyup', rule: 'length=5,500'}
                            ]
                        });
                        $('#frm_AnulacionDocumento').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatosAnulacion();
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
        //FUNCION PARA ABRIR VENTANA DE ANULACION
        function fn_AnularDocumento() {
            $("#txt_ComentarioAnulacion").val('');
            $("#txt_ComentarioAnulacion").jqxInput('focus');
            $('#div_DetalleAnulacion').jqxWindow({isModal: true});
            $('#div_DetalleAnulacion').jqxWindow('open');
        }
        //FUNCION PARA VERIFICAR LA PRIORIDAD
        function fn_verificarPrioridad() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_Prioridad").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione la prioridad";
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: msg,
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
                return "ERROR";
            } else {
                return "";
            }
        }
        //FUNCION PARA VERIFICAR EL TIPO DE DOCUMENTO
        function fn_verificarTipoDocumento() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_TipoDocumento").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el tipo de documento";
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: msg,
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
                return "ERROR";
            } else {
                return "";
            }
        }
        //FUNCION PARA VERIFICAR LA CLASIFICACION
        function fn_verificarClasificacion() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_Clasificacion").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione la clasificacion del documento";
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: msg,
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
                return "ERROR";
            } else {
                return "";
            }
        }
        //FUNCION PARA VERIFICAR INSTITUCION
        function fn_verificarInstitucion() {
            var msg = "";
            var dato = "";
            dato = codInstitucion;
            if (dato === "" || (dato.trim()).length === 0 || dato === null) {
                msg = "Ingrese el nombre de la Institucion";
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: msg,
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
                return "ERROR";
            } else {
                return "";
            }
        }
        //FUNCION PARA VERIFICAR FOLIO
        function fn_verificarFolio() {
            var msg = "";
            var dato = "";
            dato = $("#div_Folios").val();
            if (dato === 0) {
                msg = "Ingrese la cantidad de folios";
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: msg,
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
                return "ERROR";
            } else {
                return "";
            }
        }
        //FUNCION PARA ADJUNTAR ARCHIVO
        function fn_AdjuntarArchivo() {
            $.confirm({
                title: 'ADJUNTAR DOCUMENTO',
                type: 'blue',
                content: '' +
                        '<form method="post"  name="frm_AdjuntarDocumento" id="frm_AdjuntarDocumento" action="../IduMesaParte" enctype="multipart/form-data">' +
                        '<label>Documento : </label>' +
                        '<input type="file" name="fichero" id="fichero" style="text-transform: uppercase; width= 600px" class="name form-control" multiple/>' +
                        '</form>',
                buttons: {
                    formSubmit: {
                        text: 'Enviar',
                        btnClass: 'btn-blue',
                        action: function () {
                            fn_GuardarDocumento();
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
        }
        //FUNCION PARA GRABAR EL DETALLE DE LA ANULACION DEL DOCUMENTO
        function fn_GrabarDatosAnulacion() {
            var comentarioAnulacion = $("#txt_ComentarioAnulacion").val();
            var fechaDocumento = '01/01/2018';
            var fechaRecepcion = '01/01/2018';
            $.ajax({
                type: "POST",
                url: "../IduMesaParte",
                data: {mode: mode, periodo: periodo, numero: codigo, observacion: comentarioAnulacion,
                    fechaDocumento: fechaDocumento, fechaRecepcion: fechaRecepcion, tipo: tipo},
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
                                        $('#div_DetalleAnulacion').jqxWindow('close');
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
        //FUNCION PARA ADJUNTAR EL DOCUMENTO DE SALIDA
        function fn_GuardarDocumento() {
            var fichero = $("#fichero").val();
            if (fichero !== '') {
                var formData = new FormData(document.getElementById("frm_AdjuntarDocumento"));
                formData.append("mode", mode);
                formData.append("periodo", periodo);
                formData.append("tipo", tipo);
                formData.append("numero", codigo);
                formData.append("fechaDocumento", '01/01/2017');
                formData.append("fechaRecepcion", '01/01/2017');
                $.ajax({
                    type: "POST",
                    url: "../IduMesaParte",
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
        //FUNCION PARA OBTENER LA FECHA ACTUAL DEL SISTEMA
        function fn_FechaActual() {
            var fec = new Date;
            var dia = fec.getDate();
            if (dia < 10)
                dia = '0' + dia;
            var mes = fec.getMonth();
            mes = mes + 1;
            if (mes < 10)
                mes = '0' + mes;
            var anio = fec.getFullYear();
            var fecha = dia + '/' + mes + '/' + anio;
            $("#txt_FechaRecepcion").val(fecha);
        }
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_DetalleAnulacion").remove();
            $("#div_Reporte").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../MesaParte",
                data: {mode: 'G', periodo: periodo, mes: mes, tipo: tipo, FechaBus: FechaBus},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA DE NUEVO REGISTRO
        function fn_NuevoRegistro() {
            var codigo = $("#cbo_Area").val();
            if (tipo === 'S') {
                fn_cargarComboAjax("#cbo_Usuario", {mode: 'usuarioMesaParte', periodo: periodo, codigo: codigo});
            }
            $.ajax({
                type: "POST",
                url: "../MesaParte",
                data: {mode: mode, periodo: periodo, mes: mes, tipo: tipo},
                success: function (data) {
                    $('#txt_Numero').val(data);
                }
            });
            $("#cbo_Prioridad").jqxDropDownList('selectItem', '01');
            $("#cbo_TipoDocumento").jqxDropDownList('selectItem', '1');
            $("#cbo_Clasificacion").jqxDropDownList('selectItem', '01');
            $("#txt_Institucion").val('');
            $("#txt_NumeroDocumento").val('');
            $("#txt_Observacion").val('');
            $("#txt_Asunto").val('');
            $("#txt_PostFirma").val('');
            $("#div_Legajos").val('0');
            $("#div_Folios").val('0');
            fn_FechaActual();
            $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../MesaParte",
                data: {mode: mode, periodo: periodo, mes: mes, tipo: tipo, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 16) {
                        $("#txt_Numero").val(codigo);
                        $("#txt_NumeroDocumento").val(dato[0]);
                        $('#txt_FechaDocumento').jqxDateTimeInput('setDate', dato[1]);
                        $("#txt_Observacion").val(dato[2]);
                        $("#txt_Asunto").val(dato[3]);
                        $('#txt_FechaRecepcion').val(dato[4]);
                        $("#cbo_TipoDocumento").jqxDropDownList('selectItem', dato[5]);
                        $("#cbo_Clasificacion").jqxDropDownList('selectItem', dato[6]);
                        codInstitucion = dato[7];
                        $("#txt_Institucion").val(dato[8]);
                        $("#cbo_Prioridad").jqxDropDownList('selectItem', dato[9]);
                        $("#txt_PostFirma").val(dato[10]);
                        $("#div_Legajos").val(dato[11]);
                        $("#div_Folios").val(dato[12]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var numero = $("#txt_Numero").val();
            var prioridad = $("#cbo_Prioridad").val();
            var tipoDocumento = $("#cbo_TipoDocumento").val();
            var numeroDocumento = $("#txt_NumeroDocumento").val();
            var clasificacion = $("#cbo_Clasificacion").val();
            var fechaDocumento = $("#txt_FechaDocumento").val();
            var fechaRecepcion = $("#txt_FechaRecepcion").val();
            var asunto = $("#txt_Asunto").val();
            var observacion = $("#txt_Observacion").val();
            var firma = $("#txt_PostFirma").val();
            var legajos = $("#div_Legajos").val();
            var folios = $("#div_Folios").val();
            var archivo = $("#txt_Archivo").val();
            if (archivo !== '') {
                var formData = new FormData(document.getElementById("frm_MesaParte"));
                formData.append("mode", mode);
                formData.append("periodo", periodo);
                formData.append("tipo", tipo);
                formData.append("numero", numero);
                formData.append("mes", mes);
                formData.append("codInstitucion", codInstitucion);
                formData.append("prioridad", prioridad);
                formData.append("tipoDocumento", tipoDocumento);
                formData.append("numeroDocumento", numeroDocumento);
                formData.append("clasificacion", clasificacion);
                formData.append("fechaDocumento", fechaDocumento);
                formData.append("fechaRecepcion", fechaRecepcion);
                formData.append("asunto", asunto);
                formData.append("observacion", observacion);
                formData.append("firma", firma);
                formData.append("legajos", legajos);
                formData.append("folios", folios);
                formData.append("archivo", archivo);
                $.ajax({
                    type: "POST",
                    url: "../IduMesaParte",
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
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">REGISTRO MESA DE PARTES</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_MesaParte" name="frm_MesaParte" enctype="multipart/form-data" action="../IduMesaParte" method="post">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Correlativo : </td>
                    <td><input type="text" id="txt_Numero" name="txt_Numero"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Dependencia : </td>
                    <td><input type="text" id="txt_Institucion" name="txt_Institucion" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Prioridad : </td>
                    <td>
                        <select id="cbo_Prioridad" name="cbo_Prioridad">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objPrioridad}">   
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Tipo Documento : </td>
                    <td>
                        <select id="cbo_TipoDocumento" name="cbo_TipoDocumento">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objTipoDocumento}">
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Nro Documento : </td>
                    <td><input type="text" id="txt_NumeroDocumento" name="txt_NumeroDocumento"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Clasificaci&oacute;n : </td>
                    <td>
                        <select id="cbo_Clasificacion" name="cbo_Clasificacion">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objClasificacion}">
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Fec. Documento : </td>
                    <td ><div id="txt_FechaDocumento"></div>
                </tr>
                <tr>
                    <td class="inputlabel">Fec. Recepci&oacute;n : </td>
                    <td ><input type="text" id="txt_FechaRecepcion" name="txt_FechaRecepcion"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Asunto : </td>
                    <td><input type="text" id="txt_Asunto" name="txt_Asunto" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Observaci&oacute;n : </td>
                    <td><input type="text" id="txt_Observacion" name="txt_Observacion" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Post Firma : </td>
                    <td><input type="text" id="txt_PostFirma" name="txt_PostFirma" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Legajos : </td>
                    <td><div id="div_Legajos"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Folios : </td>
                    <td><div id="div_Folios"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Archivo : </td>
                    <td><input type="file" name="txt_Archivo" id="txt_Archivo" style="text-transform: uppercase; width: 400px;height: 30px" class="name form-control"/></td>
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
<div style="display: none" id="div_Reporte">
    <div>
        <span style="float: left">LISTADO DE REPORTES</span>
    </div>
    <div style="overflow: hidden">
        <div id='div_MPA0001'>Reporte Diario</div>
        <div id='div_MPA0002'>Reporte Mensual</div>
        <div class="Summit">
            <input type="submit" id="btn_Imprimir" name="btn_Imprimir" value="Ver" style="margin-right: 20px"/>
            <input type="button" id="btn_CerrarImprimir" name="btn_CerrarImprimir" value="Cerrar" style="margin-right: 20px"/>
        </div>
    </div>
</div>
<div id="div_DetalleAnulacion" style="display: none">
    <div>
        <span style="float: left">DETALLE ANULACIÓN DEL DOCUMENTO</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_AnulacionDocumento" name="frm_AnulacionDocumento" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Detalle : </td>
                    <td><textarea id="txt_ComentarioAnulacion" name="txt_ComentarioAnulacion" style="text-transform: uppercase;"/></textarea></td> 
                </tr>
                <tr>
                    <td class="Summit" colspan="2">
                        <div>
                            <input type="button" id="btn_GuardarAnulacion"  value="Guardar" style="margin-right: 20px"/>
                            <input type="button" id="btn_CancelarAnulacion" value="Cancelar" style="margin-right: 20px"/>
                        </div>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
<div id='div_ContextMenu' style='display:none;'>
    <ul>
        <li style="font-weight: bold;">Editar</li>
        <li style="font-weight: bold;">Anular</li> 
        <li type='separator'></li>
        <li style="font-weight: bold; color: maroon;">Ver Documento</li>
        <li type='separator'></li>
        <li style="font-weight: bold; color: blue;">Adjuntar Documento</li>
    </ul>
</div>