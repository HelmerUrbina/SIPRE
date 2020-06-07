/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanProgramacionPresupuestal;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.ProgramacionMultianualDAO;
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
public class ProgramacionMultianualDAOImpl implements ProgramacionMultianualDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanProgramacionPresupuestal objBnProgramacion;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ProgramacionMultianualDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaProgramacionMultianual(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CTAREA_CODIGO||NTIPO_CALENDARIO_CODIGO||CDISTRITO_CODIGO AS CODIGO, CTAREA_CODIGO||'-'||UTIL_NEW.FUN_NTAREA(CTAREA_CODIGO) AS TAREA, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END) AS IMPORTE_A, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+1) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END) AS IMPORTE_B, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+2) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END) AS IMPORTE_C, "
                + "OPRE_NEW.FUN_IMPORTE_PROGRA_MULTI_DETAL(CANIO_REGISTRO, TO_NUMBER(CANIO_REGISTRO), CUNIDAD_OPERATIVA_CODIGO, NPRESUPUESTO_CODIGO, NTIPO_CALENDARIO_CODIGO, CTAREA_CODIGO, CDISTRITO_CODIGO) AS DETALLE_A, "
                + "OPRE_NEW.FUN_IMPORTE_PROGRA_MULTI_DETAL(CANIO_REGISTRO, TO_NUMBER(CANIO_REGISTRO+1), CUNIDAD_OPERATIVA_CODIGO, NPRESUPUESTO_CODIGO, NTIPO_CALENDARIO_CODIGO, CTAREA_CODIGO, CDISTRITO_CODIGO) AS DETALLE_B, "
                + "OPRE_NEW.FUN_IMPORTE_PROGRA_MULTI_DETAL(CANIO_REGISTRO, TO_NUMBER(CANIO_REGISTRO+2), CUNIDAD_OPERATIVA_CODIGO, NPRESUPUESTO_CODIGO, NTIPO_CALENDARIO_CODIGO, CTAREA_CODIGO, CDISTRITO_CODIGO) AS DETALLE_C, "
                + "CASE CESTADO_CODIGO WHEN 'PE' THEN 'PENDIENTE' WHEN 'CE' THEN 'CERRADO' ELSE 'VERIFICAR' END AS ESTADO,"
                + "UTIL_NEW.FUN_DESTIP(NTIPO_CALENDARIO_CODIGO, NPRESUPUESTO_CODIGO) AS TIPO_CALENDARIO, "
                + "UTIL_NEW.FUN_CAT_PRESUPUESTAL_TAREA_PRO(CANIO_REGISTRO, NPRESUPUESTO_CODIGO, CTAREA_CODIGO) AS CAT_PRESUPUESTAL, "
                + "UTIL_NEW.FUN_PRODUCTO_TAREA_PROG(CANIO_REGISTRO, NPRESUPUESTO_CODIGO, CTAREA_CODIGO) AS PRODUCTO, "
                + "UTIL_NEW.FUN_ACTIVIDAD_TAREA_PROG(CANIO_REGISTRO, NPRESUPUESTO_CODIGO, CTAREA_CODIGO) AS ACTIVIDAD, "
                + "UTIL_NEW.FUN_DESUBI(CDISTRITO_CODIGO) AS UBIGEO "
                + "FROM SIPE_PROGRAMACION_MULTIANUAL WHERE "
                + "CANIO_REGISTRO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? "
                + "GROUP BY CANIO_REGISTRO, CUNIDAD_OPERATIVA_CODIGO, NPRESUPUESTO_CODIGO, NTIPO_CALENDARIO_CODIGO, CTAREA_CODIGO, CESTADO_CODIGO, CDISTRITO_CODIGO "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setString(2, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanProgramacion.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnProgramacion = new BeanProgramacionPresupuestal();
                objBnProgramacion.setCodigo(objResultSet.getString("CODIGO"));
                objBnProgramacion.setTarea(objResultSet.getString("TAREA"));
                objBnProgramacion.setEnero(objResultSet.getDouble("IMPORTE_A"));
                objBnProgramacion.setFebrero(objResultSet.getDouble("IMPORTE_B"));
                objBnProgramacion.setMarzo(objResultSet.getDouble("IMPORTE_C"));
                objBnProgramacion.setAbril(objResultSet.getDouble("DETALLE_A"));
                objBnProgramacion.setMayo(objResultSet.getDouble("DETALLE_B"));
                objBnProgramacion.setJunio(objResultSet.getDouble("DETALLE_C"));
                objBnProgramacion.setEstado(objResultSet.getString("ESTADO"));
                objBnProgramacion.setTipoCalendario(objResultSet.getString("TIPO_CALENDARIO"));
                objBnProgramacion.setCategoriaPresupuestal(objResultSet.getString("CAT_PRESUPUESTAL"));
                objBnProgramacion.setProducto(objResultSet.getString("PRODUCTO"));
                objBnProgramacion.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnProgramacion.setDistrito(objResultSet.getString("UBIGEO"));
                lista.add(objBnProgramacion);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaProgramacionMultianual(objBeanProgramacion) : " + e.getMessage());
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
    public List getListaProgramacionMultianualDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CTAREA_CODIGO||NTIPO_CALENDARIO_CODIGO||CDISTRITO_CODIGO AS CODIGO, "
                + "VCADENA_GASTO_CODIGO||'-'||UTIL_NEW.FUN_NOCLAS(VCADENA_GASTO_CODIGO) AS CADENA_GASTO, "
                + "CDEPENDENCIA_CODIGO||'-'||UTIL_NEW.FUN_ABRDEP(CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "SUM(NPROGRAMACION_MULTI_IMPORTE) AS ASIGNADO, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO) THEN NPROGRAMACION_MULTI_IMPORTE ELSE 0 END) AS DATO_A, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+1) THEN NPROGRAMACION_MULTI_IMPORTE ELSE 0 END) AS DATO_B, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+2) THEN NPROGRAMACION_MULTI_IMPORTE ELSE 0 END) AS DATO_C "
                + "FROM SIPE_PROGRAMACION_MULTI_DETALL WHERE "
                + "CANIO_REGISTRO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? "
                + "GROUP BY CUNIDAD_OPERATIVA_CODIGO, CTAREA_CODIGO, NTIPO_CALENDARIO_CODIGO, CDISTRITO_CODIGO, CDEPENDENCIA_CODIGO, VCADENA_GASTO_CODIGO "
                + "ORDER BY CDEPENDENCIA_CODIGO, CADENA_GASTO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setString(2, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanProgramacion.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnProgramacion = new BeanProgramacionPresupuestal();
                objBnProgramacion.setCodigo(objResultSet.getString("CODIGO"));
                objBnProgramacion.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnProgramacion.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnProgramacion.setImporte(objResultSet.getDouble("ASIGNADO"));
                objBnProgramacion.setEnero(objResultSet.getDouble("DATO_A"));
                objBnProgramacion.setFebrero(objResultSet.getDouble("DATO_B"));
                objBnProgramacion.setMarzo(objResultSet.getDouble("DATO_C"));
                lista.add(objBnProgramacion);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaProgramacionMultianualDetalle(objBeanProgramacion) : " + e.getMessage());
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
    public ArrayList getDatosProgramacionMultianualDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT VCADENA_GASTO_CODIGO||':'||UTIL_NEW.FUN_NOCLAS(VCADENA_GASTO_CODIGO) AS CADENA_GASTO,"
                + "CDEPENDENCIA_CODIGO||':'||UTIL_NEW.FUN_ABRDEP(CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "SUM(NPROGRAMACION_MULTI_IMPORTE) AS ASIGNADO, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO) THEN NPROGRAMACION_MULTI_IMPORTE ELSE 0 END) AS DATO_A, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+1) THEN NPROGRAMACION_MULTI_IMPORTE ELSE 0 END) AS DATO_B, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+2) THEN NPROGRAMACION_MULTI_IMPORTE ELSE 0 END) AS DATO_C "
                + "FROM SIPE_PROGRAMACION_MULTI_DETALL WHERE "
                + "CANIO_REGISTRO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CTAREA_CODIGO||NTIPO_CALENDARIO_CODIGO||CDISTRITO_CODIGO=? "
                + "GROUP BY CUNIDAD_OPERATIVA_CODIGO, CTAREA_CODIGO, CDEPENDENCIA_CODIGO, VCADENA_GASTO_CODIGO "
                + "ORDER BY CDEPENDENCIA_CODIGO, CADENA_GASTO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setString(2, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanProgramacion.getPresupuesto());
            objPreparedStatement.setString(4, objBeanProgramacion.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CADENA_GASTO") + "+++"
                        + objResultSet.getString("DEPENDENCIA") + "+++"
                        + objResultSet.getDouble("ASIGNADO") + "+++"
                        + objResultSet.getDouble("DATO_A") + "+++"
                        + objResultSet.getDouble("DATO_B") + "+++"
                        + objResultSet.getDouble("DATO_C");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getDatosProgramacionMultianualDetalle(objBeanProgramacion) : " + e.getMessage());
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
    public BeanProgramacionPresupuestal getProgramadoMultianual(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        sql = "SELECT CDEPARTAMENTO_CODIGO, "
                + "CPROVINCIA_CODIGO, UTIL_NEW.FUN_NOMBRE_PROVINCIA(CDEPARTAMENTO_CODIGO, CPROVINCIA_CODIGO) AS PROVINCIA,"
                + "CDISTRITO_CODIGO, UTIL_NEW.FUN_NOMBRE_UBIGEO(CDISTRITO_CODIGO) AS UBIGEO, NPROG_MULTIANUAL_PORCENTAJE, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END) AS IMPORTE_A, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+1) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END) AS IMPORTE_B, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+2) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END) AS IMPORTE_C "
                + "FROM SIPE_PROGRAMACION_MULTIANUAL WHERE "
                + "CANIO_REGISTRO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CTAREA_CODIGO||NTIPO_CALENDARIO_CODIGO||CDISTRITO_CODIGO=? "
                + "GROUP BY CDEPARTAMENTO_CODIGO, CPROVINCIA_CODIGO, CDISTRITO_CODIGO, NPROG_MULTIANUAL_PORCENTAJE";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setString(2, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanProgramacion.getPresupuesto());
            objPreparedStatement.setString(4, objBeanProgramacion.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanProgramacion.setDepartamento(objResultSet.getString("CDEPARTAMENTO_CODIGO"));
                objBeanProgramacion.setProvincia(objResultSet.getString("CPROVINCIA_CODIGO"));
                objBeanProgramacion.setEstado(objResultSet.getString("PROVINCIA"));
                objBeanProgramacion.setDistrito(objResultSet.getString("CDISTRITO_CODIGO"));
                objBeanProgramacion.setUnidadMedida(objResultSet.getString("UBIGEO"));
                objBeanProgramacion.setProgramado(objResultSet.getDouble("NPROG_MULTIANUAL_PORCENTAJE"));
                objBeanProgramacion.setEnero(objResultSet.getDouble("IMPORTE_A"));
                objBeanProgramacion.setFebrero(objResultSet.getDouble("IMPORTE_B"));
                objBeanProgramacion.setMarzo(objResultSet.getDouble("IMPORTE_C"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getProgramadoMultianual(objBeanProgramacion) : " + e.getMessage());
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
        return objBeanProgramacion;
    }

    @Override
    public BeanProgramacionPresupuestal getProgramadoMultianualDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        sql = "SELECT CTAREA_CODIGO||'-'||UTIL_NEW.FUN_NTAREA(CTAREA_CODIGO) AS TAREA, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END) AS IMPORTE_A, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+1) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END) AS IMPORTE_B, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+2) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END) AS IMPORTE_C "
                + "FROM SIPE_PROGRAMACION_MULTIANUAL WHERE "
                + "CANIO_REGISTRO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CTAREA_CODIGO||NTIPO_CALENDARIO_CODIGO||CDISTRITO_CODIGO=? "
                + "GROUP BY CTAREA_CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setString(2, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanProgramacion.getPresupuesto());
            objPreparedStatement.setString(4, objBeanProgramacion.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanProgramacion.setGenericaGasto(objResultSet.getString("TAREA"));
                objBeanProgramacion.setEnero(objResultSet.getDouble("IMPORTE_A"));
                objBeanProgramacion.setFebrero(objResultSet.getDouble("IMPORTE_B"));
                objBeanProgramacion.setMarzo(objResultSet.getDouble("IMPORTE_C"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getProgramadoMultianualDetalle(objBeanProgramacion) : " + e.getMessage());
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
        return objBeanProgramacion;

    }

    @Override
    public BeanProgramacionPresupuestal getProgramadoMultianualMetaFisica(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        sql = "SELECT CTAREA_CODIGO||'-'||UTIL_NEW.FUN_NTAREA(CTAREA_CODIGO) AS TAREA, "
                + "UTIL_NEW.FUN_NOUNME_TAPAIN(CTAREA_CODIGO) AS UNIDAD_MEDIDA, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO) THEN NPROG_MULTIANUAL_META_FISICA ELSE 0 END) AS META_A, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+1) THEN NPROG_MULTIANUAL_META_FISICA ELSE 0 END) AS META_B, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+2) THEN NPROG_MULTIANUAL_META_FISICA ELSE 0 END) AS META_C "
                + "FROM SIPE_PROGRAMACION_MULTIANUAL WHERE "
                + "CANIO_REGISTRO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CTAREA_CODIGO||NTIPO_CALENDARIO_CODIGO||CDISTRITO_CODIGO=? "
                + "GROUP BY CTAREA_CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setString(2, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanProgramacion.getPresupuesto());
            objPreparedStatement.setString(4, objBeanProgramacion.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanProgramacion.setGenericaGasto(objResultSet.getString("TAREA"));
                objBeanProgramacion.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBeanProgramacion.setEnero(objResultSet.getDouble("META_A"));
                objBeanProgramacion.setFebrero(objResultSet.getDouble("META_B"));
                objBeanProgramacion.setMarzo(objResultSet.getDouble("META_C"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getProgramadoMultianualMetaFisica(objBeanProgramacion) : " + e.getMessage());
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
        return objBeanProgramacion;
    }

    @Override
    public BeanProgramacionPresupuestal getSaldoUtilidadEnteGenerador(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        sql = "SELECT SUM(UTILIDAD_A-IMPORTE_A) AS SALDO_A, "
                + "SUM(UTILIDAD_B-IMPORTE_B) AS SALDO_B, "
                + "SUM(UTILIDAD_C-IMPORTE_C) AS SALDO_C "
                + "FROM (SELECT "
                + "SUM(ROUND((CASE TO_NUMBER(EG.CPERIODO_CODIGO) WHEN TO_NUMBER(EG.CANIO_REGISTRO) THEN (CASE EI.CTIPO_AFECTACION WHEN 'A' THEN NPROG_MULTI_ENTE_RECAUDACION-(NPROG_MULTI_ENTE_RECAUDACION)*SD_PFE.FUN_IGV(EG.CANIO_REGISTRO)-NPROG_MULTI_ENTE_COSTO ELSE "
                + "NPROG_MULTI_ENTE_RECAUDACION-NPROG_MULTI_ENTE_COSTO END) ELSE 0 END)*(EI.NPORCENTAJE_RDR_UO/100))) AS UTILIDAD_A, "
                + "SUM(ROUND((CASE TO_NUMBER(EG.CPERIODO_CODIGO) WHEN TO_NUMBER(EG.CANIO_REGISTRO+1) THEN (CASE EI.CTIPO_AFECTACION WHEN 'A' THEN NPROG_MULTI_ENTE_RECAUDACION-(NPROG_MULTI_ENTE_RECAUDACION)*SD_PFE.FUN_IGV(EG.CANIO_REGISTRO)-NPROG_MULTI_ENTE_COSTO ELSE "
                + "NPROG_MULTI_ENTE_RECAUDACION-NPROG_MULTI_ENTE_COSTO END) ELSE 0 END)*(EI.NPORCENTAJE_RDR_UO/100))) AS UTILIDAD_B, "
                + "SUM(ROUND((CASE TO_NUMBER(EG.CPERIODO_CODIGO) WHEN TO_NUMBER(EG.CANIO_REGISTRO+2) THEN (CASE EI.CTIPO_AFECTACION WHEN 'A' THEN NPROG_MULTI_ENTE_RECAUDACION-(NPROG_MULTI_ENTE_RECAUDACION)*SD_PFE.FUN_IGV(EG.CANIO_REGISTRO)-NPROG_MULTI_ENTE_COSTO ELSE "
                + "NPROG_MULTI_ENTE_RECAUDACION-NPROG_MULTI_ENTE_COSTO END) ELSE 0 END)*(EI.NPORCENTAJE_RDR_UO/100))) AS UTILIDAD_C, 0 AS IMPORTE_A, 0 AS IMPORTE_B, 0 AS IMPORTE_C "
                + "FROM SIPE_PROGRAMACION_MULTI_ENTE EG LEFT OUTER JOIN SIPE_ESTIMACION_INGRESOS EI ON ("
                + "EI.CPERIODO_CODIGO=EG.CANIO_REGISTRO AND EG.NPRESUPUESTO_CODIGO=EI.NPRESUPUESTO_CODIGO AND EG.NESTIMACION_INGRESO_CODIGO=EI.NESTIMACION_INGRESO_CODIGO) WHERE "
                + "EG.CANIO_REGISTRO=? AND "
                + "EG.CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "EG.NPRESUPUESTO_CODIGO=? AND "
                + "EG.CESTADO_CODIGO='CE' "
                + "UNION "
                + "SELECT 0 AS UTILIDAD_A, 0 AS UTILIDAD_B, 0 AS UTILIDAD_C, "
                + "NVL(SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END),0) AS IMPORTE_A, "
                + "NVL(SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+1) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END),0) AS IMPORTE_B, "
                + "NVL(SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+2) THEN NPROG_MULTIANUAL_IMPORTE ELSE 0 END),0) AS IMPORTE_C "
                + "FROM SIPE_PROGRAMACION_MULTIANUAL WHERE "
                + "CANIO_REGISTRO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CTAREA_CODIGO NOT IN ('0001','0848','0849','0850','0851','0852'))";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setString(2, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanProgramacion.getPresupuesto());
            objPreparedStatement.setString(4, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setString(5, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setInt(6, objBeanProgramacion.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanProgramacion.setEnero(objResultSet.getDouble("SALDO_A"));
                objBeanProgramacion.setFebrero(objResultSet.getDouble("SALDO_B"));
                objBeanProgramacion.setMarzo(objResultSet.getDouble("SALDO_C"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getSaldoUtilidadEnteGenerador(objBeanProgramacion) : " + e.getMessage());
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
        return objBeanProgramacion;
    }

    @Override
    public BeanProgramacionPresupuestal getSaldoFuerzaOperativa(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        /* sql = "SELECT SUM(IMPORTE_A-DATO_A) AS SALDO_A, SUM(IMPORTE_B-DATO_B) AS SALDO_B, SUM(IMPORTE_C-DATO_C) AS SALDO_C "
                + "FROM (SELECT  "
                + "SD_PFE.FUN_MONTO_FUERZA_OPERATIVA_DEP('" + objBeanProgramacion.getPeriodo() + "', '" + objBeanProgramacion.getUnidadOperativa() + "', '" + objBeanProgramacion.getDependencia() + "') AS IMPORTE_A, "
                + "SD_PFE.FUN_MONTO_FUERZA_OPERATIVA_DEP('" + objBeanProgramacion.getPeriodo() + "', '" + objBeanProgramacion.getUnidadOperativa() + "', '" + objBeanProgramacion.getDependencia() + "') AS IMPORTE_B, "
                + "SD_PFE.FUN_MONTO_FUERZA_OPERATIVA_DEP('" + objBeanProgramacion.getPeriodo() + "', '" + objBeanProgramacion.getUnidadOperativa() + "', '" + objBeanProgramacion.getDependencia() + "') AS IMPORTE_C, 0 DATO_A, 0 DATO_B, 0 DATO_C FROM DUAL "
                + /*+ "UNION ALL "
                + "SELECT 0 IMPORTE_A, 0 IMPORTE_B, 0 IMPORTE_C, "
                + "NVL(SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO) THEN NPROGRAMACION_MULTI_IMPORTE ELSE 0 END),0) AS DATO_A, "
                + "NVL(SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+1) THEN NPROGRAMACION_MULTI_IMPORTE ELSE 0 END),0) AS DATO_B, "
                + "NVL(SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+2) THEN NPROGRAMACION_MULTI_IMPORTE ELSE 0 END),0) AS DATO_C "
                + "FROM SIPE_PROGRAMACION_MULTI_DETALL WHERE "
                + "CANIO_REGISTRO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CDEPENDENCIA_CODIGO=? AND "
                + "CTAREA_CODIGO  IN ('0013','0019')*/
        sql = "SELECT  "
                + "SD_PFE.FUN_MONTO_FUERZA_OPERATIVA_DEP('" + objBeanProgramacion.getPeriodo() + "', '" + objBeanProgramacion.getUnidadOperativa() + "', '" + objBeanProgramacion.getDependencia() + "') AS IMPORTE_A, "
                + "SD_PFE.FUN_MONTO_FUERZA_OPERATIVA_DEP('" + objBeanProgramacion.getPeriodo() + "', '" + objBeanProgramacion.getUnidadOperativa() + "', '" + objBeanProgramacion.getDependencia() + "') AS IMPORTE_B, "
                + "SD_PFE.FUN_MONTO_FUERZA_OPERATIVA_DEP('" + objBeanProgramacion.getPeriodo() + "', '" + objBeanProgramacion.getUnidadOperativa() + "', '" + objBeanProgramacion.getDependencia() + "') AS IMPORTE_C "
                + "FROM DUAL ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            /*objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setString(2, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanProgramacion.getPresupuesto());
            objPreparedStatement.setString(4, objBeanProgramacion.getDependencia());
             *///objPreparedStatement.setString(5, objBeanProgramacion.getCodigo().substring(0, 4));
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanProgramacion.setEnero(objResultSet.getDouble("IMPORTE_A"));
                objBeanProgramacion.setFebrero(objResultSet.getDouble("IMPORTE_B"));
                objBeanProgramacion.setMarzo(objResultSet.getDouble("IMPORTE_C"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getSaldoFuerzaOperativa(objBeanProgramacion) : " + e.getMessage());
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
        return objBeanProgramacion;
    }

    @Override
    public int iduProgramacionMultianual(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA TABLA TAPAIN, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA,
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_PROGRAMACION_MULTIANUAL(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanProgramacion.getPeriodo());
            cs.setString(2, objBeanProgramacion.getUnidadOperativa());
            cs.setInt(3, objBeanProgramacion.getPresupuesto());
            cs.setString(4, objBeanProgramacion.getCodigo());
            cs.setString(5, objBeanProgramacion.getTarea());
            cs.setString(6, objBeanProgramacion.getDepartamento());
            cs.setString(7, objBeanProgramacion.getProvincia());
            cs.setString(8, objBeanProgramacion.getDistrito());
            cs.setDouble(9, objBeanProgramacion.getProgramado());
            cs.setDouble(10, objBeanProgramacion.getEnero());
            cs.setDouble(11, objBeanProgramacion.getFebrero());
            cs.setDouble(12, objBeanProgramacion.getMarzo());
            cs.setString(13, usuario);
            cs.setString(14, objBeanProgramacion.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduProgramacionMultianual : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_MULTIANUAL");
            objBnMsgerr.setTipo(objBeanProgramacion.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduProgramacionMultianualDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA TABLA TAPAIN, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA,
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_PROGRAMACION_MULTI_DET(?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanProgramacion.getPeriodo());
            cs.setString(2, objBeanProgramacion.getUnidadOperativa());
            cs.setInt(3, objBeanProgramacion.getPresupuesto());
            cs.setString(4, objBeanProgramacion.getCodigo());
            cs.setString(5, objBeanProgramacion.getCadenaGasto());
            cs.setString(6, objBeanProgramacion.getDependencia());
            cs.setDouble(7, objBeanProgramacion.getEnero());
            cs.setDouble(8, objBeanProgramacion.getFebrero());
            cs.setDouble(9, objBeanProgramacion.getMarzo());
            cs.setString(10, usuario);
            cs.setString(11, objBeanProgramacion.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduProgramacionMultianualDetalle : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_MULTI_DETALL");
            objBnMsgerr.setTipo(objBeanProgramacion.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
