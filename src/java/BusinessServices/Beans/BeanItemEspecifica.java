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
public class BeanItemEspecifica implements Serializable {

    private String Mode;
    private String Codigo;
    private String Item;
    private String CadenaGasto;
    private String UnidadMedida;

    public String getMode() {
        return Mode;
    }

    public void setMode(String Mode) {
        this.Mode = Mode;
    }

    public String getCodigo() {
        return Codigo;
    }

    public void setCodigo(String Codigo) {
        this.Codigo = Codigo;
    }

    public String getItem() {
        return Item;
    }

    public void setItem(String Item) {
        this.Item = Item;
    }

    public String getCadenaGasto() {
        return CadenaGasto;
    }

    public void setCadenaGasto(String CadenaGasto) {
        this.CadenaGasto = CadenaGasto;
    }

    public String getUnidadMedida() {
        return UnidadMedida;
    }

    public void setUnidadMedida(String UnidadMedida) {
        this.UnidadMedida = UnidadMedida;
    }

}
