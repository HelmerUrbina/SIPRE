<%-- 
    Document   : ListaDecreto
    Created on : 20/07/2017, 10:59:39 AM
    Author     : H-TECCSI-V
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = $("#cbo_Periodo").val();
    var tipo = "E";
    var mes = $("#cbo_Mes").val();
    var estadoDoc = $("#cbo_Estado").val();
    var codigo = null;
    var archivo = null;
    var codigoUsuario = '';
    var codInstitucion = '';
    var estado = '';
    var mode = null;
    var msg = '';
    var lista = new Array();
    <c:forEach var="d" items="${objDocumentos}">
    var result = {numero: '${d.numero}', numeroDocumento: '${d.numeroDocumento}', asunto: '${d.asunto}',
        subGrupo: '${d.subGrupo}', prioridad: '${d.prioridad}', fecha: '${d.fecha}', firma: '${d.hora}',
        referencia: "${d.referencia}", responsable: '${d.usuarioResponsable}',
        archivo: '${d.archivo}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DEL DETALLE
        var sourceDetalle = {
            datatype: "array",
            datafields:
                    [
                        {name: "codDetalle", type: "number"},
                        {name: "usuario", type: "string"},
                        {name: "prioridad", type: "string"},
                        {name: "comentario", type: "string"},
                        {name: "fechaD", type: "string"},
                        {name: "fechaR", type: "string"},
                        {name: "estadoDoc", type: "string"}
                    ],
            addrow: function (rowid, rowdata, position, commit) {
                commit(true);
            },
            updaterow: function (rowid, rowdata, commit) {
                commit(true);
            }
        };
        var dataDetalle = new $.jqx.dataAdapter(sourceDetalle);
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'numero', type: "string"},
                        {name: 'numeroDocumento', type: "string"},
                        {name: 'asunto', type: "string"},
                        {name: 'subGrupo', type: "string"},
                        {name: 'prioridad', type: "string"},
                        {name: 'fecha', type: "date", format: 'dd/MM/yyyy'},
                        {name: 'firma', type: "string"},
                        {name: 'referencia', type: "string"},
                        {name: 'responsable', type: "string"},
                        {name: 'archivo', type: "string"}
                    ],
            root: "Decreto",
            record: "Decreto",
            id: 'numero'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "numero") {
                return "RowBold";
            }
            if (datafield === "subGrupo") {
                return "RowPurple";
            }
            if (datafield === "responsable") {
                return "RowBlue";
            }
        };
        var cellclassDet = function (row, datafield, value, rowdata) {
            if (rowdata['estadoDoc'] === "DOC") {
                return "RowBrown";
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
            showtoolbar: true,
            sortable: true,
            pageable: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            showfilterrow: true,
            editable: false,
            rendertoolbar: function (toolbar) {
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonExportar);
                toolbar.append(container);
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'DecretoDocumentos');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: 10, pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'CÓDIGO', dataField: 'numero', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DOCUMENTO', dataField: 'numeroDocumento', width: '9%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ASUNTO', dataField: 'asunto', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'INSTITUCIÓN', dataField: 'subGrupo', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'PRIORIDAD', dataField: 'prioridad', filtertype: 'checkedlist', width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FEC. DOC', dataField: 'fecha', columntype: 'datetimeinput', filtertype: 'date', width: '8%', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'FIRMA', dataField: 'firma', width: '8%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'RESPONSABLE', dataField: 'responsable', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'REFERENCIA', dataField: 'referencia', width: '9%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'ARCHIVO', dataField: 'archivo', width: '9%', align: 'center', cellsAlign: 'left', cellclassname: cellclass}
            ]
        });
        //DEFINIMOS CAMPOS DE LA GRILLA DE CONSULTA
        $("#div_GrillaDetalle").jqxGrid({
            width: '100%',
            height: 350,
            source: dataDetalle,
            pageable: true,
            columnsresize: true,
            altrows: false,
            editable: false,
            statusbarheight: 25,
            autoheight: false,
            autorowheight: false,
            sortable: true,
            pagesize: 10,
            columns: [
                {text: 'CODIGO', datafield: 'codDetalle', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclassDet},
                {text: 'USUARIO', datafield: 'usuario', width: '25%', align: 'center', cellsAlign: 'left', cellclassname: cellclassDet},
                {text: 'PRIORIDAD', datafield: 'prioridad', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclassDet},
                {text: 'COMENTARIO', datafield: 'comentario', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclassDet},
                {text: 'FEC. DECRETO', datafield: 'fechaD', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclassDet},
                {text: 'FEC. RECIBIDO', datafield: 'fechaR', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclassDet}
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
            if ($.trim($(opcion).text()) === "Decretar") {
                if (estadoDoc !== 'PE') {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: "Opción no valida, documento ya se encuentra decretado",
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'orange',
                        typeAnimated: true
                    });
                } else {
                    mode = 'I';
                    fn_Decretar();
                }
            } else if ($.trim($(opcion).text()) === "Seguimiento Decreto") {
                if (estadoDoc === 'PE') {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: "No hay Opción a mostrar, aun no se ha decretado el documento.",
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'orange',
                        typeAnimated: true
                    });
                } else {
                    mode = 'U';
                    fn_SeguimientoDecreto();
                }
            } else if ($.trim($(opcion).text()) === "Ver Documento") {
                if (archivo !== null && archivo !== '') {
                    document.location.target = "_blank";
                    document.location.href = "../Descarga?opcion=MesaParte&periodo=" + periodo + "&codigo=" + tipo + "-" + codigo + "&documento=" + archivo;
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
            } else {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: "No hay Opción a mostrar",
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
            }
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['numero'];
            estado = row['estado'];
            archivo = row['archivo'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 600;
                var alto = 275;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_Comentario").jqxInput({placeHolder: "Ingrese un Comentario", height: 80, width: 400, minLength: 1});
                        $("#cbo_UsuarioEmision").jqxDropDownList({animationType: 'fade', width: 350, height: 20});
                        $("#cbo_Area").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                        $('#cbo_Area').on('change', function () {
                            var codigo = $("#cbo_Area").val();
                            fn_cargarComboAjax("#cbo_Usuario", {mode: 'usuarioMesaParte', periodo: periodo, codigo: codigo});
                            $("#cbo_Usuario").jqxDropDownList('clear');
                        });
                        $("#cbo_Prioridad").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                        $("#cbo_TipoDecretos").jqxDropDownList({animationType: 'fade', checkboxes: true, width: 440, height: 20, dropDownWidth: 500});
                        $("#cbo_Usuario").jqxDropDownList({animationType: 'fade', width: 350, height: 20});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            var msg = "";
                            if (msg === "")
                                msg = fn_verificarUsuarioEmisor();
                            if (msg === "")
                                msg = fn_verificarPrioridad();
                            if (msg === "")
                                msg = fn_verificarArea();
                            if (msg === "")
                                msg = fn_verificarUsuario();
                            if (msg === "") {
                                $('#frm_Decreto').jqxValidator('validate');
                            }
                        });
                        $('#frm_Decreto').jqxValidator({
                            rules: [
                                {input: '#txt_Comentario', message: 'Ingrese un comentatio', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_Decreto').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatos();
                            }
                        });
                    }
                });
                //INICIALIZAMOS LOS VALORES DE LA VENTANA DE DETALLE
                var ancho = 700;
                var alto = 465;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaDetalle').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_UsuarioEmisionDet").jqxDropDownList({animationType: 'fade', width: 350, height: 20, disabled: true});
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
        //FUNCION PARA VER EL SEGUIMIENTO DEL DECRETO
        function fn_SeguimientoDecreto() {
            $.ajax({
                type: "GET",
                url: "../Decreto",
                data: {mode: 'U', periodo: periodo, tipo: tipo, numero: codigo},
                success: function (result) {
                    var dato = result.split("+++");
                    if (dato.length === 1) {
                        $("#cbo_UsuarioEmisionDet").val(dato[0]);
                        $('#div_GrillaDetalle').jqxGrid('clear');
                        $.ajax({
                            type: "GET",
                            url: "../Decreto",
                            data: {mode: 'B', periodo: periodo, tipo: tipo, numero: codigo},
                            success: function (data) {
                                var fechaRecibido = "";
                                data = data.replace("[", "");
                                var fila = data.split("[");
                                var rows = new Array();
                                for (i = 1; i < fila.length; i++) {
                                    var columna = fila[i];
                                    var datos = columna.split("+++");
                                    while (datos[6].indexOf(']') > 0) {
                                        datos[6] = datos[6].replace("]", "");
                                    }
                                    while (datos[6].indexOf(',') > 0) {
                                        datos[6] = datos[6].replace(",", "");
                                    }
                                    if (datos[5] === 'null') {
                                        fechaRecibido = "";
                                    } else {
                                        fechaRecibido = datos[5];
                                    }
                                    var row = {codDetalle: datos[0], usuario: datos[1], prioridad: datos[2], comentario: datos[3],
                                        fechaD: datos[4], fechaR: fechaRecibido, estadoDoc: datos[6]};
                                    rows.push(row);
                                }
                                if (rows.length > 0)
                                    $("#div_GrillaDetalle").jqxGrid('addrow', null, rows);
                            }
                        });
                    }
                }
            });
            $('#div_VentanaDetalle').jqxWindow({isModal: true});
            $('#div_VentanaDetalle').jqxWindow('open');
        }
        //FUNCION PARA DECRETAR DOCUMENTACION
        function fn_Decretar() {
            $("#cbo_Area").jqxDropDownList('selectItem', 0);
            $("#cbo_Usuario").jqxDropDownList('selectItem', 0);
            $("#txt_Comentario").val('CONOCIMIENTO, EXPLOTACIÓN Y TRAMITE SEGUN NORMA.');
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA VERIFICAR LA PRIORIDAD
        function fn_verificarPrioridad() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_Prioridad").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione la prioridad";
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
        //FUNCION PARA VERIFICAR EL AREA
        function fn_verificarArea() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_Area").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el area";
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
        //FUNCION PARA VERIFICAR EL USUARIO
        function fn_verificarUsuario() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_Usuario").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el usuario";
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
        //FUNCION PARA VERIFICAR EL USUARIO EMISION
        function fn_verificarUsuarioEmisor() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_UsuarioEmision").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el usuario";
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
            $("#div_GrillaPrincipal").remove();
            $("#div_VentanaDetalle").remove();
            $("#cbo_Ajax").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../Decreto",
                data: {mode: 'G', periodo: periodo, mes: mes, tipo: tipo, estadoDoc: estadoDoc},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var usuarioEmision = $("#cbo_UsuarioEmision").val();
            var prioridad = $("#cbo_Prioridad").val();
            var area = $("#cbo_Area").val();
            var usuario = $("#cbo_Usuario").val();
            var tipoDecretos = $("#cbo_TipoDecretos").jqxDropDownList('getCheckedItems');
            var comentario = $("#txt_Comentario").val();
            var result = "";
            var lista = new Array();
            $.each(tipoDecretos, function (index) {
                result = this.value;
                lista.push(result);
            });
            $.ajax({
                type: "POST",
                url: "../IduDecretarDocumentacion",
                data: {mode: mode, periodo: periodo, numero: codigo, tipo: tipo, usuarioEmision: usuarioEmision, area: area,
                    usuario: usuario, comentario: comentario, prioridad: prioridad, lista: JSON.stringify(lista), decreto: 0},
                success: function (data) {
                    msg = data;
                    if (msg === "GUARDO") {
                        $.confirm({
                            title: 'AVISO DEL SISTEMA',
                            content: 'Datos procesados correctamente',
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
        <span style="float: left">DECRETAR DOCUMENTACIÓN</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_Decreto" name="frm_Decreto" method="post">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Decretado por : </td>
                    <td>
                        <select id="cbo_UsuarioEmision" name="cbo_UsuarioEmision">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objUsuarioJefatura}">
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Prioridad : </td>
                    <td>
                        <select id="cbo_Prioridad" name="cbo_Prioridad">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objPrioridad}">
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Area : </td>
                    <td>
                        <select id="cbo_Area" name="cbo_Area">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objArea}">
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Usuario : </td>
                    <td>
                        <select id="cbo_Usuario" name="cbo_Usuario">
                            <option value="0">Seleccione</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Decreto : </td>
                    <td>
                        <select id="cbo_TipoDecretos" name="cbo_TipoDecretos">
                            <c:forEach var="d" items="${objTipoDecreto}">
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Comentario : </td>
                    <td><textarea id="txt_Comentario" name="txt_Comentario" style="text-transform: uppercase;"></textarea>
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
<div id="div_VentanaDetalle" style="display: none">
    <div>
        <span style="float: left">SEGUIMIENTO DE LA DOCUMENTACIÓN</span>
    </div>
    <div style="overflow: hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="inputlabel">Decretado Inicial : </td>
                <td>
                    <select id="cbo_UsuarioEmisionDet" name="cbo_UsuarioEmisionDet">
                        <option value="0">Seleccione</option>
                        <c:forEach var="f" items="${objUsuarioJefatura}">
                            <option value="${f.codigo}">${f.descripcion}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="inputlabel">&zwj;</td>
            </tr>
            <tr>
                <td colspan="4"><div id="div_GrillaDetalle"> </div></div></td>  
            </tr>
            <tr>
                <td class="Summit" colspan="4">
                    <div>
                        <input type="button" id="btn_Cancelar" value="Salir" style="margin-right: 20px"/>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</div>
<div id='div_ContextMenu' style='display:none;'>
    <ul>
        <li style="font-weight: bold;">Decretar</li>
        <li style="font-weight: bold; color: blue;">Seguimiento Decreto</li>
        <li type='separator'></li>
        <li style="font-weight: bold; color: maroon;">Ver Documento</li>
    </ul>
</div>