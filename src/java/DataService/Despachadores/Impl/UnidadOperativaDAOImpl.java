/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUnidadOperativa;
import DataService.Despachadores.MsgerrDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;
import DataService.Despachadores.UnidadOperativaDAO;

/**
 *
 * @author H-URBINA-M
 */
public class UnidadOperativaDAOImpl implements UnidadOperativaDAO {

    private final Connection objConnection;
    private PreparedStatement objPreparedStatement;
    private ResultSet objResultSet;
    private String sql;
    private List lista;
    private BeanUnidadOperativa objBnUnidadesOperativas;
    private BeanMsgerr objBnMsgerr;
    private MsgerrDAO objDsMsgerr;
    private Integer s = 0;

    public UnidadOperativaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaUnidadesOperativas(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT COUUOO AS CODIGO, NOUUOO AS NOMBRE, ABUUOO AS ABREVIATURA, "
                + "CASE ESTREG WHEN 'AC' THEN 'ACTIVO' WHEN 'IN' THEN 'INACTIVO' ELSE 'VERIFICAR' END AS ESTADO, "
                + "NOMDIR AS DIRECCION, CARJEF AS CARGO_JEFE, "
                + "UTIL_NEW.FUN_NOMBRE_DEPARTAMENTO(SUBSTR(CODUBI,0,2)) AS DEPARTAMENTO, "
                + "UTIL_NEW.FUN_NOMBRE_PROVINCIA(SUBSTR(CODUBI,0,2), SUBSTR(CODUBI,3,2)) AS PROVINCIA, "
                + "UTIL_NEW.FUN_NOMBRE_UBIGEO(CODUBI) AS DISTRITO "
                + "FROM TAUUOO WHERE "
                + "TIUUOO='U' "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnUnidadesOperativas = new BeanUnidadOperativa();
                objBnUnidadesOperativas.setCodigo(objResultSet.getString("CODIGO"));
                objBnUnidadesOperativas.setNombre(objResultSet.getString("NOMBRE"));
                objBnUnidadesOperativas.setAbreviatura(objResultSet.getString("ABREVIATURA"));
                objBnUnidadesOperativas.setEstado(objResultSet.getString("ESTADO"));
                objBnUnidadesOperativas.setDireccion(objResultSet.getString("DIRECCION"));
                objBnUnidadesOperativas.setCargoJefe(objResultSet.getString("CARGO_JEFE"));
                objBnUnidadesOperativas.setDepartamento(objResultSet.getString("DEPARTAMENTO"));
                objBnUnidadesOperativas.setProvincia(objResultSet.getString("PROVINCIA"));
                objBnUnidadesOperativas.setDistrito(objResultSet.getString("DISTRITO"));
                lista.add(objBnUnidadesOperativas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getUnidadesOperativas(usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAUUOO");
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
    public BeanUnidadOperativa getUnidadOperativa(BeanUnidadOperativa objBeanUnidadOperativa, String usuario) {
        sql = "SELECT NOUUOO, ABUUOO, ESTREG, NOMDIR, CARJEF, "
                + "SUBSTR(CODUBI,0,2) AS DEPARTAMENTO, SUBSTR(CODUBI,3,2) AS PROVINCIA, "
                + "CODUBI "
                + "FROM TAUUOO WHERE "
                + "TIUUOO='U' AND "
                + "COUUOO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanUnidadOperativa.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanUnidadOperativa.setNombre(objResultSet.getString("NOUUOO"));
                objBeanUnidadOperativa.setAbreviatura(objResultSet.getString("ABUUOO"));
                objBeanUnidadOperativa.setEstado(objResultSet.getString("ESTREG"));
                objBeanUnidadOperativa.setDireccion(objResultSet.getString("NOMDIR"));
                objBeanUnidadOperativa.setCargoJefe(objResultSet.getString("CARJEF"));
                objBeanUnidadOperativa.setDepartamento(objResultSet.getString("DEPARTAMENTO"));
                objBeanUnidadOperativa.setProvincia(objResultSet.getString("PROVINCIA"));
                objBeanUnidadOperativa.setDistrito(objResultSet.getString("CODUBI"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getUnidadOperativa(objBeanTareas) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAUUOO");
            objBnMsgerr.setTipo(objBeanUnidadOperativa.getMode());
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
        return objBeanUnidadOperativa;
    }

    @Override
    public int iduUnidadOperativa(BeanUnidadOperativa objBeanUnidadOperativa, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA TABLA TAPAIN, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA,
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_UNIDAD_OPERATIVA(?,?,?,?,?,?,?,?,?)}";
        try {
            try (CallableStatement cs = objConnection.prepareCall(sql)) {
                cs.setString(1, objBeanUnidadOperativa.getCodigo());
                cs.setString(2, objBeanUnidadOperativa.getNombre());
                cs.setString(3, objBeanUnidadOperativa.getAbreviatura());
                cs.setString(4, objBeanUnidadOperativa.getEstado());
                cs.setString(5, objBeanUnidadOperativa.getDireccion());
                cs.setString(6, objBeanUnidadOperativa.getCargoJefe());
                cs.setString(7, objBeanUnidadOperativa.getDistrito());
                cs.setString(8, usuario);
                cs.setString(9, objBeanUnidadOperativa.getMode());
                objResultSet = cs.executeQuery();
                s++;
            }
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduUnidadOperativa : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAUUOO");
            objBnMsgerr.setTipo(objBeanUnidadOperativa.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println(e.toString());
            }
        }
        return s;
    }

}
