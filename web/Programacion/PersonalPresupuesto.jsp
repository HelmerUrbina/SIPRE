<%-- 
    Document   : PersonalPresupuesto
    Created on : 23/02/2017, 12:14:47 PM
    Author     : hateccsiv
--%>

<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    $(document).ready(function () {
        var theme = getTheme();
        $("#div_Titulo").jqxExpander({theme: theme, width: '100%'});
        $("#cbo_Periodo").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 100, dropDownWidth: 150, height: 20});
        $("#cbo_Concepto").jqxComboBox({theme: theme, autoOpen: true, promptText: "Seleccione", width: 400, dropDownWidth: 400, height: 20});        
        $('#cbo_Periodo').on('change', function () {
            fn_CargarBusqueda();
        });
        $('#cbo_Concepto').on('change', function () {
            fn_CargarBusqueda();
        });         
    });
    function fn_CargarBusqueda() {
        var msg = "";
        
        if (msg === "") {    
            var periodo = $("#cbo_Periodo").val();
            var codConcepto=$("#cbo_Concepto").val();                        
            $("#div_VentanaPrincipal").remove();  
            $("#div_ContextMenu").remove(); 
            $("#div_VentanaDetalle").remove(); 
            var $contenidoAjax = $('#div_Detalle').html('<img src="../Imagenes/Fondos/cargando.gif">');
            $.ajax({
                type: "GET",
                url: "../PersonalPresupuesto",
                data: {mode: "G",codConcepto: codConcepto,periodo: periodo,nivelGrado:0},
                success: function (data) {
                    $contenidoAjax.html(data);
                }
            });
        } else {
             $.alert({theme: 'material', title: 'Alerta!', content: msg, boxWidth: '50%'});
        }
    }
</script>
<div style="border: none;" id='div_Titulo'>
    <div class="jqx-hideborder">PRESUPUESTO PERSONAL Y OBLIGACIONES SOCIALES</div>
    <div>
        <div id="div_Cabecera">
            <table class="navy">                
                <tbody>
                    <tr> 
                        <td>Periodo : </td>
                        <td>
                            <select id="cbo_Periodo" name="cbo_Periodo">
                                <c:forEach var="a" items="${objPeriodo}">
                                    <option value="${a.codigo}">${a.codigo}</option>
                                </c:forEach>
                            </select>
                        </td>
                         <td>Concepto : </td>
                        <td>
                            <select id="cbo_Concepto" name="cbo_Concepto">
                                <c:forEach var="a" items="${objListaConceptos}">
                                    <option value="${a.codigo}">${a.descripcion}</option>
                                </c:forEach>
                            </select>
                        </td> 
                        <td><a href="javascript: fn_CargarBusqueda();" ><img src="../Imagenes/Botones/refresh42.gif" alt="Buscar Datos" name="imgrefresh" width="30" height="28" border="0" id="imgrefresh"></a></td>
                        <td><a href="../Login/Principal.jsp" target="_parent"><img src="../Imagenes/Botones/exit42.gif" alt="Salir de pantalla" name="imgexit" width="30" height="28"  border="0" id="imgexit" /></a></td>                        
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="div_Detalle" class="maincen"></div>        
    </div>
</div>
<script type="text/javascript">
    fn_CargarBusqueda();
</script>
