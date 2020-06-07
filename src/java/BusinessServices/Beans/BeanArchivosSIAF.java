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
public class BeanArchivosSIAF implements Serializable {

    private String Mode;
    private String Periodo;
    private String Ejecutora;
    private String Certificado;
    private String Secuencia;
    private String Correlativo;
    private String Presupuesto;
    private String Documento;
    private String NumeroDocumento;
    private String RUC;
    private String CadenaGasto;
    private String SecuenciaFuncional;
    private String Moneda;
    private String Estado;
    private String TipoRegistro;
    private String EstadoRegistro;
    private String EstadoEnvio;
    private String TipoTransaccion;
    private String GenericaGasto;
    private String SubGenericaGasto;
    private String SubGenericaDetalleGasto;
    private String EspecificaGasto;
    private String EspecificaDetalleGasto;
    private String RegistroTipo;
    private String Actividad;
    private String CategoriaPresupuestal;
    private String Producto;
    private String Funcion;
    private String DivisionFuncional;
    private String GrupoFuncional;
    private String Meta;
    private String Finalidad;
    private String UnidadMedida;
    private Double TipoCambio;
    private Double Monto;
    private Double MontoNacional;
    private Double PIM;
    private Double Ejecucion;
    private Double Saldo;
    private Double Enero;
    private Double Febrero;
    private Double Marzo;
    private Double Abril;
    private Double Mayo;
    private Double Junio;
    private Double Julio;
    private Double Agosto;
    private Double Setiembre;
    private Double Octubre;
    private Double Noviembre;
    private Double Diciembre;    
    private Date FechaDocumento;

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

    public String getEjecutora() {
        return Ejecutora;
    }

    public void setEjecutora(String Ejecutora) {
        this.Ejecutora = Ejecutora;
    }

    public String getCertificado() {
        return Certificado;
    }

    public void setCertificado(String Certificado) {
        this.Certificado = Certificado;
    }

    public String getSecuencia() {
        return Secuencia;
    }

    public void setSecuencia(String Secuencia) {
        this.Secuencia = Secuencia;
    }

    public String getCorrelativo() {
        return Correlativo;
    }

    public void setCorrelativo(String Correlativo) {
        this.Correlativo = Correlativo;
    }

    public String getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(String Presupuesto) {
        this.Presupuesto = Presupuesto;
    }

    public String getDocumento() {
        return Documento;
    }

    public void setDocumento(String Documento) {
        this.Documento = Documento;
    }

    public String getNumeroDocumento() {
        return NumeroDocumento;
    }

    public void setNumeroDocumento(String NumeroDocumento) {
        this.NumeroDocumento = NumeroDocumento;
    }

    public String getRUC() {
        return RUC;
    }

    public void setRUC(String RUC) {
        this.RUC = RUC;
    }

    public String getCadenaGasto() {
        return CadenaGasto;
    }

    public void setCadenaGasto(String CadenaGasto) {
        this.CadenaGasto = CadenaGasto;
    }

    public String getSecuenciaFuncional() {
        return SecuenciaFuncional;
    }

    public void setSecuenciaFuncional(String SecuenciaFuncional) {
        this.SecuenciaFuncional = SecuenciaFuncional;
    }

    public String getMoneda() {
        return Moneda;
    }

