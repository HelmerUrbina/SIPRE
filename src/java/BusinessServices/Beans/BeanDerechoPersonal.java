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
public class BeanDerechoPersonal implements Serializable{

    private String Periodo;
    private Integer Presupuesto;
    private String Mes;
    private Integer oficio;
    private Date FechaOficio;
    private Date FechaResolucion;
    private Integer Resolucion;
    private String Asunto;
    private String Referencia;
    private String Cobertura;
    private String Mode;
    private String Codigo;
    private String CodigoBeneficio;
    private String CodigoAdministrativo;
    private double ImporteBeneficiario;
    private Integer NumeroCorrelativo;
    private String CodigoSubTipo;
    private String PeriodoResolucion;
    private String Tipo;
    private String FecOficio;
    private String FecResolucion;

    
    public String getFecOficio() {
        return FecOficio;
    }

    public void setFecOficio(String FecOficio) {
        this.FecOficio = FecOficio;
    }

    public String getFecResolucion() {
        return FecResolucion;
    }

    public void setFecResolucion(String FecResolucion) {
        this.FecResolucion = FecResolucion;
    }    
    
    public String getTipo() {
        return Tipo;
    }

    public void setTipo(String Tipo) {
        this.Tipo = Tipo;
    }   
    
    public String getPeriodoResolucion() {
        return PeriodoResolucion;
    }

    public void setPeriodoResolucion(String PeriodoResolucion) {
        this.PeriodoResolucion = PeriodoResolucion;
    }    

    public String getPeriodo() {
        return Periodo;
    }

    public void setPeriodo(String Periodo) {
        this.Periodo = Periodo;
    }

    public Integer getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(Integer Presupuesto) {
        this.Presupuesto = Presupuesto;
    }

    public String getMes() {
        return Mes;
    }

    public void setMes(String Mes) {
        this.Mes = Mes;
    }

    public Integer getOficio() {
        return oficio;
    }

    public void setOficio(Integer oficio) {
        this.oficio = oficio;
    }

    public Date getFechaOficio() {
        return FechaOficio;
    }

    public void setFechaOficio(Date FechaOficio) {
        this.FechaOficio = FechaOficio;
    }

    public Date getFechaResolucion() {
        return FechaResolucion;
    }

    public void setFechaResolucion(Date FechaResolucion) {
        this.FechaResolucion = FechaResolucion;
    }

    public Integer getResolucion() {
        return Resolucion;
    }

    public void setResolucion(Integer Resolucion) {
        this.Resolucion = Resolucion;
    }

    public String getAsunto() {
        return Asunto;
    }

    public void setAsunto(String Asunto) {
        this.Asunto = Asunto;
    }

    public String getReferencia() {
        return Referencia;
    }

    public void setReferencia(String Referencia) {
        this.Referencia = Referencia;
    }

    public String getCobertura() {
        return Cobertura;
    }

    public void setCobertura(String Cobertura) {
        this.Cobertura = Cobertura;
    }

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

    public String getCodigoBeneficio() {
        return CodigoBeneficio;
    }

    public void setCodigoBeneficio(String CodigoBeneficio) {
        this.CodigoBeneficio = CodigoBeneficio;
    }

    public String getCodigoAdministrativo() {
        return CodigoAdministrativo;
    }

    public void setCodigoAdministrativo(String CodigoAdministrativo) {
        this.CodigoAdministrativo = CodigoAdministrativo;
    }

    public double getImporteBeneficiario() {
        return ImporteBeneficiario;
    }

    public void setImporteBeneficiario(double ImporteBeneficiario) {
        this.ImporteBeneficiario = ImporteBeneficiario;
    }

    public Integer getNumeroCorrelativo() {
        return NumeroCorrelativo;
    }

    public void setNumeroCorrelativo(Integer NumeroCorrelativo) {
        this.NumeroCorrelativo = NumeroCorrelativo;
    }

    public String getCodigoSubTipo() {
        return CodigoSubTipo;
    }

    public void setCodigoSubTipo(String CodigoSubTipo) {
        this.CodigoSubTipo = CodigoSubTipo;
    }
    
    
}
