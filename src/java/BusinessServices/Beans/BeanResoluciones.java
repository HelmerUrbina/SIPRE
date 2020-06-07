/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BusinessServices.Beans;

import java.io.Serializable;
import java.sql.Date;

/**
 *
 * @author H-URBINA-M
 */
public class BeanResoluciones implements Serializable {

    private String Mode;
    private String Periodo;
    private String FuenteFinanciamiento;
    private String Resolucion;
    private String Descripcion;
    private String Tipo;
    private Date Fecha;
    private Integer Codigo;
    private Double Importe;

    public String getMode() {
        return Mode;
    }

    public void setMode(String Mode) {
        this.Mode = Mode;
    }

    public String getPeriodo() {
        return Periodo;
    }

    public void setPeriodo(String Periodo) {
        this.Periodo = Periodo;
    }

    public String getFuenteFinanciamiento() {
        return FuenteFinanciamiento;
    }

    public void setFuenteFinanciamiento(String FuenteFinanciamiento) {
        this.FuenteFinanciamiento = FuenteFinanciamiento;
    }

    public String getResolucion() {
        return Resolucion;
    }

    public void setResolucion(String Resolucion) {
        this.Resolucion = Resolucion;
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

    public Date getFecha() {
        return Fecha;
    }

    public void setFecha(Date Fecha) {
        this.Fecha = Fecha;
    }

    public Integer getCodigo() {
        return Codigo;
    }

    public void setCodigo(Integer Codigo) {
        this.Codigo = Codigo;
    }

    public Double getImporte() {
        return Importe;
    }

    public void setImporte(Double Importe) {
        this.Importe = Importe;
    }

}
