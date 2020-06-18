<%-- 
    Document   : LoginSuccess
    Created on : 13/06/2020, 01:30:05 PM
    Author     : helme
--%>

<%@ page language="java" contentType="text/html; charset=US-ASCII"
         pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "https://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
        <title>Login Success Page</title>
    </head>
    <body>
        <%
            String userName = null;
            String sessionID = null;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    System.out.println(cookie.getValue());
                    if (cookie.getName().equals("usuario")) {
                        userName = cookie.getValue();
        %>
        <h3>Hi <%=userName%>, do the checkout.</h3>
        <%
                    }
                }
            }
        %>

        <br>
        <form action="LogoutServlet" method="post">
            <input type="submit" value="Logout" >
        </form>
    </body>
</html>