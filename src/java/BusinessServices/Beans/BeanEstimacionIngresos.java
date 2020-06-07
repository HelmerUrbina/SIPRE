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
public class BeanEstimacionIngresos implements Serializable {

    private String Mode;
    private String Periodo;
    private String UnidadOperativa;
    private String CadenaIngreso;
    private String Impuesto;
    private String Descripcion;
    private Integer Codigo;
    private Integer Presupuesto;
    private Double ImporteUnidadOperativa;
    private Double ImporteUnidadEjecutora;

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

    public String getUnidadOperativa() {
        return UnidadOperativa;
    }

    public void setUnidadOperativa(String UnidadOperativa) {
        this.UnidadOperativa = UnidadOperativa;
    }

    public String getCadenaIngreso() {
        return CadenaIngreso;
    }

    public void setCadenaIngreso(String CadenaIngreso) {
        this.CadenaIngreso = CadenaIngreso;
    }

    public String getImpuesto() {
        return Impuesto;
    }

    public void setImpuesto(String Impuesto) {
        this.Impuesto = Impuesto;
    }

    public String getDescripcion() {
        return Descripcion;
    }

    public void setDescripcion(String Descripcion) {
        this.Descripcion = Descripcion;
    }

    public Integer getCodigo() {
        return Codigo;
    }

    public void setCodigo(Integer Codigo) {
        this.Codigo = Codigo;
    }

    public Integer getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(Integer Presupuesto) {
        this.Presupuesto = Presupuesto;
    }

    public Double getImporteUnidadOperativa() {
        return ImporteUnidadOperativa;
    }

    public void setImporteUnidadOperativa(Double ImporteUnidadOperativa) {
        this.ImporteUnidadOperativa = ImporteUnidadOperativa;
    }

    public Double getImporteUnidadEjecutora() {
        return ImporteUnidadEjecutora;
    }

    public void setImporteUnidadEjecutora(Double ImporteUnidadEjecutora) {
        this.ImporteUnidadEjecutora = ImporteUnidadEjecutora;
    }
   
}
