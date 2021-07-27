/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanEnteRecaudador;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.MsgerrDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import DataService.Despachadores.EnteRecaudadorDAO;

/**
 *
 * @author H-URBINA-M
 */
public class EnteRecaudadorDAOImpl implements EnteRecaudadorDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEnteRecaudador objBnEnteGenerador;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public EnteRecaudadorDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaEnteRecaudador(BeanEnteRecaudador objBeanEnteRecaudador) {
        lista = new ArrayList();
        sql = "SELECT ER.NENTE_RECAUDADOR_CODIGO AS CODIGO, "
                + "UTIL_NEW.FUN_NOMBRE_ESTIMACION_INGRESO(EI.CPERIODO_CODIGO, ER.NPRESUPUESTO_CODIGO, ER.NESTIMACION_INGRESO_CODIGO) AS CLASIFICADOR,"
                + "EI.VESTIMACION_INGRESO_DESCRIP AS CONCEPTO, "
                + "ER.VENTE_RECAUDADOR_DESCRIPCION AS DESCRIPCION, "
                + "SUM(NENTE_RECAUDADOR_RECAUDACION) AS RECAUDACION, "
                + "SUM(NENTE_RECAUDADOR_DETRACCION) AS DETRACCION, "
                + "SUM(NENTE_RECAUDADOR_IGV) AS IGV, SUM(NENTE_RECAUDADOR_UTILIDAD) AS UTILIDAD_NETA, "
                + "ROUND(SUM(NENTE_RECAUDADOR_UTILIDAD)*(EI.NPORCENTAJE_RDR_UO/100)) AS UTILIDAD_UO, "
                + "TRUNC(SUM(NENTE_RECAUDADOR_UTILIDAD)*(EI.NPORCENTAJE_RDR_UE/100)) AS UTILIDAD_UE "
                + "FROM SIPRE_ENTE_RECAUDADOR ER LEFT OUTER JOIN SIPE_ESTIMACION_INGRESOS EI ON ("
                + "EI.CPERIODO_CODIGO=ER.CPERIODO_CODIGO AND "
                + "ER.NPRESUPUESTO_CODIGO=EI.NPRESUPUESTO_CODIGO AND "
                + "ER.NESTIMACION_INGRESO_CODIGO=EI.NESTIMACION_INGRESO_CODIGO) WHERE "
                + "ER.CPERIODO_CODIGO=? AND "
                + "ER.NPRESUPUESTO_CODIGO=?  AND "
                + "ER.CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "ER.CMES_CODIGO=? AND "
                + "ER.CESTADO_CODIGO!='AN' "
                + "GROUP BY ER.NENTE_RECAUDADOR_CODIGO, EI.CPERIODO_CODIGO, ER.NPRESUPUESTO_CODIGO, ER.NESTIMACION_INGRESO_CODIGO, "
                + "ER.VENTE_RECAUDADOR_DESCRIPCION, EI.NPORCENTAJE_RDR_UO, EI.NPORCENTAJE_RDR_UE, EI.VESTIMACION_INGRESO_DESCRIP "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEnteRecaudador.getPeriodo());
            objPreparedStatement.setInt(2, objBeanEnteRecaudador.getPresupuesto());
            objPreparedStatement.setString(3, objBeanEnteRecaudador.getUnidadOperativa());
            objPreparedStatement.setString(4, objBeanEnteRecaudador.getMes());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEnteGenerador = new BeanEnteRecaudador();
                objBnEnteGenerador.setCodigo(objResultSet.getInt("CODIGO"));
                objBnEnteGenerador.setClasificador(objResultSet.getString("CLASIFICADOR"));
                objBnEnteGenerador.setEstado(objResultSet.getString("CONCEPTO"));
                objBnEnteGenerador.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnEnteGenerador.setRecaudacion(objResultSet.getDouble("RECAUDACION"));
                objBnEnteGenerador.setDetraccion(objResultSet.getDouble("DETRACCION"));
                objBnEnteGenerador.setIGV(objResultSet.getDouble("IGV"));
                objBnEnteGenerador.setUtilidadNeta(objResultSet.getDouble("UTILIDAD_NETA"));
                objBnEnteGenerador.setUtilidadUE(objResultSet.getDouble("UTILIDAD_UE"));
                objBnEnteGenerador.setUtilidadUO(objResultSet.getDouble("UTILIDAD_UO"));
                lista.add(objBnEnteGenerador);
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaEnteRecaudador(objBeanEnteGenerador) : " + e.getMessage());
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
        return lista;
    }

    @Override
    public BeanEnteRecaudador getEnteRecaudador(BeanEnteRecaudador objBeanEnteGenerador) {
        sql = "SELECT NESTIMACION_INGRESO_CODIGO, VENTE_RECAUDADOR_DESCRIPCION, "
                + "NENTE_RECAUDADOR_RECAUDACION, NENTE_RECAUDADOR_DETRACCION, NENTE_RECAUDADOR_IGV, NENTE_RECAUDADOR_UTILIDAD "
                + "FROM SIPRE_ENTE_RECAUDADOR WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=?  AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "CMES_CODIGO=? AND "
                + "NENTE_RECAUDADOR_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEnteGenerador.getPeriodo());
            objPreparedStatement.setInt(2, objBeanEnteGenerador.getPresupuesto());
            objPreparedStatement.setString(3, objBeanEnteGenerador.getUnidadOperativa());
            objPreparedStatement.setString(4, objBeanEnteGenerador.getMes());
            objPreparedStatement.setInt(5, objBeanEnteGenerador.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanEnteGenerador.setEstimacionIngreso(objResultSet.getInt("NESTIMACION_INGRESO_CODIGO"));
                objBeanEnteGenerador.setDescripcion(objResultSet.getString("VENTE_RECAUDADOR_DESCRIPCION"));
                objBeanEnteGenerador.setRecaudacion(objResultSet.getDouble("NENTE_RECAUDADOR_RECAUDACION"));
                objBeanEnteGenerador.setDetraccion(objResultSet.getDouble("NENTE_RECAUDADOR_DETRACCION"));
                objBeanEnteGenerador.setIGV(objResultSet.getDouble("NENTE_RECAUDADOR_IGV"));
                objBeanEnteGenerador.setUtilidadNeta(objResultSet.getDouble("NENTE_RECAUDADOR_UTILIDAD"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getEnteRecaudador(objBeanEnteGenerador) : " + e.getMessage());
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
        return objBeanEnteGenerador;
    }

    @Override
    public int iduEnteRecaudador(BeanEnteRecaudador objBeanEnteGenerador, String usuario) {
        sql = "{CALL SP_IDU_ENTE_RECAUDADOR(?,?,?,?,?,?,?,?,?,?,?)}";
        try {
            CallableStatement cs = objConnection.prepareCall(sql);
            cs.setString(1, objBeanEnteGenerador.getPeriodo());
            cs.setInt(2, objBeanEnteGenerador.getPresupuesto());
            cs.setString(3, objBeanEnteGenerador.getUnidadOperativa());
            cs.setString(4, objBeanEnteGenerador.getMes());
            cs.setInt(5, objBeanEnteGenerador.getCodigo());
            cs.setInt(6, objBeanEnteGenerador.getEstimacionIngreso());
            cs.setString(7, objBeanEnteGenerador.getDescripcion());
            cs.setDouble(8, objBeanEnteGenerador.getRecaudacion());
            cs.setDouble(9, objBeanEnteGenerador.getDetraccion());
            cs.setDouble(9, objBeanEnteGenerador.getIGV());
            cs.setDouble(9, objBeanEnteGenerador.getUtilidadNeta());
            cs.setString(10, usuario);
            cs.setString(11, objBeanEnteGenerador.getMode());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduEnteGenerador : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_ENTE_RECAUDADOR");
            objBnMsgerr.setTipo(objBeanEnteGenerador.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduEnteRecaudador : " + e.getMessage());
            }
        }
        return s;
    }
}
