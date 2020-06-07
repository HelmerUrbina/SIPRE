/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BusinessServices.Beans;

import java.io.Serializable;

/**
 *
 * @author H-TECCSI-V
 */
public class BeanInstitucion implements Serializable {

    private String Codigo;
    private String Descripcion;
    private String Abreviatura;
    private String Organismo;
    private String Mode;

    public String getCodigo() {
        return Codigo;
    }

    public void setCodigo(String Codigo) {
        this.Codigo = Codigo;
    }

    public String getDescripcion() {
        return Descripcion;
    }

    public void setDescripcion(String Descripcion) {
        this.Descripcion = Descripcion;
    }

    public String getAbreviatura() {
        return Abreviatura;
    }

    public void setAbreviatura(String Abreviatura) {
        this.Abreviatura = Abreviatura;
    }

    public String getOrganismo() {
        return Organismo;
    }

    public void setOrganismo(String Organismo) {
        this.Organismo = Organismo;
    }

    public String getMode() {
        return Mode;
    }

    public void setMode(String Mode) {
        this.Mode = Mode;
    }
    
}
