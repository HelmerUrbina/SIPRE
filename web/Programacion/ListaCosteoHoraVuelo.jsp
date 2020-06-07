<%-- 
    Document   : ListaCosteoHoraVuelo
    Created on : 08/05/2017, 03:34:46 PM
    Author     : H-TECCSI-V
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnHoraVuelo.periodo}';
    var codigoAeronave = '${objBnHoraVuelo.codigoAeronave}';
    var aeronave = '${objBnHoraVuelo.aeronave}';
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objHoraVuelo}">
    var result = {codigo: '${d.codigoCosteo}', tipoCosto: '${d.tipoCosto}', cadenaGasto: '${d.cadenaGasto}',
        importe: '${d.importe}'};
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
                        {name: 'tipoCosto', type: "string"},
                        {name: 'cadenaGasto', type: "string"},
                        {name: 'importe', type: "number"}
                    ],
            root: "HoraVuelo",
            record: "HoraVuelo",
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
            showtoolbar: true,
            filterable: true,
            autoshowfiltericon: true,
            showaggregates: true,
            showstatusbar: true,
            columnsresize: true,
            showfilterrow: true,
            editable: false,
            pagesize: 30,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonActualizar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");

                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
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
                    //$("#div_VentanaPrincipal").remove();
                    $("#cbo_cadenaGasto").jqxDropDownList({disabled: false});
                    $("#cbo_tipoCosto").jqxDropDownList({disabled: false});
                    $("#cbo_cadenaGasto").jqxDropDownList('selectItem', 0);
                    $("#cbo_tipoCosto").jqxDropDownList('selectItem', 0);
                    $("#div_importe").val('0');
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });


                // Recarga la Data en la Grilla
                ButtonActualizar.click(function (event) {
                    fn_Refrescar();
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'CosteoHoraVuelo');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '10', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'TIPO COSTO', dataField: 'tipoCosto', width: '15%', filtertype: 'checkedlist', columngroup: 'Aeronave', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'CADENA DE GASTO', dataField: 'cadenaGasto', width: '30%', filtertype: 'checkedlist', columngroup: 'Aeronave', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'importe', columngroup: 'Aeronave', align: 'center', width: '15%', cellsAlign: 'right', cellsFormat: 'f2', columntype: 'numberinput', cellclassname: cellclass, aggregates: ['sum']}
            ],
            columngroups: [
                {text: '<strong>CONSULTA DE COSTOS POR AERONAVE</strong>', name: 'Titulo', align: 'center'},
                {text: 'TIPO DE AERONAVE : <strong>' + aeronave + '</strong>', name: 'Aeronave', parentgroup: 'Titulo'}
            ]
        });
        // DEFINIMOS EL MENU CONTEXTUAL
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 85, autoOpenPopup: false, mode: 'popup'});
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
                    $("#cbo_cadenaGasto").jqxDropDownList('selectItem', 0);
                    $("#cbo_tipoCosto").jqxDropDownList('selectItem', 0);
                    $("#div_importe").val('0');

                    mode = 'B';
                    fn_EditarRegistro();
                } else {
                    if ($.trim($(opcion).text()) === "Eliminar") {
                        fn_Eliminar();
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
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: 400, y: 250},
                    width: 500, height: 190, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_cadenaGasto").jqxDropDownList({width: 350, height: 20});
                        $("#cbo_tipoCosto").jqxDropDownList({width: 350, height: 20});
                        $('#div_importe').jqxNumberInput({width: 150, height: 20, max: 999999999, digits: 6, decimalDigits: 2});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            var msg = "";
                            if (msg === "")
                                msg = fn_verificarTipoCosto();
                            if (msg === "")
                                msg = fn_verificarCadenaGasto();
                            if (msg === "")
                                msg = fn_validarImporte();
                            if (msg === "")
                                fn_GrabarDatos();
                        });
                    }
                });
            }
            return {init: function () {
                    _createElements();
                    fn_cargarComboAjax("#cbo_cadenaGasto", {mode: 'cadGasHoraVuelo'});
                }
            };
        }());
        $(document).ready(function () {
            customButtonsDemo.init();
        });

        //FUNCION PARA VERIFICAR EL REGISTRO DEL IMPORTE
        function fn_validarImporte() {
            var msg = "";
            var dato = "";
            dato = $("#div_importe").val();
            dato = parseFloat(dato);
            if (dato <= 0) {
                msg = "Ingrese el importe";
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
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_VentanaDetalle").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../HoraVuelo",
                data: {mode: 'GD', periodo: periodo, codigoAeronave: codigoAeronave, aeronave: aeronave},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA ANULAR LOS REGISTROS
        function fn_Eliminar() {
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
            fn_cargarComboAjax("#cbo_cadenaGasto", {mode: 'cadGasHoraVuelo'});
            $("#cbo_cadenaGasto").jqxDropDownList({disabled: true});
            $("#cbo_tipoCosto").jqxDropDownList({disabled: true});
            $.ajax({
                type: "GET",
                url: "../HoraVuelo",
                data: {mode: mode, periodo: periodo, codigoCosteo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 3) {
                        $("#cbo_tipoCosto").jqxDropDownList('selectItem', dato[0]);
                        $("#cbo_cadenaGasto").jqxDropDownList('selectItem', dato[1]);
                        $("#div_importe").val(dato[2]);
                    }
                }
            });
            mode = 'U';
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }

        //FUNCION PARA VERIFICAR SE SELECCIONE UNA CADENA DE GASTO
        function fn_verificarCadenaGasto() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_cadenaGasto").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione la Cadena de Gasto";
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
        //FUNCION PARA VERIFICAR SE SELECCIONE UNA TIPO DE COSTO
        function fn_verificarTipoCosto() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_tipoCosto").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el tipo de costo";
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
            var cadenaGasto = $("#cbo_cadenaGasto").val();
            var tipoCosto = $("#cbo_tipoCosto").val();
            var importe = $("#div_importe").val();
            $.ajax({
                type: "POST",
                url: "../IduCosteoHoraVuelo",
                data: {mode: mode, periodo: periodo, codigoAeronave: codigoAeronave, codigoCosteo: codigo,
                    cadenaGasto: cadenaGasto, importe: importe, tipoCosto: tipoCosto},
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
        <span style="float: left">REGISTRO COSTO HORAS DE VUELO</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_CostoHorasVuelo" name="frm_CostoHorasVuelo" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">

                <tr>
                    <td class="inputlabel">Tipo Costo : </td>
                    <td>
                        <select id="cbo_tipoCosto" name="cbo_tipoCosto">
                            <option value="0">Seleccione</option>
                            <option value="CD">COSTOS DIRECTOS</option> 
                            <option value="CI">COSTOS INDIRECTOS</option> 
                        </select>
                    </td>                    
                </tr>                 
                <tr>
                    <td class="inputlabel">Cadena Gasto : </td>
                    <td>
                        <select id="cbo_cadenaGasto" name="cbo_cadenaGasto">
                            <option value="0">Seleccione</option> 
                        </select>
                    </td>                    
                </tr>

                <tr>
                    <td class="inputlabel">Importe : </td>
                    <td><div id="div_importe"></div> </td>  
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

<div id="cbo_Ajax" style='display: none;'></div>
<div id='div_ContextMenu' style='display: none;'>
    <ul>
        <li>Editar</li>
        <li>Eliminar</li>
    </ul>
</div>
