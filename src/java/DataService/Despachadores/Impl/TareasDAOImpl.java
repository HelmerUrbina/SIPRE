/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanTareas;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.TareasDAO;
import java.sql.CallableStatement;
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
public class TareasDAOImpl implements TareasDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanTareas objBnTareas;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public TareasDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaTareas(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT COMEOP AS CODIGO, NTAREA AS TAREA, ABMEOP AS ABREVIATURA, "
                + "DEMEOP AS DESCRIPCION, UTIL_NEW.FUN_NOMBRE_UNIDAD_MEDIDA(COUNME) AS UNIDAD_MEDIDA, "
                + "UTIL_NEW.FUN_DESOPC('MOP', ESMEOP) AS TIPO, "
                + "CASE TIMEOP WHEN 'A' THEN 'ACTIVO' ELSE 'INACTIVO' END AS ESTADO "
                + "FROM TAMEOP "
                + "ORDER BY COMEOP";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnTareas = new BeanTareas();
                objBnTareas.setCodigo(objResultSet.getString("CODIGO"));
                objBnTareas.setTarea(objResultSet.getString("TAREA"));
                objBnTareas.setAbreviatura(objResultSet.getString("ABREVIATURA"));
                objBnTareas.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnTareas.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBnTareas.setTipo(objResultSet.getString("TIPO"));
                objBnTareas.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnTareas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaTareas(" + usuario + ") : " + e.getMessage());            
        } finally {
            try {
                if (objResultSet != null) {
                    objPreparedStatement.close();
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return lista;
    }

    @Override
    public BeanTareas getTareas(BeanTareas objBeanTareas, String usuario) {
        sql = "SELECT NTAREA, ABMEOP, DEMEOP, COUNME, ESMEOP "
                + "FROM TAMEOP WHERE "
                + "COMEOP=?"
                + "ORDER BY COMEOP";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanTareas.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanTareas.setTarea(objResultSet.getString("NTAREA"));
                objBeanTareas.setAbreviatura(objResultSet.getString("ABMEOP"));
                objBeanTareas.setDescripcion(objResultSet.getString("DEMEOP"));
                objBeanTareas.setUnidadMedida(objResultSet.getString("COUNME"));
                objBeanTareas.setTipo(objResultSet.getString("ESMEOP"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getTareas(objBeanTareas," + usuario + ") : " + e.getMessage());            
        } finally {
            try {
                if (objResultSet != null) {
                    objPreparedStatement.close();
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return objBeanTareas;
    }

    @Override
    public int iduTareas(BeanTareas objBeanTareas, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA TABLA TAPAIN, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA,
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_TAMEOP(?,?,?,?,?,?,?,?,?,?)}";
        try {
            try (CallableStatement cs = objConnection.prepareCall(sql)) {
                cs.setString(1, objBeanTareas.getCodigo());
                cs.setString(2, objBeanTareas.getTarea());
                cs.setString(3, objBeanTareas.getAbreviatura());
                cs.setString(4, objBeanTareas.getDescripcion());
                cs.setString(5, objBeanTareas.getTipo());
                cs.setString(6, "LI");
                cs.setString(7, objBeanTareas.getUnidadMedida());
                cs.setString(8, "0");
                cs.setString(9, usuario);
                cs.setString(10, objBeanTareas.getMode());
                objResultSet = cs.executeQuery();
                s++;
            }
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduTareas : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAMEOP");
            objBnMsgerr.setTipo(objBeanTareas.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return s;
    }

}
