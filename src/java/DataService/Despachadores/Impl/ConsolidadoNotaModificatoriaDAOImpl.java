/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanNotaModificatoria;
import DataService.Despachadores.ConsolidadoNotaModificatoriaDAO;
import DataService.Despachadores.MsgerrDAO;
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
public class ConsolidadoNotaModificatoriaDAOImpl implements ConsolidadoNotaModificatoriaDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanNotaModificatoria objBnNotaModificatoria;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ConsolidadoNotaModificatoriaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaConsolidadoNotasModificatorias(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT DISTINCT CN.CCONSOLIDADO_NOTA AS CONSOLIDADO,"
                + "UTIL_NEW.FUN_IMPORTE_CONSOLIDADO_NOTA(CN.CPERIODO_CODIGO,CN.CCONSOLIDADO_NOTA,'C') AS CREDITO,"
                + "UTIL_NEW.FUN_IMPORTE_CONSOLIDADO_NOTA(CN.CPERIODO_CODIGO,CN.CCONSOLIDADO_NOTA,'A') AS ANULACION,"
                + "CNUMERO_SIAF_NOTA AS NUMERO_SIAF,"
                + "CASE CESTADO_CONSOLIDADO_NOTA WHEN 'CO' THEN 'CONSOLIDADO' WHEN 'EN' THEN 'ENVIADO' WHEN 'AN' THEN 'ANULADO' WHEN 'CE' THEN 'CERRADO' ELSE ' ' END ESTADO_CONSOLIDADO,"
                + "CASE CESTADO_SIAF WHEN 'AP' THEN 'APROBADO' WHEN 'AN' THEN 'ANULADO' ELSE 'PENDIENTE' END ESTADO_SIAF, "
                + "DUSUARIO_CONSOLIDADO AS FECHA_CONSOLIDADO,"
                + "NVL(UTIL_NEW.FUN_DESC_USUARIO(VUSUARIO_CONSOLIDADO),'--') AS USU_CONSOLIDADO,"
                + "DUSUARIO_APROBACION AS FECHA_APROBACION,"
                + "NVL(UTIL_NEW.FUN_DESC_USUARIO(VUSUARIO_APROBACION),'--') AS USU_APROBACION, "
                + "DUSUARIO_CIERRE AS FECHA_ENVIO, "
                + "NVL(UTIL_NEW.FUN_DESC_USUARIO(VUSUARIO_CIERRE),'--') AS USU_ENVIO,"
                + "CASE CESTADO_METFISICA WHEN 'N' THEN 'NO' ELSE 'SI' END EST_METAFISICA "
                + "FROM SIPE_CONSOLIDADO_NOTA CN LEFT OUTER JOIN SIPE_CONSOLIDADO_DETALLE_NOTA CD ON "
                + "(CN.CPERIODO_CODIGO=CD.CPERIODO_CODIGO AND "
                + "CN.CCONSOLIDADO_NOTA=CD.CCONSOLIDADO_NOTA) WHERE "
                + "CN.CPERIODO_CODIGO=? AND "
                + "CN.CMES_CODIGO=? AND "
                + "CN.NPRESUPUESTO_CODIGO=? "
                + "ORDER BY CONSOLIDADO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getMes());
            objPreparedStatement.setString(3, objBeanNotaModificatoria.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnNotaModificatoria = new BeanNotaModificatoria();
                objBnNotaModificatoria.setConsolidado(objResultSet.getString("CONSOLIDADO"));
                objBnNotaModificatoria.setImporteAnulacion(objResultSet.getDouble("ANULACION"));
                objBnNotaModificatoria.setImporteCredito(objResultSet.getDouble("CREDITO"));
                objBnNotaModificatoria.setSIAF(objResultSet.getInt("NUMERO_SIAF"));
                objBnNotaModificatoria.setEstado(objResultSet.getString("ESTADO_CONSOLIDADO"));
                objBnNotaModificatoria.setActividad(objResultSet.getString("ESTADO_SIAF"));
                objBnNotaModificatoria.setFecha(objResultSet.getDate("FECHA_CONSOLIDADO"));
                objBnNotaModificatoria.setUsuario(objResultSet.getString("USU_CONSOLIDADO"));
                objBnNotaModificatoria.setFechaAprobacion(objResultSet.getDate("FECHA_APROBACION"));
                objBnNotaModificatoria.setUsuarioAprobacion(objResultSet.getString("USU_APROBACION"));
                objBnNotaModificatoria.setFechaCierre(objResultSet.getDate("FECHA_ENVIO"));
                objBnNotaModificatoria.setUsuarioCierre(objResultSet.getString("USU_ENVIO"));
                objBnNotaModificatoria.setTipo(objResultSet.getString("EST_METAFISICA"));
                lista.add(objBnNotaModificatoria);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaConsolidadoNotasModificatorias(objBeanNotaModificatoria) : " + e.getMessage());
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
    public List getListaConsolidadoNotasModificatoriasDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CN.CCONSOLIDADO_NOTA AS CONSOLIDADO, "
                + "CUNIDAD_OPERATIVA_CODIGO||':'||UTIL_NEW.FUN_NOMBRE_UNIDADES(CUNIDAD_OPERATIVA_CODIGO) AS UUOO, "
                + "NNOTA_MODIFICATORIA_CODIGO AS NOTA, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VNOTA_MODIFICATORIA_JUSTIFICA),'''',''),'\n"
                + "', ' ') AS JUSTIFICADO, "
                + "UTIL_NEW.FUN_NOMBRE_NOTA_MODIFICATORIA(CTIPO_NOTA_MODIFICATORIA_CODIG) AS TIPO_NOTA, "
                + "SUM(CASE CNOTA_MODIFICATORIA_TIPO WHEN 'A' THEN NNOTA_MODIFICATORIA_IMPORTE ELSE 0 END ) AS ANULACION, "
                + "SUM(CASE CNOTA_MODIFICATORIA_TIPO WHEN 'C' THEN NNOTA_MODIFICATORIA_IMPORTE ELSE 0 END ) AS CREDITO, "
                + "NVL(UTIL_NEW.FUN_DESC_USUARIO(VUSUARIO_VERIFICA),'--') AS SECTORISTA, "
                + "DUSUARIO_VERIFICA AS FEC_VERIFICA, "
                + "CASE CNOTA_ESTADO WHEN 'EN' THEN 'ENVIADO' ELSE 'CONSOLIDADO' END AS ESTADO_ENVIO "
                + "FROM SIPE_CONSOLIDADO_NOTA CN INNER JOIN SIPE_CONSOLIDADO_DETALLE_NOTA CD ON "
                + "(CN.CPERIODO_CODIGO=CD.CPERIODO_CODIGO AND "
                + "CN.CCONSOLIDADO_NOTA=CD.CCONSOLIDADO_NOTA) WHERE "
                + "CN.CPERIODO_CODIGO=? AND "
                + "CN.CMES_CODIGO=? AND "
                + "CN.NPRESUPUESTO_CODIGO=? "
                + "GROUP BY CN.CCONSOLIDADO_NOTA, CUNIDAD_OPERATIVA_CODIGO, NNOTA_MODIFICATORIA_CODIGO, "
                + "VNOTA_MODIFICATORIA_JUSTIFICA, CTIPO_NOTA_MODIFICATORIA_CODIG, "
                + "VUSUARIO_VERIFICA, DUSUARIO_VERIFICA, CNOTA_ESTADO, CESTADO_RESTRINGIDO "
                + "ORDER BY CONSOLIDADO, CUNIDAD_OPERATIVA_CODIGO, NNOTA_MODIFICATORIA_CODIGO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getMes());
            objPreparedStatement.setString(3, objBeanNotaModificatoria.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnNotaModificatoria = new BeanNotaModificatoria();
                objBnNotaModificatoria.setConsolidado(objResultSet.getString("CONSOLIDADO"));
                objBnNotaModificatoria.setUnidad(objResultSet.getString("UUOO"));
                objBnNotaModificatoria.setNotaModificatoria(objResultSet.getString("NOTA"));
                objBnNotaModificatoria.setJustificacion(objResultSet.getString("JUSTIFICADO"));
                objBnNotaModificatoria.setTipo(objResultSet.getString("TIPO_NOTA"));
                objBnNotaModificatoria.setImporteAnulacion(objResultSet.getDouble("ANULACION"));
                objBnNotaModificatoria.setImporteCredito(objResultSet.getDouble("CREDITO"));
                objBnNotaModificatoria.setUsuario(objResultSet.getString("SECTORISTA"));
                objBnNotaModificatoria.setFecha(objResultSet.getDate("FEC_VERIFICA"));
                objBnNotaModificatoria.setEstado(objResultSet.getString("ESTADO_ENVIO"));
                lista.add(objBnNotaModificatoria);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaConsolidadoNotasModificatoriasDetalle(objBeanNotaModificatoria) : " + e.getMessage());
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
    public List getListaConsolidadoNotaModificatoriaSIAF(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT COPRES||':'||UTIL_NEW.FUN_NOMBRE_CATEGORIA_PRESUPUES(COPRES) CAT_PRESUPUESTAL, "
                + "CODCOM||':'||UTIL_NEW.FUN_NOMBRE_PRODUCTO(CODCOM) PRODUCTO, "
                + "CODACT||':'||UTIL_NEW.FUN_NOMBRE_ACTIVIDAD(CODACT) ACTIVIDAD, "
                + "SECFUN||':'||UTIL_NEW.FUN_DESMET(CODPER, COPPTO, SECFUN) AS SECUENCIA_FUNCIONAL, "
                + "UTIL_NEW.FUN_FINALIDAD_SECFUN(CODPER, COPPTO, SECFUN) AS FINALIDAD, "
                + "COPPTO||':'||UTIL_NEW.FUN_ABPPTO(COPPTO) AS FUENTE_FINANCIAMIENTO, "
                + "COCAGA AS COCAGA, "
                + "UTIL_NEW.FUN_NOCLAS(COCAGA) AS CADENA_GASTO, "
                + "SUM(PIA) AS PIA, SUM(PIM) AS PIM, SUM(CERTIFICADO) AS CERTIFICADO, "
                + "SUM(PIM-CERTIFICADO) AS SALDO_CERT, "
                + "SUM(EJE_2016) AS EJECUCION, "
                + "SUM(CASE WHEN IMPORTE<0 THEN IMPORTE*(-1) ELSE 0 END) AS HABILITADOR, "
                + "SUM(CASE WHEN IMPORTE>0 THEN IMPORTE ELSE 0 END) AS HABILITADO, "
                + "SUM(PIM)+SUM(IMPORTE) AS NUEVO_PIM "
                + "FROM V_SUSTENTO_CONSOLIDADO WHERE "
                + "CODPER=? AND "
                + "TO_NUMBER(CONSOLIDADO)=? "
                + "GROUP BY CODPER, COPPTO, CODACT, CODCOM, COPRES, SECFUN, CODGEN,COCAGA "
                + "ORDER BY CAT_PRESUPUESTAL, PRODUCTO, ACTIVIDAD, FINALIDAD, SECUENCIA_FUNCIONAL, CADENA_GASTO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getCodigo().replaceAll("_", ""));
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnNotaModificatoria = new BeanNotaModificatoria();
                objBnNotaModificatoria.setCategoriaPresupuestal(objResultSet.getString("CAT_PRESUPUESTAL"));
                objBnNotaModificatoria.setProducto(objResultSet.getString("PRODUCTO"));
                objBnNotaModificatoria.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnNotaModificatoria.setSecuenciaFuncional(objResultSet.getString("SECUENCIA_FUNCIONAL"));
                objBnNotaModificatoria.setDescripcion(objResultSet.getString("FINALIDAD"));
                objBnNotaModificatoria.setFuenteFinanciamiento(objResultSet.getString("FUENTE_FINANCIAMIENTO"));
                objBnNotaModificatoria.setConsecuencia(objResultSet.getString("COCAGA"));
                objBnNotaModificatoria.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnNotaModificatoria.setEnero(objResultSet.getDouble("PIA"));
                objBnNotaModificatoria.setFebrero(objResultSet.getDouble("PIM"));
                objBnNotaModificatoria.setMarzo(objResultSet.getDouble("CERTIFICADO"));
                objBnNotaModificatoria.setAbril(objResultSet.getDouble("SALDO_CERT"));
                objBnNotaModificatoria.setImporteAnulacion(objResultSet.getDouble("HABILITADOR"));
                objBnNotaModificatoria.setImporteCredito(objResultSet.getDouble("HABILITADO"));
                objBnNotaModificatoria.setSaldo(objResultSet.getDouble("NUEVO_PIM"));
                lista.add(objBnNotaModificatoria);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaConsolidadoNotaModificatoriaSIAF(objBeanNotaModificatoria) : " + e.getMessage());
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
    public ArrayList getConsolidadoNotaModificatoriaVerificada(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT NM.CUNIDAD_OPERATIVA_CODIGO||':'||UTIL_NEW.FUN_NOMBRE_UNIDADES(NM.CUNIDAD_OPERATIVA_CODIGO) AS UNIDAD, "
                + "NM.NNOTA_MODIFICATORIA_CODIGO AS NOTA, "
                + "NM.VNOTA_MODIFICATORIA_JUSTIFICAC AS JUSTIFICACION, "
                + "UTIL_NEW.FUN_NOMBRE_NOTA_MODIFICATORIA(NM.CTIPO_NOTA_MODIFICATORIA_CODIG) AS TIPO_NOTA, "
                + "SUM(CASE ND.CNOTA_MODIFICATORIA_TIPO WHEN 'A' THEN ND.NNOTA_MODIFICATORIA_IMPORTE ELSE 0.00 END) AS ANULACION, "
                + "SUM(CASE ND.CNOTA_MODIFICATORIA_TIPO WHEN 'C' THEN ND.NNOTA_MODIFICATORIA_IMPORTE ELSE 0.00 END) AS CREDITO, "
                + "LOGISTICA.FUN_NOMBRE_ESTADO(NM.CNOTA_MODIFICATORIA_ESTADO) AS ESTADO, "
                + "NVL(UTIL_NEW.FUN_DESC_USUARIO(VUSUARIO_VERIFICA),'--') AS SECTORISTA "
                + "FROM SIPE_NOTA_MODIFICATORIA NM INNER JOIN SIPE_NOTA_MODIFICATORIA_DETAL ND ON ( "
                + "NM.CPERIODO_CODIGO=ND.CPERIODO_CODIGO AND  "
                + "NM.CUNIDAD_OPERATIVA_CODIGO=ND.CUNIDAD_OPERATIVA_CODIGO AND "
                + "NM.NNOTA_MODIFICATORIA_CODIGO=ND.NNOTA_MODIFICATORIA_CODIGO) WHERE "
                + "NM.CPERIODO_CODIGO=? AND "
                + "ND.NPRESUPUESTO_CODIGO=? AND "
                + "NM.CESTADO_CONSOLIDADO='PE' AND "
                + "NM.CNOTA_MODIFICATORIA_ESTADO='VE' AND "
                + "NM.CESTADO_CODIGO NOT IN ('AN') AND "
                + "NM.CUNIDAD_OPERATIVA_CODIGO NOT IN ('9000') "
                + "GROUP BY NM.CUNIDAD_OPERATIVA_CODIGO,NM.NNOTA_MODIFICATORIA_CODIGO, "
                + "NM.CTIPO_NOTA_MODIFICATORIA_CODIG,NM.VNOTA_MODIFICATORIA_JUSTIFICAC, "
                + "NM.CNOTA_MODIFICATORIA_ESTADO, VUSUARIO_VERIFICA "
                + "ORDER BY UNIDAD, NOTA";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("UNIDAD") + "+++"
                        + objResultSet.getString("NOTA") + "+++"
                        + objResultSet.getString("JUSTIFICACION") + "+++"
                        + objResultSet.getString("TIPO_NOTA") + "+++"
                        + objResultSet.getDouble("ANULACION") + "+++"
                        + objResultSet.getDouble("CREDITO") + "+++"
                        + objResultSet.getString("ESTADO") + "+++"
                        + objResultSet.getString("SECTORISTA") + "+++";
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsolidadoNotaModificatoriaVerificada(objBeanNotaModificatoria) : " + e.getMessage());
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
    public ArrayList getConsolidadoNotaModificatoriaDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT CUNIDAD_OPERATIVA_CODIGO||':'||UTIL_NEW.FUN_NOMBRE_UNIDADES(CUNIDAD_OPERATIVA_CODIGO) AS UNIDAD, "
                + "NNOTA_MODIFICATORIA_CODIGO AS NOTA, "
                + "VNOTA_MODIFICATORIA_JUSTIFICA AS JUSTIFICACION, "
                + "UTIL_NEW.FUN_NOMBRE_NOTA_MODIFICATORIA(CTIPO_NOTA_MODIFICATORIA_CODIG) AS TIPO_NOTA, "
                + "SUM(CASE CNOTA_MODIFICATORIA_TIPO WHEN 'A' THEN NNOTA_MODIFICATORIA_IMPORTE ELSE 0 END ) AS ANULACION, "
                + "SUM(CASE CNOTA_MODIFICATORIA_TIPO WHEN 'C' THEN NNOTA_MODIFICATORIA_IMPORTE ELSE 0 END ) AS CREDITO, "
                + "CASE CNOTA_ESTADO WHEN 'EN' THEN 'ENVIADO' ELSE 'CONSOLIDADO' END AS ESTADO, "
                + "NVL(UTIL_NEW.FUN_DESC_USUARIO(VUSUARIO_VERIFICA),'--') AS SECTORISTA "
                + "FROM SIPE_CONSOLIDADO_NOTA CN INNER JOIN SIPE_CONSOLIDADO_DETALLE_NOTA CD ON "
                + "(CN.CPERIODO_CODIGO=CD.CPERIODO_CODIGO AND "
                + "CN.CCONSOLIDADO_NOTA=CD.CCONSOLIDADO_NOTA) WHERE "
                + "CN.CPERIODO_CODIGO=? AND "
                + "CN.CCONSOLIDADO_NOTA=? "
                + "GROUP BY CUNIDAD_OPERATIVA_CODIGO, NNOTA_MODIFICATORIA_CODIGO, "
                + "VNOTA_MODIFICATORIA_JUSTIFICA, CTIPO_NOTA_MODIFICATORIA_CODIG, "
                + "VUSUARIO_VERIFICA, DUSUARIO_VERIFICA, CNOTA_ESTADO "
                + "ORDER BY UNIDAD, NOTA";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("UNIDAD") + "+++"
                        + objResultSet.getString("NOTA") + "+++"
                        + objResultSet.getString("JUSTIFICACION") + "+++"
                        + objResultSet.getString("TIPO_NOTA") + "+++"
                        + objResultSet.getDouble("ANULACION") + "+++"
                        + objResultSet.getDouble("CREDITO") + "+++"
                        + objResultSet.getString("ESTADO") + "+++"
                        + objResultSet.getString("SECTORISTA") + "+++";
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsolidadoNotaModificatoriaVerificada(objBeanNotaModificatoria) : " + e.getMessage());
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
    public String getCodigoConsolidadoNota(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        String result = "";
        sql = "SELECT NVL(LPAD(MAX(CCONSOLIDADO_NOTA)+1,4,0),'0001') AS CODIGO "
                + "FROM SIPE_CONSOLIDADO_NOTA WHERE "
                + "CPERIODO_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("CODIGO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCodigoConsolidadoNota(objBeanNotaModificatoria) : " + e.getMessage());
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
        return result;
    }

    @Override
    public BeanNotaModificatoria getConsolidadoNotaModificatoriaInforme(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "SELECT VCONSOLIDADO_IMPORTANCIA AS IMPORTANCIA, "
                + "VCONSOLIDADO_FINANCIAMIENTO AS FINANCIAMIENTO, "
                + "VCONSOLIDADO_CONSECUENCIAS AS CONSECUENCIA, "
                + "VCONSOLIDADO_VARIACION AS VARIACION "
                + "FROM SIPE_CONSOLIDADO_NOTA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CCONSOLIDADO_NOTA=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanNotaModificatoria.setImportancia(objResultSet.getString("IMPORTANCIA"));
                objBeanNotaModificatoria.setFinanciamiento(objResultSet.getString("FINANCIAMIENTO"));
                objBeanNotaModificatoria.setConsecuencia(objResultSet.getString("CONSECUENCIA"));
                objBeanNotaModificatoria.setVariacion(objResultSet.getString("VARIACION"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsolidadoNotaModificatoriaInforme(objBeanNotaModificatoria) : " + e.getMessage());
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
        return objBeanNotaModificatoria;
    }

    @Override
    public int iduConsolidarNotaModificatoria(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "{CALL SP_IDU_CONSOLIDADO_NOTA(?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanNotaModificatoria.getPeriodo());
            cs.setString(2, objBeanNotaModificatoria.getMes());
            cs.setString(3, objBeanNotaModificatoria.getCodigo());
            cs.setInt(4, objBeanNotaModificatoria.getSIAF());
            cs.setString(5, objBeanNotaModificatoria.getUnidadOperativa());
            cs.setInt(6, Utiles.Utiles.checkNum(objBeanNotaModificatoria.getNotaModificatoria()));
            cs.setString(7, objBeanNotaModificatoria.getPresupuesto());
            cs.setInt(8, 99);
            cs.setString(9, usuario);
            cs.setString(10, objBeanNotaModificatoria.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduConsolidarNotaModificatoria : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_CONSOLIDADO_NOTA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduConsolidadoNotaModificatoriaDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "{CALL SP_IDU_CONSOLIDADO_DETALLE_NOT(?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanNotaModificatoria.getPeriodo());
            cs.setString(2, objBeanNotaModificatoria.getMes());
            cs.setString(3, objBeanNotaModificatoria.getCodigo());
            cs.setString(4, objBeanNotaModificatoria.getUnidadOperativa());
            cs.setString(5, objBeanNotaModificatoria.getNotaModificatoria().trim());
            cs.setString(6, objBeanNotaModificatoria.getJustificacion());
            cs.setString(7, usuario);
            cs.setString(8, objBeanNotaModificatoria.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduConsolidadoNotaModificatoriaDetalle : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_CONSOLIDADO_NOTA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int eliminaDetalleConsolidadoNotaModificatoria(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "SELECT CUNIDAD_OPERATIVA_CODIGO AS UNIDAD, "
                + "NNOTA_MODIFICATORIA_CODIGO AS NOTA "
                + "FROM SIPE_CONSOLIDADO_DETALLE_NOTA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CCONSOLIDADO_NOTA=? "
                + "GROUP BY CUNIDAD_OPERATIVA_CODIGO, NNOTA_MODIFICATORIA_CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBeanNotaModificatoria.setMode("D");
                objBeanNotaModificatoria.setUnidadOperativa(objResultSet.getString("UNIDAD"));
                objBeanNotaModificatoria.setNotaModificatoria(objResultSet.getString("NOTA"));
                s = iduConsolidadoNotaModificatoriaDetalle(objBeanNotaModificatoria, usuario);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsolidadoNotaModificatoriaVerificada(objBeanNotaModificatoria) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_CONSOLIDADO_NOTA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
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
        return s;
    }

    @Override
    public int iduConsolidadoNotaModificatoriaInforme(BeanNotaModificatoria objBeanNotaModificatoria, String usuario) {
        sql = "UPDATE SIPE_CONSOLIDADO_NOTA SET "
                + "VCONSOLIDADO_IMPORTANCIA=?, "
                + "VCONSOLIDADO_FINANCIAMIENTO=?, "
                + "VCONSOLIDADO_CONSECUENCIAS=?, "
                + "VCONSOLIDADO_VARIACION=?, "
                + "VUSUARIO_INFORME=?, "
                + "DUSUARIO_INFORME=SYSDATE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CCONSOLIDADO_NOTA=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanNotaModificatoria.getImportancia());
            objPreparedStatement.setString(2, objBeanNotaModificatoria.getFinanciamiento());
            objPreparedStatement.setString(3, objBeanNotaModificatoria.getConsecuencia());
            objPreparedStatement.setString(4, objBeanNotaModificatoria.getVariacion());
            objPreparedStatement.setString(5, usuario);
            objPreparedStatement.setString(6, objBeanNotaModificatoria.getPeriodo());
            objPreparedStatement.setString(7, objBeanNotaModificatoria.getCodigo());
            s = objPreparedStatement.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduConsolidadoNotaModificatoriaInforme : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_CONSOLIDADO_NOTA");
            objBnMsgerr.setTipo(objBeanNotaModificatoria.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                objPreparedStatement.close();
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduConsolidadoNotaModificatoriaInforme : " + e.getMessage());
            }
        }
        return s;
    }

}
