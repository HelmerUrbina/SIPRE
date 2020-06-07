/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanEstimacionIngresos;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.EstimacionIngresosDAO;
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
public class EstimacionIngresosDAOImpl implements EstimacionIngresosDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEstimacionIngresos objBnEstimacionIngresos;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public EstimacionIngresosDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaEstimacionIngresos(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario) {
        lista = new ArrayList();
        sql = "SELECT NESTIMACION_INGRESO_CODIGO AS CODIGO, "
                + "VCADENA_INGRESO_CODIGO||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(VCADENA_INGRESO_CODIGO) AS CADENA_INGRESO, "
                + "VESTIMACION_INGRESO_DESCRIP AS DESCRIPCION, "
                + "CASE CTIPO_AFECTACION WHEN 'E' THEN 'EXONERADO' ELSE 'AFECTO' END AS IMPUESTO, "
                + "NPORCENTAJE_RDR_UE AS IMPORTE_UE, NPORCENTAJE_RDR_UO AS IMPORTE_UO "
                + "FROM SIPE_ESTIMACION_INGRESOS WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEstimacionIngresos.getPeriodo());
            objPreparedStatement.setInt(2, objBeanEstimacionIngresos.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEstimacionIngresos = new BeanEstimacionIngresos();
                objBnEstimacionIngresos.setCodigo(objResultSet.getInt("CODIGO"));
                objBnEstimacionIngresos.setCadenaIngreso(objResultSet.getString("CADENA_INGRESO"));
                objBnEstimacionIngresos.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnEstimacionIngresos.setImpuesto(objResultSet.getString("IMPUESTO"));
                objBnEstimacionIngresos.setImporteUnidadOperativa(objResultSet.getDouble("IMPORTE_UO"));
                objBnEstimacionIngresos.setImporteUnidadEjecutora(objResultSet.getDouble("IMPORTE_UE"));                
                lista.add(objBnEstimacionIngresos);
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaEstimacionIngresos(objBeanEstimacionIngresos) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ESTIMACION_INGRESOS");
            objBnMsgerr.setTipo(objBeanEstimacionIngresos.getMode().toUpperCase());
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
    public BeanEstimacionIngresos getEstimacionIngresos(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario) {
        sql = "SELECT VCADENA_INGRESO_CODIGO, VESTIMACION_INGRESO_DESCRIP, CTIPO_AFECTACION, "
                + "NPORCENTAJE_RDR_UO, NPORCENTAJE_RDR_UE "
                + "FROM SIPE_ESTIMACION_INGRESOS WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "NESTIMACION_INGRESO_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEstimacionIngresos.getPeriodo());
            objPreparedStatement.setInt(2, objBeanEstimacionIngresos.getPresupuesto());
            objPreparedStatement.setInt(3, objBeanEstimacionIngresos.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanEstimacionIngresos.setCadenaIngreso(objResultSet.getString("VCADENA_INGRESO_CODIGO"));
                objBeanEstimacionIngresos.setDescripcion(objResultSet.getString("VESTIMACION_INGRESO_DESCRIP"));
                objBeanEstimacionIngresos.setImpuesto(objResultSet.getString("CTIPO_AFECTACION"));
                objBeanEstimacionIngresos.setImporteUnidadOperativa(objResultSet.getDouble("NPORCENTAJE_RDR_UO"));
                objBeanEstimacionIngresos.setImporteUnidadEjecutora(objResultSet.getDouble("NPORCENTAJE_RDR_UE"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getEstimacionIngresos(objBeanEstimacionIngresos) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ESTIMACION_INGRESOS");
            objBnMsgerr.setTipo(objBeanEstimacionIngresos.getMode().toUpperCase());
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
        return objBeanEstimacionIngresos;
    }

    @Override
    public int iduEstimacionIngresos(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario) {
        sql = "{CALL SP_IDU_ESTIMACION_INGRESOS(?,?,?,?,?,?,?,?,?,?)}";
        try {
            CallableStatement cs = objConnection.prepareCall(sql);
            cs.setString(1, objBeanEstimacionIngresos.getPeriodo());
            cs.setInt(2, objBeanEstimacionIngresos.getPresupuesto());
            cs.setInt(3, objBeanEstimacionIngresos.getCodigo());
            cs.setString(4, objBeanEstimacionIngresos.getCadenaIngreso());
            cs.setString(5, objBeanEstimacionIngresos.getDescripcion().toUpperCase());
            cs.setString(6, objBeanEstimacionIngresos.getImpuesto());
            cs.setDouble(7, objBeanEstimacionIngresos.getImporteUnidadOperativa());
            cs.setDouble(8, objBeanEstimacionIngresos.getImporteUnidadEjecutora());
            cs.setString(9, usuario);
            cs.setString(10, objBeanEstimacionIngresos.getMode());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduEstimacionIngresos : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ESTIMACION_INGRESOS");
            objBnMsgerr.setTipo(objBeanEstimacionIngresos.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduEstimacionIngresos : " + e.toString());
            }
        }
        return s;
    }

}
