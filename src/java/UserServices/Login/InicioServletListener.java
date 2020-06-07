/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Login;

import DataService.SQL.ConnectionMySQL;
import DataService.SQL.ConnectionSource;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Web application lifecycle listener.
 *
 * @author H-URBNINA-M
 */
public class InicioServletListener implements ServletContextListener {

    private Connection objConnection = null;
    private Connection objConnectionMySQL = null;
    private ConnectionSource connection;
    private ConnectionMySQL connectionMySQL;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        //Creacion de Conexion a Base de Datos
        connection = new ConnectionSource();
        objConnection = connection.getConnection();
        if (objConnection != null) {
            ctx.setAttribute("objConnection", objConnection);
            System.out.println("SE HA CONECTADO SATISFACTORIAMENTE............ SIPRE");
        } else {
            System.out.println("PROBLEMAS AL CONECTAR............ SIPRE");
        }
        connectionMySQL = new ConnectionMySQL();
        objConnectionMySQL = connectionMySQL.getConnection();
        if (objConnectionMySQL != null) {
            ctx.setAttribute("objConnectionMySQL", objConnectionMySQL);
            System.out.println("SE HA CONECTADO SATISFACTORIAMENTE............ BIOSTAR");
        } else {
            System.out.println("PROBLEMAS AL CONECTAR............ BIOSTAR");
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        try {
            objConnection = (Connection) ctx.getAttribute("objConnection");
            objConnection.close();
        } catch (SQLException ex) {
            System.out.println("Error al Cerrar Connection " + ex.getMessage());
        }
        System.out.println("CONEXION SIPRE ...... CERRADO CORRECTAMENTE.");
        try {
            objConnectionMySQL = (Connection) ctx.getAttribute("objConnectionMySQL");
            objConnectionMySQL.close();
        } catch (SQLException ex) {
            System.out.println("Error al Cerrar Connection MySQL " + ex.getMessage());
        }
        System.out.println("CONEXION BIOSTAR ...... CERRADO CORRECTAMENTE.");
    }
}
