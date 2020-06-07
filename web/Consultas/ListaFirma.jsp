<%-- 
    Document   : ListaFirma
    Created on : 26/09/2017, 04:33:39 PM
    Author     : H-URBINA-M
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var unidadOperativa = $("#cbo_UnidadOperativa").val();
    var codigo = null;
    var mode = null;
    var archivo = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objFirma}">
    var result = {codigo: '${d.codigo}', nivel: '${d.nivel}', responsable: '${d.documento}', cargo: '${d.opcion}',
        grado: '${d.concepto}'.substr(0, 3), gradoDescripcion: '${d.concepto}'.substr(4), fechaInicio: "${d.inicio}",
        fechaFin: '${d.fin}', estado: "${d.estado}", proceso: "${d.periodo}", archivo: '${d.archivo}'};
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
                        {name: 'nivel', type: "string"},
                        {name: 'responsable', type: "string"},
                        {name: 'cargo', type: "string"},
                        {name: 'grado', type: "string"},
                        {name: 'gradoDescripcion', type: "string"},
                        {name: "fechaInicio", type: "string"},
                        {name: "fechaFin", type: "string"},
                        {name: 'proceso', type: "string"},
                        {name: 'estado', type: "string"},
                        {name: 'archivo', type: "string"}
                    ],
            root: "Firma",
            record: "Firma",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "nivel") {
                return "RowBold";
            }
        };
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
                    var fecha = new Date();
                    $.ajax({
                        type: "GET",
                        url: "../Firmas",
                        data: {mode: mode, periodo: periodo, unidadOperativa: unidadOperativa},
                        success: function (data) {
                            codigo = data;
                        }
                    });
                    $("#div_Nivel").val(0);
                    $("#txt_Responsable").val('');
                    $("#cbo_Grado").jqxDropDownList('setContent', 'Seleccione');
                    $("#txt_Cargo").val('');
                    $("#txt_FechaInicio").val('01/01/' + fecha.getFullYear());
                    $("#txt_FechaFin").val('31/12/' + fecha.getFullYear());
                    $("#cbo_Estado").jqxDropDownList('selectItem', 'AC');
                    $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.9});
                    $('#div_VentanaPrincipal').jqxWindow('open');
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'RegistroFirma');
                });
            },
            columns: [
                {text: 'Nro', align: 'center', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '3%', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'NIVEL', dataField: 'nivel', width: '5%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'RESPONSABLE', dataField: 'responsable', width: '25%', align: 'center', cellclassname: cellclass},
                {text: 'GRADO', dataField: 'gradoDescripcion', filtertype: 'checkedlist', width: '11%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'CARGO', dataField: 'cargo', filtertype: 'checkedlist', width: '11%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DESDE', dataField: 'fechaInicio', columntype: 'datetimeinput', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'HASTA', dataField: 'fechaFin', columntype: 'datetimeinput', filtertype: 'date', width: '7%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'checkedlist', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'PROCESO', dataField: 'proceso', filtertype: 'checkedlist', width: '7%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ARCHIVO', dataField: 'archivo', width: '18%', align: 'center', cellclassname: cellclass}
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
                    mode = 'U';
                    fn_EditarRegistro();
                } else if ($.trim($(opcion).text()) === "Ver Documento") {
                    if (archivo !== null && archivo !== '') {
                        document.location.target = "_blank";
                        document.location.href = "../Descarga?opcion=Firma&periodo=" + periodo + "&unidadOperativa=" + unidadOperativa + "&codigo=" + codigo + "&documento=" + archivo;
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'No existe Archivo a Vizualizar!!!',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                } else if ($.trim($(opcion).text()) === "Aprobar") {
                    mode = 'A';
                    fn_GrabarDatos();
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
            archivo = row['archivo'];
            $("#div_Nivel").val(row['nivel']);
            $("#txt_Responsable").val(row['responsable']);
            $("#cbo_Grado").jqxDropDownList('selectItem', row['grado'].substr(0, 3));
            $("#txt_Cargo").val(row['cargo']);
            $("#txt_FechaInicio").val(row['fechaInicio']);
            $("#txt_FechaFin").val(row['fechaFin']);
            $("#cbo_Estado").jqxDropDownList('selectItem', row['estado'].substr(0, 2));
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 510;
                var alto = 255;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#div_Nivel").jqxNumberInput({width: 100, height: 20, decimalDigits: 0, inputMode: 'simple', spinButtons: true});
                        $("#cbo_Grado").jqxDropDownList({width: 250, height: 20, dropDownWidth: 320});
                        $("#txt_Responsable").jqxInput({placeHolder: 'APELLIDOS Y NOMBRES', width: 400, height: 20});
                        $("#txt_Cargo").jqxInput({placeHolder: 'CARGO', width: 400, height: 20});
                        $("#txt_FechaInicio").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#txt_FechaFin").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#cbo_Estado").jqxDropDownList({width: 100, height: 20, dropDownWidth: 150, promptText: "Seleccione"});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            $('#frm_Firma').jqxValidator('validate');
                        });
                        $('#frm_Firma').jqxValidator({
                            rules: [
                                {input: '#txt_Responsable', message: 'Ingrese los Nombres y Apellidos!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Cargo', message: 'Ingrese el Cargo!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_Firma').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatos();
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
            fn_cargarComboAjax("#cbo_Grado", {mode: 'grados', codigo: 1});
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../Firmas",
                data: {mode: 'G', periodo: periodo, unidadOperativa: unidadOperativa},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            mode = 'U';
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var nivel = $("#div_Nivel").val();
            var grado = $("#cbo_Grado").val();
            var responsable = $("#txt_Responsable").val();
            var cargo = $("#txt_Cargo").val();
            var inicio = $("#txt_FechaInicio").val();
            var fin = $("#txt_FechaFin").val();
            var estado = $("#cbo_Estado").val();
            var archivo = $("#txt_Archivo").val();
            
            if (archivo !== '' || (mode!=='A' || mode!=='D')) {
                var formData = new FormData(document.getElementById("frm_Firma"));
                formData.append("mode", mode);
                formData.append("periodo", periodo);
                formData.append("unidadOperativa", unidadOperativa);
                formData.append("codigo", codigo);
                formData.append("nivel", nivel);
                formData.append("grado", grado);
                formData.append("responsable", responsable);
                formData.append("cargo", cargo);
                formData.append("inicio", inicio);
                formData.append("fin", fin);
                formData.append("estado", estado);
                formData.append("archivo", archivo);
                $.ajax({
                    type: "POST",
                    url: "../IduFirmas",
                    data: formData,
                    dataType: "html",
                    cache: false,
                    contentType: false,
                    processData: false,
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
            } else {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: "Debe Seleccionar un Archivo a subir!!!.",
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            }
        }
    });
</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">Registro de Firma : </span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_Firma" name="frm_Firma" enctype="multipart/form-data" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">                
                <tr>
                    <td class="inputlabel">Nivel : </td>
                    <td><div id='div_Nivel'></div></td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Grado : </td>
                    <td>
                        <select id="cbo_Grado" name="cbo_Grado">
                            <option value="0">Seleccione</option>                            
                        </select>
                    </td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Responsable : </td>
                    <td><input type="text" id="txt_Responsable" name="txt_Responsable" style='text-transform:uppercase;'/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Cargo : </td>
                    <td><input type="text" id="txt_Cargo" name="txt_Cargo" style='text-transform:uppercase;'/></td> 
                </tr>                
                <tr>
                    <td class="inputlabel">Inicio : </td>
                    <td><div id="txt_FechaInicio"></td>
                </tr>
                <tr>
                    <td class="inputlabel">Fin : </td>
                    <td><div id="txt_FechaFin"></td>
                </tr>  
                <tr>
                    <td class="inputlabel">Documento : </td>
                    <td><input type="file" name="txt_Archivo" id="txt_Archivo" style="text-transform: uppercase; width: 400px;height: 30px" class="name form-control" multiple/></td>
                </tr>
                <tr>
                    <td class="inputlabel">Estado : </td>
                    <td>
                        <select id="cbo_Estado" name="cbo_Estado">
                            <option value="AC">ACTIVO</option>
                            <option value="IN">INACTIVO</option>
                            <option value="AN">ANULADO</option>
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
        <li>Ver Documento</li>  
        <li type='separator'></li>
        <li>Aprobar</li>
    </ul>
</div>