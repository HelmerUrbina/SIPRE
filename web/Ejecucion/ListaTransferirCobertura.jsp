<%-- 
    Document   : ListaTransferirCobertura
    Created on : 06/03/2018, 08:53:07 AM
    Author     : H-TECCSI-V
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var periodo = '${objBnTransferirCobertura.periodo}';
    var presupuesto = '${objBnTransferirCobertura.presupuesto}';
    var coberturaInicial = '${objBnTransferirCobertura.cobertura}';
    var coberturaFinal = '${objBnTransferirCobertura.certificado}';
    var estado = "";
    var mode = null;
    var msg = '';
    var lista = new Array();
    <c:forEach var="d" items="${objCoberturaMensual}">
    var result = {cobertura: '${d.cobertura}', unidad: '${d.unidad}',usuario: '${d.dependencia}', detalle: '${d.detalle}',
        documentoReferencia: '${d.documentoReferencia}', importe: '${d.importe}'};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        var initGrid=function(){
            //PARA CARGAR LOS ELEMENTOS DE LA GRILLA
        var source = {
            localdata: lista,
            datatype: "array",
            datafields:
                    [
                        {name: 'cobertura', type: "string"},
                        {name: 'unidad', type: "string"},
                        {name: 'usuario', type: "string"},
                        {name: 'detalle', type: "string"},
                        {name: 'documentoReferencia', type: "string"},
                        {name: 'importe', type: "number"}
                    ],
            root: "TransferirCobertura",
            record: "TransferirCobertura",
            id: 'cobertura'
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
            height: ($(window).height() - 140),
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
            //showfilterrow: true,
            showaggregates: true,
            showstatusbar: true,
            editable: false,
            pagesize: 30,
            rendertoolbar: function (toolbar) {
                var container = $("<div style='overflow: hidden; position: relative; margin: 1px;'></div>");                
                var ButtonExportar = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/pauf42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                var ButtonTrans = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='../Imagenes/Botones/parametro42.gif' width=18 height=18/><span style='margin-left: 4px; position: relative; top: -3px;'> </span></div>");
                
                container.append(ButtonExportar);
                container.append(ButtonTrans);
                toolbar.append(container);
                
                ButtonExportar.jqxButton({width: 30, height: 22});
                ButtonExportar.jqxTooltip({position: 'bottom', content: "Exportar Datos"});
                ButtonTrans.jqxButton({width: 30, height: 22});
                ButtonTrans.jqxTooltip({position: 'bottom', content: "Transferir Datos"});
                
                ButtonExportar.click(function (event) {
                    $("#div_GrillaPrincipal").jqxGrid('exportdata', 'xls', 'TransferirCobertura');
                });
                ButtonTrans.click(function (event) {
                    var rows=$('#div_GrillaPrincipal').jqxGrid('getrows');
                    if(rows.length>0){
                        //alert("grabar");
                        fn_GrabarDatos();
                        fn_Imprimircobertura();
                    }else{
                        $.alert({
                            theme: 'material',
                            title: 'AVISO DEL SISTEMA',
                            content: "No se encontraron registros a transferir según los criterios ingresados",
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
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
                {text: 'COBERTURA', dataField: 'cobertura',  width: '6%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'UNIDAD', dataField: 'unidad',  width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'SECTORISTA', dataField: 'usuario',  width: '10%', align: 'center', cellsAlign: 'center', cellclassname: cellclass},
                {text: 'DETALLE', dataField: 'detalle',  width: '40%', cellsFormat: 'd', align: 'center', cellsAlign: 'left', cellclassname: cellclass},
                {text: 'DOC. REF', dataField: 'documentoReferencia', width: '20%', align: 'center', cellsAlign: 'left', cellclassname: cellclass, aggregates: [{'<b>Total : </b>':
                                    function () {
                                        return  "";
                                    }}]},
                {text: 'IMPORTE', dataField: 'importe', width: '10%', align: 'center', cellsAlign: 'right', cellsFormat: 'f2', cellclassname: cellclass, aggregates: ['sum']}                
            ]
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
                
            }
            return {init: function () {
                    _createElements();
                }
            };
        }());
        $(document).ready(function () {
            customButtonsDemo.init();
        });
        function fn_Imprimircobertura(){
            var url = '../Reportes?reporte=EJE0031&periodo=' + periodo + '&presupuesto=' + presupuesto + "&codigo=" + coberturaInicial + "&codigo2=" + coberturaFinal;
            window.open(url, '_blank');
        }                

        //FUNCION PARA ACTUALIZAR DATOS DE LA GRILLA
        function fn_Refrescar() {
            $("#div_VentanaPrincipal").remove();
            $("#div_ContextMenu").remove();
            $("#div_GrillaPrincipal").remove();
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "POST",
                url: "../TransferirCobertura",
                data: {mode: 'G', periodo: periodo, presupuesto: presupuesto, coberturaInicial: coberturaInicial,coberturaFinal: coberturaFinal},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        }
        //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
        function fn_GrabarDatos() {
         
            $.ajax({
                type: "POST",
                url: "../IduTransferirCobertura",
                data: {mode: 'T', periodo: periodo, presupuesto: presupuesto, coberturaInicial: coberturaInicial, coberturaFinal: coberturaFinal},
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
        };
        
        var initGrid2=function(){
    
               var url = '../Reportes?reporte=EJE0014&periodo=' + periodo + '&presupuesto=' + presupuesto + "&codigo=" + coberturaInicial + "&codigo2=" + coberturaFinal;
             
               $("#reporte").attr("src",url);
     
        };
        
        // init widgets.
            var initWidgets = function (tab) {
                switch (tab) {
                    case 0:
                        initGrid();
                        break;
                    case 1:
                        initGrid2();
                        break;
                }
            };
            $('#tabs').jqxTabs({ width: "1400px", height: $(window).height() - 90, position: 'top',initTabContent: initWidgets });
    });
</script>
<div id="jqxWidget">
    <div id='tabs'>
           <ul>
               <li style="margin-left: 30px;">
                   Listado
               </li>
               <li>
                   Vista Previa
               </li>
           </ul>

           <div style="overflow: hidden;">
               <div style="border:none;" id="div_GrillaPrincipal">
               </div>
           </div>
           <div style="overflow: hidden;">
               <div style="border:none;" id="div_coberturas">
                   <iframe id="reporte" width="1300" height="900"></iframe>
               </div>
           </div>

       </div>
    </div>


