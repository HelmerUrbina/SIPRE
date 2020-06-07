<%-- 
    Document   : TextoInstitucionAjax
    Created on : 13/07/2017, 11:48:40 AM
    Author     : H-TECCSI-V
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    var lista = new Array();
    var rows = '${objTextoAjax}';
    <c:forEach var="c" items="${objTextoAjax}">
        <c:set value="${c.descripcion}" var="descripcion"></c:set>
        <c:set value="${c.codigo}" var="codigo"></c:set>
    var result = {label: "${descripcion}", value: "${codigo}"};
    lista.push(result);
    </c:forEach>
    $(document).ready(function () {
        var source = {
            datafields: [{name: 'label'}, {name: 'value'}],
            localdata: lista
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        $("#txt_Institucion").jqxInput({height: 20, width: 450, minLength: 1, items: 15, source: dataAdapter});
    });
</script>
<input type="text" id="txt_Institucion" />