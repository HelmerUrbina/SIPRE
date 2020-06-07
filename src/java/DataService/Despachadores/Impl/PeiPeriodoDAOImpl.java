/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPlaneamiento;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PeiPeriodoDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author heurbinam
 */
public class PeiPeriodoDAOImpl implements PeiPeriodoDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPlaneamiento objBnPeiPeriodo;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public PeiPeriodoDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaPeiPeriodo(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CPERIODO_CODIGO AS PERIODO, VPEI_PERIODO_DESCRIPCION AS DESCRIPCION, "
                + "DPEI_PERIODO_INICIO AS INICIO, DPEI_PERIODO_FINAL AS FINAL, "
                + "CASE CESTADO_CODIGO WHEN 'AC' THEN 'ACTIVO' WHEN 'IN' THEN 'INACTIVO' ELSE 'VERIFICAR' END AS ESTADO "
                + "FROM SIPRE_PEI_PERIODO "
                + "ORDER BY PERIODO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnPeiPeriodo = new BeanPlaneamiento();
                objBnPeiPeriodo.setPeriodo(objResultSet.getString("PERIODO"));
                objBnPeiPeriodo.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnPeiPeriodo.setFechaInicio(objResultSet.getDate("INICIO"));
                objBnPeiPeriodo.setFechaFinal(objResultSet.getDate("FINAL"));
                objBnPeiPeriodo.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnPeiPeriodo);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPeiPeriodo(objBeanPeiPeriodo) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PEI_PERIODO");
            objBnMsgerr.setTipo("G");
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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

    @Override
    public BeanPlaneamiento getPeiPeriodo(BeanPlaneamiento objBeanPeiPeriodo, String usuario) {
        sql = "SELECT VPEI_PERIODO_DESCRIPCION AS DESCRIPCION, "
                + "DPEI_PERIODO_INICIO AS INICIO, DPEI_PERIODO_FINAL AS FINAL, "
                + "CESTADO_CODIGO ESTADO "
                + "FROM SIPRE_PEI_PERIODO WHERE "
                + "CPERIODO_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPeiPeriodo.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanPeiPeriodo.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBeanPeiPeriodo.setFechaInicio(objResultSet.getDate("INICIO"));
                objBeanPeiPeriodo.setFechaFinal(objResultSet.getDate("FINAL"));
                objBeanPeiPeriodo.setEstado(objResultSet.getString("ESTADO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPeiPeriodo(objBeanPeiPeriodo) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PEI_PERIODO");
            objBnMsgerr.setTipo(objBeanPeiPeriodo.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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
        return objBeanPeiPeriodo;
    }

    @Override
    public int iduPeiPeriodo(BeanPlaneamiento objBeanPeiPeriodo, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL  SP_IDU_PAAC(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanPeiPeriodo.getPeriodo());
            cs.setString(4, objBeanPeiPeriodo.getDescripcion());
            cs.setString(5, objBeanPeiPeriodo.getEstado());
            cs.setString(6, objBeanPeiPeriodo.getMode());
            cs.setDate(7, objBeanPeiPeriodo.getFechaInicio());
            cs.setDate(7, objBeanPeiPeriodo.getFechaFinal());
            cs.setString(23, usuario);
            cs.setString(24, objBeanPeiPeriodo.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPeiPeriodo : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PEI_PERIODO");
            objBnMsgerr.setTipo(objBeanPeiPeriodo.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
