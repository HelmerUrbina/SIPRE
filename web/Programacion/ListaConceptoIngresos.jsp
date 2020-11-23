<%-- 
    Document   : ListaConceptoIngresos
    Created on : 17/02/2017, 02:55:51 PM
    Author     : H-TECCSI-V
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
    .editedRow {
        color: #b90f0f !important;
        font-style: italic;
    }
</style>
<script type="text/javascript">
    var codGrado = '${objBnIngresosPorGrado.codGrado}';
    var periodo = $("#cbo_Periodo").val();
    var codConcepto = $("#cbo_Concepto").val();
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objIngresosPorGrado}">
    var result = {codigo: '${d.desConcepto}', codGrado: '${d.codGrado}', periodoRee: '${d.periodoRee}',
        abvGrado: '${d.abvGrado}', desGrado: '${d.desGrado}', desPeriodo: '${d.desPeriodo}', ingresoGrado: "${d.ingresoGrado}",
        nivel: '${d.nivelGrado}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var editedRows = new Array();
        var source = {
            localdata: lista,
            datatype: "array",
            updaterow: function (rowid, rowdata, commit) {
                // synchronize with the server - send update command
                // call commit with parameter true if the synchronization with the server is successful 
                // and with parameter false if the synchronization failder.
                var rowindex = $("#div_GrillaPrincipal").jqxGrid('getrowboundindexbyid', rowid);
                editedRows.push({index: rowindex, data: rowdata});
                commit(true);
            },
            datafields:
                    [
                        {name: 'codigo', type: "string"},
                        {name: 'codGrado', type: "string"},
                        {name: 'periodoRee', type: "string"},
                        {name: 'abvGrado', type: "string"},
                        {name: 'desGrado', type: "string"},
                        {name: 'desPeriodo', type: "string"},
                        {name: 'ingresoGrado', type: "number"},
                        {name: 'nivel', type: "number"}
                    ],
            root: "ConceptoIngresos",
            record: "ConceptoIngresos",
            id: 'codigo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "codigo") {
                return "RowBold";
            }
            for (var i = 0; i < editedRows.length; i++) {
                if (editedRows[i].index === row) {
                    return "editedRow";
                }
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
            showaggregates: true,
            showstatusbar: true,
            editable: true,
            statusbarheight: 25,
            //selectionmode: 'singlerow',
            //editmode: 'selectedrow',
            selectionmode: 'multiplecellsadvanced',
            pagesize: 30,
            enabletooltips: true,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonGuardar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/save42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonCargar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonGuardar);
                container.append(ButtonCargar);
                container.append(ButtonExportar);
                toolbar.append(container);
                ButtonGuardar.jqxButton({width: 30, height: 22});
                ButtonGuardar.jqxTooltip({position: 'bottom', content: "Guardar Registro"});
                ButtonCargar.jqxButton({width: 30, height: 22});
                ButtonCargar.jqxTooltip({position: 'bottom', content: "Actualiza Pantalla"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON NUEVO
                ButtonGuardar.click(function (event) {
                    mode = 'I';
                    fn_GrabarDatos();
                });
                // ASIGNAMOS LAS FUNCIONES PARA EL BOTON CARGAR
                ButtonCargar.click(function (event) {
                    fn_Refrescar();
                });
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'ConceptoIngresos');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '10', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'DESCRIPCIÓN', dataField: 'desGrado', editable: false, width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ABREVIATURA', dataField: 'abvGrado', editable: false, width: '10%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'PERIODO REE', dataField: 'desPeriodo', editable: false, width: '10%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'IMPORTE', dataField: 'ingresoGrado', width: '20%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', columntype: 'numberinput', cellclassname: cellclass, aggregates: ['sum'],
                    validation: function (cell, value) {
                        if (value < 0) {
                            return {result: false, message: "Importe Invalido, Revise!!.."};
                        }
                        return true;
                    },
                    createeditor: function (row, cellvalue, editor) {
                        editor.jqxNumberInput({decimalDigits: 2, digits: 9});
                    }
                }
            ]
        });
        /*
         // DEFINIMOS EL MENU CONTEXTUAL
         var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 57, autoOpenPopup: false, mode: 'popup'});
         $("#div_GrillaPrincipal").on('contextmenu', function () {
         return false;
         });*/
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
            if (codGrado === null || codGrado === '') {
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
            codGrado = row['codGrado'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: 400, y: 200},
                    width: 600, height: 155, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_desConcepto").jqxInput({placeHolder: 'INGRESE NOMBRE DEL CONCEPTO', width: 400, height: 20});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function (event) {
                            $('#frm_ConceptoIngresos').jqxValidator('validate');
                        });
                        $('#frm_ConceptoIngresos').jqxValidator({
                            rules: [
                                {input: '#txt_desConcepto', message: 'Ingrese el Nombre del Concepto!', action: 'keyup, blur', rule: 'required'}
                            ]
                        });
                        $('#frm_ConceptoIngresos').jqxValidator({
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
        });
        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../ConceptoIngresos",
                data: {mode: 'G', periodo: periodo, codConcepto: codConcepto},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var msg = "";
            var lista = new Array();
            var result;
            var rows = $('#div_GrillaPrincipal').jqxGrid('getrows');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                result = row.codGrado + "---" + row.ingresoGrado + "---" + row.periodoRee + "---" + row.nivel;
                //if(parseFloat(row.ingresoGrado)>0){
                lista.push(result);
                //}
            }
            $.ajax({
                type: "POST",
                url: "../IduIngresosPorGrado",
                data: {mode: mode, periodo: periodo, codConcepto: codConcepto,
                    lista: JSON.stringify(lista)},
                success: function (data) {
                    msg = data;
                    if (msg === "GUARDO") {
                        $.confirm({
                            title: 'AVISO DEL SISYEMA',
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
        <span style="float: left">CONCEPTO REMUNERACIONES</span>
    </div>
    <div style="overflow: hidden">
        <form id="frm_ConceptoIngresos" name="frm_ConceptoIngresos" method="post" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="inputlabel">Descripción : </td>
                    <td><input type="text" id="txt_desConcepto" name="txt_desConcepto" style="text-transform: uppercase;"/></td>
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