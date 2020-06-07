/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPIMInforme;
import DataService.Despachadores.MsgerrDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;
import DataService.Despachadores.ConsultaProgramacionDAO;

/**
 *
 * @author H-URBINA-M
 */
public class ConsultaProgramacionDAOImpl implements ConsultaProgramacionDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPIMInforme objBnEjecucion;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;

    public ConsultaProgramacionDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaConsultaEjecucion(BeanPIMInforme objBeanEjecucionPresupuestal, String usuario) {
        lista = new LinkedList<>();
        String add = "";

        if (objBeanEjecucionPresupuestal.getCategoriaPresupuestal().length() > 0) {
            add = "COMEOP IN (" + objBeanEjecucionPresupuestal.getTarea() + ") ";
            if (objBeanEjecucionPresupuestal.getProducto().length() > 0) {
                add += "AND UTIL_NEW.FUN_CODIGO_SECFUN(CODPER, COPPTO, SECFUN, 'CODCOM') IN (" + objBeanEjecucionPresupuestal.getProducto().replaceFirst(",", " ") + ") ";
            }
        } else {
            if (objBeanEjecucionPresupuestal.getProducto().length() > 0) {
                add += "UTIL_NEW.FUN_CODIGO_SECFUN(CODPER, COPPTO, SECFUN, 'CODCOM') IN (" + objBeanEjecucionPresupuestal.getProducto().replaceFirst(",", " ") + ") ";
            }
        }
        sql = "SELECT CODPER AS PERIODO, "
                + "COUUOO||':'||UTIL_NEW.FUN_ABUUOO(COUUOO) UNIDAD_OPERATIVA, "
                + "CODDEP||':'||UTIL_NEW.FUN_ABRDEP(COUUOO,CODDEP) AS DEPENDENCIA, "
                + "UTIL_NEW.FUN_PRODUCTO_SECFUN(CODPER, COPPTO, SECFUN) PRODUCTO, "
                + "UTIL_NEW.FUN_ACTIVIDAD_SECFUN(CODPER, COPPTO, SECFUN) ACTIVIDAD, "
                + "COMEOP||':'||UTIL_NEW.FUN_NOMEOP(COMEOP) TAREA, "
                + "COCAGA||':'||UTIL.FUN_NOMBRE_CADGAS(COCAGA) CADENA_GASTO, "
                + "UTIL_NEW.FUN_NOMBRE_GENERICA_COCAGA(COCAGA) AS GENERICA_GASTO, "
                + "UTIL_NEW.FUN_NOMBRE_SUB_GENERICA_COCAGA(COCAGA) AS SUB_GENERICA, "
                + "UTIL_NEW.FUN_NOMBRE_SUB_GENE_DET_COCAGA(COCAGA) AS SUB_GENERICA_DETALLE, "
                + "SUM(PIA) AS PIA, SUM(PROGRAMADO) AS PIM, SUM(EJECUTADO) EJECUTADO "
                + "FROM V_PRG_EJE_ANUAL_RESOL WHERE "
                + add
                + "GROUP BY CODPER, COPPTO, COUUOO, CODDEP, SECFUN, COMEOP, COCAGA "
                + "HAVING (SUM(PIA) + SUM(PROGRAMADO))>0 "
                + "ORDER BY PERIODO, UNIDAD_OPERATIVA, DEPENDENCIA, PRODUCTO, ACTIVIDAD, TAREA, CADENA_GASTO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEjecucion = new BeanPIMInforme();
                objBnEjecucion.setPeriodo(objResultSet.getString("PERIODO"));
                objBnEjecucion.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnEjecucion.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnEjecucion.setProducto(objResultSet.getString("PRODUCTO"));
                objBnEjecucion.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnEjecucion.setTarea(objResultSet.getString("TAREA"));
                objBnEjecucion.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnEjecucion.setGenericaGasto(objResultSet.getString("GENERICA_GASTO"));
                objBnEjecucion.setSubGenerica(objResultSet.getString("SUB_GENERICA"));
                objBnEjecucion.setSubGenericaDetalle(objResultSet.getString("SUB_GENERICA_DETALLE"));
                objBnEjecucion.setPIA(objResultSet.getDouble("PIA"));
                objBnEjecucion.setPIM(objResultSet.getDouble("PIM"));
                objBnEjecucion.setInforme(objResultSet.getDouble("EJECUTADO"));
                lista.add(objBnEjecucion);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaConsultaEjecucion(BeanEjecucionPresupuestal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("CADGAS");
            objBnMsgerr.setTipo("G");
            objBnMsgerr.setDescripcion(e.getMessage());
            int s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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

}
