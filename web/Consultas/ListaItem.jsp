<%-- 
    Document   : ListaItem
    Created on : 22/09/2017, 12:12:31 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var codigo = null;
    var lista = new Array();
    <c:forEach var="d" items="${objItem}">
    var result = {codigo: '${d.codigo}', item: '${d.item}', unidadMedida: "${d.unidadMedida}", cadenaGasto: "${d.cadenaGasto}",
        rubro: '${d.rubro}'};
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
                        {name: 'unidadMedida', type: "string"},
                        {name: 'cadenaGasto', type: "string"},
                        {name: 'rubro', type: "string"}
                    ],
            root: "Item",
            record: "Item",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //DEFINIMOS LOS CAMPOS Y DATOS DE LA GRILLA
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 62),
            source: dataAdapter,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showtoolbar: true,
            showfilterrow: true,
            editable: false,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonExportar);
                toolbar.append(container);
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ListadoItem');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'ITEM', dataField: 'item', width: '55%', align: 'center', cellsAlign: 'left'},
                {text: 'CADENA GASTO', dataField: 'cadenaGasto', filtertype: 'checkedlist', width: '25%', align: 'center', cellsAlign: 'left'},
                {text: 'UNIDAD MEDIDA', dataField: 'unidadMedida', filtertype: 'checkedlist', width: '9%', align: 'center', cellsAlign: 'center'},
                {text: 'RUBRO', dataField: 'rubro', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center'}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 32, autoOpenPopup: false, mode: 'popup'});
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
        $("#div_ContextMenu").on('itemclick', function (event) {
            var opcion = event.args;
            if (codigo !== null || codigo === '') {
                if ($.trim($(opcion).text()) === "Ver Item") {
                    fn_VerRegistro();
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'No hay Opcion a Mostar',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'orange',
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
            codigo = row['codigo'];
            $("#txt_Item").val(row['item']);
            $("#txt_UnidadMedida").val(row['unidadMedida']);
            $("#txt_Rubro").val(row['rubro']);
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 550;
                var alto = 130;
                posicionX = (screen.width / 2) - (ancho / 2);
                posicionY = (screen.height / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionY, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_Item").jqxInput({width: 450, height: 20});
                        $("#txt_UnidadMedida").jqxInput({width: 450, height: 20});
                        $("#txt_Rubro").jqxInput({width: 450, height: 20});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
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
        function fn_VerRegistro() {
            $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">ITEM</span>
    </div>
    <div style="overflow: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">                                   
            <tr>
                <td class="inputlabel">Item : </td>
                <td><input type="text" id="txt_Item" name="txt_Item" style="text-transform: uppercase;"/></td>                          
            </tr> 
            <tr>
                <td class="inputlabel">UU/MM : </td>
                <td><input type="text" id="txt_UnidadMedida" name="txt_UnidadMedida" style="text-transform: uppercase;"/></td>                          
            </tr>
            <tr>
                <td class="inputlabel">Rubro : </td>
                <td><input type="text" id="txt_Rubro" name="txt_Rubro" style="text-transform: uppercase;"/></td>                          
            </tr>
            <tr>
                <td class="Summit" colspan="2">
                    <div>
                        <input type="button" id="btn_Cancelar" value="Cerrar" style="margin-right: 20px"/>                            
                    </div>
                </td>
            </tr>
        </table>  

    </div>
</div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Ver Item</li>        
    </ul>
</div>