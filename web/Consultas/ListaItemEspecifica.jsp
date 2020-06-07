<%-- 
    Document   : ListaItemEspecifica
    Created on : 26/05/2017, 09:16:03 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var autorizacion = '${autorizacion}';
    var codigo = null;
    var cadenaGasto = $("#cbo_CadenaGasto").val();
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objItemEspecifica}">
    var result = {codigo: '${d.codigo}', item: '${d.item}', unidadMedida: "${d.unidadMedida}"};
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
                        {name: 'item', type: "string"},
                        {name: 'unidadMedida', type: "string"}
                    ],
            root: "ItemEspecifica",
            record: "ItemEspecifica",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
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
                        $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.8});
                        $('#div_VentanaPrincipal').jqxWindow('open');
                    }
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ItemEspecificaGasto');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'ITEM', dataField: 'item', width: '60%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'UNIDAD MEDIDA', dataField: 'unidadMedida', filtertype: 'checkedlist', width: '17%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: ' ', dataField: 'null', filterable: false, sortable: false, width: '20%', cellclassname: cellclass}
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
                    if ($.trim($(opcion).text()) === "Eliminar") {
                        $.confirm({
                            title: 'AVISO DEL SISTEMA',
                            content: 'Desea eliminar este Item!',
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
                var alto = 500;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_Buscar").jqxInput({placeHolder: "BUSCAR ITEM", height: 20, width: 400, minLength: 5, maxLength: 100});
                        $('#txt_Buscar').on('change', function () {
                            $('#frm_ItemEspecifica').jqxValidator('validate');
                        });
                        $('#div_Opciones').jqxTree({width: '580px', height: '400px', hasThreeStates: true, checkboxes: true});
                        $('#div_Opciones').css('visibility', 'visible');
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            fn_GrabarDatos();
                        });
                        $('#frm_ItemEspecifica').jqxValidator({
                            rules: [
                                {input: '#txt_Buscar', message: 'Ingrese la Busqueda!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_ItemEspecifica').jqxValidator({
                            onSuccess: function () {
                               
                                var busqueda = $('#txt_Buscar').val();
                                if (busqueda.length >= 4) {
                                    fn_CargarItem(cadenaGasto, busqueda);
                                } else {
                                    $.alert({
                                        theme: 'material',
                                        title: 'AVISO DEL SISTEMA',
                                        content: "Debe ingresar más carateres de busqueda",
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
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../ItemEspecifica",
                data: {mode: 'G', cadenaGasto: cadenaGasto},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        function fn_CargarItem(codigo, texto) {
            $.ajax({
                type: "GET",
                url: "../ItemEspecifica",
                data: {mode: 'M', codigo: texto},
                success: function (data) {
                    var lista = new Array();
                    data = data.replace("[", "");
                    var fila = data.split("[");
                    var data = new Array();
                    for (i = 1; i < fila.length; i++) {
                        var columna = fila[i];
                        var datos = columna.split("+++");
                        while (datos[2].indexOf("]") > 0) {
                            datos[2] = datos[2].replace("]", "");
                        }
                        while (datos[2].indexOf(",") > 0) {
                            datos[2] = datos[2].replace(",", "");
                        }
                        var row = {id: datos[0],
                            parentid: "0",
                            text: datos[2],
                            value: datos[1]};
                        lista.push(row);
                    }
                    var mod = {id: "0",
                        parentid: -1,
                        text: "Seleccione Todos",
                        value: "0"};
                    lista.push(mod);
                    var source = {
                        datatype: "json",
                        datafields: [
                            {name: 'id'},
                            {name: 'parentid'},
                            {name: 'text'},
                            {name: 'value'}
                        ],
                        id: 'id',
                        localdata: lista
                    };
                    var dataAdapter = new $.jqx.dataAdapter(source);
                    dataAdapter.dataBind();
                    var records = dataAdapter.getRecordsHierarchy('id', 'parentid', 'items', [{name: 'text', map: 'label'}]);
                    $('#div_Opciones').jqxTree({source: records});
                    $('#div_Opciones').jqxTree('expandAll');
                    $.ajax({
                        type: "GET",
                        url: "../ItemEspecifica",
                        data: {mode: 'O', codigo: codigo},
                        success: function (data) {
                            data = data.replace("[", "");
                            data = data.replace("]", "");
                            var fila = data.split(",");
                            for (i = 0; i < fila.length; i++) {
                                var dato = "#" + fila[i].trim();
                                $("#div_Opciones").jqxTree('checkItem', $(dato)[0], true);
                            }
                        }
                    });
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var lista = new Array();
            var busca = $("#txt_Buscar").val();
            var items = $('#div_Opciones').jqxTree('getCheckedItems');
            for (var i = 0; i < items.length; i++) {
                var item = items[i];
                if (item.value !== '0')
                    lista.push(item.value);
            }
            $.ajax({
                type: "POST",
                url: "../IduItemEspecifica",
                data: {mode: mode, codigo: codigo, cadenaGasto: cadenaGasto, item: busca, lista: JSON.stringify(lista)},
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
<div id="cbo_Ajax" style='display: none;' ></div>
<div id="div_VentanaPrincipal" style="display: none" >
    <div>
        <span style="float: left">Datos del Item - Especifica Gasto : </span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_ItemEspecifica" name="frm_ItemEspecifica" method="POST"  onsubmit="return false;">        
            <table width="100%" border="0" cellspacing="0" cellpadding="0">                 
                <tr>
                    <td class="inputlabel">Buscar Item : </td>
                    <td><input type="text" id="txt_Buscar" name="txt_Buscar" style="text-transform: uppercase;"/></td> 
                </tr>
                <tr>
                    <td colspan="2" style="align-items: center"> <div id='div_Opciones'></div></td>                    
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
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Eliminar</li>
    </ul>
</div>
