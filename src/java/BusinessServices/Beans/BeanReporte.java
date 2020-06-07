/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BusinessServices.Beans;

/**
 *
 * @author H-URBINA-M
 */
public class BeanReporte {

    private String Codigo;
    private String Codigo2;
    private String Reporte;
    private String Periodo;
    private String UnidadOperativa;
    private String Tipo;
    private String Unidad;
    private Integer Presupuesto;
    private String Generica;

    public String getGenerica() {
        return Generica;
    }

    public void setGenerica(String Generica) {
        this.Generica = Generica;
    }
    
    public String getCodigo() {
        return Codigo;
    }

    public void setCodigo(String Codigo) {
        this.Codigo = Codigo;
    }

    public String getCodigo2() {
        return Codigo2;
    }

    public void setCodigo2(String Codigo2) {
        this.Codigo2 = Codigo2;
    }

    public String getReporte() {
        return Reporte;
    }

    public void setReporte(String Reporte) {
        this.Reporte = Reporte;
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

    public String getTipo() {
        return Tipo;
    }

    public void setTipo(String Tipo) {
        this.Tipo = Tipo;
    }

    public String getUnidad() {
        return Unidad;
    }

    public void setUnidad(String Unidad) {
        this.Unidad = Unidad;
    }

    public Integer getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(Integer Presupuesto) {
        this.Presupuesto = Presupuesto;
    }
    
}
