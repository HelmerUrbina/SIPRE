/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPlaneamiento;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.ObjetivosEstrategicosDAO;
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
public class ObjetivosEstrategicosDAOImpl implements ObjetivosEstrategicosDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPlaneamiento objBnObjetivos;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ObjetivosEstrategicosDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaObjetivosEstrategicos(String periodo, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NOEI_CODIGO AS CODIGO, VOEI_DESCRIPCION AS DESCRIPCION, VOEI_ABREVIATURA AS ABREVIATURA, "
                + "NOEI_PRIORIDAD AS PRIORIDAD, DOEI_FECHA_INICIO AS FECHA_INICIO, DOEI_FECHA_FINAL AS FECHA_FINAL, "
                + "UTIL_NEW.FUN_NOMBRE_UNIDAD_MEDIDA(CUNIDAD_MEDIDA_CODIGO) AS UNIDAD_MEDIDA, "
                + "CASE CESTADO_CODIGO WHEN 'AC' THEN 'ACTIVO' WHEN 'AN' THEN 'ANULADO' ELSE 'VERIFICAR' END AS ESTADO "
                + "FROM SIPRE_PEI_OBJETIVOS_ESTRATEGIC WHERE "
                + "CPERIODO_CODIGO=? "
                + "ORDER BY PRIORIDAD";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, periodo);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnObjetivos = new BeanPlaneamiento();
                objBnObjetivos.setCodigo(objResultSet.getString("CODIGO"));
                objBnObjetivos.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnObjetivos.setAbreviatura(objResultSet.getString("ABREVIATURA"));
                objBnObjetivos.setPrioridad(objResultSet.getInt("PRIORIDAD"));
                objBnObjetivos.setFechaInicio(objResultSet.getDate("FECHA_INICIO"));
                objBnObjetivos.setFechaFinal(objResultSet.getDate("FECHA_FINAL"));
                objBnObjetivos.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBnObjetivos.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnObjetivos);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaObjetivosEstrategicos(" + periodo + ", " + usuario + ") : " + e.getMessage());
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
    public BeanPlaneamiento getObjetivosEstrategicos(BeanPlaneamiento objBeanObjetivos, String usuario) {
        sql = "SELECT VOEI_DESCRIPCION, VOEI_ABREVIATURA, NOEI_PRIORIDAD, DOEI_FECHA_INICIO, DOEI_FECHA_FINAL, "
                + "CUNIDAD_MEDIDA_CODIGO, CESTADO_CODIGO "
                + "FROM SIPRE_PEI_OBJETIVOS_ESTRATEGIC WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NOEI_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanObjetivos.getPeriodo());
            objPreparedStatement.setString(2, objBeanObjetivos.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanObjetivos.setDescripcion(objResultSet.getString("VOEI_DESCRIPCION"));
                objBeanObjetivos.setAbreviatura(objResultSet.getString("VOEI_ABREVIATURA"));
                objBeanObjetivos.setPrioridad(objResultSet.getInt("NOEI_PRIORIDAD"));
                objBeanObjetivos.setFechaInicio(objResultSet.getDate("DOEI_FECHA_INICIO"));
                objBeanObjetivos.setFechaFinal(objResultSet.getDate("DOEI_FECHA_FINAL"));
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
    public Integer getPrioridadObjetivosEstrategicos(String periodo, String usuario) {
        Integer prioridad = 0;
        sql = "SELECT NVL(MAX(NOEI_PRIORIDAD),0)+1 AS PRIORIDAD "
                + "FROM SIPRE_PEI_OBJETIVOS_ESTRATEGIC WHERE "
                + "CPERIODO_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, periodo);
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                prioridad = objResultSet.getInt("PRIORIDAD");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPrioridadObjetivosEstrategicos(" + periodo + ", " + usuario + ") : " + e.getMessage());
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
    public int iduObjetivosEstrategicos(BeanPlaneamiento objBeanObjetivos, String usuario) {
        sql = "{CALL SP_IDU_OBJETIVOS_ESTRATEGIC(?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanObjetivos.getPeriodo());
            cs.setString(2, objBeanObjetivos.getCodigo());
            cs.setString(3, objBeanObjetivos.getDescripcion());
            cs.setString(4, objBeanObjetivos.getAbreviatura());
            cs.setInt(5, objBeanObjetivos.getPrioridad());
            cs.setDate(6, objBeanObjetivos.getFechaInicio());
            cs.setDate(7, objBeanObjetivos.getFechaFinal());
            cs.setString(8, objBeanObjetivos.getUnidadMedida());
            cs.setString(9, objBeanObjetivos.getEstado());
            cs.setString(10, usuario);
            cs.setString(11, objBeanObjetivos.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduObjetivosEstrategicos : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PEI_OBJETIVOS_ESTRATEGIC");
            objBnMsgerr.setTipo(objBeanObjetivos.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
