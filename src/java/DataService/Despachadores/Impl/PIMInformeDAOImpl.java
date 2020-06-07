/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPIMInforme;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PIMInformeDAO;
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
public class PIMInformeDAOImpl implements PIMInformeDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPIMInforme objBnPIMInforme;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
   

    public PIMInformeDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaPIMInforme(BeanPIMInforme objBeanPIMInforme, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT TIPO AS TIPO_CALENDARIO, RESOLUCION, ACTIVIDAD, SECUENCIA, TAREA, CADENA_GASTO, "
                + "GENERICA_GASTO, SUB_GENERICA, SUB_GENERICA_DETALLE, PROGRAMA, PRODUCTO, DEPENDENCIA, "
                + "TIPO_CLAS AS TIPO_CLASIFICADOR, PIA, VARIACION_PIA, PIM, INFORME, NOTA_PEND, CERTIFICADO, "
                + "SALDO_CERTF, SALDO, SALDO_SN_CERT "
                + "FROM V_PIM_VS_INFORME_TOTAL WHERE "
                + "PERIODO=? AND "
                + "PPTO=? "
                + "ORDER BY PROGRAMA, PRODUCTO, ACTIVIDAD, SECUENCIA, TAREA, CADENA_GASTO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPIMInforme.getPeriodo());
            objPreparedStatement.setString(2, objBeanPIMInforme.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnPIMInforme = new BeanPIMInforme();
                objBnPIMInforme.setTipoCalendario(objResultSet.getString("TIPO_CALENDARIO"));
                objBnPIMInforme.setResolucion(objResultSet.getString("RESOLUCION"));
                objBnPIMInforme.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnPIMInforme.setSecuencia(objResultSet.getString("SECUENCIA"));
                objBnPIMInforme.setTarea(objResultSet.getString("TAREA"));
                objBnPIMInforme.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnPIMInforme.setGenericaGasto(objResultSet.getString("GENERICA_GASTO"));
                objBnPIMInforme.setSubGenerica(objResultSet.getString("SUB_GENERICA"));
                objBnPIMInforme.setSubGenericaDetalle(objResultSet.getString("SUB_GENERICA_DETALLE"));
                objBnPIMInforme.setCategoriaPresupuestal(objResultSet.getString("PROGRAMA"));
                objBnPIMInforme.setProducto(objResultSet.getString("PRODUCTO"));
                objBnPIMInforme.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnPIMInforme.setTipoClasificador(objResultSet.getString("TIPO_CLASIFICADOR"));
                objBnPIMInforme.setPIA(objResultSet.getDouble("PIA"));
                objBnPIMInforme.setNotaModificatoria(objResultSet.getDouble("VARIACION_PIA"));
                objBnPIMInforme.setPIM(objResultSet.getDouble("PIM"));
                objBnPIMInforme.setInforme(objResultSet.getDouble("INFORME"));
                objBnPIMInforme.setNotaPendiente(objResultSet.getDouble("NOTA_PEND"));
                objBnPIMInforme.setCertificado(objResultSet.getDouble("CERTIFICADO"));
                objBnPIMInforme.setSaldoCertificado(objResultSet.getDouble("SALDO_CERTF"));
                objBnPIMInforme.setSaldo(objResultSet.getDouble("SALDO"));
                objBnPIMInforme.setSaldoSinCertificado(objResultSet.getDouble("SALDO_SN_CERT"));
                lista.add(objBnPIMInforme);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPIMInforme(objBeanPIMInforme, usuario) : " + e.getMessage());
        } finally {
            try {
                if (objResultSet != null) {
                    objPreparedStatement.close();
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println(e.toString());
            }
        }
        return lista;
    }

}
