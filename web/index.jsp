<%-- 
    Document   : index.jsp
    Created on : 18/03/2016, 12:11:54 PM
    Author     : H-URBINA-M
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="WEB-INF/jspf/browser.jspf" %>
<%    session.removeAttribute("objUsuario" + request.getSession().getId());
    session.removeAttribute("ID");
    session.removeAttribute("autorizacion");
    session.invalidate();
%>
<!DOCTYPE html> 
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <meta http-equiv="Expires" content="0"/>
        <meta http-equiv="Last-Modified" content="0"/>
        <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate"/>
        <meta http-equiv="Pragma" content="no-cache"/>
        <meta http-equiv="refresh" content="300; url=index.jsp">
        <title>.:: SIPRE - Sistema Integrado Presupuestal del Ejercito ::.</title>
        <link type="text/css" rel="stylesheet" href="css/styles/jqx.base.css">
        <link type="text/css" rel="stylesheet" href="css/login.css">
        <link type="text/css" rel="stylesheet" href="css/scaf.css">
        <link type="text/css" rel="stylesheet" href="css/bundled.css">
        <link type="text/css" rel="stylesheet" href="css/jquery-confirm.css"> 
        <script type="text/javascript" src="javascript/theme.js"></script>
        <script type="text/javascript" src="javascript/bundled.js"></script>
        <script type="text/javascript" src="javascript/jquery.js"></script>
        <script type="text/javascript" src="javascript/jquery-confirm.js"></script>
        <script type="text/javascript" src="javascript/jquery.hoverplay.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxcore.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxinput.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxpasswordinput.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxtooltip.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxbuttons.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxvalidator.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxwindow.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxcombobox.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxdropdownlist.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxscrollbar.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxlistbox.js"></script>
        <script type="text/javascript" src="javascript/jqwidgets/jqxexpander.js"></script>
        <script type="text/javascript" src="javascript/pdfobject.js" ></script>
        <script type="text/javascript">
            $(document).ready(function () {
                fn_Refrescar();
                var theme = getTheme();
                $('#div_Descarga').jqxExpander({showArrow: false, toggleMode: 'none', width: '300px', height: '200px'});
                $('#div_Normas').jqxExpander({showArrow: false, toggleMode: 'none', width: '300px', height: '200px'});
                $('#div_Ejecucion').jqxExpander({showArrow: false, toggleMode: 'none', width: '300px', height: '200px'});
                $('#div_Programacion').jqxExpander({showArrow: false, toggleMode: 'none', width: '300px', height: '200px'});
                $("#txt_Usuario").jqxInput({theme: theme, placeHolder: "Usuario", height: 25, width: 150});
                $("#txt_Password").jqxPasswordInput({theme: theme, placeHolder: "Contraseña", width: 150, height: 25, showStrength: true, showStrengthPosition: "right"});
                $("#txt_Verificacion").jqxInput({theme: theme, placeHolder: "Verificación", height: 25, width: 150, minLength: 1});
                $("#btn_Ingresar").jqxButton({theme: theme, template: "success", width: '150'});
                $("#btn_MesaPartes").jqxButton({theme: theme, template: "info", width: '150'});
                $("#btn_MesaPartes").on('click', function () {
                    window.location = "MesaPartes.jsp";
                });
                $("#btn_Ingresar").on('click', function () {
                    $('#frm_Login').jqxValidator('validate');
                });
                $('#frm_Login').jqxValidator({
                    rules: [
                        {input: '#txt_Usuario', message: 'Ingrese el Usuario!', action: 'keyup, blur', rule: 'required'},
                        {input: '#txt_Usuario', message: 'Ingrese Solo Numeros!', action: 'keyup, blur', rule: 'number'},
                        {input: '#txt_Password', message: 'Ingrese la Contraseña!', action: 'keyup, blur', rule: 'required'},
                        {input: '#txt_Verificacion', message: 'Ingrese los Caracteres de Verificacion!', action: 'keyup, blur', rule: 'required'}]
                });
                $('#frm_Login').jqxValidator({
                    onSuccess: function () {
                        fn_login();
                    }
                });
                var posicionX, posicionY;
                var ancho = 400;
                var alto = 225;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_WindowRegistro').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    cancelButton: $('#btn_Cancelar'),
                    initContent: function () {
                        $("#txt_CodigoUsuario").jqxInput({theme: theme, placeHolder: "USUARIO", height: 20, width: 200, minLength: 1, maxLength: 10});
                        $("#txt_Nombres").jqxInput({theme: theme, placeHolder: "NOMBRES", height: 20, width: 200, minLength: 1, maxLength: 25});
                        $("#txt_Apellidos").jqxInput({theme: theme, placeHolder: "APELLIDOS", height: 20, width: 200, minLength: 1, maxLength: 35});
                        $("#txt_Iniciales").jqxInput({theme: theme, placeHolder: "INICIALES", height: 20, width: 200, minLength: 1, maxLength: 10});
                        $("#txt_PasswordRegistro").jqxPasswordInput({theme: theme, placeHolder: "CONTRASEÑA", width: 200, height: 20, maxLength: 200, showStrength: true, showStrengthPosition: "right"});
                        $("#txt_CompruebaPassword").jqxPasswordInput({theme: theme, placeHolder: "COMPROBAR CONTRASEÑA", width: 200, maxLength: 200, height: 20, showStrength: true, showStrengthPosition: "right"});
                        $("#cbo_AreaLaboral").jqxDropDownList({theme: theme, autoOpen: true, promptText: "SELECCIONE", animationType: 'fade', width: 150, height: 20});
                        $('#btn_Cancelar').jqxButton({width: '65px', height: 22});
                        $('#btn_Guardar').jqxButton({width: '65px', height: 22});
                        $('#btn_Guardar').on('click', function (event) {
                            $('#frm_RegistraUsuario').jqxValidator('validate');
                        });
                        $('#frm_RegistraUsuario').jqxValidator({
                            rules: [
                                {input: '#txt_CodigoUsuario', message: 'Ingrese el Usuario (CIP o DNI)!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_CodigoUsuario', message: 'Ingrese Solo Numeros (CIP o DNI)!', action: 'keyup, blur', rule: 'number'},
                                {input: '#txt_Nombres', message: 'Ingrese sus Nombres!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Apellidos', message: 'Ingrese sus Apellidos!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_Iniciales', message: 'Ingrese sus Iniciales!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_PasswordRegistro', message: 'Ingrese una Contraseña!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_CompruebaPassword', message: 'Confirme Contraseña!', action: 'keyup, blur', rule: 'required'},
                                {input: '#txt_CompruebaPassword', message: 'Contraseña no coincide!', action: 'keyup, focus', rule: function (input, commit) {
                                        if (input.val() === $('#txt_PasswordRegistro').val()) {
                                            return true;
                                        }
                                        return false;
                                    }
                                }
                            ]
                        });
                        $('#frm_RegistraUsuario').jqxValidator({
                            onSuccess: function () {
                                fn_nuevoRegistro();
                            }
                        });
                    }
                });
                ancho = 640;
                alto = 420;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#div_WindowVideo').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    initContent: function () {
                    }
                });
                ancho = 400;
                alto = 400;
                posicionX = ($(window).width() / 2) - (ancho / 2);
                posicionY = ($(window).height() / 2) - (alto / 2);
                $('#window').jqxWindow({
                    position: {x: posicionX, y: posicionY},
                    width: ancho, height: alto, resizable: false,
                    initContent: function () {
                    }
                });
            });
            function fn_login() {
                var usuario = $("#txt_Usuario").val();
                var password = $("#txt_Password").val();
                var verificacion = $("#txt_Verificacion").val();
                $.ajax({
                    type: "POST",
                    url: "VerificaUsuario",
                    data: {accion: "LOGIN", usuario: usuario, password: password, verificacion: verificacion},
                    success: function (data) {
                        var result = data.substr(0, 5);
                        if (result === "Login") {
                            window.location = data;
                            /* var caracteristicas = "width=" + $(window).width() + ", height=" + $(window).height() + ", directories=no, location=no, menubar=no, scrollbars=yes, statusbar=no, tittlebar=no";
                             $("#txt_Usuario").val("");
                             $("#txt_Password").val("");
                             $("#txt_Verificacion").val("");
                             mywindow = window.open(data, 'Popup', caracteristicas);*/
                            fn_Refrescar();
                        } else {
                            $.alert({
                                theme: 'material',
                                title: 'Mensaje!',
                                content: data,
                                animation: 'zoom',
                                closeAnimation: 'zoom',
                                type: 'orange',
                                typeAnimated: true
                            });
                            fn_Refrescar();
                            $("#txt_Verificacion").val('');
                        }
                    }
                });
            }
            function fn_nuevoRegistro() {
                var codigo = $("#txt_CodigoUsuario").val();
                var nombres = $("#txt_Nombres").val();
                var apellidos = $("#txt_Apellidos").val();
                var iniciales = $("#txt_Iniciales").val();
                var password = $("#txt_PasswordRegistro").val();
                var areaLaboral = $("#cbo_AreaLaboral").val();
                $.ajax({
                    type: "POST",
                    url: "IduUsuario",
                    data: {mode: "I", usuario: codigo, nombres: nombres, apellidos: apellidos, iniciales: iniciales, password: password,
                        areaLaboral: areaLaboral, unidadOperativa: '----'},
                    success: function (data) {
                        msg = data;
                        if (msg === "GUARDO") {
                            $.confirm({
                                title: 'AVISO DEL SISTEMA',
                                content: 'Usuario se Registrado Correctamente!!. \n >Remita su Compromiso de Seguridad. ',
                                type: 'green',
                                typeAnimated: true,
                                autoClose: 'cerrarAction|1000',
                                buttons: {
                                    cerrarAction: {
                                        text: 'Cerrar',
                                        action: function () {
                                            $('#div_WindowRegistro').jqxWindow('close');
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
            function fn_Refrescar() {
                var d = new Date();
                $.ajax({
                    type: "POST",
                    url: "captcha.jsp?" + d.getTime(),
                    data: {},
                    success: function (data) {
                        $("#img_stickyImg").html(data);
                    }
                });
            }
            function fn_Registro() {
                $("#txt_CodigoUsuario").val("");
                $("#txt_Nombres").val("");
                $("#txt_Apellidos").val("");
                $("#txt_Iniciales").val("");
                $("#txt_PasswordRegistro").val("");
                $("#txt_CompruebaPassword").val("");
                $('#div_WindowRegistro').jqxWindow({isModal: true, modalOpacity: 0.9});
                $('#div_WindowRegistro').jqxWindow('open');
            }
            function fn_VerVideo() {
                $('#div_WindowVideo').jqxWindow({isModal: true, modalOpacity: 0.9});
                $('#div_WindowVideo').jqxWindow('open');
            }
            function fn_verDocumento() {
                var options = {
                    pdfOpenParams: {
                        pagemode: "thumbs",
                        navpanes: 1,
                        toolbar: 1,
                        statusbar: 0,
                        view: "FitH"
                    }
                };
                var myPDF = PDFObject.embed("Descarga/FaxMultiple2019-0097-OPRE.pdf", "#div_ViewerPDF");
            }
            function fn_Aviso() {
                $.alert({
                    theme: 'material',
                    title: 'AVISO DEL SISTEMA',
                    content: 'SIRVASE REMITIR SU FORMATO DE CONFIDENCIALIDAD PARA EL AF-2020.',
                    animation: 'zoom',
                    closeAnimation: 'zoom',
                    type: 'blue',
                    typeAnimated: true
                });
            }
        </script>
    </head>
    <body oncontextmenu='return false'>
        <table cellpadding="0" cellspacing="0" width="100%"  height="100%" >
            <tr>
                <td colspan="3" height="30px"></td>
            </tr>
            <tr >
                <td align="right" style="padding: 20px">
                    <div id='div_Normas' style="position: relative">
                        <div style="text-align: center">NORMAS LEGALES - DISPOSICIONES GENERALES</div>
                        <div>
                            <ul>
                                <li class="link"> 1. <a href="Descarga/DL1440-LeydelSistemaNacionaldePresupuestoPublico.pdf" target="_blank">DL 1440 - Ley del Sistema Nacional de Presupuesto Público</a></li>
                                <li class="link"> 2. <a href="Descarga/DU014_2019.pdf" target="_blank">Decreto Urgencia N° 014-2019</a></li>
                                <li class="link"> 3. <a href="Descarga/Anexo4-FtesFinanciamiento2020.pdf" target="_blank">Fuentes de Financiamiento 2020 - MEF</a></li>
                                <li class="link"> 4. <a href="Descarga/Anexo1-ClasificadoresIngreso2020.pdf" target="_blank">Clasificador de Ingresos 2020 - MEF</a></li>
                                <li class="link"> 5. <a href="Descarga/Anexo2-ClasificadoresGasto2020.pdf" target="_blank">Clasificador de Gastos 2020 - MEF</a></li>
                                <li class="link"> 6. <a href="Descarga/GlosariodeTerminosFinancieros-MEF.pdf" target="_blank">Glosario de Términos Financieros - MEF</a></li>
                                <li class="link"> 7. <a href="Descarga/DirectivaEjecucion_0003-2018-OPRE.pdf" target="_blank">Directiva General para la Ejecución del Proceso Presupuestario.</a></li>
                                <li class="link"> 8. <a href="Descarga/DirectivaOGRE2016.pdf" target="_blank">Directiva N° 001-2016/OGRE.</a></li>
                                <li class="link"> 9. <a href="Descarga/LineamientoComplentariosEvaluacion2020.pdf" target="_blank">Lineamientos para la Evaluación AF-2020.</a></li>
                                    <%--<li class="link"> 9. <a href="Descarga/LineamientoComplentariosEvaluacion2020.pdf" target="_blank"><span class="inputlabelred">Lineamientos para la Evaluación AF-2020.</span></a></li>--%>
                            </ul>
                        </div>
                    </div>
                    <div id='div_Descarga' style="position: relative">
                        <div style="text-align: center">MANUALES</div>
                        <div>
                            <ul>
                                <li class="link"> 1. <a href="Descarga/SIPRE_ManualUsuario.pdf" target="_blank">SIPRE - Manual</a></li>
                                <li class="link"> 2. <a href="Descarga/SIPRE_ProgramacionMultianual.pdf" target="_blank">SIPRE - Programación Multianual</a></li>
                                <li class="link"> 3. <a href="Descarga/FormatoConfidencialidadOPRE2020.pdf" target="_blank">Formato de Confidencialidad AF-2020.</a></li>
                            </ul>
                        </div>
                    </div>
                </td>
                <td align="center" style="width: 400px">
                    <form action="" method="post" id="frm_Login" >
                        <div class="header">INGRESO AL SISTEMA</div>
                        <div style="float: left; margin-top: 60px; margin-left: 10px "> 
                            <img src="Imagenes/Logos/candado.png" alt="Icon-Login" width="130px" height="150px"/>
                        </div>
                        <div id="content">
                            <table >
                                <tr>
                                    <td><label for="usuario">Usuario </label></td>
                                    <td><input type="text" name="txt_Usuario" id="txt_Usuario" autocomplete="off"/></td>
                                </tr>
                                <tr>
                                    <td colspan="2">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td><label for="password">Password </label></td>
                                    <td><input type="password" name="txt_Password" id="txt_Password" autocomplete="off"/></td>
                                </tr>
                                <tr>
                                    <td colspan="2">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="2"><label for="verificacion">Escriba estos caracteres </label></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><div id="img_stickyImg"></div></td>
                                </tr> 
                                <tr>
                                    <td colspan="2" class="link"><a href="javascript:fn_Refrescar();">Refrescar</a></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td><input type="text" name="txt_Verificacion" id="txt_Verificacion" autocomplete="off"/></td>
                                </tr>
                                <tr>
                                    <td colspan="2">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                    </td>
                                </tr>
                            </table> 
                            <div class="Summit" >
                                <div >
                                    <div style="float: left"><input name="btn_MesaPartes" id="btn_MesaPartes" type="button" value="Mesa Partes" /></div>
                                    <div style="float: right"><input name="btn_Ingresar" id="btn_Ingresar" type="button" value="Ingresar" /></div>
                                </div>
                            </div>
                            <div class="link" style="text-align: center">¿No tiene una cuenta? <a  href="javascript:fn_Registro();">Registrese</a></div>
                        </div>
                        <div class="footer">
                            <span style="font-weight: bold">Sistema Integrado Presupuestal del Ejercito</span><br/>
                            &copy; Todos los derechos reservados
                        </div>
                    </form> 
                </td>
                <td align="left" style="padding: 20px">
                    <div id='div_Programacion'>
                        <div style="text-align: center">PROGRAMACIÓN y FORMULACIÓN PRESUPUESTAL</div>
                        <div>
                            <ul>
                                <li class="link"> 1. <a href="Descarga/Directiva001-2014PlaneamientoEstrategico-CEPLAN.pdf" target="_blank">Directiva General del Proceso de Planeamiento Estratégico - CEPLAN.</a></li>
                                <li class="link"> 2. <a href="Descarga/VinculacióndelPlaneamientoconelPresupuesto-CEPLAN.pdf" target="_blank">Vinculación del Planeamiento con el Presupuesto - CEPLAN.</a></li>
                                <li class="link"> 3. <a href="Descarga/FormatoProgramacionMultianualGastos2021.xlsx" target="_blank">Formato para el Sustento del Anteproyecto del PPTO AF-2021.</a></li>
                                <li class="link"> 4. <a href="Descarga/DirectivaProgramacionMultianualFormulacionPPtal.pdf" target="_blank">Directiva de Programación Multianual y Formulación Presupuestaria.</a></li>
                                <li class="link"> 5. <a href="Descarga/Anexo1-DefinicionesProgramacionMultianual.pdf" target="_blank">Definiciones - Programación Multianual.</a></li>
                                <li class="link"> 6. <a href="Descarga/Anexo2-EquivalenciaClasificadoresGasto2021-2023.pdf" target="_blank">Equivalencia de los Clasificadores de Gasto para la P.M. 2021-2023.</a></li>
                                <li class="link"> 7. <a href="Descarga/Directiva001-2020MEFProgramacionMultianual.pdf" target="_blank">Directiva de Programación Multianual Presupuestaria y Formulación Presupuestaria.</a></li>
                            </ul>
                        </div>
                    </div>
                    <div id='div_Ejecucion'>
                        <div style="text-align: center">EJECUCIÓN PRESUPUESTAL</div>
                        <div>
                            <ul>
                                
                                <li class="link"> 1. <a href="Descarga/FaxMultiple2020-0059-OPRE.pdf" target="_blank"><span class="inputlabelred">Fax Mult. N° 0059 - Prioridad para el Pago de Servicios Básicos de las UUOO del EP.</span></a></li>
                                <li class="link"> a)<a href="Descarga/NuevoFormatoSSBB2020.xlsx" target="_blank"><span class="inputlabelred">Formato de Sustento de SSBB - 2020.</span></a></li>
                                    <%--<li class="link"> 4. <a href="Descarga/FaxMultiple2020-0053-OPRE.pdf" target="_blank"><span class="inputlabelred">Fax Mult. N° 0053 - Evaluación Presupuestal al 1er Semestre AF-2020 “Lineamientos Complementarios para la Evaluación del Presupuesto Institucional del al UE 003: Ejercito Peruano AF-2020”.</span></a></li>--%>
                            </ul>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <div id="div_WindowRegistro" style="display: none">
            <div>
                <span style="float: left">REGISTRO DE USUARIOS</span>
            </div>
            <div style="overflow: hidden">
                <form id="frm_RegistraUsuario" name="frm_RegistraUsuario" method="POST" >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="inputlabel">Usuario : </td>
                            <td style="text-align: left"><input type="text" id="txt_CodigoUsuario" name="txt_CodigoUsuario"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Nombres : </td>
                            <td style="text-align: left"><input type="text" id="txt_Nombres" name="txt_Nombres" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel" >Apellidos : </td>
                            <td style="text-align: left"><input type="text" id="txt_Apellidos" name="txt_Apellidos" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel" >Iniciales : </td>
                            <td style="text-align: left"><input type="text" id="txt_Iniciales" name="txt_Iniciales" style="text-transform: uppercase;"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Password : </td>
                            <td style="text-align: left"><input type="password" name="txt_PasswordRegistro" id="txt_PasswordRegistro"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Comprobar  password : </td>
                            <td style="text-align: left"><input type="password" name="txt_CompruebaPassword" id="txt_CompruebaPassword"/></td>
                        </tr>
                        <tr>
                            <td class="inputlabel">Area Laboral : </td>
                            <td>
                                <select name="cbo_AreaLaboral" id="cbo_AreaLaboral">
                                    <option value="02">EJECUCION</option>
                                    <option value="03">EVALUACION</option>
                                    <option value="08">PRESUPUESTO</option>
                                    <option value="15">PROGRAMACION</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="Summit" colspan="2">
                                <div>
                                    <input type="button" id="btn_Guardar" value="Guardar" style="margin-right: 20px" />
                                    <input type="button" id="btn_Cancelar" value="Cancelar" style="margin-right: 20px"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </div>
        <div id="div_WindowVideo" style="display: none">
            <div>
                <span style="float: left">D.L. 1440</span>
            </div>
            <div style="overflow: hidden">
                <div class="container">
                    <div id="videoID">
                        <%--
                        <video width="600" height="400" controls>
                            <source src="Descarga/DL1440.mp4" type="video/mp4">
                            Su navegador no soporta la etiqueta de vídeo.
                        </video>
                        --%>
                    </div>
                </div>
            </div>
        </div>
        <div id="window" style="display: none" >
            <div>
                Fax Multiple 0097-OPRE
            </div>
            <div>
                <div id="div_ViewerPDF" style="width: 100%; height: 100%"> </div> 
            </div>
        </div> 
    </body>
</html>
<script type="text/javascript">
    //fn_Aviso();
    //fn_verDocumento();
</script>