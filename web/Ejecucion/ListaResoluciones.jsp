<%-- 
    Document   : ListaResoluciones
    Created on : 26/02/2018, 10:37:19 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var autorizacion = '${autorizacion}';
    var codigo = null;
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objResoluciones}">
    var result = {codigo: '${d.codigo}', fuenteFinanciamiento: '${d.fuenteFinanciamiento}', resolucion: "${d.resolucion}",
        fecha: "${d.fecha}", tipo: '${d.tipo}', descripcion: '${d.descripcion}', importe: "${d.importe}"};
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
                        {name: 'fuenteFinanciamiento', type: "string"},
                        {name: 'resolucion', type: "string"},
                        {name: 'fecha', type: "string"},
                        {name: 'tipo', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'importe', type: "number"}
                    ],
            root: "Resoluciones",
            record: "Resoluciones",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "resolucion") {
                return "RowBold";
            }
            if (datafield === "importe") {
                return "RowBlue";
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
            pagesize: 50,
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
                    $("#cbo_FuenteFinanciamiento").jqxDropDownList('setContent', 'Seleccione');
                    $("#cbo_TipoResolucion").jqxDropDownList('setContent', 'Seleccione');
                    $("#div_Resolucion").val('');
                    $("#txt_Descripcion").val('');
                    $("#div_Importe").val(0);
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.8});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ListadoResoluciones');
                });
            },
            columns: [
                {text: 'RESOLUCIÓN', dataField: 'resolucion', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'F.F.', dataField: 'fuenteFinanciamiento', filtertype: 'list', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DESCRIPCIÓN', dataField: 'descripcion', width: '47%', align: 'center', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'importe', width: '15%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass},
                {text: 'TIPO', dataField: 'tipo', filtertype: 'list', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FECHA', dataField: 'fecha', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
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
                    } else if ($.trim($(opcion).text()) === "Anular") {
                        $.confirm({
                            title: 'AVISO DEL SISTEMA',
                            content: 'Desea Anular este registro!',
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
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 250;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_FuenteFinanciamiento").jqxDropDownList({width: 400, height: 20, promptText: "Seleccione"});
                        $("#cbo_TipoResolucion").jqxDropDownList({width: 300, height: 20, promptText: "Seleccione"});
                        $("#div_Resolucion").jqxNumberInput({width: 70, height: 20, inputMode: 'simple', digits: 6, decimalDigits: 0});
                        $("#txt_Fecha").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#txt_Descripcion").jqxInput({width: 470, height: 65, minLength: 1});
                        $("#div_Importe").jqxNumberInput({width: 150, height: 20, max: 999999999999, digits: 12, decimalDigits: 0});
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
            fn_cargarComboAjax("#cbo_FuenteFinanciamiento", {mode: 'presupuesto', periodo: $("#cbo_Periodo").val()});
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../Resoluciones",
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
                url: "../Resoluciones",
                data: {mode: mode, periodo: periodo, codigo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 6) {
                        $("#div_Resolucion").val(dato[0]);
                        $("#txt_Fecha").val(dato[1]);
                        $("#cbo_TipoResolucion").jqxDropDownList('selectItem', dato[2]);
                        $("#txt_Descripcion").val(dato[3]);
                        $("#cbo_FuenteFinanciamiento").jqxDropDownList('selectItem', dato[4]);
                        $('#div_Importe').val(parseFloat(dato[5]));
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var presupuesto = $("#cbo_FuenteFinanciamiento").val();
            var tipo = $("#cbo_TipoResolucion").val();
            var fecha = $("#txt_Fecha").val();
            var descripcion = $("#txt_Descripcion").val();
            var resolucion = $("#div_Resolucion").val();
            var importe = $("#div_Importe").val();            
            $.ajax({
                type: "POST",
                url: "../IduResoluciones",
                data: {mode: mode, periodo: periodo, codigo: codigo, presupuesto: presupuesto, tipo: tipo,
                    fecha: fecha, descripcion: descripcion, resolucion: resolucion, importe: importe},
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
        <span style="float: left">Registro de Resolución : </span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_Tarea" name="frm_Tarea" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">F.F : </td>
                    <td>
                        <select id="cbo_FuenteFinanciamiento" name="cbo_FuenteFinanciamiento">
                            <option value="0">Seleccione</option>
                        </select>
                    </td> 
                </tr>
                <tr>
                    <td class="inputlabel">Tipo : </td>
                    <td>
                        <select id="cbo_TipoResolucion" name="cbo_TipoResolucion">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objTipoResolucion}">   
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach> 
                        </select>
                    </td> 
                </tr>
                <tr>
                    <td class="inputlabel">Fecha : </td>
                    <td><div id="txt_Fecha"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">N° Resolucion : </td>
                    <td><div id="div_Resolucion" name="div_Resolucion"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Descripción : </td>
                    <td><textarea id="txt_Descripcion" name="txt_Descripcion" style="text-transform: uppercase;"/></textarea></td>
                </tr>
                <tr>
                    <td class="inputlabel">Importe : </td>
                    <td><div id="div_Importe"></div></td>
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
    </ul>
</div>
