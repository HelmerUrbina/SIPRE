/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanDirecciones;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.DireccionesDAO;
import DataService.Despachadores.MsgerrDAO;
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
public class DireccionesDAOImpl implements DireccionesDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanDirecciones objBnDireccion;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public DireccionesDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaDirecciones(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NDIRECCION_CODIGO AS CODIGO, VDIRECCION_DESCRIPCION AS NOMBRE, "
                + "VDIRECCION_ABREVIATURA AS ABREVIATURA, "
                + "CASE CESTADO_CODIGO WHEN 'AC' THEN 'ACTIVO' WHEN 'IN' THEN 'INACTIVO' WHEN 'AN' THEN 'ANULADO' ELSE 'REVISE' END ESTADO "
                + "FROM SIPRE_DIRECCIONES "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDireccion = new BeanDirecciones();
                objBnDireccion.setCodigo(objResultSet.getInt("CODIGO"));
                objBnDireccion.setDescripcion(objResultSet.getString("NOMBRE"));
                objBnDireccion.setAbreviatura(objResultSet.getString("ABREVIATURA"));
                objBnDireccion.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnDireccion);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDirecciones(objBeanDirecciones, usuario) : " + e.getMessage());
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
    public int iduDireccion(BeanDirecciones objBeanDirecciones, String usuario) {
        sql = "{CALL SP_IDU_DIRECCIONES(?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setInt(1, objBeanDirecciones.getCodigo());
            cs.setString(2, objBeanDirecciones.getDescripcion());
            cs.setString(3, objBeanDirecciones.getAbreviatura());
            cs.setString(4, usuario);
            cs.setString(5, objBeanDirecciones.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduDireccion : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_DIRECCIONES");
            objBnMsgerr.setTipo(objBeanDirecciones.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
