/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanEjecucionPresupuestal;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.CertificadoPresupuestalDAO;
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
public class CertificadoPresupuestalDAOImpl implements CertificadoPresupuestalDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEjecucionPresupuestal objBnCertificado;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public CertificadoPresupuestalDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaCertificados(BeanEjecucionPresupuestal objBeanCertificado, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT TIPSOL||'.'||NROCER AS ID,"
                + "NROCER, REPLACE(REGEXP_REPLACE(UPPER(DOCREF),'[^A-Za-z0-9ÁÉÍÓÚáéíóú ]', ''),'\n"
                + "', ' ') AS DOCREF, REPLACE(REGEXP_REPLACE(UPPER(DESOCE),'[^A-Za-z0-9ÁÉÍÓÚáéíóú ]', ''),'\n"
                + "', ' ') AS DESOCE, DUSUARIO_CERRADO AS FECHA, "
                + "CASE TIPSOL WHEN 'RE' THEN (-1)*MOCRPR ELSE MOCRPR END AS IMPORTE, TIPCAM, CASE TIPSOL WHEN 'RE' THEN (-1)*IMPDOL ELSE IMPDOL END AS EXTRANJERA, "
                + "NROCOB||'-'||UTIL_NEW.FUN_MEMORAMDUN(CODPER, COPPTO, NROCOB) AS NROCOB, "
                + "CASE ESTCCP WHEN 'PE' THEN 'PENDIENTE' WHEN 'CE' THEN 'CERRADO' WHEN 'AT' THEN 'ATENDIDO' WHEN 'AN' THEN 'ANULADA' ELSE ' ' END AS ESTADO, "
                + "UTIL_NEW.FUN_CERTIFICADO_SIAF(CODPER, COPPTO, COUUOO, NROCOB) AS NRO_SIAF, "
                + "CASE TIPSOL WHEN 'CE' THEN 'CERTIFICADO' WHEN 'AM' THEN 'AMPLIACION' WHEN 'RE' THEN 'REBAJA' ELSE '' END AS TIP_SOL, NUSOCP, NUMOPI,"
                + "LOGISTICA.FUN_PAC_PROCESO_DESCRIPCION(CODPER, COPPTO, COUUOO, NROPRO) AS PROCESO, CODTIP, COSTIP, "
                + "CASE CESTADO_PRIORIZACION WHEN 'AP' THEN 'SI' ELSE CASE CSOLICITUD_PRIORIZACION WHEN 'Y' THEN 'CHECK' ELSE 'NO' END END PRIORIZACION, "
                + "CASE WHEN VFIRMA_JEFE IS NOT NULL THEN 'SI' ELSE 'NO' END FIRMA_JEFE, "
                + "CASE WHEN VFIRMA_SUBJEFE IS NOT NULL THEN 'SI' ELSE 'NO' END FIRMA_SUBJEFE, "
                + "UTIL_NEW.FUN_FECHA_MEMORAMDUN(CODPER, COPPTO, NROCOB) AS FECHA_APROBACION, "
                + "UTIL_NEW.FUN_DESC_USUARIO(UTIL_NEW.FUN_USUARIO_COBERTURA(CODPER, NROCOB)) AS SECTORISTA, "
                + "VTASOCP_ARCHIVO AS ARCHIVO "
                + "FROM TASOCP WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? "
                + "ORDER BY NROCER DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCertificado.getPeriodo());
            objPreparedStatement.setString(2, objBeanCertificado.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanCertificado.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnCertificado = new BeanEjecucionPresupuestal();
                objBnCertificado.setMode(objResultSet.getString("ID"));
                objBnCertificado.setSolicitudCredito(objResultSet.getString("NROCER"));
                objBnCertificado.setDocumentoReferencia(objResultSet.getString("DOCREF"));
                objBnCertificado.setDetalle(objResultSet.getString("DESOCE"));
                objBnCertificado.setFecha(objResultSet.getDate("FECHA"));
                objBnCertificado.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnCertificado.setTipoCambio(objResultSet.getDouble("TIPCAM"));
                objBnCertificado.setMonedaExtranjera(objResultSet.getDouble("EXTRANJERA"));
                objBnCertificado.setCobertura(objResultSet.getString("NROCOB"));
                objBnCertificado.setEstado(objResultSet.getString("ESTADO"));
                objBnCertificado.setTipo(objResultSet.getString("TIP_SOL"));
                objBnCertificado.setCertificado(objResultSet.getString("NRO_SIAF"));
                objBnCertificado.setDependencia(objResultSet.getString("NUMOPI"));
                objBnCertificado.setProcesoSeleccion(objResultSet.getString("PROCESO"));
                objBnCertificado.setTipoCalendario(objResultSet.getString("CODTIP"));
                objBnCertificado.setSubTipoCalendario(objResultSet.getString("COSTIP"));
                objBnCertificado.setCadenaGasto(objResultSet.getString("NUSOCP"));
                objBnCertificado.setTareaPresupuestal(objResultSet.getString("PRIORIZACION"));
                objBnCertificado.setFirmaJefe(objResultSet.getString("FIRMA_JEFE"));
                objBnCertificado.setFirmaSubJefe(objResultSet.getString("FIRMA_SUBJEFE"));
                objBnCertificado.setUnidad(objResultSet.getString("FECHA_APROBACION"));
                objBnCertificado.setSectorista(objResultSet.getString("SECTORISTA"));
                objBnCertificado.setArchivo(objResultSet.getString("ARCHIVO"));
                lista.add(objBnCertificado);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaCertificados(BeanCertificadoCreditoPresupuestal) : " + e.getMessage());
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
    public List getListaCertificadosDetalle(BeanEjecucionPresupuestal objBeanCertificado, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NROCER, CORDET, UTIL_NEW.FUN_ABRDEP(COUUOO, CODDEP) AS CODDEP, "
                + "SECFUN||':'||UTIL_NEW.FUN_CODIGO_COCAFU(CODPER,COPPTO, SECFUN) AS SECFUN, "
                + "COMEOP||':'||UTIL_NEW.FUN_NTAREA(COMEOP) AS TAREA, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(COCAGA) AS COCAGA,"
                + "IMPORT, TIPCAM, IMPDOL "
                + "FROM DESOCP WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? "
                + "ORDER BY CORDET";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCertificado.getPeriodo());
            objPreparedStatement.setString(2, objBeanCertificado.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanCertificado.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnCertificado = new BeanEjecucionPresupuestal();
                objBnCertificado.setSolicitudCredito(objResultSet.getString("NROCER"));
                objBnCertificado.setCorrelativo(objResultSet.getInt("CORDET"));
                objBnCertificado.setDependencia(objResultSet.getString("CODDEP"));
                objBnCertificado.setSecuenciaFuncional(objResultSet.getString("SECFUN"));
                objBnCertificado.setTareaPresupuestal(objResultSet.getString("TAREA"));
                objBnCertificado.setCadenaGasto(objResultSet.getString("COCAGA"));
                objBnCertificado.setImporte(objResultSet.getDouble("IMPORT"));
                objBnCertificado.setTipoCambio(objResultSet.getDouble("TIPCAM"));
                objBnCertificado.setMonedaExtranjera(objResultSet.getDouble("IMPDOL"));
                lista.add(objBnCertificado);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaCertificadosDetalle(BeanCertificadoCreditoPresupuestal) : " + e.getMessage());
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
    public ArrayList getListaCertificadoDetalle(BeanEjecucionPresupuestal objBeanCertificado, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT CORDET, CODDEP||':'||UTIL_NEW.FUN_ABRDEP(COUUOO, CODDEP) AS DEPENDENCIA, "
                + "SECFUN||':'||UTIL_NEW.FUN_CODIGO_COCAFU(CODPER,COPPTO, SECFUN) AS SECUENCIA, "
                + "COMEOP||':'||UTIL_NEW.FUN_NTAREA(COMEOP) AS TAREA, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(COCAGA) AS CADENA_GASTO,"
                + "IMPORT AS IMPORTE, IMPDOL AS MONEDA_EXTRANJERA, "
                + "NCODIGO_RESOLUCION||':'||UTIL.FUN_DESCRIPCION_RESOLUCION(CODPER, NCODIGO_RESOLUCION) AS RESOLUCION "
                + "FROM DESOCP WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "NROCER=? "
                + "ORDER BY CORDET";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCertificado.getPeriodo());
            objPreparedStatement.setString(2, objBeanCertificado.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanCertificado.getPresupuesto());
            objPreparedStatement.setString(4, objBeanCertificado.getSolicitudCredito());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("DEPENDENCIA") + "+++"
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
            System.out.println("Error al obtener getListaCertificadoDetalle(BeanCertificadoCreditoPresupuestal) : " + e.getMessage());
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
    public String getNumeroCertificado(BeanEjecucionPresupuestal objBeanCertificado, String usuario) {
        String codigo = "";
        sql = "SELECT LPAD(NVL(MAX(SUBSTR(NROCER,0,7)+1),'0000001'),7,0) AS CODIGO "
                + "FROM TASOCP WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCertificado.getPeriodo());
            objPreparedStatement.setString(2, objBeanCertificado.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanCertificado.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                codigo = objResultSet.getString("CODIGO") + "A";
            } else {
                codigo = "0000001A";
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getNumeroCertificado(BeanCertificadoCreditoPresupuestal) : " + e.getMessage());
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
    public BeanEjecucionPresupuestal getCertificado(BeanEjecucionPresupuestal objBeanCertificado, String usuario) {
        sql = "SELECT NROCER, CODTIP, COSTIP, NVL(NUMOFI, ' ') AS NUMOFI, FECCCP, NROPRO, "
                + "NVL(DOCREF, ' ') AS DOCREF, NVL(DESOCE, ' ') AS DESOCE, MOCRPR, TIPCAM, "
                + "IMPDOL, CODMON, NVL(NUSOCP, ' ') AS NUSOCP,"
                + "COSTIP||':'||UTIL_NEW.FUN_DSCSTIP(COSTIP, COPPTO, CODTIP) AS SUBTIPO_CAL, NUMOPI "
                + "FROM TASOCP WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "NROCER=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCertificado.getPeriodo());
            objPreparedStatement.setString(2, objBeanCertificado.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanCertificado.getPresupuesto());
            objPreparedStatement.setString(4, objBeanCertificado.getSolicitudCredito().toUpperCase());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanCertificado.setSolicitudCredito(objResultSet.getString("NROCER"));
                objBeanCertificado.setTipoCalendario(objResultSet.getString("CODTIP"));
                objBeanCertificado.setSubTipoCalendario(objResultSet.getString("COSTIP"));
                objBeanCertificado.setOficio(objResultSet.getString("NUMOFI"));
                objBeanCertificado.setFecha(objResultSet.getDate("FECCCP"));
                objBeanCertificado.setProcesoSeleccion(objResultSet.getString("NROPRO"));
                objBeanCertificado.setDocumentoReferencia(objResultSet.getString("DOCREF"));
                objBeanCertificado.setDetalle(objResultSet.getString("DESOCE"));
                objBeanCertificado.setImporte(objResultSet.getDouble("MOCRPR"));
                objBeanCertificado.setTipoMoneda(objResultSet.getString("CODMON"));
                objBeanCertificado.setTipoCambio(objResultSet.getDouble("TIPCAM"));
                objBeanCertificado.setMonedaExtranjera(objResultSet.getDouble("IMPDOL"));
                objBeanCertificado.setCertificado(objResultSet.getString("NUSOCP"));
                objBeanCertificado.setDependencia(objResultSet.getString("NUMOPI"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCertificado(BeanCertificadoCreditoPresupuestal) : " + e.getMessage());
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
        return objBeanCertificado;
    }

    @Override
    public String iduCertificado(BeanEjecucionPresupuestal objBnCertificado, String usuario) {
        String codigo = "";
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_TASOCP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBnCertificado.getPeriodo());
            cs.setString(2, objBnCertificado.getUnidadOperativa());
            cs.setInt(3, objBnCertificado.getPresupuesto());
            cs.setString(4, objBnCertificado.getSolicitudCredito());
            cs.setString(5, objBnCertificado.getTipoCalendario());
            cs.setString(6, objBnCertificado.getSubTipoCalendario());
            cs.setString(7, "");
            cs.setString(8, objBnCertificado.getProcesoSeleccion());
            cs.setString(9, objBnCertificado.getCertificado());
            cs.setString(10, objBnCertificado.getDocumentoReferencia());
            cs.setString(11, objBnCertificado.getOficio());
            cs.setString(12, objBnCertificado.getDetalle());
            cs.setDate(13, objBnCertificado.getFecha());
            cs.setDouble(14, objBnCertificado.getImporte());
            cs.setString(15, objBnCertificado.getTipoMoneda());
            cs.setDouble(16, objBnCertificado.getTipoCambio());
            cs.setDouble(17, objBnCertificado.getMonedaExtranjera());
            cs.setString(18, objBnCertificado.getTipo());
            cs.setString(19, objBnCertificado.getDisponibilidadPresupuestal());
            cs.setString(20, usuario);
            cs.setString(21, objBnCertificado.getMode());
            cs.registerOutParameter(22, java.sql.Types.VARCHAR);
            cs.executeUpdate();
            codigo = cs.getString(22);
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduCertificado : " + e.getMessage());
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TASOCP");
            objBnMsgerr.setTipo(objBnCertificado.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return "0";
        }
        return codigo;
    }

    @Override
    public int iduCertificadoDetalle(BeanEjecucionPresupuestal objBeanCertificado, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_DESOCP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanCertificado.getPeriodo());
            cs.setString(2, objBeanCertificado.getUnidadOperativa());
            cs.setString(3, objBeanCertificado.getUnidadOperativa());
            cs.setInt(4, objBeanCertificado.getPresupuesto());
            cs.setString(5, objBeanCertificado.getSolicitudCredito());
            cs.setInt(6, objBeanCertificado.getCorrelativo());
            cs.setString(7, objBeanCertificado.getDependencia());
            cs.setString(8, objBeanCertificado.getSecuenciaFuncional());
            cs.setString(9, objBeanCertificado.getTareaPresupuestal());
            cs.setString(10, objBeanCertificado.getCadenaGasto());
            cs.setString(11, objBeanCertificado.getUnidad());
            cs.setDouble(12, objBeanCertificado.getImporte());
            cs.setString(13, objBeanCertificado.getTipoMoneda());
            cs.setDouble(14, objBeanCertificado.getTipoCambio());
            cs.setDouble(15, objBeanCertificado.getMonedaExtranjera());
            cs.setDouble(16, objBeanCertificado.getResolucion());
            cs.setString(17, usuario);
            cs.setString(18, objBeanCertificado.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduCertificadoDetalle : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TASOCP");
            objBnMsgerr.setTipo(objBeanCertificado.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduGenerarSolicitud(BeanEjecucionPresupuestal objBeanCertificado, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_GENERAR_COBERTURA_A(?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanCertificado.getPeriodo());
            cs.setString(2, objBeanCertificado.getUnidadOperativa());
            cs.setInt(3, objBeanCertificado.getPresupuesto());
            cs.setString(4, objBeanCertificado.getSolicitudCredito());
            cs.setString(5, usuario);
            cs.setString(6, objBeanCertificado.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduGenerarSolicitud : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TASOCP");
            objBnMsgerr.setTipo(objBeanCertificado.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduCertificadoSIAF(BeanEjecucionPresupuestal objBeanCertificado, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_UPD_NUMERO_CERTIFICADO(?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanCertificado.getPeriodo());
            cs.setInt(2, objBeanCertificado.getPresupuesto());
            cs.setString(3, objBeanCertificado.getUnidadOperativa());
            cs.setString(4, objBeanCertificado.getSolicitudCredito());
            cs.setString(5, objBeanCertificado.getCertificado().trim());
            cs.setString(6, usuario);
            cs.setString(7, objBeanCertificado.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduCertificadoSIAF : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TASOCP");
            objBnMsgerr.setTipo(objBeanCertificado.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }
}