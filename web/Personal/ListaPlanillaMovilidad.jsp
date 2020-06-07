<%-- 
    Document   : ListaPlanillaMovilidad
    Created on : 24/01/2018, 10:04:41 AM
    Author     : hateccsiv
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnPlanillaMovilidad.periodo}';
    var mes = '${objBnPlanillaMovilidad.mes}';
    var codigo = '${objBnPlanillaMovilidad.correlativo}';
    var usuario='${objBnPlanillaMovilidad.usuarioPlanilla}';
    var estado="";
    var mode = null;
    var msg = '';
    var lista = new Array();
    <c:forEach var="d" items="${objPlanillaMovilidad}">
    var result = {correlativo: '${d.correlativo}', lugarOrigen: '${d.lugarOrigen}', lugarDestino: '${d.lugarDestino}',
        fechaMovilidad: '${d.fechaMovilidad}', justificacion: '${d.justificacion}', importe: '${d.importe}', estado: '${d.estado}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'correlativo', type: "string"},
                        {name: 'lugarOrigen', type: "string"},
                        {name: 'lugarDestino', type: "string"},
                        {name: 'fechaMovilidad', type: "date"},
                        {name: 'justificacion', type: "string"},
                        {name: 'importe', type: "number"},
                        {name: 'estado', type: "string"}
                    ],
            root: "PlanillaMovilidad",
            record: "PlanillaMovilidad",
            id: 'correlativo'
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        //ESTILOS A LAS CELDAS DE LA GRILLA 
        var cellclass = function (row, datafield, value, rowdata) {

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
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'DecretoDocumentos');
                });
                ButtonReporte.click(function (event) {
                    var url = '../Reportes?periodo=' + periodo + '&tipo=' + mes + '&codigo=' + usuario+"&reporte=PER0001";
                    window.open(url, '_blank');                    
                });
            },
            columns: [
                {text: ' ', sortable: false, filterable: false, editable: false, groupable: false, draggable: false, resizable: false,
                    datafield: '', columntype: 'number', width: 10, pinned: true, cellsrenderer: function (row, column, value) {
                        return "<div style='margin:4px; text-align: center;'>" + (value + 1) + "</div>";
                    }
                },
                {text: 'ORIGEN', dataField: 'lugarOrigen', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DESTINO', dataField: 'lugarDestino', filtertype: 'checkedlist', width: '15%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'FECHA', dataField: 'fechaMovilidad', columntype: 'datetimeinput',  width: '10%', cellsFormat: 'd', align: 'center', cellsAlign: 'center', cellclassname: cellclass,
                    cellsrenderer: function (row, column, value){                        
                        var fec=new Date(value);
                        var fecha=new Date(fec.getTime()+86400000);
                        fecha=fn_FormatoFecha(fecha);
                        return "<div style='text-align: center;vertical-align: middle;margin-top: 5px;'>"+fecha+ "</div>";
                    }  
                },
                {text: 'JUSTIFICACION', dataField: 'justificacion', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Total : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'IMPORTE', dataField: 'importe', width: '10%', align: 'center', cellsAlign: 'center', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']},
                {text: 'ESTADO', dataField: 'estado', filtertype: 'list', width: '8%', align: 'center', cellsAlign: 'center', cellclassname: cellclass}
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
            if(estado==="CERRADO"){
                $.alert({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: "No puede modificar el registro, la planilla se encuentra cerrada.",
                        animation: 'zoom',
                        closeAnimation: 'zoom',
                        type: 'red',
                        typeAnimated: true
                    });
            }else{
                if ($.trim($(opcion).text()) === "Editar") {
                    mode='U';
                    fn_EditarRegistro();
                }else if ($.trim($(opcion).text()) === "Eliminar") {
                    mode='D';
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
                                        $("#div_FechaMovilidad").val('01/01/2017');
                                        fn_GrabarDatos();
                                    }
                                },
                            cancelar: function () {
                            }
                         }
                    });
                }else if ($.trim($(opcion).text()) === "Cerrar") {
                    mode='C';
                    $.confirm({
                        theme: 'material',
                        title: 'AVISO DEL SISTEMA',
                        content: 'Desea cerrar la planilla?, una vez cerrada no podra modificar.',
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
                                        $("#div_FechaMovilidad").val('01/01/2017');
                                        fn_GrabarDatos();
                                    }
                                },
                            cancelar: function () {
                            }
                         }
                    });
                }else{
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
                var ancho = 600;
                var alto = 250;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_VentanaPrincipal').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#cbo_Origen").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                        $("#cbo_Destino").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                        $("#cbo_Destino").on('change', function (event) {
                            var val=$("#cbo_Destino").jqxDropDownList('getSelectedItem').label;                           
                            var importe=0;
                            importe=fn_ImporteMovilidad(val);
                            $("#div_Importe").val(importe);
                        });
                        var fecha=new Date('01/'+mes+'/'+periodo);
                        var primerDia = new Date(fecha.getFullYear(), fecha.getMonth(), 1);
                        //var ultimoDia = new Date(fecha.getFullYear(), fecha.getMonth() + 1, 0);
                        //alert(primerDia.getDate());
                        var ultimoDia=fn_ultimoDiaDelMes(periodo,mes-1);
                        $("#div_FechaMovilidad").jqxDateTimeInput({min: new Date(periodo,mes-1,primerDia.getDate()),max: new Date(periodo,mes-1,ultimoDia),culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#txt_Justificacion").jqxInput({placeHolder: "Ingrese Justificación", height: 80, width: 400,minLength: 1});
                        $("#div_Importe").jqxNumberInput({width: 120, height: 20, max: 999999999, digits: 9, decimalDigits: 2, disabled: true});

                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            var msg = "";
                            if (msg === "")
                                msg = fn_verificarOrigen();
                            if (msg === "")
                                msg = fn_verificarDestino();
                            if (msg === "") {
                                $('#frm_Movilidad').jqxValidator('validate');
                            }
                        });
                        $('#frm_Movilidad').jqxValidator({
                            rules: [
                                {input: '#txt_Justificacion', message: 'Ingrese Justificación', action: 'keyup, blur', rule: 'required'},
                                {
                                    input: '#div_FechaMovilidad', message: 'Fecha fuera de Rango [2015 - 2030]', action: 'valueChanged', rule: function (input, commit) {
                                        var date = $('#div_FechaMovilidad').jqxDateTimeInput('value');
                                        var result = date.getFullYear() >= 2015 && date.getFullYear() <= 2030;
                                        return result;
                                    }
                                }
                            ]
                        });
                        $('#frm_Movilidad').jqxValidator({
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
        //FUNCION PARA CARGAR VENTANA DE NUEVO REGISTRO
        function fn_NuevoRegistro() {

            $("#cbo_Origen").jqxDropDownList('selectItem', 1);
            $("#cbo_Destino").jqxDropDownList('selectItem', 0);
            $("#txt_Justificacion").val('');
            $("#div_Importe").val('0');  
            
            $('#div_VentanaPrincipal').jqxWindow({isModal: true, modalOpacity: 0.3});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
         //FUNCION PARA CARGAR VENTANA PARA EDITAR REGISTRO
        function fn_EditarRegistro() {
            $.ajax({
                type: "GET",
                url: "../PlanillaMovilidad",
                data: {mode: mode, periodo: periodo, mes: mes, correlativo: codigo},
                success: function (data) {
                    var dato = data.split("+++");
                    if (dato.length === 5) {                       
                        $("#cbo_Origen").jqxDropDownList('selectItem', dato[0]);
                        $("#cbo_Destino").jqxDropDownList('selectItem', dato[1]);
                        $('#div_FechaMovilidad').jqxDateTimeInput('setDate', dato[2]);                        
                        $("#txt_Justificacion").val(dato[3]);                        
                        $("#div_Importe").val(dato[4]);                  
                    }
                }
            });
            $('#div_VentanaPrincipal').jqxWindow({isModal: true});
            $('#div_VentanaPrincipal').jqxWindow('open');
        }
       
        //funcion para cargar los precios según destino
        function fn_ImporteMovilidad(objDestino){
            
            var destino=objDestino;
            var importe=0;
            switch(destino)
            {
                case "SAN BORJA":
                    importe=0;
                    break;
                case "CERCADO DE LIMA":
                    importe=16;
                    break;
                case "ANCON":
                    importe=60;
                    break;
                case "CHORRILLOS":
                    importe=50;
                    break;
                case "JESUS MARIA":
                    importe=24;
                    break;
                case "RIMAC":
                    importe=20;
                    break;
                case "CALLAO":
                    importe=50;
                    break;
                default:
                    importe=0;                    
            }
            return importe;
        }
        //funcion ultimo dia del mes
        function fn_ultimoDiaDelMes(periodo,mes){
            var ultimoDia=0;
            switch(mes){
                case 0:
                    ultimoDia=31;
                    break;
                case 2:
                    ultimoDia=31;
                    break;
                case 4:
                    ultimoDia=31;
                    break;
                case 6:
                    ultimoDia=31;
                    break;
                case 7:
                    ultimoDia=31;
                    break;
                case 9:
                    ultimoDia=31;
                    break;
                case 11:
                    ultimoDia=31;
                    break;
                case 3:
                    ultimoDia=30;
                    break;
                case 5:
                    ultimoDia=30;
                    break;
                case 8:
                    ultimoDia=30;
                    break;
                case 10:
                    ultimoDia=30;
                    break;
                case 1:
                    if ( ((periodo%100 == 0) && (periodo%400 == 0)) ||
                        ((periodo%100 != 0) && (periodo%  4 == 0))   )
                        ultimoDia=29;  // Año Bisiesto
                    else
                        ultimoDia=28;
                    break;
            }
            return ultimoDia;
        }
        //FUNCION PARA VERIFICAR LA PRIORIDAD
        function fn_verificarDestino() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_Destino").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el destino";
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
        function fn_verificarOrigen() {
            var msg = "";
            var dato = "";
            dato = $("#cbo_Origen").val();
            if (dato === "" || dato === "0" || dato === null) {
                msg = "Seleccione el origen";
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
            $("#cbo_Ajax").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../PlanillaMovilidad",
                data: {mode: 'G', periodo: periodo, mes: mes, correlativo: codigo},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
            var origen = $("#cbo_Origen").val();
            var destino = $("#cbo_Destino").val();            
            var fechaMovilidad = $("#div_FechaMovilidad").val();
            var justificacion = $("#txt_Justificacion").val();
            var importe = $("#div_Importe").val();
            $.ajax({
                type: "POST",
                url: "../IduPlanillaMovilidad",
                data: {mode: mode, periodo: periodo, mes: mes,correlativo: codigo, origen: origen, destino: destino, fechaMovilidad: fechaMovilidad,
                    justificacion: justificacion, importe: importe},
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
        <span style="float: left">REGISTRAR MOVILIDAD</span>
    </div>
    <div style="overflow: hidden">        
        <form id="frm_Movilidad" name="frm_Movilidad" method="post">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">                
                <tr>
                    <td class="inputlabel">Origen : </td>
                    <td>
                        <select id="cbo_Origen" name="cbo_Origen">
                            <option value="0">Seleccione</option>
                            <option value="150130" selected>SAN BORJA</option>                             
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Destino : </td>
                    <td>
                        <select id="cbo_Destino" name="cbo_Destino">
                            <option value="0">Seleccione</option>
                            <c:forEach var="d" items="${objOrigen}">   
                                <option value="${d.codigo}">${d.descripcion}</option>
                            </c:forEach>                              
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="inputlabel">Fecha : </td>
                    <td><div id="div_FechaMovilidad"></div></td>
                </tr>
                <tr>
                    <td class="inputlabel">Justificación : </td>
                    <td><textarea id="txt_Justificacion" name="txt_Justificacion" maxlength="200"></textarea></td>                    
                </tr>
                <tr>
                    <td class="inputlabel">Importe : </td>
                    <td><div id="div_Importe"></div></td>  
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
<div id='div_ContextMenu' style='display:none;'>
    <ul>
        <li>Editar</li>
        <li>Eliminar</li>
        <li>Cerrar</li>
    </ul>
</div>
