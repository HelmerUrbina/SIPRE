<%-- 
    Document   : ListaProveedores
    Created on : 05/04/2017, 11:16:36 AM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var ruc = '${objBnProveedor.RUC}';
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objProveedor}">
    var result = {ruc: '${d.RUC}', codigo: '${d.codigo}', tipo: '${d.tipo}', razonSocial: '${d.razonSocial}',
        cci: '${d.CCI}', representante: '${d.representante}', dni: '${d.DNI}', telefono: '${d.telefono}',
        direccion: '${d.direccion}', estado: '${d.estado}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'ruc', type: "string"},
                        {name: 'codigo', type: "string"},
                        {name: 'tipo', type: "string"},
                        {name: 'razonSocial', type: "string"},
                        {name: 'cci', type: "string"},
                        {name: 'representante', type: "string"},
                        {name: 'dni', type: "string"},
                        {name: 'telefono', type: "string"},
                        {name: 'direccion', type: "string"},
                        {name: 'estado', type: "string"}
                    ],
            root: "Proveedores",
            record: "Proveedores",
            id: 'ruc'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "ruc") {
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
                    mode = 'I';
                    ruc = null;
                    $("#txt_RUC").val('');
                    $("#txt_RazonSocial").val('');
                    $("#txt_Representante").val('');
                    $("#txt_DNI").val();
                    $("#txt_Direccion").val('');
                    $("#txt_Telefono").val();
                    $("#txt_RUC").jqxInput({disabled: false});
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'Proveedores');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON RECARGAR
                ButtonRecargar.click(function (event) {
                    fn_Refrescar();
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON SALIR
                ButtonSalir.click(function (event) {
                    window.location = "../Login/Principal.jsp";
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '30', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'R.U.C.', dataField: 'ruc', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'CÓDIGO', dataField: 'codigo', width: '3%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'TIPO', dataField: 'tipo', filtertype: 'checkedlist', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'RAZÓN SOCIAL', dataField: 'razonSocial', width: '25%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'C.C.I.', dataField: 'cci', filtertype: 'checkedlist', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'REPRESENTANTE', dataField: 'representante', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DNI', dataField: 'dni', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'TELEFONO', dataField: 'telefono', width: '8%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DIRECCION', dataField: 'direccion', width: '10%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
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
            if (ruc === null || ruc === '') {
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
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            ruc = row['ruc'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 500;
                var alto = 240;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_Tipo").jqxDropDownList({width: 120, height: 20, promptText: "Seleccione"});
                        $("#txt_RUC").jqxInput({placeHolder: 'RUC', width: 100, height: 20});
                        $("#txt_RazonSocial").jqxInput({placeHolder: 'RAZÓN SOCIAL', width: 350, height: 20});
                        $("#txt_Representante").jqxInput({placeHolder: 'REPRESENTANTE', width: 350, height: 20});
                        $("#txt_DNI").jqxMaskedInput({width: 80, height: 20, mask: '########'});
                        $("#txt_Direccion").jqxInput({placeHolder: 'DIRECCIÓN', width: 350, height: 20});
                        $("#txt_Telefono").jqxMaskedInput({width: 100, height: 20, mask: '### ### ###'});
                        $("#cbo_Estado").jqxDropDownList({width: 100, height: 20, promptText: "Seleccione"});
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
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../Proveedores",
                data: {mode: 'G'},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../Proveedores",
                data: {mode: mode, ruc: ruc},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 8) {
                        $("#cbo_Tipo").jqxDropDownList('selectItem', dato[0]);
                        $("#txt_RUC").val(dato[1]);
                        $("#txt_RazonSocial").val(dato[2]);
                        $("#txt_Representante").val(dato[3]);
                        $("#txt_DNI").val(dato[4]);
                        $("#txt_Direccion").val(dato[5]);
                        $("#txt_Telefono").val(dato[6]);
                        $("#cbo_Estado").jqxDropDownList('selectItem', dato[7]);
                        $("#txt_RUC").jqxInput({disabled: true});
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var tipo = $("#cbo_Tipo").val();
            var ruc = $("#txt_RUC").val();
            var razonSocial = $("#txt_RazonSocial").val();
            var representante = $("#txt_Representante").val();
            var dni = $("#txt_DNI").val();
            var direccion = $("#txt_Direccion").val();
            var telefono = $("#txt_Telefono").val();
            var estado = $("#cbo_Estado").val();
            $.ajax({
                type: "POST",
                url: "../IduProveedores",
                data: {mode: mode, ruc: ruc, tipo: tipo, razonSocial: razonSocial, representante: representante,
                    dni: dni, direccion: direccion, telefono: telefono, estado: estado},
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
        <span style="float: left">Datos del Proveedor : </span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_Proveedor" name="frm_Proveedor" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">                
                <tr>
                    <td class="inputlabel">Tipo : </td>
                    <td>
                        <select id="cbo_Tipo" name="cbo_Tipo">
                            <option value="J">JURIDICO</option>
                            <option value="N">NATURAL</option> 
                        </select>
                    </td>                    
                </tr>
                <tr>
                    <td class="inputlabel">R.U.C. : </td>
                    <td><input type="text" id="txt_RUC" name="txt_RUC"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Raz&oacute;n Social : </td>
                    <td><input type="text" id="txt_RazonSocial" name="txt_RazonSocial" style='text-transform:uppercase;'/></td> 
                </tr>                
                <tr>
                    <td class="inputlabel">Representante : </td>
                    <td><input type="text" id="txt_Representante" name="txt_Representante" style='text-transform:uppercase;'/></td>
                </tr>
                <tr>
                    <td class="inputlabel">D.N.I. : </td>
                    <td><input id='txt_DNI' name='txt_DNI'/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Direcci&oacute;n : </td>
                    <td><input type="text" id="txt_Direccion" name="txt_Direccion"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Teléfono  : </td>
                    <td><input id="txt_Telefono" name="txt_Telefono"/></td>
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
    </ul>
</div>
<div id="cbo_Ajax" style='display: none;'></div>