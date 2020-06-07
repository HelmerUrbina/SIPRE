/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanCadenaFuncional;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.CadenaFuncionalProgramacionDAO;
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
public class CadenaFuncionalProgramacionDAOImpl implements CadenaFuncionalProgramacionDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanCadenaFuncional objBnCadenaFuncional;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public CadenaFuncionalProgramacionDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaCadenaFuncional(BeanCadenaFuncional objBeanCadenaFuncional, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT DISTINCT SECFUN||'.'||COPRES||'.'||CODCOM||'.'||CODACT||'.'||CODFUN||'.'||CODPRG||'.'||COSPRG||'.'||CODMET CODIGO, "
                + "SECFUN AS SECUENCIA_FUNCIONAL,"
                + "COPRES AS CATEGORIA_PRESUPUESTAL, "
                + "CODCOM AS PRODUCTO, "
                + "CODACT AS ACTIVIDAD, "
                + "CODFUN AS FUNCION, "
                + "CODPRG AS DIVISION_FUNCIONAL, "
                + "COSPRG AS GRUPO_FUNCIONAL, "
                + "CODMET||':'||DESMET AS META, "
                + "COFINA||':'||DEFINA AS FINALIDAD, "
                + "UTIL_NEW.FUN_NOMBRE_UNIDAD_MEDIDA(COUNME) AS UNIDAD_MEDIDA, "
                + "NOMUBI||'-'||NOMDIS AS DISTRITO "
                + "FROM TACAFU_PRG WHERE "
                + "CODPER=? "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCadenaFuncional.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnCadenaFuncional = new BeanCadenaFuncional();
                objBnCadenaFuncional.setCodigo(objResultSet.getString("CODIGO"));
                objBnCadenaFuncional.setSecuenciaFuncional(objResultSet.getString("SECUENCIA_FUNCIONAL"));
                objBnCadenaFuncional.setCategoriaPresupuestal(objResultSet.getString("CATEGORIA_PRESUPUESTAL"));
                objBnCadenaFuncional.setProducto(objResultSet.getString("PRODUCTO"));
                objBnCadenaFuncional.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnCadenaFuncional.setFuncion(objResultSet.getString("FUNCION"));
                objBnCadenaFuncional.setDivisionFuncional(objResultSet.getString("DIVISION_FUNCIONAL"));
                objBnCadenaFuncional.setGrupoFuncional(objResultSet.getString("GRUPO_FUNCIONAL"));
                objBnCadenaFuncional.setMeta(objResultSet.getString("META"));
                objBnCadenaFuncional.setFinalidad(objResultSet.getString("FINALIDAD"));
                objBnCadenaFuncional.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBnCadenaFuncional.setDistrito(objResultSet.getString("DISTRITO"));
                lista.add(objBnCadenaFuncional);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaCadenaFuncional(BeanCadenaFuncional) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TACAFU_PRG");
            objBnMsgerr.setTipo(objBeanCadenaFuncional.getMode().toUpperCase());
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
    public String getSecuenciaFuncional(BeanCadenaFuncional objBeanCadenaFuncional, String usuario) {
        String result = "";
        sql = "SELECT NVL(LPAD(MAX(SECFUN+1),4,0),'0001') AS SECUENCIA_FUNCIONAL "
                + "FROM TACAFU_PRG WHERE "
                + "CODPER=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCadenaFuncional.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("SECUENCIA_FUNCIONAL");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getSecuenciaFuncional(BeanCadenaFuncional) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TACAFU_PRG");
            objBnMsgerr.setTipo(objBeanCadenaFuncional.getMode().toUpperCase());
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
        return result;
    }

    @Override
    public String getMetaPresupuestal(BeanCadenaFuncional objBeanCadenaFuncional, String usuario) {
        String result = "";
        sql = "SELECT NVL(LPAD(MAX(CODMET+1),5,0),'00001') AS META_PRESUPUESTAL "
                + "FROM TACAFU_PRG WHERE "
                + "CODPER=? AND "
                + "CODACT=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCadenaFuncional.getPeriodo());
            objPreparedStatement.setString(2, objBeanCadenaFuncional.getActividad());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("META_PRESUPUESTAL");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getMetaPresupuestal(BeanCadenaFuncional) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TACAFU_PRG");
            objBnMsgerr.setTipo(objBeanCadenaFuncional.getMode().toUpperCase());
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
        return result;
    }

    @Override
    public BeanCadenaFuncional getCadenaFuncional(BeanCadenaFuncional objBeanCadenaFuncional, String usuario) {
        sql = "SELECT DISTINCT SECFUN AS SECUENCIA_FUNCIONAL,"
                + "COPRES AS CATEGORIA_PRESUPUESTAL, UTIL_NEW.FUN_NOMBRE_CATEGORIA_PRESUPUES(COPRES) AS CATEGORIA_PRESUPUESTAL_NOMBRE, "
                + "CODCOM AS PRODUCTO, UTIL_NEW.FUN_NOMBRE_PRODUCTO(CODCOM) AS PRODUCTO_NOMBRE, "
                + "CODACT AS ACTIVIDAD, UTIL_NEW.FUN_NOMBRE_ACTIVIDAD(CODACT) AS ACTIVIDAD_NOMBRE, "
                + "CODFUN AS FUNCION, UTIL_NEW.FUN_DESFUN(CODFUN) AS FUNCION_NOMBRE, "
                + "CODPRG AS DIVISION_FUNCIONAL, UTIL_NEW.FUN_DESPRG(CODPRG) AS DIVISION_FUNCIONAL_NOMBRE, "
                + "COSPRG AS GRUPO_FUNCIONAL, UTIL_NEW.FUN_DES_SPRG(COSPRG) AS GRUPO_FUNCIONAL_NOMBRE, "
                + "CODMET AS META, DESMET AS META_NOMBRE, "
                + "COFINA AS FINALIDAD, DEFINA AS FINALIDAD_NOMBRE, "
                + "COUNME AS UNIDAD_MEDIDA, NOMDEP AS DEPARTAMENTO, NOMDIS AS PROVINCIA, NOMUBI AS DISTRITO "
                + "FROM TACAFU_PRG WHERE "
                + "CODPER=?  AND "
                + "SECFUN||'.'||COPRES||'.'||CODCOM||'.'||CODACT||'.'||CODFUN||'.'||CODPRG||'.'||COSPRG||'.'||CODMET=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCadenaFuncional.getPeriodo());
            objPreparedStatement.setString(2, objBeanCadenaFuncional.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanCadenaFuncional.setSecuenciaFuncional(objResultSet.getString("SECUENCIA_FUNCIONAL"));
                objBeanCadenaFuncional.setCategoriaPresupuestal(objResultSet.getString("CATEGORIA_PRESUPUESTAL"));
                objBeanCadenaFuncional.setCategoriaPresupuestalNombre(objResultSet.getString("CATEGORIA_PRESUPUESTAL_NOMBRE"));
                objBeanCadenaFuncional.setProducto(objResultSet.getString("PRODUCTO"));
                objBeanCadenaFuncional.setProductoNombre(objResultSet.getString("PRODUCTO_NOMBRE"));
                objBeanCadenaFuncional.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBeanCadenaFuncional.setActividadNombre(objResultSet.getString("ACTIVIDAD_NOMBRE"));
                objBeanCadenaFuncional.setFuncion(objResultSet.getString("FUNCION"));
                objBeanCadenaFuncional.setFuncionNombre(objResultSet.getString("FUNCION_NOMBRE"));
                objBeanCadenaFuncional.setDivisionFuncional(objResultSet.getString("DIVISION_FUNCIONAL"));
                objBeanCadenaFuncional.setDivisionFuncionalNombre(objResultSet.getString("DIVISION_FUNCIONAL_NOMBRE"));
                objBeanCadenaFuncional.setGrupoFuncional(objResultSet.getString("GRUPO_FUNCIONAL"));
                objBeanCadenaFuncional.setGrupoFuncionalNombre(objResultSet.getString("GRUPO_FUNCIONAL_NOMBRE"));
                objBeanCadenaFuncional.setMeta(objResultSet.getString("META"));
                objBeanCadenaFuncional.setMetaNombre(objResultSet.getString("META_NOMBRE"));
                objBeanCadenaFuncional.setFinalidad(objResultSet.getString("FINALIDAD"));
                objBeanCadenaFuncional.setFinalidadNombre(objResultSet.getString("FINALIDAD_NOMBRE"));
                objBeanCadenaFuncional.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBeanCadenaFuncional.setDepartamento(objResultSet.getString("DEPARTAMENTO"));
                objBeanCadenaFuncional.setProvincia(objResultSet.getString("PROVINCIA"));
                objBeanCadenaFuncional.setDistrito(objResultSet.getString("DISTRITO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCadenaFuncional(BeanCadenaFuncional) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TACAFU_PRG");
            objBnMsgerr.setTipo(objBeanCadenaFuncional.getMode().toUpperCase());
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
        return objBeanCadenaFuncional;
    }

    @Override
    public int iduCadenaFuncional(BeanCadenaFuncional objBeanCadenaFuncional, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_CADENA_FUNCIONAL_PROG(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanCadenaFuncional.getPeriodo());
            cs.setString(2, objBeanCadenaFuncional.getCodigo());
            cs.setString(3, objBeanCadenaFuncional.getCategoriaPresupuestal());
            cs.setString(4, objBeanCadenaFuncional.getCategoriaPresupuestalNombre().toUpperCase());
            cs.setString(5, objBeanCadenaFuncional.getProducto());
            cs.setString(6, objBeanCadenaFuncional.getProductoNombre().toUpperCase());
            cs.setString(7, objBeanCadenaFuncional.getActividad());
            cs.setString(8, objBeanCadenaFuncional.getActividadNombre().toUpperCase());
            cs.setString(9, objBeanCadenaFuncional.getFuncion());
            cs.setString(10, objBeanCadenaFuncional.getFuncionNombre().toUpperCase());
            cs.setString(11, objBeanCadenaFuncional.getDivisionFuncional());
            cs.setString(12, objBeanCadenaFuncional.getDivisionFuncionalNombre().toUpperCase());
            cs.setString(13, objBeanCadenaFuncional.getGrupoFuncional());
            cs.setString(14, objBeanCadenaFuncional.getGrupoFuncionalNombre().toUpperCase());
            cs.setString(15, objBeanCadenaFuncional.getSecuenciaFuncional());
            cs.setString(16, objBeanCadenaFuncional.getMeta());
            cs.setString(17, objBeanCadenaFuncional.getMetaNombre().toUpperCase());
            cs.setString(18, objBeanCadenaFuncional.getFinalidad());
            cs.setString(19, objBeanCadenaFuncional.getFinalidadNombre().toUpperCase());
            cs.setString(20, objBeanCadenaFuncional.getUnidadMedida());
            cs.setString(21, objBeanCadenaFuncional.getDepartamento());
            cs.setString(22, objBeanCadenaFuncional.getProvincia());
            cs.setString(23, objBeanCadenaFuncional.getDistrito());
            cs.setString(24, usuario);
            cs.setString(25, objBeanCadenaFuncional.getMode());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduCadenaFuncional : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TACAFU_PRG");
            objBnMsgerr.setTipo(objBeanCadenaFuncional.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduCadenaFuncional : " + e.toString());
            }
        }
        return s;
    }
}
