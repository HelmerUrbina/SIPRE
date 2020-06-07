/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanConsultaIngresoSalida;
import DataService.Despachadores.ConsultaIngresoSalidaDAO;
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
public class ConsultaIngresoSalidaDAOImpl implements ConsultaIngresoSalidaDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private PreparedStatement objPreparedStatement;
    private BeanConsultaIngresoSalida objBnIngresoSalida;

    public ConsultaIngresoSalidaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaIngresoSalida(BeanConsultaIngresoSalida objBeanIngresoSalida, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT LPAD(PERSONAL.USRID,8,0) AS DNI, "
                + "PERSONAL.NM AS PERSONAL, "
                + "CASE CTIPO_PERSONAL WHEN 'C' THEN 'CIVIL' WHEN 'M' THEN 'MILITAR' ELSE '' END AS TIPO_PERSONAL, "
                + "DATE_FORMAT(MIN(REGISTRO.SRVDT), '%H:%i:%s') AS ENTRADA, "
                + "DATE_FORMAT(MAX(CASE WHEN EQUIPO.IP IN ('10.64.28.111','10.64.28.113') THEN REGISTRO.SRVDT END), '%H:%i:%s') AS SALIDA "
                + "FROM t_lg202003 REGISTRO INNER JOIN t_dev EQUIPO ON REGISTRO.DEVUID = EQUIPO.DEVID "
                + "INNER JOIN t_usr PERSONAL ON REGISTRO.USRID = PERSONAL.USRID WHERE "
                + "CTIPO_PERSONAL IS NOT NULL AND "
                + "Date_format(REGISTRO.SRVDT,'%d/%m/%y')=? "
                + "GROUP BY LPAD(PERSONAL.USRID,8,0), PERSONAL.NM, Date_format(REGISTRO.SRVDT,'%d/%m/%y') "
                + "ORDER BY CTIPO_PERSONAL, PERSONAL";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanIngresoSalida.getFechaMarcacion().toString());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnIngresoSalida = new BeanConsultaIngresoSalida();
                objBnIngresoSalida.setIdUsuario(objResultSet.getString("DNI"));
                objBnIngresoSalida.setNombre(objResultSet.getString("PERSONAL"));
                objBnIngresoSalida.setHoraEntrada(objResultSet.getString("ENTRADA"));
                objBnIngresoSalida.setHoraSalida(objResultSet.getString("SALIDA"));
                lista.add(objBnIngresoSalida);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaIngresoSalida(objBeanIngresoSalida) : " + e.getMessage());
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
