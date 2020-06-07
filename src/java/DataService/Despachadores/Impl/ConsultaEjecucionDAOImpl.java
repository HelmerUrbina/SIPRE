/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanCalendarioGastos;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPIMInforme;
import DataService.Despachadores.MsgerrDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;
import DataService.Despachadores.ConsultaEjecucionDAO;

/**
 *
 * @author H-URBINA-M
 */
public class ConsultaEjecucionDAOImpl implements ConsultaEjecucionDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPIMInforme objBnEjecucion;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;

    public ConsultaEjecucionDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaConsultaEjecucion(BeanPIMInforme objBeanEjecucionPresupuestal, String usuario) {
        lista = new LinkedList<>();
        String add = "";
        if (objBeanEjecucionPresupuestal.getPresupuesto().equals("0")) {
            objBeanEjecucionPresupuestal.setPresupuesto("%");
        }
        if (objBeanEjecucionPresupuestal.getTipoClasificador().equals("true")) {
            add = " AND UTIL_NEW.FUN_CODIGO_SECFUN(CODPER, COPPTO, SECFUN, 'CODACT') IN ('6000005','6000008') ";
        } else {
            if (objBeanEjecucionPresupuestal.getCategoriaPresupuestal().length() > 0) {
                add = " AND UTIL_NEW.FUN_CODIGO_SECFUN(CODPER, COPPTO, SECFUN, 'COPRES') IN (" + objBeanEjecucionPresupuestal.getCategoriaPresupuestal().replaceFirst(",", " ") + ") ";
                if (objBeanEjecucionPresupuestal.getProducto().length() > 0) {
                    add += " AND UTIL_NEW.FUN_CODIGO_SECFUN(CODPER, COPPTO, SECFUN, 'CODCOM') IN (" + objBeanEjecucionPresupuestal.getProducto().replaceFirst(",", " ") + ") ";
                }
            }
        }
        sql = "SELECT CODPER AS PERIODO, UTIL_NEW.FUN_ABPPTO(COPPTO) AS FUENTE_FINANCIAMIENTO, "
                + "COUUOO||':'||UTIL_NEW.FUN_ABUUOO(COUUOO) UNIDAD_OPERATIVA, "
                + "UTIL_NEW.FUN_PROGRAMA_SECFUN(CODPER, COPPTO, SECFUN) CATEGORIA_PRESUPUESTAL, "
                + "UTIL_NEW.FUN_PRODUCTO_SECFUN(CODPER, COPPTO, SECFUN) PRODUCTO, "
                + "UTIL_NEW.FUN_ACTIVIDAD_SECFUN(CODPER, COPPTO, SECFUN) ACTIVIDAD, "
                + "UTIL_NEW.FUN_NOM_FINALIDAD(CODPER, COPPTO, SECFUN) FINALIDAD, "
                + "SECFUN||':'||UTIL_NEW.FUN_DESMET(CODPER,COPPTO, SECFUN) SECUENCIA_FUNCIONAL, "
                + "COMEOP||':'||UTIL_NEW.FUN_NOMEOP(COMEOP) TAREA, "
                + "COCAGA||':'||UTIL.FUN_NOMBRE_CADGAS(COCAGA) CADENA_GASTO, "
                + "UTIL_NEW.FUN_NOMBRE_GENERICA_COCAGA(COCAGA) AS GENERICA_GASTO, "
                + "UTIL_NEW.FUN_NOMBRE_SUB_GENERICA_COCAGA(COCAGA) AS SUB_GENERICA, "
                + "UTIL_NEW.FUN_NOMBRE_SUB_GENE_DET_COCAGA(COCAGA) AS SUB_GENERICA_DETALLE, "
                + "SUM(PIA) AS PIA, SUM(PROGRAMADO) AS PROGRAMADO, SUM(CERTIFICADO) AS CERTIFICADO, "
                + "SUM(COMP_ANUAL) AS COMP_ANUAL, SUM(EJECUTADO) EJECUTADO "
                + "FROM V_PRG_EJE_ANUAL_RESOL WHERE "
                + "CODPER=? AND "
                + "COPPTO LIKE ?  "
                + add
                + "GROUP BY CODPER, COPPTO, COUUOO, CODGEN, SECFUN, COMEOP, COCAGA "
                + "HAVING SUM(PROGRAMADO)+SUM(PIA)>0 "
                + "ORDER BY COPPTO, COUUOO, CATEGORIA_PRESUPUESTAL, PRODUCTO, ACTIVIDAD, SECFUN, COMEOP, COCAGA";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEjecucion = new BeanPIMInforme();
                objBnEjecucion.setPeriodo(objResultSet.getString("PERIODO"));
                objBnEjecucion.setPresupuesto(objResultSet.getString("FUENTE_FINANCIAMIENTO"));
                objBnEjecucion.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnEjecucion.setCategoriaPresupuestal(objResultSet.getString("CATEGORIA_PRESUPUESTAL"));
                objBnEjecucion.setProducto(objResultSet.getString("PRODUCTO"));
                objBnEjecucion.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnEjecucion.setSecuencia(objResultSet.getString("SECUENCIA_FUNCIONAL"));
                objBnEjecucion.setFuncion(objResultSet.getString("FINALIDAD"));
                objBnEjecucion.setTarea(objResultSet.getString("TAREA"));
                objBnEjecucion.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnEjecucion.setGenericaGasto(objResultSet.getString("GENERICA_GASTO"));
                objBnEjecucion.setSubGenerica(objResultSet.getString("SUB_GENERICA"));
                objBnEjecucion.setSubGenericaDetalle(objResultSet.getString("SUB_GENERICA_DETALLE"));
                objBnEjecucion.setPIA(objResultSet.getDouble("PIA"));
                objBnEjecucion.setPIM(objResultSet.getDouble("PROGRAMADO"));
                objBnEjecucion.setCertificado(objResultSet.getDouble("CERTIFICADO"));
                objBnEjecucion.setNotaModificatoria(objResultSet.getDouble("COMP_ANUAL"));
                objBnEjecucion.setInforme(objResultSet.getDouble("EJECUTADO"));
                lista.add(objBnEjecucion);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaConsultaEjecucion(BeanEjecucionPresupuestal, " + usuario + ") : " + e.getMessage());
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

    @Override
    public List getListaConsultaAmigable(BeanPIMInforme objBeanEjecucionPresupuestal, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CODPER AS PERIODO, "
                + "PPTO||':'||UTIL_NEW.FUN_ABPPTO(PPTO) AS PRESUPUESTO, "
                + "COUUOO||':'||UTIL_NEW.FUN_NOMBRE_UNIDADES(COUUOO) AS UNIDAD_OPERATIVA, "
                + "LPAD(NRO_SIAF, 10, 0)||':'||UTIL_NEW.FUN_DOC_REF_SIAF(CODPER, LPAD(NRO_SIAF, 10, 0)) AS GLOSA, "
                + "UTIL_NEW.FUN_PROGRAMA_SECFUN(CODPER, PPTO, SECFUN) AS PROGRAMA,"
                + "UTIL_NEW.FUN_PRODUCTO_SECFUN(CODPER, PPTO, SECFUN) AS PRODUCTO, "
                + "UTIL_NEW.FUN_ACTIVIDAD_SECFUN(CODPER, PPTO, SECFUN) AS ACTIVIDAD, "
                + "SECFUN||':'||UTIL_NEW.FUN_DESMET(CODPER, PPTO, SECFUN) SECUENCIA_FUNCIONAL, "
                + "COCAGA||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(COCAGA) CADENA_GASTO, "
                + "UTIL_NEW.FUN_NOMBRE_GENERICA_COCAGA(COCAGA) AS GENERICA_GASTO, "
                + "UTIL_NEW.FUN_NOMBRE_SUB_GENERICA_COCAGA(COCAGA) AS SUB_GENERICA, "
                + "UTIL_NEW.FUN_NOMBRE_SUB_GENE_DET_COCAGA(COCAGA) AS SUB_GENERICA_DETALLE, "
                + "SUM(IMP_SIPE) AS COBERTURA, "
                + "SUM(IMP_COMPROMISO) AS COMPROMISO, "
                + "SUM(IMP_DEVENGADO) AS DEVENGADO, "
                + "SUM(IMP_GIRADO) AS GIRADO, "
                + "SUM(IMP_PAGADO) AS PAGADO "
                + "FROM V_AMIGABLE WHERE "
                + "CODPER LIKE ? AND  "
                + "PPTO LIKE ? AND "
                + "COUUOO LIKE ? AND "
                + "UPPER(NRO_SIAF) LIKE ? AND "
                + "UTIL_NEW.FUN_DOC_REF_SIAF(CODPER, LPAD(NRO_SIAF, 10, 0)) LIKE ? "
                + "GROUP BY CODPER, PPTO, COUUOO, NRO_SIAF, SECFUN, COCAGA "
                + "ORDER BY PERIODO, PRESUPUESTO, UNIDAD_OPERATIVA, GLOSA";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEjecucionPresupuestal.getPresupuesto());
            objPreparedStatement.setString(3, objBeanEjecucionPresupuestal.getUnidadOperativa());
            objPreparedStatement.setString(4, objBeanEjecucionPresupuestal.getTipoCalendario().replaceAll(" ", "%").toUpperCase());
            objPreparedStatement.setString(5, objBeanEjecucionPresupuestal.getTarea().replaceAll(" ", "%").toUpperCase());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEjecucion = new BeanPIMInforme();
                objBnEjecucion.setPeriodo(objResultSet.getString("PERIODO"));
                objBnEjecucion.setPresupuesto(objResultSet.getString("PRESUPUESTO"));
                objBnEjecucion.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnEjecucion.setDependencia(objResultSet.getString("GLOSA"));
                objBnEjecucion.setCategoriaPresupuestal(objResultSet.getString("PROGRAMA"));
                objBnEjecucion.setProducto(objResultSet.getString("PRODUCTO"));
                objBnEjecucion.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnEjecucion.setSecuencia(objResultSet.getString("SECUENCIA_FUNCIONAL"));
                objBnEjecucion.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnEjecucion.setGenericaGasto(objResultSet.getString("GENERICA_GASTO"));
                objBnEjecucion.setSubGenerica(objResultSet.getString("SUB_GENERICA"));
                objBnEjecucion.setSubGenericaDetalle(objResultSet.getString("SUB_GENERICA_DETALLE"));
                objBnEjecucion.setPIA(objResultSet.getDouble("COBERTURA"));
                objBnEjecucion.setPIM(objResultSet.getDouble("COMPROMISO"));
                objBnEjecucion.setCertificado(objResultSet.getDouble("DEVENGADO"));
                objBnEjecucion.setNotaModificatoria(objResultSet.getDouble("GIRADO"));
                objBnEjecucion.setInforme(objResultSet.getDouble("PAGADO"));
                lista.add(objBnEjecucion);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsultaAmigable(BeanEjecucionPresupuestal," + usuario + ") : " + e.getMessage());
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

    @Override
    public List getListaConsultaMensual(BeanCalendarioGastos objBeanEjecucionPresupuestal, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CODPER AS PERIODO, COUUOO||':'||UTIL_NEW.FUN_ABUUOO(COUUOO) UNIDAD_OPERATIVA, "
                + "CODDEP||':'||UTIL_NEW.FUN_ABRDEP(COUUOO, CODDEP) AS DEPENDENCIA, "
                + "UTIL_NEW.FUN_PRODUCTO_SECFUN(CODPER, COPPTO, SECFUN) PRODUCTO, "
                + "UTIL_NEW.FUN_ACTIVIDAD_SECFUN(CODPER, COPPTO, SECFUN) ACTIVIDAD, "
                + "SECFUN||':'||UTIL_NEW.FUN_DESMET(CODPER, COPPTO, SECFUN) SECUENCIA_FUNCIONAL, "
                + "COMEOP||':'||UTIL_NEW.FUN_NOMEOP(COMEOP) TAREA, "
                + "COCAGA||':'||UTIL.FUN_NOMBRE_CADGAS(COCAGA) CADENA_GASTO, "
                + "UTIL_NEW.FUN_NOMBRE_GENERICA_COCAGA(COCAGA) AS GENERICA_GASTO, "
                + "SUM(PIA) AS PIA, "
                + "SUM(PIM) AS PIM, "
                + "SUM(ENERO) AS ENERO, "
                + "SUM(FEBRERO) AS FEBRERO, "
                + "SUM(MARZO) AS MARZO, "
                + "SUM(ABRIL) AS ABRIL, "
                + "SUM(MAYO) AS MAYO, "
                + "SUM(JUNIO) AS JUNIO, "
                + "SUM(JULIO) AS JULIO, "
                + "SUM(AGOSTO) AS AGOSTO, "
                + "SUM(SETIEMBRE) AS SETIEMBRE, "
                + "SUM(OCTUBRE) AS OCTUBRE, "
                + "SUM(NOVIEMBRE) AS NOVIEMBRE, "
                + "SUM(DICIEMBRE) AS DICIEMBRE, "
                + "SUM(EJEC) AS EJECUTADO "
                + "FROM V_PIM_EJECUCION_MENSUAL WHERE "
                + "CODPER IN (?) AND "
                + "COPPTO=? AND "
                + "REGEXP_LIKE (COUUOO, ?) "
                + "GROUP BY CODPER, COPPTO, COUUOO, CODDEP, SECFUN, COMEOP, COCAGA "
                + "ORDER BY PERIODO, UNIDAD_OPERATIVA, DEPENDENCIA, PRODUCTO, ACTIVIDAD, SECUENCIA_FUNCIONAL, TAREA, CADENA_GASTO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionPresupuestal.getPeriodo().replaceFirst(",", " "));
            objPreparedStatement.setInt(2, objBeanEjecucionPresupuestal.getPresupuesto());
            objPreparedStatement.setString(3, objBeanEjecucionPresupuestal.getUnidadOperativa().replaceFirst("|", " "));
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                BeanCalendarioGastos objBnMensual = new BeanCalendarioGastos();
                objBnMensual.setPeriodo(objResultSet.getString("PERIODO"));
                objBnMensual.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnMensual.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnMensual.setProducto(objResultSet.getString("PRODUCTO"));
                objBnMensual.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnMensual.setSecuenciaFuncional(objResultSet.getString("SECUENCIA_FUNCIONAL"));
                objBnMensual.setTarea(objResultSet.getString("TAREA"));
                objBnMensual.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnMensual.setGenericaGasto(objResultSet.getString("GENERICA_GASTO"));
                objBnMensual.setProgramado(objResultSet.getDouble("PIA"));
                objBnMensual.setImporte(objResultSet.getDouble("PIM"));
                objBnMensual.setEnero(objResultSet.getDouble("ENERO"));
                objBnMensual.setFebrero(objResultSet.getDouble("FEBRERO"));
                objBnMensual.setMarzo(objResultSet.getDouble("MARZO"));
                objBnMensual.setAbril(objResultSet.getDouble("ABRIL"));
                objBnMensual.setMayo(objResultSet.getDouble("MAYO"));
                objBnMensual.setJunio(objResultSet.getDouble("JUNIO"));
                objBnMensual.setJulio(objResultSet.getDouble("JULIO"));
                objBnMensual.setAgosto(objResultSet.getDouble("AGOSTO"));
                objBnMensual.setSetiembre(objResultSet.getDouble("SETIEMBRE"));
                objBnMensual.setOctubre(objResultSet.getDouble("OCTUBRE"));
                objBnMensual.setNoviembre(objResultSet.getDouble("NOVIEMBRE"));
                objBnMensual.setDiciembre(objResultSet.getDouble("DICIEMBRE"));
                objBnMensual.setTotal(objResultSet.getDouble("EJECUTADO"));
                lista.add(objBnMensual);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaConsultaMensual(BeanCalendarioGastos, " + usuario + ") : " + e.getMessage());
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
