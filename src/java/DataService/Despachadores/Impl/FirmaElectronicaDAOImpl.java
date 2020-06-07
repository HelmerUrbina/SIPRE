/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanFirmaElectronica;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.FirmaElectronicaDAO;
import DataService.Despachadores.MsgerrDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public class FirmaElectronicaDAOImpl implements FirmaElectronicaDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanFirmaElectronica objBnFirmaElectronica;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public FirmaElectronicaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaCertificadosPresupuestales(BeanFirmaElectronica objBeanFirmaElectronica, String usuario) {
        lista = new LinkedList<>();
        String add = "";
        if (usuario.equals("10714635")) {
            add = "AND VFIRMA_JEFE " + objBeanFirmaElectronica.getEstado();
        }
        if (usuario.equals("43305891")) {
            add = "AND VFIRMA_SUBJEFE " + objBeanFirmaElectronica.getEstado();
        }
        sql = "SELECT NROCOB AS CODIGO, CASE TIPSOL WHEN 'CE' THEN UTIL_NEW.FUN_CERTIFICADO_SIAF(CODPER,COPPTO,COUUOO,NROCOB) ELSE "
                + "CASE WHEN ESTCCP='AT' THEN UTIL_NEW.FUN_CERTIFICADO_SIAF(CODPER,COPPTO,COUUOO,(SELECT NROCOB FROM COMCAB WHERE CODPER=TASOCP.CODPER AND "
                + "COUUOO=TASOCP.COUUOO AND COPPTO=TASOCP.COPPTO AND NROCER=TASOCP.NUSOCP AND ESTCOB!='AN' GROUP BY NROCOB )) ELSE '' END END AS NRO_SIAF, "
                + "COUUOO||'-'||UTIL_NEW.FUN_ABUUOO(COUUOO) AS UNIDAD_OPERATIVA, "
                + "DOCREF, DESOCE, FECCCP AS FECHA, "
                + "CASE TIPSOL WHEN 'RE' THEN (-1)*MOCRPR ELSE MOCRPR END AS IMPORTE, "
                + "CASE TIPSOL WHEN 'CE' THEN 'CERTIFICADO' WHEN 'AM' THEN 'AMPLIACION' WHEN 'RE' THEN 'REBAJA' ELSE '' END AS TIP_SOL, "
                + "UTIL_NEW.FUN_DESC_USUARIO(UTIL_NEW.FUN_USUARIO_COBERTURA(CODPER, NROCOB)) AS USUARIO "
                + "FROM TASOCP WHERE "
                + "CODPER=? AND "
                + "COPPTO=? AND "
                + "ESTCCP='AT' "
                + add
                + " ORDER BY UNIDAD_OPERATIVA, NROCOB DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanFirmaElectronica.getPeriodo());
            objPreparedStatement.setInt(2, objBeanFirmaElectronica.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnFirmaElectronica = new BeanFirmaElectronica();
                objBnFirmaElectronica.setCodigo(objResultSet.getString("CODIGO"));
                objBnFirmaElectronica.setSIAF(objResultSet.getString("NRO_SIAF"));
                objBnFirmaElectronica.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnFirmaElectronica.setDocumento(objResultSet.getString("DOCREF"));
                objBnFirmaElectronica.setConcepto(objResultSet.getString("DESOCE"));
                objBnFirmaElectronica.setFecha(objResultSet.getDate("FECHA"));
                objBnFirmaElectronica.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnFirmaElectronica.setOpcion(objResultSet.getString("TIP_SOL"));
                objBnFirmaElectronica.setPeriodo(objResultSet.getString("USUARIO"));
                lista.add(objBnFirmaElectronica);
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsultaCompromisoAnual(BeanFirmaElectronica) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("FIRMA_ELECTRONICA");
            objBnMsgerr.setTipo(objBeanFirmaElectronica.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        }
        return lista;
    }

    @Override
    public List getListaCompromisosAnuales(BeanFirmaElectronica objBeanFirmaElectronica, String usuario) {
        lista = new LinkedList<>();
        String add = "";
        if (usuario.equals("10714635")) {
            add = "AND VFIRMA_JEFE " + objBeanFirmaElectronica.getEstado();
        }
        if (usuario.equals("43305891")) {
            add = "AND VFIRMA_SUBJEFE " + objBeanFirmaElectronica.getEstado();
        }
        sql = "SELECT "
                + "NUMCOR AS CODIGO, UTIL_NEW.FUN_CERTIFICADO_SIAF(CODPER, COPPTO, COUUOO, NROCOB) NRO_SIAF, "
                + "COUUOO||'-'||UTIL_NEW.FUN_ABUUOO(COUUOO) AS UNIDAD_OPERATIVA, "
                + "DESOCE, DOCREF, FECCCP FECHA, MOCRPR AS IMPORTE, "
                + "CASE TIPSOL WHEN 'CE' THEN 'COMPROMISO' WHEN 'AM' THEN 'AMPLIACION' WHEN 'RE' THEN 'REBAJA' ELSE '' END AS TIP_SOL, "
                + "UTIL_NEW.FUN_DESC_USUARIO(USUENV) AS USUARIO "
                + "FROM TASOCP_CA WHERE "
                + "CODPER=? AND "
                + "COPPTO=? AND "
                + "ESTCCP='AT' "
                + add
                + " ORDER BY UNIDAD_OPERATIVA, NROCOB DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanFirmaElectronica.getPeriodo());
            objPreparedStatement.setInt(2, objBeanFirmaElectronica.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnFirmaElectronica = new BeanFirmaElectronica();
                objBnFirmaElectronica.setCodigo(objResultSet.getString("CODIGO"));
                objBnFirmaElectronica.setSIAF(objResultSet.getString("NRO_SIAF"));
                objBnFirmaElectronica.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnFirmaElectronica.setDocumento(objResultSet.getString("DOCREF"));
                objBnFirmaElectronica.setConcepto(objResultSet.getString("DESOCE"));
                objBnFirmaElectronica.setFecha(objResultSet.getDate("FECHA"));
                objBnFirmaElectronica.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnFirmaElectronica.setOpcion(objResultSet.getString("TIP_SOL"));
                objBnFirmaElectronica.setPeriodo(objResultSet.getString("USUARIO"));
                lista.add(objBnFirmaElectronica);
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaCompromisosAnuales(BeanFirmaElectronica) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("FIRMA_ELECTRONICA");
            objBnMsgerr.setTipo(objBeanFirmaElectronica.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        }
        return lista;
    }

    @Override
    public List getListaCompromisosMensuales(BeanFirmaElectronica objBeanFirmaElectronica, String usuario) {
        lista = new LinkedList<>();
        String add = "";
        if (usuario.equals("10714635")) {
            add = "AND VFIRMA_JEFE " + objBeanFirmaElectronica.getEstado();
        }
        if (usuario.equals("43305891")) {
            add = "AND VFIRMA_SUBJEFE " + objBeanFirmaElectronica.getEstado();
        }
        sql = "SELECT "
                + "NROCOB AS CODIGO, REGSIAF NRO_SIAF, "
                + "COUUOO||'-'||UTIL_NEW.FUN_ABUUOO(COUUOO) AS UNIDAD_OPERATIVA, "
                + "DESGLO AS DESOCE, NUMOFI AS DOCREF, FECPRO FECHA, TOTCOB AS IMPORTE, "
                + "'MENSUAL' AS TIP_SOL, "
                + "UTIL_NEW.FUN_DESC_USUARIO(CODUSU) AS USUARIO "
                + "FROM COMCAB WHERE "
                + "CODPER=? AND "
                + "COPPTO=? AND "
                + "NROCOB NOT LIKE '%A' AND "
                + "ESTCOB!='AN' "
                + add
                + " ORDER BY UNIDAD_OPERATIVA, NROCOB DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanFirmaElectronica.getPeriodo());
            objPreparedStatement.setInt(2, objBeanFirmaElectronica.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnFirmaElectronica = new BeanFirmaElectronica();
                objBnFirmaElectronica.setCodigo(objResultSet.getString("CODIGO"));
                objBnFirmaElectronica.setSIAF(objResultSet.getString("NRO_SIAF"));
                objBnFirmaElectronica.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnFirmaElectronica.setDocumento(objResultSet.getString("DOCREF"));
                objBnFirmaElectronica.setConcepto(objResultSet.getString("DESOCE"));
                objBnFirmaElectronica.setFecha(objResultSet.getDate("FECHA"));
                objBnFirmaElectronica.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnFirmaElectronica.setOpcion(objResultSet.getString("TIP_SOL"));
                objBnFirmaElectronica.setPeriodo(objResultSet.getString("USUARIO"));
                lista.add(objBnFirmaElectronica);
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaCompromisosMensuales(BeanFirmaElectronica) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("FIRMA_ELECTRONICA");
            objBnMsgerr.setTipo(objBeanFirmaElectronica.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        }
        return lista;
    }

    @Override
    public List getListaDisponibilidadPresupuestal(BeanFirmaElectronica objBeanFirmaElectronica, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT "
                + "NROCER_CA, NUMCOR AS COBERTURA, UTIL_NEW.FUN_CERTIFICADO_SIAF(CODPER, COPPTO, COUUOO, NROCOB) CERTIFICADO, "
                + "DESOCE, DOCREF, FECCCP FECHA, MOCRPR AS IMPORTE, TIPCAM, IMPDOL,  "
                + "CASE ESTCCP WHEN 'PE' THEN 'PENDIENTE' WHEN 'AT' THEN 'ATENDIDO' WHEN 'AN' THEN 'ANULADO' ELSE '' END AS ESTADO, "
                + "CASE TIPSOL WHEN 'CE' THEN 'COMPROMISO' WHEN 'AM' THEN 'AMPLIACION' WHEN 'RE' THEN 'REBAJA' ELSE '' END AS TIP_SOL, "
                + "NUSOCP, NROCER "
                + "FROM TASOCP_CA WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=?  "
                + "ORDER BY NROCER_CA DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanFirmaElectronica.getPeriodo());
            objPreparedStatement.setString(2, objBeanFirmaElectronica.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanFirmaElectronica.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnFirmaElectronica = new BeanFirmaElectronica();
                objBnFirmaElectronica.setCodigo(objResultSet.getString("CODIGO"));
                objBnFirmaElectronica.setSIAF(objResultSet.getString("NRO_SIAF"));
                objBnFirmaElectronica.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnFirmaElectronica.setDocumento(objResultSet.getString("DOCREF"));
                objBnFirmaElectronica.setConcepto(objResultSet.getString("DESOCE"));
                objBnFirmaElectronica.setFecha(objResultSet.getDate("FECHA"));
                objBnFirmaElectronica.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnFirmaElectronica.setOpcion(objResultSet.getString("TIP_SOL"));
                objBnFirmaElectronica.setPeriodo(objResultSet.getString("USUARIO"));
                lista.add(objBnFirmaElectronica);
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDisponibilidadPresupuestal(BeanFirmaElectronica) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("FIRMA_ELECTRONICA");
            objBnMsgerr.setTipo(objBeanFirmaElectronica.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        }
        return lista;
    }

    @Override
    public List getListaFirmaUnidad(BeanFirmaElectronica objBeanFirmaElectronica, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NFIRMA_CODIGO AS CODIGO, NFIRMA_NIVEL AS NIVEL, VFIRMA_RESPONSABLE AS RESPONSABLE, "
                + "VFIRMA_CARGO AS CARGO, CFIRMA_GRADO||':'||UTIL_NEW.FUN_DESCRIPCION_GRADO(CFIRMA_GRADO) AS GRADO, "
                + "DFIRMA_INICIO AS INICIO, DFIRMA_FIN AS FIN, "
                + "CASE CESTADO_CODIGO WHEN 'AC' THEN 'ACTIVO' WHEN 'IN' THEN 'INACTIVO' WHEN 'AN' THEN 'ANULADO' ELSE 'VERIFICA' END ESTADO, "
                + "CASE CFIRMA_PROCESO WHEN 'AP' THEN 'APROBADO' WHEN 'PE' THEN 'PENDIENTE' ELSE 'VERIFICA' END PROCESO,  "
                + "VFIRMA_ARCHIVO AS ARCHIVO "
                + "FROM SIPE_FIRMA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? "
                + "ORDER BY CESTADO_CODIGO, NIVEL";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanFirmaElectronica.getPeriodo());
            objPreparedStatement.setString(2, objBeanFirmaElectronica.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnFirmaElectronica = new BeanFirmaElectronica();
                objBnFirmaElectronica.setCodigo(objResultSet.getString("CODIGO"));
                objBnFirmaElectronica.setNivel(objResultSet.getInt("NIVEL"));
                objBnFirmaElectronica.setDocumento(objResultSet.getString("RESPONSABLE"));
                objBnFirmaElectronica.setOpcion(objResultSet.getString("CARGO"));
                objBnFirmaElectronica.setConcepto(objResultSet.getString("GRADO"));
                objBnFirmaElectronica.setInicio(objResultSet.getDate("INICIO"));
                objBnFirmaElectronica.setFin(objResultSet.getDate("FIN"));
                objBnFirmaElectronica.setEstado(objResultSet.getString("ESTADO"));
                objBnFirmaElectronica.setPeriodo(objResultSet.getString("PROCESO"));
                objBnFirmaElectronica.setArchivo(objResultSet.getString("ARCHIVO"));
                lista.add(objBnFirmaElectronica);
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaFirmaUnidad(BeanFirmaElectronica) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("FIRMA_ELECTRONICA");
            objBnMsgerr.setTipo(objBeanFirmaElectronica.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        }
        return lista;
    }

    @Override
    public String getCodigoFirma(BeanFirmaElectronica objBeanFirmaElectronica, String usuario) {
        String result = "";
        sql = "SELECT NVL(MAX(NFIRMA_CODIGO),0)+1 AS CODIGO "
                + "FROM SIPE_FIRMA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanFirmaElectronica.getPeriodo());
            objPreparedStatement.setString(2, objBeanFirmaElectronica.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = "" + objResultSet.getInt("CODIGO");
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getCodigoFirma(BeanFirmaElectronica) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_FIRMA");
            objBnMsgerr.setTipo(objBeanFirmaElectronica.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        }
        return result;
    }

    @Override
    public int iduFirmaElectronica(BeanFirmaElectronica objBeanFirmaElectronica, String usuario) {
        sql = "{CALL SP_IDU_FIRMA_ELECTRONICA(?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanFirmaElectronica.getPeriodo());
            cs.setInt(2, objBeanFirmaElectronica.getPresupuesto());
            cs.setString(3, objBeanFirmaElectronica.getCodigo());
            cs.setString(4, usuario);
            cs.setString(5, objBeanFirmaElectronica.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduFirmaElectronica : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("FIRMA_ELECTRONICA");
            objBnMsgerr.setTipo(objBeanFirmaElectronica.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduFirma(BeanFirmaElectronica objBeanFirmaElectronica, String usuario) {
        sql = "{CALL SP_IDU_FIRMA(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanFirmaElectronica.getPeriodo());
            cs.setString(2, objBeanFirmaElectronica.getUnidadOperativa());
            cs.setString(3, objBeanFirmaElectronica.getCodigo());
            cs.setInt(4, objBeanFirmaElectronica.getNivel());
            cs.setString(5, objBeanFirmaElectronica.getDocumento());
            cs.setString(6, objBeanFirmaElectronica.getOpcion());
            cs.setString(7, objBeanFirmaElectronica.getConcepto());
            cs.setDate(8, objBeanFirmaElectronica.getInicio());
            cs.setDate(9, objBeanFirmaElectronica.getFin());
            cs.setString(10, objBeanFirmaElectronica.getArchivo());
            cs.setString(11, objBeanFirmaElectronica.getEstado());
            cs.setString(12, usuario);
            cs.setString(13, objBeanFirmaElectronica.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduFirma : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_FIRMA");
            objBnMsgerr.setTipo(objBeanFirmaElectronica.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