    public void setMoneda(String Moneda) {
        this.Moneda = Moneda;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public String getTipoRegistro() {
        return TipoRegistro;
    }

    public void setTipoRegistro(String TipoRegistro) {
        this.TipoRegistro = TipoRegistro;
    }

    public String getEstadoRegistro() {
        return EstadoRegistro;
    }

    public void setEstadoRegistro(String EstadoRegistro) {
        this.EstadoRegistro = EstadoRegistro;
    }

    public String getEstadoEnvio() {
        return EstadoEnvio;
    }

    public void setEstadoEnvio(String EstadoEnvio) {
        this.EstadoEnvio = EstadoEnvio;
    }

    public String getTipoTransaccion() {
        return TipoTransaccion;
    }

    public void setTipoTransaccion(String TipoTransaccion) {
        this.TipoTransaccion = TipoTransaccion;
    }

    public String getGenericaGasto() {
        return GenericaGasto;
    }

    public void setGenericaGasto(String GenericaGasto) {
        this.GenericaGasto = GenericaGasto;
    }

    public String getSubGenericaGasto() {
        return SubGenericaGasto;
    }

    public void setSubGenericaGasto(String SubGenericaGasto) {
        this.SubGenericaGasto = SubGenericaGasto;
    }

    public String getSubGenericaDetalleGasto() {
        return SubGenericaDetalleGasto;
    }

    public void setSubGenericaDetalleGasto(String SubGenericaDetalleGasto) {
        this.SubGenericaDetalleGasto = SubGenericaDetalleGasto;
    }

    public String getEspecificaGasto() {
        return EspecificaGasto;
    }

    public void setEspecificaGasto(String EspecificaGasto) {
        this.EspecificaGasto = EspecificaGasto;
    }

    public String getEspecificaDetalleGasto() {
        return EspecificaDetalleGasto;
    }

    public void setEspecificaDetalleGasto(String EspecificaDetalleGasto) {
        this.EspecificaDetalleGasto = EspecificaDetalleGasto;
    }

    public String getRegistroTipo() {
        return RegistroTipo;
    }

    public void setRegistroTipo(String RegistroTipo) {
        this.RegistroTipo = RegistroTipo;
    }

    public String getActividad() {
        return Actividad;
    }

    public void setActividad(String Actividad) {
        this.Actividad = Actividad;
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

    public String getFuncion() {
        return Funcion;
    }

    public void setFuncion(String Funcion) {
        this.Funcion = Funcion;
    }

    public String getDivisionFuncional() {
        return DivisionFuncional;
    }

    public void setDivisionFuncional(String DivisionFuncional) {
        this.DivisionFuncional = DivisionFuncional;
    }

    public String getGrupoFuncional() {
        return GrupoFuncional;
    }

    public void setGrupoFuncional(String GrupoFuncional) {
        this.GrupoFuncional = GrupoFuncional;
    }

    public String getMeta() {
        return Meta;
    }

    public void setMeta(String Meta) {
        this.Meta = Meta;
    }

    public String getFinalidad() {
        return Finalidad;
    }

    public void setFinalidad(String Finalidad) {
        this.Finalidad = Finalidad;
    }

    public String getUnidadMedida() {
        return UnidadMedida;
    }

    public void setUnidadMedida(String UnidadMedida) {
        this.UnidadMedida = UnidadMedida;
    }

    public Double getTipoCambio() {
        return TipoCambio;
    }

    public void setTipoCambio(Double TipoCambio) {
        this.TipoCambio = TipoCambio;
    }

    public Double getMonto() {
        return Monto;
    }

    public void setMonto(Double Monto) {
        this.Monto = Monto;
    }

    public Double getMontoNacional() {
        return MontoNacional;
    }

    public void setMontoNacional(Double MontoNacional) {
        this.MontoNacional = MontoNacional;
    }

    public Double getPIM() {
        return PIM;
    }

    public void setPIM(Double PIM) {
        this.PIM = PIM;
    }

    public Double getEjecucion() {
        return Ejecucion;
    }

    public void setEjecucion(Double Ejecucion) {
        this.Ejecucion = Ejecucion;
    }

    public Double getSaldo() {
        return Saldo;
    }

    public void setSaldo(Double Saldo) {
        this.Saldo = Saldo;
    }

    public Double getEnero() {
        return Enero;
    }

    public void setEnero(Double Enero) {
        this.Enero = Enero;
    }

    public Double getFebrero() {
        return Febrero;
    }

    public void setFebrero(Double Febrero) {
        this.Febrero = Febrero;
    }

    public Double getMarzo() {
        return Marzo;
    }

    public void setMarzo(Double Marzo) {
        this.Marzo = Marzo;
    }

    public Double getAbril() {
        return Abril;
    }

    public void setAbril(Double Abril) {
        this.Abril = Abril;
    }

    public Double getMayo() {
        return Mayo;
    }

    public void setMayo(Double Mayo) {
        this.Mayo = Mayo;
    }

    public Double getJunio() {
        return Junio;
    }

    public void setJunio(Double Junio) {
        this.Junio = Junio;
    }

    public Double getJulio() {
        return Julio;
    }

    public void setJulio(Double Julio) {
        this.Julio = Julio;
    }

    public Double getAgosto() {
        return Agosto;
    }

    public void setAgosto(Double Agosto) {
        this.Agosto = Agosto;
    }

    public Double getSetiembre() {
        return Setiembre;
    }

    public void setSetiembre(Double Setiembre) {
        this.Setiembre = Setiembre;
    }

    public Double getOctubre() {
        return Octubre;
    }

    public void setOctubre(Double Octubre) {
        this.Octubre = Octubre;
    }

    public Double getNoviembre() {
        return Noviembre;
    }

    public void setNoviembre(Double Noviembre) {
        this.Noviembre = Noviembre;
    }

    public Double getDiciembre() {
        return Diciembre;
    }

    public void setDiciembre(Double Diciembre) {
        this.Diciembre = Diciembre;
    }

    public Date getFechaDocumento() {
        return FechaDocumento;
    }

    public void setFechaDocumento(Date FechaDocumento) {
        this.FechaDocumento = FechaDocumento;
    }

}
