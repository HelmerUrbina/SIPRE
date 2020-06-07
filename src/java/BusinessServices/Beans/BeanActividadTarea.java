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
public class BeanActividadTarea implements Serializable {

    private String Mode;
    private String Codigo;
    private String Periodo;
    private String CategoriaPresupuestal;
    private String Producto;
    private String Actividad;
    private String Tarea;
    private String Finalidad;
    private Integer Presupuesto;

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

    public String getPeriodo() {
        return Periodo;
    }

    public void setPeriodo(String Periodo) {
        this.Periodo = Periodo;
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

    public String getTarea() {
        return Tarea;
    }

    public void setTarea(String Tarea) {
        this.Tarea = Tarea;
    }

    public String getFinalidad() {
        return Finalidad;
    }

    public void setFinalidad(String Finalidad) {
        this.Finalidad = Finalidad;
    }

    public Integer getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(Integer Presupuesto) {
        this.Presupuesto = Presupuesto;
    }

}
