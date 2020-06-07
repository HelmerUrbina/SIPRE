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
public class BeanNotaModificatoria implements Serializable {

    private String Mode;
    private String Periodo;
    private String Mes;
    private String UnidadOperativa;
    private String Dependencia;
    private String Presupuesto;
    private String Codigo;
    private String Tipo;
    private String Justificacion;
    private String NotaModificatoria;
    private String Estado;
    private String Descripcion;
    private String FuenteFinanciamiento;
    private String SecuenciaFuncional;
    private String CadenaGasto;
    private String Tarea;
    private String Unidad;
    private String CategoriaPresupuestal;
    private String Producto;
    private String Actividad;
    private String Importancia;
    private String Financiamiento;
    private String Consecuencia;
    private String Variacion;
    private String Consolidado;
    private String TipoCalendario;
    private String Usuario;
    private String UsuarioCierre;
    private String UsuarioVerifica;
    private String UsuarioRechazo;
    private String UsuarioAprobacion;
    private Integer Detalle;
    private Integer Resolucion;
    private Integer SIAF;
    private Double Importe;
    private Double ImporteAnulacion;
    private Double ImporteCredito;
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
    private Double Saldo;
    private Date Fecha;
    private Date FechaCierre;
    private Date FechaVerifica;
    private Date FechaRechazo;
    private Date FechaAprobacion;

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

    public String getMes() {
        return Mes;
    }

    public void setMes(String Mes) {
        this.Mes = Mes;
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

    public String getPresupuesto() {
        return Presupuesto;
    }

    public void setPresupuesto(String Presupuesto) {
        this.Presupuesto = Presupuesto;
    }

    public String getCodigo() {
        return Codigo;
    }

    public void setCodigo(String Codigo) {
        this.Codigo = Codigo;
    }

    public String getTipo() {
        return Tipo;
    }

    public void setTipo(String Tipo) {
        this.Tipo = Tipo;
    }

    public String getJustificacion() {
        return Justificacion;
    }

    public void setJustificacion(String Justificacion) {
        this.Justificacion = Justificacion;
    }

    public String getNotaModificatoria() {
        return NotaModificatoria;
    }

    public void setNotaModificatoria(String NotaModificatoria) {
        this.NotaModificatoria = NotaModificatoria;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public String getDescripcion() {
        return Descripcion;
    }

    public void setDescripcion(String Descripcion) {
        this.Descripcion = Descripcion;
    }

    public String getFuenteFinanciamiento() {
        return FuenteFinanciamiento;
    }

    public void setFuenteFinanciamiento(String FuenteFinanciamiento) {
        this.FuenteFinanciamiento = FuenteFinanciamiento;
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

    public String getTarea() {
        return Tarea;
    }

    public void setTarea(String Tarea) {
        this.Tarea = Tarea;
    }

    public String getUnidad() {
        return Unidad;
    }

    public void setUnidad(String Unidad) {
        this.Unidad = Unidad;
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
    

    public String getImportancia() {
        return Importancia;
    }

    public void setImportancia(String Importancia) {
        this.Importancia = Importancia;
    }

    public String getFinanciamiento() {
        return Financiamiento;
    }

    public void setFinanciamiento(String Financiamiento) {
        this.Financiamiento = Financiamiento;
    }

    public String getConsecuencia() {
        return Consecuencia;
    }

    public void setConsecuencia(String Consecuencia) {
        this.Consecuencia = Consecuencia;
    }

    public String getVariacion() {
        return Variacion;
    }

    public void setVariacion(String Variacion) {
        this.Variacion = Variacion;
    }

    public String getConsolidado() {
        return Consolidado;
    }

    public void setConsolidado(String Consolidado) {
        this.Consolidado = Consolidado;
    }

    public String getTipoCalendario() {
        return TipoCalendario;
    }

    public void setTipoCalendario(String TipoCalendario) {
        this.TipoCalendario = TipoCalendario;
    }

    public String getUsuario() {
        return Usuario;
    }

    public void setUsuario(String Usuario) {
        this.Usuario = Usuario;
    }

    public String getUsuarioCierre() {
        return UsuarioCierre;
    }

    public void setUsuarioCierre(String UsuarioCierre) {
        this.UsuarioCierre = UsuarioCierre;
    }

    public String getUsuarioVerifica() {
        return UsuarioVerifica;
    }

    public void setUsuarioVerifica(String UsuarioVerifica) {
        this.UsuarioVerifica = UsuarioVerifica;
    }

    public String getUsuarioRechazo() {
        return UsuarioRechazo;
    }

    public void setUsuarioRechazo(String UsuarioRechazo) {
        this.UsuarioRechazo = UsuarioRechazo;
    }

    public String getUsuarioAprobacion() {
        return UsuarioAprobacion;
    }

    public void setUsuarioAprobacion(String UsuarioAprobacion) {
        this.UsuarioAprobacion = UsuarioAprobacion;
    }

    public Integer getDetalle() {
        return Detalle;
    }

    public void setDetalle(Integer Detalle) {
        this.Detalle = Detalle;
    }

    public Integer getResolucion() {
        return Resolucion;
    }

    public void setResolucion(Integer Resolucion) {
        this.Resolucion = Resolucion;
    }

    public Integer getSIAF() {
        return SIAF;
    }

    public void setSIAF(Integer SIAF) {
        this.SIAF = SIAF;
    }

    public Double getImporte() {
        return Importe;
    }

    public void setImporte(Double Importe) {
        this.Importe = Importe;
    }

    public Double getImporteAnulacion() {
        return ImporteAnulacion;
    }

    public void setImporteAnulacion(Double ImporteAnulacion) {
        this.ImporteAnulacion = ImporteAnulacion;
    }

    public Double getImporteCredito() {
        return ImporteCredito;
    }

    public void setImporteCredito(Double ImporteCredito) {
        this.ImporteCredito = ImporteCredito;
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

    public Double getSaldo() {
        return Saldo;
    }

    public void setSaldo(Double Saldo) {
        this.Saldo = Saldo;
    }

    public Date getFecha() {
        return Fecha;
    }

    public void setFecha(Date Fecha) {
        this.Fecha = Fecha;
    }

    public Date getFechaCierre() {
        return FechaCierre;
    }

    public void setFechaCierre(Date FechaCierre) {
        this.FechaCierre = FechaCierre;
    }

    public Date getFechaVerifica() {
        return FechaVerifica;
    }

    public void setFechaVerifica(Date FechaVerifica) {
        this.FechaVerifica = FechaVerifica;
    }

    public Date getFechaRechazo() {
        return FechaRechazo;
    }

    public void setFechaRechazo(Date FechaRechazo) {
        this.FechaRechazo = FechaRechazo;
    }

    public Date getFechaAprobacion() {
        return FechaAprobacion;
    }

    public void setFechaAprobacion(Date FechaAprobacion) {
        this.FechaAprobacion = FechaAprobacion;
    }
    
}
