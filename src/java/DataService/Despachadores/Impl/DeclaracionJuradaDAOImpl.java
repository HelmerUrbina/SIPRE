/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanEjecucionPresupuestal;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.DeclaracionJuradaDAO;
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
public class DeclaracionJuradaDAOImpl implements DeclaracionJuradaDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEjecucionPresupuestal objBnDeclaracionJurada;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public DeclaracionJuradaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaDeclaracionJurada(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NUMPED AS PEDIDO, NROCER AS COMPROMISO, REPLACE(REGEXP_REPLACE(UPPER(NUMOFI),'[^A-Za-z0-9ÁÉÍÓÚáéíóú ]', ''),'\n"
                + "', ' ') AS OFICIO, REPLACE(REGEXP_REPLACE(UPPER(DESGLO),'[^A-Za-z0-9ÁÉÍÓÚáéíóú ]', ''),'\n"
                + "', ' ') AS DETALLE, "
                + "NROCOB AS COBERTURA, CODTIP||'-'||COSTIP AS TIPO_CALENDARIO, DUSUARIO_CERRADO AS FECHA, "
                + "TOTCOB AS IMPORTE, TOTDOL AS IMPDOL, TIPCAM,  "
                + "CASE ESTENV WHEN 'CO' THEN 'ATENDIDO' ELSE CASE ESTCOB WHEN 'PE' THEN 'PENDIENTE' WHEN 'CE' THEN 'CERRADO'  WHEN 'AN' THEN 'ANULADO' ELSE ' ' END END AS ESTADO, NUMOPI, "
                + "CASE WHEN VFIRMA_JEFE IS NOT NULL THEN 'SI' ELSE 'NO' END FIRMA_JEFE, "
                + "CASE WHEN VFIRMA_SUBJEFE IS NOT NULL THEN 'SI' ELSE 'NO' END FIRMA_SUBJEFE, "
                + "UTIL_NEW.FUN_DESC_USUARIO(UTIL_NEW.FUN_USUARIO_COBERTURA(CODPER, NROCOB)) AS SECTORISTA, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VTAPECO_ARCHIVO),'[^A-Za-z0-9ÁÉÍÓÚáéíóú. ]', ''),'\n"
                + "', ' ') AS ARCHIVO "
                + "FROM TAPECO WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "MESPER=? "
                + "ORDER BY PEDIDO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEjecucionPresupuestal.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEjecucionPresupuestal.getMes());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDeclaracionJurada = new BeanEjecucionPresupuestal();
                objBnDeclaracionJurada.setDeclaracionJurada(objResultSet.getString("PEDIDO"));
                objBnDeclaracionJurada.setCompromisoAnual(objResultSet.getString("COMPROMISO"));
                objBnDeclaracionJurada.setDocumentoReferencia(objResultSet.getString("OFICIO"));
                objBnDeclaracionJurada.setDetalle(objResultSet.getString("DETALLE"));
                objBnDeclaracionJurada.setCobertura(objResultSet.getString("COBERTURA"));
                objBnDeclaracionJurada.setTipoCalendario(objResultSet.getString("TIPO_CALENDARIO"));
                objBnDeclaracionJurada.setFecha(objResultSet.getDate("FECHA"));
                objBnDeclaracionJurada.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnDeclaracionJurada.setTipoCambio(objResultSet.getDouble("TIPCAM"));
                objBnDeclaracionJurada.setMonedaExtranjera(objResultSet.getDouble("IMPDOL"));
                objBnDeclaracionJurada.setEstado(objResultSet.getString("ESTADO"));
                objBnDeclaracionJurada.setTipo(objResultSet.getString("NUMOPI"));
                objBnDeclaracionJurada.setFirmaJefe(objResultSet.getString("FIRMA_JEFE"));
                objBnDeclaracionJurada.setFirmaSubJefe(objResultSet.getString("FIRMA_SUBJEFE"));
                objBnDeclaracionJurada.setSectorista(objResultSet.getString("SECTORISTA"));
                objBnDeclaracionJurada.setArchivo(objResultSet.getString("ARCHIVO"));
                lista.add(objBnDeclaracionJurada);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDeclaracionJurada(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPECO");
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
    public List getListaDeclaracionJuradaDetalle(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NUMPED AS PEDIDO, CORDET AS CODIGO, UTIL_NEW.FUN_ABRDEP(COUOCO, CODDEP) AS ABRDEP, "
                + "SECFUN||':'||UTIL_NEW.FUN_CODIGO_COCAFU(CODPER,COPPTO, SECFUN) AS SECFUN, "
                + "COMEOP||':'||UTIL_NEW.FUN_NOMEOP(COMEOP) AS COMEOP, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOCLAS(COCAGA) AS COCAGA, "
                + "COUUOO||'-'||UTIL_NEW.FUN_ABUUOO(COUUOO) AS PROVEEDOR, "
                + "IMPORT AS IMPORT, IMPDOL AS IMPDOL "
                + "FROM DEPECO WHERE "
                + "CODPER = ? AND "
                + "COUOCO = ? AND "
                + "COPPTO = ? AND "
                + "MESPER = ?  "
                + "ORDER BY PEDIDO DESC, CODIGO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEjecucionPresupuestal.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEjecucionPresupuestal.getMes());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDeclaracionJurada = new BeanEjecucionPresupuestal();
                objBnDeclaracionJurada.setDeclaracionJurada(objResultSet.getString("PEDIDO"));
                objBnDeclaracionJurada.setCorrelativo(objResultSet.getInt("CODIGO"));
                objBnDeclaracionJurada.setDependencia(objResultSet.getString("ABRDEP"));
                objBnDeclaracionJurada.setSecuenciaFuncional(objResultSet.getString("SECFUN"));
                objBnDeclaracionJurada.setTareaPresupuestal(objResultSet.getString("COMEOP"));
                objBnDeclaracionJurada.setCadenaGasto(objResultSet.getString("COCAGA"));
                objBnDeclaracionJurada.setUnidad(objResultSet.getString("PROVEEDOR"));
                objBnDeclaracionJurada.setImporte(objResultSet.getDouble("IMPORT"));
                objBnDeclaracionJurada.setMonedaExtranjera(objResultSet.getDouble("IMPDOL"));
                lista.add(objBnDeclaracionJurada);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDeclaracionJuradaDetalle(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPECO");
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
    public String getNumeroDeclaracionJurada(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        String result = null;
        sql = "SELECT LPAD(NVL(MAX(NUMPED+1),1),7,0) AS NUMPED "
                + "FROM TAPECO WHERE "
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
                result = objResultSet.getString("NUMPED");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getNumeroDeclaracionJurada(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPECO");
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
        return result;
    }

    @Override
    public synchronized BeanEjecucionPresupuestal getTipoCalendarioCompromiso(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        sql = "SELECT CODTIP, DESOCE  "
                + "FROM TASOCP_CA WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "NROCER_CA=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEjecucionPresupuestal.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEjecucionPresupuestal.getCompromisoAnual());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanEjecucionPresupuestal.setTipoCalendario(objResultSet.getString("CODTIP"));
                objBeanEjecucionPresupuestal.setDocumentoReferencia(objResultSet.getString("DESOCE"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getTipoCalendarioCompromiso(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPECO");
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
    public BeanEjecucionPresupuestal getDeclaracionJurada(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        sql = "SELECT NROCER AS COMPROMISO, NUMOFI AS OFICIO, DESGLO AS DETALLE, PROVIE AS OBSERVACION, "
                + "CODTIP AS TIPO_CALENDARIO, FECPRO AS FECHA, NUMOPI, TIPCAM, "
                + "COSTIP AS SUBTIPO_CAL "
                + "FROM TAPECO WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "MESPER=? AND "
                + "NUMPED=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEjecucionPresupuestal.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEjecucionPresupuestal.getMes());
            objPreparedStatement.setString(5, objBeanEjecucionPresupuestal.getDeclaracionJurada());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanEjecucionPresupuestal.setCompromisoAnual(objResultSet.getString("COMPROMISO"));
                objBeanEjecucionPresupuestal.setDocumentoReferencia(objResultSet.getString("OFICIO"));
                objBeanEjecucionPresupuestal.setDetalle(objResultSet.getString("DETALLE"));
                objBeanEjecucionPresupuestal.setOficio(objResultSet.getString("OBSERVACION"));
                objBeanEjecucionPresupuestal.setTipoCalendario(objResultSet.getString("TIPO_CALENDARIO"));
                objBeanEjecucionPresupuestal.setFecha(objResultSet.getDate("FECHA"));
                objBeanEjecucionPresupuestal.setTipo(objResultSet.getString("NUMOPI"));
                objBeanEjecucionPresupuestal.setTipoCambio(objResultSet.getDouble("TIPCAM"));
                objBeanEjecucionPresupuestal.setSubTipoCalendario(objResultSet.getString("SUBTIPO_CAL"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getDeclaracionJurada(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPECO");
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
    public ArrayList getListaDetalleDeclaracionJurada(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT CORDET, CODDEP||':'||UTIL_NEW.FUN_ABRDEP(COUOCO, CODDEP) AS DEPENDENCIA, "
                + "COUUOO||':'||UTIL_NEW.FUN_ABUUOO(COUUOO) AS PROVEEDOR, "
                + "SECFUN||':'||UTIL_NEW.FUN_CODIGO_COCAFU(CODPER, COPPTO, SECFUN) AS SECUENCIA, "
                + "COMEOP||':'||UTIL_NEW.FUN_NTAREA(COMEOP) AS TAREA, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(COCAGA) AS CADENA_GASTO,"
                + "IMPORT AS IMPORTE, IMPDOL AS MONEDA_EXTRANJERA, "
                + "NCODIGO_RESOLUCION||':'||UTIL.FUN_DESCRIPCION_RESOLUCION(CODPER, NCODIGO_RESOLUCION) AS RESOLUCION "
                + "FROM DEPECO WHERE "
                + "CODPER=? AND "
                + "COUOCO=? AND "
                + "COPPTO=? AND "
                + "MESPER=? AND "
                + "NUMPED=? "
                + "ORDER BY CORDET";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEjecucionPresupuestal.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEjecucionPresupuestal.getMes());
            objPreparedStatement.setString(5, objBeanEjecucionPresupuestal.getDeclaracionJurada());
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
    public int iduDeclaracionJurada(BeanEjecucionPresupuestal objBeanDeclaracionJurada, String usuario) {
        s = 0;
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_DECLARACION_JURADA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanDeclaracionJurada.getPeriodo());
            cs.setInt(2, objBeanDeclaracionJurada.getPresupuesto());
            cs.setString(3, objBeanDeclaracionJurada.getMes());
            cs.setString(4, objBeanDeclaracionJurada.getUnidadOperativa());
            cs.setString(5, objBeanDeclaracionJurada.getDeclaracionJurada());
            cs.setString(6, objBeanDeclaracionJurada.getTipoCalendario());
            cs.setString(7, objBeanDeclaracionJurada.getSubTipoCalendario());
            cs.setString(8, objBeanDeclaracionJurada.getOficio());
            cs.setString(9, objBeanDeclaracionJurada.getDetalle());
            cs.setDouble(10, objBeanDeclaracionJurada.getTipoCambio());
            cs.setString(11, objBeanDeclaracionJurada.getDocumentoReferencia());
            cs.setDate(12, objBeanDeclaracionJurada.getFecha());
            cs.setDouble(13, objBeanDeclaracionJurada.getImporte());
            cs.setDouble(14, objBeanDeclaracionJurada.getMonedaExtranjera());
            cs.setString(15, objBeanDeclaracionJurada.getTipo());
            cs.setString(16, "");
            cs.setString(17, objBeanDeclaracionJurada.getTipoMoneda());
            cs.setString(18, objBeanDeclaracionJurada.getCompromisoAnual());
            cs.setString(19, usuario);
            cs.setString(20, objBeanDeclaracionJurada.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduDeclaracionJurada : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPECO");
            objBnMsgerr.setTipo(objBeanDeclaracionJurada.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduDeclaracionJuradaDetalle(BeanEjecucionPresupuestal objBeanDeclaracionJurada, String usuario) {
        sql = "{CALL SP_IDU_DECLARACION_JURADA_DETA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanDeclaracionJurada.getPeriodo());
            cs.setString(2, objBeanDeclaracionJurada.getUnidadOperativa());
            cs.setString(3, objBeanDeclaracionJurada.getUnidadOperativa());
            cs.setInt(4, objBeanDeclaracionJurada.getPresupuesto());
            cs.setString(5, objBeanDeclaracionJurada.getDeclaracionJurada());
            cs.setInt(6, objBeanDeclaracionJurada.getCorrelativo());
            cs.setString(7, objBeanDeclaracionJurada.getDependencia());
            cs.setString(8, objBeanDeclaracionJurada.getUnidad());
            cs.setString(9, objBeanDeclaracionJurada.getSecuenciaFuncional());
            cs.setString(10, objBeanDeclaracionJurada.getTareaPresupuestal());
            cs.setString(11, objBeanDeclaracionJurada.getCadenaGasto());
            cs.setDouble(12, objBeanDeclaracionJurada.getImporte());
            cs.setDouble(13, objBeanDeclaracionJurada.getTipoCambio());
            cs.setString(14, objBeanDeclaracionJurada.getTipoMoneda());
            cs.setDouble(15, objBeanDeclaracionJurada.getMonedaExtranjera());
            cs.setString(16, objBeanDeclaracionJurada.getCompromisoAnual());
            cs.setString(17, objBeanDeclaracionJurada.getMes());
            cs.setInt(18, Integer.valueOf(objBeanDeclaracionJurada.getDeclaracionJurada()));
            cs.setInt(19, objBeanDeclaracionJurada.getResolucion());
            cs.setString(20, usuario);
            cs.setString(21, objBeanDeclaracionJurada.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduDeclaracionJuradaDetalle : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("DEPECO");
            objBnMsgerr.setTipo(objBeanDeclaracionJurada.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduGenerarCoberturaMensual(BeanEjecucionPresupuestal objBeanDeclaracionJurada, String usuario) {
        sql = "{CALL SP_IDU_GENERAR_COBERTURA(?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanDeclaracionJurada.getPeriodo());
            cs.setInt(2, objBeanDeclaracionJurada.getPresupuesto());
            cs.setString(3, objBeanDeclaracionJurada.getUnidadOperativa());
            cs.setString(4, objBeanDeclaracionJurada.getDeclaracionJurada());
            cs.setString(5, usuario);
            cs.setString(6, objBeanDeclaracionJurada.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduGenerarCoberturaMensual : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPECO");
            objBnMsgerr.setTipo(objBeanDeclaracionJurada.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduTransferirCobertura(BeanEjecucionPresupuestal objBeanDeclaracionJurada, String usuario) {
        sql = "{CALL SP_TRANS_COBERTURAS(?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanDeclaracionJurada.getPeriodo());
            cs.setInt(2, objBeanDeclaracionJurada.getPresupuesto());
            cs.setString(3, objBeanDeclaracionJurada.getMes());
            cs.setString(4, objBeanDeclaracionJurada.getDeclaracionJurada());
            cs.setString(5, objBeanDeclaracionJurada.getDeclaracionJurada());
            cs.setInt(6, 0);
            cs.setInt(7, 0);
            cs.setInt(8, 0);
            cs.setInt(9, 0);
            cs.setString(10, usuario);
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduTransferirCobertura : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPECO");
            objBnMsgerr.setTipo(objBeanDeclaracionJurada.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
