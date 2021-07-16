/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanEnteRecaudador;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.EnteGeneradorDAO;
import DataService.Despachadores.MsgerrDAO;
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
public class EnteGeneradorDAOImpl implements EnteGeneradorDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEnteRecaudador objBnEnteGenerador;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public EnteGeneradorDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaEnteGenerador(BeanEnteRecaudador objBeanEnteGenerador, String usuario) {
        lista = new ArrayList();
        sql = "SELECT EG.NCOD_ENTE_GENERADOR AS CODIGO, "
                + "EI.VCADENA_INGRESO_CODIGO||'-'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(EI.VCADENA_INGRESO_CODIGO) AS CADENA_INGRESO, "
                + "EG.VENTE_GENERADOR_DESCRIP AS DESCRIPCION, "
                + "SUM(NIMPORTE_RECAUDACION) AS RECAUDACION, "
                + "SUM(CASE EI.CTIPO_AFECTACION WHEN 'A' THEN (NIMPORTE_RECAUDACION)*SD_PFE.FUN_IGV(EG.CPERIODO_CODIGO) ELSE 0.0 END) AS IGV, "
                + "SUM(NIMPORTE_COSTO_OPERATIVO) AS COSTO_OPERATIVO, "
                + "SUM(CASE EI.CTIPO_AFECTACION WHEN 'A' THEN (NIMPORTE_RECAUDACION)-(NIMPORTE_RECAUDACION)*SD_PFE.FUN_IGV(EG.CPERIODO_CODIGO)-NIMPORTE_COSTO_OPERATIVO "
                + "ELSE NIMPORTE_RECAUDACION-NIMPORTE_COSTO_OPERATIVO END) AS UTILIDAD_NETA, "
                + "ROUND(SUM(CASE EI.CTIPO_AFECTACION WHEN 'A' THEN NIMPORTE_RECAUDACION-(NIMPORTE_RECAUDACION)*SD_PFE.FUN_IGV(EG.CPERIODO_CODIGO)-NIMPORTE_COSTO_OPERATIVO "
                + "ELSE NIMPORTE_RECAUDACION-NIMPORTE_COSTO_OPERATIVO END)*(EI.NPORCENTAJE_RDR_UO/100)) AS UTILIDAD_UO, "
                + "TRUNC(SUM(CASE EI.CTIPO_AFECTACION WHEN 'A' THEN NIMPORTE_RECAUDACION-(NIMPORTE_RECAUDACION)*SD_PFE.FUN_IGV(EG.CPERIODO_CODIGO)-NIMPORTE_COSTO_OPERATIVO "
                + "ELSE NIMPORTE_RECAUDACION-NIMPORTE_COSTO_OPERATIVO END)*(EI.NPORCENTAJE_RDR_UE/100)) AS UTILIDAD_UE, "
                + "CASE EG.CENTE_GENERADOR_ESTADO WHEN 'PE' THEN 'PENDIENTE' WHEN 'CE' THEN 'CERRADO' WHEN 'AN' THEN 'ANULADO' WHEN 'GE' THEN 'GENERADO' ELSE 'VERIFICAR' END AS ESTADO "
                + "FROM SIPE_ENTE_GENERADOR EG JOIN SIPE_ENTE_GENERADOR_DET ED ON "
                + "(EG.CPERIODO_CODIGO=ED.CPERIODO_CODIGO AND EG.CUNIDAD_OPERATIVA_CODIGO=ED.CUNIDAD_OPERATIVA_CODIGO AND "
                + "EG.NPRESUPUESTO_CODIGO=ED.NPRESUPUESTO_CODIGO AND EG.NCOD_ENTE_GENERADOR=ED.NCOD_ENTE_GENERADOR) LEFT OUTER JOIN SIPE_ESTIMACION_INGRESOS EI ON "
                + "(EG.CPERIODO_CODIGO=EI.CPERIODO_CODIGO AND EG.NPRESUPUESTO_CODIGO=EI.NPRESUPUESTO_CODIGO AND EG.NESTIMACION_INGRESO_CODIGO=EI.NESTIMACION_INGRESO_CODIGO) WHERE "
                + "EG.CPERIODO_CODIGO=? AND "
                + "EG.CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "EG.NPRESUPUESTO_CODIGO=?  "
                + "GROUP BY EG.CPERIODO_CODIGO, EG.NPRESUPUESTO_CODIGO, EG.NCOD_ENTE_GENERADOR, EI.VCADENA_INGRESO_CODIGO, EG.VENTE_GENERADOR_DESCRIP, "
                + "EG.CENTE_GENERADOR_ESTADO, EI.CTIPO_AFECTACION, EI.NPORCENTAJE_RDR_UO, EI.NPORCENTAJE_RDR_UE "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEnteGenerador.getPeriodo());
            objPreparedStatement.setString(2, objBeanEnteGenerador.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEnteGenerador.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEnteGenerador = new BeanEnteRecaudador();
                objBnEnteGenerador.setCodigo(objResultSet.getInt("CODIGO"));
                objBnEnteGenerador.setCadenaIngreso(objResultSet.getString("CADENA_INGRESO"));
                objBnEnteGenerador.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnEnteGenerador.setEnero(objResultSet.getDouble("RECAUDACION"));
                objBnEnteGenerador.setFebrero(objResultSet.getDouble("IGV"));
                objBnEnteGenerador.setMarzo(objResultSet.getDouble("COSTO_OPERATIVO"));
                objBnEnteGenerador.setAbril(objResultSet.getDouble("UTILIDAD_NETA"));
                objBnEnteGenerador.setMayo(objResultSet.getDouble("UTILIDAD_UO"));
                objBnEnteGenerador.setJunio(objResultSet.getDouble("UTILIDAD_UE"));
                objBnEnteGenerador.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnEnteGenerador);
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaEnteGenerador(objBeanEnteGenerador) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ENTE_GENERADOR");
            objBnMsgerr.setTipo(objBeanEnteGenerador.getMode().toUpperCase());
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
    public BeanEnteRecaudador getEnteGenerador(BeanEnteRecaudador objBeanEnteGenerador, String usuario) {
        sql = "SELECT EG.NESTIMACION_INGRESO_CODIGO AS CADENA_INGRESO, EG.VENTE_GENERADOR_DESCRIP AS DESCRIPCION, "
                + "SUM(CASE CMES_CODIGO WHEN '01' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_ENE, "
                + "SUM(CASE CMES_CODIGO WHEN '02' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_FEB, "
                + "SUM(CASE CMES_CODIGO WHEN '03' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_MAR, "
                + "SUM(CASE CMES_CODIGO WHEN '04' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_ABR, "
                + "SUM(CASE CMES_CODIGO WHEN '05' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_MAY, "
                + "SUM(CASE CMES_CODIGO WHEN '06' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_JUN, "
                + "SUM(CASE CMES_CODIGO WHEN '07' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_JUL, "
                + "SUM(CASE CMES_CODIGO WHEN '08' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_AGO, "
                + "SUM(CASE CMES_CODIGO WHEN '09' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_SET, "
                + "SUM(CASE CMES_CODIGO WHEN '10' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_OCT, "
                + "SUM(CASE CMES_CODIGO WHEN '11' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_NOV, "
                + "SUM(CASE CMES_CODIGO WHEN '12' THEN NIMPORTE_RECAUDACION ELSE 0 END) AS REC_DIC, "
                + "SUM(CASE CMES_CODIGO WHEN '01' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_ENE, "
                + "SUM(CASE CMES_CODIGO WHEN '02' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_FEB, "
                + "SUM(CASE CMES_CODIGO WHEN '03' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_MAR, "
                + "SUM(CASE CMES_CODIGO WHEN '04' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_ABR, "
                + "SUM(CASE CMES_CODIGO WHEN '05' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_MAY, "
                + "SUM(CASE CMES_CODIGO WHEN '06' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_JUN, "
                + "SUM(CASE CMES_CODIGO WHEN '07' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_JUL, "
                + "SUM(CASE CMES_CODIGO WHEN '08' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_AGO, "
                + "SUM(CASE CMES_CODIGO WHEN '09' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_SET, "
                + "SUM(CASE CMES_CODIGO WHEN '10' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_OCT, "
                + "SUM(CASE CMES_CODIGO WHEN '11' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_NOV, "
                + "SUM(CASE CMES_CODIGO WHEN '12' THEN NIMPORTE_COSTO_OPERATIVO ELSE 0 END) AS COS_DIC  "
                + "FROM SIPE_ENTE_GENERADOR EG JOIN SIPE_ENTE_GENERADOR_DET ED ON "
                + "(EG.CPERIODO_CODIGO=ED.CPERIODO_CODIGO AND EG.CUNIDAD_OPERATIVA_CODIGO=ED.CUNIDAD_OPERATIVA_CODIGO AND "
                + "EG.NPRESUPUESTO_CODIGO=ED.NPRESUPUESTO_CODIGO AND EG.NCOD_ENTE_GENERADOR=ED.NCOD_ENTE_GENERADOR) WHERE "
                + "EG.CPERIODO_CODIGO=? AND "
                + "EG.CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "EG.NPRESUPUESTO_CODIGO=? AND "
                + "EG.NCOD_ENTE_GENERADOR=? "
                + "GROUP BY EG.NESTIMACION_INGRESO_CODIGO, EG.VENTE_GENERADOR_DESCRIP";
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
                objBeanEnteGenerador.setEnero(objResultSet.getDouble("REC_ENE"));
                objBeanEnteGenerador.setFebrero(objResultSet.getDouble("REC_FEB"));
                objBeanEnteGenerador.setMarzo(objResultSet.getDouble("REC_MAR"));
                objBeanEnteGenerador.setAbril(objResultSet.getDouble("REC_ABR"));
                objBeanEnteGenerador.setMayo(objResultSet.getDouble("REC_MAY"));
                objBeanEnteGenerador.setJunio(objResultSet.getDouble("REC_JUN"));
                objBeanEnteGenerador.setJulio(objResultSet.getDouble("REC_JUL"));
                objBeanEnteGenerador.setAgosto(objResultSet.getDouble("REC_AGO"));
                objBeanEnteGenerador.setSetiembre(objResultSet.getDouble("REC_SET"));
                objBeanEnteGenerador.setOctubre(objResultSet.getDouble("REC_OCT"));
                objBeanEnteGenerador.setNoviembre(objResultSet.getDouble("REC_NOV"));
                objBeanEnteGenerador.setDiciembre(objResultSet.getDouble("REC_DIC"));
                objBeanEnteGenerador.setCostoEnero(objResultSet.getDouble("COS_ENE"));
                objBeanEnteGenerador.setCostoFebrero(objResultSet.getDouble("COS_FEB"));
                objBeanEnteGenerador.setCostoMarzo(objResultSet.getDouble("COS_MAR"));
                objBeanEnteGenerador.setCostoAbril(objResultSet.getDouble("COS_ABR"));
                objBeanEnteGenerador.setCostoMayo(objResultSet.getDouble("COS_MAY"));
                objBeanEnteGenerador.setCostoJunio(objResultSet.getDouble("COS_JUN"));
                objBeanEnteGenerador.setCostoJulio(objResultSet.getDouble("COS_JUL"));
                objBeanEnteGenerador.setCostoAgosto(objResultSet.getDouble("COS_AGO"));
                objBeanEnteGenerador.setCostoSetiembre(objResultSet.getDouble("COS_SET"));
                objBeanEnteGenerador.setCostoOctubre(objResultSet.getDouble("COS_OCT"));
                objBeanEnteGenerador.setCostoNoviembre(objResultSet.getDouble("COS_NOV"));
                objBeanEnteGenerador.setCostoDiciembre(objResultSet.getDouble("COS_DIC"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getEnteGenerador(objBeanEnteGenerador) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ENTE_GENERADOR_DET");
            objBnMsgerr.setTipo(objBeanEnteGenerador.getMode().toUpperCase());
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
        return objBeanEnteGenerador;
    }

    @Override
    public int iduEnteGenerador(BeanEnteRecaudador objBeanEnteGenerador, String usuario) {
        sql = "{CALL SP_IDU_ENTE_GENERADOR(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try {
            CallableStatement cs = objConnection.prepareCall(sql);
            cs.setString(1, objBeanEnteGenerador.getPeriodo());
            cs.setString(2, objBeanEnteGenerador.getUnidadOperativa());
            cs.setInt(3, objBeanEnteGenerador.getPresupuesto());
            cs.setString(4, objBeanEnteGenerador.getCadenaIngreso());
            cs.setInt(5, objBeanEnteGenerador.getCodigo());
            cs.setString(6, objBeanEnteGenerador.getDescripcion().toUpperCase());
            cs.setDouble(7, objBeanEnteGenerador.getEnero());
            cs.setDouble(8, objBeanEnteGenerador.getFebrero());
            cs.setDouble(9, objBeanEnteGenerador.getMarzo());
            cs.setDouble(10, objBeanEnteGenerador.getAbril());
            cs.setDouble(11, objBeanEnteGenerador.getMayo());
            cs.setDouble(12, objBeanEnteGenerador.getJunio());
            cs.setDouble(13, objBeanEnteGenerador.getJulio());
            cs.setDouble(14, objBeanEnteGenerador.getAgosto());
            cs.setDouble(15, objBeanEnteGenerador.getSetiembre());
            cs.setDouble(16, objBeanEnteGenerador.getOctubre());
            cs.setDouble(17, objBeanEnteGenerador.getNoviembre());
            cs.setDouble(18, objBeanEnteGenerador.getDiciembre());
            cs.setDouble(19, objBeanEnteGenerador.getCostoEnero());
            cs.setDouble(20, objBeanEnteGenerador.getCostoFebrero());
            cs.setDouble(21, objBeanEnteGenerador.getCostoMarzo());
            cs.setDouble(22, objBeanEnteGenerador.getCostoAbril());
            cs.setDouble(23, objBeanEnteGenerador.getCostoMayo());
            cs.setDouble(24, objBeanEnteGenerador.getCostoJunio());
            cs.setDouble(25, objBeanEnteGenerador.getCostoJulio());
            cs.setDouble(26, objBeanEnteGenerador.getCostoAgosto());
            cs.setDouble(27, objBeanEnteGenerador.getCostoSetiembre());
            cs.setDouble(28, objBeanEnteGenerador.getCostoOctubre());
            cs.setDouble(29, objBeanEnteGenerador.getCostoNoviembre());
            cs.setDouble(30, objBeanEnteGenerador.getCostoDiciembre());
            cs.setString(31, usuario);
            cs.setString(32, objBeanEnteGenerador.getMode());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduEnteGenerador : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ENTE_GENERADOR");
            objBnMsgerr.setTipo(objBeanEnteGenerador.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduEnteGenerador : " + e.toString());
            }
        }
        return s;
    }

    @Override
    public int iduGeneraCNV(BeanEnteRecaudador objBeanEnteGenerador, String usuario) {
        sql = "{CALL SP_IDU_GENERA_CNV(?,?,?,?,?)}";
        try {
            CallableStatement cs = objConnection.prepareCall(sql);
            cs.setString(1, objBeanEnteGenerador.getPeriodo());
            cs.setString(2, objBeanEnteGenerador.getUnidadOperativa());
            cs.setInt(3, objBeanEnteGenerador.getPresupuesto());
            cs.setInt(4, objBeanEnteGenerador.getCodigo());
            cs.setString(5, usuario);
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduGeneraCNV : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ENTE_GENERADOR");
            objBnMsgerr.setTipo(objBeanEnteGenerador.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduGeneraCNV : " + e.toString());
            }
        }
        return s;
    }

    @Override
    public String getCNV(BeanEnteRecaudador objBeanEnteGenerador, String usuario) {
        String result = "";
        sql = "SELECT MAX(CODEVE) AS EVENTO_PRINCIPAL, MAX(COEVFI) AS EVENTO_FINAL "
                + "FROM TAEVFI WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEnteGenerador.getPeriodo());
            objPreparedStatement.setString(2, objBeanEnteGenerador.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEnteGenerador.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEnteGenerador.getTarea());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("EVENTO_PRINCIPAL") + "+++" + objResultSet.getString("EVENTO_FINAL");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCNV(objBeanEnteGenerador) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAEVFI");
            objBnMsgerr.setTipo(objBeanEnteGenerador.getMode().toUpperCase());
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
}
