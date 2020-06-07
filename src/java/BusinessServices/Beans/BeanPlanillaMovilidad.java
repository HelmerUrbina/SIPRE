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
 * @author H-TECCSI-V
 */
public class BeanPlanillaMovilidad implements Serializable {

    private String Mode;
    private String UsuarioPlanilla;
    private Date FechaMovilidad;
    private String Mes;
    private String LugarOrigen;
    private String LugarDestino;
    private Double Importe;
    private String Justificacion;
    private Integer Correlativo;
    private String Periodo;
    private String Estado;

    public String getMode() {
        return Mode;
    }

    public void setMode(String Mode) {
        this.Mode = Mode;
    }

    public String getUsuarioPlanilla() {
        return UsuarioPlanilla;
    }

    public void setUsuarioPlanilla(String UsuarioPlanilla) {
        this.UsuarioPlanilla = UsuarioPlanilla;
    }

    public Date getFechaMovilidad() {
        return FechaMovilidad;
    }

    public void setFechaMovilidad(Date FechaMovilidad) {
        this.FechaMovilidad = FechaMovilidad;
    }

    public String getMes() {
        return Mes;
    }

    public void setMes(String Mes) {
        this.Mes = Mes;
    }

    public String getLugarOrigen() {
        return LugarOrigen;
    }

    public void setLugarOrigen(String LugarOrigen) {
        this.LugarOrigen = LugarOrigen;
    }

    public String getLugarDestino() {
        return LugarDestino;
    }

    public void setLugarDestino(String LugarDestino) {
        this.LugarDestino = LugarDestino;
    }

    public Double getImporte() {
        return Importe;
    }

    public void setImporte(Double Importe) {
        this.Importe = Importe;
    }

    public String getJustificacion() {
        return Justificacion;
    }

    public void setJustificacion(String Justificacion) {
        this.Justificacion = Justificacion;
    }

    public Integer getCorrelativo() {
        return Correlativo;
    }

    public void setCorrelativo(Integer Correlativo) {
        this.Correlativo = Correlativo;
    }

    public String getPeriodo() {
        return Periodo;
    }

    public void setPeriodo(String Periodo) {
        this.Periodo = Periodo;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

}
