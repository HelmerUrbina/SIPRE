<%-- 
    Document   : ListaTareas
    Created on : 09/05/2017, 12:02:43 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var codigo = null;
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objTareas}">
    var result = {codigo: '${d.codigo}', tarea: '${d.tarea}', abreviatura: '${d.abreviatura}', descripcion: '${d.descripcion}',
        unidadMedida: "${d.unidadMedida}", tipo: '${d.tipo}', estado: "${d.estado}"};
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
                        {name: 'tarea', type: "string"},
                        {name: 'abreviatura', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'tarea', type: "string"},
                        {name: 'unidadMedida', type: "string"},
                        {name: 'tipo', type: "string"},
                        {name: 'estado', type: "string"}
                    ],
            root: "TareasPresupuestales",
            record: "Tareas",
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
                        mode = 'I';
                        $("#txt_Codigo").jqxMaskedInput({disabled: false});
                        $("#txt_Codigo").val('');
                        $("#txt_Tarea").val('');
                        $("#cbo_UnidadMedida").jqxDropDownList('setContent', 'Seleccione');
                        $("#cbo_Tipo").jqxDropDownList('setContent', 'Seleccione');
                        $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.8});
                        $('#div_VentanaPrincipal').jqxWindow('open');
                    }
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'TareasPresupuestales');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON RECARGAR
                ButtonRecargar.click(function (event) {
                    fn_Refrescar();
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON SALIR
                ButtonSalir.click(function (event) {
                    window.location.reload();
                });
            },
            columns: [
                {text: 'CÓDIGO', dataField: 'codigo', width: '4%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'TAREA', dataField: 'tarea', width: '26%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ABREVIATURA', dataField: 'abreviatura', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DESCRIPCIÓN', dataField: 'descripcion', width: '27%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'UNIDAD MEDIDA', dataField: 'unidadMedida', width: '9%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'TIPO', dataField: 'tipo', filtertype: 'list', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'list', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 83, autoOpenPopup: false, mode: 'popup'});
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
                    } else if ($.trim($(opcion).text()) === "Activar") {
                        $.confirm({
                            title: 'AVISO DEL SISTEMA',
                            content: 'Desea Activar esta Tarea Presupuestal!',
                            theme: 'material',
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
                                        mode = 'A';
                                        fn_GrabarDatos();
                                    }
                                },
                                cancelar: function () {
                                }
                            }
                        });
                    } else if ($.trim($(opcion).text()) === "Desactivar") {
                        $.confirm({
                            title: 'AVISO DEL SISTEMA',
                            content: 'Desea Desactivar esta Tarea Presupuestal!',
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
                                        mode = 'R';
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
                            content: 'Opción NO VALIDA!!',
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
            $("#txt_Codigo").val(codigo);
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 245;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_Codigo").jqxMaskedInput({width: 100, height: 20, mask: '####'});
                        $("#txt_Tarea").jqxInput({placeHolder: 'TAREA', width: 490, height: 20, minLength: 2, maxLength: 500});
                        $("#txt_Abreviatura").jqxInput({placeHolder: 'ABREVIATURA', width: 400, height: 20, minLength: 2, maxLength: 100});
                        $("#txt_Descripcion").jqxInput({placeHolder: "DESCRIPCION", width: 490, height: 60, minLength: 2, maxLength: 1000});
                        $("#cbo_UnidadMedida").jqxDropDownList({width: 250, height: 20, dropDownWidth: 300, promptText: "Seleccione"});
                        $("#cbo_Tipo").jqxDropDownList({width: 200, height: 20, promptText: "Seleccione"});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            $('#frm_Tarea').jqxValidator('validate');
                        });
                        $('#frm_Tarea').jqxValidator({
                            rules: [
                                {input: '#txt_Tarea', message: 'Ingrese el Nombre de la Tarea Presupuestal!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Abreviatura', message: 'Ingrese la Abreviatura de la Tarea!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Descripcion', message: 'Ingrese la Descripcion de la Tarea!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_Tarea').jqxValidator({
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
            fn_cargarComboAjax("#cbo_UnidadMedida", {mode: 'unidadMedida'});
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../Tareas",
                data: {mode: 'G'},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $("#txt_Codigo").jqxInput({disabled: true});
            $.ajax({
                type: "GET",
                url: "../Tareas",
                data: {mode: mode, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 5) {
                        $("#txt_Tarea").val(dato[0]);
                        $("#txt_Abreviatura").val(dato[1]);
                        $("#txt_Descripcion").val(dato[2]);
                        $("#cbo_UnidadMedida").jqxDropDownList('selectItem', dato[3]);
                        $("#cbo_Tipo").jqxDropDownList('selectItem', dato[4]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var codigo = $("#txt_Codigo").val();
            var tarea = $("#txt_Tarea").val();
            var abreviatura = $("#txt_Abreviatura").val();
            var descripcion = $("#txt_Descripcion").val();
            var unidadMedida = $("#cbo_UnidadMedida").val();
            var tipo = $("#cbo_Tipo").val();
            $.ajax({
                type: "POST",
                url: "../IduTareas",
                data: {mode: mode, codigo: codigo, tarea: tarea, abreviatura: abreviatura,
                    descripcion: descripcion, unidadMedida: unidadMedida, tipo: tipo},
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
        <span style="float: left">DATOS DE LA TAREA PRESUPUESTAL </span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_Tarea" name="frm_Tarea" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">  
                <tr>
                    <td class="inputlabel">Código : </td>
                    <td><input type="text" id="txt_Codigo" name="txt_Codigo"/></td>
                </tr>   
                <tr>
                    <td class="inputlabel">Tarea : </td>
                    <td><input type="text" id="txt_Tarea" name="txt_Tarea" style='text-transform:uppercase;'/></td>
                </tr> 
                <tr>
                    <td class="inputlabel">Abreviatura : </td>
                    <td><input type="text" id="txt_Abreviatura" name="txt_Abreviatura" style='text-transform:uppercase;'/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Descripcion : </td>
                    <td><textarea id="txt_Descripcion" name="txt_Descripcion" style="text-transform: uppercase;"/></textarea></td>
                </tr>

                <tr>
                    <td class="inputlabel">UU. MM. : </td>
                    <td>
                        <select id="cbo_UnidadMedida" name="cbo_UnidadMedida">
                            <option value="0">Seleccione</option>
                        </select>
                    </td> 
                </tr>
                <tr>
                    <td class="inputlabel">Tipo : </td>
                    <td>
                        <select id="cbo_Tipo" name="cbo_Tipo">
                            <option value="HO">HABILITADORA</option>
                            <option value="HA">NO HABILITADORA</option>
                            <option value="LI" selected>LIBRE</option>
                            <option value="HS">HABILIT. ENTRE SI</option> 
                        </select>
                    </td>
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
        <li style="font-weight: bold;">Editar</li>
        <li type='separator'></li>
        <li style="color: blue; font-weight: bold;">Activar</li>
        <li style="color: brown; font-weight: bold;">Desactivar</li>
    </ul>
</div>