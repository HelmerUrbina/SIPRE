/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPriorizacionPCA;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PriorizacionPCADAO;
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
public class PriorizacionPCADAOImpl implements PriorizacionPCADAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPriorizacionPCA objBnPriorizacion;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public PriorizacionPCADAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaPriorizacionPCA(BeanPriorizacionPCA objBeanPriorizacion, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT COCAGA||':'||UTIL_NEW.FUN_NOCLAS(COCAGA) AS CADENA_GASTO, SUM(PIM) AS PIM, "
                + "SUM(PRIORIZADO) AS PRIORIZADO, SUM(CERT) AS CERTIFICADO, SUM(SOLICITADO_I) AS INCREMENTO, "
                + "SUM(SOLICITADO_D) AS DISMINUCION "
                + "FROM V_PRIORIZACION_SIPE WHERE "
                + "CODPER=? AND "
                + "COPPTO=? AND "
                + "CODGEN=? "
                + "GROUP BY COCAGA "
                + "ORDER BY COCAGA";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPriorizacion.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPriorizacion.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPriorizacion.getGenericaGasto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnPriorizacion = new BeanPriorizacionPCA();
                objBnPriorizacion.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnPriorizacion.setPIM(objResultSet.getDouble("PIM"));
                objBnPriorizacion.setPriorizado(objResultSet.getDouble("PRIORIZADO"));
                objBnPriorizacion.setCertificado(objResultSet.getDouble("CERTIFICADO"));
                objBnPriorizacion.setIncremento(objResultSet.getDouble("INCREMENTO"));
                objBnPriorizacion.setDisminucion(objResultSet.getDouble("DISMINUCION"));
                lista.add(objBnPriorizacion);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPriorizacionPCA(objBeanPriorizacion) : " + e.getMessage());
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
    public ArrayList getListaPriorizacionPCADetalle(BeanPriorizacionPCA objBeanPriorizacion, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT CA.NPRIORIZACION_CODIGO AS CODIGO, TO_CHAR(CA.DUSUARIO_CREADOR,'DD/MM/YYYY') AS FECHA, "
                + "LPAD(NVL(CA.NPRIORIZACION_SIAF,'0'),10,'0') AS SIAF, "
                + "CASE CA.CESTADO_CODIGO WHEN 'AP' THEN 'APROBADO' WHEN 'PE' THEN 'PENDIENTE' WHEN 'AN' THEN 'ANULADO' ELSE 'VERIFICAR' END AS ESTADO,  "
                + "SUM(CASE DE.CPRIORIZACION_TIPO WHEN 'I' THEN DE.NPRIORIZACION_IMPORTE ELSE 0 END) SOLICITADO_I, "
                + "SUM(CASE DE.CPRIORIZACION_TIPO WHEN 'D' THEN DE.NPRIORIZACION_IMPORTE*(-1) ELSE 0 END) AS SOLICITADO_D,"
                + "UTIL_NEW.FUN_DESC_USUARIO(CA.VUSUARIO_CREADOR) AS CREADOR, "
                + "UTIL_NEW.FUN_DESC_USUARIO(CA.VUSUARIO_APROBADO) AS APROBADO "
                + "FROM SIPRE_PRIORIZACION CA LEFT OUTER JOIN SIPRE_PRIORIZACION_DETALLE DE ON "
                + "CA.CPERIODO_CODIGO=DE.CPERIODO_CODIGO AND CA.NPRIORIZACION_CODIGO=DE.NPRIORIZACION_CODIGO WHERE "
                + "CA.CPERIODO_CODIGO=? AND "
                + "CA.NPRESUPUESTO_CODIGO=? AND "
                + "CA.CGENERICA_GASTO_CODIGO=? "
                + "GROUP BY CA.NPRIORIZACION_CODIGO, CA.DUSUARIO_CREADOR, CA.NPRIORIZACION_SIAF, CA.CESTADO_CODIGO, CA.VUSUARIO_CREADOR, CA.VUSUARIO_APROBADO "
                + "ORDER BY CODIGO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPriorizacion.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPriorizacion.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPriorizacion.getGenericaGasto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("FECHA") + "+++"
                        + objResultSet.getString("SIAF") + "+++"
                        + objResultSet.getString("ESTADO") + "+++"
                        + objResultSet.getDouble("SOLICITADO_I") + "+++"
                        + objResultSet.getDouble("SOLICITADO_D") + "+++"
                        + objResultSet.getString("CREADOR") + "+++"
                        + objResultSet.getString("APROBADO");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPriorizacionPCADetalle(BeanCertificadoCreditoPresupuestal) : " + e.getMessage());
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
    public ArrayList getListaPriorizacionPCAPendiente(BeanPriorizacionPCA objBeanPriorizacion, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT SOLICITUD, COUUOO||':'||UTIL_NEW.FUN_NOMBRE_UNIDADES(COUUOO) AS UNIDAD, "
                + "UTIL_NEW.FUN_SECTORISTA(CODPER, COUUOO, COPPTO, CODGEN) AS SECTORISTA, "
                + "CASE TIPO WHEN 'D' THEN SUM(IMPORTE)*(-1) ELSE SUM(IMPORTE) END AS IMPORTE, TIPO "
                + "FROM V_MEMO_PRIORIZACION WHERE "
                + "CODPER=? AND "
                + "COPPTO=? AND "
                + "CODGEN=? "
                + "GROUP BY CODPER, COPPTO, SOLICITUD, COUUOO, CODGEN, TIPO "
                + "HAVING SUM(IMPORTE)!=0.0 "
                + "ORDER BY COUUOO, SOLICITUD";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPriorizacion.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPriorizacion.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPriorizacion.getGenericaGasto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("SOLICITUD") + "+++"
                        + objResultSet.getString("UNIDAD") + "+++"
                        + objResultSet.getString("SECTORISTA") + "+++"
                        + objResultSet.getDouble("IMPORTE") + "+++"
                        + objResultSet.getString("TIPO");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPriorizacionPCAPendiente(BeanCertificadoCreditoPresupuestal) : " + e.getMessage());
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
    public ArrayList getPriorizacionPCADetalle(BeanPriorizacionPCA objBeanPriorizacion, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT CSOLICITUD_CREDITO_CODIGO AS SOLICITUD, "
                + "CUNIDAD_OPERATIVA_CODIGO||':'||UTIL_NEW.FUN_ABUUOO(CUNIDAD_OPERATIVA_CODIGO) AS UNIDAD, "
                + "UTIL_NEW.FUN_SECTORISTA(CPERIODO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, NPRESUPUESTO_CODIGO, TRIM(?)) AS SECTORISTA, "
                + "CASE CPRIORIZACION_TIPO WHEN 'D' THEN SUM(NPRIORIZACION_IMPORTE)*(-1) ELSE SUM(NPRIORIZACION_IMPORTE) END AS IMPORTE, "
                + "CPRIORIZACION_TIPO AS TIPO "
                + "FROM SIPRE_PRIORIZACION_DETALLE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "NPRIORIZACION_CODIGO=? "
                + "GROUP BY CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, CSOLICITUD_CREDITO_CODIGO, CPRIORIZACION_TIPO "
                + "ORDER BY SOLICITUD";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPriorizacion.getGenericaGasto());
            objPreparedStatement.setString(2, objBeanPriorizacion.getPeriodo());
            objPreparedStatement.setInt(3, objBeanPriorizacion.getPresupuesto());
            objPreparedStatement.setInt(4, objBeanPriorizacion.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("SOLICITUD") + "+++"
                        + objResultSet.getString("UNIDAD") + "+++"
                        + objResultSet.getString("SECTORISTA") + "+++"
                        + objResultSet.getDouble("IMPORTE") + "+++"
                        + objResultSet.getString("TIPO");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPriorizacionPCADetalle(BeanCertificadoCreditoPresupuestal) : " + e.getMessage());
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
    public Integer getNumeroPriorizacionPCA(BeanPriorizacionPCA objBeanPriorizacion, String usuario) {
        Integer codigo = 0;
        sql = "SELECT NVL(MAX(NPRIORIZACION_CODIGO+1),1) AS CODIGO "
                + "FROM SIPRE_PRIORIZACION WHERE "
                + "CPERIODO_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPriorizacion.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                codigo = objResultSet.getInt("CODIGO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getNumeroPriorizacionPCA(objBeanPriorizacion) : " + e.getMessage());
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
    public int iduPriorizacionPCA(BeanPriorizacionPCA objBeanPriorizacion, String usuario) {
        Integer codigo = 0;
        sql = "{CALL SP_IDU_PRIORIZACION(?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanPriorizacion.getPeriodo());
            cs.setInt(2, objBeanPriorizacion.getPresupuesto());
            cs.setString(3, objBeanPriorizacion.getGenericaGasto());
            cs.setInt(4, objBeanPriorizacion.getCodigo());
            cs.setString(5, objBeanPriorizacion.getSolicitudCredito());
            cs.setString(6, usuario);
            cs.setString(7, objBeanPriorizacion.getMode());
            cs.registerOutParameter(8, java.sql.Types.INTEGER);
            cs.executeUpdate();
            codigo = cs.getInt(8);
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPriorizacionPCA : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PRIORIZACION");
            objBnMsgerr.setTipo(objBeanPriorizacion.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return codigo;
    }

    @Override
    public int iduPriorizacionPCADetalle(BeanPriorizacionPCA objBeanPriorizacion, String usuario) {
        sql = "{CALL SP_IDU_PRIORIZACION_DETALLE(?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanPriorizacion.getPeriodo());
            cs.setInt(2, objBeanPriorizacion.getCodigo());
            cs.setString(3, objBeanPriorizacion.getUnidadOperativa());
            cs.setInt(4, objBeanPriorizacion.getPresupuesto());
            cs.setString(5, objBeanPriorizacion.getSolicitudCredito());
            cs.setString(6, objBeanPriorizacion.getTipo());
            cs.setString(7, usuario);
            cs.setString(8, objBeanPriorizacion.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPriorizacionPCADetalle : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PRIORIZACION_DETALLE");
            objBnMsgerr.setTipo(objBeanPriorizacion.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
