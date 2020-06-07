package BusinessServices.Beans;

import java.io.Serializable;
import java.sql.Date;

/**
 *
 * @author H-URBINA-M
 */
public class BeanEjecucionPresupuestal implements Serializable {

    private String mode;
    private String Periodo;
    private String UnidadOperativa;
    private String SolicitudCredito;
    private String Certificado;
    private String CompromisoAnual;
    private String DeclaracionJurada;
    private String Cobertura;
    private String TipoCalendario;
    private String SubTipoCalendario;
    private String DocumentoReferencia;
    private String Oficio;
    private String Detalle;
    private String Estado;
    private String Dependencia;
    private String DisponibilidadPresupuestal;
    private String Unidad;
    private String Tipo;
    private String SecuenciaFuncional;
    private String TareaPresupuestal;
    private String CadenaGasto;
    private String TipoMoneda;
    private String FirmaJefe;
    private String FirmaSubJefe;
    private String Archivo;
    private String Mes;
    private String ProcesoSeleccion;
    private String Sectorista;
    private Date Fecha;
    private Integer Presupuesto;
    private Integer Correlativo;
    private Integer Resolucion;
    private Double Importe;
    private Double TipoCambio;
    private Double MonedaExtranjera;
    private Double Saldo;

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

    public String getSolicitudCredito() {
        return SolicitudCredito;
    }

    public void setSolicitudCredito(String SolicitudCredito) {
        this.SolicitudCredito = SolicitudCredito;
    }

    public String getCertificado() {
        return Certificado;
    }

    public void setCertificado(String Certificado) {
        this.Certificado = Certificado;
    }

    public String getCompromisoAnual() {
        return CompromisoAnual;
    }

    public void setCompromisoAnual(String CompromisoAnual) {
        this.CompromisoAnual = CompromisoAnual;
    }

    public String getDeclaracionJurada() {
        return DeclaracionJurada;
    }

    public void setDeclaracionJurada(String DeclaracionJurada) {
        this.DeclaracionJurada = DeclaracionJurada;
    }

    public String getCobertura() {
        return Cobertura;
    }

    public void setCobertura(String Cobertura) {
        this.Cobertura = Cobertura;
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

    public String getDocumentoReferencia() {
        return DocumentoReferencia;
    }

    public void setDocumentoReferencia(String DocumentoReferencia) {
        this.DocumentoReferencia = DocumentoReferencia;
    }

    public String getOficio() {
        return Oficio;
    }

    public void setOficio(String Oficio) {
        this.Oficio = Oficio;
    }

    public String getDetalle() {
        return Detalle;
    }

    public void setDetalle(String Detalle) {
        this.Detalle = Detalle;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public String getDependencia() {
        return Dependencia;
    }

    public void setDependencia(String Dependencia) {
        this.Dependencia = Dependencia;
    }

    public String getDisponibilidadPresupuestal() {
        return DisponibilidadPresupuestal;
    }

    public void setDisponibilidadPresupuestal(String DisponibilidadPresupuestal) {
        this.DisponibilidadPresupuestal = DisponibilidadPresupuestal;
    }

    public String getUnidad() {
        return Unidad;
    }

    public void setUnidad(String Unidad) {
        this.Unidad = Unidad;
    }

    public String getTipo() {
        return Tipo;
    }

    public void setTipo(String Tipo) {
        this.Tipo = Tipo;
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

    public String getTipoMoneda() {
        return TipoMoneda;
    }

    public void setTipoMoneda(String TipoMoneda) {
        this.TipoMoneda = TipoMoneda;
    }

    public String getFirmaJefe() {
        return FirmaJefe;
    }

    public void setFirmaJefe(String FirmaJefe) {
        this.FirmaJefe = FirmaJefe;
    }

    public String getFirmaSubJefe() {
        return FirmaSubJefe;
    }

    public void setFirmaSubJefe(String FirmaSubJefe) {
        this.FirmaSubJefe = FirmaSubJefe;
    }

    public String getArchivo() {
        return Archivo;
    }

    public void setArchivo(String Archivo) {
        this.Archivo = Archivo;
    }

    public String getMes() {
        return Mes;
    }

    public void setMes(String Mes) {
        this.Mes = Mes;
    }

    public String getProcesoSeleccion() {
        return ProcesoSeleccion;
    }

    public void setProcesoSeleccion(String ProcesoSeleccion) {
        this.ProcesoSeleccion = ProcesoSeleccion;
    }

    public String getSectorista() {
        return Sectorista;
    }

    public void setSectorista(String Sectorista) {
        this.Sectorista = Sectorista;
    }

    public Date getFecha() {
        return Fecha;
    }

    public void setFecha(Date Fecha) {
        this.Fecha = Fecha;
    }

    public Integer getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(Integer Presupuesto) {
        this.Presupuesto = Presupuesto;
    }

    public Integer getCorrelativo() {
        return Correlativo;
    }

    public void setCorrelativo(Integer Correlativo) {
        this.Correlativo = Correlativo;
    }

    public Integer getResolucion() {
        return Resolucion;
    }

    public void setResolucion(Integer Resolucion) {
        this.Resolucion = Resolucion;
    }

    public Double getImporte() {
        return Importe;
    }

    public void setImporte(Double Importe) {
        this.Importe = Importe;
    }

    public Double getTipoCambio() {
        return TipoCambio;
    }

    public void setTipoCambio(Double TipoCambio) {
        this.TipoCambio = TipoCambio;
    }

    public Double getMonedaExtranjera() {
        return MonedaExtranjera;
    }

    public void setMonedaExtranjera(Double MonedaExtranjera) {
        this.MonedaExtranjera = MonedaExtranjera;
    }

    public Double getSaldo() {
        return Saldo;
    }

    public void setSaldo(Double Saldo) {
        this.Saldo = Saldo;
    }

}
