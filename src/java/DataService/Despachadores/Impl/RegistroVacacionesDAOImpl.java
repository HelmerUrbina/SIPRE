/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanRegistroVacaciones;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.RegistroVacacionesDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public class RegistroVacacionesDAOImpl implements RegistroVacacionesDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanRegistroVacaciones objBnRegistroVacaciones;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public RegistroVacacionesDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaVacaciones(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NCORRELATIVO AS CORRELATIVO,"
                + "DFECHA_INICIO AS FECHA_INICIO,"
                + "DFECHA_FIN AS FECHA_FIN,"
                + "NCANTIDAD_DIAS_DISP AS DIAS_DISP,"
                + "NCANTIDAD_DIAS_SOL AS DIAS_SOL,"
                + "NCANTIDAD_DIAS_REST AS DIAS_RES,"
                + "CASE CESTADO_REGISTRO WHEN 'PE' THEN 'PENDIENTE' WHEN 'AP' THEN 'APROBADO' "
                + "WHEN 'AN' THEN 'ANULADO' WHEN 'CE' THEN 'CERRADO' WHEN 'RZ' THEN 'RECHAZADO' ELSE '' END AS ESTADO,"
                + "CASE CESTADO_REGISTRO WHEN 'AP' THEN ' ' ELSE VOBSERVACIONES END AS OBSERVACIONES "
                + "FROM SIPE_REGISTRO_VACACIONES "
                + "WHERE CPERIODO_CODIGO=? AND "
                + "VCODIGO_PERSONAL=? AND "
                + "CESTADO_REGISTRO NOT IN ('AN') ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanRegistroVacaciones.getPeriodo());
            objPreparedStatement.setString(2, objBeanRegistroVacaciones.getCodigoPersonal());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnRegistroVacaciones = new BeanRegistroVacaciones();
                objBnRegistroVacaciones.setCorrelativo(objResultSet.getInt("CORRELATIVO"));
                objBnRegistroVacaciones.setFechaInicio(objResultSet.getDate("FECHA_INICIO"));
                objBnRegistroVacaciones.setFechaFin(objResultSet.getDate("FECHA_FIN"));
                objBnRegistroVacaciones.setDiasDisponible(objResultSet.getInt("DIAS_DISP"));
                objBnRegistroVacaciones.setDiasSolicitado(objResultSet.getInt("DIAS_SOL"));
                objBnRegistroVacaciones.setDiasRestantes(objResultSet.getInt("DIAS_RES"));
                objBnRegistroVacaciones.setEstado(objResultSet.getString("ESTADO"));
                objBnRegistroVacaciones.setObservaciones(objResultSet.getString("OBSERVACIONES"));
                lista.add(objBnRegistroVacaciones);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaVacaciones(objBeanRegistroVacaciones) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_VACACIONES");
            objBnMsgerr.setTipo(objBeanRegistroVacaciones.getMode());
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
    public BeanRegistroVacaciones getVacacionesPersonal(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario) {
        sql = "SELECT "
                + "DFECHA_INICIO AS FECHA_INICIO,"
                + "DFECHA_FIN AS FECHA_FIN,"
                + "NCANTIDAD_DIAS_DISP AS DIAS_DISP,"
                + "NCANTIDAD_DIAS_SOL AS DIAS_SOL,"
                + "NCANTIDAD_DIAS_REST AS DIAS_RES,NVL(VMOTIVO_VACACIONES,'') AS MOTIVO "
                + " FROM SIPE_REGISTRO_VACACIONES "
                + "WHERE CPERIODO_CODIGO=? AND "
                + "VCODIGO_PERSONAL=? AND "
                + "NCORRELATIVO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanRegistroVacaciones.getPeriodo());
            objPreparedStatement.setString(2, objBeanRegistroVacaciones.getCodigoPersonal());
            objPreparedStatement.setInt(3, objBeanRegistroVacaciones.getCorrelativo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanRegistroVacaciones.setFechaInicio(objResultSet.getDate("FECHA_INICIO"));
                objBeanRegistroVacaciones.setFechaFin(objResultSet.getDate("FECHA_FIN"));
                objBeanRegistroVacaciones.setDiasDisponible(objResultSet.getInt("DIAS_DISP"));
                objBeanRegistroVacaciones.setDiasSolicitado(objResultSet.getInt("DIAS_SOL"));
                objBeanRegistroVacaciones.setDiasRestantes(objResultSet.getInt("DIAS_RES"));
                objBeanRegistroVacaciones.setMotivo(objResultSet.getString("MOTIVO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getVacacionesPersonal(objBeanRegistroVacaciones) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_VACACIONES");
            objBnMsgerr.setTipo(objBeanRegistroVacaciones.getMode().toUpperCase());
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
        return objBeanRegistroVacaciones;
    }

    @Override
    public int iduRegistroVacaciones(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario) {
        sql = "{CALL SP_IDU_REGISTRO_VACACIONES(?,?,?,?,?,?,?,?,?,?,?,?)}";

        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanRegistroVacaciones.getPeriodo());
            cs.setString(2, objBeanRegistroVacaciones.getCodigoPersonal());
            cs.setInt(3, objBeanRegistroVacaciones.getCorrelativo());
            cs.setDate(4, objBeanRegistroVacaciones.getFechaInicio());
            cs.setDate(5, objBeanRegistroVacaciones.getFechaFin());
            cs.setInt(6, objBeanRegistroVacaciones.getDiasDisponible());
            cs.setInt(7, objBeanRegistroVacaciones.getDiasSolicitado());
            cs.setString(8, objBeanRegistroVacaciones.getMotivo());
            cs.setInt(9, objBeanRegistroVacaciones.getDiasNoLaborables());
            cs.setInt(10, objBeanRegistroVacaciones.getDiasLaborables());
            cs.setString(11, usuario);
            cs.setString(12, objBeanRegistroVacaciones.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduRegistroVacaciones : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_VACACIONES");
            objBnMsgerr.setTipo(objBeanRegistroVacaciones.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int getDiasDisponibles(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario) {
        Integer cantidad = 0;
        sql = "SELECT NVL(SUM(NCANTIDAD_DIAS),30) AS CANTIDAD "
                + " FROM SIPE_REGISTRO_VACACIONES_MOV "
                + "WHERE CPERIODO_CODIGO=? AND "
                + "VCODIGO_PERSONAL=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanRegistroVacaciones.getPeriodo());
            objPreparedStatement.setString(2, objBeanRegistroVacaciones.getCodigoPersonal());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                cantidad = objResultSet.getInt("CANTIDAD");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getDiasDisponibles(objBeanRegistroVacaciones) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_VACACIONES_MOV");
            objBnMsgerr.setTipo(objBeanRegistroVacaciones.getMode().toUpperCase());
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
        return cantidad;
    }

    @Override
    public List getListaConsolidadoVacaciones(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT RP.VDNI_PERSONAL AS DOCUMENTO,"
                + "RP.VNOMBRES_PERSONAL||' '||RP.VAPELLIDOS_PERSONAL AS PERSONAL,"
                + "30 AS D_HABILES,"
                + "(SELECT NVL(SUM(VM.NCANTIDAD_DIAS),30) FROM SIPE_REGISTRO_VACACIONES RV JOIN SIPE_REGISTRO_VACACIONES_MOV VM "
                + "ON (RV.CPERIODO_CODIGO=VM.CPERIODO_CODIGO AND RV.VCODIGO_PERSONAL=VM.VCODIGO_PERSONAL) "
                + "WHERE "
                + "RV.CPERIODO_CODIGO=? AND RV.VCODIGO_PERSONAL=RP.VDNI_PERSONAL AND RV.CESTADO_REGISTRO IN ('CE','AP') ) AS D_DISPONIBLES, "
                + "(SELECT NVL(SUM(VM.NCANTIDAD_DIAS),30) FROM SIPE_REGISTRO_VACACIONES RV JOIN SIPE_REGISTRO_VACACIONES_MOV VM "
                + "ON (RV.CPERIODO_CODIGO=VM.CPERIODO_CODIGO AND RV.VCODIGO_PERSONAL=VM.VCODIGO_PERSONAL) "
                + "WHERE "
                + "RV.CPERIODO_CODIGO=? AND RV.VCODIGO_PERSONAL=RP.VDNI_PERSONAL AND RV.CESTADO_REGISTRO IN ('CE','AP') ) AS D_QUEDAN "
                + "FROM SIPE_REGISTRO_PERSONAL RP "
                + "ORDER BY PERSONAL";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanRegistroVacaciones.getPeriodo());
            objPreparedStatement.setString(2, objBeanRegistroVacaciones.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnRegistroVacaciones = new BeanRegistroVacaciones();
                objBnRegistroVacaciones.setCodigoPersonal(objResultSet.getString("DOCUMENTO"));
                objBnRegistroVacaciones.setNombres(objResultSet.getString("PERSONAL"));
                objBnRegistroVacaciones.setDiasDisponible(objResultSet.getInt("D_HABILES"));
                objBnRegistroVacaciones.setDiasSolicitado(objResultSet.getInt("D_DISPONIBLES"));
                objBnRegistroVacaciones.setDiasRestantes(objResultSet.getInt("D_QUEDAN"));
                lista.add(objBnRegistroVacaciones);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaVacaciones(objBeanRegistroVacaciones) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_VACACIONES");
            objBnMsgerr.setTipo(objBeanRegistroVacaciones.getMode());
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
    public ArrayList getListaVacacionesPersonal(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT RV.NCORRELATIVO AS CODIGO,"
                + "TRIM(INITCAP(to_char(RV.DFECHA_INICIO, 'DAY', 'NLS_DATE_LANGUAGE=SPANISH')))||' '||TO_CHAR(RV.DFECHA_INICIO,'DD')||' de '||"
                + "INITCAP(UTIL_NEW.FUN_NONMES(TO_CHAR(RV.DFECHA_INICIO,'MM')))||' '||TO_CHAR(RV.DFECHA_INICIO,'YYYY') AS EMPIEZA,"
                + "TRIM(INITCAP(to_char(RV.DFECHA_FIN, 'DAY', 'NLS_DATE_LANGUAGE=SPANISH')))||' '||TO_CHAR(RV.DFECHA_FIN,'DD')||' de '||"
                + "INITCAP(UTIL_NEW.FUN_NONMES(TO_CHAR(RV.DFECHA_FIN,'MM')))||' '||TO_CHAR(RV.DFECHA_FIN,'YYYY') AS TERMINA,"
                + "LPAD(RV.NCANTIDAD_DIAS_SOL,2,0) AS DIAS,"
                + "CASE CESTADO_REGISTRO WHEN 'PE' THEN 'PENDIENTE' WHEN 'AP' THEN 'APROBADO' "
                + "WHEN 'AN' THEN 'ANULADO' WHEN 'CE' THEN 'CERRADO' WHEN 'RZ' THEN 'RECHAZADO' ELSE '' END AS ESTADO "
                + "FROM SIPE_REGISTRO_VACACIONES RV WHERE "
                + "RV.CPERIODO_CODIGO=? AND "
                + "RV.VCODIGO_PERSONAL=? AND "
                + "RV.CESTADO_REGISTRO IN ('CE','AP') "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanRegistroVacaciones.getPeriodo());
            objPreparedStatement.setString(2, objBeanRegistroVacaciones.getCodigoPersonal());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("EMPIEZA") + "+++"
                        + objResultSet.getString("TERMINA") + "+++"
                        + objResultSet.getString("DIAS") + "+++"
                        + objResultSet.getString("ESTADO");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaVacacionesPersonal(objBeanRegistroVacaciones() : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_VACACIONES");
            objBnMsgerr.setTipo(objBeanRegistroVacaciones.getMode().toUpperCase());
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
        return Arreglo;
    }

    @Override
    public int updRegistroVacaciones(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario) {
        sql = "{CALL SP_UPD_REGISTRO_VACACIONES(?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanRegistroVacaciones.getPeriodo());
            cs.setString(2, objBeanRegistroVacaciones.getCodigoPersonal());
            cs.setInt(3, objBeanRegistroVacaciones.getCorrelativo());
            cs.setString(4, objBeanRegistroVacaciones.getMotivo());
            cs.setString(5, usuario);
            cs.setString(6, objBeanRegistroVacaciones.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar updRegistroVacaciones : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_VACACIONES");
            objBnMsgerr.setTipo(objBeanRegistroVacaciones.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
