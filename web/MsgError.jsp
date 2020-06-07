<%-- 
    Document   : MsgError
    Created on : 21/03/2016, 02:51:55 PM
    Author     : H-URBINA-M
--%>

<%@ page contentType="text/html" buffer='8kb' autoFlush='true'%>
<html>
    <link href="css/scaf.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        <!--
        body {
            margin-left: 0px;
            margin-top: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }
        -->
    </style><head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>AVISO DEL SISTEMA</title>
    </head>
    <body oncontextmenu="return false">
        <table width="100%" height="100%" border="1" cellspacing="0">
            <tr>
                <td height="4%"colspan="3" background="img/menuBg.gif"><div align="center"><span class="titulopopup">AVISO DEL SISTEMA</span></div></td>
            </tr>
            <tr>
                <td width="20%" height="17%" ><img src="img/Aviso.png" width="93" height="94"></td>
                <td width="80%" height="73%" colspan="2" class="textoTabla" ><p>${objBnMsgerr.descripcion}</p>
                    <p align="center" class="textoRequerido"><a href="javascript:window.history.back()"><img src="img/right42.gif" name="imgright" width="22" height="23" border="0" id="imgright"></a> Retroceder</p></td>
            </tr>
        </table>
    </body>
</html>
<script>
    alert("REVISE URGENTE, TIENE ERRORES QUE CORREGIR...");
</script>