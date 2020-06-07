<%-- 
    Document   : ListaRegistroPersonal
    Created on : 18/09/2017, 05:03:59 PM
    Author     : hateccsiv
--%>


<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<script type="text/javascript">
    var ruta = '${objBnRegistroPersonal.rutaFile}';
    var codigo = null;
    var mode = null;
    var tipo = null;
    var estado = "";
    var nombres = "";
    var msg = "";
    var indiceDetalle = -1;
    var item="";
    var lista = new Array();
    <c:forEach var="c" items="${objPersonal}">
    var result = {dni: '${c.dni}', apellidos: '${c.apellidosPersonal}', direccion: '${c.direccion}', telefono: '${c.telefono}',
        fechaNac: '${c.fechaNacimiento}', area: '${c.areaLaboral}', cargo: '${c.cargo}', grado: '${c.grado}', estado: '${c.estado}', foto: '${c.foto}'};
    lista.push(result);
    </c:forEach>
    var detalle = new Array();
    <c:forEach var="d" items="${objPersonalFamiliar}">
    var deta = {dni: '${d.dni}', codFamiliar: '${d.codigoFamiliar}', docFamiliar: '${d.documentoFamiliar}',
        parentesco: '${d.parentesco}', apellidos: "${d.nombreFamiliar}", telefono: '${d.telefonoFamiliar}', fijo: '${d.telefono}'};
    detalle.push(deta);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA CABECERA
        var sourceNuevo = {
            datatype: "array",
            datafields:
                    [
                        {name: "detalle", type: "number"},
                        {name: "documento", type: "string"},
                        {name: "parentesco", type: "string"},
                        {name: "nombres", type: "string"},
                        {name: "telefono", type: "string"},
                        {name: "celular", type: "string"},
                        {name: "codParentesco", type: "string"},
                        {name: "nom", type: "string"},
                        {name: "ape", type: "string"}
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
        var sourceCab = {
            localdata: lista,
            datatype: "array",
            datafields: [
                {name: 'dni', type: "string"},
                {name: 'apellidos', type: "string"},
                {name: 'direccion', type: "string"},
                {name: 'telefono', type: "string"},
                {name: 'fechaNac', type: "date", format: 'dd/MM/yyyy'},
                {name: 'area', type: "string"},
                {name: 'cargo', type: "string"},
                {name: 'estado', type: "string"},
                {name: 'foto', type: "string"},
                {name: "ape", type: "string"},
                {name: "grado", type: "string"}
            ],
            root: "Personal",
            record: "Personal",
            id: 'dni'
        };
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA DETALLE 
        var sourceDet = {
            localdata: detalle,
            datatype: "array",
            datafields:
                    [
                        {name: "dni", type: "string"},
                        {name: "codFamiliar", type: "number"},
                        {name: "docFamiliar", type: "string"},
                        {name: "parentesco", type: "string"},
                        {name: "apellidos", type: "string"},
                        {name: "telefono", type: "string"},
                        {name: "fijo", type: "string"}
                    ],
            root: "PersonalFamiliar",
            record: "Detalle",
            id: 'dni',
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
                var result = filter.evaluate(nested[m]["dni"]);
                if (result)
                    ordersbyid.push(nested[m]);
            }
            var sourceNested = {datafields: [
                    {name: "dni", type: "string"},
                    {name: "codFamiliar", type: "number"},
                    {name: "docFamiliar", type: "string"},
                    {name: "parentesco", type: "string"},
                    {name: "apellidos", type: "string"},
                    {name: "telefono", type: "string"},
                    {name: "fijo", type: "string"}
                ],
                id: 'dni',
                localdata: ordersbyid
            };
            var nestedGridAdapter = new $.jqx.dataAdapter(sourceNested);
            if (grid !== null) {
                grid.jqxGrid({
                    source: nestedGridAdapter,
                    width: '95%',
                    height: 340,
                    pageable: true,
                    filterable: true,
                    autoshowfiltericon: true,
                    columnsresize: true,
                    showfilterrow: true,
                    showstatusbar: true,
                    statusbarheight: 25,
                    columns: [
                        {text: 'DOCUMENTO', datafield: 'docFamiliar', width: '10%', align: 'center', cellsAlign: 'center'},
                        {text: 'PARENTESCO', datafield: 'parentesco', width: '10%', filtertype: 'checkedlist', align: 'center', cellsAlign: 'center'},
                        {text: 'NOMBRES Y APELLIDOS', datafield: 'apellidos', width: '30%', align: 'center', cellsAlign: 'left'},
                        {text: 'CELULAR', datafield: 'telefono', width: '10%', align: 'center', cellsAlign: 'center'},
                        {text: 'TELF. FIJO', datafield: 'fijo', width: '10%', align: 'center', cellsAlign: 'center'}
                    ]
                });
            }
        };        
        var cellclass = function (row, datafield, value, rowdata) {

        };
        var photorenderer = function (row, column, value) {
            var name = $('#div_GrillaPrincipal').jqxGrid('getrowdata', row).foto;
            var dni = $('#div_GrillaPrincipal').jqxGrid('getrowdata', row).dni;
            var imgurl = "../Imagenes/Usuarios/" + dni + "-" + name;
            //var imgurl = ruta+ name;
            var img = '<div style="background: white;"><img style="margin:2px; margin-left: 10px;" width="52" height="52" src="' + imgurl + '"></div>';
            return img;
        };
        var renderer = function (row, column, value) {
            return '<span style="margin-left: 4px; margin-top: 9px; float: left;">' + value + '</span>';
        };

        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 60),
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
            pagesize: 30,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonRecargar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonExportar);
                container.append(ButtonRecargar);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonRecargar.jqxButton({width: 30, height: 22});
                ButtonRecargar.jqxTooltip({position: 'bottom', content: "Recargar"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                    $("#div_Dni").jqxMaskedInput({disabled: false});
                    $("#div_Dni").jqxMaskedInput('clearValue');
                    $("#div_Celular").jqxMaskedInput('clearValue');
                    $("#div_FecNacimiento").val('');
                    $("#txt_Nombres").val("");
                    $("#txt_Apellidos").val("");
                    $("#txt_Direccion").val("");
                    $("#txt_Cargo").val("");
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'RegistroPersonal');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON RECARGAR
                ButtonRecargar.click(function (event) {
                    fn_Refrescar();
                });
            },
            initRowDetails: initRowDetails,
            rowDetailsTemplate: {rowdetails: "<div id='grid' style='margin: 3px;'></div>", rowdetailsheight: 350, rowdetailshidden: true},
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: 10, pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px;text-align: center;vertical-align: middle;margin-top: 20px'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'FOTO', width: 80, align: 'center', cellsrenderer: photorenderer},
                {text: 'DNI', width: '6%', dataField: 'dni', align: 'center', cellsAlign: 'center'},
                {text: 'NOMBRES Y APELLIDOS', width: '20%', dataField: 'apellidos', align: 'center', cellsAlign: 'left'},
                {text: 'GRADO', width: '8%', dataField: 'grado', filtertype: 'checkedlist', align: 'center', cellsAlign: 'center'},
                {text: 'FEC. NACIMIENTO', width: '8%', dataField: 'fechaNac', columntype: 'datetimeinput', filtertype: 'date', align: 'center', cellsAlign: 'center', cellsFormat: 'd',
                    cellsrenderer: function (row, column, value){                        
                        var fec=new Date(value);
                        var fecha=new Date(fec.getTime()+86400000);
                        fecha=fn_FormatoFecha(fecha);
                        return "<div style='text-align: center;vertical-align: middle;margin-top: 20px;'>"+fecha+ "</div>";
                    }                        
                },
                {text: 'CARGO', width: '8%', dataField: 'cargo', align: 'center', cellsAlign: 'center'},
                {text: 'AREA', width: '8%', dataField: 'area', align: 'center', filtertype: 'checkedlist', cellsAlign: 'center'},
                {text: 'TELÉFONO', width: '8%', dataField: 'telefono', align: 'center', cellsAlign: 'center'},
                {text: 'DIRECCIÓN', width: '18%', dataField: 'direccion', align: 'center', cellsAlign: 'left'},
                {text: 'ESTADO', width: '8%', dataField: 'estado', align: 'center', filtertype: 'checkedlist', cellsAlign: 'center'}
            ]
        });
        //GRILLA DE DETALLE DE REGISTRO DE FAMILIA
        $("#div_GrillaRegistro").jqxGrid({
            width: '100%',
            height: 350,
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
            pagesize: 10,
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
                    tipo = 'I';
                    $('#div_RegistroDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_RegistroDetalle').jqxWindow('open');
                    $("#div_DocFamiliar").jqxMaskedInput('clearValue');
                    $("#txt_NomFamiliar").val("");
                    $("#txt_ApeFamiliar").val("");
                    $("#div_FijoFamiliar").jqxMaskedInput('clearValue');
                    $("#div_CelFamiliar").jqxMaskedInput('clearValue');
                    $("#div_DocFamiliar").jqxMaskedInput({disabled: false});
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

                        $('#div_RegistroDetalle').jqxWindow({isModal: true, modalOpacity: 0.9});
                        $("#div_DocFamiliar").jqxMaskedInput({disabled: true});
                        $('#div_RegistroDetalle').jqxWindow('open');
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
                {text: 'DOCUMENTO', datafield: 'documento', width: '15%', align: 'center', cellsAlign: 'center'},
                {text: 'PARENTESCO', datafield: 'parentesco', width: '15%', align: 'center', cellsAlign: 'center'},
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
                        content: 'El personal no puede ser modificado',
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
                        content: 'El personal ya se encuentra de baja.',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                } else {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Desea dar de baja al personal: <b>' + nombres,
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
                                    $("#div_Dni").val(codigo);
                                    $("#div_FecNacimiento").val('01/01/2017');
                                    fn_GrabarDatos();
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
                        content: 'El personal ya se encuentra de alta.',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                } else {
                    $.confirm({
                        title: 'AVISO DEL SISTEMA',
                        content: 'Desea dar de alta al personal: <b>' + nombres + '',
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
                                    $("#div_Dni").val(codigo);
                                    $("#div_FecNacimiento").val('01/01/2017');
                                    fn_GrabarDatos();
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
                        content: 'No puede ingresar datos familiares el personal se encuentra de baja.',
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
        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['dni'];
            estado = row['estado'];
            nombres = row['apellidos'];

        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 300;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#div_Dni").jqxMaskedInput({width: 100, height: 20, mask: '########'});
                        $("#cbo_Grado").jqxComboBox({width: 200, height: 20, promptText: "Seleccione",selectedIndex: 0,searchMode: 'contains',autoComplete: true,animationType: 'fade'});
                        $("#cbo_Grado").on('select',function(event){
                            if(event.args){
                                item=event.args.item;
                            }
                        });
                        $("#txt_Nombres").jqxInput({placeHolder: "Ingrese nombres", width: 300, height: 20, maxLength: 70});
                        $("#txt_Apellidos").jqxInput({placeHolder: "Ingrese apellidos", width: 300, height: 20, maxLength: 70});
                        $("#div_FecNacimiento").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#txt_Direccion").jqxInput({placeHolder: "Ingrese direccion", width: 450, height: 20, maxLength: 100});
                        $("#div_Celular").jqxMaskedInput({width: 110, height: 20, mask: '###-###-###'});
                        $("#cbo_Area").jqxDropDownList({width: 200, height: 20, promptText: "Seleccione"});
                        $("#txt_Cargo").jqxInput({placeHolder: "Ingrese cargo", width: 300, height: 20, maxLength: 100});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            var msg = "";
                            if (msg === "")
                                msg = fn_verificarArea();
                            if (msg === "")
                                msg = fn_verificarGrado();
                            if (msg === "")
                                msg = fn_verificaFormatoImagen();
                            if (msg === "") {
                                $('#frm_RegistroPersonal').jqxValidator('validate');
                            }
                        });
                        $('#frm_RegistroPersonal').jqxValidator({
                            rules: [
                                {input: '#div_Dni', message: 'Ingrese el DNI', action: 'valuechanged, blur', rule: 'required'},
                                {input: '#txt_Nombres', message: 'Ingrese nombres', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Apellidos', message: 'Ingrese apellidos', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Direccion', message: 'Ingrese la dirección', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Cargo', message: 'Ingrese el cargo', action: 'keyup, blur', rule: 'required'},
                                {input: '#div_Celular', message: 'Ingrese el número de celular', action: 'valuechanged, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_RegistroPersonal').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatos();
                            }
                        });
                    }
                });
                //INICIAMOS VALORES PARA LA VENTA DE REGISTRO DE FAMILIA
                ancho = 750;
                alto = 490;
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
                ancho = 450;
                alto = 200;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_RegistroDetalle').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_CancelarRegistro'),
                    initContent: function () {
                        $("#div_DocFamiliar").jqxMaskedInput({width: 100, height: 20, mask: '########'});                       
                        $("#cbo_Parentesco").jqxDropDownList({width: 200, height: 20, promptText: "Seleccione"});
                        $("#txt_NomFamiliar").jqxInput({placeHolder: "Ingrese nombres", width: 250, height: 20, maxLength: 70});
                        $("#txt_ApeFamiliar").jqxInput({placeHolder: "Ingrese apellidos", width: 250, height: 20, maxLength: 70});
                        $("#div_FijoFamiliar").jqxMaskedInput({width: 110, height: 20, mask: '#######'});
                        $("#div_CelFamiliar").jqxMaskedInput({width: 110, height: 20, mask: '#########'});
                        $('#btn_CancelarRegistro').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRegistro').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarRegistro').on('click', function () {
                            var msg = "";
                            if (msg === "")
                                msg = fn_verificarParentesco();
                            if (msg === "") {
                                $('#frm_RegistroFamilia').jqxValidator('validate');
                            }
                        });
                        $('#frm_RegistroFamilia').jqxValidator({
                            rules: [
                                {input: '#div_DocFamiliar', message: 'Ingrese el DNI', action: 'valuechanged, blur', rule: 'required'},
                                {input: '#txt_NomFamiliar', message: 'Ingrese nombres', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_ApeFamiliar', message: 'Ingrese apellidos', action: 'keyup, blur', rule: 'required'},
                                {input: '#div_CelFamiliar', message: 'Ingrese el número de celular', action: 'valuechanged, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_RegistroFamilia').jqxValidator({
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
                                    if (tipo === 'I') {
                                        $("#div_GrillaRegistro").jqxGrid('addrow', null, row);
                                    }
                                    if (tipo === 'U') {
                                        var rowindex = $("#div_GrillaRegistro").jqxGrid('getselectedrowindex');
                                        var rowID = $('#div_GrillaRegistro').jqxGrid('getrowid', rowindex);
                                        $('#div_GrillaRegistro').jqxGrid('updaterow', rowID, row);
                                    }
                                    tipo = null;
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
                data: {dni: codigo,
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
            $("#txt_Personal").val(nombres);
            $.ajax({
                type: "GET",
                url: "../Personal",
                data: {mode: 'F', dni: codigo},
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
                        var row = {documento: datos[0], parentesco: datos[1], nombres: datos[2] + ", " + datos[3],
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
        //FUNCION PARA VALIDAR FORMATO DE IMAGEN
        function fn_verificaFormatoImagen() {
            var msg = "";
            var obj = document.getElementById("txt_Foto");

            if (obj.value === "" || obj.value === null) {
                msg = "Debe seleccionar una imagen, revise.";
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: msg,
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
                return "ERROR";
            } else {
                var uploadFile = obj.files[0];
                if (!(/\.(jpg|jpeg|png)$/i).test(uploadFile.name)) {
                    msg = "El archivo seleccionado no es una imagen, los formatos permitidos son: <b>.jpg, .jpeg, .png";
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: msg,
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                    return "ERROR";
                } else {
                    return "";
                }
            }
        }
        //FUNCION PARA VERIFICAR EL PARENTESCO
        function fn_verificarParentesco() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_Parentesco").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el parentesco";
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
        function fn_verificarArea() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_Area").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el area";
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
        //FUNCION PARA VERIFICAR EL GRADO
        function fn_verificarGrado() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_Grado").val();
            if (dato === "" || dato === "0" || dato === null || item==="") {
                msg = "Seleccione el grado";
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
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $("#div_Dni").jqxMaskedInput({disabled: true});
            $.ajax({
                type: "GET",
                url: "../Personal",
                data: {mode: mode, dni: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 8) {
                        $("#div_Dni").val(codigo);
                        $("#txt_Nombres").val(dato[0]);
                        $("#txt_Apellidos").val(dato[1]);
                        $('#div_FecNacimiento').jqxDateTimeInput('setDate', dato[4]);
                        $("#txt_Direccion").val(dato[2]);
                        $('#div_Celular').val(dato[3]);
                        $("#cbo_Area").jqxDropDownList('selectItem', dato[5]);
                        $("#txt_Cargo").val(dato[6]);
                        $("#cbo_Grado").jqxComboBox('selectItem', dato[7]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var dni = $("#div_Dni").val();
            var nombres = $("#txt_Nombres").val();
            var apellidos = $("#txt_Apellidos").val();
            var fecNacimiento = $("#div_FecNacimiento").val();
            var direccion = $("#txt_Direccion").val();
            var celular = $("#div_Celular").val();
            var area = $("#cbo_Area").val();
            var cargo = $("#txt_Cargo").val();
            var foto = $("#txt_Foto").val();
            var grado=$("#cbo_Grado").val();

            var formData = new FormData(document.getElementById("frm_RegistroPersonal"));
            formData.append("mode", mode);
            formData.append("dni", dni);
            formData.append("nombres", nombres);
            formData.append("apellidos", apellidos);
            formData.append("fecNacimiento", fecNacimiento);
            formData.append("direccion", direccion);
            formData.append("celular", celular);
            formData.append("area", area);
            formData.append("grado", grado);
            formData.append("cargo", cargo);
            formData.append("foto", foto);
            $.ajax({
                type: "POST",
                url: "../IduRegistroPersonal",
                /*data: {mode: mode,dni: dni, nombres: nombres, apellidos: apellidos,fecNacimiento: fecNacimiento,
                 direccion: direccion, celular: celular, area: area, cargo: cargo, foto: foto},*/
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
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_RegistroDetalle").remove();
            $("#div_VentanaPrincipal").remove();
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
    });

</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">REGISTRO PERSONAL</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_RegistroPersonal" name="frm_RegistroPersonal" enctype="multipart/form-data" action="../IduRegistroPersonal"  method="post">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">DNI : </td> 
                    <td><div id="div_Dni"></div></td> 
                </tr>
                <tr>
                    <td class="inputlabel">Grado : </td>
                    <td>
                        <select id="cbo_Grado" name="cbo_Grado">
                            <option value="0" selected>Seleccione</option>
                            <c:forEach var="d" items="${objGrado}">   
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>                              
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Nombres : </td> 
                    <td><input type="text" id="txt_Nombres" name="txt_Nombres" style="text-transform: uppercase;"/></td> 
                </tr>
                <tr>
                    <td class="inputlabel">Apellidos : </td> 
                    <td><input type="text" id="txt_Apellidos" name="txt_Apellidos" style="text-transform: uppercase;"/></td> 
                </tr>
                <tr>
                    <td class="inputlabel">Fec. Nacimiento : </td>
                    <td><div id="div_FecNacimiento"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Direcci&oacute;n : </td> 
                    <td><input type="text" id="txt_Direccion" name="txt_Direccion" style="text-transform: uppercase;"/></td> 
                </tr>
                <tr>
                    <td class="inputlabel">Nro Celular : </td> 
                    <td><div id="div_Celular"></div></td> 
                </tr>
                <tr>
                    <td class="inputlabel">Area : </td>
                    <td>
                        <select id="cbo_Area" name="cbo_Area">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objArea}">   
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>                              
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Cargo : </td> 
                    <td><input type="text" id="txt_Cargo" name="txt_Cargo" style="text-transform: uppercase;"/></td> 
                </tr>
                <tr>
                    <td class="inputlabel">Foto : </td>
                    <td><input type="file" name="txt_Foto" id="txt_Foto" style="text-transform: uppercase; width: 400px;height: 30px" class="name form-control" multiple/></td>                    
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
<div id="cbo_Ajax" style='display: none;' ></div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Baja</li>
        <li>Alta</li>
        <li type='separator'></li>
        <li>Datos Familiares</li>
    </ul>
</div>
<div id="div_VentanaDetalle" style="display: none">
    <div>
        <span style="float: left">LISTA DE FAMILIARES</span>
    </div>
    <div style="overflow: hidden">

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="inputlabel">Personal : </td>
                <td><input type="text" id="txt_Personal" name="txt_Personal" style="text-transform: uppercase;"/></td>
            </tr>          
            <tr>
                <td colspan="2"><div id="div_GrillaRegistro"> </div></td>                     
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
        <div style="display: none" id="div_RegistroDetalle">
            <div>
                <span style="float: left">REGISTRO DE FAMILIARES</span>
            </div>
            <div style="overflow: hidden">  
                <form id="frm_RegistroFamilia" name="frm_RegistroFamilia" method="post">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                        <tr>
                            <td class="inputlabel">Documento : </td>                         
                            <td><div id="div_DocFamiliar"></div></td> 
                        </tr>                  
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
                            <td class="inputlabel">Nombres : </td> 
                            <td><input type="text" id="txt_NomFamiliar" name="txt_NomFamiliar" style="text-transform: uppercase;"/></td> 
                        </tr>
                        <tr>
                            <td class="inputlabel">Apellidos : </td> 
                            <td><input type="text" id="txt_ApeFamiliar" name="txt_ApeFamiliar" style="text-transform: uppercase;"/></td> 
                        </tr> 
                        <tr>
                            <td class="inputlabel">Tel&eacute;fono Fijo : </td> 
                            <td><div id="div_FijoFamiliar"></div></td> 
                        </tr>
                        <tr>
                            <td class="inputlabel">Nro Celular : </td> 
                            <td><div id="div_CelFamiliar"></div></td> 
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
                </form>
            </div>                
        </div>
    </div>
</div>
<div style="text-align: center;vertical-align: middle;">

</div>
