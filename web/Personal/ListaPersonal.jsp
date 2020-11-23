<%-- 
    Document   : ListaRegistroPersonal
    Created on : 18/09/2017, 05:03:59 PM
    Author     : H-TECCSI-V
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<script type="text/javascript">
    var mode = null;
    var codigo = null;
    var detalle = null;
    var modeDetalle = null;
    var estado = "";
    var personal = "";
    var msg = "";
    var indiceDetalle = -1;
    var lista = new Array();
    <c:forEach var="c" items="${objPersonal}">
    var result = {codigo: '${c.personal}', documento: '${c.documento}', personal: '${c.paterno}', direccion: '${c.direccion}', telefono: '${c.telefono}',
        fechaNacimiento: '${c.fechaNacimiento}', area: '${c.areaLaboral}', cargo: '${c.cargo}', grado: '${c.grado}', estado: '${c.estado}'};
    lista.push(result);
    </c:forEach>
    var detalle = new Array();
    <c:forEach var="d" items="${objFamilia}">
    var deta = {codigo: '${d.personal}', detalle: '${d.familia}', documento: '${d.documento}', parentesco: '${d.parentesco}', familia: '${d.nombres}',
        telefono: '${d.telefono}', fechaNacimiento: '${d.fechaNacimiento}', observacion: '${d.estado}'};
    detalle.push(deta);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA CABECERA
        var sourceNuevo = {
            datatype: "array",
            datafields:
                    [
                        {name: "detalle", type: "number"},
                        {name: "parentesco", type: "string"},
                        {name: "tipoDocumento", type: "string"},
                        {name: "documento", type: "string"},
                        {name: "paterno", type: "string"},
                        {name: "materno", type: "string"},
                        {name: "nombres", type: "string"},
                        {name: "sexo", type: "string"},
                        {name: "fechaNacimiento", type: "string"},
                        {name: "celular", type: "string"},
                        {name: "direccion", type: "string"},
                        {name: "email", type: "string"},
                        {name: "estado", type: "string"}
                    ],
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            }
        };
        var dataNuevo = new $.jqx.dataAdapter(sourceNuevo);
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields: [
                {name: 'codigo', type: "number"},
                {name: 'documento', type: "string"},
                {name: 'personal', type: "string"},
                {name: 'direccion', type: "string"},
                {name: 'telefono', type: "string"},
                {name: 'fechaNacimiento', type: "date", format: 'dd/MM/yyyy'},
                {name: 'area', type: "string"},
                {name: 'cargo', type: "string"},
                {name: 'estado', type: "string"},
                {name: 'foto', type: "string"},
                {name: "grado", type: "string"}
            ],
            root: "Personal",
            record: "Personal",
            id: 'codigo'
        };
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA DETALLE 
        var sourceDet = {
            localdata: detalle,
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "documento", type: "string"},
                        {name: "parentesco", type: "string"},
                        {name: "familia", type: "string"},
                        {name: "telefono", type: "string"},
                        {name: "fechaNacimiento", type: "string"},
                        {name: "observacion", type: "string"}
                    ],
            root: "PersonalFamiliar",
            record: "Detalle",
            id: 'codigo',
            async: false
        };
        var dataAdapter = new $.jqx.dataAdapter(sourceDet, {autoBind: true});
        nested = dataAdapter.records;
        var nestedGrids = new Array();
        var initRowDetails = function (index, parentElement, gridElement, record) {
            var id = record.uid.toString();
            var grid = $($(parentElement).children()[0]);
            nestedGrids[index] = grid;
            var filtergroup = new $.jqx.filter();
            //var filter_or_operator = 1;
            var filtervalue = id;
            var filtercondition = 'equal';
            var filter = filtergroup.createfilter('stringfilter', filtervalue, filtercondition);
            // fill the orders depending on the id.
            var ordersbyid = [];
            for (var m = 0; m < nested.length; m++) {
                var result = filter.evaluate(nested[m]["codigo"]);
                if (result)
                    ordersbyid.push(nested[m]);
            }
            var sourceNested = {datafields: [
                    {name: "codigo", type: "string"},
                    {name: "documento", type: "string"},
                    {name: "parentesco", type: "string"},
                    {name: "familia", type: "string"},
                    {name: "telefono", type: "string"},
                    {name: "fechaNacimiento", type: "string"},
                    {name: "observacion", type: "string"}
                ],
                id: 'codigo',
                localdata: ordersbyid
            };
            var nestedGridAdapter = new $.jqx.dataAdapter(sourceNested);
            if (grid !== null) {
                grid.jqxGrid({
                    source: nestedGridAdapter,
                    width: '95%',
                    height: 250,
                    pageable: true,
                    filterable: true,
                    autoshowfiltericon: true,
                    columnsresize: true,
                    showfilterrow: true,
                    columns: [
                        {text: 'DOCUMENTO', datafield: 'documento', width: '15%', align: 'center', cellsAlign: 'center'},
                        {text: 'PARENTESCO', datafield: 'parentesco', width: '15%', filtertype: 'checkedlist', align: 'center', cellsAlign: 'center'},
                        {text: 'NOMBRES Y APELLIDOS', datafield: 'familia', width: '35%', align: 'center', cellsAlign: 'left'},
                        {text: 'TELEFONO', datafield: 'telefono', width: '12%', align: 'center', cellsAlign: 'center'},
                        {text: 'FEC. NACIMIENTO', width: '13%', dataField: 'fechaNacimiento', columntype: 'datetimeinput', filtertype: 'date', align: 'center', cellsAlign: 'center', cellsFormat: 'd'},
                        {text: 'OBS.', datafield: 'observacion', width: '10%', align: 'center', cellsAlign: 'center'}
                    ]
                });
            }
        };
        var photorenderer = function (row, column, value) {
            var imgurl = "../Personal?mode=imagen&personal=" + $('#div_GrillaPrincipal').jqxGrid('getrowdata', row).codigo;
            var img = '<div style="background: white;"><img style="display:block; margin:auto;" width="52" height="52" src="' + imgurl + '"></div>';
            return img;
        };
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 32),
            source: sourceCab,
            rowdetails: true,
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
            rowsheight: 55,
            statusbarheight: 25,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonRecargar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExit = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/exit42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonExportar);
                container.append(ButtonRecargar);
                container.append(ButtonExit);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonRecargar.jqxButton({width: 30, height: 22});
                ButtonRecargar.jqxTooltip({position: 'bottom', content: "Recargar"});
                ButtonExit.jqxButton({width: 30, height: 22});
                ButtonExit.jqxTooltip({position: 'bottom', content: "Salir"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    codigo = 0;
                    $("#cbo_TipoDocumento").jqxDropDownList('selectItem', 0);
                    $("#div_NumeroDocumento").jqxMaskedInput('clearValue');
                    $("#txt_Paterno").val("");
                    $("#txt_Materno").val("");
                    $("#txt_Nombres").val("");
                    $('#div_FecNacimiento').jqxDateTimeInput('setDate', "");
                    $('#div_Sexo1').jqxRadioButton({checked: false});
                    $('#div_Sexo2').jqxRadioButton({checked: false});
                    $('#div_Celular').jqxMaskedInput('clearValue');
                    $("#txt_Direccion").val("");
                    $("#txt_Email").val("");
                    $("#cbo_Grado").jqxDropDownList('selectItem', 0);
                    $("#div_CIP").jqxMaskedInput('clearValue');
                    $("#cbo_AreaLaboral").jqxDropDownList('selectItem', 0);
                    $("#txt_Cargo").val("");
                    $("#foto").attr("src", "../Imagenes/Fondos/usuario.jpg");
                    $("#cbo_TipoDocumento").jqxDropDownList({disabled: false});
                    $("#div_NumeroDocumento").jqxMaskedInput({disabled: false});
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'RegistroPersonal');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON RECARGAR
                ButtonRecargar.click(function (event) {
                    fn_Refrescar();
                });
                ButtonExit.click(function (event) {
                    fn_MenuPrincipal();
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 260, rowdetailshidden: true},
            columns: [
                {text: 'FOTO', width: "7%", sortable: false, filterable: false, align: 'center', cellsAlign: 'center', cellsrenderer: photorenderer},
                {text: 'DOCUMENTO', width: '6%', dataField: 'documento', align: 'center', cellsAlign: 'center'},
                {text: 'NOMBRES Y APELLIDOS', width: '20%', dataField: 'personal', align: 'center', cellsAlign: 'left'},
                {text: 'GRADO', width: '8%', dataField: 'grado', filtertype: 'checkedlist', align: 'center', cellsAlign: 'center'},
                {text: 'FEC. NACIMIENTO', width: '8%', dataField: 'fechaNacimiento', columntype: 'datetimeinput', filtertype: 'date', align: 'center', cellsAlign: 'center', cellsFormat: 'd',
                    cellsrenderer: function (row, column, value) {
                        var fec = new Date(value);
                        var fecha = new Date(fec.getTime() + 86400000);
                        fecha = fn_FormatoFecha(fecha);
                        return "<div style='text-align: center;vertical-align: middle;margin-top: 20px;'>" + fecha + "</div>";
                    }
                },
                {text: 'AREA', width: '8%', dataField: 'area', align: 'center', filtertype: 'checkedlist', cellsAlign: 'center'},
                {text: 'CARGO', width: '8%', dataField: 'cargo', align: 'center', cellsAlign: 'center'},
                {text: 'TELÉFONO', width: '8%', dataField: 'telefono', align: 'center', cellsAlign: 'center'},
                {text: 'DIRECCIÓN', width: '19%', dataField: 'direccion', align: 'center', cellsAlign: 'left'},
                {text: 'ESTADO', width: '8%', dataField: 'estado', align: 'center', filtertype: 'checkedlist', cellsAlign: 'center'}
            ]
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA PRINCIPAL
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
            estado = row['estado'];
            personal = row['personal'];
        });
        //GRILLA DE DETALLE DE REGISTRO DE FAMILIA
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: 300,
            source: dataNuevo,
            pageable: true,
            columnsresize: true,
            showtoolbar: true,
            showstatusbar: false,
            showaggregates: true,
            altrows: false,
            editable: false,
            statusbarheight: 25,
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
                ButtonNuevoRegistro.click(function (event) {
                    modeDetalle = 'I';
                    detalle = 0;
                    $("#cbo_TipoDocumentoFamilia").jqxDropDownList('selectItem', 0);
                    $("#div_NumeroDocumentoFamilia").jqxMaskedInput('clearValue');
                    $("#txt_PaternoFamilia").val("");
                    $("#txt_MaternoFamilia").val("");
                    $("#txt_NombresFamilia").val("");
                    $('#div_FecNacimientoFamilia').jqxDateTimeInput('setDate', "");
                    $('#div_SexoFamilia1').jqxRadioButton({checked: false});
                    $('#div_SexoFamilia2').jqxRadioButton({checked: false});
                    $('#div_CelularFamilia').jqxMaskedInput('clearValue');
                    $("#txt_DireccionFamilia").val("");
                    $("#txt_EmailFamilia").val("");
                    $("#cbo_TipoDocumentoFamilia").jqxDropDownList({disabled: false});
                    $("#div_NumeroDocumentoFamilia").jqxMaskedInput({disabled: false});
                    $('#div_RegistroFamilia').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_RegistroFamilia').jqxWindow('open');
                });
                // add new row.
                ButtonEditarRegistro.click(function (event) {
                    tipo = 'U';
                    if (indiceDetalle >= 0) {
                        $("#cbo_Parentesco").jqxDropDownList('selectIndex', 0);
                        var dataRecord = $("#div_GrillaRegistro").jqxGrid('getrowdata', indiceDetalle);
                        $("#div_DocFamiliar").val(dataRecord.documento);
                        $("#txt_NomFamiliar").val(dataRecord.nom);
                        $("#txt_ApeFamiliar").val(dataRecord.ape);
                        $("#div_FijoFamiliar").val(dataRecord.telefono);
                        $("#div_CelFamiliar").val(dataRecord.celular);
                        $("#cbo_Parentesco").jqxDropDownList('selectItem', dataRecord.codParentesco);
                        $('#div_RegistroFamilia').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $("#div_DocFamiliar").jqxMaskedInput({disabled: true});
                        $('#div_RegistroFamilia').jqxWindow('open');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'Aviso Del Sistema',
                            content: 'Debe seleccionar un registro',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }
                });
                // delete selected row.
                ButtonEliminaRegistro.click(function (event) {
                    tipo = 'D';
                    if (indiceDetalle >= 0) {
                        var rowid = $("#div_GrillaRegistro").jqxGrid('getrowid', indiceDetalle);
                        $("#div_GrillaRegistro").jqxGrid('deleterow', rowid);
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'Aviso del Sistema',
                            content: 'Debe seleccionar un registro',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }
                });
            },
            columns: [
                {text: 'DOCUMENTO', datafield: 'documento', width: '20%', align: 'center', cellsAlign: 'center'},
                {text: 'PARENTESCO', datafield: 'parentesco', width: '25%', align: 'center', cellsAlign: 'center'},
                {text: 'NOMBRES Y APELLIDOS', datafield: 'nombres', width: '40%', align: 'center', cellsAlign: 'left'},
                {text: 'TELÉFONO', datafield: 'telefono', width: '15%', align: 'center', cellsAlign: 'center'},
                {text: 'CELULAR', datafield: 'celular', width: '15%', align: 'center', cellsAlign: 'center'}
                //{text: 'CODPARENTESCO', datafield: 'codParentesco', width: '0%', align: 'center', cellsAlign: 'center'}
            ]
        });
        //
        function fn_FormatoFecha(obj) {
            var fecha = "";
            var fechaObj = obj;
            var dia = String(fechaObj.getDate());
            var mes = String(fechaObj.getMonth() + 1);
            var aa = String(fechaObj.getFullYear());
            if (mes.length < 2)
                mes = '0' + mes;
            if (dia.length < 2)
                dia = '0' + dia;
            fecha = dia + "/" + mes + "/" + aa;
            return fecha;
        }
        //
        $("#div_GrillaRegistro").on('rowselect', function (event) {
            indiceDetalle = event.args.rowindex;
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 110, autoOpenPopup: false, mode: 'popup'});
        $("#div_GrillaPrincipal").on('contextmenu', function () {
            return false;
        });
        // handle context menu clicks.
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
                if (estado !== "BAJA") {
                    mode = 'U';
                    fn_EditarRegistro();
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'El Personal no puede ser modificado',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                }
            } else
            if ($.trim($(opcion).text()) === "Baja") {
                if (estado === "BAJA") {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'El Personal ya se encuentra de Baja.',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                } else {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Desea dar de Baja al Personal: <br><strong>' + personal + '</strong>',
                        theme: 'material',
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
                                    fn_GrabarPersonal();
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                }
            } else if ($.trim($(opcion).text()) === "Alta") {
                if (estado === "ACTIVO") {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'El Personal ya se encuentra de Alta.',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                } else {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Desea dar de Alta al Personal: <br><strong>' + personal + '</strong>',
                        theme: 'material',
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
                                    mode = 'A';
                                    fn_GrabarPersonal();
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                }
            } else if ($.trim($(opcion).text()) === "Datos Familiares") {
                if (estado !== "BAJA") {
                    fn_datosFamiliares();
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'No puede ingresar Datos Familiares, el Personal se encuentra de Baja.',
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
                    content: 'Debe Seleccionar un Registro',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            }
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 700;
                var alto = 395;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_TipoDocumento").jqxDropDownList({width: 100, height: 20, dropDownWidth: 150, promptText: "Seleccione", selectedIndex: 0, animationType: 'fade'});
                        $("#cbo_TipoDocumento").on('select', function (event) {
                            if ($("#cbo_TipoDocumento").val() === '1')
                                $("#div_NumeroDocumento").jqxMaskedInput({mask: '########'});
                            if ($("#cbo_TipoDocumento").val() === '2')
                                $("#div_NumeroDocumento").jqxMaskedInput({mask: '############'});
                        });
                        $("#div_NumeroDocumento").jqxMaskedInput({width: 110, height: 20, mask: '########'});
                        $("#txt_Paterno").jqxInput({placeHolder: "Apellido Paterno", width: 300, height: 20, maxLength: 50});
                        $("#txt_Materno").jqxInput({placeHolder: "Apellido Materno", width: 300, height: 20, maxLength: 50});
                        $("#txt_Nombres").jqxInput({placeHolder: "Nombres", width: 300, height: 20, maxLength: 70});
                        $("#div_FecNacimiento").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_Sexo1").jqxRadioButton({width: 250, height: 25});
                        $("#div_Sexo2").jqxRadioButton({width: 250, height: 25});
                        $("#div_Celular").jqxMaskedInput({width: 110, height: 20, mask: '###-###-###'});
                        $("#txt_Direccion").jqxInput({placeHolder: "Dirección", width: 400, height: 20, maxLength: 100});
                        $("#txt_Email").jqxInput({placeHolder: "Correo Electronico", width: 400, height: 20, maxLength: 100});
                        $("#cbo_Grado").jqxDropDownList({width: 100, height: 20, dropDownWidth: 200, promptText: "Seleccione", selectedIndex: 0, animationType: 'fade'});
                        $("#div_CIP").jqxMaskedInput({width: 110, height: 20, mask: '#########'});
                        $("#cbo_AreaLaboral").jqxDropDownList({width: 200, height: 20, dropDownWidth: 350, promptText: "Seleccione"});
                        $("#txt_Cargo").jqxInput({placeHolder: "Ingrese cargo", width: 450, height: 20, maxLength: 100});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            var msg = "";
                            msg += fn_validaCombos('#cbo_TipoDocumento', "Seleccione el Tipo de Documento.");
                            msg += fn_validaCombos('#cbo_Grado', "Seleccione el Grado.");
                            msg += fn_validaCombos('#cbo_AreaLaboral', "Seleccione el Area Laboral.");
                            if (msg === "") {
                                $('#frm_Personal').jqxValidator('validate');
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
                        $('#frm_Personal').jqxValidator({
                            rules: [
                                {input: '#div_NumeroDocumento', message: 'Ingrese el N° de Documento', action: 'valuechanged, blur', rule: 'required'},
                                {input: '#txt_Paterno', message: 'Ingrese el Apellido Paterno', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Materno', message: 'Ingrese el Apellido Materno', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Nombres', message: 'Ingrese los Nombres', action: 'keyup, blur', rule: 'required'},
                                {input: '#div_FecNacimiento', message: 'Ingrese la Fecha de Nacimiento', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Direccion', message: 'Ingrese la dirección', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Email', message: 'Correo Electronico invalido.', action: 'keyup', rule: 'email'},
                                {input: '#txt_Cargo', message: 'Ingrese el cargo', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_Personal').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatos();
                            }
                        });
                    }
                });
                //INICIAMOS VALORES PARA LA VENTA DE REGISTRO DE FAMILIA
                ancho = 750;
                alto = 395;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaDetalle').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarDetalle'),
                    initContent: function () {
                        $("#txt_Personal").jqxInput({placeHolder: 'PERSONAL', width: 550, height: 20, disabled: true});
                        $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').on('click', function () {
                            fn_GrabarDatosDetalle();
                        });
                    }
                });
                //INICIAMOS VALOERS PARA VENTANA DE REGISTRO DE DETALLE
                ancho = 550;
                alto = 325;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_RegistroFamilia').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarFamilia'),
                    initContent: function () {
                        $("#cbo_TipoDocumentoFamilia").jqxDropDownList({width: 100, height: 20, dropDownWidth: 150, promptText: "Seleccione", selectedIndex: 0, animationType: 'fade'});
                        $("#cbo_TipoDocumentoFamilia").on('select', function (event) {
                            if ($("#cbo_TipoDocumentoFamilia").val() === '1')
                                $("#div_NumeroDocumentoFamilia").jqxMaskedInput({mask: '########'});
                            if ($("#cbo_TipoDocumentoFamilia").val() === '2')
                                $("#div_NumeroDocumentoFamilia").jqxMaskedInput({mask: '############'});
                        });
                        $("#div_NumeroDocumentoFamilia").jqxMaskedInput({width: 110, height: 20, mask: '########'});
                        $("#cbo_Parentesco").jqxDropDownList({width: 200, height: 20, dropDownWidth: 350, promptText: "Seleccione"});
                        $("#txt_PaternoFamilia").jqxInput({placeHolder: "Apellido Paterno", width: 300, height: 20, maxLength: 50});
                        $("#txt_MaternoFamilia").jqxInput({placeHolder: "Apellido Materno", width: 300, height: 20, maxLength: 50});
                        $("#txt_NombresFamilia").jqxInput({placeHolder: "Nombres", width: 300, height: 20, maxLength: 70});
                        $("#div_FecNacimientoFamilia").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#div_SexoFamilia1").jqxRadioButton({width: 250, height: 25});
                        $("#div_SexoFamilia2").jqxRadioButton({width: 250, height: 25});
                        $("#div_CelularFamilia").jqxMaskedInput({width: 110, height: 20, mask: '###-###-###'});
                        $("#txt_DireccionFamilia").jqxInput({placeHolder: "Dirección", width: 400, height: 20, maxLength: 100});
                        $("#txt_EmailFamilia").jqxInput({placeHolder: "Correo Electronico", width: 400, height: 20, maxLength: 100});
                        $('#btn_CancelarFamilia').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarFamilia').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarFamilia').on('click', function () {
                            var msg = "";
                            msg += fn_validaCombos('#cbo_TipoDocumentoFamilia', "Seleccione el Tipo de Documento.");
                            msg += fn_validaCombos('#cbo_Parentesco', "Seleccione el Parentesco.");
                            if (msg === "") {
                                $('#frm_Familia').jqxValidator('validate');
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
                        $('#frm_Familia').jqxValidator({
                            rules: [
                                {input: '#div_NumeroDocumentoFamilia', message: 'Ingrese el N° de Documento', action: 'valuechanged, blur', rule: 'required'},
                                {input: '#txt_PaternoFamilia', message: 'Ingrese el Apellido Paterno', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_MaternoFamilia', message: 'Ingrese el Apellido Materno', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_NombresFamilia', message: 'Ingrese los Nombres', action: 'keyup, blur', rule: 'required'},
                                {input: '#div_FecNacimientoFamilia', message: 'Ingrese la Fecha de Nacimiento', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_DireccionFamilia', message: 'Ingrese la dirección', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_Familia').jqxValidator({
                            onSuccess: function () {
                                var documentoFamiliar = $("#div_DocFamiliar").val();
                                var codParentesco = $("#cbo_Parentesco").jqxDropDownList('getSelectedItem').value;
                                var parentesco = $("#cbo_Parentesco").jqxDropDownList('getSelectedItem');
                                var nombresFamiliar = $("#txt_NomFamiliar").val();
                                var apellidosFamiliar = $("#txt_ApeFamiliar").val();
                                var numFijo = $("#div_FijoFamiliar").val();
                                var numCelular = $("#div_CelFamiliar").val();
                                var nombres = nombresFamiliar + " " + apellidosFamiliar;
                                var msg = "";
                                if (msg === "")
                                    msg = fn_validaDetalle(documentoFamiliar);
                                if (msg === "") {
                                    var row = {documento: documentoFamiliar, codParentesco: codParentesco, parentesco: parentesco.label,
                                        nombres: nombres.toUpperCase(), telefono: numFijo, celular: numCelular,
                                        nom: nombresFamiliar.toUpperCase(), ape: apellidosFamiliar.toUpperCase()};
                                    if (modeDetalle === 'I') {
                                        $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
                                    }
                                    if (modeDetalle === 'U') {
                                        var rowindex = $("#div_GrillaRegistro").jqxGrid('getselectedrowindex');
                                        var rowID = $('#div_GrillaRegistro').jqxGrid('getrowid', rowindex);
                                        $('#div_GrillaRegistro').jqxGrid('updaterow', rowID, row);
                                    }
                                    modeDetalle = null;
                                    $("#div_RegistroFamilia").jqxWindow('hide');
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
            }
            return {init: function () {
                    _createElements();
                }
            };
        }());
        $(document).ready(function () {
            customButtonsDemo.init();
        });
        //FUNCION PARA GRABAR DETALLE (REGISTRO FAMILIA)
        function fn_GrabarDatosDetalle() {
            var msg = "";
            var lista = new Array();
            var result = "";
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                result = row.documento + "-" + row.telefono + "-" + row.celular + "-" +
                        row.codParentesco + "-" + row.nom + "-" + row.ape;
                lista.push(result);
            }
            $.ajax({
                type: "POST",
                url: "../IduRegistroFamilia",
                data: {dni: codigo, lista: JSON.stringify(lista)},
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
        //FUNCION PARA VENTANA DE REGISTRO DE FAMILIARES
        function fn_datosFamiliares() {
            $('#div_GrillaRegistro').jqxGrid('clear');
            $("#txt_Personal").val(personal);
            $.ajax({
                type: "GET",
                url: "../Personal",
                data: {mode: 'F', dni: codigo},
                success: function (data) {
                    data = data.replace("[", "");
                    var fila = data.split("[");
                    var rows = new Array();
                    var indice = 13;
                    for (i = 1; i < fila.length; i++) {
                        var columna = fila[i];
                        var datos = columna.split("+++");
                        while (datos[indice].indexOf(']') > 0) {
                            datos[indice] = datos[indice].replace("]", "");
                        }
                        while (datos[indice].indexOf(',') > 0) {
                            datos[indice] = datos[indice].replace(",", "");
                        }
                        var row = {detalle: datos[0], parentesco: datos[1], nombres: datos[2] + ", " + datos[3],
                            telefono: datos[4], celular: datos[5], nom: datos[2], ape: datos[3], codParentesco: datos[6]};
                        rows.push(row);
                    }
                    if (rows.length > 0)
                        $("#div_GrillaRegistro").jqxGrid('addrow', null, rows);
                }
            });
            $('#div_VentanaDetalle').jqxWindow({isModal: true});
            $('#div_VentanaDetalle').jqxWindow('open');
        }
        //FUNCION PARA VALIDAD QUE NO REPITAN LOS REGISTROS DEL DETALLE
        function fn_validaDetalle(docFamiliar) {
            var rows = $('#div_GrillaRegistro').jqxGrid('getrows');
            if (tipo === 'I') {
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.documento.trim() === docFamiliar) {
                        return "Los Datos que desea registrar ya existen, Revise!!";
                    }
                }
            }
            if (tipo === 'U') {
                if (rows[indiceDetalle].documento.trim() === docFamiliar) {
                    return "";
                } else {
                    for (var i = 0; i < rows.length; i++) {
                        var row = rows[i];
                        if (i !== indiceDetalle && row.documento.trim() === docFamiliar) {
                            return "Los Datos que desea registrar ya existen, Revise!!";
                        }
                    }
                }
            }
            return "";
        }
    });
    //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
    function fn_EditarRegistro() {
        $.ajax({
            type: "GET",
            url: "../Personal",
            data: {mode: mode, personal: codigo},
            success: function (data) {
                var dato = data.split("+++");
                if (dato.length === 14) {
                    $("#cbo_TipoDocumento").jqxDropDownList('selectItem', dato[0]);
                    $("#div_NumeroDocumento").val(dato[1]);
                    $("#txt_Paterno").val(dato[2]);
                    $("#txt_Materno").val(dato[3]);
                    $("#txt_Nombres").val(dato[4]);
                    $('#div_FecNacimiento').jqxDateTimeInput('setDate', dato[5]);
                    if (dato[6] === 'M')
                        $('#div_Sexo1').jqxRadioButton({checked: true});
                    else
                        $('#div_Sexo2').jqxRadioButton({checked: true});
                    $('#div_Celular').val(dato[7]);
                    $("#txt_Direccion").val(dato[8]);
                    $("#txt_Email").val(dato[9]);
                    $("#cbo_Grado").jqxDropDownList('selectItem', dato[10]);
                    $("#div_CIP").val(dato[11]);
                    $("#cbo_AreaLaboral").jqxDropDownList('selectItem', dato[12]);
                    $("#txt_Cargo").val(dato[13]);
                    $("#foto").attr("src", "../Personal?mode=imagen&personal=" + codigo);
                    $("#cbo_TipoDocumento").jqxDropDownList({disabled: true});
                    $("#div_NumeroDocumento").jqxMaskedInput({disabled: true});
                }
            }
        });
        $('#div_VentanaPrincipal').jqxWindow({isModal: true});
        $('#div_VentanaPrincipal').jqxWindow('open');
    }
    //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
    function fn_GrabarDatos() {
        var tipoDocumento = $("#cbo_TipoDocumento").val();
        var documento = $("#div_NumeroDocumento").val();
        var paterno = $("#txt_Paterno").val();
        var materno = $("#txt_Materno").val();
        var nombres = $("#txt_Nombres").val();
        var fechaNacimiento = $("#div_FecNacimiento").val();
        var sexo = '';
        if ($('#div_Sexo1').val())
            sexo = 'M';
        if ($('#div_Sexo2').val())
            sexo = 'F';
        var celular = $("#div_Celular").val();
        var direccion = $("#txt_Direccion").val();
        var email = $("#txt_Email").val();
        var grado = $("#cbo_Grado").val();
        var cip = $("#div_CIP").val();
        var area = $("#cbo_AreaLaboral").val();
        var cargo = $("#txt_Cargo").val();
        var foto = $("#txt_Foto").val();
        var formData = new FormData(document.getElementById("frm_Personal"));
        formData.append("mode", mode);
        formData.append("personal", codigo);
        formData.append("tipoDocumento", tipoDocumento);
        formData.append("documento", documento);
        formData.append("paterno", paterno);
        formData.append("materno", materno);
        formData.append("nombres", nombres);
        formData.append("fechaNacimiento", fechaNacimiento);
        formData.append("sexo", sexo);
        formData.append("celular", celular);
        formData.append("direccion", direccion);
        formData.append("email", email);
        formData.append("grado", grado);
        formData.append("cip", cip);
        formData.append("area", area);
        formData.append("cargo", cargo);
        formData.append("foto", foto);
        $.ajax({
            type: "POST",
            url: "../IduPersonal",
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
    }
    //FUNCION PARA GRABAR LOS ESTADOS DE LA VENTANA PRINCIPAL
    function fn_GrabarPersonal() {
        $.ajax({
            type: "POST",
            url: "../IduPersonal",
            data: {mode: mode, personal: codigo},
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
    document.getElementById("txt_Foto").onchange = function (e) {
        // Creamos el objeto de la clase FileReader
        let reader = new FileReader();
        // Leemos el archivo subido y se lo pasamos a nuestro fileReader
        reader.readAsDataURL(e.target.files[0]);
        // Le decimos que cuando este listo ejecute el código interno
        reader.onload = function () {
            let preview = document.getElementById('preview'),
                    image = document.createElement('img');
            image.src = reader.result;
            preview.innerHTML = '';
            preview.append(image);
            image.width = 130;
            image.height = 130;
        };
    };
    function fn_Refrescar() {
        $("#div_GrillaPrincipal").remove();
        $("#div_VentanaPrincipal").remove();
        $("#div_VentanaDetalle").remove();
        $("#div_ContextMenu").remove();
        var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
        $.ajax({
            type: "POST",
            url: "../Personal",
            data: {mode: "G"},
            success: function (data) {
                $contenidoAjax.html(data);
            }
        });
    }
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">REGISTRO PERSONAL</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_Personal" name="frm_Personal" enctype="multipart/form-data" action="../IduRegistroPersonal"  method="post">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Tipo Documento : </td>
                    <td>
                        <select id="cbo_TipoDocumento" name="cbo_TipoDocumento">
                            <option value="0">Seleccione</option>
                            <option value="1">D.N.I.</option>
                            <option value="2">C.E.</option>
                    </td>
                    <td class="inputlabel">N° : </td> 
                    <td><div id="div_NumeroDocumento"></div></td> 
                    <td rowspan="8" > 
                        <div style="background-color: #fafafa; display:inline-block; margin: 0.8rem; padding: 0.5rem; border: 2px solid #ccc; text-align: center;">
                            <div id="preview"><img id="foto" src="../Imagenes/Fondos/usuario.jpg" width="130" height="130"></div>
                            <input type="file" name="txt_Foto" id="txt_Foto" style="text-transform: uppercase; width: 130px;height: 20px;" accept="image/*,"/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Ap. Paterno : </td> 
                    <td colspan="3"><input type="text" id="txt_Paterno" name="txt_Paterno" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Ap. Materno : </td> 
                    <td colspan="3"><input type="text" id="txt_Materno" name="txt_Materno" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Nombres : </td> 
                    <td colspan="3"><input type="text" id="txt_Nombres" name="txt_Nombres" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Fec. Nacimiento : </td>
                    <td colspan="3"><div id="div_FecNacimiento"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Sexo : </td>
                    <td colspan="3">
                        <div id='div_Sexo1'>Masculino</div>
                        <div id='div_Sexo2'>Femenino</div>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Nro Celular : </td>
                    <td colspan="3"><div id="div_Celular"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Direcci&oacute;n : </td>
                    <td colspan="3"><input type="text" id="txt_Direccion" name="txt_Direccion" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Email : </td>
                    <td colspan="3"><input type="text" id="txt_Email" name="txt_Email" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Grado : </td>
                    <td colspan="4">
                        <select id="cbo_Grado" name="cbo_Grado">
                            <option value="0" selected>Seleccione</option>
                            <c:forEach var="d" items="${objGrado}">
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">CIP : </td>
                    <td colspan="3"><div id="div_CIP"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Area : </td>
                    <td colspan="4">
                        <select id="cbo_AreaLaboral" name="cbo_AreaLaboral">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objArea}">
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Cargo : </td> 
                    <td colspan="4"><input type="text" id="txt_Cargo" name="txt_Cargo" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="Summit" colspan="5">
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
<div id="div_VentanaDetalle" style="display: none">
    <div>
        <span style="float: left">LISTADO DE DATOS FAMILIARES</span>
    </div>
    <div style="overflow: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="inputlabel">Personal : </td>
                <td><input type="text" id="txt_Personal" name="txt_Personal" style="text-transform: uppercase;"/></td>
            </tr>
            <tr>
                <td colspan="2"><div id="div_GrillaRegistro"></div></td>
            </tr>
            <tr>
                <td class="Summit" colspan="2">
                    <div>
                        <input type="button" id="btn_GuardarDetalle"  value="Guardar" style="margin-right: 20px"/>
                        <input type="button" id="btn_CancelarDetalle" value="Cancelar" style="margin-right: 20px"/>
                    </div>
                </td>
            </tr>
        </table> 
        <div style="display: none" id="div_RegistroFamilia">
            <div>
                <span style="float: left">REGISTRO DE FAMILIAR</span>
            </div>
            <div style="overflow: hidden">
                <form id="frm_Familia" name="frm_Familia" method="post">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="inputlabel">Tipo Documento : </td>
                            <td>
                                <select id="cbo_TipoDocumentoFamilia" name="cbo_TipoDocumentoFamilia">
                                    <option value="0">Seleccione</option>
                                    <option value="1">D.N.I.</option>
                                    <option value="2">C.E.</option>
                            </td>
                            <td class="inputlabel">N° : </td> 
                            <td><div id="div_NumeroDocumentoFamilia"></div></td> 
                        </tr>
                        <tr>
                            <td class="inputlabel">Parentesco : </td>
                            <td colspan="3">
                                <select id="cbo_Parentesco" name="cbo_Parentesco">
                                    <option value="0">Seleccione</option>
                                    <c:forEach var="d" items="${objParentesco}">
                                        <option value="${d.codigo}">${d.descripcion}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Ap. Paterno : </td> 
                            <td colspan="3"><input type="text" id="txt_PaternoFamilia" name="txt_PaternoFamilia" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Ap. Materno : </td> 
                            <td colspan="3"><input type="text" id="txt_MaternoFamilia" name="txt_MaternoFamilia" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Nombres : </td> 
                            <td colspan="3"><input type="text" id="txt_NombresFamilia" name="txt_NombresFamilia" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Fec. Nacimiento : </td>
                            <td colspan="3"><div id="div_FecNacimientoFamilia"></div></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Sexo : </td>
                            <td colspan="3">
                                <div id='div_SexoFamilia1'>Masculino</div>
                                <div id='div_SexoFamilia2'>Femenino</div>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Nro Celular : </td>
                            <td colspan="3"><div id="div_CelularFamilia"></div></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Direcci&oacute;n : </td>
                            <td colspan="3"><input type="text" id="txt_DireccionFamilia" name="txt_DireccionFamilia" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Email : </td>
                            <td colspan="3"><input type="text" id="txt_EmailFamilia" name="txt_EmailFamilia" style="text-transform: uppercase;"/></td>
                        </tr> 
                        <tr>
                            <td class="Summit" colspan="4">
                                <div>
                                    <input type="button" id="btn_GuardarFamilia" value="Guardar" style="margin-right: 20px" />
                                    <input type="button" id="btn_CancelarFamilia"  value="Cancelar" style="margin-right: 20px"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li style="color: black; font-weight: bold;">Editar</li>
        <li style="color: red; font-weight: bold;">Baja</li>
        <li style="color: green; font-weight: bold;">Alta</li>
        <li type='separator'></li>
        <li style="color: blue; font-weight: bold;">Datos Familiares</li>
    </ul>
</div>