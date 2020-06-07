/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPlaneamiento;
import DataService.Despachadores.AccionesEstrategicasDAO;
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
public class AccionesEstrategicasDAOImpl implements AccionesEstrategicasDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPlaneamiento objBnAcciones;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public AccionesEstrategicasDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaAccionesEstrategicas(BeanPlaneamiento objBeanAcciones, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NAEI_CODIGO AS CODIGO, VAEI_DESCRIPCION AS DESCRIPCION, VAEI_ABREVIATURA AS ABREVIATURA, "
                + "NAEI_PRIORIDAD AS PRIORIDAD, DAEI_FECHA_INICIO AS FECHA_INICIO, DAEI_FECHA_FINAL AS FECHA_FINAL, "
                + "PK_PLANEAMIENTO.FUN_ABREVIATURA_DIRECCION(NDIRECCION_CODIGO) AS DIRECCION, "
                + "UTIL_NEW.FUN_NOMBRE_UNIDAD_MEDIDA(CUNIDAD_MEDIDA_CODIGO) AS UNIDAD_MEDIDA, "
                + "CASE CESTADO_CODIGO WHEN 'AC' THEN 'ACTIVO' WHEN 'AN' THEN 'ANULADO' ELSE 'VERIFICAR' END AS ESTADO "
                + "FROM SIPRE_PEI_ACCIONES_ESTRATEGICA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NOEI_CODIGO=? "
                + "ORDER BY PRIORIDAD";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanAcciones.getPeriodo());
            objPreparedStatement.setInt(2, objBeanAcciones.getObjetivo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnAcciones = new BeanPlaneamiento();
                objBnAcciones.setCodigo(objResultSet.getString("CODIGO"));
                objBnAcciones.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnAcciones.setAbreviatura(objResultSet.getString("ABREVIATURA"));
                objBnAcciones.setPrioridad(objResultSet.getInt("PRIORIDAD"));
                objBnAcciones.setFechaInicio(objResultSet.getDate("FECHA_INICIO"));
                objBnAcciones.setFechaFinal(objResultSet.getDate("FECHA_FINAL"));
                objBnAcciones.setDireccion(objResultSet.getString("DIRECCION"));
                objBnAcciones.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBnAcciones.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnAcciones);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaAccionesEstrategicas(" + objBeanAcciones + ", " + usuario + ") : " + e.getMessage());
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
    public BeanPlaneamiento getAccionesEstrategicas(BeanPlaneamiento objBeanObjetivos, String usuario) {
        sql = "SELECT VAEI_DESCRIPCION, VAEI_ABREVIATURA, NAEI_PRIORIDAD, DAEI_FECHA_INICIO, DAEI_FECHA_FINAL, "
                + "NDIRECCION_CODIGO, CUNIDAD_MEDIDA_CODIGO, CESTADO_CODIGO "
                + "FROM SIPRE_PEI_ACCIONES_ESTRATEGICA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NOEI_CODIGO=? AND "
                + "NAEI_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanObjetivos.getPeriodo());
            objPreparedStatement.setInt(2, objBeanObjetivos.getObjetivo());
            objPreparedStatement.setString(3, objBeanObjetivos.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanObjetivos.setDescripcion(objResultSet.getString("VAEI_DESCRIPCION"));
                objBeanObjetivos.setAbreviatura(objResultSet.getString("VAEI_ABREVIATURA"));
                objBeanObjetivos.setPrioridad(objResultSet.getInt("NAEI_PRIORIDAD"));
                objBeanObjetivos.setFechaInicio(objResultSet.getDate("DAEI_FECHA_INICIO"));
                objBeanObjetivos.setFechaFinal(objResultSet.getDate("DAEI_FECHA_FINAL"));
                objBeanObjetivos.setDireccion(objResultSet.getString("NDIRECCION_CODIGO"));
                objBeanObjetivos.setUnidadMedida(objResultSet.getString("CUNIDAD_MEDIDA_CODIGO"));
                objBeanObjetivos.setEstado(objResultSet.getString("CESTADO_CODIGO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getObjetivosEstrategicos(" + objBeanObjetivos + ", " + usuario + ") : " + e.getMessage());
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
        return objBeanObjetivos;
    }

    @Override
    public Integer getPrioridadAccionesEstrategicas(BeanPlaneamiento objBeanAcciones, String usuario) {
        Integer prioridad = 0;
        sql = "SELECT NVL(MAX(NAEI_PRIORIDAD),0)+1 AS PRIORIDAD "
                + "FROM SIPRE_PEI_ACCIONES_ESTRATEGICA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NOEI_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanAcciones.getPeriodo());
            objPreparedStatement.setInt(2, objBeanAcciones.getObjetivo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                prioridad = objResultSet.getInt("PRIORIDAD");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPrioridadAccionesEstrategicas(" + objBeanAcciones + ", " + usuario + ") : " + e.getMessage());
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
        return prioridad;
    }

    @Override
    public int iduAccionesEstrategicas(BeanPlaneamiento objBeanObjetivos, String usuario) {
        sql = "{CALL SP_IDU_ACCIONES_ESTRATEGICAS(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanObjetivos.getPeriodo());
            cs.setInt(2, objBeanObjetivos.getObjetivo());
            cs.setString(3, objBeanObjetivos.getCodigo());
            cs.setString(4, objBeanObjetivos.getDescripcion());
            cs.setString(5, objBeanObjetivos.getAbreviatura());
            cs.setInt(6, objBeanObjetivos.getPrioridad());
            cs.setString(7, objBeanObjetivos.getDireccion());
            cs.setDate(8, objBeanObjetivos.getFechaInicio());
            cs.setDate(9, objBeanObjetivos.getFechaFinal());
            cs.setString(10, objBeanObjetivos.getUnidadMedida());
            cs.setString(11, objBeanObjetivos.getEstado());
            cs.setString(12, usuario);
            cs.setString(13, objBeanObjetivos.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduAccionesEstrategicas : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PEI_ACCIONES_ESTRATEGICA");
            objBnMsgerr.setTipo(objBeanObjetivos.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
