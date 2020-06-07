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
public class BeanResolucionesAdministrativas implements Serializable {

    private String mode;
    private String Periodo;
    private String UnidadOperativa;
    private String Codigo;
    private String Detalle;
    private String SIAF;
    private String Estado;
    private String TipoCalendario;
    private String SubTipoCalendario;
    private String Cobertura;
    private String GenericaGasto;
    private String SecuenciaFuncional;
    private String TareaPresupuestal;
    private String CadenaGasto;
    private Date FechaEmision;
    private Integer Presupuesto;
    private Double Importe;
    private Double Compromiso;
    private Double Devengado;
    private Double Girado;
    private Double Revertido;

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

    public String getUnidadOperativa() {
        return UnidadOperativa;
    }

    public void setUnidadOperativa(String UnidadOperativa) {
        this.UnidadOperativa = UnidadOperativa;
    }

    public String getCodigo() {
        return Codigo;
    }

    public void setCodigo(String Codigo) {
        this.Codigo = Codigo;
    }

    public String getDetalle() {
        return Detalle;
    }

    public void setDetalle(String Detalle) {
        this.Detalle = Detalle;
    }

    public String getSIAF() {
        return SIAF;
    }

    public void setSIAF(String SIAF) {
        this.SIAF = SIAF;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public String getTipoCalendario() {
        return TipoCalendario;
    }

    public void setTipoCalendario(String TipoCalendario) {
        this.TipoCalendario = TipoCalendario;
    }

    public String getSubTipoCalendario() {
        return SubTipoCalendario;
    }

    public void setSubTipoCalendario(String SubTipoCalendario) {
        this.SubTipoCalendario = SubTipoCalendario;
    }

    public String getCobertura() {
        return Cobertura;
    }

    public void setCobertura(String Cobertura) {
        this.Cobertura = Cobertura;
    }

    public String getGenericaGasto() {
        return GenericaGasto;
    }

    public void setGenericaGasto(String GenericaGasto) {
        this.GenericaGasto = GenericaGasto;
    }

    public String getSecuenciaFuncional() {
        return SecuenciaFuncional;
    }

    public void setSecuenciaFuncional(String SecuenciaFuncional) {
        this.SecuenciaFuncional = SecuenciaFuncional;
    }

    public String getTareaPresupuestal() {
        return TareaPresupuestal;
    }

    public void setTareaPresupuestal(String TareaPresupuestal) {
        this.TareaPresupuestal = TareaPresupuestal;
    }

    public String getCadenaGasto() {
        return CadenaGasto;
    }

    public void setCadenaGasto(String CadenaGasto) {
        this.CadenaGasto = CadenaGasto;
    }

    public Date getFechaEmision() {
        return FechaEmision;
    }

    public void setFechaEmision(Date FechaEmision) {
        this.FechaEmision = FechaEmision;
    }

    public Integer getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(Integer Presupuesto) {
        this.Presupuesto = Presupuesto;
    }

    public Double getImporte() {
        return Importe;
    }

    public void setImporte(Double Importe) {
        this.Importe = Importe;
    }

    public Double getCompromiso() {
        return Compromiso;
    }

    public void setCompromiso(Double Compromiso) {
        this.Compromiso = Compromiso;
    }

    public Double getDevengado() {
        return Devengado;
    }

    public void setDevengado(Double Devengado) {
        this.Devengado = Devengado;
    }

    public Double getGirado() {
        return Girado;
    }

    public void setGirado(Double Girado) {
        this.Girado = Girado;
    }

    public Double getRevertido() {
        return Revertido;
    }

    public void setRevertido(Double Revertido) {
        this.Revertido = Revertido;
    }

}
