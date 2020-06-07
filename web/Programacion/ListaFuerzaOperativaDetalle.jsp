<%-- 
    Document   : ListaFuerzaOperativaDetalle
    Created on : 14/03/2017, 01:38:09 PM
    Author     : H-TECCSI-V
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnFuerzaOperativa.periodo}';
    var unidadOperativa = '${objBnFuerzaOperativa.unidadOperativa}';
    var codigoCab = '${objBnFuerzaOperativa.codigo}';
    var unidad = '${objBnFuerzaOperativa.dependencia}';
    var codDept = '${objBnFuerzaOperativa.codigoDepartamento}';
    var codigo = "";
    var estado = "";
    var mode = null;
    var codDependencia = "";
    var nomUnidad = "";
    var tipoFuerza = "";
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objFuerzaOperativa}">
    var result = {codigo: '${d.codigo}', codDependencia: '${d.dependenciaDetalle}', dependencia: '${d.dependencia}',
        tipoFuerza: '${d.descripFuerzaOperativa}', comentario: '${d.comentario}',
        estado: '${d.estado}', cantidad: '${d.cantidadOficina}', desactivacion: '${d.desactivacion}',
        importe: '${d.totalRemuneracion}', importeMensual: '${d.importeMensual}', importeAnual: '${d.importeAnual}'};
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
                        {name: 'tipoFuerza', type: "string"},
                        {name: 'comentario', type: "string"},
                        {name: 'estado', type: "string"},
                        {name: 'cantidad', type: "number"},
                        {name: 'desactivacion', type: "string"},
                        {name: 'importe', type: "number"},
                        {name: 'importeMensual', type: "number"},
                        {name: 'importeAnual', type: "number"}
                    ],
            root: "FuerzaOperativaDetalle",
            record: "FuerzaOperativaDetalle",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "estado") {
                return "RowBold";
            }
            if (datafield === "importeAnual") {
                return "RowBlue";
            }
            if (datafield === "importe") {
                return "RowBold";
            }
            if (datafield === "importeMensual") {
                return "RowGreen";
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
            showtoolbar: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            editable: false,
            showstatusbar: true,
            showaggregates: true,
            statusbarheight: 20,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonActualizar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonActualizar);
                container.append(ButtonExportar);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonActualizar.jqxButton({width: 30, height: 22});
                ButtonActualizar.jqxTooltip({position: 'bottom', content: "Actualizar Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    codigo = "";
                    $("#cbo_tipoUnidad").jqxDropDownList('selectItem', 0);
                    $("#txt_comentario").val('');
                    $("#cbo_dependencia").jqxDropDownList({disabled: false});
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                // Recarga la Data en la Grilla
                ButtonActualizar.click(function (event) {
                    fn_Refrescar();
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'FuerzaOperativaDet');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'UNIDAD', dataField: 'dependencia', width: '12%', columngroup: 'Unidad', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'TIPO UNIDAD', dataField: 'tipoFuerza', columngroup: 'Unidad', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'COMENTARIO', dataField: 'comentario', width: '15%', columngroup: 'Unidad', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Totales : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'IMPORTE', dataField: 'importe', width: '8%', columngroup: 'Unidad', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'CANT. OFICINAS', dataField: 'cantidad', columngroup: 'Unidad', width: '8%', align: 'center', cellsAlign: 'center', cellsFormat: 'f0', cellclassname: cellclass},
                {text: 'IMP. MENSUAL', dataField: 'importeMensual', columngroup: 'Unidad', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMP. ANUAL', dataField: 'importeAnual', columngroup: 'Unidad', width: '8%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ESTADO', dataField: 'estado', width: '10%', columngroup: 'Unidad', filtertype: 'checkedlist', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DESACTIVACIÓN', dataField: 'desactivacion', columngroup: 'Unidad', width: '13%', align: 'center', cellsAlign: 'left', cellclassname: cellclass}
            ],
            columngroups: [
                {text: '<strong>LISTADO DE BTN Y CIA</strong>', name: 'Titulo', align: 'center'},
                {text: '<strong>UNIDAD : </strong>' + unidad, name: 'Unidad', parentgroup: 'Titulo'}
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
                        mode = 'B';
                        $("#cbo_tipoUnidad").jqxDropDownList('selectItem', 0);
                        $("#txt_comentario").val('');
                        $("#cbo_dependencia").jqxDropDownList('setContent', 'Selecione');
                        fn_EditarRegistro();
                        mode = 'U';
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
                } else if ($.trim($(opcion).text()) === "Efectivo") {
                    if (estado === "ACTIVO") {
                        fn_detalleEfectivo();
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
                }
            }
        });
        //FUNCION PARA CONSULTAR E INGRESAR LOS EFECTIVOS
        function fn_detalleEfectivo() {
            $("#div_GrillaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_VentanaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../EfectivoFuerzaOperativa",
                data: {mode: 'G', periodo: periodo, unidadOperativa: unidadOperativa, codFuerza: codigo,
                    dependencia: codDependencia, unidad: unidad, tipoFuerza: tipoFuerza, codigo: codigoCab,
                    departamento: codDept, nomUnidad: nomUnidad},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
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
            codDependencia = row['codDependencia'];
            nomUnidad = row['dependencia'];
            tipoFuerza = row['tipoFuerza'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: 400, y: 250},
                    width: 410, height: 152, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_dependencia").jqxDropDownList({width: 300, height: 20});
                        $("#cbo_tipoUnidad").jqxDropDownList({width: 300, height: 20});
                        $("#cbo_tipoUnidad").on('change', function () {
                            fn_activarCantidad();
                        });
                        $('#div_cantidad').jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 3, decimalDigits: 0, disabled: true});
                        $("#txt_comentario").jqxInput({placeHolder: "Ingrese un comentario", width: 300, height: 20});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            var msg = "";
                            if (msg === "")
                                msg = fn_verificarDependencia();
                            if (msg === "")
                                msg = fn_verificarTipoUnidad();
                            if (msg === "")
                                msg = fn_validarCantidad();
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
        //FUNCION PARA ACTIVA/DESACTIVAR CANTIDAD
        function fn_activarCantidad() {
            var tipo = $("#cbo_tipoUnidad").val();
            if (tipo === "1" || tipo === "2" || tipo === "3") {
                $('#div_cantidad').jqxNumberInput({disabled: false});
            } else {
                $('#div_cantidad').val("0");
                $('#div_cantidad').jqxNumberInput({disabled: true});
            }
        }
        //FUNCION PARA VERIFICAR LA CNTIDAD DE OFICINAS CORRECTAS
        function fn_validarCantidad() {
            var msg = "";
            var dato = "";
            dato = $("#div_cantidad").val();
            dato = parseFloat(dato);
            var tipo = $("#cbo_tipoUnidad").val();
            if (tipo === "1" || tipo === "2" || tipo === "3") {
                if (dato <= 0) {
                    msg = "Ingrese la cantidad";
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
            } else {
                return "";
            }
        }
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../FuerzaOperativa",
                data: {mode: 'GD', periodo: periodo, unidadOperativa: unidadOperativa, codigo: codigoCab, departamento: codDept, dependencia: unidad},
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
                    content: '¿Desea borrar este registro ?',
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
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, codigoDetalle: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 4) {
                        $("#cbo_dependencia").jqxDropDownList('selectItem', dato[0]);
                        $("#txt_comentario").val(dato[1]);
                        $("#cbo_tipoUnidad").jqxDropDownList('selectItem', dato[2]);
                        $("#div_cantidad").val(dato[3]);
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
            var tipoUnidad = $("#cbo_tipoUnidad").val();
            var comentario = $("#txt_comentario").val();
            var cantidad = $("#div_cantidad").val();
            $.ajax({
                type: "POST",
                url: "../IduFuerzaOperativaDetalle",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa, dependencia: dependencia, departamento: codDept,
                    tipoFuerza: tipoUnidad, comentario: comentario, codigoDetalle: codigo, codigo: codigoCab, cantidad: cantidad},
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
                url: "../IduFuerzaOperativaDetalle",
                data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa,
                    tipoFuerza: "0", desactivacion: resolucion, codigo: codigoCab, codigoDetalle: codigo},
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
                    <td class="inputlabel">Unidad : </td>
                    <td>
                        <select id="cbo_dependencia" name="cbo_dependencia">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Tipo Unidad : </td>
                    <td>
                        <select id="cbo_tipoUnidad" name="cbo_tipoUnidad">
                            <option value="0">Seleccione</option>
                            <c:forEach var="j" items="${objTipoFuerza}">   
                                <option value="${j.codigo}">${j.descripcion}</option>
                            </c:forEach>  
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Cantidad : </td>
                    <td><div id="div_cantidad"></div> </td>  
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
                    <td><input type="text" id="txt_resolucion" name="txt_resolucion" style="text-transform: uppercase;"/></td>
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
        <li style="font-weight: bold;">Efectivo</li>
    </ul>
</div>
