/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanInstitucion;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.InstitucionDAO;
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
 * @author H-TECCSI-V
 */
public class InstitucionDAOImpl implements InstitucionDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanInstitucion objBnInstitucion;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public InstitucionDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaInstitucion(BeanInstitucion objBeanInstitucion, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CINSTITUCION_CODIGO,VINSTITUCION_DESCRIPCION,"
                + "VINSTITUCION_ABREVIATURA "
                + " FROM SIPE_INSTITUCION WHERE "
                + "CORGANISMO_CODIGO=? "
                + "ORDER BY CINSTITUCION_CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanInstitucion.getOrganismo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnInstitucion = new BeanInstitucion();
                objBnInstitucion.setCodigo(objResultSet.getString("CINSTITUCION_CODIGO"));
                objBnInstitucion.setDescripcion(objResultSet.getString("VINSTITUCION_DESCRIPCION"));
                objBnInstitucion.setAbreviatura(objResultSet.getString("VINSTITUCION_ABREVIATURA"));
                lista.add(objBnInstitucion);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaInstitucion(objBeanInstitucion, usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_INSTITUCION");
            objBnMsgerr.setTipo(objBeanInstitucion.getMode());
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
    public BeanInstitucion getInstitucion(BeanInstitucion objBeanInstitucion, String usuario) {
        sql = "SELECT VINSTITUCION_DESCRIPCION,"
                + "VINSTITUCION_ABREVIATURA "
                + " FROM SIPE_INSTITUCION WHERE "
                + "CORGANISMO_CODIGO=? AND "
                + "CINSTITUCION_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanInstitucion.getOrganismo());
            objPreparedStatement.setString(2, objBeanInstitucion.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanInstitucion.setDescripcion(objResultSet.getString("VINSTITUCION_DESCRIPCION"));
                objBeanInstitucion.setAbreviatura(objResultSet.getString("VINSTITUCION_ABREVIATURA"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getInstitucion(objBeanInstitucion) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_INSTITUCION");
            objBnMsgerr.setTipo(objBeanInstitucion.getMode().toUpperCase());
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
        return objBeanInstitucion;
    }

    @Override
    public int iduInstitucion(BeanInstitucion objBeanInstitucion, String usuario) {
        sql = "{CALL SP_IDU_INSTITUCION(?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanInstitucion.getOrganismo());
            cs.setString(2, objBeanInstitucion.getCodigo());
            cs.setString(3, objBeanInstitucion.getDescripcion());
            cs.setString(4, objBeanInstitucion.getAbreviatura());
            cs.setString(5, usuario);
            cs.setString(6, objBeanInstitucion.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduInstitucion : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_INSTITUCION");
            objBnMsgerr.setTipo(objBeanInstitucion.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduInstitucion : " + e.toString());
            }
        }
        return s;
    }
}
