/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanDependencia;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.DependenciaDAO;
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
public class DependenciaDAOImpl implements DependenciaDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanDependencia objBnDependencia;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public DependenciaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaDependencia(BeanDependencia objBeanDependencia, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CODDEP AS CODIGO, NOMDEP AS NOMBRE, ABRDEP AS ABREVIATURA, "
                + "CASE ESTREG WHEN 'AC' THEN 'ACTIVO' WHEN 'IN' THEN 'INACTIVO' ELSE 'VERIFICAR' END AS ESTADO "
                + "FROM TABDEP WHERE "
                + "COUUOO=? "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDependencia.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDependencia = new BeanDependencia();
                objBnDependencia.setCodigo(objResultSet.getString("CODIGO"));
                objBnDependencia.setNombre(objResultSet.getString("NOMBRE"));
                objBnDependencia.setAbreviatura(objResultSet.getString("ABREVIATURA"));
                objBnDependencia.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnDependencia);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDependencia(unidadOperativa, usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TABDEP");
            objBnMsgerr.setTipo(objBeanDependencia.getMode());
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
    public BeanDependencia getDependencia(BeanDependencia objBeanDependencia, String usuario) {
        sql = "SELECT NOMDEP AS NOMBRE, ABRDEP AS ABREVIATURA, ESTREG AS ESTADO "
                + "FROM TABDEP WHERE "
                + "COUUOO=? AND "
                + "CODDEP=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDependencia.getUnidadOperativa());
            objPreparedStatement.setString(2, objBeanDependencia.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanDependencia.setNombre(objResultSet.getString("NOMBRE"));
                objBeanDependencia.setAbreviatura(objResultSet.getString("ABREVIATURA"));
                objBeanDependencia.setEstado(objResultSet.getString("ESTADO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getDependencia(objBeanDependencia) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TABDEP");
            objBnMsgerr.setTipo(objBeanDependencia.getMode().toUpperCase());
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
        return objBeanDependencia;
    }

    @Override
    public int iduDependencia(BeanDependencia objBeanDependencia, String usuario) {
        sql = "{CALL SP_IDU_DEPENDENCIA(?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanDependencia.getUnidadOperativa());
            cs.setString(2, objBeanDependencia.getCodigo());
            cs.setString(3, objBeanDependencia.getNombre());
            cs.setString(4, objBeanDependencia.getAbreviatura());
            cs.setString(5, objBeanDependencia.getEstado());
            cs.setString(6, usuario);
            cs.setString(7, objBeanDependencia.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduDependencia : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TABDEP");
            objBnMsgerr.setTipo(objBeanDependencia.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
