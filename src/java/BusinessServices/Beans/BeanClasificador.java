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
public class BeanClasificador implements Serializable {

    private String Mode;
    private String Cadena;
    private String TipoTransaccion;
    private String Generica;
    private String SubGenerica;
    private String SubGenericaDetalle;
    private String Especifica;
    private String EspecificaDetalle;
    private String Descripcion;
    private String Tipo;

    public String getMode() {
        return Mode;
    }

    public void setMode(String Mode) {
        this.Mode = Mode;
    }

    public String getCadena() {
        return Cadena;
    }

    public void setCadena(String Cadena) {
        this.Cadena = Cadena;
    }

    public String getTipoTransaccion() {
        return TipoTransaccion;
    }

    public void setTipoTransaccion(String TipoTransaccion) {
        this.TipoTransaccion = TipoTransaccion;
    }

    public String getGenerica() {
        return Generica;
    }

    public void setGenerica(String Generica) {
        this.Generica = Generica;
    }

    public String getSubGenerica() {
        return SubGenerica;
    }

    public void setSubGenerica(String SubGenerica) {
        this.SubGenerica = SubGenerica;
    }

    public String getSubGenericaDetalle() {
        return SubGenericaDetalle;
    }

    public void setSubGenericaDetalle(String SubGenericaDetalle) {
        this.SubGenericaDetalle = SubGenericaDetalle;
    }

    public String getEspecifica() {
        return Especifica;
    }

    public void setEspecifica(String Especifica) {
        this.Especifica = Especifica;
    }

    public String getEspecificaDetalle() {
        return EspecificaDetalle;
    }

    public void setEspecificaDetalle(String EspecificaDetalle) {
        this.EspecificaDetalle = EspecificaDetalle;
    }

    public String getDescripcion() {
        return Descripcion;
    }

    public void setDescripcion(String Descripcion) {
        this.Descripcion = Descripcion;
    }

    public String getTipo() {
        return Tipo;
    }

    public void setTipo(String Tipo) {
        this.Tipo = Tipo;
    }

}
