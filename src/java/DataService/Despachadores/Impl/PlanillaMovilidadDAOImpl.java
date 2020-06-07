/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPlanillaMovilidad;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PlanillaMovilidadDAO;
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
public class PlanillaMovilidadDAOImpl implements PlanillaMovilidadDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPlanillaMovilidad objBnPlanillaMovilidad;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public PlanillaMovilidadDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaPlanillaMovilidad(BeanPlanillaMovilidad objBeanPlanillaMovilidad, String usuario) {
        lista = new LinkedList<>();
        sql = " SELECT NCORRELATIVO_MOVILIDAD AS CODIGO,"
                + "UTIL_NEW.FUN_NOMBRE_UBIGEO(CLUGAR_ORIGEN) AS ORIGEN,"
                + "CASE CLUGAR_DESTINO WHEN '150101' THEN 'CERCADO DE LIMA' ELSE "
                + "UTIL_NEW.FUN_NOMBRE_UBIGEO(CLUGAR_DESTINO) END AS DESTINO,"
                + "DFECHA_MOVILIDAD AS FECHA_MOV,"
                + "VJUSTIFICACION_MOVILIDAD AS JUSTIFICACION,"
                + "SUM(NIMPORTE_MOVILIDAD) AS IMPORTE,"
                + "CASE CESTADO_CODIGO WHEN 'CE' THEN 'CERRADO' ELSE 'PENDIENTE' END AS ESTADO "
                + " FROM SIPE_PLANILLA_MOVILIDAD "
                + "WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CMES_CODIGO=? AND "
                + "VUSUARIO_PLANILLA=? "
                + "GROUP BY NCORRELATIVO_MOVILIDAD,CLUGAR_ORIGEN,CLUGAR_DESTINO,"
                + "DFECHA_MOVILIDAD,VJUSTIFICACION_MOVILIDAD,CESTADO_CODIGO "
                + "ORDER BY FECHA_MOV";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPlanillaMovilidad.getPeriodo());
            objPreparedStatement.setString(2, objBeanPlanillaMovilidad.getMes());
            objPreparedStatement.setString(3, objBeanPlanillaMovilidad.getUsuarioPlanilla());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnPlanillaMovilidad = new BeanPlanillaMovilidad();
                objBnPlanillaMovilidad.setCorrelativo(objResultSet.getInt("CODIGO"));
                objBnPlanillaMovilidad.setLugarOrigen(objResultSet.getString("ORIGEN"));
                objBnPlanillaMovilidad.setLugarDestino(objResultSet.getString("DESTINO"));
                objBnPlanillaMovilidad.setFechaMovilidad(objResultSet.getDate("FECHA_MOV"));
                objBnPlanillaMovilidad.setJustificacion(objResultSet.getString("JUSTIFICACION"));
                objBnPlanillaMovilidad.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnPlanillaMovilidad.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnPlanillaMovilidad);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPlanillaMovilidad(objBeanPlanillaMovilidad) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PLANILLA_MOVILIDAD");
            objBnMsgerr.setTipo(objBnPlanillaMovilidad.getMode());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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
    public int iduPlanillaMovilidad(BeanPlanillaMovilidad objBeanPlanillaMovilidad, String usuario) {
        sql = "{CALL SP_IDU_PLANILLA_MOVILIDAD(?,?,?,?,?,?,?,?,?,?,?)}";
        try {
            CallableStatement cs = objConnection.prepareCall(sql);
            cs.setString(1, objBeanPlanillaMovilidad.getPeriodo());
            cs.setString(2, objBeanPlanillaMovilidad.getMes());
            cs.setInt(3, objBeanPlanillaMovilidad.getCorrelativo());
            cs.setString(4, objBeanPlanillaMovilidad.getUsuarioPlanilla());
            cs.setDate(5, objBeanPlanillaMovilidad.getFechaMovilidad());
            cs.setString(6, objBeanPlanillaMovilidad.getLugarOrigen());
            cs.setString(7, objBeanPlanillaMovilidad.getLugarDestino());
            cs.setDouble(8, objBeanPlanillaMovilidad.getImporte());
            cs.setString(9, objBeanPlanillaMovilidad.getJustificacion());
            cs.setString(10, usuario);
            cs.setString(11, objBeanPlanillaMovilidad.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPlanillaMovilidad : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PLANILLA_MOVILIDAD");
            objBnMsgerr.setTipo(objBeanPlanillaMovilidad.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduPlanillaMovilidad : " + e.getMessage());
            }
        }
        return s;
    }

    @Override
    public BeanPlanillaMovilidad getPlanillaMovilidad(BeanPlanillaMovilidad objBeanPlanillaMovilidad, String usuario) {
        sql = "SELECT CLUGAR_ORIGEN AS ORIGEN,"
                + "CLUGAR_DESTINO AS DESTINO,"
                + "DFECHA_MOVILIDAD AS FECHA_MOV,"
                + "VJUSTIFICACION_MOVILIDAD AS JUSTIFICACION,"
                + "NIMPORTE_MOVILIDAD AS IMPORTE "
                + " FROM SIPE_PLANILLA_MOVILIDAD "
                + "WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CMES_CODIGO=? AND "
                + "VUSUARIO_PLANILLA=? AND "
                + "NCORRELATIVO_MOVILIDAD=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPlanillaMovilidad.getPeriodo());
            objPreparedStatement.setString(2, objBeanPlanillaMovilidad.getMes());
            objPreparedStatement.setString(3, objBeanPlanillaMovilidad.getUsuarioPlanilla());
            objPreparedStatement.setInt(4, objBeanPlanillaMovilidad.getCorrelativo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanPlanillaMovilidad.setLugarOrigen(objResultSet.getString("ORIGEN"));
                objBeanPlanillaMovilidad.setLugarDestino(objResultSet.getString("DESTINO"));
                objBeanPlanillaMovilidad.setFechaMovilidad(objResultSet.getDate("FECHA_MOV"));
                objBeanPlanillaMovilidad.setJustificacion(objResultSet.getString("JUSTIFICACION"));
                objBeanPlanillaMovilidad.setImporte(objResultSet.getDouble("IMPORTE"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPlanillaMovilidad(objBeanPlanillaMovilidad) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PLANILLA_MOVILIDAD");
            objBnMsgerr.setTipo(objBeanPlanillaMovilidad.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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
        return objBeanPlanillaMovilidad;
    }

    @Override
    public List getListaPlanillaConsolidado(BeanPlanillaMovilidad objBeanPlanillaMovilidad, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT VUSUARIO_PLANILLA AS CODIGO,"
                + "UTIL_NEW.FUN_NOMUSU('0003',VUSUARIO_PLANILLA) AS USUARIO,"
                + "SUM(NIMPORTE_MOVILIDAD) AS IMPORTE "
                + "FROM SIPE_PLANILLA_MOVILIDAD  "
                + "WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CMES_CODIGO=? AND "
                + "CESTADO_CODIGO='CE' "
                + "GROUP BY VUSUARIO_PLANILLA "
                + "ORDER BY USUARIO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPlanillaMovilidad.getPeriodo());
            objPreparedStatement.setString(2, objBeanPlanillaMovilidad.getMes());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnPlanillaMovilidad = new BeanPlanillaMovilidad();
                objBnPlanillaMovilidad.setUsuarioPlanilla(objResultSet.getString("CODIGO"));
                objBnPlanillaMovilidad.setJustificacion(objResultSet.getString("USUARIO"));
                objBnPlanillaMovilidad.setImporte(objResultSet.getDouble("IMPORTE"));
                lista.add(objBnPlanillaMovilidad);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPlanillaConsolidado(objBeanPlanillaMovilidad) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PLANILLA_MOVILIDAD");
            objBnMsgerr.setTipo(objBnPlanillaMovilidad.getMode());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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
    public int iduConsolidadoMovilidad(BeanPlanillaMovilidad objBeanPlanillaMovilidad, String usuario) {
        sql = "{CALL SP_IDU_VERIFICAR_PLANILLA_MOV(?,?,?,?,?)}";
        try {
            CallableStatement cs = objConnection.prepareCall(sql);
            cs.setString(1, objBeanPlanillaMovilidad.getPeriodo());
            cs.setString(2, objBeanPlanillaMovilidad.getMes());
            cs.setString(3, objBeanPlanillaMovilidad.getUsuarioPlanilla());
            cs.setString(4, usuario);
            cs.setString(5, objBeanPlanillaMovilidad.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduConsolididadoMovilidad : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PLANILLA_MOVILIDAD");
            objBnMsgerr.setTipo(objBeanPlanillaMovilidad.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduConsolididadoMovilidad : " + e.toString());
            }
        }
        return s;
    }

}
