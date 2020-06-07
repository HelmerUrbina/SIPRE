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
public class BeanHoraVuelo implements Serializable {

    private String Mode;
    private String Periodo;
    private String Aeronave;
    private String CadenaGasto;
    private String TipoAeronave;
    private String TipoCosto;
    private String PlacaAeronave;
    private String Tarea;
    private Integer CodigoAeronave;
    private Integer CodigoCosteo;
    private Integer Cantidad;
    private Integer CodigoProgramacion;
    private double Importe;
    private double CostoCCFFAA;
    private double CostoEntidades;

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

    public String getAeronave() {
        return Aeronave;
    }

    public void setAeronave(String Aeronave) {
        this.Aeronave = Aeronave;
    }

    public String getCadenaGasto() {
        return CadenaGasto;
    }

    public void setCadenaGasto(String CadenaGasto) {
        this.CadenaGasto = CadenaGasto;
    }

    public String getTipoAeronave() {
        return TipoAeronave;
    }

    public void setTipoAeronave(String TipoAeronave) {
        this.TipoAeronave = TipoAeronave;
    }

    public String getTipoCosto() {
        return TipoCosto;
    }

    public void setTipoCosto(String TipoCosto) {
        this.TipoCosto = TipoCosto;
    }

    public String getPlacaAeronave() {
        return PlacaAeronave;
    }

    public void setPlacaAeronave(String PlacaAeronave) {
        this.PlacaAeronave = PlacaAeronave;
    }

    public String getTarea() {
        return Tarea;
    }

    public void setTarea(String Tarea) {
        this.Tarea = Tarea;
    }

    public Integer getCodigoAeronave() {
        return CodigoAeronave;
    }

    public void setCodigoAeronave(Integer CodigoAeronave) {
        this.CodigoAeronave = CodigoAeronave;
    }

    public Integer getCodigoCosteo() {
        return CodigoCosteo;
    }

    public void setCodigoCosteo(Integer CodigoCosteo) {
        this.CodigoCosteo = CodigoCosteo;
    }

    public Integer getCantidad() {
        return Cantidad;
    }

    public void setCantidad(Integer Cantidad) {
        this.Cantidad = Cantidad;
    }

    public Integer getCodigoProgramacion() {
        return CodigoProgramacion;
    }

    public void setCodigoProgramacion(Integer CodigoProgramacion) {
        this.CodigoProgramacion = CodigoProgramacion;
    }

    public double getImporte() {
        return Importe;
    }

    public void setImporte(double Importe) {
        this.Importe = Importe;
    }

    public double getCostoCCFFAA() {
        return CostoCCFFAA;
    }

    public void setCostoCCFFAA(double CostoCCFFAA) {
        this.CostoCCFFAA = CostoCCFFAA;
    }

    public double getCostoEntidades() {
        return CostoEntidades;
    }

    public void setCostoEntidades(double CostoEntidades) {
        this.CostoEntidades = CostoEntidades;
    }

}
