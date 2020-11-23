<%-- 
    Document   : ListaClasificadores
    Created on : 10/05/2017, 03:52:22 PM
    Author     : OPRE
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var lista = new Array();
    <c:forEach var="d" items="${objClasificador}">
    var result = {cadena: '${d.cadena}', tipoTransaccion: '${d.tipoTransaccion}', generica: "${d.generica}", subGenerica: '${d.subGenerica}',
        subGenericaDetalle: "${d.subGenericaDetalle}", especifica: "${d.especifica}", especificaDetalle: "${d.especificaDetalle}",
        descripcion: "${d.descripcion}", tipo: "${d.tipo}"};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'cadena', type: "string"},
                        {name: 'tipoTransaccion', type: "string"},
                        {name: 'generica', type: "string"},
                        {name: 'subGenerica', type: "string"},
                        {name: 'especifica', type: "string"},
                        {name: 'subGenericaDetalle', type: "string"},
                        {name: 'especificaDetalle', type: "string"},
                        {name: 'descripcion', type: "string"},
                        {name: 'tipo', type: "string"}
                    ],
            root: "ClasificadoresPresupuestales",
            record: "Clasificador",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "cadena") {
                return "RowBold";
            }
            if (datafield === "especificaDetalle") {
                return "RowBlue";
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
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonRecargar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonSalir = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/exit42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonExportar);
                container.append(ButtonRecargar);
                container.append(ButtonSalir);
                toolbar.append(container);
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonRecargar.jqxButton({width: 30, height: 22});
                ButtonRecargar.jqxTooltip({position: 'bottom', content: "Recargar"});
                ButtonSalir.jqxButton({width: 30, height: 22});
                ButtonSalir.jqxTooltip({position: 'bottom', content: "Salir de la Pantalla"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ClasificadoresPresupuestales');
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
                {text: 'CADENA', dataField: 'cadena', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ESPECIFICA DETALLE', dataField: 'especificaDetalle', filtertype: 'checkedlist', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ESPECIFICA', dataField: 'especifica', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'SUB GENERICA DETALLE', dataField: 'subGenericaDetalle', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'SUB GENERICA', dataField: 'subGenerica', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'GENERICA', dataField: 'generica', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'TIPO TRANSACCIÓN', dataField: 'tipoTransaccion', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DESCRIPCIÓN', dataField: 'descripcion', filtertype: 'checkedlist', width: '15%', align: 'left', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'TIPO', dataField: 'tipo', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 30, autoOpenPopup: false, mode: 'popup'});
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
            if ($.trim($(opcion).text()) === "Ver") {
                fn_VerRegistro();
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
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            $("#txt_Cadena").val(row['cadena']);
            $("#txt_TipoTransaccion").val(row['tipoTransaccion']);
            $("#txt_Generica").val(row['generica']);
            $("#txt_SubGenerica").val(row['subGenerica']);
            $("#txt_SubGenericaDetalle").val(row['subGenericaDetalle']);
            $("#txt_Especifica").val(row['especifica']);
            $("#txt_EspecificaDetalle").val(row['especificaDetalle']);
            $("#txt_Descripcion").val(row['descripcion']);
            $("#txt_Tipo").val(row['tipo']);
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 330;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cerrar'),
                    initContent: function () {
                        $("#txt_Cadena").jqxInput({width: 100, height: 20, disabled: true});
                        $("#txt_TipoTransaccion").jqxInput({width: 400, height: 20, disabled: true});
                        $("#txt_Generica").jqxInput({width: 400, height: 20, disabled: true});
                        $("#txt_SubGenerica").jqxInput({width: 400, height: 20, disabled: true});
                        $("#txt_SubGenericaDetalle").jqxInput({width: 400, height: 20, disabled: true});
                        $("#txt_Especifica").jqxInput({width: 400, height: 20, disabled: true});
                        $("#txt_EspecificaDetalle").jqxInput({width: 400, height: 20, disabled: true});
                        $("#txt_Descripcion").jqxInput({width: 400, height: 80, disabled: true});
                        $("#txt_Tipo").jqxInput({width: 150, height: 20, disabled: true});
                        $('#btn_Cerrar').jqxButton({width: '65px', height: 25});
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
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../Clasificadores",
                data: {mode: 'G'},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_VerRegistro() {
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">Datos del Clasificador Presupuestal : </span>
    </div>
    <div style="overflow: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">  
            <tr>
                <td class="inputlabel">Cadena : </td>
                <td><input type="text" id="txt_Cadena" name="txt_Cadena"/></td>
            </tr>
            <tr>
                <td class="inputlabel">Tipo Transaccion : </td>
                <td><input type="text" id="txt_TipoTransaccion" name="txt_TipoTransaccion" style='text-transform:uppercase;'/></td>
            </tr> 
            <tr>
                <td class="inputlabel">Generica : </td>
                <td><input type="text" id="txt_Generica" name="txt_Generica" style='text-transform:uppercase;'/></td>
            </tr>
            <tr>
                <td class="inputlabel">Sub Generica : </td>
                <td><input type="text" id="txt_SubGenerica" name="txt_SubGenerica" style='text-transform:uppercase;'/></td>
            </tr>
            <tr>
                <td class="inputlabel">Sub Generica Detalle : </td>
                <td><input type="text" id="txt_SubGenericaDetalle" name="txt_SubGenericaDetalle" style='text-transform:uppercase;'/></td>
            </tr>
            <tr>
                <td class="inputlabel">Especifica : </td>
                <td><input type="text" id="txt_Especifica" name="txt_Especifica" style='text-transform:uppercase;'/></td>
            </tr>
            <tr>
                <td class="inputlabel">Especifica Detalle : </td>
                <td><input type="text" id="txt_EspecificaDetalle" name="txt_EspecificaDetalle" style='text-transform:uppercase;'/></td>
            </tr>
            <tr>
                <td class="inputlabel">Descripcion : </td>
                <td><textarea id="txt_Descripcion" name="txt_Descripcion" style="text-transform: uppercase;"/></textarea></td>
            </tr>
            <tr>
                <td class="inputlabel">Tipo : </td>
                <td><input type="text" id="txt_Tipo" name="txt_Tipo" style='text-transform:uppercase;'/></td>
            </tr>
            <tr>
                <td class="Summit" colspan="4">
                    <div>
                        <input type="button" id="btn_Cerrar" value="Cerrar" style="margin-right: 20px"/>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Ver</li>
    </ul>
</div>