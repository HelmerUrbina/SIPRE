/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BusinessServices.Beans;

import java.io.Serializable;

/**
 *
 * @author H-TECCSI-V
 */
public class BeanFuerzaOperativa implements Serializable {

    private String Mode;
    private String Codigo;
    private String Periodo;
    private String UnidadOperativa;
    private String Dependencia;
    private String DependenciaDetalle;
    private String Estado;
    private String NombreDependencia;
    private String Comentario;
    private String CodigoDepartamento;
    private String NombreDepartamento;
    private String DescripFuerzaOperativa;
    private String Desactivacion;
    private Integer TipoFuerzaOperativa;
    private Integer CantidadOficina;
    private String PeriodoREE;
    private double Remuneracion;
    private double TotalRemuneracion;
    private double ImporteMensual;
    private double ImporteAnual;

    public double getImporteMensual() {
        return ImporteMensual;
    }

    public void setImporteMensual(double ImporteMensual) {
        this.ImporteMensual = ImporteMensual;
    }

    public double getImporteAnual() {
        return ImporteAnual;
    }

    public void setImporteAnual(double ImporteAnual) {
        this.ImporteAnual = ImporteAnual;
    }

    public String getPeriodoREE() {
        return PeriodoREE;
    }

    public void setPeriodoREE(String PeriodoREE) {
        this.PeriodoREE = PeriodoREE;
    }

    public double getRemuneracion() {
        return Remuneracion;
    }

    public void setRemuneracion(double Remuneracion) {
        this.Remuneracion = Remuneracion;
    }

    public double getTotalRemuneracion() {
        return TotalRemuneracion;
    }

    public void setTotalRemuneracion(double TotalRemuneracion) {
        this.TotalRemuneracion = TotalRemuneracion;
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

    public String getDependencia() {
        return Dependencia;
    }

    public void setDependencia(String Dependencia) {
        this.Dependencia = Dependencia;
    }

    public String getDependenciaDetalle() {
        return DependenciaDetalle;
    }

    public void setDependenciaDetalle(String DependenciaDetalle) {
        this.DependenciaDetalle = DependenciaDetalle;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public String getNombreDependencia() {
        return NombreDependencia;
    }

    public void setNombreDependencia(String NombreDependencia) {
        this.NombreDependencia = NombreDependencia;
    }

    public String getComentario() {
        return Comentario;
    }

    public void setComentario(String Comentario) {
        this.Comentario = Comentario;
    }

    public String getCodigoDepartamento() {
        return CodigoDepartamento;
    }

    public void setCodigoDepartamento(String CodigoDepartamento) {
        this.CodigoDepartamento = CodigoDepartamento;
    }

    public String getNombreDepartamento() {
        return NombreDepartamento;
    }

    public void setNombreDepartamento(String NombreDepartamento) {
        this.NombreDepartamento = NombreDepartamento;
    }

    public String getDescripFuerzaOperativa() {
        return DescripFuerzaOperativa;
    }

    public void setDescripFuerzaOperativa(String DescripFuerzaOperativa) {
        this.DescripFuerzaOperativa = DescripFuerzaOperativa;
    }

    public String getDesactivacion() {
        return Desactivacion;
    }

    public void setDesactivacion(String Desactivacion) {
        this.Desactivacion = Desactivacion;
    }

    public Integer getTipoFuerzaOperativa() {
        return TipoFuerzaOperativa;
    }

    public void setTipoFuerzaOperativa(Integer TipoFuerzaOperativa) {
        this.TipoFuerzaOperativa = TipoFuerzaOperativa;
    }

    public Integer getCantidadOficina() {
        return CantidadOficina;
    }

    public void setCantidadOficina(Integer CantidadOficina) {
        this.CantidadOficina = CantidadOficina;
    }
}
