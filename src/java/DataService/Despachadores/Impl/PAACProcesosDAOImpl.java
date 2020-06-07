/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPAACProcesos;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PAACProcesosDAO;
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
public class PAACProcesosDAOImpl implements PAACProcesosDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPAACProcesos objBnPAACProcesos;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public PAACProcesosDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaPAACProcesos(BeanPAACProcesos objBeanPAACProcesos, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NPAAC_PROCESOS_CODIGO AS CODIGO, NVL(REPLACE(UPPER(VPAAC_PROCESOS_NUMERO_PAAC),'NULL',''),' ') AS PAAC, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VPAAC_PROCESOS_DESCRIPCION),'[^A-Za-z0-9ÁÉÍÓÚáéíóú ]', ''),'\n"
                + "', ' ')  AS DESCRIPCION, NPAAC_PROCESOS_MONTO_PROCESO AS MONTO_PROCESO, NPAAC_PROCESOS_CERTIFICADO AS CERTIFICADO, "
                + "CASE CPAAC_PROCESOS_ACOMPRAS WHEN '1' THEN 'SI' WHEN '0' THEN 'NO' ELSE 'VERIFICA' END AS COMPRA, "
                + "CASE CPAAC_PROCESOS_VERIFICACION WHEN 'S' THEN 'true' ELSE 'false' END AS OPRE, "
                + "NTIPO_PROCESO_CONTRATACION_COD, NPROCESO_DOCUMENTO_CODIGO, "
                + "PK_LOGISTICA.FUN_NOMBRE_TIPO_PROCESO_CONTRA(NTIPO_PROCESO_CONTRATACION_COD) AS TIPO_PROCESO_CONTRATACION, "
                + "PK_LOGISTICA.FUN_NOMBRE_PROCESO_ETAPA(NTIPO_PROCESO_CONTRATACION_COD, NPROCESO_ETAPA_CODIGO) AS PROCESO_ETAPA,"
                + "PK_LOGISTICA.FUN_NOMBRE_PROCESO_DOCUMENTO(NPROCESO_DOCUMENTO_CODIGO) AS PROCESO_DOCUMENTO,"
                + "PK_LOGISTICA.FUN_NOMBRE_TIPO_PROCEDIMIENTO(CTIPO_PROCEDIMIENTO_CODIGO) AS TIPO_PROCEDIMIENTO, "
                + "NPAAC_PROCESOS_MONTO_CONTRATO AS MONTO_CONTRATO, "
                + "UTIL_NEW.FUN_SOLICITUD_CREDITO_SIAF(CPERIODO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, NPAAC_PROCESOS_CERTIFICADO) AS SOLICITUD_CREDITO, "
                + "PK_LOGISTICA.FUN_PROCESO_MENSUALIZACION(CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, NPAAC_PROCESOS_CODIGO) AS MENSUALIZADO "
                + "FROM SIPRE_PAAC_PROCESOS WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "CESTADO_CODIGO='AC' "
                + "ORDER BY CODIGO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPAACProcesos.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPAACProcesos.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPAACProcesos.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnPAACProcesos = new BeanPAACProcesos();
                objBnPAACProcesos.setCodigo(objResultSet.getInt("CODIGO"));
                objBnPAACProcesos.setNumeroPAAC(objResultSet.getString("PAAC"));
                objBnPAACProcesos.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnPAACProcesos.setMontoProceso(objResultSet.getDouble("MONTO_PROCESO"));
                objBnPAACProcesos.setCertificado(objResultSet.getString("CERTIFICADO"));
                objBnPAACProcesos.setCompras(objResultSet.getString("COMPRA"));
                objBnPAACProcesos.setEstado(objResultSet.getString("OPRE"));
                objBnPAACProcesos.setPeriodo(objResultSet.getString("NTIPO_PROCESO_CONTRATACION_COD"));
                objBnPAACProcesos.setPresupuesto(objResultSet.getInt("NPROCESO_DOCUMENTO_CODIGO"));
                objBnPAACProcesos.setTipoProcesoContratacion(objResultSet.getString("TIPO_PROCESO_CONTRATACION"));
                objBnPAACProcesos.setProcesoEtapa(objResultSet.getString("PROCESO_ETAPA"));
                objBnPAACProcesos.setProcesoDocumento(objResultSet.getString("PROCESO_DOCUMENTO"));
                objBnPAACProcesos.setTipoProcedimiento(objResultSet.getString("TIPO_PROCEDIMIENTO"));
                objBnPAACProcesos.setMontoContrato(objResultSet.getDouble("MONTO_CONTRATO"));
                objBnPAACProcesos.setDependencia(objResultSet.getString("SOLICITUD_CREDITO"));
                objBnPAACProcesos.setEnero(objResultSet.getDouble("MENSUALIZADO"));
                lista.add(objBnPAACProcesos);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPAACProcesos(objBeanPAACProcesos) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PAAC_PROCESOS");
            objBnMsgerr.setTipo(objBeanPAACProcesos.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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
    public ArrayList getListaPAACProcesosDetalle(BeanPAACProcesos objBeanPAACProcesos, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT NPAAC_PROCESOS_DETALLE AS DETALLE, "
                + "NVL(UTIL_NEW.FUN_DOCUMENTO_COMPROMISO(CPERIODO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, NPRESUPUESTO_CODIGO, VPAAC_PROCESOS_COMPROMISO),'SIN COMPROMISO') AS COMPROMISO, "
                + "VPAAC_PROCESOS_NUMERO_CONTRATO AS NUMERO_CONTRATO, NPAAC_PROCESOS_MONTO_CONTRATO AS MONTO_CONTRATO, "
                + "CSECUENCIA_FUNCIONAL_CODIGO||':'||UTIL_NEW.FUN_DESMET(CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) AS SECUENCIA_FUNCIONAL, "
                + "CTAREA_PRESUPUESTAL_CODIGO||':'||UTIL_NEW.FUN_NTAREA(CTAREA_PRESUPUESTAL_CODIGO) AS TAREA_PRESUPUESTAL, "
                + "VCADENA_GASTO_CODIGO||':'||UTIL_NEW.FUN_NOCLAS(VCADENA_GASTO_CODIGO) AS CADENA_GASTO, "
                + "UTIL_NEW.FUN_ABRDEP(CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA  "
                + "FROM SIPRE_PAAC_PROCESOS_DETALLE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPAAC_PROCESOS_CODIGO=?  AND "
                + "CESTADO_CODIGO='AC' "
                + "ORDER BY DETALLE";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPAACProcesos.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPAACProcesos.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPAACProcesos.getUnidadOperativa());
            objPreparedStatement.setInt(4, objBeanPAACProcesos.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("DETALLE") + "+++"
                        + objResultSet.getString("COMPROMISO") + "+++"
                        + objResultSet.getString("NUMERO_CONTRATO") + "+++"
                        + objResultSet.getDouble("MONTO_CONTRATO") + "+++"
                        + objResultSet.getString("SECUENCIA_FUNCIONAL") + "+++"
                        + objResultSet.getString("TAREA_PRESUPUESTAL") + "+++"
                        + objResultSet.getString("CADENA_GASTO") + "+++"
                        + objResultSet.getString("DEPENDENCIA");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPAACProcesosDetalle(BeanPAACProcesos) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PAAC_PROCESOS");
            objBnMsgerr.setTipo(objBeanPAACProcesos.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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
    public ArrayList getListaPAACProcesosAfectacion(BeanPAACProcesos objBeanPAACProcesos, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT NPAAC_PROCESOS_AFECTACION AS DETALLE, "
                + "UTIL_NEW.FUN_ABRDEP(CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "CSECUENCIA_FUNCIONAL_CODIGO||'-'||UTIL_NEW.FUN_DESMET(CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) AS SECUENCIA_FUNCIONAL, "
                + "CTAREA_PRESUPUESTAL_CODIGO||'-'||UTIL_NEW.FUN_NTAREA(CTAREA_PRESUPUESTAL_CODIGO) AS TAREA_PRESUPUESTAL, "
                + "VCADENA_GASTO_CODIGO||'-'||UTIL_NEW.FUN_NOCLAS(VCADENA_GASTO_CODIGO) AS CADENA_GASTO, NPAAC_PROCESOS_AFECTACION_IMPO AS IMPORTE, "
                + "NTIPO_CALENDARIO_CODIGO||':'||UTIL_NEW.FUN_DESTIP(NTIPO_CALENDARIO_CODIGO, NPRESUPUESTO_CODIGO) AS TIPO_CALENDARIO "
                + "FROM SIPRE_PAAC_PROCESOS_AFECTACION WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPAAC_PROCESOS_CODIGO=? "
                + "ORDER BY DETALLE";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPAACProcesos.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPAACProcesos.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPAACProcesos.getUnidadOperativa());
            objPreparedStatement.setInt(4, objBeanPAACProcesos.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("DETALLE") + "+++"
                        + objResultSet.getString("DEPENDENCIA") + "+++"
                        + objResultSet.getString("SECUENCIA_FUNCIONAL") + "+++"
                        + objResultSet.getString("TAREA_PRESUPUESTAL") + "+++"
                        + objResultSet.getString("CADENA_GASTO") + "+++"
                        + objResultSet.getDouble("IMPORTE") + "+++"
                        + objResultSet.getString("TIPO_CALENDARIO");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPAACProcesosAfectacion(BeanPAACProcesos) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PAAC_PROCESOS");
            objBnMsgerr.setTipo(objBeanPAACProcesos.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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
    public BeanPAACProcesos getPAACProceso(BeanPAACProcesos objBeanPAACProcesos, String usuario) {
        sql = "SELECT VPAAC_PROCESOS_NUMERO_PAAC AS PAAC, NTIPO_PROCESO_CONTRATACION_COD TIPO_CONTRATACION,"
                + "NPROCESO_ETAPA_CODIGO PROCESO_ETAPA, NPROCESO_DOCUMENTO_CODIGO AS PROCESO_DOCUMENTO,"
                + "CTIPO_PROCEDIMIENTO_CODIGO AS TIPO_PROCEDIMIENTO, VPAAC_PROCESOS_NUMERO_PROCESO AS NUMERO_PROCESO, "
                + "VPAAC_PROCESOS_DESCRIPCION AS DESCRIPCION, NPAAC_PROCESOS_MONTO_PROCESO AS MONTO_PROCESO, "
                + "DPAAC_PROCESOS_CONVOCATORIA AS CONVOCATORIA, DPAAC_PROCESOS_PARTICIPANTES AS PARTICIPANTES, "
                + "DPAAC_PROCESOS_OBSERVACIONES AS OBERVACIONES, DPAAC_PROCESOS_ABSOLUCION AS ABSOLUCION, "
                + "DPAAC_PROCESOS_INTEGRACION AS INTEGRACION, DPAAC_PROCESOS_OFERTAS AS OFERTAS, "
                + "DPAAC_PROCESOS_EVALUACION AS EVALUACION, DPAAC_PROCESOS_BUENA_PRO AS BUENA_PRO, "
                + "DPAAC_PROCESOS_CONSENTIMIENTO AS CONSENTIMIENTO, DPAAC_PROCESOS_CONTRATO AS CONTRATO, "
                + "NPAAC_PROCESOS_MONTO_CONTRATO AS MONTO_CONTRATO, CPAAC_PROCESOS_ACOMPRAS AS COMPRAS "
                + "FROM SIPRE_PAAC_PROCESOS WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPAAC_PROCESOS_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPAACProcesos.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPAACProcesos.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPAACProcesos.getUnidadOperativa());
            objPreparedStatement.setInt(4, objBeanPAACProcesos.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanPAACProcesos.setNumeroPAAC(objResultSet.getString("PAAC"));
                objBeanPAACProcesos.setTipoProcesoContratacion(objResultSet.getString("TIPO_CONTRATACION"));
                objBeanPAACProcesos.setProcesoEtapa(objResultSet.getString("PROCESO_ETAPA"));
                objBeanPAACProcesos.setProcesoDocumento(objResultSet.getString("PROCESO_DOCUMENTO"));
                objBeanPAACProcesos.setTipoProcedimiento(objResultSet.getString("TIPO_PROCEDIMIENTO"));
                objBeanPAACProcesos.setNumeroProceso(objResultSet.getString("NUMERO_PROCESO"));
                objBeanPAACProcesos.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBeanPAACProcesos.setMontoProceso(objResultSet.getDouble("MONTO_PROCESO"));
                objBeanPAACProcesos.setConvocatoria(objResultSet.getDate("CONVOCATORIA"));
                objBeanPAACProcesos.setParticipantes(objResultSet.getDate("PARTICIPANTES"));
                objBeanPAACProcesos.setObservaciones(objResultSet.getDate("OBERVACIONES"));
                objBeanPAACProcesos.setAbsolucion(objResultSet.getDate("ABSOLUCION"));
                objBeanPAACProcesos.setIntegracion(objResultSet.getDate("INTEGRACION"));
                objBeanPAACProcesos.setOfertas(objResultSet.getDate("OFERTAS"));
                objBeanPAACProcesos.setEvaluacion(objResultSet.getDate("EVALUACION"));
                objBeanPAACProcesos.setBuenaPro(objResultSet.getDate("BUENA_PRO"));
                objBeanPAACProcesos.setConsentimiento(objResultSet.getDate("CONSENTIMIENTO"));
                objBeanPAACProcesos.setContrato(objResultSet.getDate("CONTRATO"));
                objBeanPAACProcesos.setMontoContrato(objResultSet.getDouble("MONTO_CONTRATO"));
                objBeanPAACProcesos.setCompras(objResultSet.getString("COMPRAS"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPAACProceso(objBeanPAACProcesos) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PAAC_PROCESOS");
            objBnMsgerr.setTipo(objBeanPAACProcesos.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
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
        return objBeanPAACProcesos;
    }

    @Override
    public BeanPAACProcesos getPAACProcesoDetalle(BeanPAACProcesos objBeanPAACProcesos, String usuario) {
        sql = "SELECT VPAAC_PROCESOS_COMPROMISO, VPAAC_PROCESOS_NUMERO_CONTRATO , NPAAC_PROCESOS_MONTO_CONTRATO, "
                + "DPAAC_PROCESOS_FECHA_INICIO, DPAAC_PROCESOS_FECHA_FIN, NPAAC_PROCESOS_ACUMULADO, NPAAC_PROCESOS_PENDIENTE, "
                + "NPAAC_PROCESOS_ENERO, NPAAC_PROCESOS_FEBRERO, NPAAC_PROCESOS_MARZO, NPAAC_PROCESOS_ABRIL, "
                + "NPAAC_PROCESOS_MAYO, NPAAC_PROCESOS_JUNIO, NPAAC_PROCESOS_JULIO, NPAAC_PROCESOS_AGOSTO, "
                + "NPAAC_PROCESOS_SETIEMBRE, NPAAC_PROCESOS_OCTUBRE, NPAAC_PROCESOS_NOVIEMBRE, NPAAC_PROCESOS_DICIEMBRE "
                + "FROM SIPRE_PAAC_PROCESOS_DETALLE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPAAC_PROCESOS_CODIGO=? AND "
                + "NPAAC_PROCESOS_DETALLE=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPAACProcesos.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPAACProcesos.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPAACProcesos.getUnidadOperativa());
            objPreparedStatement.setInt(4, objBeanPAACProcesos.getCodigo());
            objPreparedStatement.setInt(5, objBeanPAACProcesos.getDetalle());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanPAACProcesos.setCertificado(objResultSet.getString("VPAAC_PROCESOS_COMPROMISO"));
                objBeanPAACProcesos.setNumeroContrato(objResultSet.getString("VPAAC_PROCESOS_NUMERO_CONTRATO"));
                objBeanPAACProcesos.setMontoContrato(objResultSet.getDouble("NPAAC_PROCESOS_MONTO_CONTRATO"));
                objBeanPAACProcesos.setFechaInicio(objResultSet.getDate("DPAAC_PROCESOS_FECHA_INICIO"));
                objBeanPAACProcesos.setFechaFin(objResultSet.getDate("DPAAC_PROCESOS_FECHA_FIN"));
                objBeanPAACProcesos.setAcumulado(objResultSet.getDouble("NPAAC_PROCESOS_ACUMULADO"));
                objBeanPAACProcesos.setPendiente(objResultSet.getDouble("NPAAC_PROCESOS_PENDIENTE"));
                objBeanPAACProcesos.setEnero(objResultSet.getDouble("NPAAC_PROCESOS_ENERO"));
                objBeanPAACProcesos.setFebrero(objResultSet.getDouble("NPAAC_PROCESOS_FEBRERO"));
                objBeanPAACProcesos.setMarzo(objResultSet.getDouble("NPAAC_PROCESOS_MARZO"));
                objBeanPAACProcesos.setAbril(objResultSet.getDouble("NPAAC_PROCESOS_ABRIL"));
                objBeanPAACProcesos.setMayo(objResultSet.getDouble("NPAAC_PROCESOS_MAYO"));
                objBeanPAACProcesos.setJunio(objResultSet.getDouble("NPAAC_PROCESOS_JUNIO"));
                objBeanPAACProcesos.setJulio(objResultSet.getDouble("NPAAC_PROCESOS_JULIO"));
                objBeanPAACProcesos.setAgosto(objResultSet.getDouble("NPAAC_PROCESOS_AGOSTO"));
                objBeanPAACProcesos.setSetiembre(objResultSet.getDouble("NPAAC_PROCESOS_SETIEMBRE"));
                objBeanPAACProcesos.setOctubre(objResultSet.getDouble("NPAAC_PROCESOS_OCTUBRE"));
                objBeanPAACProcesos.setNoviembre(objResultSet.getDouble("NPAAC_PROCESOS_NOVIEMBRE"));
                objBeanPAACProcesos.setDiciembre(objResultSet.getDouble("NPAAC_PROCESOS_DICIEMBRE"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPAACProcesoDetalle(objBeanPAACProcesos) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PAAC_PROCESOS");
            objBnMsgerr.setTipo(objBeanPAACProcesos.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
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
        return objBeanPAACProcesos;
    }

    @Override
    public int iduPAACProcesos(BeanPAACProcesos objBeanEvento, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_PAAC_PROCESOS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEvento.getPeriodo());
            cs.setInt(2, objBeanEvento.getPresupuesto());
            cs.setString(3, objBeanEvento.getUnidadOperativa());
            cs.setInt(4, objBeanEvento.getCodigo());
            cs.setString(5, objBeanEvento.getNumeroPAAC());
            cs.setInt(6, Utiles.Utiles.checkNum(objBeanEvento.getTipoProcesoContratacion()));
            cs.setInt(7, Utiles.Utiles.checkNum(objBeanEvento.getProcesoEtapa()));
            cs.setInt(8, Utiles.Utiles.checkNum(objBeanEvento.getProcesoDocumento()));
            cs.setString(9, objBeanEvento.getTipoProcedimiento());
            cs.setString(10, objBeanEvento.getDescripcion());
            cs.setString(11, objBeanEvento.getNumeroProceso());
            cs.setDouble(12, objBeanEvento.getMontoProceso());
            cs.setString(13, objBeanEvento.getCompras());
            cs.setString(14, objBeanEvento.getCertificado());
            cs.setDate(15, objBeanEvento.getConvocatoria());
            cs.setDate(16, objBeanEvento.getParticipantes());
            cs.setDate(17, objBeanEvento.getObservaciones());
            cs.setDate(18, objBeanEvento.getAbsolucion());
            cs.setDate(19, objBeanEvento.getIntegracion());
            cs.setDate(20, objBeanEvento.getOfertas());
            cs.setDate(21, objBeanEvento.getEvaluacion());
            cs.setDate(22, objBeanEvento.getBuenaPro());
            cs.setDate(23, objBeanEvento.getConsentimiento());
            cs.setDate(24, objBeanEvento.getContrato());
            cs.setDouble(25, objBeanEvento.getMontoContrato());
            cs.setString(26, usuario);
            cs.setString(27, objBeanEvento.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPAACProcesos : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PAAC_PROCESOS");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduPAACProcesosDetalle(BeanPAACProcesos objBeanEvento, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_PAAC_PROCESOS_DETALLE(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEvento.getPeriodo());
            cs.setInt(2, objBeanEvento.getPresupuesto());
            cs.setString(3, objBeanEvento.getUnidadOperativa());
            cs.setInt(4, objBeanEvento.getCodigo());
            cs.setInt(5, objBeanEvento.getDetalle());
            cs.setString(6, objBeanEvento.getCertificado());
            cs.setString(7, objBeanEvento.getNumeroContrato());
            cs.setDouble(8, objBeanEvento.getMontoContrato());
            cs.setDate(9, objBeanEvento.getFechaInicio());
            cs.setDate(10, objBeanEvento.getFechaFin());
            cs.setDouble(11, objBeanEvento.getAcumulado());
            cs.setDouble(12, objBeanEvento.getPendiente());
            cs.setDouble(13, objBeanEvento.getEnero());
            cs.setDouble(14, objBeanEvento.getFebrero());
            cs.setDouble(15, objBeanEvento.getMarzo());
            cs.setDouble(16, objBeanEvento.getAbril());
            cs.setDouble(17, objBeanEvento.getMayo());
            cs.setDouble(18, objBeanEvento.getJunio());
            cs.setDouble(19, objBeanEvento.getJulio());
            cs.setDouble(20, objBeanEvento.getAgosto());
            cs.setDouble(21, objBeanEvento.getSetiembre());
            cs.setDouble(22, objBeanEvento.getOctubre());
            cs.setDouble(23, objBeanEvento.getNoviembre());
            cs.setDouble(24, objBeanEvento.getDiciembre());
            cs.setString(25, usuario);
            cs.setString(26, objBeanEvento.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPAACProcesosDetalle : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PAAC_PROCESOS_DETALLE");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduPAACProcesosAfectacion(BeanPAACProcesos objBeanEvento, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_PAAC_PROCESOS_AFECTACIO(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEvento.getPeriodo());
            cs.setInt(2, objBeanEvento.getPresupuesto());
            cs.setString(3, objBeanEvento.getUnidadOperativa());
            cs.setInt(4, objBeanEvento.getCodigo());
            cs.setInt(5, objBeanEvento.getDetalle());
            cs.setString(6, objBeanEvento.getTipoCalendario());
            cs.setString(7, objBeanEvento.getResolucion());
            cs.setString(8, objBeanEvento.getDependencia());
            cs.setString(9, objBeanEvento.getSecuenciaFuncional());
            cs.setString(10, objBeanEvento.getTareaPresupuestal());
            cs.setString(11, objBeanEvento.getCadenaGasto());
            cs.setDouble(12, objBeanEvento.getMontoProceso());
            cs.setDouble(13, objBeanEvento.getEnero());
            cs.setDouble(14, objBeanEvento.getFebrero());
            cs.setDouble(15, objBeanEvento.getMarzo());
            cs.setDouble(16, objBeanEvento.getAbril());
            cs.setDouble(17, objBeanEvento.getMayo());
            cs.setDouble(18, objBeanEvento.getJunio());
            cs.setDouble(19, objBeanEvento.getJulio());
            cs.setDouble(20, objBeanEvento.getAgosto());
            cs.setDouble(21, objBeanEvento.getSetiembre());
            cs.setDouble(22, objBeanEvento.getOctubre());
            cs.setDouble(23, objBeanEvento.getNoviembre());
            cs.setDouble(24, objBeanEvento.getDiciembre());
            cs.setString(25, usuario);
            cs.setString(26, objBeanEvento.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPAACProcesosAfectacion : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PAAC_PROCESOS_AFECTACION");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduPAACProcesosDetalleContratoAfectacion(BeanPAACProcesos objBeanEvento, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_PAAC_PROCESOS_DET_AFECT(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEvento.getPeriodo());
            cs.setInt(2, objBeanEvento.getPresupuesto());
            cs.setString(3, objBeanEvento.getUnidadOperativa());
            cs.setInt(4, objBeanEvento.getCodigo());
            cs.setInt(5, objBeanEvento.getDetalle());
            cs.setString(6, objBeanEvento.getTipoCalendario());
            cs.setString(7, objBeanEvento.getResolucion());
            cs.setString(8, objBeanEvento.getDependencia());
            cs.setString(9, objBeanEvento.getSecuenciaFuncional());
            cs.setString(10, objBeanEvento.getTareaPresupuestal());
            cs.setString(11, objBeanEvento.getCadenaGasto());
            cs.setString(12, usuario);
            cs.setString(13, objBeanEvento.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPAACProcesosDetalleContratoAfectacion : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PAAC_PROCESOS_DETALLE");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
