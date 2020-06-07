<%-- 
    Document   : MesaPartes
    Created on : 01/06/2020, 08:11:34 PM
    Author     : H-URBINA-M
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="Expires" content="0">
        <meta http-equiv="Last-Modified" content="0">
        <meta http-equiv="Cache-Control" content="no-cache, mustrevalidate">
        <meta http-equiv="Pragma" content="no-cache">
        <link type="text/css" rel="stylesheet" href="css/styles/jqx.base.css">
        <link type="text/css" rel="stylesheet" href="css/scaf.css">
        <link type="text/css" rel="stylesheet" href="css/jquery-confirm.css">
        <script type="text/javascript" src="javascript/validacion.js"></script>
        <script type="text/javascript" src="javascript/jquery.js"></script>
        <script type="text/javascript" src="javascript/jquery-confirm.js"></script>
        <script type="text/javascript" src="javascript/theme.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxcore.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxbuttons.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxscrollbar.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxlistbox.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxinput.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxnumberinput.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxtextarea.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxdatetimeinput.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxcalendar.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxexpander.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxvalidator.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxdropdownlist.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxfileupload.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/globalization/globalize.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/globalization/globalize.culture.es-PE.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxdata.js"></script>
        <title>.:: SIPRE - Registro de Mesa de Partes ::.</title>
        <script type="text/javascript">
            var tipo = "I";
            var institucion = '';
            var msg = '';
            $(document).ready(function () {
                //CREA LOS ELEMENTOS DE LAS VENTANAS
                var customButtonsDemo = (function () {
                    function _createElements() {
                        //INICIA LOS VALORES DE LA VENTANA
                        $('#div_VentanaPrincipal').jqxExpander({showArrow: false, toggleMode: 'none', width: '600px', height: '400px'});
                        $("#txt_Institucion").jqxInput({height: 20, width: 450, minLength: 1, items: 15});
                        $('#txt_Institucion').on('select', function (event) {
                            if (event.args) {
                                var item = event.args.item;
                                if (item) {
                                    institucion = item.value;
                                }
                            }
                        });
                        $("#cbo_Prioridad").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                        $("#cbo_TipoDocumento").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                        $("#txt_NumeroDocumento").jqxInput({width: 120, height: 20});
                        $("#cbo_Clasificacion").jqxDropDownList({animationType: 'fade', width: 200, height: 20});
                        $("#txt_FechaDocumento").jqxDateTimeInput({culture: 'es-PE', animationType: 'fade', width: 150, height: 20});
                        $("#txt_FechaRecepcion").jqxDateTimeInput({culture: 'es-PE', width: 150, height: 20, disabled: true});
                        $("#txt_Asunto").jqxInput({placeHolder: "Ingrese el asunto", width: 450, height: 20});
                        $("#txt_Observacion").jqxInput({placeHolder: "Ingrese la Observación", width: 450, height: 20});
                        $("#txt_PostFirma").jqxInput({placeHolder: "Ingrese la Post Firma", width: 450, height: 20});
                        $("#txt_Correo").jqxInput({placeHolder: "Ingrese su Correo Electrónico", width: 450, height: 20});
                        $("#div_Legajos").jqxNumberInput({width: 50, height: 20, max: 99, digits: 2, decimalDigits: 0});
                        $("#div_Folios").jqxNumberInput({width: 50, height: 20, max: 99, digits: 2, decimalDigits: 0});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 25});
                        $('#btn_Cancelar').on('click', function () {
                            window.location = "index.jsp";
                        });
                        $('#btn_Guardar').jqxButton({width: '65px', height: 25});
                        $('#btn_Guardar').on('click', function () {
                            msg = "";
                            msg += fn_validaCampo(institucion, "Seleccione la Institución.");
                            if (msg === "") {
                                $('#frm_MesaParte').jqxValidator('validate');
                            } else {
                                $.alert({
                                    theme: 'material',
                                    title: 'Aviso del Sistema',
                                    content: msg,
                                    type: 'blue',
                                    animation: 'zoom',
                                    closeAnimation: 'zoom',
                                    typeAnimated: true
                                });
                            }
                        });
                        $('#frm_MesaParte').jqxValidator({
                            rules: [
                                {input: '#txt_Institucion', message: 'Ingrese el nombre de la institución', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_NumeroDocumento', message: 'Ingrese el Numero de Documento!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Asunto', message: 'Ingrese el Asunto!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_FechaDocumento', message: 'Ingrese la fecha de documento', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_FechaRecepcion', message: 'Ingrese la fecha de recepción!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_FechaDocumento', message: 'Ingrese una fecha valida de documento', action: 'valueChanged',
                                    rule: function (input, commit) {
                                        var date = $('#txt_FechaDocumento').jqxDateTimeInput('value');
                                        var result = date.getFullYear() >= 2015 && date.getFullYear() <= 2030;
                                        return result;
                                    }
                                },
                                {input: '#txt_PostFirma', message: 'Ingrese la firma!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Correo', message: 'Ingrese su Correo Electronico!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Correo', message: 'Correo Electronico invalido!', action: 'keyup', rule: 'email'}
                            ]
                        });
                        $('#frm_MesaParte').jqxValidator({
                            onSuccess: function () {
                                fn_GrabarDatos();
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
                    fn_BuscaItem();
                });
                //FUNCION PARA GRABAR LOS DATOS DE LA VENTANA PRINCIPAL
                function fn_GrabarDatos() {
                     var fecha = new Date();
                    var prioridad = $("#cbo_Prioridad").val();
                    var tipoDocumento = $("#cbo_TipoDocumento").val();
                    var numeroDocumento = $("#txt_NumeroDocumento").val();
                    var clasificacion = $("#cbo_Clasificacion").val();
                    var fechaDocumento = $("#txt_FechaDocumento").val();
                    var fechaRecepcion = $("#txt_FechaRecepcion").val();
                    var asunto = $("#txt_Asunto").val();
                    var observacion = $("#txt_Observacion").val();
                    var firma = $("#txt_PostFirma").val();
                    var legajos = $("#div_Legajos").val();
                    var folios = $("#div_Folios").val();
                    var correo = $("#txt_Correo").val();
                    var archivo = $("#txt_Archivo").val();
                    if (archivo !== '') {
                        var formData = new FormData(document.getElementById("frm_MesaParte"));
                        formData.append("mode", "I");
                        formData.append("periodo", fecha.getFullYear());
                        formData.append("mes", fecha.getMonth()());
                        formData.append("tipo", tipo);
                        formData.append("institucion", institucion);
                        formData.append("prioridad", prioridad);
                        formData.append("tipoDocumento", tipoDocumento);
                        formData.append("numeroDocumento", numeroDocumento);
                        formData.append("clasificacion", clasificacion);
                        formData.append("fechaDocumento", fechaDocumento);
                        formData.append("fechaRecepcion", fechaRecepcion);
                        formData.append("asunto", asunto);
                        formData.append("observacion", observacion);
                        formData.append("firma", firma);
                        formData.append("legajos", legajos);
                        formData.append("folios", folios);
                        formData.append("correo", correo);
                        formData.append("archivo", archivo);
                        $.ajax({
                            type: "POST",
                            url: "RegistrarMesaPartes",
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
                                        content: 'Datos procesados correctamente',
                                        type: 'green',
                                        typeAnimated: true,
                                        autoClose: 'cerrarAction|1000',
                                        buttons: {
                                            cerrarAction: {
                                                text: 'Cerrar',
                                                action: function () {
                                                   
                                                   
                                                   
                                                   
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
                            content: "Debe Seleccionar un Archivo a subir\n Proceso cancelado!!!.",
                            animation: 'zoom',
                            closeAnimation: 'zoom',
                            type: 'red',
                            typeAnimated: true
                        });
                    }
                }
            });
            function fn_BuscaItem() {
                $.ajax({
                    type: "POST",
                    url: "TextoAjax",
                    data: {mode: 'institucion', codigo: ' '},
                    success: function (data) {
                        $("#txt_Institucion").html(data);
                    }
                });
            }
        </script>
    </head>
    <body oncontextmenu='return false' style="max-width: 600px; margin: auto; padding-top: 20px;">
        <div id="div_VentanaPrincipal">
            <div>
                <span style="float: next;">REGISTRO MESA DE PARTES</span>
            </div>
            <div>
                <form id="frm_MesaParte" name="frm_MesaParte" enctype="multipart/form-data" action="RegistrarMesaPartes" method="post">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="inputlabel">Instituci&oacute;n : </td>
                            <td><input type="text" id="txt_Institucion" name="txt_Institucion" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Prioridad : </td>
                            <td>
                                <select id="cbo_Prioridad" name="cbo_Prioridad">
                                    <option value="01" selected="true">TRAMITE NORMAL</option>
                                    <option value="02">URGENTE</option>
                                    <option value="03">MUY URGENTE</option>
                                    <option value="04">TRAMITE PERSONAL</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Tipo Documento : </td>
                            <td>
                                <select id="cbo_TipoDocumento" name="cbo_TipoDocumento">
                                    <option value="1" selected="true">OFICIO</option>
                                    <option value="2">SOLICITUD</option>
                                    <option value="3">HOJA RECOMENDACION</option>
                                    <option value="4">HOJA DE TRAMITE</option>
                                    <option value="5">MEMORANDUM</option>
                                    <option value="6">CARTA</option>
                                    <option value="7">FAX</option>
                                    <option value="8">INFORME</option>
                                    <option value="9">OFICIO MULTIPLE</option>
                                    <option value="10">DICTAMEN</option>
                                    <option value="11">FAX MULTIPLE</option>
                                    <option value="12">DIRECTIVA</option>
                                    <option value="13">HOJA INFOR</option>
                                    <option value="14">DECRETO</option>
                                    <option value="15">NOTIFICACION</option>
                                    <option value="16">ACTA DE ACUERDOS</option>
                                    <option value="17">CITACION</option>
                                    <option value="18">OPINION LEGAL</option>
                                    <option value="19">HOJA DE COORDINACION</option>
                                    <option value="20">INFORME TECNICO</option>
                                    <option value="21">INFORME PRESUPUESTAL</option>
                                    <option value="22">HOJA DE RESPUESTA</option>
                                    <option value="23">ANEXOS</option>
                                    <option value="24">AYUDA MEMORIA</option>
                                    <option value="25">MEMORANDUM MULTIPLE</option>
                                    <option value="26">ORDEN INTERNO</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Nro Documento : </td>
                            <td><input type="text" id="txt_NumeroDocumento" name="txt_NumeroDocumento"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Clasificaci&oacute;n : </td>
                            <td>
                                <select id="cbo_Clasificacion" name="cbo_Clasificacion">
                                    <option value="01" selected="true">COMUN</option>
                                    <option value="02">RESERVADO</option>
                                    <option value="03">CONFIDENCIAL</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Fecha Documento : </td>
                            <td ><div id="txt_FechaDocumento"></div>
                        </tr>
                        <tr>
                            <td class="inputlabel">Fecha Recepci&oacute;n : </td>
                            <td ><div id="txt_FechaRecepcion"></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Asunto : </td>
                            <td><input type="text" id="txt_Asunto" name="txt_Asunto" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Observaci&oacute;n : </td>
                            <td><input type="text" id="txt_Observacion" name="txt_Observacion" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Post Firma : </td>
                            <td><input type="text" id="txt_PostFirma" name="txt_PostFirma" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Legajos : </td>
                            <td><div id="div_Legajos"></div></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Folios : </td>
                            <td><div id="div_Folios"></div></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Correo Electrónico : </td>
                            <td><input type="email" id="txt_Correo" name="txt_Correo" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Archivo : </td>
                            <td><input type="file" name="txt_Archivo" id="txt_Archivo" style="text-transform: uppercase; width: 400px;height: 30px" class="name form-control" multiple/></td>
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
    </body>
</html>