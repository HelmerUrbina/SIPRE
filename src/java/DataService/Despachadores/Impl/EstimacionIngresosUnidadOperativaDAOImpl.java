/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanEstimacionIngresos;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.EstimacionIngresosUnidadOperativaDAO;
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
public class EstimacionIngresosUnidadOperativaDAOImpl implements EstimacionIngresosUnidadOperativaDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEstimacionIngresos objBnEstimacionIngresos;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public EstimacionIngresosUnidadOperativaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaEstimacionIngresosUnidadOperativa(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario) {
        lista = new ArrayList();
        sql = "SELECT EU.NESTIMACION_INGRESO_CODIGO AS CODIGO, "
                + "VCADENA_INGRESO_CODIGO||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(VCADENA_INGRESO_CODIGO) AS CADENA_INGRESO, "
                + "EI.VESTIMACION_INGRESO_DESCRIP AS DESCRIPCION, "
                + "CASE CTIPO_AFECTACION WHEN 'E' THEN 'EXONERADO' ELSE 'AFECTO' END AS IMPUESTO, "
                + "NPORCENTAJE_RDR_UE AS IMPORTE_UE, NPORCENTAJE_RDR_UO AS IMPORTE_UO "
                + "FROM SIPE_ESTIMACION_INGRESOS EI INNER JOIN SIPE_ESTIMACION_UNIDAD EU ON ("
                + "EI.CPERIODO_CODIGO=EU.CPERIODO_CODIGO AND "
                + "EI.NPRESUPUESTO_CODIGO=EU.NPRESUPUESTO_CODIGO AND "
                + "EI.NESTIMACION_INGRESO_CODIGO=EU.NESTIMACION_INGRESO_CODIGO) WHERE "
                + "EI.CPERIODO_CODIGO=? AND "
                + "EU.CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "EI.NPRESUPUESTO_CODIGO=?  "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEstimacionIngresos.getPeriodo());
            objPreparedStatement.setString(2, objBeanEstimacionIngresos.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEstimacionIngresos.getPresupuesto());
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
            System.out.println("Error al obtener getListaEstimacionIngresosUnidadOperativa(objBeanEstimacionIngresos) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ESTIMACION_UNIDAD");
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
    public List getListaEstimacionIngresos(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario) {
        lista = new ArrayList();
        sql = "SELECT NESTIMACION_INGRESO_CODIGO AS CODIGO, VCADENA_INGRESO_CODIGO||'-'||VESTIMACION_INGRESO_DESCRIP DESCRIPCION "
                + "FROM SIPE_ESTIMACION_INGRESOS WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "NESTIMACION_INGRESO_CODIGO NOT IN(SELECT NESTIMACION_INGRESO_CODIGO "
                + "FROM SIPE_ESTIMACION_UNIDAD WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=?) "
                + "ORDER BY DESCRIPCION";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEstimacionIngresos.getPeriodo());
            objPreparedStatement.setInt(2, objBeanEstimacionIngresos.getPresupuesto());
            objPreparedStatement.setString(3, objBeanEstimacionIngresos.getPeriodo());
            objPreparedStatement.setInt(4, objBeanEstimacionIngresos.getPresupuesto());
            objPreparedStatement.setString(5, objBeanEstimacionIngresos.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEstimacionIngresos = new BeanEstimacionIngresos();
                objBnEstimacionIngresos.setCodigo(objResultSet.getInt("CODIGO"));
                objBnEstimacionIngresos.setDescripcion(objResultSet.getString("DESCRIPCION"));
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
    public int iduEstimacionIngresosUnidadOperativa(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario) {
        sql = "{CALL SP_IDU_ESTIMACION_UNIDAD(?,?,?,?,?,?)}";
        try {
            CallableStatement cs = objConnection.prepareCall(sql);
            cs.setString(1, objBeanEstimacionIngresos.getPeriodo());
            cs.setString(2, objBeanEstimacionIngresos.getUnidadOperativa());
            cs.setInt(3, objBeanEstimacionIngresos.getPresupuesto());
            cs.setInt(4, objBeanEstimacionIngresos.getCodigo());            
            cs.setString(5, usuario);
            cs.setString(6, objBeanEstimacionIngresos.getMode());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduEstimacionIngresosUnidadOperativa : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ESTIMACION_UNIDAD");
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
