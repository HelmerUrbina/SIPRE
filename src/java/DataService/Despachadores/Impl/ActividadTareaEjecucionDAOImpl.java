/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanActividadTarea;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.ActividadTareaEjecucionDAO;
import DataService.Despachadores.MsgerrDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public class ActividadTareaEjecucionDAOImpl implements ActividadTareaEjecucionDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanActividadTarea objBnActividadTarea;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ActividadTareaEjecucionDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaActividadTarea(BeanActividadTarea objBeanActividadTarea, String usuario) {
        lista = new ArrayList();
        sql = "SELECT COACTME AS CODIGO, "
                + "COPRES||':'||UTIL_NEW.FUN_NOMBRE_CATEGORIA_PRESUPUES(COPRES) AS CATEGORIA_PRESUPUESTAL, "
                + "CODCOM||':'||UTIL_NEW.FUN_NOMBRE_PRODUCTO(CODCOM) AS PRODUCTO, "
                + "CODACT||':'||UTIL_NEW.FUN_NOMBRE_ACTIVIDAD(CODACT) AS ACTIVIDAD, "
                + "COMEOP||':'||UTIL_NEW.FUN_NTAREA(COMEOP) AS TAREA, "
                + "COFINA||':'||UTIL_NEW.FUN_NOMBRE_FINALIDAD(CODPER, COPPTO, CODACT, COFINA) AS FINALIDAD "
                + "FROM TACMEOP WHERE "
                + "CODPER=? AND "
                + "COPPTO=? "
                + "ORDER BY CATEGORIA_PRESUPUESTAL, PRODUCTO, ACTIVIDAD, TAREA";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanActividadTarea.getPeriodo());
            objPreparedStatement.setInt(2, objBeanActividadTarea.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnActividadTarea = new BeanActividadTarea();
                objBnActividadTarea.setCodigo(objResultSet.getString("CODIGO"));
                objBnActividadTarea.setCategoriaPresupuestal(objResultSet.getString("CATEGORIA_PRESUPUESTAL"));
                objBnActividadTarea.setProducto(objResultSet.getString("PRODUCTO"));
                objBnActividadTarea.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnActividadTarea.setTarea(objResultSet.getString("TAREA"));
                objBnActividadTarea.setFinalidad(objResultSet.getString("FINALIDAD"));
                lista.add(objBnActividadTarea);
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaActividadTarea(objBeanActividadTarea) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TACMEOP");
            objBnMsgerr.setTipo(objBeanActividadTarea.getMode().toUpperCase());
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
    public int iduActividadTarea(BeanActividadTarea objBeanActividadTarea, String usuario) {
        sql = "{CALL SP_IDU_TACMEOP(?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanActividadTarea.getPeriodo());
            cs.setInt(2, objBeanActividadTarea.getPresupuesto());
            cs.setString(3, objBeanActividadTarea.getCodigo());
            cs.setString(4, objBeanActividadTarea.getCategoriaPresupuestal());
            cs.setString(5, objBeanActividadTarea.getProducto());
            cs.setString(6, objBeanActividadTarea.getActividad());
            cs.setString(7, objBeanActividadTarea.getTarea());
            cs.setString(8, objBeanActividadTarea.getFinalidad());
            cs.setString(9, usuario);
            cs.setString(10, objBeanActividadTarea.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduActividadTarea : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TACMEOP");
            objBnMsgerr.setTipo(objBeanActividadTarea.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
