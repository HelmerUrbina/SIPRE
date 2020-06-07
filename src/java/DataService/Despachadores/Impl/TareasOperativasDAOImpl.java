/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanTareas;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.TareasOperativasDAO;
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
public class TareasOperativasDAOImpl implements TareasOperativasDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanTareas objBnTareas;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public TareasOperativasDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaTareasOperativas(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NTAREA_OPERATIVA_CODIGO AS CODIGO, VTAREA_OPERATIVA_DESCRIPCION AS DESCRIPCION, "
                + "VTAREA_OPERATIVA_ABREVIATURA AS ABREVIATURA, UTIL_NEW.FUN_NOMBRE_UNIDAD_MEDIDA(CUNIDAD_MEDIDA_CODIGO) AS UNIDAD_MEDIDA, "
                + "CASE CESTADO_CODIGO WHEN 'AC' THEN 'ACTIVO' WHEN 'IN' THEN 'INACTIVO' ELSE 'VERIFICAR' END AS ESTADO "
                + "FROM SIPRE_POI_TAREA_OPERATIVA "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnTareas = new BeanTareas();
                objBnTareas.setCodigo(objResultSet.getString("CODIGO"));
                objBnTareas.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnTareas.setAbreviatura(objResultSet.getString("ABREVIATURA"));
                objBnTareas.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBnTareas.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnTareas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaTareasOperativas(" + usuario + ") : " + e.getMessage());
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
    public BeanTareas getTareasOperativas(BeanTareas objBeanTareasOperativas, String usuario) {
        sql = "SELECT VTAREA_OPERATIVA_DESCRIPCION, VTAREA_OPERATIVA_ABREVIATURA, CUNIDAD_MEDIDA_CODIGO "
                + "FROM SIPRE_POI_TAREA_OPERATIVA WHERE "
                + "NTAREA_OPERATIVA_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanTareasOperativas.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanTareasOperativas.setAbreviatura(objResultSet.getString("VTAREA_OPERATIVA_DESCRIPCION"));
                objBeanTareasOperativas.setDescripcion(objResultSet.getString("VTAREA_OPERATIVA_ABREVIATURA"));
                objBeanTareasOperativas.setUnidadMedida(objResultSet.getString("CUNIDAD_MEDIDA_CODIGO"));            
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getTareasOperativas(" + objBeanTareasOperativas + ", " + usuario + ") : " + e.getMessage());
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
        return objBeanTareasOperativas;
    }

    @Override
    public int iduTareasOperativas(BeanTareas objBeanTareasOperativas, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA TABLA TAPAIN, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA,
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_POI_TAREA_OPERATIVA(?,?,?,?,?,?)}";
        try {
            try (CallableStatement cs = objConnection.prepareCall(sql)) {
                cs.setString(1, objBeanTareasOperativas.getCodigo());
                cs.setString(2, objBeanTareasOperativas.getDescripcion());
                cs.setString(3, objBeanTareasOperativas.getAbreviatura());
                cs.setString(4, objBeanTareasOperativas.getUnidadMedida());                
                cs.setString(5, usuario);
                cs.setString(6, objBeanTareasOperativas.getMode());
                s = cs.executeUpdate();
            }
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduTareasOperativas : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_POI_TAREA_OPERATIVA");
            objBnMsgerr.setTipo(objBeanTareasOperativas.getMode().toUpperCase());
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
