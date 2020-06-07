/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanDerechoPersonal;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.DerechoPersonalDAO;
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
 * @author H-TECCSI-V
 */
public class DerechoPersonalDAOImpl implements DerechoPersonalDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanDerechoPersonal objBnDerechoPersonal;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public DerechoPersonalDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public ArrayList getListaPedidoJADPE(BeanDerechoPersonal objBeanDerechoPersonal, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT NUMRES||'.'||NUMOFI||'.'||COTIDE||'.'||CODBEN||'.'||COSTIP AS CODIGO, "
                + "NOMBEN, UTIL_NEW.FUN_NOMBRE_GRADO(CODGRD) AS GRADO, SUM(IMPBEN) AS IMPORTE, "
                + "UTIL.FUN_DES_BENEFICIO_RESOLUCIONES(TIPO, COTIDE) AS BENEFICIO "
                + "FROM DERPER WHERE "
                + "CODPER=? AND "
                + "COPPTO=? AND "
                + "NUMPED=? AND "
                + "MESPER=? "
                + "GROUP BY NUMRES, NUMOFI, COTIDE, CODBEN, CODGRD, NOMBEN, COSTIP, TIPO "
                + "ORDER BY NOMBEN";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDerechoPersonal.getPeriodo());
            objPreparedStatement.setInt(2, objBeanDerechoPersonal.getPresupuesto());
            objPreparedStatement.setString(3, objBeanDerechoPersonal.getCobertura());
            objPreparedStatement.setString(4, objBeanDerechoPersonal.getMes());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("NOMBEN") + "+++"
                        + objResultSet.getString("GRADO") + "+++"
                        + objResultSet.getString("IMPORTE") + "+++"
                        + objResultSet.getString("BENEFICIO");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPedidoJADPE(objBeanDerechoPersonal,'" + usuario + "') : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("DERPER");
            objBnMsgerr.setTipo(objBnDerechoPersonal.getMode().toUpperCase());
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
        return Arreglo;
    }

    @Override
    public ArrayList getListaBeneficiarioJADPE(BeanDerechoPersonal objBeanDerechoPersonal, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        if (objBeanDerechoPersonal.getTipo().equals("J")) {
            sql = "SELECT DNI AS CODIGO, OFICIO,NRO_RESOLUCION AS RESOLUCION, "
                    + "BENEFICIARIO, SUM(IMPORTE) AS IMPORTE, "
                    + "DES_GRADO AS GRADO, TO_CHAR(FEC_OFICIO,'DD') AS DIA, MES, BENEFICIO_SENTENCIA_JUDICIAL AS COSTIP "
                    + "FROM V_RESOLUCION_JADPE@DBLINK_ECON "
                    + "WHERE ANO_RESOL=? AND "
                    + "COD_BENEFICIO=? AND "
                    + "DNI||'.'||NRO_RESOLUCION||'.'||OFICIO NOT IN (SELECT CODBEN||'.'||NUMRES||'.'||NUMOFI "
                    + "FROM DERPER WHERE "
                    + "CODPER=? AND "
                    + "COTIDE=LPAD(?,3,0) AND ESTDER!='AN') "
                    + "GROUP BY DNI,OFICIO, NRO_RESOLUCION,BENEFICIARIO, DES_GRADO,"
                    + "TO_CHAR(FEC_OFICIO,'DD'), MES, BENEFICIO_SENTENCIA_JUDICIAL";
        } else {
            sql = "SELECT COD_ADM AS CODIGO, NRO_OFI_DIPLAN AS OFICIO, NRO_RESOL AS RESOLUCION, "
                    + "NOMBRE AS BENEFICIARIO, SUM(IMP_BRUTO) AS IMPORTE, ' ' AS GRADO, "
                    + "TO_CHAR(FEC_OFI_DIPLAN,'DD') AS DIA, TO_CHAR(FEC_OFI_DIPLAN,'MM') AS MES, '' AS COSTIP "
                    + "FROM BDATOS.V_RESOLUCION_TES_COPERE@DBLINK_ECON WHERE "
                    + "ANO_RESOL=? AND COD_CONCEPTO=? AND "
                    + "COD_ADM||'.'||TO_NUMBER(NRO_RESOL)||'.'||TO_NUMBER(NRO_OFI_DIPLAN) NOT IN "
                    + "(SELECT CODBEN||'.'||NUMRES||'.'||NUMOFI "
                    + "FROM DERPER WHERE "
                    + "CODPER=? AND "
                    + "COTIDE=? AND "
                    + "TIPO='T' AND "
                    + "ESTDER!='AN') "
                    + "GROUP BY COD_ADM, NRO_OFI_DIPLAN, NRO_RESOL, NOMBRE, TO_CHAR(FEC_OFI_DIPLAN,'DD'), TO_CHAR(FEC_OFI_DIPLAN,'MM') "
                    + "ORDER BY DIA, MES";
        }
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDerechoPersonal.getPeriodoResolucion());
            objPreparedStatement.setString(2, objBeanDerechoPersonal.getCodigoBeneficio());
            objPreparedStatement.setString(3, objBeanDerechoPersonal.getPeriodo());
            objPreparedStatement.setString(4, objBeanDerechoPersonal.getCodigoBeneficio());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("OFICIO") + "+++"
                        + objResultSet.getString("RESOLUCION") + "+++"
                        + objResultSet.getString("BENEFICIARIO") + "+++"
                        + objResultSet.getString("IMPORTE") + "+++"
                        + objResultSet.getString("GRADO") + "+++"
                        + objResultSet.getString("COSTIP");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaBeneficiarioJADPE(objBeanDerechoPersonal, '" + usuario + "') : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("DERPER");
            objBnMsgerr.setTipo(objBnDerechoPersonal.getMode().toUpperCase());
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
        return Arreglo;
    }

    @Override
    public int iduRelacionJADPE(BeanDerechoPersonal objBeanDerechoPersonal, String usuario) {
        sql = "{CALL SP_IDU_DERECHO_PERSONAL_PEDIDO(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanDerechoPersonal.getPeriodo());
            cs.setInt(2, objBeanDerechoPersonal.getPresupuesto());
            cs.setString(3, objBeanDerechoPersonal.getMes());
            cs.setInt(4, objBeanDerechoPersonal.getOficio());
            cs.setInt(5, objBeanDerechoPersonal.getResolucion());
            cs.setString(6, objBeanDerechoPersonal.getCobertura());
            cs.setString(7, objBeanDerechoPersonal.getCodigoAdministrativo());
            cs.setString(8, objBeanDerechoPersonal.getCodigo());
            cs.setString(9, objBeanDerechoPersonal.getCodigoBeneficio());
            cs.setString(10, objBeanDerechoPersonal.getCodigoSubTipo());
            cs.setString(11, objBeanDerechoPersonal.getReferencia());
            cs.setString(12, objBeanDerechoPersonal.getAsunto());
            cs.setString(13, usuario);
            cs.setString(14, objBeanDerechoPersonal.getMode().toUpperCase());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduRelacionJADPE : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("DERPER");
            objBnMsgerr.setTipo(objBeanDerechoPersonal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public List getConsultaJADPE(BeanDerechoPersonal objBeanDerechoPersonal, String usuario) {
        lista = new LinkedList<>();
        // if(objBeanDerechoPersonal.getCodigoAdministrativo().equals("")){
        sql = "SELECT CODPER, DES_BENEFICIO, COD_ADM, REG_SIAF, "
                + "BENEFICIARIO, GRADO, RESOL, OFICIO, IMPORTE, "
                + "NVL(NROCOB,' ') AS NROCOB, FEC_COMP, FEC_DEVENG, FEC_GIRD "
                + "FROM V_CONSULTA_DERECHO_PERSONAL WHERE "
                + "CODPER LIKE '%'||?||'%' AND "
                + "BENEFICIARIO LIKE UPPER('%'||?||'%') "
                + "ORDER BY CODPER ";
        /* }else{
            sql = "SELECT CODPER,DES_BENEFICIO,COD_ADM,REG_SIAF,"
                    + "BENEFICIARIO,GRADO,RESOL,OFICIO,IMPORTE,"
                    + "NVL(NROCOB,' ') AS NROCOB,FEC_COMP,FEC_DEVENG,FEC_GIRD "
                    + " FROM V_CONSULTA_DERECHO_PERSONAL WHERE "
                    + "CODPER LIKE '%?%' AND "
                    + "COD_ADM=? "
                    + "ORDER BY CODPER ";      
        }   */
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDerechoPersonal.getPeriodo());
            objPreparedStatement.setString(2, objBeanDerechoPersonal.getReferencia());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDerechoPersonal = new BeanDerechoPersonal();
                objBnDerechoPersonal.setPeriodo(objResultSet.getString("CODPER"));
                objBnDerechoPersonal.setCodigoBeneficio(objResultSet.getString("DES_BENEFICIO"));
                objBnDerechoPersonal.setCodigoAdministrativo(objResultSet.getString("COD_ADM"));
                objBnDerechoPersonal.setCodigo(objResultSet.getString("REG_SIAF"));
                objBnDerechoPersonal.setReferencia(objResultSet.getString("BENEFICIARIO"));
                objBnDerechoPersonal.setAsunto(objResultSet.getString("GRADO"));
                objBnDerechoPersonal.setResolucion(objResultSet.getInt("RESOL"));
                objBnDerechoPersonal.setOficio(objResultSet.getInt("OFICIO"));
                objBnDerechoPersonal.setImporteBeneficiario(objResultSet.getInt("IMPORTE"));
                objBnDerechoPersonal.setCobertura(objResultSet.getString("NROCOB"));
                objBnDerechoPersonal.setFecOficio(objResultSet.getString("FEC_COMP"));
                objBnDerechoPersonal.setFecResolucion(objResultSet.getString("FEC_DEVENG"));
                objBnDerechoPersonal.setMes(objResultSet.getString("FEC_GIRD"));
                lista.add(objBnDerechoPersonal);
            }
            objResultSet.close();
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsultaJADPE(BeanDerechoPersonal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("RESODP");
            objBnMsgerr.setTipo(objBnDerechoPersonal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        }
        return lista;
    }

}
