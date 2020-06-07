/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanDisponibilidadPresupuestal;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.DisponibilidadPresupuestalDAO;
import DataService.Despachadores.MsgerrDAO;
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
 * @author H-URBINA-M
 */
public class DisponibilidadPresupuestalDAOImpl implements DisponibilidadPresupuestalDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanDisponibilidadPresupuestal objBnDisponibilidad;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public DisponibilidadPresupuestalDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario) {
        String unidadOperativa = objBeanDisponibilidad.getUnidadOperativa().trim();
        if (unidadOperativa.equals("*")) {
            unidadOperativa = "";
        }
        lista = new LinkedList<>();
        sql = "SELECT CINFORME_DISPONIBILIDAD_CODIGO AS CODIGO, "
                + "CASE CINFORME_DISPONIBILIDAD_TIPO WHEN 'IDP' THEN 'INFORME' WHEN 'CDP' THEN 'CONSTANCIA' ELSE ' 'END AS TIPO,"
                + "CASE CINFORME_DISPONIBILIDAD_TIPO WHEN 'IDP' THEN CINFORME_DISPONIBILIDAD_CODIGO WHEN 'CDP' THEN LPAD(NINFORME_DISPONIBILIDAD_CONSTA,5,0) ELSE ' ' END AS NUMERO, "
                + "CUNIDAD_OPERATIVA_CODIGO||':'||UTIL_NEW.FUN_ABUUOO(CUNIDAD_OPERATIVA_CODIGO) AS UNIDAD, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VINFORME_DISPONIBILIDAD_OFICIO),'''',''),'\n"
                + "', ' ') AS DOCUMENTO, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VINFORME_DISPONIBILIDAD_CONCEP),'''',''),'\n"
                + "', ' ') AS CONCEPTO, "
                + "OPRE_NEW.FUN_TOTAL_DETALLE_INFORME(CPERIODO_CODIGO, CINFORME_DISPONIBILIDAD_CODIGO) AS IMPORTE, "
                + "DFECHA_EMISION AS FECHA, "
                + "CASE CESTADO_INFORME WHEN 'PE' THEN 'PENDIENTE' WHEN 'NO' THEN 'EN NOTA' WHEN 'CO' THEN 'CONSOLIDADO' "
                + "WHEN 'RS' THEN 'RECHAZO SIAF' WHEN 'AP' THEN 'APROBADA' WHEN 'AN' THEN 'ANULADO' ELSE '' END AS ESTADO, "
                + "DFECHA_APROBACION AS FECHA_APROBACION, "
                + "CASE WHEN TO_CHAR(UTIL_NEW.FUN_NOTA_MODIFICATORIA_INFORME(CPERIODO_CODIGO, CINFORME_DISPONIBILIDAD_CODIGO, '0003')) IS NULL THEN '' ELSE  "
                + "TO_CHAR(UTIL_NEW.FUN_NOTA_MODIFICATORIA_INFORME(CPERIODO_CODIGO, CINFORME_DISPONIBILIDAD_CODIGO,'0003')) END AS NOTA_SIPE, "
                + "UTIL_NEW.FUN_NUM_SIAF_INFORME(CPERIODO_CODIGO,CINFORME_DISPONIBILIDAD_CODIGO,'0003') AS NOTA_SIAF, "
                + "CASE CINFORME_CERRADO WHEN 'CE' THEN 'SI' WHEN 'PE' THEN 'NO' ELSE ' ' END AS ESTADO_CIERRE, "
                + "DUSUARIO_INFORME_CIERRE AS FECHA_CIERRE "
                + "FROM SIPE_INFORME_DISPONIBILIDAD WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO LIKE ? AND "
                + "CMES_CODIGO=? "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDisponibilidad.getPeriodo());
            objPreparedStatement.setInt(2, objBeanDisponibilidad.getPresupuesto());
            objPreparedStatement.setString(3, "%" + unidadOperativa + "%");
            objPreparedStatement.setString(4, objBeanDisponibilidad.getMes());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDisponibilidad = new BeanDisponibilidadPresupuestal();
                objBnDisponibilidad.setCodigo(objResultSet.getString("CODIGO"));
                objBnDisponibilidad.setTipo(objResultSet.getString("TIPO"));
                objBnDisponibilidad.setPeriodo(objResultSet.getString("NUMERO"));
                objBnDisponibilidad.setUnidad(objResultSet.getString("UNIDAD"));
                objBnDisponibilidad.setOficio(objResultSet.getString("DOCUMENTO"));
                objBnDisponibilidad.setConcepto(objResultSet.getString("CONCEPTO"));
                objBnDisponibilidad.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnDisponibilidad.setEstado(objResultSet.getString("ESTADO"));
                objBnDisponibilidad.setFecha(objResultSet.getDate("FECHA"));
                objBnDisponibilidad.setFechaAprobacion(objResultSet.getDate("FECHA_APROBACION"));
                objBnDisponibilidad.setTarea(objResultSet.getString("NOTA_SIPE"));
                objBnDisponibilidad.setCadenaGasto(objResultSet.getString("NOTA_SIAF"));
                objBnDisponibilidad.setSecuencia(objResultSet.getString("ESTADO_CIERRE"));
                objBnDisponibilidad.setFechaCierre(objResultSet.getDate("FECHA_CIERRE"));
                lista.add(objBnDisponibilidad);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDisponibilidadPresupuestal(objBeanDisponibilidad, usuario) : " + e.getMessage());
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
    public List getListaDisponibilidadPresupuestalDetalle(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario) {
        String unidadOperativa = objBeanDisponibilidad.getUnidadOperativa().trim();
        if (unidadOperativa.equals("*")) {
            unidadOperativa = "";
        }
        lista = new LinkedList<>();
        sql = "SELECT DP.CINFORME_DISPONIBILIDAD_CODIGO AS CODIGO, "
                + "NINFORME_DISPONIBILIDAD_DETAL AS DETALLE, "
                + "UTIL_NEW.FUN_ABUUOO(CUNIDAD_CODIGO) AS UNIDAD, "
                + "UTIL_NEW.FUN_ABRDEP(CUNIDAD_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "CSECUENCIA_FUNCIONAL_CODIGO ||'-'|| UTIL_NEW.FUN_DESMET(DP.CPERIODO_CODIGO, DP.NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) AS SECUENCIA, "
                + "CMETA_OPERATIVA_CODIGO||'-'||UTIL_NEW.FUN_NOMEOP(CMETA_OPERATIVA_CODIGO) AS TAREA, "
                + "VCADENA_GASTO_CODIGO||'-'||UTIL_NEW.FUN_NOCLAS(VCADENA_GASTO_CODIGO) AS CADENA_GASTO, "
                + "NINFORME_DETALLE_IMPORTE AS IMPORTE "
                + "FROM SIPE_INFORME_DISPONIBILIDAD DP INNER JOIN SIPE_INFORME_DISPONIBILIDAD_DE DD ON ("
                + "DP.CPERIODO_CODIGO=DD.CPERIODO_CODIGO AND "
                + "DP.NPRESUPUESTO_CODIGO=DD.NPRESUPUESTO_CODIGO AND "
                + "DP.CINFORME_DISPONIBILIDAD_CODIGO=DD.CINFORME_DISPONIBILIDAD_CODIGO AND "
                + "DP.CUNIDAD_OPERATIVA_CODIGO=DD.CUNIDAD_OPERATIVA_CODIGO) WHERE "
                + "DP.CPERIODO_CODIGO=? AND "
                + "DP.NPRESUPUESTO_CODIGO=? AND "
                + "DP.CUNIDAD_OPERATIVA_CODIGO LIKE ? AND "
                + "DP.CMES_CODIGO=? "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDisponibilidad.getPeriodo());
            objPreparedStatement.setInt(2, objBeanDisponibilidad.getPresupuesto());
            objPreparedStatement.setString(3, "%" + unidadOperativa + "%");
            objPreparedStatement.setString(4, objBeanDisponibilidad.getMes());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDisponibilidad = new BeanDisponibilidadPresupuestal();
                objBnDisponibilidad.setCodigo(objResultSet.getString("CODIGO"));
                objBnDisponibilidad.setDetalle(objResultSet.getInt("DETALLE"));
                objBnDisponibilidad.setUnidad(objResultSet.getString("UNIDAD"));
                objBnDisponibilidad.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnDisponibilidad.setSecuencia(objResultSet.getString("SECUENCIA"));
                objBnDisponibilidad.setTarea(objResultSet.getString("TAREA"));
                objBnDisponibilidad.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnDisponibilidad.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnDisponibilidad.setImporte(objResultSet.getDouble("IMPORTE"));
                lista.add(objBnDisponibilidad);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDisponibilidadPresupuestalDetalle(objBeanDisponibilidad, usuario) : " + e.getMessage());
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
    public ArrayList getListaDetalleDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT DD.NINFORME_DISPONIBILIDAD_DETAL AS CODIGO, "
                + "DD.NRESOLUCION_CARGO||':'||UTIL.FUN_DESCRIPCION_RESOLUCION(DD.CPERIODO_CODIGO, NRESOLUCION_CARGO) AS RESOLUCION_CARGO, "
                + "CDEPENDENCIA_CARGO||':'||UTIL_NEW.FUN_ABRDEP('0003', CDEPENDENCIA_CARGO) AS DEPENDENCIA_CARGO, "
                + "CSECUENCIA_FUNCIONAL_CARGO||':'||UTIL_NEW.FUN_DESMET(DD.CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CARGO) AS SECUENCIA_FUNCIONAL_CARGO, "
                + "CMETA_OPERATIVA_CARGO||':'||UTIL_NEW.FUN_NOMEOP(CMETA_OPERATIVA_CARGO) AS TAREA_CARGO, "
                + "VCADENA_GASTO_CARGO||':'||UTIL_NEW.FUN_NOCLAS(VCADENA_GASTO_CARGO) AS CADENA_GASTO_CARGO, "
                + "CUNIDAD_CODIGO||':'||UTIL_NEW.FUN_ABUUOO(CUNIDAD_CODIGO) AS UNIDAD, "
                + "CDEPENDENCIA_CODIGO||':'||UTIL_NEW.FUN_ABRDEP(CUNIDAD_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "CSECUENCIA_FUNCIONAL_CODIGO||':'||UTIL_NEW.FUN_DESMET(DD.CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) AS SECUENCIA_FUNCIONAL, "
                + "CMETA_OPERATIVA_CODIGO||':'||UTIL_NEW.FUN_NOMEOP(CMETA_OPERATIVA_CODIGO) AS TAREA, "
                + "VCADENA_GASTO_CODIGO||':'||UTIL_NEW.FUN_NOCLAS(VCADENA_GASTO_CODIGO) AS CADENA_GASTO, "
                + "AVG(NINFORME_DETALLE_IMPORTE) AS IMPORTE, "
                + "SUM(CASE CMES_CODIGO WHEN '01' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS ENERO, "
                + "SUM(CASE CMES_CODIGO WHEN '02' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS FEBRERO, "
                + "SUM(CASE CMES_CODIGO WHEN '03' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS MARZO, "
                + "SUM(CASE CMES_CODIGO WHEN '04' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS ABRIL, "
                + "SUM(CASE CMES_CODIGO WHEN '05' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS MAYO, "
                + "SUM(CASE CMES_CODIGO WHEN '06' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS JUNIO, "
                + "SUM(CASE CMES_CODIGO WHEN '07' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS JULIO, "
                + "SUM(CASE CMES_CODIGO WHEN '08' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS AGOSTO, "
                + "SUM(CASE CMES_CODIGO WHEN '09' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS SETIEMBRE, "
                + "SUM(CASE CMES_CODIGO WHEN '10' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS OCTUBRE, "
                + "SUM(CASE CMES_CODIGO WHEN '11' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS NOVIEMBRE, "
                + "SUM(CASE CMES_CODIGO WHEN '12' THEN NINFORME_DISPONIBILIDAD_MENSUA ELSE 0 END) AS DICIEMBRE  "
                + "FROM SIPE_INFORME_DISPONIBILIDAD_DE DD INNER JOIN SIPE_INFORME_DISPONIBILIDAD_ME DM ON ("
                + "DD.CPERIODO_CODIGO=DM.CPERIODO_CODIGO AND "
                + "DD.CINFORME_DISPONIBILIDAD_CODIGO=DM.CINFORME_DISPONIBILIDAD_CODIGO AND "
                + "DD.NINFORME_DISPONIBILIDAD_DETAL=DM.NINFORME_DISPONIBILIDAD_DETAL) WHERE "
                + "DD.CPERIODO_CODIGO=? AND "
                + "DD.NPRESUPUESTO_CODIGO=? AND "
                + "DD.CINFORME_DISPONIBILIDAD_CODIGO=? "
                + "GROUP BY DD.NINFORME_DISPONIBILIDAD_DETAL, DD.CPERIODO_CODIGO, DD.CUNIDAD_OPERATIVA_CODIGO, CUNIDAD_CODIGO,"
                + "NRESOLUCION_CARGO, CDEPENDENCIA_CARGO, CSECUENCIA_FUNCIONAL_CARGO, CMETA_OPERATIVA_CARGO, VCADENA_GASTO_CARGO, "
                + "CDEPENDENCIA_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO, NPRESUPUESTO_CODIGO, CMETA_OPERATIVA_CODIGO, VCADENA_GASTO_CODIGO, "
                + "DD.CINFORME_DISPONIBILIDAD_CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDisponibilidad.getPeriodo());
            objPreparedStatement.setInt(2, objBeanDisponibilidad.getPresupuesto());
            objPreparedStatement.setString(3, objBeanDisponibilidad.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("RESOLUCION_CARGO") + "+++"
                        + objResultSet.getString("DEPENDENCIA_CARGO") + "+++"
                        + objResultSet.getString("SECUENCIA_FUNCIONAL_CARGO") + "+++"
                        + objResultSet.getString("TAREA_CARGO") + "+++"
                        + objResultSet.getString("CADENA_GASTO_CARGO") + "+++"
                        + objResultSet.getString("UNIDAD") + "+++"
                        + objResultSet.getString("DEPENDENCIA") + "+++"
                        + objResultSet.getString("SECUENCIA_FUNCIONAL") + "+++"
                        + objResultSet.getString("TAREA") + "+++"
                        + objResultSet.getString("CADENA_GASTO") + "+++"
                        + objResultSet.getDouble("IMPORTE") + "+++"
                        + objResultSet.getDouble("ENERO") + "+++"
                        + objResultSet.getDouble("FEBRERO") + "+++"
                        + objResultSet.getDouble("MARZO") + "+++"
                        + objResultSet.getDouble("ABRIL") + "+++"
                        + objResultSet.getDouble("MAYO") + "+++"
                        + objResultSet.getDouble("JUNIO") + "+++"
                        + objResultSet.getDouble("JULIO") + "+++"
                        + objResultSet.getDouble("AGOSTO") + "+++"
                        + objResultSet.getDouble("SETIEMBRE") + "+++"
                        + objResultSet.getDouble("OCTUBRE") + "+++"
                        + objResultSet.getDouble("NOVIEMBRE") + "+++"
                        + objResultSet.getDouble("DICIEMBRE");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDetalleDisponibilidadPresupuestal(objBeanDisponibilidad) : " + e.getMessage());
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
    public BeanDisponibilidadPresupuestal getDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario) {
        sql = "SELECT CINFORME_DISPONIBILIDAD_TIPO, VINFORME_DISPONIBILIDAD_OFICIO, "
                + "VINFORME_DISPONIBILIDAD_CONCEP, DFECHA_EMISION "
                + "FROM SIPE_INFORME_DISPONIBILIDAD WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CINFORME_DISPONIBILIDAD_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDisponibilidad.getPeriodo());
            objPreparedStatement.setInt(2, objBeanDisponibilidad.getPresupuesto());
            objPreparedStatement.setString(3, objBeanDisponibilidad.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanDisponibilidad.setTipo(objResultSet.getString("CINFORME_DISPONIBILIDAD_TIPO"));
                objBeanDisponibilidad.setOficio(objResultSet.getString("VINFORME_DISPONIBILIDAD_OFICIO"));
                objBeanDisponibilidad.setConcepto(objResultSet.getString("VINFORME_DISPONIBILIDAD_CONCEP"));
                objBeanDisponibilidad.setFecha(objResultSet.getDate("DFECHA_EMISION"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getDisponibilidadPresupuestal(objBeanDisponibilidad, usuario) : " + e.getMessage());
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
        return objBeanDisponibilidad;
    }

    @Override
    public String getCodigoDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario) {
        String result = "";
        sql = "SELECT NVL(LPAD(MAX(CINFORME_DISPONIBILIDAD_CODIGO)+1,4,0),'0001') AS CODIGO "
                + "FROM SIPE_INFORME_DISPONIBILIDAD WHERE "
                + "CPERIODO_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDisponibilidad.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("CODIGO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCodigoDisponibilidadPresupuestal(objBeanDisponibilidad, usuario) : " + e.getMessage());
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
        return result;
    }

    @Override
    public int iduDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario) {
        sql = "{CALL SP_IDU_INFORME_DISPONIBILIDAD(?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanDisponibilidad.getPeriodo());
            cs.setString(2, objBeanDisponibilidad.getUnidadOperativa());
            cs.setInt(3, objBeanDisponibilidad.getPresupuesto());
            cs.setString(4, objBeanDisponibilidad.getMes());
            cs.setString(5, objBeanDisponibilidad.getCodigo());
            cs.setString(6, objBeanDisponibilidad.getTipo());
            cs.setString(7, objBeanDisponibilidad.getOficio());
            cs.setString(8, objBeanDisponibilidad.getConcepto());
            cs.setDate(9, objBeanDisponibilidad.getFecha());
            cs.setString(10, objBeanDisponibilidad.getSecuencia());
            cs.setString(11, usuario);
            cs.setString(12, objBeanDisponibilidad.getMode().toUpperCase());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener iduDisponibilidadPresupuestal(objBeanDisponibilidad, usuario) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_INFORME_DISPONIBILIDAD");
            objBnMsgerr.setTipo(objBeanDisponibilidad.getMode());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduDisponibilidadPresupuestalDetalle(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario) {
        sql = "{CALL SP_IDU_INFORME_DISPO_DETALLE(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanDisponibilidad.getPeriodo());
            cs.setString(2, objBeanDisponibilidad.getUnidadOperativa());
            cs.setString(3, objBeanDisponibilidad.getCodigo());
            cs.setInt(4, objBeanDisponibilidad.getDetalle());
            cs.setInt(5, objBeanDisponibilidad.getPresupuesto());
            cs.setInt(6, objBeanDisponibilidad.getResolucion());
            cs.setString(7, objBeanDisponibilidad.getDependenciaCargo());
            cs.setString(8, objBeanDisponibilidad.getSecuenciaFuncionalCargo());
            cs.setString(9, objBeanDisponibilidad.getTareaCargo());
            cs.setString(10, objBeanDisponibilidad.getCadenaGastoCargo());
            cs.setString(11, objBeanDisponibilidad.getUnidad());
            cs.setString(12, objBeanDisponibilidad.getDependencia());
            cs.setString(13, objBeanDisponibilidad.getSecuencia());
            cs.setString(14, objBeanDisponibilidad.getTarea());
            cs.setString(15, objBeanDisponibilidad.getCadenaGasto());
            cs.setDouble(16, objBeanDisponibilidad.getImporte());
            cs.setDouble(17, 0.0);
            cs.setDouble(18, 0.0);
            cs.setDouble(19, 0.0);
            cs.setDouble(20, 0.0);
            cs.setDouble(21, 0.0);
            cs.setDouble(22, 0.0);
            cs.setDouble(23, 0.0);
            cs.setDouble(24, 0.0);
            cs.setDouble(25, 0.0);
            cs.setDouble(26, 0.0);
            cs.setDouble(27, 0.0);
            cs.setDouble(28, 0.0);
            cs.setString(29, usuario);
            cs.setString(30, objBeanDisponibilidad.getMode().toUpperCase());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener iduDisponibilidadPresupuestalDetalle(objBeanDisponibilidad, usuario) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_INFORME_DISPONIBILIDAD");
            objBnMsgerr.setTipo(objBeanDisponibilidad.getMode());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduEnvioDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario) {
        sql = "{CALL SP_INS_NOTA_INFORME(?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanDisponibilidad.getPeriodo());
            cs.setString(2, objBeanDisponibilidad.getCodigo());
            cs.setString(3, usuario);
            cs.setString(4, objBeanDisponibilidad.getMode().toUpperCase());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener iduEnvioDisponibilidadPresupuestal(objBeanDisponibilidad, usuario) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_INFORME_DISPONIBILIDAD");
            objBnMsgerr.setTipo(objBeanDisponibilidad.getMode());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }
}
