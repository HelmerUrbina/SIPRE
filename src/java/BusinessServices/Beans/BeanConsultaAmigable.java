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
public class BeanConsultaAmigable implements Serializable {

    private String mode;
    private String Periodo;
    private String Presupuesto;
    private String UnidadEjecutora;
    private String UnidadOperativa;
    private String Secuencia;
    private String Tarea;
    private String CadenaGasto;
    private String GenericaGasto;
    private String CategoriaPresupuestal;
    private String Producto;
    private String Actividad;
    private Double PIM;
    private Double Devengado;
    private Double Avance;

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getPeriodo() {
        return Periodo;
    }

    public void setPeriodo(String Periodo) {
        this.Periodo = Periodo;
    }

    public String getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(String Presupuesto) {
        this.Presupuesto = Presupuesto;
    }

    public String getUnidadEjecutora() {
        return UnidadEjecutora;
    }

    public void setUnidadEjecutora(String UnidadEjecutora) {
        this.UnidadEjecutora = UnidadEjecutora;
    }

    public String getUnidadOperativa() {
        return UnidadOperativa;
    }

    public void setUnidadOperativa(String UnidadOperativa) {
        this.UnidadOperativa = UnidadOperativa;
    }

    public String getSecuencia() {
        return Secuencia;
    }

    public void setSecuencia(String Secuencia) {
        this.Secuencia = Secuencia;
    }

    public String getTarea() {
        return Tarea;
    }

    public void setTarea(String Tarea) {
        this.Tarea = Tarea;
    }

    public String getCadenaGasto() {
        return CadenaGasto;
    }

    public void setCadenaGasto(String CadenaGasto) {
        this.CadenaGasto = CadenaGasto;
    }

    public String getGenericaGasto() {
        return GenericaGasto;
    }

    public void setGenericaGasto(String GenericaGasto) {
        this.GenericaGasto = GenericaGasto;
    }

    public String getCategoriaPresupuestal() {
        return CategoriaPresupuestal;
    }

    public void setCategoriaPresupuestal(String CategoriaPresupuestal) {
        this.CategoriaPresupuestal = CategoriaPresupuestal;
    }

    public String getProducto() {
        return Producto;
    }

    public void setProducto(String Producto) {
        this.Producto = Producto;
    }

    public String getActividad() {
        return Actividad;
    }

    public void setActividad(String Actividad) {
        this.Actividad = Actividad;
    }

    public Double getPIM() {
        return PIM;
    }

    public void setPIM(Double PIM) {
        this.PIM = PIM;
    }

    public Double getDevengado() {
        return Devengado;
    }

    public void setDevengado(Double Devengado) {
        this.Devengado = Devengado;
    }

    public Double getAvance() {
        return Avance;
    }

    public void setAvance(Double Avance) {
        this.Avance = Avance;
    }

}
