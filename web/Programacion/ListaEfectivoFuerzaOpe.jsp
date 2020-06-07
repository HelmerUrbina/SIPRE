<%-- 
    Document   : ListaEfectivoFuerzaOpe
    Created on : 18/04/2017, 03:17:15 PM
    Author     : hateccsiv
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
    .editedRow {
        color: #b90f0f !important;
        font-style: italic;
    }
</style>
<script type="text/javascript">
    var periodo = '${objBnFuerzaOperativa.periodo}';
    var codFuerzaOpe = '${objBnFuerzaOperativa.codigo}';
    var unidad = '${objBnFuerzaOperativa.unidadOperativa}';
    var depen = '${objBnFuerzaOperativa.dependencia}';
    var tipoFuerza = '${objBnFuerzaOperativa.comentario}';
    var codigoCab='${objBnFuerzaOperativa.codigoDepartamento}';
    var departamento='${objBnFuerzaOperativa.dependenciaDetalle}';
    var nomDependencia='${objBnFuerzaOperativa.desactivacion}';
    var unidadAnt='${objBnFuerzaOperativa.nombreDependencia}';
    var mode = null;
    var msg = "";
    var lista = new Array();
    <c:forEach var="d" items="${objEfectivoFuerzaOpe}">
    var result = {codGrado: '${d.codigo}', nomGrado: '${d.dependencia}', abrGrado: '${d.dependenciaDetalle}',
        periodoRee: '${d.periodoREE}', remuneracion: '${d.remuneracion}', cantidad: '${d.cantidadOficina}',
        total: '${d.totalRemuneracion}', codGrd: '${d.codigoDepartamento}', perRee: '${d.comentario}',
        nivel: '${d.estado}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var editedRows = new Array();
        var source = {
            localdata: lista,
            datatype: "array",
            updaterow: function (rowid, rowdata, commit) {
                // that function is called after each edit.
                var rowindex = $("#div_GrillaPrincipal").jqxGrid('getrowboundindexbyid', rowid);
                editedRows.push({index: rowindex, data: rowdata});
                // synchronize with the server - send update command
                // call commit with parameter true if the synchronization with the server is successful 
                // and with parameter false if the synchronization failder.
                commit(true);
            },
            datafields:
                    [
                        {name: 'codGrado', type: "string"},
                        {name: 'nomGrado', type: "string"},
                        {name: 'abrGrado', type: "string"},
                        {name: 'periodoRee', type: "string"},
                        {name: 'remuneracion', type: "number"},
                        {name: 'cantidad', type: "number"},
                        {name: 'total', type: "number"},
                        {name: 'codGrd', type: "string"},
                        {name: 'perRee', type: "string"},
                        {name: 'nivel', type: "string"}
                    ],
            root: "EfectivoFuerzaOperativa",
            record: "EfectivoFuerzaOperativa",
            id: 'codGrado'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "codGrado") {
                return "RowBold";
            }
            for (var i = 0; i < editedRows.length; i++) {
                if (editedRows[i].index == row) {
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
            pagesize: 80,
            enabletooltips: true,
            rendertoolbar: function (toolbar) {
                // ADICIONAMOS BOTONES A LA BARRA DE ESTADOS
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonGuardar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/save42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonCargar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var regresarButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/right42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonGuardar);
                container.append(ButtonCargar);
                container.append(ButtonExportar);
                container.append(regresarButton);
                toolbar.append(container);
                ButtonGuardar.jqxButton({width: 30, height: 22});
                ButtonGuardar.jqxTooltip({position: 'bottom', content: "Guardar Registro"});
                ButtonCargar.jqxButton({width: 30, height: 22});
                ButtonCargar.jqxTooltip({position: 'bottom', content: "Actualiza Pantalla"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                regresarButton.jqxButton({width: 50, height: 22});
                regresarButton.jqxTooltip({position: 'bottom', content: "Regresar"});
                
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
                //
                regresarButton.click(function (event) {
                    fn_RegresarUnidad();
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '10', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'PERSONAL', dataField: 'nivel', editable: false, filtertype: 'checkedlist', columngroup: 'Unidad', width: '15%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DESCRIPCIÓN', dataField: 'nomGrado', editable: false, filtertype: 'checkedlist', columngroup: 'Unidad', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'ABREVIATURA', dataField: 'abrGrado', editable: false, filtertype: 'checkedlist', columngroup: 'Unidad', width: '10%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'PERIODO REE', dataField: 'periodoRee', editable: false, filtertype: 'checkedlist', columngroup: 'Unidad', width: '10%', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'REMUNERACIÓN MENSUAL', dataField: 'remuneracion', editable: false, columngroup: 'Unidad', width: '12%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', columntype: 'numberinput', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'N° EFECTIVO', dataField: 'cantidad', columngroup: 'Unidad', width: '12%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', columntype: 'numberinput', cellclassname: cellclass, aggregates: ['sum'],
                    validation: function (cell, value) {
                        if (value < 0) {
                            return {result: false, message: "Importe Invalido, Revise!!.."};
                        }
                        return true;
                    },
                    createeditor: function (row, cellvalue, editor) {
                        editor.jqxNumberInput({decimalDigits: 2, digits: 9});
                    }
                },
                {text: 'TOTAL', dataField: 'total', editable: false, columngroup: 'Unidad', width: '12%', align: 'right', cellsAlign: 'right',
                    cellsFormat: 'f2', columntype: 'numberinput', cellclassname: cellclass,
                    cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata) {
                        var total = parseFloat(rowdata.remuneracion) * parseFloat(rowdata.cantidad);
                        return "<div style='margin 0px;' class='jqx-right-align'>" + dataAdapter.formatNumber(total, "f2") + "</div>";
                    },
                    aggregates: [{'<b><b/>':
                                    function (aggregatedValue, currentValue, column, record) {
                                        var total = parseFloat(record['remuneracion']) * parseFloat(record['cantidad']);
                                        return aggregatedValue + total;
                                    }
                        }]
                }
                
            ],
            columngroups: [
                {text: '<strong>REGISTRO DE EFECTIVOS</strong>', name: 'Titulo', align: 'center'},
                {text: '<strong>UNIDAD : </strong>' + nomDependencia + '<strong>   TIPO UNIDAD:</strong> ' + tipoFuerza, name: 'Unidad', parentgroup: 'Titulo', height: '52px'}
            ]
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
                    width: 600, height: 155, resizable: false
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
            $("#div_VentanaDetalle").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');

            $.ajax({
                type: "GET",
                url: "../EfectivoFuerzaOperativa",
                data: {mode: 'G', periodo: periodo, codFuerza: codFuerzaOpe, unidadOperativa: unidad,
                    tipoFuerza: tipoFuerza, dependencia: depen,unidad: unidad,codigo: codigoCab,
                    departamento: departamento,nomUnidad: nomDependencia},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        
        
        function fn_RegresarUnidad() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_VentanaDetalle").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../FuerzaOperativa",
                data: {mode: 'GD', periodo: periodo,unidadOperativa: unidad, dependencia: unidadAnt,
                codigo: codigoCab,departamento: departamento},
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
                result = row.codGrado + "---" + row.perRee + "---" + row.cantidad;
                //if(parseInt(row.cantidad)>0){                   
                lista.push(result);
                //}
            }
            $.ajax({
                type: "POST",
                url: "../IduEfectivoFuerzaOpe",
                data: {mode: mode, periodo: periodo, codFuerza: codFuerzaOpe, unidad: unidad, dependencia: depen,
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
    }
    );

</script>
<div id="div_GrillaPrincipal"></div>
<div id="div_VentanaPrincipal" style="display: none">
    <div>
        <span style="float: left">CONCEPTO REMUNERACIONES</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_EfectivoFuerzaOpe" name="frm_EfectivoFuerzaOpe" method="post" >

        </form>
    </div>
</div>
<div id="cbo_Ajax" style='display: none;'></div>
<div id="filtro">
    <select id="cbo_Nivel" name="cbo_Nivel">
        <c:forEach var="a" items="${objListaNivelGrado}">
            <option value="${a.codigo}">${a.descripcion}</option>
        </c:forEach>
    </select>
</div>
