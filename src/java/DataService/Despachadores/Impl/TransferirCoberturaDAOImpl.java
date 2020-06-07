/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanEjecucionPresupuestal;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.TransferirCoberturaDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public class TransferirCoberturaDAOImpl implements TransferirCoberturaDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEjecucionPresupuestal objBnDeclaracionJurada;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public TransferirCoberturaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaCoberturas(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NROCOB AS COBERTURA,COUUOO||':'||UTIL_NEW.FUN_NOMBRE_UNIDADES(COUUOO) AS UNIDAD,"
                + "UTIL_NEW.FUN_NOMUSU('0003', CODUSU) AS USUARIO,"
                + "DESGLO, NUMOFI, TOTCOB "
                + "FROM COMCAB WHERE "
                + "CODPER=? AND "
                + "COPPTO=? AND "
                + "NROCOB BETWEEN ? AND ? AND "
                + "NROCOB NOT LIKE '%A' AND "
                + "ESTCOB NOT IN ('AN') "
                + "ORDER BY COBERTURA";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setInt(2, objBeanEjecucionPresupuestal.getPresupuesto());
            objPreparedStatement.setString(3, objBeanEjecucionPresupuestal.getCobertura());
            objPreparedStatement.setString(4, objBeanEjecucionPresupuestal.getCertificado());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDeclaracionJurada = new BeanEjecucionPresupuestal();
                objBnDeclaracionJurada.setCobertura(objResultSet.getString("COBERTURA"));
                objBnDeclaracionJurada.setUnidad(objResultSet.getString("UNIDAD"));
                objBnDeclaracionJurada.setDependencia(objResultSet.getString("USUARIO"));
                objBnDeclaracionJurada.setDetalle(objResultSet.getString("DESGLO"));
                objBnDeclaracionJurada.setDocumentoReferencia(objResultSet.getString("NUMOFI"));
                objBnDeclaracionJurada.setImporte(objResultSet.getDouble("TOTCOB"));
                lista.add(objBnDeclaracionJurada);
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaCoberturas(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("COMCAB");
            objBnMsgerr.setTipo(objBeanEjecucionPresupuestal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        }
        return lista;
    }

    @Override
    public int iduTransferenciaCobertura(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario) {
        s = 0;
        sql = "{call sp_transferir_coberturas(?,?,?,?,?,?,?,?,?,?)}";
        String anual = "";
        anual = objBeanEjecucionPresupuestal.getCobertura().substring(objBeanEjecucionPresupuestal.getCobertura().length() - 1, objBeanEjecucionPresupuestal.getCobertura().length());
        if (anual.equals("A")) {
            sql = "{call SP_TRANSFERIR_COBERTURAS_A(?,?,?,?,?,?,?,?,?,?)}";
        }
        try {
            CallableStatement cs = objConnection.prepareCall(sql);
            cs.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            cs.setInt(2, objBeanEjecucionPresupuestal.getPresupuesto());
            cs.setString(3, objBeanEjecucionPresupuestal.getMes());
            cs.setString(4, objBeanEjecucionPresupuestal.getCobertura().trim());
            cs.setString(5, objBeanEjecucionPresupuestal.getCertificado().trim());
            cs.setInt(6, 0);
            cs.setInt(7, 0);
            cs.setInt(8, 0);
            cs.setInt(9, 0);
            cs.setString(10, usuario);
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduTransferenciaCobertura : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("COMCAB");
            objBnMsgerr.setTipo(objBeanEjecucionPresupuestal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
