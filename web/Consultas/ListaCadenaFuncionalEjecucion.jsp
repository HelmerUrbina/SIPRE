<%-- 
    Document   : ListaCadenaFuncionalEjecucion
    Created on : 07/02/2018, 10:06:05 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var codigo = null;
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objCadenaFuncional}">
    var result = {codigo: '${d.codigo}', secuenciaFuncional: '${d.secuenciaFuncional}', categoriaPresupuestal: '${d.categoriaPresupuestal}', producto: '${d.producto}',
        actividad: '${d.actividad}', funcion: '${d.funcion}', divisionFuncional: '${d.divisionFuncional}', grupoFuncional: '${d.grupoFuncional}', meta: '${d.meta}',
        finalidad: '${d.finalidad}', unidadMedida: '${d.unidadMedida}', distrito: '${d.distrito}'};
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
                        {name: 'secuenciaFuncional', type: "string"},
                        {name: 'categoriaPresupuestal', type: "string"},
                        {name: 'producto', type: "string"},
                        {name: 'actividad', type: "string"},
                        {name: 'funcion', type: "string"},
                        {name: 'divisionFuncional', type: "string"},
                        {name: 'grupoFuncional', type: "string"},
                        {name: 'meta', type: "string"},
                        {name: 'finalidad', type: "string"},
                        {name: 'unidadMedida', type: "string"},
                        {name: 'distrito', type: "string"}
                    ],
            root: "CadenaFuncionalEjecucion",
            record: "CadenaFuncionalEjecucion",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "secuenciaFuncional") {
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
                    codigo = 0;
                    $("#div_SecuenciaFuncional").jqxNumberInput({disabled: false});
                    $("#div_SecuenciaFuncional").val('');
                    $("#div_CategoriaPresupuestal").val('');
                    $("#div_Producto").val('');
                    $("#div_Actividad").val('');
                    $("#div_Funcion").val('');
                    $("#div_GrupoFuncional").val('');
                    $("#div_DivisionFuncional").val('');
                    $("#txt_Meta").val('');
                    $("#div_Finalidad").val('');
                    $("#txt_CategoriaPresupuestalNombre").val('');
                    $("#txt_ProductoNombre").val('');
                    $("#txt_ActividadNombre").val('');
                    $("#txt_FuncionNombre").val('');
                    $("#txt_GrupoFuncionalNombre").val('');
                    $("#txt_DivisionFuncionalNombre").val('');
                    $("#txt_MetaNombre").val('');
                    $("#txt_FinalidadNombre").val('');
                    $("#cbo_Provincia").jqxDropDownList('clear');
                    $("#cbo_Distrito").jqxDropDownList('clear');
                    $("#div_CategoriaPresupuestal").jqxNumberInput({disabled: false});
                    $("#div_Producto").jqxNumberInput({disabled: false});
                    $("#div_Actividad").jqxNumberInput({disabled: false});
                    $("#div_Funcion").jqxNumberInput({disabled: false});
                    $("#div_DivisionFuncional").jqxNumberInput({disabled: false});
                    $("#div_GrupoFuncional").jqxNumberInput({disabled: false});
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'CadenaFuncionalEjecucion');
                });
            },
            columns: [
                {text: 'SEC.FUN.', dataField: 'secuenciaFuncional', width: '4%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'CAT. PPTAL.', dataField: 'categoriaPresupuestal', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'PROD/PROY', dataField: 'producto', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ACT/ACCION INV./OBR', dataField: 'actividad', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FUNCION', dataField: 'funcion', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DIV. FUN.', dataField: 'divisionFuncional', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'GRP. FUN.', dataField: 'grupoFuncional', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'META', dataField: 'meta', filtertype: 'checkedlist', width: '28%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'FINALIDAD', dataField: 'finalidad', filtertype: 'checkedlist', width: '24%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'UBIGEO', dataField: 'distrito', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 57, autoOpenPopup: false, mode: 'popup'});
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
                } else if ($.trim($(opcion).text()) === "Eliminar") {
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: '¿Desea Eliminar este registro?',
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
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: 400, y: 200},
                    width: 700, height: 355, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#div_SecuenciaFuncional").jqxNumberInput({width: 70, height: 20, inputMode: 'simple', digits: 4, promptChar: "0000", decimalDigits: 0});
                        $("#txt_CategoriaPresupuestalNombre").jqxInput({placeHolder: 'CATEGORIA PRESUPUESTAL', width: 350, height: 20});
                        $("#div_CategoriaPresupuestal").jqxNumberInput({width: 70, height: 20, inputMode: 'simple', digits: 4, promptChar: "0000", decimalDigits: 0});
                        $('#div_CategoriaPresupuestal').on('textchanged', function (event) {
                            var value = event.args.value;
                            if (value.length === 4) {
                                fn_cargarTextoAjax("#txt_CategoriaPresupuestalNombre", 'categoriaPresupuestal', value);
                            } else {
                                $("#txt_CategoriaPresupuestalNombre").val('');                                
                            }
                        });
                        $("#div_Producto").jqxNumberInput({width: 70, height: 20, inputMode: 'simple', digits: 7, decimalDigits: 0});
                        $('#div_Producto').on('textchanged', function (event) {
                            var value = event.args.value;
                            if (value.length === 7)
                                fn_cargarTextoAjax("#txt_ProductoNombre", 'producto', value);
                            else
                                $("#txt_ProductoNombre").val('');
                        });
                        $("#div_Actividad").jqxNumberInput({width: 70, height: 20, inputMode: 'simple', digits: 7, decimalDigits: 0});
                        $('#div_Actividad').on('textchanged', function (event) {
                            var value = event.args.value;
                            if (value.length === 7) {
                                fn_cargarTextoAjax("#txt_ActividadNombre", 'actividad', value);
                                fn_MetaOperativa();
                            } else {
                                $("#txt_ActividadNombre").val('');
                            }
                        });
                        $("#div_Funcion").jqxNumberInput({width: 70, height: 20, inputMode: 'simple', digits: 2, decimalDigits: 0});
                        $('#div_Funcion').on('textchanged', function (event) {
                            var value = event.args.value;
                            if (value.length === 2)
                                fn_cargarTextoAjax("#txt_FuncionNombre", 'funcion', value);
                            else
                                $("#txt_FuncionNombre").val('');
                        });
                        $("#div_DivisionFuncional").jqxNumberInput({width: 70, height: 20, inputMode: 'simple', digits: 3, decimalDigits: 0});
                        $('#div_DivisionFuncional').on('textchanged', function (event) {
                            var value = event.args.value;
                            if (value.length === 3)
                                fn_cargarTextoAjax("#txt_DivisionFuncionalNombre", 'divisionFuncional', value);
                            else
                                $("#txt_DivisionFuncionalNombre").val('');
                        });
                        $("#div_GrupoFuncional").jqxNumberInput({width: 70, height: 20, inputMode: 'simple', digits: 4, decimalDigits: 0});
                        $('#div_GrupoFuncional').on('textchanged', function (event) {
                            var value = event.args.value;
                            if (value.length === 4)
                                fn_cargarTextoAjax("#txt_GrupoFuncionalNombre", 'grupoFuncional', value);
                            else
                                $("#txt_GrupoFuncionalNombre").val('');
                        });
                        $("#txt_Meta").jqxInput({width: 70, height: 20, disabled: true});
                        $("#div_Finalidad").jqxNumberInput({width: 70, height: 20, inputMode: 'simple', digits: 7, decimalDigits: 0});

                        $("#txt_ProductoNombre").jqxInput({placeHolder: 'PRODUCTO/PROYECTO', width: 350, height: 20, disabled: true});
                        $("#txt_ActividadNombre").jqxInput({placeHolder: 'ACTIVIDAD/ACCION DE INVERSION/OBRA', width: 350, height: 20, disabled: true});
                        $("#txt_FuncionNombre").jqxInput({placeHolder: 'FUNCION', width: 350, height: 20, disabled: true});
                        $("#txt_DivisionFuncionalNombre").jqxInput({placeHolder: 'DIVISION FUNCIONAL', width: 350, height: 20, disabled: true});
                        $("#txt_GrupoFuncionalNombre").jqxInput({placeHolder: 'GRUPO FUNCIONAL', width: 350, height: 20, disabled: true});
                        $("#txt_MetaNombre").jqxInput({placeHolder: 'META PRESUPUESTAL', width: 350, height: 20});
                        $("#txt_FinalidadNombre").jqxInput({placeHolder: 'FINALIDAD', width: 350, height: 20});
                        $("#cbo_UnidadMedida").jqxDropDownList({width: 400, height: 20});
                        $("#cbo_Departamento").jqxDropDownList({width: 400, height: 20});
                        $('#cbo_Departamento').on('select', function (event) {
                            var codigo = $("#cbo_Departamento").val();
                            fn_cargarComboAjax("#cbo_Provincia", {mode: 'provincia', departamento: codigo});
                            $("#cbo_Provincia").jqxDropDownList('clear');
                            $("#cbo_Distrito").jqxDropDownList('clear');
                        });
                        $("#cbo_Provincia").jqxDropDownList({width: 400, height: 20});
                        $('#cbo_Provincia').on('select', function (event) {
                            var departamento = $('#cbo_Departamento').val();
                            var codigo = $('#cbo_Provincia').val();
                            fn_cargarComboAjax("#cbo_Distrito", {mode: 'distrito', departamento: departamento, provincia: codigo});
                            $("#cbo_Distrito").jqxDropDownList('clear');
                        });
                        $("#cbo_Distrito").jqxDropDownList({width: 400, height: 20});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            fn_GrabarDatos();
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
                url: "../CadenaFuncionalEjecucion",
                data: {mode: 'G', periodo: periodo},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../CadenaFuncionalEjecucion",
                data: {mode: mode, periodo: periodo, codigo: codigo},
                success: function (data) {                   
                    var dato = data.split("+++");
                    if (dato.length === 21) {
                        $("#div_SecuenciaFuncional").jqxNumberInput({disabled: true});
                        $("#div_SecuenciaFuncional").val(dato[0]);
                        $("#div_CategoriaPresupuestal").val(dato[1]);
                        $("#txt_CategoriaPresupuestalNombre").val(dato[2]);
                        $("#div_Producto").val(dato[3]);
                        $("#txt_ProductoNombre").val(dato[4]);
                        $("#div_Actividad").val(dato[5]);
                        $("#txt_ActividadNombre").val(dato[6]);
                        $("#div_Funcion").val(dato[7]);
                        $("#txt_FuncionNombre").val(dato[8]);
                        $("#div_DivisionFuncional").val(dato[9]);
                        $("#txt_DivisionFuncionalNombre").val(dato[10]);
                        $("#div_GrupoFuncional").val(dato[11]);
                        $("#txt_GrupoFuncionalNombre").val(dato[12]);
                        $("#txt_Meta").val(dato[13]);
                        $("#txt_MetaNombre").val(dato[14]);
                        $("#div_Finalidad").val(dato[15]);
                        $("#txt_FinalidadNombre").val(dato[16]);
                        $("#cbo_UnidadMedida").jqxDropDownList('selectItem', dato[17]);
                        $("#cbo_Departamento").jqxDropDownList('setContent', dato[18]);
                        fn_cargarComboAjax("#cbo_Provincia", {mode: 'provincia', departamento: $("#cbo_Departamento").val()});
                        fn_cargarComboAjax("#cbo_Distrito", {mode: 'distrito', departamento: $("#cbo_Departamento").val(), provincia: $('#cbo_Provincia').val()});
                        $("#cbo_Provincia").jqxDropDownList('setContent', dato[19]);
                        $("#cbo_Distrito").jqxDropDownList('setContent', dato[20]);
                    }
                    $("#div_CategoriaPresupuestal").jqxNumberInput({disabled: true});
                    $("#div_Producto").jqxNumberInput({disabled: true});
                    $("#div_Actividad").jqxNumberInput({disabled: true});
                    $("#div_Funcion").jqxNumberInput({disabled: true});
                    $("#div_DivisionFuncional").jqxNumberInput({disabled: true});
                    $("#div_GrupoFuncional").jqxNumberInput({disabled: true});
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var secuenciaFuncional = $("#div_SecuenciaFuncional").val();
            var categoriaPresupuestal = $("#div_CategoriaPresupuestal").val();
            var categoriaPresupuestalNombre = $("#txt_CategoriaPresupuestalNombre").val();
            var producto = $("#div_Producto").val();
            var productoNombre = $("#txt_ProductoNombre").val();
            var actividad = $("#div_Actividad").val();
            var actividadNombre = $("#txt_ActividadNombre").val();
            var funcion = $("#div_Funcion").val();
            var funcionNombre = $("#txt_FuncionNombre").val();
            var divisionFuncional = $("#div_DivisionFuncional").val();
            var divisionFuncionalNombre = $("#txt_DivisionFuncionalNombre").val();
            var grupoFuncional = $("#div_GrupoFuncional").val();
            var grupoFuncionalNombre = $("#txt_GrupoFuncionalNombre").val();
            var meta = $("#txt_Meta").val();
            var metaNombre = $("#txt_MetaNombre").val();
            var finalidad = $("#div_Finalidad").val();
            var finalidadNombre = $("#txt_FinalidadNombre").val();
            var unidadMedida = $("#cbo_UnidadMedida").val();
            var departamento = '0';
            var provincia = '0';
            var distrito = '0';
            if (mode === 'D') {
            } else {
                departamento = $("#cbo_Departamento").jqxDropDownList('getSelectedItem').label;
                provincia = $("#cbo_Provincia").jqxDropDownList('getSelectedItem').label;
                distrito = $("#cbo_Distrito").jqxDropDownList('getSelectedItem').label;
            }
            $.ajax({
                type: "POST",
                url: "../IduCadenaFuncionalEjecucion",
                data: {mode: mode, periodo: periodo, codigo: codigo, secuenciaFuncional: secuenciaFuncional, categoriaPresupuestal: categoriaPresupuestal,
                    categoriaPresupuestalNombre: categoriaPresupuestalNombre, producto: producto, productoNombre: productoNombre, actividad: actividad,
                    actividadNombre: actividadNombre, funcion: funcion, funcionNombre: funcionNombre, divisionFuncional: divisionFuncional,
                    divisionFuncionalNombre: divisionFuncionalNombre, grupoFuncional: grupoFuncional, grupoFuncionalNombre: grupoFuncionalNombre,
                    meta: meta, metaNombre: metaNombre, finalidad: finalidad, finalidadNombre: finalidadNombre, unidadMedida: unidadMedida,
                    departamento: departamento, provincia: provincia, distrito: distrito},
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
        //FUNCION PARA OBTENER EL CODIGO DE META OPERATIVA
        function fn_MetaOperativa() {
            var actividad = $("#div_Actividad").val();
            $.ajax({
                type: "GET",
                url: "../CadenaFuncionalEjecucion",
                data: {mode: 'B', periodo: periodo, actividad: actividad},
                success: function (data) {
                    $('#txt_Meta').val(data);
                }
            });
        }
        $("#cbo_Departamento").jqxDropDownList('clear');
        fn_cargarComboAjax("#cbo_Departamento", {mode: 'departamento'});
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">CADENA FUNCIONAL PROGRAMATICA</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_CadenaFuncional" name="frm_CadenaFuncional" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Secuencia Funcional : </td> 
                    <td colspan="3"><div id="div_SecuenciaFuncional" name="div_SecuenciaFuncional"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Categoria Presupuestal : </td>
                    <td><div id="div_CategoriaPresupuestal" name="div_CategoriaPresupuestal"></div></td>
                    <td> : <input type="text" id="txt_CategoriaPresupuestalNombre" name="txt_CategoriaPresupuestalNombre" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Producto/Proyecto : </td>
                    <td><div id="div_Producto" name="div_Producto"></div></td>
                    <td> : <input type="text" id="txt_ProductoNombre" name="txt_ProductoNombre" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Act./Acc. de Inver./Obra : </td>
                    <td><div id="div_Actividad" name="div_Actividad"></div></td>
                    <td> : <input type="text" id="txt_ActividadNombre" name="txt_ActividadNombre" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Función : </td>
                    <td><div id="div_Funcion" name="div_Funcion"></div></td>
                    <td> : <input type="text" id="txt_FuncionNombre" name="txt_FuncionNombre" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">DivisionFuncional : </td>
                    <td><div id="div_DivisionFuncional" name="div_DivisionFuncional"></div></td>
                    <td> : <input type="text" id="txt_DivisionFuncionalNombre" name="txt_DivisionFuncionalNombre" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Grupo Funcional : </td>
                    <td><div id="div_GrupoFuncional" name="div_GrupoFuncional"></div></td>
                    <td> : <input type="text" id="txt_GrupoFuncionalNombre" name="txt_GrupoFuncionalNombre" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Meta : </td>
                    <td><input type="text" id="txt_Meta" name="txt_Meta" /> </td>
                    <td> : <input type="text" id="txt_MetaNombre" name="txt_MetaNombre" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Finalidad : </td>
                    <td><div id="div_Finalidad" name="div_Finalidad"></div></td>
                    <td> : <input type="text" id="txt_FinalidadNombre" name="txt_FinalidadNombre" style="text-transform: uppercase;"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Unidad Medida : </td>
                    <td colspan="2">
                        <select id="cbo_UnidadMedida" name="cbo_UnidadMedida">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Departamento : </td>
                    <td colspan="2">
                        <select id="cbo_Departamento" name="cbo_Departamento">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Provincia : </td>
                    <td colspan="2">
                        <select id="cbo_Provincia" name="cbo_Provincia">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Distrito : </td>
                    <td colspan="2">
                        <select id="cbo_Distrito" name="cbo_Distrito">
                            <option value="0">Seleccione</option> 
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
        <li>Editar</li>
        <li>Eliminar</li>        
    </ul>
</div>