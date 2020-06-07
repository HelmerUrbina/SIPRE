/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanResoluciones;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.ResolucionesDAO;
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
public class ResolucionesDAOImpl implements ResolucionesDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanResoluciones objBnResolucion;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ResolucionesDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaResoluciones(BeanResoluciones objBeanResolucion, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NCODIGO_RESOLUCION AS CODIGO, "
                + "CASE NCODIGO_RESOLUCION WHEN 1 THEN 'TODAS' ELSE UTIL_NEW.FUN_ABPPTO(NPRESUPUESTO_CODIGO) END AS PRESUPUESTO,"
                + "VNUMERO_RESOLUCION AS RESOLUCION, DFECHA_RESOLUCION AS FECHA,"
                + "UTIL_NEW.FUN_NOMBRE_TIPO_RESOLUCION(CTIPO_RESOLUCION_CODIGO) AS TIPO,"
                + "VDESCRIPCION_RESOLUCION AS DESCRIPCION, NIMPORTE_RESOLUCION AS IMPORTE "
                + "FROM SIPE_RESOLUCION WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CESTADO_RESOLUCION NOT IN ('IN') "
                + "ORDER BY FECHA DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanResolucion.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnResolucion = new BeanResoluciones();
                objBnResolucion.setCodigo(objResultSet.getInt("CODIGO"));
                objBnResolucion.setFuenteFinanciamiento(objResultSet.getString("PRESUPUESTO"));
                objBnResolucion.setResolucion(objResultSet.getString("RESOLUCION"));
                objBnResolucion.setFecha(objResultSet.getDate("FECHA"));
                objBnResolucion.setTipo(objResultSet.getString("TIPO"));
                objBnResolucion.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnResolucion.setImporte(objResultSet.getDouble("IMPORTE"));
                lista.add(objBnResolucion);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaResoluciones() : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_RESOLUCION");
            objBnMsgerr.setTipo("G");
            objBnMsgerr.setDescripcion(e.getMessage());
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
    public BeanResoluciones getResolucion(BeanResoluciones objBeanResolucion, String usuario) {
        sql = "SELECT VNUMERO_RESOLUCION AS RESOLUCION, DFECHA_RESOLUCION AS FECHA, "
                + "CTIPO_RESOLUCION_CODIGO AS TIPO, "
                + "VDESCRIPCION_RESOLUCION AS DESCRIPCION, "
                + "NIMPORTE_RESOLUCION AS IMPORTE, "
                + "NPRESUPUESTO_CODIGO AS PRESUPUESTO "
                + "FROM SIPE_RESOLUCION WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NCODIGO_RESOLUCION=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanResolucion.getPeriodo());
            objPreparedStatement.setInt(2, objBeanResolucion.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanResolucion.setResolucion(objResultSet.getString("RESOLUCION"));
                objBeanResolucion.setFecha(objResultSet.getDate("FECHA"));
                objBeanResolucion.setTipo(objResultSet.getString("TIPO"));
                objBeanResolucion.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBeanResolucion.setImporte(objResultSet.getDouble("IMPORTE"));
                objBeanResolucion.setFuenteFinanciamiento(objResultSet.getString("PRESUPUESTO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getResolucion(objBeanResolucion) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_RESOLUCION");
            objBnMsgerr.setTipo(objBeanResolucion.getMode());
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
        return objBeanResolucion;
    }

    @Override
    public int iduResolucion(BeanResoluciones objBeanResolucion, String usuario) {
        sql = "{CALL SP_IDU_RESOLUCION(?,?,?,?,?,?,?,?,?,?)}";
        try {
            try (CallableStatement cs = objConnection.prepareCall(sql)) {
                cs.setString(1, objBeanResolucion.getPeriodo());
                cs.setInt(2, objBeanResolucion.getCodigo());
                cs.setString(3, objBeanResolucion.getTipo());
                cs.setString(4, objBeanResolucion.getFuenteFinanciamiento());
                cs.setString(5, objBeanResolucion.getResolucion());
                cs.setString(6, objBeanResolucion.getDescripcion());
                cs.setDate(7, objBeanResolucion.getFecha());
                cs.setDouble(8, objBeanResolucion.getImporte());
                cs.setString(9, usuario);
                cs.setString(10, objBeanResolucion.getMode().toUpperCase());
                s = cs.executeUpdate();
            }
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduResolucion : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_RESOLUCION");
            objBnMsgerr.setTipo(objBeanResolucion.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
