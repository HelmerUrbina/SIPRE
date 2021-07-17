/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanEnteGenerador;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.ProgramacionMultianualEnteGeneradorDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public class ProgramacionMultianualEnteGeneradorDAOImpl implements ProgramacionMultianualEnteGeneradorDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEnteGenerador objBnEnteGenerador;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ProgramacionMultianualEnteGeneradorDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaProgramacionMultianualEnteGenerador(BeanEnteGenerador objBeanEnteGenerador, String usuario) {
        lista = new ArrayList();
        sql = "SELECT NPROG_MULTI_ENTE_CODIGO AS CODIGO, "
                + "UTIL_NEW.FUN_NOMBRE_ESTIMACION_INGRESO(CANIO_REGISTRO, NPRESUPUESTO_CODIGO, NESTIMACION_INGRESO_CODIGO) AS CADENA_INGRESO, "
                + "VPROG_MULTI_ENTE_DESCRIP AS DESCRIPCION,  "
                + "CASE CESTADO_CODIGO WHEN 'PE' THEN 'PENDIENTE' WHEN 'CE' THEN 'CERRADO' WHEN 'AN' THEN 'ANULADO' WHEN 'GE' THEN 'GENERADO' ELSE 'VERIFICAR' END AS ESTADO "
                + "FROM SIPE_PROGRAMACION_MULTI_ENTE WHERE "
                + "CANIO_REGISTRO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=?  "
                + "GROUP BY CANIO_REGISTRO, NPRESUPUESTO_CODIGO, NPROG_MULTI_ENTE_CODIGO, "
                + "NESTIMACION_INGRESO_CODIGO, VPROG_MULTI_ENTE_DESCRIP, CESTADO_CODIGO "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEnteGenerador.getPeriodo());
            objPreparedStatement.setString(2, objBeanEnteGenerador.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEnteGenerador.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEnteGenerador = new BeanEnteGenerador();
                objBnEnteGenerador.setCodigo(objResultSet.getInt("CODIGO"));
                objBnEnteGenerador.setCadenaIngreso(objResultSet.getString("CADENA_INGRESO"));
                objBnEnteGenerador.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnEnteGenerador.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnEnteGenerador);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaProgramacionMultianualEnteGenerador(objBeanEnteGenerador) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_MULTI_ENTE");
            objBnMsgerr.setTipo(objBeanEnteGenerador.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.toString());
            }
        }
        return lista;
    }

    @Override
    public List getListaProgramacionMultianualEnteGeneradorDetalle(BeanEnteGenerador objBeanEnteGenerador, String usuario) {
        lista = new ArrayList();
        sql = "SELECT EG.NPROG_MULTI_ENTE_CODIGO AS CODIGO, EG.CPERIODO_CODIGO AS PERIODO,  "
                + "SUM(NPROG_MULTI_ENTE_RECAUDACION) AS RECAUDACION, "
                + "SUM(CASE EI.CTIPO_AFECTACION WHEN 'A' THEN (NPROG_MULTI_ENTE_RECAUDACION)*SD_PFE.FUN_IGV(EG.CANIO_REGISTRO) ELSE 0.0 END) AS IGV, "
                + "SUM(NPROG_MULTI_ENTE_COSTO) AS COSTO_OPERATIVO, "
                + "SUM(CASE EI.CTIPO_AFECTACION WHEN 'A' THEN (NPROG_MULTI_ENTE_RECAUDACION)-(NPROG_MULTI_ENTE_RECAUDACION)*SD_PFE.FUN_IGV('2017')-NPROG_MULTI_ENTE_COSTO "
                + "ELSE NPROG_MULTI_ENTE_RECAUDACION-NPROG_MULTI_ENTE_COSTO END) AS UTILIDAD_NETA, "
                + "ROUND(SUM(CASE EI.CTIPO_AFECTACION WHEN 'A' THEN NPROG_MULTI_ENTE_RECAUDACION-(NPROG_MULTI_ENTE_RECAUDACION)*SD_PFE.FUN_IGV('2017')-NPROG_MULTI_ENTE_COSTO "
                + "ELSE NPROG_MULTI_ENTE_RECAUDACION-NPROG_MULTI_ENTE_COSTO END)*(EI.NPORCENTAJE_RDR_UO/100)) AS UTILIDAD_UO, "
                + "TRUNC(SUM(CASE EI.CTIPO_AFECTACION WHEN 'A' THEN NPROG_MULTI_ENTE_RECAUDACION-(NPROG_MULTI_ENTE_RECAUDACION)*SD_PFE.FUN_IGV('2017')-NPROG_MULTI_ENTE_COSTO "
                + "ELSE NPROG_MULTI_ENTE_RECAUDACION-NPROG_MULTI_ENTE_COSTO END)*(EI.NPORCENTAJE_RDR_UE/100)) AS UTILIDAD_UE "
                + "FROM SIPE_PROGRAMACION_MULTI_ENTE EG LEFT OUTER JOIN SIPE_ESTIMACION_INGRESOS EI ON "
                + "(EI.CPERIODO_CODIGO=EG.CANIO_REGISTRO AND EG.NPRESUPUESTO_CODIGO=EI.NPRESUPUESTO_CODIGO AND EG.NESTIMACION_INGRESO_CODIGO=EI.NESTIMACION_INGRESO_CODIGO) WHERE "
                + "EG.CANIO_REGISTRO=? AND "
                + "EG.CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "EG.NPRESUPUESTO_CODIGO=?  "
                + "GROUP BY EG.CPERIODO_CODIGO, EG.NPRESUPUESTO_CODIGO, EG.NPROG_MULTI_ENTE_CODIGO, EG.NESTIMACION_INGRESO_CODIGO,  "
                + "EI.CTIPO_AFECTACION, EI.NPORCENTAJE_RDR_UO, EI.NPORCENTAJE_RDR_UE "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEnteGenerador.getPeriodo());
            objPreparedStatement.setString(2, objBeanEnteGenerador.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEnteGenerador.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEnteGenerador = new BeanEnteGenerador();
                objBnEnteGenerador.setCodigo(objResultSet.getInt("CODIGO"));
                objBnEnteGenerador.setPeriodo(objResultSet.getString("PERIODO"));
                objBnEnteGenerador.setEnero(objResultSet.getDouble("RECAUDACION"));
                objBnEnteGenerador.setFebrero(objResultSet.getDouble("IGV"));
                objBnEnteGenerador.setMarzo(objResultSet.getDouble("COSTO_OPERATIVO"));
                objBnEnteGenerador.setAbril(objResultSet.getDouble("UTILIDAD_NETA"));
                objBnEnteGenerador.setMayo(objResultSet.getDouble("UTILIDAD_UO"));
                objBnEnteGenerador.setJunio(objResultSet.getDouble("UTILIDAD_UE"));
                lista.add(objBnEnteGenerador);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaProgramacionMultianualEnteGeneradorDetalle(objBeanEnteGenerador) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_MULTI_ENTE");
            objBnMsgerr.setTipo(objBeanEnteGenerador.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.toString());
            }
        }
        return lista;
    }

    @Override
    public BeanEnteGenerador getProgramacionMultianualEnteGenerador(BeanEnteGenerador objBeanEnteGenerador, String usuario) {
        sql = "SELECT NESTIMACION_INGRESO_CODIGO AS CADENA_INGRESO, VPROG_MULTI_ENTE_DESCRIP AS DESCRIPCION, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO) THEN NPROG_MULTI_ENTE_RECAUDACION ELSE 0 END) AS RECAUDACION_A, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+1) THEN NPROG_MULTI_ENTE_RECAUDACION ELSE 0 END) AS RECAUDACION_B, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+2) THEN NPROG_MULTI_ENTE_RECAUDACION ELSE 0 END) AS RECAUDACION_C, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO) THEN NPROG_MULTI_ENTE_COSTO ELSE 0 END) AS COSTO_A, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+1) THEN NPROG_MULTI_ENTE_COSTO ELSE 0 END) AS COSTO_B, "
                + "SUM(CASE TO_NUMBER(CPERIODO_CODIGO) WHEN TO_NUMBER(CANIO_REGISTRO+2) THEN NPROG_MULTI_ENTE_COSTO ELSE 0 END) AS COSTO_C "
                + "FROM SIPE_PROGRAMACION_MULTI_ENTE WHERE "
                + "CANIO_REGISTRO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "NPROG_MULTI_ENTE_CODIGO=? "
                + "GROUP BY NESTIMACION_INGRESO_CODIGO, VPROG_MULTI_ENTE_DESCRIP";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEnteGenerador.getPeriodo());
            objPreparedStatement.setString(2, objBeanEnteGenerador.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEnteGenerador.getPresupuesto());
            objPreparedStatement.setInt(4, objBeanEnteGenerador.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanEnteGenerador.setCadenaIngreso(objResultSet.getString("CADENA_INGRESO"));
                objBeanEnteGenerador.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBeanEnteGenerador.setEnero(objResultSet.getDouble("RECAUDACION_A"));
                objBeanEnteGenerador.setFebrero(objResultSet.getDouble("RECAUDACION_B"));
                objBeanEnteGenerador.setMarzo(objResultSet.getDouble("RECAUDACION_C"));
                objBeanEnteGenerador.setCostoEnero(objResultSet.getDouble("COSTO_A"));
                objBeanEnteGenerador.setCostoFebrero(objResultSet.getDouble("COSTO_B"));
                objBeanEnteGenerador.setCostoMarzo(objResultSet.getDouble("COSTO_C"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getProgramacionMultianualEnteGenerador(objBeanEnteGenerador) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_MULTI_ENTE");
            objBnMsgerr.setTipo(objBeanEnteGenerador.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.toString());
            }
        }
        return objBeanEnteGenerador;
    }

    @Override
    public int iduProgramacionMultianualEnteGenerador(BeanEnteGenerador objBeanEnteGenerador, String usuario) {
        sql = "{CALL SP_IDU_PROGRAMACION_MULTI_ENTE(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEnteGenerador.getPeriodo());
            cs.setString(2, objBeanEnteGenerador.getUnidadOperativa());
            cs.setInt(3, objBeanEnteGenerador.getPresupuesto());
            cs.setInt(4, objBeanEnteGenerador.getCodigo());
            cs.setString(5, objBeanEnteGenerador.getCadenaIngreso());
            cs.setString(6, objBeanEnteGenerador.getDescripcion().toUpperCase());
            cs.setDouble(7, objBeanEnteGenerador.getEnero());
            cs.setDouble(8, objBeanEnteGenerador.getFebrero());
            cs.setDouble(9, objBeanEnteGenerador.getMarzo());
            cs.setDouble(10, objBeanEnteGenerador.getCostoEnero());
            cs.setDouble(11, objBeanEnteGenerador.getCostoFebrero());
            cs.setDouble(12, objBeanEnteGenerador.getCostoMarzo());
            cs.setString(13, usuario);
            cs.setString(14, objBeanEnteGenerador.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduProgramacionMultianualEnteGenerador : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_MULTI_ENTE");
            objBnMsgerr.setTipo(objBeanEnteGenerador.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
