/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanDiferenciasSIAF;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.DiferenciasSIAFDAO;
import DataService.Despachadores.MsgerrDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public class DiferenciasSIAFDAOImpl implements DiferenciasSIAFDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanDiferenciasSIAF objBnDiferencia;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public DiferenciasSIAFDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaDiferenciaCertificado(BeanDiferenciasSIAF objBeanDiferencia, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT "
                + "COUUOO||':'||UTIL_NEW.FUN_ABUUOO(COUUOO) UNIDAD_OPERATIVA, "
                + "LPAD(REG_SIAF,10,0) AS REG_SIAF, "
                + "UTIL_NEW.FUN_DESC_USUARIO(UTIL_NEW.FUN_CODUSU_SIAF(CODPER, REG_SIAF)) AS SECTORISTA, "
                + "SECFUN||':'||UTIL_NEW.FUN_DESMET(CODPER, COPPTO, SECFUN) CADENA_FUNCIONAL,"
                + "UTIL_NEW.FUN_PROGRAMA_SECFUN(CODPER, COPPTO, SECFUN) CAT_PRESUPUESTAL, "
                + "UTIL_NEW.FUN_PRODUCTO_SECFUN(CODPER, COPPTO, SECFUN) PRODUCTO, "
                + "UTIL_NEW.FUN_ACTIVIDAD_SECFUN(CODPER, COPPTO, SECFUN) ACTIVIDAD, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(COCAGA) CADENA_GASTO, "
                + "CODGEN||':'||UTIL_NEW.FUN_NOMGEN(CODGEN) GENERICA, "
                + "SUM(IMPORTE_SIPE) SIPE, SUM(IMPORTE_SIAF) SIAF, SUM(IMPORTE_SIPE-IMPORTE_SIAF) DIFERENCIA "
                + "FROM V_CERTIFICADO_SIPE_SIAF WHERE "
                + "CODPER=? AND "
                + "COPPTO=? "
                + "GROUP BY CODPER, COPPTO, COUUOO, REG_SIAF, CODGEN, SECFUN, COCAGA "
                + "HAVING SUM(IMPORTE_SIPE-IMPORTE_SIAF)<>0 "
                + "ORDER BY SECTORISTA, UNIDAD_OPERATIVA, REG_SIAF";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDiferencia.getPeriodo());
            objPreparedStatement.setInt(2, objBeanDiferencia.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDiferencia = new BeanDiferenciasSIAF();
                objBnDiferencia.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnDiferencia.setCertificado(objResultSet.getString("REG_SIAF"));
                objBnDiferencia.setSectorista(objResultSet.getString("SECTORISTA"));
                objBnDiferencia.setSecuenciaFuncional(objResultSet.getString("CADENA_FUNCIONAL"));
                objBnDiferencia.setCategoriaPresupuestal(objResultSet.getString("CAT_PRESUPUESTAL"));
                objBnDiferencia.setProducto(objResultSet.getString("PRODUCTO"));
                objBnDiferencia.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnDiferencia.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnDiferencia.setGenericaGasto(objResultSet.getString("GENERICA"));
                objBnDiferencia.setSIPE(objResultSet.getDouble("SIPE"));
                objBnDiferencia.setSIAF(objResultSet.getDouble("SIAF"));
                objBnDiferencia.setDiferencia(objResultSet.getDouble("DIFERENCIA"));
                lista.add(objBnDiferencia);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDiferenciaCertificado(objBeanDiferencia, usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("V_CERTIFICADO_SIPE_SIAF");
            objBnMsgerr.setTipo(objBnDiferencia.getMode());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.toString());
            }
        }
        return lista;
    }

    @Override
    public List getListaDiferenciaCompromisoAnual(BeanDiferenciasSIAF objBeanDiferencia, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT "
                + "COUUOO||':'||UTIL_NEW.FUN_ABUUOO(COUUOO) UNIDAD_OPERATIVA, "
                + "CERTIFICADO AS REG_SIAF, "
                + "UTIL_NEW.FUN_DESC_USUARIO(UTIL_NEW.FUN_CODUSU_SIAF(CODPER, CERTIFICADO)) AS SECTORISTA, "
                + "SEC_FUN||':'||UTIL_NEW.FUN_DESMET(CODPER, COPPTO, SEC_FUN) CADENA_FUNCIONAL, "
                + "UTIL_NEW.FUN_PROGRAMA_SECFUN(CODPER, COPPTO, SEC_FUN) CAT_PRESUPUESTAL, "
                + "UTIL_NEW.FUN_PRODUCTO_SECFUN(CODPER, COPPTO, SEC_FUN) PRODUCTO, "
                + "UTIL_NEW.FUN_ACTIVIDAD_SECFUN(CODPER, COPPTO, SEC_FUN) ACTIVIDAD, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(COCAGA) CADENA_GASTO, "
                + "CODGEN||':'||UTIL_NEW.FUN_NOMGEN(CODGEN) GENERICA, "
                + "SUM(CA_SIPE) SIPE, SUM(CA_SIAF) SIAF, SUM(CA_SIAF-CA_SIPE) AS DIFERENCIA "
                + "FROM V_CA_SIPE_SIAF WHERE "
                + "CODPER=? AND "
                + "COPPTO=? "
                + "GROUP BY CODPER, COPPTO, COUUOO, CERTIFICADO, CODGEN, SEC_FUN, COCAGA "
                + "HAVING SUM(CA_SIAF-CA_SIPE)<>0 "
                + "ORDER BY SECTORISTA, UNIDAD_OPERATIVA, REG_SIAF";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDiferencia.getPeriodo());
            objPreparedStatement.setInt(2, objBeanDiferencia.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDiferencia = new BeanDiferenciasSIAF();
                objBnDiferencia.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnDiferencia.setCertificado(objResultSet.getString("REG_SIAF"));
                objBnDiferencia.setSectorista(objResultSet.getString("SECTORISTA"));
                objBnDiferencia.setSecuenciaFuncional(objResultSet.getString("CADENA_FUNCIONAL"));
                objBnDiferencia.setCategoriaPresupuestal(objResultSet.getString("CAT_PRESUPUESTAL"));
                objBnDiferencia.setProducto(objResultSet.getString("PRODUCTO"));
                objBnDiferencia.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnDiferencia.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnDiferencia.setGenericaGasto(objResultSet.getString("GENERICA"));
                objBnDiferencia.setSIPE(objResultSet.getDouble("SIPE"));
                objBnDiferencia.setSIAF(objResultSet.getDouble("SIAF"));
                objBnDiferencia.setDiferencia(objResultSet.getDouble("DIFERENCIA"));
                lista.add(objBnDiferencia);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDiferenciaCompromisoAnual(objBeanDiferencia, usuario) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("V_CA_SIPE_SIAF");
            objBnMsgerr.setTipo(objBnDiferencia.getMode());
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

}
