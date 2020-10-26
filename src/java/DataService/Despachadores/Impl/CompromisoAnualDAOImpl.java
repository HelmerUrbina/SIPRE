/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanEjecucionPresupuestal;
import DataService.Despachadores.CompromisoAnualDAO;
import DataService.Despachadores.MsgerrDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public class CompromisoAnualDAOImpl implements CompromisoAnualDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEjecucionPresupuestal objBnCompromisoAnual;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public CompromisoAnualDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaCompromisosAnuales(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT "
                + "NROCER_CA, NUMCOR AS COBERTURA, UTIL_NEW.FUN_CERTIFICADO_SIAF(CODPER, COPPTO, COUUOO, NROCOB) CERTIFICADO, "
                + "REPLACE(REGEXP_REPLACE(UPPER(DESOCE),'[^A-Za-z0-9ÁÉÍÓÚáéíóú ]', ''),'\n"
                + "', ' ') AS DESOCE, REPLACE(REGEXP_REPLACE(UPPER(DOCREF),'[^A-Za-z0-9ÁÉÍÓÚáéíóú ]', ''),'\n"
                + "', ' ') AS DOCREF, DUSUARIO_CERRADO FECHA, CASE TIPSOL WHEN 'RE' THEN (-1)*MOCRPR ELSE MOCRPR END AS IMPORTE, TIPCAM, CASE TIPSOL WHEN 'RE' THEN (-1)*IMPDOL ELSE IMPDOL END AS EXTRANJERA,  "
                + "CASE ESTCCP WHEN 'PE' THEN 'PENDIENTE' WHEN 'CE' THEN 'CERRADO' WHEN 'AT' THEN 'ATENDIDO' WHEN 'AN' THEN 'ANULADO' WHEN 'RE' THEN 'RECHAZADO' ELSE '' END AS ESTADO, "
                + "CASE TIPSOL WHEN 'CE' THEN 'COMPROMISO' WHEN 'AM' THEN 'AMPLIACION' WHEN 'RE' THEN 'REBAJA' ELSE '' END AS TIP_SOL, "
                + "NUSOCP, NROCER, "
                + "CASE WHEN VFIRMA_JEFE IS NOT NULL THEN 'SI' ELSE 'NO' END FIRMA_JEFE, "
                + "CASE WHEN VFIRMA_SUBJEFE IS NOT NULL THEN 'SI' ELSE 'NO' END FIRMA_SUBJEFE, "
                + "UTIL_NEW.FUN_DESC_USUARIO(USUVER) AS SECTORISTA, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VTASOCP_CA_ARCHIVO),'[^A-Za-z0-9ÁÉÍÓÚáéíóú. ]', ''),'\n"
                + "', ' ') AS ARCHIVO "
                + "FROM TASOCP_CA WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? "
                + "ORDER BY NROCER_CA DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEjecucionPresupuestal.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnCompromisoAnual = new BeanEjecucionPresupuestal();
                objBnCompromisoAnual.setCompromisoAnual(objResultSet.getString("NROCER_CA"));
                objBnCompromisoAnual.setCobertura(objResultSet.getString("COBERTURA"));
                objBnCompromisoAnual.setCertificado(objResultSet.getString("CERTIFICADO"));
                objBnCompromisoAnual.setDetalle(objResultSet.getString("DESOCE"));
                objBnCompromisoAnual.setDocumentoReferencia(objResultSet.getString("DOCREF"));
                objBnCompromisoAnual.setFecha(objResultSet.getDate("FECHA"));
                objBnCompromisoAnual.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnCompromisoAnual.setTipoCambio(objResultSet.getDouble("TIPCAM"));
                objBnCompromisoAnual.setMonedaExtranjera(objResultSet.getDouble("EXTRANJERA"));
                objBnCompromisoAnual.setEstado(objResultSet.getString("ESTADO"));
                objBnCompromisoAnual.setTipo(objResultSet.getString("TIP_SOL"));
                objBnCompromisoAnual.setSolicitudCredito(objResultSet.getString("NROCER"));
                objBnCompromisoAnual.setSubTipoCalendario(objResultSet.getString("NUSOCP"));
                objBnCompromisoAnual.setFirmaJefe(objResultSet.getString("FIRMA_JEFE"));
                objBnCompromisoAnual.setFirmaSubJefe(objResultSet.getString("FIRMA_SUBJEFE"));
                objBnCompromisoAnual.setSectorista(objResultSet.getString("SECTORISTA"));
                objBnCompromisoAnual.setArchivo(objResultSet.getString("ARCHIVO"));
                lista.add(objBnCompromisoAnual);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsultaCompromisoAnual(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TASOCP");
            objBnMsgerr.setTipo(objBeanEjecucionPresupuestal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return lista;
    }

    @Override
    public List getListaCompromisosAnualesDetalle(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NROCER_CA, CORDET, UTIL_NEW.FUN_ABRDEP(COUUOO, CODDEP) AS CODDEP, "
                + "COUOAB||':'||UTIL_NEW.FUN_ABUUOO(COUOAB) AS PROVEEDOR, "
                + "SECFUN||':'||UTIL_NEW.FUN_CODIGO_COCAFU(CODPER,COPPTO, SECFUN) AS SECFUN, "
                + "COMEOP||':'||UTIL_NEW.FUN_NOMEOP(COMEOP) AS COMEOP, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOCLAS(COCAGA) AS COCAGA, "
                + "IMPORT, TIPCAM, IMPDOL "
                + "FROM DESOCP_CA WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=?  "
                + "ORDER BY NROCER_CA, CORDET";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEjecucionPresupuestal.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnCompromisoAnual = new BeanEjecucionPresupuestal();
                objBnCompromisoAnual.setCompromisoAnual(objResultSet.getString("NROCER_CA"));
                objBnCompromisoAnual.setCorrelativo(objResultSet.getInt("CORDET"));
                objBnCompromisoAnual.setDependencia(objResultSet.getString("CODDEP"));
                objBnCompromisoAnual.setSecuenciaFuncional(objResultSet.getString("SECFUN"));
                objBnCompromisoAnual.setTareaPresupuestal(objResultSet.getString("COMEOP"));
                objBnCompromisoAnual.setCadenaGasto(objResultSet.getString("COCAGA"));
                objBnCompromisoAnual.setUnidad(objResultSet.getString("PROVEEDOR"));
                objBnCompromisoAnual.setImporte(objResultSet.getDouble("IMPORT"));
                objBnCompromisoAnual.setTipoCambio(objResultSet.getDouble("TIPCAM"));
                objBnCompromisoAnual.setMonedaExtranjera(objResultSet.getDouble("IMPDOL"));
                lista.add(objBnCompromisoAnual);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsultaCompromisoAnualDetalle(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("DESOCP");
            objBnMsgerr.setTipo(objBeanEjecucionPresupuestal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return lista;
    }

    @Override
    public ArrayList getListaCompromisoAnualDetalle(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT CORDET, CODDEP||':'||UTIL_NEW.FUN_ABRDEP(COUUOO, CODDEP) AS DEPENDENCIA, "
                + "COUOAB||':'||UTIL_NEW.FUN_ABUUOO(COUOAB) AS PROVEEDOR, "
                + "SECFUN||':'||UTIL_NEW.FUN_CODIGO_COCAFU(CODPER, COPPTO, SECFUN) AS SECUENCIA, "
                + "COMEOP||':'||UTIL_NEW.FUN_NTAREA(COMEOP) AS TAREA, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(COCAGA) AS CADENA_GASTO,"
                + "IMPORT AS IMPORTE, IMPDOL AS MONEDA_EXTRANJERA, "
                + "NCODIGO_RESOLUCION||':'||UTIL.FUN_DESCRIPCION_RESOLUCION(CODPER, NCODIGO_RESOLUCION) AS RESOLUCION "
                + "FROM DESOCP_CA WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "NROCER_CA=? "
                + "ORDER BY CORDET";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEjecucionPresupuestal.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEjecucionPresupuestal.getCompromisoAnual());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("DEPENDENCIA") + "+++"
                        + objResultSet.getString("PROVEEDOR") + "+++"
                        + objResultSet.getString("SECUENCIA") + "+++"
                        + objResultSet.getString("TAREA") + "+++"
                        + objResultSet.getString("CADENA_GASTO") + "+++"
                        + objResultSet.getDouble("IMPORTE") + "+++"
                        + objResultSet.getDouble("MONEDA_EXTRANJERA") + "+++"
                        + objResultSet.getString("RESOLUCION");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaCompromisoAnualDetalle(BeanCertificadoCreditoPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("DESOCP_CA");
            objBnMsgerr.setTipo(objBeanEjecucionPresupuestal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return Arreglo;
    }

    @Override
    public String getNumeroCompromisoAnual(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        String codigo = "";
        sql = "SELECT LPAD(NVL(MAX(SUBSTR(NROCER_CA,0,7)+1),'0000001'),7,0) AS CODIGO "
                + "FROM TASOCP_CA WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEjecucionPresupuestal.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                codigo = objResultSet.getString("CODIGO") + "A";
            } else {
                codigo = "0000001A";
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getNumeroCompromisoAnual(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TASOCP");
            objBnMsgerr.setTipo(objBeanEjecucionPresupuestal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return codigo;
    }

    @Override
    public String getTipoCalendarioSolicitud(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        String codigo = "";
        sql = "SELECT CODTIP AS CODIGO "
                + "FROM TASOCP WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "NROCER=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEjecucionPresupuestal.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEjecucionPresupuestal.getCompromisoAnual());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                codigo = objResultSet.getString("CODIGO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getTipoCalendarioSolicitud(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TASOCP");
            objBnMsgerr.setTipo(objBeanEjecucionPresupuestal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return codigo;
    }

    @Override
    public BeanEjecucionPresupuestal getCompromisoAnual(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        sql = "SELECT NROCER, NUMOFI, FECCCP, DOCREF, DESOCE, MOCRPR, TIPCAM, IMPDOL, CODMON, TIPSOL, NUSOCP "
                + "FROM TASOCP_CA WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "NROCER_CA=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEjecucionPresupuestal.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEjecucionPresupuestal.getCompromisoAnual());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanEjecucionPresupuestal.setSolicitudCredito(objResultSet.getString("NROCER"));
                objBeanEjecucionPresupuestal.setOficio(objResultSet.getString("NUMOFI"));
                objBeanEjecucionPresupuestal.setFecha(objResultSet.getDate("FECCCP"));
                objBeanEjecucionPresupuestal.setDocumentoReferencia(objResultSet.getString("DOCREF"));
                objBeanEjecucionPresupuestal.setDetalle(objResultSet.getString("DESOCE"));
                objBeanEjecucionPresupuestal.setImporte(objResultSet.getDouble("MOCRPR"));
                objBeanEjecucionPresupuestal.setTipoMoneda(objResultSet.getString("CODMON"));
                objBeanEjecucionPresupuestal.setTipoCambio(objResultSet.getDouble("TIPCAM"));
                objBeanEjecucionPresupuestal.setMonedaExtranjera(objResultSet.getDouble("IMPDOL"));
                objBeanEjecucionPresupuestal.setTipo(objResultSet.getString("TIPSOL"));
                objBeanEjecucionPresupuestal.setSectorista(objResultSet.getString("NUSOCP"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCompromisoAnual(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TASOCP");
            objBnMsgerr.setTipo(objBeanEjecucionPresupuestal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return objBeanEjecucionPresupuestal;
    }

    @Override
    public int iduCompromisoAnual(BeanEjecucionPresupuestal objBeanCompromisoAnual, String usuario) {
        s = 0;
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_TASOCP_CA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";

        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanCompromisoAnual.getPeriodo());
            cs.setString(2, objBeanCompromisoAnual.getUnidadOperativa());
            cs.setInt(3, objBeanCompromisoAnual.getPresupuesto());
            cs.setString(4, objBeanCompromisoAnual.getCompromisoAnual());
            cs.setString(5, objBeanCompromisoAnual.getSolicitudCredito());
            cs.setString(6, objBeanCompromisoAnual.getTipoCalendario());
            cs.setString(7, objBeanCompromisoAnual.getSubTipoCalendario());
            cs.setString(8, "");
            cs.setString(9, objBeanCompromisoAnual.getCertificado());
            cs.setString(10, objBeanCompromisoAnual.getDocumentoReferencia());
            cs.setString(11, objBeanCompromisoAnual.getOficio());
            cs.setString(12, objBeanCompromisoAnual.getDetalle());
            cs.setDate(13, objBeanCompromisoAnual.getFecha());
            cs.setDouble(14, objBeanCompromisoAnual.getImporte());
            cs.setString(15, objBeanCompromisoAnual.getTipoMoneda());
            cs.setDouble(16, objBeanCompromisoAnual.getTipoCambio());
            cs.setDouble(17, objBeanCompromisoAnual.getMonedaExtranjera());
            cs.setString(18, objBeanCompromisoAnual.getTipo());
            cs.setString(19, objBeanCompromisoAnual.getUnidad());
            cs.setString(20, usuario);
            cs.setString(21, objBeanCompromisoAnual.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduCompromisoAnual : " + e.getMessage());
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TASOCP_CA");
            objBnMsgerr.setTipo(objBeanCompromisoAnual.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduCompromisoAnualDetalle(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_DESOCP_CA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";

        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            cs.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            cs.setString(3, objBeanEjecucionPresupuestal.getUnidadOperativa());
            cs.setInt(4, objBeanEjecucionPresupuestal.getPresupuesto());
            cs.setString(5, objBeanEjecucionPresupuestal.getCompromisoAnual());
            cs.setInt(6, objBeanEjecucionPresupuestal.getCorrelativo());
            cs.setString(7, objBeanEjecucionPresupuestal.getDependencia());
            cs.setString(8, objBeanEjecucionPresupuestal.getSecuenciaFuncional());
            cs.setString(9, objBeanEjecucionPresupuestal.getTareaPresupuestal());
            cs.setString(10, objBeanEjecucionPresupuestal.getCadenaGasto());
            cs.setString(11, objBeanEjecucionPresupuestal.getUnidad());
            cs.setDouble(12, objBeanEjecucionPresupuestal.getImporte());
            cs.setString(13, objBeanEjecucionPresupuestal.getTipoMoneda());
            cs.setDouble(14, objBeanEjecucionPresupuestal.getTipoCambio());
            cs.setDouble(15, objBeanEjecucionPresupuestal.getMonedaExtranjera());
            cs.setInt(16, objBeanEjecucionPresupuestal.getResolucion());
            cs.setString(17, objBeanEjecucionPresupuestal.getTipoCalendario());
            cs.setString(18, usuario);
            cs.setString(19, objBeanEjecucionPresupuestal.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduCompromisoAnualDetalle : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("DESOCP_CA");
            objBnMsgerr.setTipo(objBeanEjecucionPresupuestal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduTransferirCompromisoAnual(BeanEjecucionPresupuestal objBeanCompromisoAnual, String usuario) {
        s = 0;
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_TRANSFERIR_COMPROMISO_ANUAL(?,?,?,?,?,?)}";

        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanCompromisoAnual.getPeriodo());
            cs.setInt(2, objBeanCompromisoAnual.getPresupuesto());
            cs.setString(3, objBeanCompromisoAnual.getUnidadOperativa());
            cs.setString(4, objBeanCompromisoAnual.getCompromisoAnual());
            cs.setString(5, objBeanCompromisoAnual.getCompromisoAnual());
            cs.setString(6, usuario);
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduTransferirCompromisoAnual : " + e.getMessage());
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TASOCP_CA");
            objBnMsgerr.setTipo(objBeanCompromisoAnual.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
