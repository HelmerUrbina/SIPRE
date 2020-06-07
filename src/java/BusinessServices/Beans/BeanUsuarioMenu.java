/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BusinessServices.Beans;

import java.io.Serializable;

/**
 *
 * @author H-URBINA-M
 */
public class BeanUsuarioMenu implements Serializable {

    private String Mode;
    private String Usuario;
    private String Modulo;
    private String Menu;
    private String Descripcion;
    private String Servlet;
    private String Modo;
    private String CodNivel;
    private String DesNivel;
    private String Privilegio;

    public String getMode() {
        return Mode;
    }

    public void setMode(String Mode) {
        this.Mode = Mode;
    }

    public String getUsuario() {
        return Usuario;
    }

    public void setUsuario(String Usuario) {
        this.Usuario = Usuario;
    }

    public String getModulo() {
        return Modulo;
    }

    public void setModulo(String Modulo) {
        this.Modulo = Modulo;
    }

    public String getMenu() {
        return Menu;
    }

    public void setMenu(String Menu) {
        this.Menu = Menu;
    }

    public String getDescripcion() {
        return Descripcion;
    }

    public void setDescripcion(String Descripcion) {
        this.Descripcion = Descripcion;
    }

    public String getServlet() {
        return Servlet;
    }

    public void setServlet(String Servlet) {
        this.Servlet = Servlet;
    }

    public String getModo() {
        return Modo;
    }

    public void setModo(String Modo) {
        this.Modo = Modo;
    }

    public String getCodNivel() {
        return CodNivel;
    }

    public void setCodNivel(String CodNivel) {
        this.CodNivel = CodNivel;
    }

    public String getDesNivel() {
        return DesNivel;
    }

    public void setDesNivel(String DesNivel) {
        this.DesNivel = DesNivel;
    }

    public String getPrivilegio() {
        return Privilegio;
    }

    public void setPrivilegio(String Privilegio) {
        this.Privilegio = Privilegio;
    }
}
