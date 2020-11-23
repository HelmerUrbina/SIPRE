<%-- 
    Document   : ListaUnidadesOperativas
    Created on : 05/06/2017, 03:56:19 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var codigo = null;
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objUnidadesOperativas}">
    var result = {codigo: '${d.codigo}', nombre: "${d.nombre}", abreviatura: '${d.abreviatura}',
        direccion: '${d.direccion}', cargoJefe: "${d.cargoJefe}", estado: '${d.estado}',
        departamento: '${d.departamento}', provincia: '${d.provincia}', distrito: '${d.distrito}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'codigo', type: "string"},
                        {name: 'nombre', type: "string"},
                        {name: 'abreviatura', type: "string"},
                        {name: 'direccion', type: "string"},
                        {name: 'cargoJefe', type: "string"},
                        {name: 'estado', type: "string"},
                        {name: 'departamento', type: "string"},
                        {name: 'provincia', type: "string"},
                        {name: 'distrito', type: "string"}
                    ],
            root: "ActividadTarea",
            record: "ActividadTarea",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "codigo") {
                return "RowBold";
            }
        };
        //DEFINIMOS LOS CAMPOS Y DATOS DE LA GRILLA
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 32),
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
                var ButtonRecargar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonSalir = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/exit42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonExportar);
                container.append(ButtonRecargar);
                container.append(ButtonSalir);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonRecargar.jqxButton({width: 30, height: 22});
                ButtonRecargar.jqxTooltip({position: 'bottom', content: "Recargar"});
                ButtonSalir.jqxButton({width: 30, height: 22});
                ButtonSalir.jqxTooltip({position: 'bottom', content: "Salir de la Pantalla"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    $("#txt_Codigo").jqxInput({disabled: false});
                    $("#txt_Codigo").val('');
                    $("#txt_Nombre").val('');
                    $("#txt_Abreviatura").val('');
                    $("#txt_Direccion").val('');
                    $("#txt_CargoJefe").val('');
                    $("#cbo_Estado").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_Departamento").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_Provincia").jqxDropDownList('clear');
                    $("#cbo_Distrito").jqxDropDownList('clear');
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'UnidadesOperativas');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON RECARGAR
                ButtonRecargar.click(function (event) {
                    fn_Refrescar();
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON SALIR
                ButtonSalir.click(function (event) {
                    fn_MenuPrincipal();
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'CÓDIGO', dataField: 'codigo', width: '4%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'NOMBRE', dataField: 'nombre', width: '30%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ABREVIATURA', dataField: 'abreviatura', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DIRECCIÓN', dataField: 'direccion', filtertype: 'checkedlist', width: '12%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'CARGO JEFE', dataField: 'cargoJefe', filtertype: 'checkedlist', width: '14%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DEPARTAMENTO', dataField: 'departamento', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'PROVINCIA', dataField: 'provincia', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DISTRITO', dataField: 'distrito', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'left', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 55, autoOpenPopup: false, mode: 'popup'});
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
                if (autorizacion !== 'true') {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'Usuario no Autorizado para realizar este Tipo de Operación',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
                } else {
                    if ($.trim($(opcion).text()) === "Editar") {
                        mode = 'U';
                        fn_EditarRegistro();
                    } else if ($.trim($(opcion).text()) === "Inactivar") {
                        $("#txt_Codigo").val(codigo);
                        $.confirm({
                            title: 'AVISO DEL SISTEMA',
                            content: 'Desea Inactivar esta Unidad Operativa!',
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
                            content: 'No hay Opcion a mostrar',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
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
                var ancho = 500;
                var alto = 270;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_Codigo").jqxInput({placeHolder: 'CÓDIGO', width: 60, height: 20, minLength: 4, maxLength: 4});
                        $("#txt_Nombre").jqxInput({placeHolder: 'UNIDAD OPERATIVA', width: 350, height: 20, maxLength: 100});
                        $("#txt_Abreviatura").jqxInput({placeHolder: 'ABREVIATURA', width: 150, height: 20, maxLength: 30});
                        $("#txt_Direccion").jqxInput({placeHolder: 'DIRECCION', width: 350, height: 20, maxLength: 300});
                        $("#txt_CargoJefe").jqxInput({placeHolder: 'CARGO DEL JEFE', width: 350, height: 20});
                        $("#cbo_Estado").jqxDropDownList({width: 250, height: 20, promptText: "Seleccione"});
                        $("#cbo_Departamento").jqxDropDownList({width: 350, height: 20, promptText: "Seleccione"});
                        $('#cbo_Departamento').on('change', function (event) {
                            $("#cbo_Distrito").jqxDropDownList('clear');
                            fn_cargarComboAjax("#cbo_Provincia", {mode: 'provincia', departamento: $("#cbo_Departamento").val()});
                        });
                        $("#cbo_Provincia").jqxDropDownList({width: 350, height: 20, promptText: "Seleccione"});
                        $('#cbo_Provincia').on('change', function (event) {
                            $("#cbo_Distrito").jqxDropDownList('clear');                            
                            fn_cargarComboAjax("#cbo_Distrito", {mode: 'distrito', departamento: $("#cbo_Departamento").val(), provincia: $("#cbo_Provincia").val()});
                        });
                        $("#cbo_Distrito").jqxDropDownList({width: 350, height: 20, promptText: "Seleccione"});
                        $("#cbo_Estado").jqxDropDownList({width: 100, height: 20, promptText: "Seleccione"});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            $('#frm_UnidadOperativa').jqxValidator('validate');
                        });
                        $('#frm_UnidadOperativa').jqxValidator({
                            rules: [
                                {input: '#txt_Codigo', message: 'Ingrese el Código!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Codigo', message: 'Solo numeros!', action: 'keyup, blur', rule: 'number'},
                                {input: '#txt_Codigo', message: 'El código debe contener 4 caracteres!', action: 'keyup, blur', rule: 'length=4,4'},
                                {input: '#txt_Nombre', message: 'Ingrese el Nombre!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Abreviatura', message: 'Ingrese la Abreviatura!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_UnidadOperativa').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatos();
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
            fn_cargarComboAjax("#cbo_Departamento", {mode: 'departamento'});           
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../UnidadesOperativas",
                data: {mode: 'G'},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $("#txt_Codigo").val(codigo);
            $("#txt_Codigo").jqxInput({disabled: true});
            $.ajax({
                type: "GET",
                url: "../UnidadesOperativas",
                data: {mode: mode, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 8) {
                        $("#cbo_Departamento").jqxDropDownList('selectItem', dato[5]);
                        $("#txt_Nombre").val(dato[0]);
                        $("#txt_Abreviatura").val(dato[1]);
                        $("#cbo_Estado").jqxDropDownList('selectItem', dato[2]);
                        $("#txt_Direccion").val(dato[3]);
                        $("#txt_CargoJefe").val(dato[4]);
                        $("#cbo_Provincia").jqxDropDownList('selectItem', dato[6]);
                        $("#cbo_Distrito").jqxDropDownList('selectItem', dato[7]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.8});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var codigo = $("#txt_Codigo").val();
            var nombre = $("#txt_Nombre").val();
            var abreviatura = $("#txt_Abreviatura").val();
            var direccion = $("#txt_Direccion").val();
            var cargoJefe = $("#txt_CargoJefe").val();
            var ubigeo = $("#cbo_Distrito").val();
            var estado = $("#cbo_Estado").val();
            $.ajax({
                type: "POST",
                url: "../IduUnidadesOperativas",
                data: {mode: mode, codigo: codigo, nombre: nombre,
                    abreviatura: abreviatura, direccion: direccion, cargoJefe: cargoJefe,
                    ubigeo: ubigeo, estado: estado},
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
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">UNIDAD OPERATIVA</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_UnidadOperativa" name="frm_UnidadOperativa" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">                
                <tr>
                    <td class="inputlabel">Código : </td>
                    <td><input type="text" id="txt_Codigo" name="txt_Codigo" /></td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Nombre : </td>
                    <td><input type="text" id="txt_Nombre" name="txt_Nombre" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Abreviatura : </td>
                    <td><input type="text" id="txt_Abreviatura" name="txt_Abreviatura" style="text-transform: uppercase;"/></td>
                </tr> 
                <tr>
                    <td class="inputlabel">Dirección : </td>
                    <td><input type="text" id="txt_Direccion" name="txt_Direccion" style="text-transform: uppercase;"/></td>
                </tr> 
                <tr>
                    <td class="inputlabel">Cargo Jefe : </td>
                    <td><input type="text" id="txt_CargoJefe" name="txt_CargoJefe" style="text-transform: uppercase;"/></td> 
                </tr>
                <tr>
                    <td class="inputlabel">Departamento : </td>
                    <td>
                        <select id="cbo_Departamento" name="cbo_Departamento">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Provincia : </td>
                    <td>
                        <select id="cbo_Provincia" name="cbo_Provincia">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Distrito : </td>
                    <td>
                        <select id="cbo_Distrito" name="cbo_Distrito">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>  
                <tr>
                    <td class="inputlabel">Estado : </td>
                    <td>
                        <select id="cbo_Estado" name="cbo_Estado">
                            <option value="AC">ACTIVO</option> 
                            <option value="IN">INACTIVO</option> 
                        </select>
                    </td> 
                </tr> 
                <tr>
                    <td class="Summit" colspan="4">
                        <div >
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
        <li>Inactivar</li>
    </ul>
</div>