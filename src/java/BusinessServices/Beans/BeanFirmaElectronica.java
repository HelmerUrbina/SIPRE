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
public class BeanFirmaElectronica implements Serializable {

    private String Mode;
    private String Codigo;
    private String Periodo;
    private String UnidadOperativa;
    private String Documento;
    private String Concepto;
    private String Estado;
    private String Opcion;
    private String SIAF;
    private String Archivo;
    private Date Fecha;
    private Date Inicio;
    private Date Fin;
    private Integer Presupuesto;
    private Integer Nivel;
    private Double Importe;

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

    public String getDocumento() {
        return Documento;
    }

    public void setDocumento(String Documento) {
        this.Documento = Documento;
    }

    public String getConcepto() {
        return Concepto;
    }

    public void setConcepto(String Concepto) {
        this.Concepto = Concepto;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public String getOpcion() {
        return Opcion;
    }

    public void setOpcion(String Opcion) {
        this.Opcion = Opcion;
    }

    public String getSIAF() {
        return SIAF;
    }

    public void setSIAF(String SIAF) {
        this.SIAF = SIAF;
    }

    public String getArchivo() {
        return Archivo;
    }

    public void setArchivo(String Archivo) {
        this.Archivo = Archivo;
    }

    public Date getFecha() {
        return Fecha;
    }

    public void setFecha(Date Fecha) {
        this.Fecha = Fecha;
    }

    public Date getInicio() {
        return Inicio;
    }

    public void setInicio(Date Inicio) {
        this.Inicio = Inicio;
    }

    public Date getFin() {
        return Fin;
    }

    public void setFin(Date Fin) {
        this.Fin = Fin;
    }

    public Integer getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(Integer Presupuesto) {
        this.Presupuesto = Presupuesto;
    }

    public Integer getNivel() {
        return Nivel;
    }

    public void setNivel(Integer Nivel) {
        this.Nivel = Nivel;
    }

    public Double getImporte() {
        return Importe;
    }

    public void setImporte(Double Importe) {
        this.Importe = Importe;
    }

}
