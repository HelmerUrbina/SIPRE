<%-- 
    Document   : ListaDependencia
    Created on : 13/06/2017, 01:45:24 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var unidadOperativa = '${objBnDependencia.unidadOperativa}';
    var codigo = null;
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objDependencia}">
    var result = {codigo: '${d.codigo}', nombre: '${d.nombre}', abreviatura: "${d.abreviatura}",
        estado: "${d.estado}"};
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
                        {name: 'estado', type: "string"}
                    ],
            root: "Dependencia",
            record: "Dependencia",
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
                    codigo = null;
                    $("#txt_Codigo").val('');
                    $("#txt_Nombre").val('');
                    $("#txt_Abreviatura").val('');
                    $("#txt_Codigo").jqxInput({disabled: false});
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ElementosDependientes');
                });
            },
            columns: [
                {text: 'CÓDIGO', dataField: 'codigo', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'NOMBRE', dataField: 'nombre', width: '50%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ABREVIATURA', dataField: 'abreviatura', width: '30%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
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
            codigo = row['codigo'];
            $("#txt_Codigo").val(codigo);
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 500;
                var alto = 160;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_Codigo").jqxInput({placeHolder: 'CÓDIGO', width: 100, height: 20});
                        $("#txt_Nombre").jqxInput({placeHolder: 'ELEMENTO DEPENDIENTE', width: 350, height: 20});
                        $("#txt_Abreviatura").jqxInput({placeHolder: 'ABREVIATURA', width: 250, height: 20});
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
                url: "../Dependencia",
                data: {mode: 'G', unidadOperativa: unidadOperativa},
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
                url: "../Dependencia",
                data: {mode: mode, codigo: codigo, unidadOperativa: unidadOperativa},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 3) {
                        $("#txt_Nombre").val(dato[0]);
                        $("#txt_Abreviatura").val(dato[1]);
                        $("#cbo_Estado").jqxDropDownList('selectItem', dato[2]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var codigo = $("#txt_Codigo").val();
            var nombre = $("#txt_Nombre").val();
            var abreviatura = $("#txt_Abreviatura").val();
            var estado = $("#cbo_Estado").val();
            $.ajax({
                type: "POST",
                url: "../IduDependencia",
                data: {mode: mode, unidadOperativa: unidadOperativa, codigo: codigo,
                    nombre: nombre, abreviatura: abreviatura, estado: estado},
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
        <span style="float: left">Datos del Elemento Dependiente : </span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_Dependencia" name="frm_Dependencia" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">               

                <tr>
                    <td class="inputlabel">Código : </td>
                    <td><input type="text" id="txt_Codigo" name="txt_Codigo"/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Nombre : </td>
                    <td><input type="text" id="txt_Nombre" name="txt_Nombre" style='text-transform:uppercase;'/></td> 
                </tr>                
                <tr>
                    <td class="inputlabel">Abreviatura : </td>
                    <td><input type="text" id="txt_Abreviatura" name="txt_Abreviatura" style='text-transform:uppercase;'/></td>
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