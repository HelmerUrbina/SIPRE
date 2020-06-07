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
public class BeanRegistroVacaciones implements Serializable {

    private String Mode;
    private String Periodo;
    private String CodigoPersonal;
    private String Nombres;
    private String Motivo;
    private String Observaciones;
    private String Estado;
    private Date FechaInicio;
    private Date FechaFin;
    private Date FechaSolicitud;
    private Integer DiasDisponible;
    private Integer DiasSolicitado;
    private Integer DiasRestantes;
    private Integer Correlativo;
    private Integer DiasLaborables;
    private Integer DiasNoLaborables;

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

    public String getCodigoPersonal() {
        return CodigoPersonal;
    }

    public void setCodigoPersonal(String CodigoPersonal) {
        this.CodigoPersonal = CodigoPersonal;
    }

    public String getNombres() {
        return Nombres;
    }

    public void setNombres(String Nombres) {
        this.Nombres = Nombres;
    }

    public String getMotivo() {
        return Motivo;
    }

    public void setMotivo(String Motivo) {
        this.Motivo = Motivo;
    }

    public String getObservaciones() {
        return Observaciones;
    }

    public void setObservaciones(String Observaciones) {
        this.Observaciones = Observaciones;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public Date getFechaInicio() {
        return FechaInicio;
    }

    public void setFechaInicio(Date FechaInicio) {
        this.FechaInicio = FechaInicio;
    }

    public Date getFechaFin() {
        return FechaFin;
    }

    public void setFechaFin(Date FechaFin) {
        this.FechaFin = FechaFin;
    }

    public Date getFechaSolicitud() {
        return FechaSolicitud;
    }

    public void setFechaSolicitud(Date FechaSolicitud) {
        this.FechaSolicitud = FechaSolicitud;
    }

    public Integer getDiasDisponible() {
        return DiasDisponible;
    }

    public void setDiasDisponible(Integer DiasDisponible) {
        this.DiasDisponible = DiasDisponible;
    }

    public Integer getDiasSolicitado() {
        return DiasSolicitado;
    }

    public void setDiasSolicitado(Integer DiasSolicitado) {
        this.DiasSolicitado = DiasSolicitado;
    }

    public Integer getDiasRestantes() {
        return DiasRestantes;
    }

    public void setDiasRestantes(Integer DiasRestantes) {
        this.DiasRestantes = DiasRestantes;
    }

    public Integer getCorrelativo() {
        return Correlativo;
    }

    public void setCorrelativo(Integer Correlativo) {
        this.Correlativo = Correlativo;
    }

    public Integer getDiasLaborables() {
        return DiasLaborables;
    }

    public void setDiasLaborables(Integer DiasLaborables) {
        this.DiasLaborables = DiasLaborables;
    }

    public Integer getDiasNoLaborables() {
        return DiasNoLaborables;
    }

    public void setDiasNoLaborables(Integer DiasNoLaborables) {
        this.DiasNoLaborables = DiasNoLaborables;
    }

}
