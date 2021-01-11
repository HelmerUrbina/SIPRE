/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanConsultaAmigable;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPIMInforme;
import DataService.Despachadores.ConsultaAmigableDAO;
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
public class ConsultaAmigableDAOImpl implements ConsultaAmigableDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanConsultaAmigable objBnAmigable;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;

    public ConsultaAmigableDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaEjecutora(BeanConsultaAmigable objBeanAmigable, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT UTIL_NEW.FUN_ABPPTO(COPPTO) AS FUENTE_FINANCIAMIENTO, "
                + "SUM(PIM) AS PIM, SUM(DEVENG) DEVENGADO, (SUM(DEVENG)/SUM(PIM)*100) AS AVANCE "
                + "FROM V_SIAF_CONSULTA_AMIGABLE WHERE "
                + "CODPER=?  "
                + "GROUP BY COPPTO "
                + "HAVING SUM(PIM)>0 "
                + "ORDER BY COPPTO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanAmigable.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnAmigable = new BeanConsultaAmigable();
                objBnAmigable.setPresupuesto(objResultSet.getString("FUENTE_FINANCIAMIENTO"));
                objBnAmigable.setPIM(objResultSet.getDouble("PIM"));
                objBnAmigable.setDevengado(objResultSet.getDouble("DEVENGADO"));
                objBnAmigable.setAvance(objResultSet.getDouble("AVANCE"));
                lista.add(objBnAmigable);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaEjecutora(BeanConsultaAmigable, " + usuario + ") : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("V_SIAF_CONSULTA_AMIGABLE");
            objBnMsgerr.setTipo("G");
            objBnMsgerr.setDescripcion(e.getMessage());
            int s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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
