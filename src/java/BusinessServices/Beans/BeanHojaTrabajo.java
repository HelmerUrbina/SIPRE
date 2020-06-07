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
public class BeanHojaTrabajo implements Serializable {

    private String Mode;
    private String Codigo;
    private String Periodo;
    private String UnidadOperativa;
    private String Tarea;
    private String EventoPrincipal;
    private String EventoFinal;
    private String Item;
    private String CadenaGasto;
    private String Descripcion;
    private String UnidadMedida;
    private String Estado;
    private String GenericaGasto;
    private String Dependencia;
    private Integer Presupuesto;
    private Integer Correlativo;
    private Integer Nivel;
    private Double Cantidad;
    private Double Precio;
    private Double Total;

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

    public String getUnidadOperativa() {
        return UnidadOperativa;
    }

    public void setUnidadOperativa(String UnidadOperativa) {
        this.UnidadOperativa = UnidadOperativa;
    }

    public String getTarea() {
        return Tarea;
    }

    public void setTarea(String Tarea) {
        this.Tarea = Tarea;
    }

    public String getEventoPrincipal() {
        return EventoPrincipal;
    }

    public void setEventoPrincipal(String EventoPrincipal) {
        this.EventoPrincipal = EventoPrincipal;
    }

    public String getEventoFinal() {
        return EventoFinal;
    }

    public void setEventoFinal(String EventoFinal) {
        this.EventoFinal = EventoFinal;
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

    public String getDescripcion() {
        return Descripcion;
    }

    public void setDescripcion(String Descripcion) {
        this.Descripcion = Descripcion;
    }

    public String getUnidadMedida() {
        return UnidadMedida;
    }

    public void setUnidadMedida(String UnidadMedida) {
        this.UnidadMedida = UnidadMedida;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public String getGenericaGasto() {
        return GenericaGasto;
    }

    public void setGenericaGasto(String GenericaGasto) {
        this.GenericaGasto = GenericaGasto;
    }

    public String getDependencia() {
        return Dependencia;
    }

    public void setDependencia(String Dependencia) {
        this.Dependencia = Dependencia;
    }

    public Integer getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(Integer Presupuesto) {
        this.Presupuesto = Presupuesto;
    }

    public Integer getCorrelativo() {
        return Correlativo;
    }

    public void setCorrelativo(Integer Correlativo) {
        this.Correlativo = Correlativo;
    }

    public Integer getNivel() {
        return Nivel;
    }

    public void setNivel(Integer Nivel) {
        this.Nivel = Nivel;
    }

    public Double getCantidad() {
        return Cantidad;
    }

    public void setCantidad(Double Cantidad) {
        this.Cantidad = Cantidad;
    }

    public Double getPrecio() {
        return Precio;
    }

    public void setPrecio(Double Precio) {
        this.Precio = Precio;
    }

    public Double getTotal() {
        return Total;
    }

    public void setTotal(Double Total) {
        this.Total = Total;
    }

}
