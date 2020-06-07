<%-- 
    Document   : ListaPersonalPresupuestoDetRee
    Created on : 08/03/2017, 03:34:44 PM
    Author     : hateccsiv
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnPersonalPresupuesto.periodo}';
    var codConcepto = '${objBnPersonalPresupuesto.codConcepto}';
    var nivelGrado = '${objBnPersonalPresupuesto.nivelGrado}'; 
    var nivelDescripcion = '${objBnPersonalPresupuesto.nivelDescripcion}'; 
    var cocaga= '${objBnPersonalPresupuesto.cadenaGasto}'; 
    var comeop= '${objBnPersonalPresupuesto.tarea}'; 
    var grado = null;
    var periodoRee=null;
    var codigo=null;
    var mode = null;
    $(document).ready(function () {
        //PARA LA GRILLA DE LA CABECERA  
        var sourceCab = {
            localdata: fn_cargarGrilla("#div_GrillaCabecera"),
            datatype: "array",
            datafields:
                    [
                        {name: "codigo", type: "string"},
                        {name: "codPeriodo", type: "string"},
                        {name: "periodoRee", type: "string"},
                        {name: "codGrd", type: "string"},
                        {name: "grado", type: "string"},
                        {name: "impRemuneracion", type: "number"},
                        {name: "amazonas", type: "number"},
                        {name: "impAmazonas", type: "number"},
                        {name: "ancash", type: "number"},
                        {name: "impAncash", type: "number"},
                        {name: "apurimac", type: "number"},
                        {name: "impApurimac", type: "number"},
                        {name: "arequipa", type: "number"},
                        {name: "impArequipa", type: "number"},
                        {name: "ayacucho", type: "number"},
                        {name: "impAyacucho", type: "number"},
                        {name: "cajamarca", type: "number"},
                        {name: "impCajamarca", type: "number"},
                        {name: "callao", type: "number"},
                        {name: "impCallao", type: "number"},
                        {name: "cusco", type: "number"},
                        {name: "impCusco", type: "number"},
                        {name: "huancavelica", type: "number"},
                        {name: "impHuancavelica", type: "number"},
                        {name: "huanuco", type: "number"},
                        {name: "impHuanuco", type: "number"},
                        {name: "ica", type: "number"},
                        {name: "impIca", type: "number"},
                        {name: "junin", type: "number"},
                        {name: "impJunin", type: "number"},
                        {name: "libertad", type: "number"},
                        {name: "impLibertad", type: "number"},
                        {name: "lambayeque", type: "number"},
                        {name: "impLambayeque", type: "number"},
                        {name: "lima", type: "number"},
                        {name: "impLima", type: "number"},
                        {name: "loreto", type: "number"},
                        {name: "impLoreto", type: "number"},
                        {name: "mddios", type: "number"},
                        {name: "impMddios", type: "number"},
                        {name: "moquegua", type: "number"},
                        {name: "impMoquegua", type: "number"},
                        {name: "pasco", type: "number"},
                        {name: "impPasco", type: "number"},
                        {name: "piura", type: "number"},
                        {name: "impPiura", type: "number"},
                        {name: "puno", type: "number"},
                        {name: "impPuno", type: "number"},
                        {name: "smartin", type: "number"},
                        {name: "impSmartin", type: "number"},
                        {name: "tacna", type: "number"},
                        {name: "impTacna", type: "number"},
                        {name: "tumbes", type: "number"},
                        {name: "impTumbes", type: "number"},
                        {name: "ucayali", type: "number"},
                        {name: "impUcayali", type: "number"},
                        {name: "cantidad", type: "number"},
                        {name: "total", type: "number"}
                    ],
            root: "PersonalPrespuesto",
            record: "Detalle",
            id: 'codigo'
        };
        var cellclass = function (row, datafield, value, rowdata) {
            if (datafield === "grado" || datafield === "total") {
                return "RowBold";
            }            
        };
        $("#div_GrillaPrincipal").jqxGrid({
            width: '99.8%',
            height: ($(window).height() - 70),
            source: sourceCab,
            autoheight: false,
            autorowheight: false,
            altrows: true,
            sortable: true,
            pageable: true,
            showtoolbar: true,
            showaggregates: true,
            showstatusbar: true,
            filterable: true,
            autoshowfiltericon: true,
            columnsresize: true,
            statusbarheight: 25,
            showfilterrow: true,
            editable: false,            
            pagesize: 30,
            rendertoolbar: function (toolbar) {
                // appends buttons to the status bar.
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");                
                var exportButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var reloadButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/refresh42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'></span></div>");
                container.append(exportButton);
                container.append(reloadButton);
                toolbar.append(container); 
                reloadButton.jqxButton({width: 50, height: 22});
                reloadButton.jqxTooltip({position: 'bottom', content: "Actualiza Pantalla"});
                exportButton.jqxButton({width: 50, height: 22});
                exportButton.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                // reload grid data.
                reloadButton.click(function (event) {
                    fn_Refrescar();
                });
                //export to excel
                exportButton.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'PresupuestoPorGrado');
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: '10', pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'PERIODO REE', dataField: 'periodoRee', width: '15%',filtertype: 'checkedlist', columngroup: 'Nivel', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'GRADO', dataField: 'grado', width: '15%',filtertype: 'checkedlist', columngroup: 'Nivel', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'REMUNERACIÓN', dataField: 'impRemuneracion', width: '7%', columngroup: 'Nivel', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'amazonas', width: '6%', columngroup: 'Amazonas', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impAmazonas', columngroup: 'Amazonas', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'ancash', width: '6%', columngroup: 'Ancash', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impAncash', columngroup: 'Ancash', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'apurimac', width: '6%', columngroup: 'Apurimac', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impApurimac', columngroup: 'Apurimac', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'arequipa', width: '6%', columngroup: 'Arequipa', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impArequipa', columngroup: 'Arequipa', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'ayacucho', width: '6%', columngroup: 'Ayacucho', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impAyacucho', columngroup: 'Ayacucho', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'cajamarca', width: '6%', columngroup: 'Cajamarca', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impCajamarca', columngroup: 'Cajamarca', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'callao', width: '6%', columngroup: 'Callao', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impCallao', columngroup: 'Callao', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'cusco', width: '6%', columngroup: 'Cusco', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impCusco', columngroup: 'Cusco', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'huancavelica', width: '6%', columngroup: 'Huancavelica', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impHuancavelica', columngroup: 'Huancavelica', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'huanuco', width: '6%', columngroup: 'Huanuco', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impHuanuco', columngroup: 'Huanuco', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'ica', width: '6%', columngroup: 'Ica', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impIca', columngroup: 'Ica', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'junin', width: '6%', columngroup: 'Junin', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impJunin', columngroup: 'Junin', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'libertad', width: '6%', columngroup: 'Libertad', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impLibertad', columngroup: 'Libertad', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'lambayeque', width: '6%', columngroup: 'Lambayeque', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impLambayeque', columngroup: 'Lambayeque', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'lima', width: '6%', columngroup: 'Lima', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impLima', columngroup: 'Lima', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'loreto', width: '6%', columngroup: 'Loreto', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impLoreto', columngroup: 'Loreto', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'mddios', width: '6%', columngroup: 'Mddios', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impMddios', columngroup: 'Mddios', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'moquegua', width: '6%', columngroup: 'Moquegua', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impMoquegua', columngroup: 'Moquegua', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'pasco', width: '6%', columngroup: 'Pasco', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impPasco', columngroup: 'Pasco', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'piura', width: '6%', columngroup: 'Piura', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impPiura', columngroup: 'Piura', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'puno', width: '6%', columngroup: 'Puno', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impPuno', columngroup: 'Puno', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'smartin', width: '6%', columngroup: 'Smartin', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impSmartin', columngroup: 'Smartin', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'tacna', width: '6%', columngroup: 'Tacna', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impTacna', columngroup: 'Tacna', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'tumbes', width: '6%', columngroup: 'Tumbes', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impTumbes', columngroup: 'Tumbes', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'ucayali', width: '6%', columngroup: 'Ucayali', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'impUcayali', columngroup: 'Ucayali', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'EFECTIVO', dataField: 'cantidad', width: '6%', columngroup: 'Total', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'IMPORTE', dataField: 'total', columngroup: 'Total', width: '6%', align: 'right', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}
            
            ],
            columngroups: [
                {text: '<strong>DETALLE POR GRADO</strong>', name: 'Titulo', align: 'center'},
                {text: '<strong>PERSONAL : </strong>' + nivelDescripcion, name: 'Nivel', parentgroup: 'Titulo'},
                {text: '<strong>AMAZONAS</strong>', name: 'Amazonas', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>ANCASH</strong>', name: 'Ancash', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>APURIMAC</strong>', name: 'Apurimac', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>AREQUIPA</strong>', name: 'Arequipa', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>AYACUCHO</strong>', name: 'Ayacucho', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>CAJAMARCA</strong>', name: 'Cajamarca', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>CALLAO</strong>', name: 'Callao', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>CUSCO</strong>', name: 'Cusco', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>HUANCAVELICA</strong>', name: 'Huancavelica', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>HUANUCO</strong>', name: 'Huanuco', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>ICA</strong>', name: 'Ica', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>JUNIN</strong>', name: 'Junin', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>LA LIBERTAD</strong>', name: 'Libertad', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>LAMBAYEQUE</strong>', name: 'Lambayeque', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>LIMA</strong>', name: 'Lima', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>LORETO</strong>', name: 'Loreto', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>MADRE DE DIOS</strong>', name: 'Mddios', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>MOQUEGUA</strong>', name: 'Moquegua', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>PASCO</strong>', name: 'Pasco', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>PIURA</strong>', name: 'Piura', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>PUNO</strong>', name: 'Puno', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>SAN MARTIN</strong>', name: 'Smartin', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>TACNA</strong>', name: 'Tacna', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>TUMBES</strong>', name: 'Tumbes', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>UCAYALI</strong>', name: 'Ucayali', parentgroup: 'Nivel', align: 'center'},
                {text: '<strong>TOTAL ANUAL</strong>', name: 'Total', parentgroup: 'Nivel', align: 'center'}
            ]
        });
        // create context menu
        var contextMenu = $("#div_ContextMenu").jqxMenu({width: 200, height: 105, autoOpenPopup: false, mode: 'popup'});
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
            
            if ($.trim($(opcion).text()) === "Eliminar") {
                
                if (codigo !== null || codigo === '') {
                    mode = 'E';
                    fn_GrabarDatos();
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'Alerta!',
                        content: 'Debe Seleccionar un Registro',
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'orange',
                        typeAnimated: true
                    });
                }
            }           
        });
        //Seleccionar un Registro de la Cabecera
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['codigo'];
            grado = row['codGrd'];
            periodoRee = row['codPeriodo'];
        });
       
        //FUNCION PARA REFRESCAR LA PANTALLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../PersonalPresupuesto",
                data: {mode: 'GD', periodo: periodo, codConcepto: codConcepto, nivelGrado: nivelGrado,nivelDescripcion: nivelDescripcion},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            
            $.ajax({
                type: "POST",
                url: "../IduPersonalPresupuesto",
                data: {mode: mode, periodo: periodo, codConcepto: codConcepto, nivelGrado: nivelGrado, codGrd: grado,periodoRee: periodoRee,
                cadenaGasto: cocaga,tarea: comeop},
                success: function (data) {
                    msg = data;
                    if (msg === "GUARDO") {
                        $.confirm({
                            title: 'Mensaje',
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
                            title: 'Error!',
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
<table id='div_GrillaCabecera' style="display: none">
    <thead>
        <tr>
            <th>codigo</th>
            <th>codPeriodo</th>
            <th>periodoRee</th>
            <th>codGrd</th>
            <th>grado</th>
             <th>impRemuneracion</th>
            <th>amazonas</th>            
            <th>impAmazonas</th>
            <th>ancash</th>
            <th>impAncash</th>
            <th>apurimac</th>
            <th>impApurimac</th>
            <th>arequipa</th>
            <th>impArequipa</th>
            <th>ayacucho</th>
            <th>impAyacucho</th>
            <th>cajamarca</th>
            <th>impCajamarca</th>
            <th>callao</th>
            <th>impCallao</th>
            <th>cusco</th>
            <th>impCusco</th>
            <th>huancavelica</th>
            <th>impHuancavelica</th>
            <th>huanuco</th>
            <th>impHuanuco</th>
            <th>ica</th>
            <th>impIca</th>
            <th>junin</th>
            <th>impJunin</th>
            <th>libertad</th>
            <th>impLibertad</th>
            <th>lambayeque</th>
            <th>impLambayeque</th>
            <th>lima</th>
            <th>impLima</th>
            <th>loreto</th>
            <th>impLoreto</th>
            <th>mddios</th>
            <th>impMddios</th>
            <th>moquegua</th>
            <th>impMoquegua</th>
            <th>pasco</th>
            <th>impPasco</th>
            <th>piura</th>
            <th>impPiura</th>
            <th>puno</th>
            <th>impPuno</th>
            <th>smartin</th>
            <th>impSmartin</th>
            <th>tacna</th>
            <th>impTacna</th>
            <th>tumbes</th>
            <th>impTumbes</th>
            <th>ucayali</th>
            <th>impUcayali</th>
            <th>cantidad</th>
            <th>total</th>           
        </tr>
    </thead>
    <tbody>
        
        <c:forEach var="c" items="${objPersonalPresupuesto}">
            <tr>
                <td>${c.codigo}</td>
                <td>${c.codPeriodo}</td>
                <td>${c.periodoRee}</td>
                <td>${c.codGrd}</td>
                <td>${c.grado}</td>
                <td>${c.impRemuneracion}</td>
                <td>${c.amazonas}</td>
                <td>${c.impAmazonas}</td>                
                <td>${c.ancash}</td>
                <td>${c.impAncash}</td>
                <td>${c.apurimac}</td>
                <td>${c.impApurimac}</td>
                <td>${c.arequipa}</td>
                <td>${c.impArequipa}</td>
                <td>${c.ayacucho}</td>
                <td>${c.impAyacucho}</td>
                <td>${c.cajamarca}</td>
                <td>${c.impCajamarca}</td>
                <td>${c.callao}</td>
                <td>${c.impCallao}</td>
                <td>${c.cusco}</td>
                <td>${c.impCusco}</td>
                <td>${c.huancavelica}</td>
                <td>${c.impHuancavelica}</td>
                <td>${c.huanuco}</td>
                <td>${c.impHuanuco}</td>
                <td>${c.ica}</td>
                <td>${c.impIca}</td>
                <td>${c.junin}</td>
                <td>${c.impJunin}</td>
                <td>${c.libertad}</td>
                <td>${c.impLibertad}</td>
                <td>${c.lambayeque}</td>
                <td>${c.impLambayeque}</td>
                <td>${c.lima}</td>
                <td>${c.impLima}</td>
                <td>${c.loreto}</td>
                <td>${c.impLoreto}</td>
                <td>${c.mddios}</td>
                <td>${c.impMddios}</td>
                <td>${c.moquegua}</td>
                <td>${c.impMoquegua}</td>
                <td>${c.pasco}</td>
                <td>${c.impPasco}</td>
                <td>${c.piura}</td>
                <td>${c.impPiura}</td>
                <td>${c.puno}</td>
                <td>${c.impPuno}</td>
                <td>${c.smartin}</td>
                <td>${c.impSmartin}</td>
                <td>${c.tacna}</td>
                <td>${c.impTacna}</td>
                <td>${c.tumbes}</td>
                <td>${c.impTumbes}</td>
                <td>${c.ucayali}</td>
                <td>${c.impUcayali}</td>
                <td>${c.cantidad}</td>
                <td>${c.total}</td>
                
            </tr>
        </c:forEach> 
    </tbody>
</table>
<div id="div_GrillaPrincipal"></div>


<div id='div_ContextMenu' style='display: none;'>
    <ul>        
        <li>Eliminar</li>         
    </ul>
</div>

