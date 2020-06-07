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
public class BeanTipoDocumento implements Serializable {

    private Integer Codigo;
    private String Descripcion;
    private String Abreviatura;
    private String Mode;

    public Integer getCodigo() {
        return Codigo;
    }

    public void setCodigo(Integer Codigo) {
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

    public String getMode() {
        return Mode;
    }

    public void setMode(String Mode) {
        this.Mode = Mode;
    }

}
