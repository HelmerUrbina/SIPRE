/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanResolucionesAdministrativas;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.ResolucionesAdministrativasDAO;
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
public class ResolucionesAdministrativasDAOImpl implements ResolucionesAdministrativasDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanResolucionesAdministrativas objBnResoluciones;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ResolucionesAdministrativasDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaResolucionesAdministrativas(BeanResolucionesAdministrativas objBeanResoluaciones, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT TABRAD.NUMERA AS CODIGO, TABRAD.NROCOB AS COBERTURA, TABRAD.NUSIAF AS SIAF, "
                + "TABRAD.FECHRA AS FECHA, MAX(TABRAD.MONTRA) AS IMPORTE, SUM(DETRAD.COMOCS) AS COMPROMISO, "
                + "SUM(DETRAD.MONDEV) AS DEVENGADO, SUM(DETRAD.MONGIR) GIRADO, SUM(DETRAD.MONREV) REVERTIDO "
                + "FROM TABRAD LEFT OUTER JOIN DETRAD ON ( "
                + "TABRAD.CODPER = DETRAD.CODPER AND "
                + "TABRAD.COPPTO = DETRAD.COPPTO AND "
                + "TABRAD.COUUOO = DETRAD.COUUOO AND "
                + "TABRAD.NUMERA = DETRAD.NUMERA) WHERE "
                + "TABRAD.CODPER = ? AND "
                + "TABRAD.COPPTO = ? AND "
                + "TABRAD.COUUOO = ? AND "
                + "(TABRAD.ESTARA IS NULL OR TABRAD.ESTARA <> 'AN')  "
                + "GROUP BY TABRAD.NROCOB, TABRAD.NUMERA, TABRAD.NUSIAF, TABRAD.FECHRA "
                + "ORDER BY CODIGO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanResoluaciones.getPeriodo());
            objPreparedStatement.setInt(2, objBeanResoluaciones.getPresupuesto());
            objPreparedStatement.setString(3, objBeanResoluaciones.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnResoluciones = new BeanResolucionesAdministrativas();
                objBnResoluciones.setCodigo(objResultSet.getString("CODIGO"));
                objBnResoluciones.setCobertura(objResultSet.getString("COBERTURA"));
                objBnResoluciones.setSIAF(objResultSet.getString("SIAF"));
                objBnResoluciones.setFechaEmision(objResultSet.getDate("FECHA"));
                objBnResoluciones.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnResoluciones.setCompromiso(objResultSet.getDouble("COMPROMISO"));
                objBnResoluciones.setDevengado(objResultSet.getDouble("DEVENGADO"));
                objBnResoluciones.setGirado(objResultSet.getDouble("GIRADO"));
                objBnResoluciones.setRevertido(objResultSet.getDouble("REVERTIDO"));
                lista.add(objBnResoluciones);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaResolucionesAdministrativas(objBeanNotaModificatoria) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TABRAD");
            objBnMsgerr.setTipo(objBeanResoluaciones.getMode().toUpperCase());
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
    public List getListaResolucionesAdministrativasDetalle(BeanResolucionesAdministrativas objBeanResoluaciones, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NUMERA AS CODIGO,   "
                + "SECFUN||':'||UTIL_NEW.FUN_CODIGO_COCAFU(CODPER, COPPTO, SECFUN) AS SECUENCIA_FUNCIONAL, "
                + "COMEOP||':'||UTIL_NEW.FUN_NTAREA(COMEOP) AS TAREA, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOCLAS(COCAGA) AS CADENA_GASTO, "
                + "SUM(MONASI) AS IMPORTE, SUM(COMOCS) AS COMPROMISO, "
                + "SUM(MONDEV) AS DEVENGADO, SUM(MONGIR) AS GIRADO, "
                + "SUM(MONREV) AS REVERTIDO "
                + "FROM DETRAD WHERE "
                + "CODPER = ? AND "
                + "COPPTO = ? AND "
                + "COUUOO = ? "
                + "GROUP BY CODPER, COPPTO, NUMERA, SECFUN, COMEOP, COCAGA "
                + "ORDER BY CODIGO DESC, SECUENCIA_FUNCIONAL, TAREA, CADENA_GASTO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanResoluaciones.getPeriodo());
            objPreparedStatement.setInt(2, objBeanResoluaciones.getPresupuesto());
            objPreparedStatement.setString(3, objBeanResoluaciones.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnResoluciones = new BeanResolucionesAdministrativas();
                objBnResoluciones.setCodigo(objResultSet.getString("CODIGO"));
                objBnResoluciones.setSecuenciaFuncional(objResultSet.getString("SECUENCIA_FUNCIONAL"));
                objBnResoluciones.setTareaPresupuestal(objResultSet.getString("TAREA"));
                objBnResoluciones.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnResoluciones.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnResoluciones.setCompromiso(objResultSet.getDouble("COMPROMISO"));
                objBnResoluciones.setDevengado(objResultSet.getDouble("DEVENGADO"));
                objBnResoluciones.setGirado(objResultSet.getDouble("GIRADO"));
                objBnResoluciones.setRevertido(objResultSet.getDouble("REVERTIDO"));
                lista.add(objBnResoluciones);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaResolucionesAdministrativasDetalle(objBeanNotaModificatoria) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TABRAD");
            objBnMsgerr.setTipo(objBeanResoluaciones.getMode().toUpperCase());
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
    public ArrayList getListaResolucionAdministrativaDetalle(BeanResolucionesAdministrativas objBeanResoluaciones, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT SECFUN||':'||UTIL_NEW.FUN_CODIGO_COCAFU(CODPER, COPPTO, SECFUN) AS SECUENCIA_FUNCIONAL, "
                + "COMEOP||':'||UTIL_NEW.FUN_NTAREA(COMEOP) AS TAREA, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOCLAS(COCAGA) AS CADENA_GASTO, "
                + "SUM(MONASI) AS IMPORTE, SUM(COMOCS) AS COMPROMISO, "
                + "SUM(MONDEV) AS DEVENGADO, SUM(MONGIR) AS GIRADO, "
                + "SUM(MONREV) AS REVERTIDO "
                + "FROM DETRAD WHERE "
                + "CODPER = ? AND "
                + "COPPTO = ? AND "
                + "COUUOO = ? AND "
                + "NUMERA = ? "
                + "GROUP BY CODPER, COPPTO, NUMERA, SECFUN, COMEOP, COCAGA "
                + "ORDER BY SECUENCIA_FUNCIONAL, TAREA, CADENA_GASTO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanResoluaciones.getPeriodo());
            objPreparedStatement.setInt(2, objBeanResoluaciones.getPresupuesto());
            objPreparedStatement.setString(3, objBeanResoluaciones.getUnidadOperativa());
            objPreparedStatement.setString(4, objBeanResoluaciones.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("SECUENCIA_FUNCIONAL") + "+++"
                        + objResultSet.getString("TAREA") + "+++"
                        + objResultSet.getString("CADENA_GASTO") + "+++"
                        + objResultSet.getDouble("IMPORTE") + "+++"
                        + objResultSet.getDouble("COMPROMISO") + "+++"
                        + objResultSet.getDouble("DEVENGADO") + "+++"
                        + objResultSet.getDouble("GIRADO") + "+++"
                        + objResultSet.getDouble("REVERTIDO");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaResolucionAdministrativaDetalle(BeanCertificadoCreditoPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TABRAD");
            objBnMsgerr.setTipo(objBeanResoluaciones.getMode().toUpperCase());
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
    public int iduResolucionesAdministrativas(BeanResolucionesAdministrativas objBeanResoluaciones, String usuario) {
        sql = "{CALL SP_IDU_DETRAD(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanResoluaciones.getPeriodo());
            cs.setInt(2, objBeanResoluaciones.getPresupuesto());
            cs.setString(3, objBeanResoluaciones.getUnidadOperativa());
            cs.setString(4, objBeanResoluaciones.getCodigo());
            cs.setString(5, objBeanResoluaciones.getSecuenciaFuncional());
            cs.setString(6, objBeanResoluaciones.getTareaPresupuestal());
            cs.setString(7, objBeanResoluaciones.getCadenaGasto());
            cs.setDouble(8, objBeanResoluaciones.getCompromiso());
            cs.setDouble(9, objBeanResoluaciones.getDevengado());
            cs.setDouble(10, objBeanResoluaciones.getGirado());
            cs.setDouble(11, objBeanResoluaciones.getRevertido());
            cs.setString(12, usuario);
            cs.setString(13, objBeanResoluaciones.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener iduResolucionesAdministrativas(objBeanResoluaciones, " + usuario + ") : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TABRAD");
            objBnMsgerr.setTipo(objBeanResoluaciones.getMode());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
