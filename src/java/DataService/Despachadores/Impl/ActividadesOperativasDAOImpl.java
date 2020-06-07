/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPlaneamiento;
import BusinessServices.Beans.BeanProgramacionPresupuestal;
import DataService.Despachadores.MsgerrDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;
import DataService.Despachadores.ActividadesOperativasDAO;
import java.util.ArrayList;

/**
 *
 * @author H-URBINA-M
 */
public class ActividadesOperativasDAOImpl implements ActividadesOperativasDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPlaneamiento objBnActividades;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ActividadesOperativasDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaActividadesOperativas(BeanPlaneamiento objBeanActividades, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NAOI_CODIGO AS CODIGO, VAOI_DESCRIPCION AS DESCRIPCION, NAOI_PRIORIDAD AS PRIORIDAD, "
                + "CCATEGORIA_PRESUPUESTAL_CODIGO||':'||UTIL_NEW.FUN_NOMBRE_CATEGORIA_PRESUPUES(CCATEGORIA_PRESUPUESTAL_CODIGO) AS CATEGORIA_PRESUPUESTAL, "
                + "CPRODUCTO_CODIGO||':'||UTIL_NEW.FUN_NOMBRE_PRODUCTO(TRIM(CPRODUCTO_CODIGO)) AS PRODUCTO, "
                + "CACTIVIDAD_CODIGO||':'||UTIL_NEW.FUN_NOMBRE_ACTIVIDAD(CACTIVIDAD_CODIGO) AS ACTIVIDAD, "
                + "UTIL_NEW.FUN_NOMBRE_UNIDAD_MEDIDA(CUNIDAD_MEDIDA_CODIGO) AS UNIDAD_MEDIDA, "
                + "CASE CESTADO_CODIGO WHEN 'AC' THEN 'ACTIVO' WHEN 'AN' THEN 'ANULADO' ELSE 'VERIFICAR' END AS ESTADO "
                + "FROM SIPRE_POI_ACTIVIDADES_OPERATIV WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NOEI_CODIGO=? AND "
                + "NAEI_CODIGO=? "
                + "ORDER BY PRIORIDAD";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanActividades.getPeriodo());
            objPreparedStatement.setInt(2, objBeanActividades.getObjetivo());
            objPreparedStatement.setInt(3, objBeanActividades.getAcciones());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnActividades = new BeanPlaneamiento();
                objBnActividades.setCodigo(objResultSet.getString("CODIGO"));
                objBnActividades.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnActividades.setPrioridad(objResultSet.getInt("PRIORIDAD"));
                objBnActividades.setCategoriaPresupuestal(objResultSet.getString("CATEGORIA_PRESUPUESTAL"));
                objBnActividades.setProducto(objResultSet.getString("PRODUCTO"));
                objBnActividades.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnActividades.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBnActividades.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnActividades);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaActividadesOperativas(" + objBeanActividades + ", " + usuario + ") : " + e.getMessage());
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
    public BeanPlaneamiento getActividadesOperativas(BeanPlaneamiento objBeanActividades, String usuario) {
        sql = "SELECT VAOI_DESCRIPCION, NAOI_PRIORIDAD, CCATEGORIA_PRESUPUESTAL_CODIGO, "
                + "CPRODUCTO_CODIGO, CACTIVIDAD_CODIGO||':'||UTIL_NEW.FUN_NOMBRE_ACTIVIDAD(CACTIVIDAD_CODIGO) AS ACTIVIDAD, "
                + "CUNIDAD_MEDIDA_CODIGO, CESTADO_CODIGO "
                + "FROM SIPRE_POI_ACTIVIDADES_OPERATIV WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NOEI_CODIGO=? AND "
                + "NAEI_CODIGO=? AND "
                + "NAOI_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanActividades.getPeriodo());
            objPreparedStatement.setInt(2, objBeanActividades.getObjetivo());
            objPreparedStatement.setInt(3, objBeanActividades.getAcciones());
            objPreparedStatement.setString(4, objBeanActividades.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanActividades.setDescripcion(objResultSet.getString("VAOI_DESCRIPCION"));
                objBeanActividades.setPrioridad(objResultSet.getInt("NAOI_PRIORIDAD"));
                objBeanActividades.setCategoriaPresupuestal(objResultSet.getString("CCATEGORIA_PRESUPUESTAL_CODIGO"));
                objBeanActividades.setProducto(objResultSet.getString("CPRODUCTO_CODIGO"));
                objBeanActividades.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBeanActividades.setUnidadMedida(objResultSet.getString("CUNIDAD_MEDIDA_CODIGO"));
                objBeanActividades.setEstado(objResultSet.getString("CESTADO_CODIGO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getActividadesOperativas(" + objBeanActividades + ", " + usuario + ") : " + e.getMessage());
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
        return objBeanActividades;
    }

    @Override
    public Integer getPrioridadActividadesOperativas(BeanPlaneamiento objBeanActividades, String usuario) {
        Integer prioridad = 0;
        sql = "SELECT NVL(MAX(NAOI_PRIORIDAD),0)+1 AS PRIORIDAD "
                + "FROM SIPRE_POI_ACTIVIDADES_OPERATIV WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NOEI_CODIGO=? AND "
                + "NAEI_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanActividades.getPeriodo());
            objPreparedStatement.setInt(2, objBeanActividades.getObjetivo());
            objPreparedStatement.setInt(3, objBeanActividades.getAcciones());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                prioridad = objResultSet.getInt("PRIORIDAD");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPrioridadActividadesOperativas(" + objBeanActividades + ", " + usuario + ") : " + e.getMessage());
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
        return prioridad;
    }

    @Override
    public ArrayList getListaActividadesOperativasDetalleDetalle(BeanPlaneamiento objBeanActividades, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT NTAREA_OPERATIVA_CODIGO||'-'||CUBIGEO_CODIGO AS CODIGO, "
                + "NTAREA_OPERATIVA_CODIGO||':'||PK_PLANEAMIENTO.FUN_ABREVIATURA_TAREA_OPERATIV(NTAREA_OPERATIVA_CODIGO) AS TAREA_OPERATIVA,"
                + "UTIL_NEW.FUN_DESUBI(CUBIGEO_CODIGO) AS UBIGEO, "
                + "SUM(CASE TO_NUMBER(CAOI_DETALLE_ANO) WHEN TO_NUMBER(CPERIODO_CODIGO) THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_A, "
                + "SUM(CASE TO_NUMBER(CAOI_DETALLE_ANO) WHEN TO_NUMBER(CPERIODO_CODIGO)+1 THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_B, "
                + "SUM(CASE TO_NUMBER(CAOI_DETALLE_ANO) WHEN TO_NUMBER(CPERIODO_CODIGO)+2 THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_C, "
                + "SUM(CASE TO_NUMBER(CAOI_DETALLE_ANO) WHEN TO_NUMBER(CPERIODO_CODIGO) THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_A, "
                + "SUM(CASE TO_NUMBER(CAOI_DETALLE_ANO) WHEN TO_NUMBER(CPERIODO_CODIGO)+1 THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_B, "
                + "SUM(CASE TO_NUMBER(CAOI_DETALLE_ANO) WHEN TO_NUMBER(CPERIODO_CODIGO)+2 THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_C "
                + "FROM SIPRE_POI_ACTIVIDADES_OPE_DETA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NOEI_CODIGO=? AND "
                + "NAEI_CODIGO=? AND "
                + "NAOI_CODIGO=? "
                + "GROUP BY NTAREA_OPERATIVA_CODIGO, CUBIGEO_CODIGO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanActividades.getPeriodo());
            objPreparedStatement.setInt(2, objBeanActividades.getObjetivo());
            objPreparedStatement.setInt(3, objBeanActividades.getAcciones());
            objPreparedStatement.setString(4, objBeanActividades.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("TAREA_OPERATIVA") + "+++"
                        + objResultSet.getString("UBIGEO") + "+++"
                        + objResultSet.getDouble("MONTO_A") + "+++"
                        + objResultSet.getDouble("MONTO_B") + "+++"
                        + objResultSet.getDouble("MONTO_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_C");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaActividadesOperativasDetalleDetalle(objBeanActividades) : " + e.getMessage());
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
    public String getActividadesOperativasDetalleDetalle(BeanPlaneamiento objBeanActividades, String usuario) {
        String arreglo = "";
        sql = "SELECT NTAREA_OPERATIVA_CODIGO, CUBIGEO_CODIGO, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='01' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_ENERO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='02' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_FEBRERO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='03' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_MARZO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='04' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_ABRIL_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='05' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_MAYO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='06' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_JUNIO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='07' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_JULIO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='08' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_AGOSTO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='09' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_SETIEMBRE_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='10' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_OCTUBRE_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='11' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_NOVIEMBRE_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=TO_NUMBER(CPERIODO_CODIGO) AND CMES_CODIGO='12' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_DICIEMBRE_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='01' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_ENERO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='02' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_FEBRERO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='03' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_MARZO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='04' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_ABRIL_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='05' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_MAYO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='06' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_JUNIO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='07' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_JULIO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='08' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_AGOSTO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='09' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_SETIEMBRE_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='10' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_OCTUBRE_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='11' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_NOVIEMBRE_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='12' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_DICIEMBRE_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='01' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_ENERO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='02' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_FEBRERO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='03' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_MARZO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='04' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_ABRIL_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='05' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_MAYO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='06' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_JUNIO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='07' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_JULIO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='08' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_AGOSTO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='09' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_SETIEMBRE_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='10' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_OCTUBRE_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='11' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_NOVIEMBRE_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='12' THEN NAOI_DETALLE_IMPORTE ELSE 0 END) AS MONTO_DICIEMBRE_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='01' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_ENERO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='02' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_FEBRERO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='03' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_MARZO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='04' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_ABRIL_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='05' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_MAYO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='06' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_JUNIO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='07' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_JULIO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='08' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_AGOSTO_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='09' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_SETIEMBRE_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='10' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_OCTUBRE_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='11' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_NOVIEMBRE_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)) AND CMES_CODIGO='12' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_DICIEMBRE_A, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='01' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_ENERO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='02' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_FEBRERO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='03' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_MARZO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='04' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_ABRIL_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='05' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_MAYO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='06' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_JUNIO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='07' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_JULIO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='08' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_AGOSTO_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='09' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_SETIEMBRE_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='10' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_OCTUBRE_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='11' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_NOVIEMBRE_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+1) AND CMES_CODIGO='12' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_DICIEMBRE_B, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='01' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_ENERO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='02' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_FEBRERO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='03' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_MARZO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='04' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_ABRIL_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='05' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_MAYO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='06' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_JUNIO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='07' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_JULIO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='08' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_AGOSTO_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='09' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_SETIEMBRE_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='10' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_OCTUBRE_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='11' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_NOVIEMBRE_C, "
                + "SUM(CASE WHEN TO_NUMBER(CAOI_DETALLE_ANO)=(TO_NUMBER(CPERIODO_CODIGO)+2) AND CMES_CODIGO='12' THEN NAOI_DETALLE_CANTIDAD ELSE 0 END) AS CANTIDAD_DICIEMBRE_C  "
                + "FROM SIPRE_POI_ACTIVIDADES_OPE_DETA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NOEI_CODIGO=? AND "
                + "NAEI_CODIGO=? AND "
                + "NAOI_CODIGO=? AND "
                + "NTAREA_OPERATIVA_CODIGO||'-'||CUBIGEO_CODIGO=? "
                + "GROUP BY NTAREA_OPERATIVA_CODIGO, CUBIGEO_CODIGO ";
       
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanActividades.getPeriodo());
            objPreparedStatement.setInt(2, objBeanActividades.getObjetivo());
            objPreparedStatement.setInt(3, objBeanActividades.getAcciones());
            objPreparedStatement.setInt(4, objBeanActividades.getActividades());
            objPreparedStatement.setString(5, objBeanActividades.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                arreglo = objResultSet.getString("NTAREA_OPERATIVA_CODIGO") + "+++"
                        + objResultSet.getString("CUBIGEO_CODIGO") + "+++"
                        + objResultSet.getDouble("MONTO_ENERO_A") + "+++"
                        + objResultSet.getDouble("MONTO_FEBRERO_A") + "+++"
                        + objResultSet.getDouble("MONTO_MARZO_A") + "+++"
                        + objResultSet.getDouble("MONTO_ABRIL_A") + "+++"
                        + objResultSet.getDouble("MONTO_MAYO_A") + "+++"
                        + objResultSet.getDouble("MONTO_JUNIO_A") + "+++"
                        + objResultSet.getDouble("MONTO_JULIO_A") + "+++"
                        + objResultSet.getDouble("MONTO_AGOSTO_A") + "+++"
                        + objResultSet.getDouble("MONTO_SETIEMBRE_A") + "+++"
                        + objResultSet.getDouble("MONTO_OCTUBRE_A") + "+++"
                        + objResultSet.getDouble("MONTO_NOVIEMBRE_A") + "+++"
                        + objResultSet.getDouble("MONTO_DICIEMBRE_A") + "+++"
                        + objResultSet.getDouble("MONTO_ENERO_B") + "+++"
                        + objResultSet.getDouble("MONTO_FEBRERO_B") + "+++"
                        + objResultSet.getDouble("MONTO_MARZO_B") + "+++"
                        + objResultSet.getDouble("MONTO_ABRIL_B") + "+++"
                        + objResultSet.getDouble("MONTO_MAYO_B") + "+++"
                        + objResultSet.getDouble("MONTO_JUNIO_B") + "+++"
                        + objResultSet.getDouble("MONTO_JULIO_B") + "+++"
                        + objResultSet.getDouble("MONTO_AGOSTO_B") + "+++"
                        + objResultSet.getDouble("MONTO_SETIEMBRE_B") + "+++"
                        + objResultSet.getDouble("MONTO_OCTUBRE_B") + "+++"
                        + objResultSet.getDouble("MONTO_NOVIEMBRE_B") + "+++"
                        + objResultSet.getDouble("MONTO_DICIEMBRE_B") + "+++"
                        + objResultSet.getDouble("MONTO_ENERO_C") + "+++"
                        + objResultSet.getDouble("MONTO_FEBRERO_C") + "+++"
                        + objResultSet.getDouble("MONTO_MARZO_C") + "+++"
                        + objResultSet.getDouble("MONTO_ABRIL_C") + "+++"
                        + objResultSet.getDouble("MONTO_MAYO_C") + "+++"
                        + objResultSet.getDouble("MONTO_JUNIO_C") + "+++"
                        + objResultSet.getDouble("MONTO_JULIO_C") + "+++"
                        + objResultSet.getDouble("MONTO_AGOSTO_C") + "+++"
                        + objResultSet.getDouble("MONTO_SETIEMBRE_C") + "+++"
                        + objResultSet.getDouble("MONTO_OCTUBRE_C") + "+++"
                        + objResultSet.getDouble("MONTO_NOVIEMBRE_C") + "+++"
                        + objResultSet.getDouble("MONTO_DICIEMBRE_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_ENERO_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_FEBRERO_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_MARZO_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_ABRIL_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_MAYO_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_JUNIO_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_JULIO_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_AGOSTO_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_SETIEMBRE_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_OCTUBRE_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_NOVIEMBRE_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_DICIEMBRE_A") + "+++"
                        + objResultSet.getInt("CANTIDAD_ENERO_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_FEBRERO_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_MARZO_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_ABRIL_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_MAYO_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_JUNIO_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_JULIO_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_AGOSTO_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_SETIEMBRE_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_OCTUBRE_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_NOVIEMBRE_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_DICIEMBRE_B") + "+++"
                        + objResultSet.getInt("CANTIDAD_ENERO_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_FEBRERO_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_MARZO_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_ABRIL_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_MAYO_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_JUNIO_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_JULIO_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_AGOSTO_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_SETIEMBRE_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_OCTUBRE_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_NOVIEMBRE_C") + "+++"
                        + objResultSet.getInt("CANTIDAD_DICIEMBRE_C");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getActividadesOperativasDetalleDetalle(objBeanActividades) : " + e.getMessage());
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
        return arreglo;
    }

    @Override
    public int iduActividadesOperativas(BeanPlaneamiento objBeanActividades, String usuario) {
        sql = "{CALL SP_IDU_ACTIVIDADES_OPERATIVAS(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanActividades.getPeriodo());
            cs.setInt(2, objBeanActividades.getObjetivo());
            cs.setInt(3, objBeanActividades.getAcciones());
            cs.setString(4, objBeanActividades.getCodigo());
            cs.setString(5, objBeanActividades.getDescripcion());
            cs.setInt(6, objBeanActividades.getPrioridad());
            cs.setString(7, objBeanActividades.getCategoriaPresupuestal());
            cs.setString(8, objBeanActividades.getProducto());
            cs.setString(9, objBeanActividades.getActividad());
            cs.setString(10, objBeanActividades.getUnidadMedida());
            cs.setString(11, objBeanActividades.getEstado());
            cs.setString(12, usuario);
            cs.setString(13, objBeanActividades.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduActividadesOperativas : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_POI_ACTIVIDADES_OPERATIV");
            objBnMsgerr.setTipo(objBeanActividades.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduActividadesOperativasDetalle(BeanPlaneamiento objBeanActividades, String usuario) {
        sql = "{CALL SP_IDU_ACTIVIDADES_OPERATI_DET(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanActividades.getPeriodo());
            cs.setInt(2, objBeanActividades.getObjetivo());
            cs.setInt(3, objBeanActividades.getAcciones());
            cs.setInt(4, objBeanActividades.getActividades());
            cs.setString(5, objBeanActividades.getTareaOperativa());
            cs.setString(6, objBeanActividades.getUbigeo());
            cs.setString(7, objBeanActividades.getAnoRegistro());
            cs.setInt(8, objBeanActividades.getCantidadEnero());
            cs.setInt(9, objBeanActividades.getCantidadFebrero());
            cs.setInt(10, objBeanActividades.getCantidadMarzo());
            cs.setInt(11, objBeanActividades.getCantidadAbril());
            cs.setInt(12, objBeanActividades.getCantidadMayo());
            cs.setInt(13, objBeanActividades.getCantidadJunio());
            cs.setInt(14, objBeanActividades.getCantidadJulio());
            cs.setInt(15, objBeanActividades.getCantidadAgosto());
            cs.setInt(16, objBeanActividades.getCantidadSetiembre());
            cs.setInt(17, objBeanActividades.getCantidadOctubre());
            cs.setInt(18, objBeanActividades.getCantidadNoviembre());
            cs.setInt(19, objBeanActividades.getCantidadDiciembre());
            cs.setDouble(20, objBeanActividades.getMontoEnero());
            cs.setDouble(21, objBeanActividades.getMontoFebrero());
            cs.setDouble(22, objBeanActividades.getMontoMarzo());
            cs.setDouble(23, objBeanActividades.getMontoAbril());
            cs.setDouble(24, objBeanActividades.getMontoMayo());
            cs.setDouble(25, objBeanActividades.getMontoJunio());
            cs.setDouble(26, objBeanActividades.getMontoJulio());
            cs.setDouble(27, objBeanActividades.getMontoAgosto());
            cs.setDouble(28, objBeanActividades.getMontoSetiembre());
            cs.setDouble(29, objBeanActividades.getMontoOctubre());
            cs.setDouble(30, objBeanActividades.getMontoNoviembre());
            cs.setDouble(31, objBeanActividades.getMontoDiciembre());
            cs.setString(32, usuario);
            cs.setString(33, objBeanActividades.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduActividadesOperativasDetalle : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_POI_ACTIVIDADES_OPE_DETA");
            objBnMsgerr.setTipo(objBeanActividades.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }
}
