<%-- 
    Document   : CombosAjax
    Created on : 04/02/2016, 10:03:56 AM
    Author     : H-URBINA-M
--%>
<%@page import="BusinessServices.Beans.BeanComun"%>
<%@page import="java.util.List"%>
<%@page import="com.google.gson.*"%>
<%
    List objCombo = (List) request.getAttribute("objCombosAjax");
    JsonArray recordsArray = new JsonArray();
    BeanComun val;    
    for (int i = 0; i < objCombo.size(); i++) {
        val = (BeanComun) objCombo.get(i);
        JsonObject currentRecord = new JsonObject();
        currentRecord.add("codigo", new JsonPrimitive(val.getCodigo()));
        currentRecord.add("descripcion", new JsonPrimitive(val.getDescripcion()));
        recordsArray.add(currentRecord);
    }
    out.print(recordsArray);
    out.flush();
%>  