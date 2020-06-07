/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanCalendarioGastos;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.CalendarioGastosDAO;
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
public class CalendarioGastosDAOImpl implements CalendarioGastosDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanCalendarioGastos objBnCalendario;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public CalendarioGastosDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaCalendarioGastos(BeanCalendarioGastos objBeanCalendarioGastos, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT COMEOP||'-'||SECFUN||'-'||TIPPAU||'-'||RESOLUCION||'-'||TRIM(CODGEN) AS CODIGO, "
                + "COMEOP||':'||UTIL_NEW.FUN_NTAREA(COMEOP) AS TAREA, "
                + "SUM(PIA) AS PIA, SUM(PROGRAMADO) AS PIM, SUM(PCA) AS PCA, "
                + "SUM(CERTIFICADO) AS CERTIFICACION_ANUAL, "
                + "SUM(COMP_ANUAL) AS COMPROMISO, "
                + "SUM(EJECUTADO) AS MENSUAL, "
                + "TIPPAU||':'||UTIL_NEW.FUN_DESTIP(TIPPAU, COPPTO) AS TIPO_CALENDARIO, "
                + "TRIM(CODGEN)||':'||UTIL_NEW.FUN_NOMGEN(TRIM(CODGEN)) GENERICA, "
                + "SECFUN||':'||UTIL_NEW.FUN_CODIGO_COCAFU(CODPER, COPPTO, SECFUN) AS SECUENCIA_FUNCIONAL, "
                + "RESOLUCION||':'||UTIL.FUN_DESCRIPCION_RESOLUCION(CODPER, RESOLUCION) AS RESOLUCION, "
                + "UTIL_NEW.FUN_PROGRAMA_SECFUN(CODPER, COPPTO, SECFUN) AS PROGRAMA, "
                + "UTIL_NEW.FUN_PRODUCTO_SECFUN(CODPER, COPPTO, SECFUN) PRODUCTO, "
                + "UTIL_NEW.FUN_ACTIVIDAD_SECFUN(CODPER, COPPTO, SECFUN) ACTIVIDAD "
                + "FROM V_PRG_EJE_ANUAL_RESOL WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? "
                + "GROUP BY CODPER, COPPTO, COUUOO, COMEOP, SECFUN, TIPPAU, RESOLUCION, TRIM(CODGEN) "
                + "ORDER BY RESOLUCION, TIPPAU, COMEOP, TRIM(CODGEN)";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCalendarioGastos.getPeriodo());
            objPreparedStatement.setString(2, objBeanCalendarioGastos.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanCalendarioGastos.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnCalendario = new BeanCalendarioGastos();
                objBnCalendario.setCodigo(objResultSet.getString("CODIGO"));
                objBnCalendario.setTarea(objResultSet.getString("TAREA"));
                objBnCalendario.setProgramado(objResultSet.getDouble("PIA"));
                objBnCalendario.setImporte(objResultSet.getDouble("PIM"));
                objBnCalendario.setEnero(objResultSet.getDouble("CERTIFICACION_ANUAL"));
                objBnCalendario.setFebrero(objResultSet.getDouble("COMPROMISO"));
                objBnCalendario.setMarzo(objResultSet.getDouble("MENSUAL"));
                objBnCalendario.setAbril(objResultSet.getDouble("PCA"));
                objBnCalendario.setTipoCalendario(objResultSet.getString("TIPO_CALENDARIO"));
                objBnCalendario.setGenericaGasto(objResultSet.getString("GENERICA"));
                objBnCalendario.setSecuenciaFuncional(objResultSet.getString("SECUENCIA_FUNCIONAL"));
                objBnCalendario.setResolucion(objResultSet.getString("RESOLUCION"));
                objBnCalendario.setCategoriaPresupuestal(objResultSet.getString("PROGRAMA"));
                objBnCalendario.setProducto(objResultSet.getString("PRODUCTO"));
                objBnCalendario.setActividad(objResultSet.getString("ACTIVIDAD"));
                lista.add(objBnCalendario);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaCalendarioGastos(objBeanCalendarioGastos) : " + e.getMessage());
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
    public List getListaCalendarioGastosDetalle(BeanCalendarioGastos objBeanCalendarioGastos, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT COMEOP||'-'||SECFUN||'-'||TIPPAU||'-'||NCODIGO_RESOLUCION||'-'||TRIM(CODGEN) AS CODIGO, "
                + "CODDEP||':'||UTIL_NEW.FUN_ABRDEP(COUUOO, CODDEP) AS DEPENDENCIA, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(COCAGA) AS CADENA_GASTO,  "
                + "SUM(PIM) AS IMPORTE, "
                + "SUM(CASE MESPER WHEN '01' THEN PIM ELSE 0 END) AS ENERO, "
                + "SUM(CASE MESPER WHEN '02' THEN PIM ELSE 0 END) AS FEBRERO, "
                + "SUM(CASE MESPER WHEN '03' THEN PIM ELSE 0 END) AS MARZO, "
                + "SUM(CASE MESPER WHEN '04' THEN PIM ELSE 0 END) AS ABRIL, "
                + "SUM(CASE MESPER WHEN '05' THEN PIM ELSE 0 END) AS MAYO, "
                + "SUM(CASE MESPER WHEN '06' THEN PIM ELSE 0 END) AS JUNIO, "
                + "SUM(CASE MESPER WHEN '07' THEN PIM ELSE 0 END) AS JULIO, "
                + "SUM(CASE MESPER WHEN '08' THEN PIM ELSE 0 END) AS AGOSTO, "
                + "SUM(CASE MESPER WHEN '09' THEN PIM ELSE 0 END) AS SETIEMBRE, "
                + "SUM(CASE MESPER WHEN '10' THEN PIM ELSE 0 END) AS OCTUBRE, "
                + "SUM(CASE MESPER WHEN '11' THEN PIM ELSE 0 END) AS NOVIEMBRE, "
                + "SUM(CASE MESPER WHEN '12' THEN PIM ELSE 0 END) AS DICIEMBRE "
                + "FROM V_MODEPA WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? "
                + "GROUP BY CODPER, COUUOO, COPPTO, COMEOP, SECFUN, TIPPAU, NCODIGO_RESOLUCION, COCAGA, CODDEP, TRIM(CODGEN) "
                + "ORDER BY CODDEP, COCAGA";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCalendarioGastos.getPeriodo());
            objPreparedStatement.setString(2, objBeanCalendarioGastos.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanCalendarioGastos.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnCalendario = new BeanCalendarioGastos();
                objBnCalendario.setCodigo(objResultSet.getString("CODIGO"));
                objBnCalendario.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnCalendario.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnCalendario.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnCalendario.setEnero(objResultSet.getDouble("ENERO"));
                objBnCalendario.setFebrero(objResultSet.getDouble("FEBRERO"));
                objBnCalendario.setMarzo(objResultSet.getDouble("MARZO"));
                objBnCalendario.setAbril(objResultSet.getDouble("ABRIL"));
                objBnCalendario.setMayo(objResultSet.getDouble("MAYO"));
                objBnCalendario.setJunio(objResultSet.getDouble("JUNIO"));
                objBnCalendario.setJulio(objResultSet.getDouble("JULIO"));
                objBnCalendario.setAgosto(objResultSet.getDouble("AGOSTO"));
                objBnCalendario.setSetiembre(objResultSet.getDouble("SETIEMBRE"));
                objBnCalendario.setOctubre(objResultSet.getDouble("OCTUBRE"));
                objBnCalendario.setNoviembre(objResultSet.getDouble("NOVIEMBRE"));
                objBnCalendario.setDiciembre(objResultSet.getDouble("DICIEMBRE"));
                lista.add(objBnCalendario);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaCalendarioGastosDetalle(objBeanCalendarioGastos) : " + e.getMessage());
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
    public ArrayList getListaCalendarioGastoDetalle(BeanCalendarioGastos objBeanCalendarioGastos, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT "
                + "CODDEP||':'||UTIL_NEW.FUN_ABRDEP(COUUOO, CODDEP) AS DEPENDENCIA, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(COCAGA) AS CADENA_GASTO, "
                + "SUM(PIM) AS IMPORTE, "
                + "SUM(CASE MESPER WHEN '01' THEN PIM ELSE 0 END) AS ENERO, "
                + "SUM(CASE MESPER WHEN '02' THEN PIM ELSE 0 END) AS FEBRERO, "
                + "SUM(CASE MESPER WHEN '03' THEN PIM ELSE 0 END) AS MARZO, "
                + "SUM(CASE MESPER WHEN '04' THEN PIM ELSE 0 END) AS ABRIL, "
                + "SUM(CASE MESPER WHEN '05' THEN PIM ELSE 0 END) AS MAYO, "
                + "SUM(CASE MESPER WHEN '06' THEN PIM ELSE 0 END) AS JUNIO, "
                + "SUM(CASE MESPER WHEN '07' THEN PIM ELSE 0 END) AS JULIO, "
                + "SUM(CASE MESPER WHEN '08' THEN PIM ELSE 0 END) AS AGOSTO, "
                + "SUM(CASE MESPER WHEN '09' THEN PIM ELSE 0 END) AS SETIEMBRE, "
                + "SUM(CASE MESPER WHEN '10' THEN PIM ELSE 0 END) AS OCTUBRE, "
                + "SUM(CASE MESPER WHEN '11' THEN PIM ELSE 0 END) AS NOVIEMBRE, "
                + "SUM(CASE MESPER WHEN '12' THEN PIM ELSE 0 END) AS DICIEMBRE "
                + "FROM V_MODEPA WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP||'-'||SECFUN||'-'||TIPPAU||'-'||NCODIGO_RESOLUCION||'-'||TRIM(CODGEN)=? "
                + "GROUP BY COUUOO, CODDEP, COCAGA "
                + "ORDER BY CODDEP, COCAGA";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanCalendarioGastos.getPeriodo());
            objPreparedStatement.setString(2, objBeanCalendarioGastos.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanCalendarioGastos.getPresupuesto());
            objPreparedStatement.setString(4, objBeanCalendarioGastos.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("DEPENDENCIA") + "+++"
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
            System.out.println("Error al obtener getListaCalendarioGastoDetalle(BeanCertificadoCreditoPresupuestal) : " + e.getMessage());
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
    public int iduCalendarioGastoDetalle(BeanCalendarioGastos objBeanCalendarioGastos, String usuario) {
        sql = "{CALL SP_ACTUALIZAR_DETPAU(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanCalendarioGastos.getPeriodo());
            cs.setInt(2, objBeanCalendarioGastos.getPresupuesto());
            cs.setString(3, objBeanCalendarioGastos.getUnidadOperativa());
            cs.setString(4, objBeanCalendarioGastos.getGenericaGasto());
            cs.setString(5, objBeanCalendarioGastos.getTarea());
            cs.setDouble(6, objBeanCalendarioGastos.getEnero());
            cs.setDouble(7, objBeanCalendarioGastos.getFebrero());
            cs.setDouble(8, objBeanCalendarioGastos.getMarzo());
            cs.setDouble(9, objBeanCalendarioGastos.getAbril());
            cs.setDouble(10, objBeanCalendarioGastos.getMayo());
            cs.setDouble(11, objBeanCalendarioGastos.getJunio());
            cs.setDouble(12, objBeanCalendarioGastos.getJulio());
            cs.setDouble(13, objBeanCalendarioGastos.getAgosto());
            cs.setDouble(14, objBeanCalendarioGastos.getSetiembre());
            cs.setDouble(15, objBeanCalendarioGastos.getOctubre());
            cs.setDouble(16, objBeanCalendarioGastos.getNoviembre());
            cs.setDouble(17, objBeanCalendarioGastos.getDiciembre());
            cs.setString(18, usuario);
            cs.setString(19, objBeanCalendarioGastos.getTipoCalendario());
            cs.setDouble(20, objBeanCalendarioGastos.getImporte());
            cs.setString(21, objBeanCalendarioGastos.getSecuenciaFuncional());
            cs.setString(22, objBeanCalendarioGastos.getDependencia());
            cs.setString(23, objBeanCalendarioGastos.getCadenaGasto());
            cs.setString(24, objBeanCalendarioGastos.getResolucion());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener iduCalendarioGastoDetalle(objBeanDisponibilidad, " + usuario + ") : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("MODEPA");
            objBnMsgerr.setTipo(objBeanCalendarioGastos.getMode());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }
}
