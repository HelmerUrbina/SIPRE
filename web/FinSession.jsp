<%-- 
    Document   : FinSession
    Created on : 16/02/2016, 12:29:20 PM
    Author     : H-URBINA-M
--%>
<%@ page contentType="text/html" buffer='8kb' autoFlush='true'%>
<head>
    <style type="text/css">
        .Mensaje {
            font-family: Verdana; 
            font-size: 16pt; 
            color: white; 
            font-weight: bold;
            background: darkgreen;
        }
        .FinSession {
            color: darkgreen;
            font-weight: bold;
            font-family: Verdana; 
            font-size: 25pt;
        }
        .IniciaSession {
            color: red;
            font-family: Verdana; 
            font-weight: bold;
        }
        .Imagen {
            opacity: 0.8;
            width: 400px;
        }
    </style>
</head>
<body oncontextmenu="return false" onkeydown="return false" topmargin="0" leftmargin="0">
    <table border="0" cellpadding="0" cellspacing="0" width="100%"  height="100%">
        <tr>
            <td class="Mensaje" height="70" colspan="3">&nbsp;Mensaje...</td>
        </tr>
        <tr>
            <td width="400">
                <div align="center">
                    <img class="Imagen" src="../Imagenes/Logos/stop.png" >
                </div>
            </td>
        </tr>
        <tr>
            <td width="100%" height="100%" rowspan="2">
                <p align="center" class="FinSession">LA SESI&#211;N HA FINALIZADO.</p>
                <p align="center"><a href="../FinalizaSesion" target="_parent" class="IniciaSession">INICIAR SESI&#211;N</a>
            </td>            
        </tr>
    </table>
</body>