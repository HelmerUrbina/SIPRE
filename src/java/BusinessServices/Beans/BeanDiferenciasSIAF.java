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
public class BeanDiferenciasSIAF implements Serializable {

    private String mode;
    private String opcion;
    private String Periodo;
    private String UnidadOperativa;
    private String Certificado;
    private String SecuenciaFuncional;
    private String CadenaGasto;
    private String GenericaGasto;
    private String CategoriaPresupuestal;
    private String Producto;
    private String Actividad;
    private String Sectorista;
    private Integer Presupuesto;
    private Double Diferencia;
    private Double SIPE;
    private Double SIAF;

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getOpcion() {
        return opcion;
    }

    public void setOpcion(String opcion) {
        this.opcion = opcion;
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

    public String getCertificado() {
        return Certificado;
    }

    public void setCertificado(String Certificado) {
        this.Certificado = Certificado;
    }

    public String getSecuenciaFuncional() {
        return SecuenciaFuncional;
    }

    public void setSecuenciaFuncional(String SecuenciaFuncional) {
        this.SecuenciaFuncional = SecuenciaFuncional;
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

    public String getSectorista() {
        return Sectorista;
    }

    public void setSectorista(String Sectorista) {
        this.Sectorista = Sectorista;
    }

    public Integer getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(Integer Presupuesto) {
        this.Presupuesto = Presupuesto;
    }

    public Double getDiferencia() {
        return Diferencia;
    }

    public void setDiferencia(Double Diferencia) {
        this.Diferencia = Diferencia;
    }

    public Double getSIPE() {
        return SIPE;
    }

    public void setSIPE(Double SIPE) {
        this.SIPE = SIPE;
    }

    public Double getSIAF() {
        return SIAF;
    }

    public void setSIAF(Double SIAF) {
        this.SIAF = SIAF;
    }

}
