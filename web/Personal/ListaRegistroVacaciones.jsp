<%-- 
    Document   : ListaRegistroVacaciones
    Created on : 07/02/2018, 04:18:30 PM
    Author     : hateccsiv
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style type="text/css">
    .cellRojo {
        color: #b90f0f !important;  
        font-weight: bold;    
    }
    .cellAzul {
        color: #0000FF !important;  
        font-weight: bold;    
    }
    .cellNegrita {        
        font-weight: bold;    
    }
</style>
<script type="text/javascript">
    var periodo = '${objBnRegistroVacaciones.periodo}';
    var codigo = '${objBnRegistroVacaciones.correlativo}';
    var usuario = '${objBnRegistroVacaciones.codigoPersonal}';
    var diasDisp = '${objBnRegistroVacaciones.diasDisponible}';
    var estado = "";
    var mode = null;
    var msg = '';
    var fecIni = "";
    var fecFin = "";
    var lista = new Array();
    var dLaborables = '0';
    var dNoLaborables = '0';
    <c:forEach var="d" items="${objRegistroVacaciones}">
    var result = {correlativo: '${d.correlativo}', fechaInicio: '${d.fechaInicio}', fechaFin: '${d.fechaFin}',
        diasDisponible: '${d.diasDisponible}', diasSolicitado: '${d.diasSolicitado}', diasRestantes: '${d.diasRestantes}',
        estado: '${d.estado}', observacion: '${d.observaciones}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'correlativo', type: "number"},
                        {name: 'fechaInicio', type: "string"},
                        {name: 'fechaFin', type: "string"},
                        {name: 'diasDisponible', type: "number"},
                        {name: 'diasSolicitado', type: "number"},
                        {name: 'diasRestantes', type: "number"},
                        {name: 'estado', type: "string"},
                        {name: 'observacion', type: "string"}
                    ],
            root: "RegistroVacaciones",
            record: "RegistroVacaciones",
            id: 'correlativo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {
            /*if (rowdata['estado'] === "APROBADO") {
             return "RowBlue";
             }
             if (rowdata['estado'] === "RECHAZADO") {
             return "RowRed";
             }*/
            if (datafield === "diasSolicitado") {
                return "cellRojo";
            }
            if (datafield === "diasRestantes") {
                return "cellAzul";
            }
            if (datafield === "diasDisponible") {
                return "cellNegrita";
            }
        };
        var cellclassDet = function (row, datafield, value, rowdata) {

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
            showaggregates: true,
            showstatusbar: true,
            editable: false,
            pagesize: 30,
            rendertoolbar: function (toolbar) {
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");
                var ButtonNuevo = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/nuevo42.gif' width=18 height=18 /><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonReporte = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/printer42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                container.append(ButtonNuevo);
                container.append(ButtonExportar);
                container.append(ButtonReporte);
                toolbar.append(container);
                ButtonNuevo.jqxButton({width: 30, height: 22});
                ButtonNuevo.jqxTooltip({position: 'bottom', content: "Nuevo Registro"});
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonReporte.jqxButton({width: 30, height: 22});
                ButtonReporte.jqxTooltip({position: 'bottom', content: "Reporte Planilla"});
                //ASIGNAMOS LAS FUNCIONES PARA EL BOTON EXPORTAR
                ButtonNuevo.click(function (event) {
                    mode = 'I';
                    codigo = 0;
                    //$("#div_VentanaPrincipal").remove();
                    fn_NuevoRegistro();
                });
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'RegistroVacaciones');
                });
                ButtonReporte.click(function (event) {
                    if (codigo > 0) {
                        var url = '../Reportes?periodo=' + periodo + '&codigo=' + codigo + "&reporte=PER0003&codigo2=" + usuario;
                        window.open(url, '_blank');
                    } else {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: "Debe seleccionar un registro.",
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true
                        });
                    }
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: 10, pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'FECHA INICIO<br>YYYY-MM-DD', dataField: 'fechaInicio', width: '12%', align: 'center', cellsformat: 'd', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FECHA TERMINO<br>YYYY-MM-DD', dataField: 'fechaFin', width: '12%', align: 'center', cellsformat: 'd', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DISPONIBLE', dataField: 'diasDisponible', columngroup: 'Titulo', width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass,
                    aggregates: [{'<b>Total : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'SOLICITADO', dataField: 'diasSolicitado', width: '10%', columngroup: 'Titulo', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'QUEDAN', dataField: 'diasRestantes', width: '10%', columngroup: 'Titulo', align: 'center', cellsAlign: 'center', cellsFormat: 'd', cellclassname: cellclass},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'list', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'OBSERVACION', dataField: 'observacion', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass}
            ],
            columngroups: [
                {text: '<strong>CANTIDAD EN DÍAS</strong>', name: 'Titulo', align: 'center'}
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
        //funcion formato de fecha
        function fn_FormatoFecha(obj) {
            var fecha = "";
            var fechaObj = obj;
            var dia = String(fechaObj.getDate());
            var mes = String(fechaObj.getMonth() + 1);
            var aa = String(fechaObj.getFullYear());
            if (mes.length < 2)
                mes = '0' + mes;
            if (dia.length < 2)
                dia = '0' + dia;
            fecha = dia + "/" + mes + "/" + aa;
            return fecha;
        }
        //DEFINIMOS LOS EVENTOS SEGUN LA OPCION DEL MENU CONTEXTUAL      
        $("#div_ContextMenu").on('itemclick', function (event) {
            var opcion = event.args;
            if (estado === "APROBADO") {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: "No puede modificar el registro, la papeleta de permiso se encuentra APROBADA",
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'red',
                    typeAnimated: true
                });
            } else {
                if ($.trim($(opcion).text()) === "Editar") {
                    if (estado === "ANULADO") {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: "No puede modificar el registro, se encuentra anulado",
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    } else {
                        mode = 'U';
                        fn_EditarRegistro();
                    }
                } else if ($.trim($(opcion).text()) === "Eliminar") {
                    if (estado === "ANULADO") {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: "El registro ya se encuentra anulado",
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    } else {
                        mode = 'D';
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Desea eliminar el registro seleccionado?',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true,
                            buttons: {
                                aceptar: {
                                    text: 'Aceptar',
                                    btnClass: 'btn-primary',
                                    keys: ['enter', 'shift'],
                                    action: function () {
                                        fecIni = "01/01/2017";
                                        fecFin = "01/01/2017";
                                        fn_GrabarDatos();
                                    }
                                },
                                cancelar: function () {
                                }
                            }
                        });
                    }
                } else if ($.trim($(opcion).text()) === "Cerrar") {
                    if (estado === "CERRADO") {
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: "El registro ya se encuentra cerrado",
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    } else {
                        mode = 'C';
                        $.confirm({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: 'Desea cerrar el registro seleccionado?',
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'orange',
                            typeAnimated: true,
                            buttons: {
                                aceptar: {
                                    text: 'Aceptar',
                                    btnClass: 'btn-primary',
                                    keys: ['enter', 'shift'],
                                    action: function () {
                                        fecIni = "01/01/2017";
                                        fecFin = "01/01/2017";
                                        fn_GrabarDatos();
                                    }
                                },
                                cancelar: function () {
                                }
                            }
                        });
                    }
                } else {
                    $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: "No hay opción a mostrar",
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'orange',
                        typeAnimated: true
                    });
                }
            }
        });
        //SELECCIONAMOS UN REGISTRO DE LA GRILLA
        $("#div_GrillaPrincipal").on('rowselect', function (event) {
            var args = event.args;
            var row = $("#div_GrillaPrincipal").jqxGrid('getrowdata', args.rowindex);
            codigo = row['correlativo'];
            estado = row['estado'];
        });
        //CREA LOS ELEMENTOS DE LAS VENTANAS
        var customButtonsDemo = (function () {
            function _createElements() {
                //INICIA LOS VALORES DE LA VENTANA
                var posicionX, posicionY;
                var ancho = 660;
                var alto = 290;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#div_Fecha").jqxDateTimeInput({animationType: 'fade', width: 250, height: 25, selectionMode: 'range', culture: 'es-PE'});
                        $("#txt_Motivo").jqxInput({placeHolder: "Ingrese motivo", height: 50, width: 400, minLength: 1, maxLength: 500});
                        $("#div_DiaDisponible").jqxNumberInput({width: 80, height: 20, max: 99, digits: 2, decimalDigits: 0, disabled: true});
                        $("#div_DiaSolicitado").jqxNumberInput({width: 80, height: 20, max: 99, digits: 2, decimalDigits: 0, disabled: true});
                        $("#div_DiaRestante").jqxNumberInput({width: 80, height: 20, max: 99, digits: 2, decimalDigits: 0, disabled: true});
                        $("#div_Fecha").on('change', function () {
                            var selection = $("#div_Fecha").jqxDateTimeInput('getRange');
                            if (selection.from !== null) {
                                //var ini=selection.from.toLocaleString();
                                var ini = new Date(selection.from.toLocaleString());
                                var fin = new Date(selection.to.toLocaleString());
                                fecIni = fn_FormatoFecha(ini);
                                fecFin = fn_FormatoFecha(fin);
                                $("#selectionIni").html("<div>" + fecIni + " </br></div>");
                                $("#selectionFin").html("<div>" + fecFin + " </br></div>");
                                //$("#div_DiaSolicitado").val(fn_DiferenciaEntreFechas(fecIni, fecFin));fn_CantidadDiasFS
                                //var cantSol = fn_DiferenciaEntreFechas(fecIni, fecFin) - fn_CantidadDiasNoLaborables(fecIni, fecFin);
                                var cantSol = fn_DiferenciaEntreFechas(fecIni, fecFin);
                                dNoLaborables = fn_CantidadDiasNoLaborables(fecIni, fecFin);
                                dLaborables = parseInt(cantSol) - parseInt(dNoLaborables);
                                $("#div_DiaSolicitado").val(cantSol);
                                var dDisp = $("#div_DiaDisponible").val();
                                var dSol = $("#div_DiaSolicitado").val();
                                $("#div_DiaRestante").val(fn_DiasRestante(dDisp, dSol));
                            }
                        });
                        $("#div_DiaDisponible").val(diasDisp);
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            var msg = "";
                            if (msg === "")
                                msg = fn_VerificarDiasSolicitados();
                            /*if (msg === "")
                             msg = fn_VerificarFechaInicio(fecIni);*/
                            if (msg === "")
                                msg = fn_VerificarDiasQuedan();
                            if (msg === "") {
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
        //FUNCTION PARA CONVERTIR A FORMATO DD/MM/YYYY
        function fn_FormatoFecha(obj) {
            var fecha = "";
            var fechaObj = obj;
            var dia = String(fechaObj.getDate());
            var mes = String(fechaObj.getMonth() + 1);
            var aa = String(fechaObj.getFullYear());
            if (mes.length < 2)
                mes = '0' + mes;
            if (dia.length < 2)
                dia = '0' + dia;
            fecha = dia + "/" + mes + "/" + aa;
            return fecha;
        }

        //FUNCTION PARA CANTIDA DE DIAS
        function fn_DiferenciaEntreFechas(fechaInicial, fechaFinal) {
            var aFecha1 = fechaInicial.split('/');
            var aFecha2 = fechaFinal.split('/');
            var fFecha1 = Date.UTC(aFecha1[2], aFecha1[1] - 1, aFecha1[0]);
            var fFecha2 = Date.UTC(aFecha2[2], aFecha2[1] - 1, aFecha2[0]);
            var dif = fFecha2 - fFecha1;
            var dias = Math.floor(dif / (1000 * 60 * 60 * 24));
            return dias + 1;
        }
        //FUNCION DIAS DISPONIBLES DE PERSONAL
        function fn_DiasDisponiblesPersonal() {
            //mode = 'B';
            $.ajax({
                type: "GET",
                url: "../RegistroVacaciones",
                data: {val: "B", periodo: periodo, correlativo: '0'},
                success: function (data) {
                    $("#div_DiaDisponible").val(data);
                }
            });
        }
        //FUNCION PARA DETERMINAR LOS DIAS QUE QUEDAN
        function fn_DiasRestante(diaDisponible, diaSolicitado) {
            var dif = 0;
            dif = parseInt(diaDisponible) - parseInt(diaSolicitado);
            return dif;
        }
        //FUNCION PARA CANTIDAD DE DIAS HABILES (Lun - Vie)
        function fn_CantidadDiasNoLaborables(fechaInicial, fechaFinal) {
            fechaInicial = fechaInicial.split("/");
            fechaFinal = fechaFinal.split("/");

            var dtInicial = new Date(fechaInicial[2], fechaInicial[1] - 1, fechaInicial[0]);
            var dtFinal = new Date(fechaFinal[2], fechaFinal[1] - 1, fechaFinal[0]);

            var contadorDias = 0;
            while (dtInicial <= dtFinal) {
                if (dtInicial.getDay() === 0 || dtInicial.getDay() === 6) { //dias q no sean sabados ni domingos
                    //console.log("dia contado:"+dtInicial);
                    contadorDias++;
                }
                dtInicial = new Date(dtInicial.getTime() + 86400000);// se agrega un dia
            }
            return contadorDias;
        }

        //FUNCION PARA VERIFICAR QUE LOS DIAS SOLICITADOS NO SEAN MAYOR A LOS DIAS DISPONIBLES
        function fn_VerificarDiasSolicitados() {
            var dDisp = $("#div_DiaDisponible").val();
            var dSol = $("#div_DiaSolicitado").val();

            if (dDisp < dSol) {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: "Los dias solicitados son mayor a lo disponible en su periodo vacacional.",
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
                return "ERROR";
            }
            return "";
        }
        //FUNCION PARA VERIFICAR EL INICIO DE VACACIONES SEA MAYOR AL DIA ACTUAL
        function fn_VerificarFechaInicio(fechaInicial) {
            var fecHoy = new Date();
            var fecIni = new Date(fechaInicial);
            fecHoy.setHours(0, 0, 0, 0);
            if (fecIni < fecHoy) {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: "La fecha de inicio seleccionada debe ser mayor o igual a la actual.",
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
                return "ERROR";
            }
            return "";
        }
        //FUNCION PARA VERIFICAR DIAS COMPLETOS DE VACACIONES
        function fn_VerificarDiasQuedan() {
            var quedan = $("#div_DiaRestante").val();
            if (quedan < 9) {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: "Los 8 días no podran ser usados forman parte de su periodo vacacional como dias NO LABORABLES.",
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'orange',
                    typeAnimated: true
                });
                return "ERROR";
            }
            return "";
        }
        //FUNCION PARA CARGAR VENTANA DE NUEVO REGISTRO
        function fn_NuevoRegistro() {

            $('#txt_Motivo').val('');
            $('#txt_Motivo').val("para permanecer en la ciudad de Lima");
            var hoy = new Date();
            hoy.getDate();
            $('#div_Fecha').jqxDateTimeInput('setRange', hoy, hoy);

            fecIni = fn_FormatoFecha(hoy);
            fecFin = fn_FormatoFecha(hoy);
            $("#selectionIni").html("<div>" + fecIni + " </br></div>");
            $("#selectionFin").html("<div>" + fecFin + " </br></div>");

            $("#div_DiaSolicitado").val('1');
            var dDisp = $("#div_DiaDisponible").val();
            var dSol = $("#div_DiaSolicitado").val();
            $("#div_DiaRestante").val(fn_DiasRestante(dDisp, dSol));

            var cantSol = fn_DiferenciaEntreFechas(fecIni, fecFin);
            dNoLaborables = fn_CantidadDiasNoLaborables(fecIni, fecFin);
            dLaborables = parseInt(cantSol) - parseInt(dNoLaborables);

            $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.3});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
        //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $('#txt_Motivo').val('');
            $.ajax({
                type: "GET",
                url: "../RegistroVacaciones",
                data: {mode: mode, periodo: periodo, correlativo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 6) {

                        var date1 = new Date(dato[0]);
                        date1 = new Date(date1.getTime() + 86400000);
                        //date1=date1+1;
                        var date2 = new Date(dato[1]);
                        date2 = new Date(date2.getTime() + 86400000);
                        //date2=date2+1;                
                        $('#div_Fecha').jqxDateTimeInput('setRange', date1, date2);

                        fecIni = fn_FormatoFecha(date1);
                        fecFin = fn_FormatoFecha(date2);
                        $("#selectionIni").html("<div>" + fecIni + " </br></div>");
                        $("#selectionFin").html("<div>" + fecFin + " </br></div>");

                        $("#div_DiaDisponible").val(dato[2]);
                        $("#div_DiaSolicitado").val(dato[3]);
                        $("#div_DiaRestante").val(dato[4]);
                        $("#txt_Motivo").val(dato[5]);
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }


        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_GrillaPrincipal").remove();
            $("#div_DiaSolicitado").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../RegistroVacaciones",
                data: {mode: 'G', periodo: periodo, correlativo: codigo},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var fechaInicio = fecIni;
            var fechaFin = fecFin;
            var diasDisponible = $("#div_DiaDisponible").val();
            var diasSolicitado = $("#div_DiaSolicitado").val();
            var motivo = $("#txt_Motivo").val();
            $.ajax({
                type: "POST",
                url: "../IduRegistroVacaciones",
                data: {mode: mode, periodo: periodo, correlativo: codigo, fechaInicio: fechaInicio, fechaFin: fechaFin,
                    diasDisponibles: diasDisponible, diasSolicitado: diasSolicitado, motivo: motivo, diasNoLaborables: dNoLaborables, diasLaborables: dLaborables},
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
        <span style="float: left">REGISTRAR VACACIONES</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_Vacaciones" name="frm_Vacaciones" method="post">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">                
                <tr>
                    <td class="inputlabel">Fecha : </td>
                    <td><div id="div_Fecha"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Empieza : </td>    
                    <td>
                        <div style='font-size: 13px; font-family: Verdana;' id='selectionIni'></div>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Termina : </td>    
                    <td>
                        <div style='font-size: 13px; font-family: Verdana;' id='selectionFin'></div>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">D&iacute;as Disponibles : </td>    
                    <td>
                        <div id="div_DiaDisponible"></div>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">D&iacute;as Solicitados : </td>    
                    <td>
                        <div id="div_DiaSolicitado"></div>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Quedan : </td>    
                    <td >
                        <div id="div_DiaRestante"></div>                       
                    </td>               
                </tr>
                <tr>
                    <td class="inputlabel">Motivo : </td>
                    <td><textarea id="txt_Motivo" name="txt_Motivo" maxlength="500"></textarea></td>                    
                </tr>

                <tr>
                    <td colspan="2">&nbsp</td>
                </tr>   
                <!--
                <tr>
                    <td colspan="2">
                        <span style="color: red;font-weight: bold;font-size: 12px;" >(*) Del periodo vacacional 8 d&iacute;as son no laborables</span>
                    </td>
                </tr>
                -->
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
<div id='div_ContextMenu' style='display:none;'>
    <ul>
        <li>Editar</li>
        <li>Eliminar</li>
        <li type='separator'></li>
        <li>Cerrar</li>
    </ul>
</div>