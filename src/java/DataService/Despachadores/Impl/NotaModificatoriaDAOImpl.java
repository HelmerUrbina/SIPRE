/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanNotaModificatoria;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.NotaModificatoriaDAO;
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
public class NotaModificatoriaDAOImpl implements NotaModificatoriaDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanNotaModificatoria objBnNotaModificatoria;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public NotaModificatoriaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaNotasModificatorias(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NNOTA_MODIFICATORIA_CODIGO AS CODIGO, "
                + "UTIL_NEW.FUN_NOMBRE_NOTA_MODIFICATORIA(CTIPO_NOTA_MODIFICATORIA_CODIG) AS TIPO, "
                + "OPRE_NEW.FUN_TOTAL_DETALLE_NOTA(CPERIODO_CODIGO,CUNIDAD_OPERATIVA_CODIGO,NNOTA_MODIFICATORIA_CODIGO,'C') AS IMP_CREDITO, "
                + "OPRE_NEW.FUN_TOTAL_DETALLE_NOTA(CPERIODO_CODIGO,CUNIDAD_OPERATIVA_CODIGO,NNOTA_MODIFICATORIA_CODIGO,'A') AS IMP_ANULACION, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VNOTA_MODIFICATORIA_JUSTIFICAC),'[^A-Za-z0-9ÁÉÍÓÚáéíóú ]', ''),'\n"
                + "', ' ') AS JUSTIFICACION, "
                + "DNOTA_MODIFICATORIA_FECHA AS FECHA_NOTA, "
                + "LOGISTICA.FUN_NOMBRE_ESTADO(CNOTA_MODIFICATORIA_ESTADO) AS ESTADO, "
                + "NVL(UTIL_NEW.FUN_DESC_USUARIO(VUSUARIO_TERMINA),'--') AS USU_CERRAR, "
                + "DUSUARIO_TERMINA AS FECHA_CERRAR, "
                + "NVL(UTIL_NEW.FUN_DESC_USUARIO(VUSUARIO_VERIFICA),'--') AS USU_VERIFICA, "
                + "DUSUARIO_VERIFICA AS FECHA_VERIFICA, "
                + "NVL(UTIL_NEW.FUN_DESC_USUARIO(VUSUARIO_ENVIO),'--') AS USU_APRUEBA, "
                + "DNOTA_MODIFICATORIA_ENVIO AS FECHA_APRUEBA, "
                + "NVL(UTIL_NEW.FUN_DESC_USUARIO(VUSUARIO_RECHAZO),'--') AS USU_RECHAZO, "
                + "DUSUARIO_RECHAZO AS FECHA_RECHAZO, "
                + "VRECHAZO_JUSTIFICA, VNOTA_MODIFICATORIA_ARCHIVO, "
                + "UTIL_NEW.FUN_NUMERO_SIAF(CPERIODO_CODIGO, CNOTA_CONSOLIDADO_CODIGO) AS NUM_SIAF,"
                + "CNOTA_CONSOLIDADO_CODIGO AS NUM_CONSOLIDADO "
                + "FROM SIPE_NOTA_MODIFICATORIA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "CMES_CODIGO=? "
                + "ORDER BY CODIGO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getUnidadOperativa());
            objPreparedStatement.setString(3, objBeanNotaModificatoria.getMes());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnNotaModificatoria = new BeanNotaModificatoria();
                objBnNotaModificatoria.setCodigo(objResultSet.getString("CODIGO"));
                objBnNotaModificatoria.setTipo(objResultSet.getString("TIPO"));
                objBnNotaModificatoria.setImporteCredito(objResultSet.getDouble("IMP_CREDITO"));
                objBnNotaModificatoria.setImporteAnulacion(objResultSet.getDouble("IMP_ANULACION"));
                objBnNotaModificatoria.setJustificacion(objResultSet.getString("JUSTIFICACION"));
                objBnNotaModificatoria.setFecha(objResultSet.getDate("FECHA_NOTA"));
                objBnNotaModificatoria.setEstado(objResultSet.getString("ESTADO"));
                objBnNotaModificatoria.setUsuarioCierre(objResultSet.getString("USU_CERRAR"));
                objBnNotaModificatoria.setFechaCierre(objResultSet.getDate("FECHA_CERRAR"));
                objBnNotaModificatoria.setUsuarioVerifica(objResultSet.getString("USU_VERIFICA"));
                objBnNotaModificatoria.setFechaVerifica(objResultSet.getDate("FECHA_VERIFICA"));
                objBnNotaModificatoria.setUsuarioAprobacion(objResultSet.getString("USU_APRUEBA"));
                objBnNotaModificatoria.setFechaAprobacion(objResultSet.getDate("FECHA_APRUEBA"));
                objBnNotaModificatoria.setUsuarioRechazo(objResultSet.getString("USU_RECHAZO"));
                objBnNotaModificatoria.setFechaRechazo(objResultSet.getDate("FECHA_RECHAZO"));
                objBnNotaModificatoria.setDependencia(objResultSet.getString("VRECHAZO_JUSTIFICA"));
                objBnNotaModificatoria.setSIAF(objResultSet.getInt("NUM_SIAF"));
                objBnNotaModificatoria.setConsolidado(objResultSet.getString("NUM_CONSOLIDADO"));
                objBnNotaModificatoria.setArchivo(objResultSet.getString("VNOTA_MODIFICATORIA_ARCHIVO"));
                lista.add(objBnNotaModificatoria);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaNotasModificatorias(objBeanNotaModificatoria) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBnNotaModificatoria.getMode().toUpperCase());
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
        return lista;
    }

    @Override
    public List getListaNotasModificatoriasDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NM.NNOTA_MODIFICATORIA_CODIGO AS CODIGO, ND.NNOTA_MODIFICATORIA_DETALLE AS DETALLE, "
                + "UTIL_NEW.FUN_ABUUOO(CUNIDAD_CODIGO) AS UNIDAD, "
                + "UTIL_NEW.FUN_ABRDEP(CUNIDAD_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "ND.NPRESUPUESTO_CODIGO||':'||UTIL_NEW.FUN_ABPPTO(ND.NPRESUPUESTO_CODIGO) AS PPTO,"
                + "ND.NTIPO_CALENDARIO_CODIGO||':'||UTIL_NEW.FUN_DESTIP(ND.NTIPO_CALENDARIO_CODIGO, ND.NPRESUPUESTO_CODIGO) AS TIPO_CALENDARIO,"
                + "UTIL_NEW.FUN_NOTA_ACTIVIDAD(NM.CPERIODO_CODIGO, ND.NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) AS ACTIVIDAD, "
                + "CSECUENCIA_FUNCIONAL_CODIGO ||'-'|| UTIL_NEW.FUN_DESMET(NM.CPERIODO_CODIGO, ND.NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) AS SECUENCIA_FUNCIONAL, "
                + "CMETA_OPERATIVA_CODIGO||'-'||UTIL_NEW.FUN_NTAREA(CMETA_OPERATIVA_CODIGO) AS TAREA, "
                + "VCADENA_GASTO_CODIGO||'-'||UTIL_NEW.FUN_NOCLAS(VCADENA_GASTO_CODIGO) AS CADENA_GASTO, "
                + "AVG(CASE CNOTA_MODIFICATORIA_TIPO WHEN 'A' THEN NNOTA_MODIFICATORIA_IMPORTE ELSE 0 END) AS IMPORTE_ANULACION,  "
                + "AVG(CASE CNOTA_MODIFICATORIA_TIPO WHEN 'C' THEN NNOTA_MODIFICATORIA_IMPORTE ELSE 0 END) AS IMPORTE_CREDITO, "
                + "REPLACE(REGEXP_REPLACE(UPPER(ND.VNOTA_MODIFICATORIA_JUSTIFICA),'[^A-Za-z0-9ÁÉÍÓÚáéíóú ]', ''),'\n"
                + "', ' ') AS JUTIFICACION "
                + "FROM SIPE_NOTA_MODIFICATORIA NM INNER JOIN SIPE_NOTA_MODIFICATORIA_DETAL ND ON ("
                + "NM.CPERIODO_CODIGO=ND.CPERIODO_CODIGO AND "
                + "NM.CUNIDAD_OPERATIVA_CODIGO=ND.CUNIDAD_OPERATIVA_CODIGO AND "
                + "NM.NNOTA_MODIFICATORIA_CODIGO=ND.NNOTA_MODIFICATORIA_CODIGO) WHERE "
                + "NM.CPERIODO_CODIGO=? AND "
                + "NM.CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NM.CMES_CODIGO=? "
                + "GROUP BY NM.CPERIODO_CODIGO, NM.NNOTA_MODIFICATORIA_CODIGO, ND.NNOTA_MODIFICATORIA_DETALLE, ND.CSECUENCIA_FUNCIONAL_CODIGO, "
                + "CDEPENDENCIA_CODIGO, ND.NPRESUPUESTO_CODIGO, CMETA_OPERATIVA_CODIGO, VCADENA_GASTO_CODIGO, CUNIDAD_CODIGO, "
                + "VNOTA_MODIFICATORIA_JUSTIFICA, NTIPO_CALENDARIO_CODIGO "
                + "ORDER BY CODIGO DESC, DETALLE ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getUnidadOperativa());
            objPreparedStatement.setString(3, objBeanNotaModificatoria.getMes());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnNotaModificatoria = new BeanNotaModificatoria();
                objBnNotaModificatoria.setCodigo(objResultSet.getString("CODIGO"));
                objBnNotaModificatoria.setDetalle(objResultSet.getInt("DETALLE"));
                objBnNotaModificatoria.setUnidad(objResultSet.getString("UNIDAD"));
                objBnNotaModificatoria.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnNotaModificatoria.setPresupuesto(objResultSet.getString("PPTO"));
                objBnNotaModificatoria.setTipoCalendario(objResultSet.getString("TIPO_CALENDARIO"));
                objBnNotaModificatoria.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnNotaModificatoria.setSecuenciaFuncional(objResultSet.getString("SECUENCIA_FUNCIONAL"));
                objBnNotaModificatoria.setTarea(objResultSet.getString("TAREA"));
                objBnNotaModificatoria.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnNotaModificatoria.setImporteAnulacion(objResultSet.getDouble("IMPORTE_ANULACION"));
                objBnNotaModificatoria.setImporteCredito(objResultSet.getDouble("IMPORTE_CREDITO"));
                objBnNotaModificatoria.setJustificacion(objResultSet.getString("JUTIFICACION"));
                lista.add(objBnNotaModificatoria);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaNotasModificatoriasDetalle(objBeanNotaModificatoria) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBnNotaModificatoria.getMode().toUpperCase());
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
        return lista;
    }

    @Override
    public ArrayList getListaNotaModificatoriaDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT ND.NNOTA_MODIFICATORIA_DETALLE AS DETALLE, "
                + "CASE ND.CNOTA_MODIFICATORIA_TIPO WHEN 'A' THEN 'Anulación' WHEN 'C' THEN 'Crédito' ELSE 'Verifique' END AS TIPO, "
                + "ND.CUNIDAD_CODIGO||':'||UTIL_NEW.FUN_ABUUOO(ND.CUNIDAD_CODIGO) AS UNIDAD, "
                + "ND.NPRESUPUESTO_CODIGO||':'||UTIL_NEW.FUN_ABPPTO(ND.NPRESUPUESTO_CODIGO) AS PPTO, "
                + "ND.NTIPO_CALENDARIO_CODIGO||':'||UTIL_NEW.FUN_DESTIP(ND.NTIPO_CALENDARIO_CODIGO, ND.NPRESUPUESTO_CODIGO) AS TIPO_CALENDARIO, "
                + "ND.CDEPENDENCIA_CODIGO||':'||UTIL_NEW.FUN_ABRDEP(ND.CUNIDAD_CODIGO, ND.CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "ND.CSECUENCIA_FUNCIONAL_CODIGO||':'||UTIL_NEW.FUN_DESMET(ND.CPERIODO_CODIGO, ND.NPRESUPUESTO_CODIGO, ND.CSECUENCIA_FUNCIONAL_CODIGO) AS SECUENCIA_FUNCIONAL, "
                + "ND.CMETA_OPERATIVA_CODIGO||':'||UTIL_NEW.FUN_NTAREA(ND.CMETA_OPERATIVA_CODIGO) AS TAREA, "
                + "ND.VCADENA_GASTO_CODIGO||':'||UTIL_NEW.FUN_NOCLAS(ND.VCADENA_GASTO_CODIGO) AS CADENA_GASTO, "
                + "AVG(CASE ND.CNOTA_MODIFICATORIA_TIPO WHEN 'A' THEN ND.NNOTA_MODIFICATORIA_IMPORTE ELSE 0 END) AS IMPORTE_ANULACION, "
                + "AVG(CASE ND.CNOTA_MODIFICATORIA_TIPO WHEN 'C' THEN ND.NNOTA_MODIFICATORIA_IMPORTE ELSE 0 END) AS IMPORTE_CREDITO, "
                + "ND.VNOTA_MODIFICATORIA_JUSTIFICA AS JUTIFICACION, "
                + "ND.NCODIGO_RESOLUCION||':'||UTIL.FUN_DESCRIPCION_RESOLUCION(ND.CPERIODO_CODIGO, ND.NCODIGO_RESOLUCION) AS RESOLUCION,"
                + "SUM(CASE MM.CMES_CODIGO WHEN '01' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS ENERO, "
                + "SUM(CASE MM.CMES_CODIGO WHEN '02' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS FEBRERO, "
                + "SUM(CASE MM.CMES_CODIGO WHEN '03' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS MARZO, "
                + "SUM(CASE MM.CMES_CODIGO WHEN '04' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS ABRIL, "
                + "SUM(CASE MM.CMES_CODIGO WHEN '05' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS MAYO, "
                + "SUM(CASE MM.CMES_CODIGO WHEN '06' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS JUNIO, "
                + "SUM(CASE MM.CMES_CODIGO WHEN '07' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS JULIO, "
                + "SUM(CASE MM.CMES_CODIGO WHEN '08' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS AGOSTO, "
                + "SUM(CASE MM.CMES_CODIGO WHEN '09' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS SETIEMBRE, "
                + "SUM(CASE MM.CMES_CODIGO WHEN '10' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS OCTUBRE, "
                + "SUM(CASE MM.CMES_CODIGO WHEN '11' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS NOVIEMBRE, "
                + "SUM(CASE MM.CMES_CODIGO WHEN '12' THEN MM.NNOTA_MODIFICATORIA_MENSUAL ELSE 0 END) AS DICIEMBRE "
                + "FROM SIPE_NOTA_MODIFICATORIA_DETAL ND LEFT OUTER JOIN SIPE_NOTA_MODIFICATORIA_MENSUA MM ON ("
                + "ND.CPERIODO_CODIGO=MM.CPERIODO_CODIGO AND "
                + "ND.CUNIDAD_OPERATIVA_CODIGO=MM.CUNIDAD_OPERATIVA_CODIGO AND "
                + "ND.NNOTA_MODIFICATORIA_CODIGO=MM.NNOTA_MODIFICATORIA_CODIGO AND "
                + "ND.NNOTA_MODIFICATORIA_DETALLE=MM.NNOTA_MODIFICATORIA_DETALLE) WHERE "
                + "ND.CPERIODO_CODIGO=? AND "
                + "ND.CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "ND.NNOTA_MODIFICATORIA_CODIGO=? "
                + "GROUP BY ND.CPERIODO_CODIGO, ND.CNOTA_MODIFICATORIA_TIPO, ND.CUNIDAD_CODIGO, ND.NTIPO_CALENDARIO_CODIGO, ND.NPRESUPUESTO_CODIGO, "
                + "ND.CDEPENDENCIA_CODIGO, ND.CSECUENCIA_FUNCIONAL_CODIGO, ND.CMETA_OPERATIVA_CODIGO, ND.VCADENA_GASTO_CODIGO, "
                + "ND.VNOTA_MODIFICATORIA_JUSTIFICA, ND.NCODIGO_RESOLUCION, ND.NNOTA_MODIFICATORIA_DETALLE "
                + "ORDER BY DETALLE ";

        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getUnidadOperativa());
            objPreparedStatement.setString(3, objBeanNotaModificatoria.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("TIPO") + "+++"
                        + objResultSet.getString("UNIDAD") + "+++"
                        + objResultSet.getString("PPTO") + "+++"
                        + objResultSet.getString("TIPO_CALENDARIO") + "+++"
                        + objResultSet.getString("DEPENDENCIA") + "+++"
                        + objResultSet.getString("SECUENCIA_FUNCIONAL") + "+++"
                        + objResultSet.getString("TAREA") + "+++"
                        + objResultSet.getString("CADENA_GASTO") + "+++"
                        + objResultSet.getDouble("IMPORTE_ANULACION") + "+++"
                        + objResultSet.getDouble("IMPORTE_CREDITO") + "+++"
                        + objResultSet.getString("JUTIFICACION") + "+++"
                        + objResultSet.getString("RESOLUCION") + "+++"
                        + objResultSet.getDouble("ENERO") + "+++"
                        + objResultSet.getDouble("FEBRERO") + "+++"
                        + objResultSet.getDouble("MARZO") + "+++"
                        + objResultSet.getDouble("ABRIL") + "+++"
                        + objResultSet.getDouble("MAYO") + "+++"
                        + objResultSet.getDouble("JUNIO") + "+++"
                        + objResultSet.getDouble("JULIO") + "+++"
                        + objResultSet.getDouble("AGOSTO") + "+++"
                        + objResultSet.getDouble("SETIEMBRE") + "+++"
                        + objResultSet.getDouble("OCTUBRE") + "+++"
                        + objResultSet.getDouble("NOVIEMBRE") + "+++"
                        + objResultSet.getDouble("DICIEMBRE");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaNotaModificatoriaDetalle(objBeanNotaModificatoria) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
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
    public ArrayList getListaNotaModificatoriaMetaFisica(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT NM.COPPTO||':'||UTIL_NEW.FUN_ABPPTO(NM.COPPTO) AS PPTO,"
                + "NM.COPRES||':'||UTIL_NEW.FUN_NOMBRE_CATEGORIA_PRESUPUES(NM.COPRES) AS CATEGORIA, "
                + "NM.CODCOM||':'||UTIL_NEW.FUN_NOMBRE_PRODUCTO(NM.CODCOM) AS PRODUCTO,  "
                + "NM.CODACT||':'||UTIL_NEW.FUN_DESACT(NM.CODACT) AS ACTIVIDAD, "
                + "NM.COMEOP||':'||UTIL_NEW.FUN_NTAREA(NM.COMEOP) AS TAREA, "
                + "NM.CODGEN||':'||UTIL_NEW.FUN_NOMGEN(NM.CODGEN) AS GENERICA, "
                + "NM.COUUAB||':'||UTIL_NEW.FUN_NOMBRE_UNIDADES(NM.COUUAB) AS UNIDAD, "
                + "CASE WHEN MF.NNOTA_MODIFICATORIA_CODIGO IS NULL THEN OPRE_NEW.FUN_NCANTIDAD_META_FISICA(NM.CODPER, NM.COUUAB, NM.COPPTO, NM.CODGEN, NM.COPRES, NM.CODCOM, NM.CODACT, NM.COMEOP) ELSE "
                + "NVL(SUM(MF.NMETA_INICIAL),0) END AS PROGRAMADO, "
                + "NVL(AVG(MF.NMETA_CANTIDAD),0) AS VARIACION "
                + "FROM V_NOTA_MODIFICATORIA_UNIDAD NM LEFT OUTER JOIN SIPE_META_FISICA MF ON ("
                + "NM.CODPER=MF.CPERIODO_CODIGO AND "
                + "NM.COUUOO=MF.CUNIDAD_CARGO AND "
                + "NM.NUNOMO=MF.NNOTA_MODIFICATORIA_CODIGO AND "
                + "NM.COUUAB=MF.CUNIDAD_OPERATIVA_CODIGO AND NM.COMEOP=MF.COMEOP) WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "NUNOMO=? "
                + "GROUP BY NM.CODPER, NM.COUUAB, NM.COPPTO, NM.CODGEN, NM.COPRES, NM.CODCOM, NM.CODACT, NM.COMEOP, MF.NNOTA_MODIFICATORIA_CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getUnidadOperativa());
            objPreparedStatement.setString(3, objBeanNotaModificatoria.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CATEGORIA") + "+++"
                        + objResultSet.getString("PRODUCTO") + "+++"
                        + objResultSet.getString("ACTIVIDAD") + "+++"
                        + objResultSet.getString("TAREA") + "+++"
                        + objResultSet.getString("GENERICA") + "+++"
                        + objResultSet.getString("UNIDAD") + "+++"
                        + objResultSet.getDouble("PROGRAMADO") + "+++"
                        + objResultSet.getDouble("VARIACION") + "+++"
                        + objResultSet.getString("PPTO") + "+++";
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaNotaModificatoriaMetaFisica(objBeanNotaModificatoria) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
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
    public BeanNotaModificatoria getNotaModificatoria(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "SELECT CTIPO_NOTA_MODIFICATORIA_CODIG AS TIPO_NOTA, "
                + "DNOTA_MODIFICATORIA_FECHA AS FECHA_NOTA, "
                + "VNOTA_MODIFICATORIA_JUSTIFICAC AS JUSTIFICADO, "
                + "LOGISTICA.FUN_NOMBRE_ESTADO(CNOTA_MODIFICATORIA_ESTADO) AS ESTADO "
                + "FROM SIPE_NOTA_MODIFICATORIA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NNOTA_MODIFICATORIA_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getUnidadOperativa());
            objPreparedStatement.setString(3, objBeanNotaModificatoria.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanNotaModificatoria.setTipo(objResultSet.getString("TIPO_NOTA"));
                objBeanNotaModificatoria.setJustificacion(objResultSet.getString("JUSTIFICADO"));
                objBeanNotaModificatoria.setFecha(objResultSet.getDate("FECHA_NOTA"));
                objBeanNotaModificatoria.setEstado(objResultSet.getString("ESTADO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getNotaModificatoria(objBeanNotaModificatoria) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
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
        return objBeanNotaModificatoria;
    }

    @Override
    public BeanNotaModificatoria getNotaModificatoriaInforme(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "SELECT VNOTA_IMPORTANCIA AS IMPORTANCIA, "
                + "VNOTA_FINANCIAMIENTO AS FINANCIAMIENTO, "
                + "VNOTA_CONSECUENCIAS AS CONSECUENCIA, "
                + "VNOTA_VARIACION AS VARIACION "
                + "FROM SIPE_NOTA_MODIFICATORIA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NNOTA_MODIFICATORIA_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getUnidadOperativa());
            objPreparedStatement.setString(3, objBeanNotaModificatoria.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanNotaModificatoria.setImportancia(objResultSet.getString("IMPORTANCIA"));
                objBeanNotaModificatoria.setFinanciamiento(objResultSet.getString("FINANCIAMIENTO"));
                objBeanNotaModificatoria.setConsecuencia(objResultSet.getString("CONSECUENCIA"));
                objBeanNotaModificatoria.setVariacion(objResultSet.getString("VARIACION"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getNotaModificatoriaInforme(objBeanNotaModificatoria) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
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
        return objBeanNotaModificatoria;
    }

    @Override
    public String getNumeroNotaModificatoria(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        String codigo = "1";
        sql = "SELECT NVL(MAX(NNOTA_MODIFICATORIA_CODIGO+1),'1') AS CODIGO "
                + "FROM SIPE_NOTA_MODIFICATORIA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                codigo = objResultSet.getString("CODIGO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getNumeroNotaModificatoria(objBeanNotaModificatoria) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
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
        return codigo;
    }

    @Override
    public int iduNotaModificatoria(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "{CALL SP_IDU_NOTA_MODIFICATORIA(?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanNotaModificatoria.getPeriodo());
            cs.setString(2, objBeanNotaModificatoria.getUnidadOperativa());
            cs.setString(3, objBeanNotaModificatoria.getCodigo());
            cs.setString(4, objBeanNotaModificatoria.getMes());
            cs.setString(5, objBeanNotaModificatoria.getTipo());
            cs.setDate(6, objBeanNotaModificatoria.getFecha());
            cs.setString(7, objBeanNotaModificatoria.getJustificacion());
            cs.setString(8, objBeanNotaModificatoria.getNotaModificatoria());
            cs.setString(9, objBeanNotaModificatoria.getEstado());
            cs.setString(10, objBeanNotaModificatoria.getCodigo());
            cs.setString(11, usuario);
            cs.setString(12, objBeanNotaModificatoria.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduNotaModificatoria : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduNotaModificatoriaDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "{CALL SP_IDU_NOTA_MODIFICATORIA_DETA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanNotaModificatoria.getPeriodo());
            cs.setString(2, objBeanNotaModificatoria.getUnidadOperativa());
            cs.setString(3, objBeanNotaModificatoria.getCodigo());
            cs.setString(4, objBeanNotaModificatoria.getTipo());
            cs.setInt(5, objBeanNotaModificatoria.getDetalle());
            cs.setString(6, objBeanNotaModificatoria.getDependencia());
            cs.setString(7, objBeanNotaModificatoria.getPresupuesto());
            cs.setString(8, objBeanNotaModificatoria.getSecuenciaFuncional());
            cs.setString(9, objBeanNotaModificatoria.getTarea());
            cs.setString(10, objBeanNotaModificatoria.getCadenaGasto());
            cs.setString(11, "");
            cs.setString(12, "");
            cs.setString(13, "003");
            cs.setString(14, objBeanNotaModificatoria.getUnidad());
            cs.setString(15, "");
            cs.setDouble(16, objBeanNotaModificatoria.getImporte());
            cs.setString(17, objBeanNotaModificatoria.getTipoCalendario());
            cs.setString(18, objBeanNotaModificatoria.getJustificacion());
            cs.setInt(19, objBeanNotaModificatoria.getResolucion());
            cs.setString(20, usuario);
            cs.setString(21, objBeanNotaModificatoria.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduNotaModificatoriaDetalle : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduNotaModificatoriaDetalleMensualizacion(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "{CALL SP_IDU_NOTA_MODIFICATORIA_MESU(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanNotaModificatoria.getPeriodo());
            cs.setString(2, objBeanNotaModificatoria.getUnidadOperativa());
            cs.setString(3, objBeanNotaModificatoria.getCodigo());
            cs.setInt(4, objBeanNotaModificatoria.getDetalle());
            cs.setDouble(5, objBeanNotaModificatoria.getEnero());
            cs.setDouble(6, objBeanNotaModificatoria.getFebrero());
            cs.setDouble(7, objBeanNotaModificatoria.getMarzo());
            cs.setDouble(8, objBeanNotaModificatoria.getAbril());
            cs.setDouble(9, objBeanNotaModificatoria.getMayo());
            cs.setDouble(10, objBeanNotaModificatoria.getJunio());
            cs.setDouble(11, objBeanNotaModificatoria.getJulio());
            cs.setDouble(12, objBeanNotaModificatoria.getAgosto());
            cs.setDouble(13, objBeanNotaModificatoria.getSetiembre());
            cs.setDouble(14, objBeanNotaModificatoria.getOctubre());
            cs.setDouble(15, objBeanNotaModificatoria.getNoviembre());
            cs.setDouble(16, objBeanNotaModificatoria.getDiciembre());
            cs.setString(17, usuario);
            cs.setString(18, objBeanNotaModificatoria.getMode().toUpperCase());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduNotaModificatoriaDetalleMensualizacion : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA_MENSUA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduNotaModificatoriaMetaFisica(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "{CALL SP_IDU_META_FISICA(?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanNotaModificatoria.getPeriodo());
            cs.setString(2, objBeanNotaModificatoria.getPresupuesto());
            cs.setString(3, objBeanNotaModificatoria.getUnidadOperativa());
            cs.setString(4, objBeanNotaModificatoria.getCodigo());
            cs.setInt(5, objBeanNotaModificatoria.getDetalle());
            cs.setString(6, objBeanNotaModificatoria.getConsolidado());
            cs.setString(7, usuario);
            cs.setString(8, objBeanNotaModificatoria.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduNotaModificatoriaMetaFisica : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduNotaModificatoriaInforme(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "UPDATE SIPE_NOTA_MODIFICATORIA SET "
                + "VNOTA_IMPORTANCIA=?, "
                + "VNOTA_FINANCIAMIENTO=?, "
                + "VNOTA_CONSECUENCIAS=?, "
                + "VNOTA_VARIACION=?, "
                + "VUSUARIO_INFORME=?, "
                + "DUSUARIO_INFORME=SYSDATE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NNOTA_MODIFICATORIA_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getImportancia());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getFinanciamiento());
            objPreparedStatement.setString(3, objBeanNotaModificatoria.getConsecuencia());
            objPreparedStatement.setString(4, objBeanNotaModificatoria.getVariacion());
            objPreparedStatement.setString(5, usuario);
            objPreparedStatement.setString(6, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(7, objBeanNotaModificatoria.getUnidadOperativa());
            objPreparedStatement.setString(8, objBeanNotaModificatoria.getCodigo());
            s = objPreparedStatement.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduNotaModificatoriaInforme : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
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
        return s;
    }

    @Override
    public int iduNotaModificatoriaVerifica(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "{CALL SP_VERIFICA_NOTA_MODIFICATORIA(?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanNotaModificatoria.getPeriodo());
            cs.setString(2, objBeanNotaModificatoria.getUnidadOperativa());
            cs.setString(3, objBeanNotaModificatoria.getCodigo());
            cs.setDate(4, objBeanNotaModificatoria.getFecha());
            cs.setString(5, objBeanNotaModificatoria.getJustificacion());
            cs.setString(6, usuario);
            cs.setString(7, objBeanNotaModificatoria.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduNotaModificatoriaVerifica : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_NOTA_MODIFICATORIA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
