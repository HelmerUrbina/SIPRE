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
public class BeanSistemaCambio implements Serializable {

    private String Mode;
    private String Codigo;
    private String Periodo;
    private String Usuario;
    private String UnidadOperativa;
    private String Asunto;
    private String Descripcion;
    private String Observacion;
    private String Estado;
    private String Responsable;
    private String Fase;
    private String Accion;
    private Date Fecha;
    private Date FechaSolucion;    

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

    public String getUsuario() {
        return Usuario;
    }

    public void setUsuario(String Usuario) {
        this.Usuario = Usuario;
    }

    public String getUnidadOperativa() {
        return UnidadOperativa;
    }

    public void setUnidadOperativa(String UnidadOperativa) {
        this.UnidadOperativa = UnidadOperativa;
    }

    public String getAsunto() {
        return Asunto;
    }

    public void setAsunto(String Asunto) {
        this.Asunto = Asunto;
    }

    public String getDescripcion() {
        return Descripcion;
    }

    public void setDescripcion(String Descripcion) {
        this.Descripcion = Descripcion;
    }

    public String getObservacion() {
        return Observacion;
    }

    public void setObservacion(String Observacion) {
        this.Observacion = Observacion;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public String getResponsable() {
        return Responsable;
    }

    public void setResponsable(String Responsable) {
        this.Responsable = Responsable;
    }

    public String getFase() {
        return Fase;
    }

    public void setFase(String Fase) {
        this.Fase = Fase;
    }

    public String getAccion() {
        return Accion;
    }

    public void setAccion(String Accion) {
        this.Accion = Accion;
    }

    public Date getFecha() {
        return Fecha;
    }

    public void setFecha(Date Fecha) {
        this.Fecha = Fecha;
    }

    public Date getFechaSolucion() {
        return FechaSolucion;
    }

    public void setFechaSolucion(Date FechaSolucion) {
        this.FechaSolucion = FechaSolucion;
    }

}
