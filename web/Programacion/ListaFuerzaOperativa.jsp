<%-- 
    Document   : ListaFuerzaOperativa
    Created on : 10/03/2017, 01:44:32 PM
    Author     : H-TECCSI-V
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnFuerzaOperativa.periodo}';
    var unidadOperativa = '${objBnFuerzaOperativa.unidadOperativa}';
    var unidad = "";
    var codDept = "";
    var codigo = "";
    var estado = "";
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objFuerzaOperativa}">
    var result = {codigo: '${d.codigo}', codDependencia: '${d.dependencia}', dependencia: '${d.dependencia}',
        departamento: '${d.nombreDepartamento}', codigoDepartamento: '${d.codigoDepartamento}', comentario: '${d.comentario}',
        estado: '${d.estado}', desactivacion: '${d.desactivacion}'};
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
                        {name: 'codDependencia', type: "string"},
                        {name: 'dependencia', type: "string"},
                        {name: 'departamento', type: "string"},
                        {name: 'codigoDepartamento', type: "string"},
                        {name: 'comentario', type: "string"},
                        {name: 'estado', type: "string"},
                        {name: 'desactivacion', type: "string"}
                    ],
            root: "FuerzaOperativa",
            record: "FuerzaOperativa",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "estado") {
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
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonExportar);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    $("#cbo_departamento").jqxDropDownList('selectItem', 0);
                    $("#txt_comentario").val('');
                    $("#cbo_dependencia").jqxDropDownList({disabled: false});
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'FuerzaOperativa');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'UNIDAD', dataField: 'dependencia', width: '25%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DEPARTAMENTO', dataField: 'departamento', width: '17%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'COMENTARIO', dataField: 'comentario', width: '35%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', width: '10%', filtertype: 'checkedlist', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DESACTIVACION', dataField: 'desactivacion', width: '10%', align: 'center', cellsAlign: 'left', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 140, autoOpenPopup: false, mode: 'popup'});
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
                    if (estado === "ACTIVO") {
                        mode = 'U';
                        $("#cbo_departamento").jqxDropDownList('selectItem', 0);
                        $("#txt_comentario").val('');
                        $("#cbo_dependencia").jqxDropDownList('setContent', 'Seleccione');
                        fn_EditarRegistro();
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Registro se encuentra DESACTIVADO, imposible modificar',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }
                } else if ($.trim($(opcion).text()) === "Eliminar") {
                    fn_Eliminar();
                } else if ($.trim($(opcion).text()) === "Desactivar") {
                    if (estado === "ACTIVO") {
                        mode = 'E';
                        fn_DesactivarUnidad();
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Registro se encuentra DESACTIVADO, revise.',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }
                } else if ($.trim($(opcion).text()) === "Ingresar Detalle") {
                    fn_registrarDetalle();
                } else if ($.trim($(opcion).text()) === "Generar Tarea 0013") {
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: '¿Desea generar el Funcionamiento en el CNV?',
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
                                    mode = 'I';
                                    fn_GrabarFuncionamiento();
                                }
                            },
                            cancelar: function () {
                            }
                        }
                    });
                }
            }
        });
        //FUNCION PARA CARGAR VENTANA PARA INGRESAR LA RESOLUCION DE DESACTIVACION
        function fn_DesactivarUnidad() {
            $('#div_VentanaDetalle').jqxWindow({isModal: true});
            $('#div_VentanaDetalle').jqxWindow('open');
        }
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
            estado = row['estado'];
            unidad = row['dependencia'];
            codDept = row['codigoDepartamento'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: 400, y: 200},
                    width: 450, height: 128, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_dependencia").jqxDropDownList({width: 300, height: 20});
                        $("#cbo_departamento").jqxDropDownList({width: 300, height: 20});
                        $("#txt_comentario").jqxInput({placeHolder: "Ingrese un comentario", width: 300, height: 20});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            var msg = "";
                            if (msg === "")
                                msg = fn_verificarDepartamento();
                            if (msg === "")
                                msg = fn_verificarDependencia();
                            if (msg === "")
                                msg = fn_verificarTipoUnidad();
                            if (msg === "")
                                fn_GrabarDatos();
                        });
                    }
                });
                //INICIA LOS VALORES DE LA VENTANA DETALLE
                $('#div_VentanaDetalle').jqxWindow({
                    position: {x: 400, y: 250},
                    width: 400, height: 85, resizable: false,
                    cancelButton: $('#btn_CancelarDetalle'),
                    initContent: function () {
                        $("#txt_resolucion").jqxInput({width: 300, height: 20});
                        $("#txt_resolucion").val("");
                        $('#btn_CancelarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').jqxButton({width: '65px', height: 25});
                        $('#btn_GuardarDetalle').on('click', function (event) {
                            var msg = "";
                            if (msg === "")
                                msg = fn_validarResolucion();
                            if (msg === "") {
                                fn_GrabarDatosDetalle();
                            }
                        });
                    }
                });
            }
            return {init: function () {
                    _createElements();
                    fn_cargarComboAjax("#cbo_dependencia", {mode: 'dependencia', unidadOperativa: unidadOperativa});
                }
            };
        }());
        $(document).ready(function () {
            customButtonsDemo.init();
        });
        //FUNCION PARA GENERAR LA TAREA 0013
        function fn_GrabarFuncionamiento() {
            $.ajax({
                type: "POST",
                url: "../IduFuncionamientoFO",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa},
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
        //FUNCION PARA INGRESAR DETALLE DE LA UNIDAD(BTN Y CIA)
        function fn_registrarDetalle() {
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../FuerzaOperativa",
                data: {mode: 'GD', periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo, departamento: codDept, dependencia: unidad},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../FuerzaOperativa",
                data: {mode: 'G', periodo: periodo, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA ANULAR LOS REGISTROS
        function fn_Eliminar() {
            if (estado === "DESACTIVADO") {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'Registro no puede ser borrado, estado: DESACTIVADO',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
            } else {
                $.confirm({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: '¿Desea borrar este registro y todo el detalle que hubiera?',
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
            }
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $("#cbo_dependencia").jqxDropDownList({disabled: true});
            $.ajax({
                type: "GET",
                url: "../FuerzaOperativa",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 3) {
                        $("#cbo_dependencia").jqxDropDownList('selectItem', dato[0]);
                        $("#cbo_departamento").jqxDropDownList('selectItem', dato[1]);
                        $("#txt_comentario").val(dato[2]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA VERIFICAR EL INGRESO DE LA RESOLUCION DE DESACTIVACION
        function fn_validarResolucion() {
            var msg = "";
            var dato = "";
            dato = $("#txt_resolucion").val();
            if (dato === "" || dato.length === "0" || dato === null) {
                msg = "Ingrese la resolucion de desactivacion";
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
        //FUNCION PARA VERIFICAR SE SELECCIONE UN DEPARTAMENTO
        function fn_verificarDepartamento() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_departamento").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el departamento";
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
        //FUNCION PARA VERIFICAR SE SELECCIONE UNA DEPENDENCIA
        function fn_verificarDependencia() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_dependencia").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione la dependencia";
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
        //FUNCION PARA VERIFICAR SE SELECCIONE UN TIPO DE UNIDAD
        function fn_verificarTipoUnidad() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_tipoUnidad").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el tipo de unidad";
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
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var dependencia = $("#cbo_dependencia").val();
            var departamento = $("#cbo_departamento").val();
            var comentario = $("#txt_comentario").val();
            $.ajax({
                type: "POST",
                url: "../IduFuerzaOperativa",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, dependencia: dependencia, departamento: departamento,
                    comentario: comentario, codigo: codigo},
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
            var resolucion = $("#txt_resolucion").val();
            $.ajax({
                type: "POST",
                url: "../IduFuerzaOperativa",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa,
                    tipoFuerza: '0', desactivacion: resolucion, codigo: codigo},
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
        <span style="float: left">FUERZA OPERATIVA</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_DependenciaFuerza" name="frm_DependenciaFuerza" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Departamento : </td>
                    <td>
                        <select id="cbo_departamento" name="cbo_departamento">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objDepartamento}">   
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>  
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Unidad : </td>
                    <td>
                        <select id="cbo_dependencia" name="cbo_dependencia">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Comentario : </td>
                    <td><input type="text" id="txt_comentario" name="txt_comentario" style="text-transform: uppercase;"/></td>
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
<div id="div_VentanaDetalle" style="display: none">
    <div>
        <span style="float: left">REGISTRO DE DESACTIVACIÓN</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_DetalleFuerza" name="frm_DetalleFuerza" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Resoluci&oacute;n : </td>
                    <td><input type="text" id="txt_resolucion" name="txt_resolucion" style="text-transform: uppercase;"/></td 
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
        </form>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Eliminar</li>
        <li type='separator'></li>
        <li style="font-weight: bold; color: red">Desactivar</li>
        <li type='separator'></li>
        <li style="font-weight: bold; color: blue">Ingresar Detalle</li>
        <li type='separator'></li>
        <li style="font-weight: bold;">Generar Tarea 0013</li>
    </ul>
</div>