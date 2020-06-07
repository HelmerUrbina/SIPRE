/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanIngresosPorGrado;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.ConceptoIngresosDAO;
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
 * @author H-TECCSI-V
 */
public class ConceptoIngresosDAOImpl implements ConceptoIngresosDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanIngresosPorGrado objBnIngresosGrado;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ConceptoIngresosDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getConsultaConceptoIngreso(BeanIngresosPorGrado objBeanIngresosGrado, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CG.CODGRD||'-'||NVL(CG.CPERIODO_REE,0) AS CODIGO,"
                + "CG.CODGRD,CG.CPERIODO_REE,"
                + "UTIL_NEW.FUN_NOMBRE_GRADO(CG.CODGRD) AS GRADO,"
                + "UTIL_NEW.FUN_DESCRIPCION_GRADO(CG.CODGRD) AS NOMGRD,"
                + "CASE CG.CPERIODO_REE WHEN 'P1' THEN '1er Periodo' "
                + "WHEN 'P2' THEN '2do Periodo' "
                + "WHEN 'P3' THEN '3er Periodo'"
                + "WHEN 'P4' THEN '4to Periodo' "
                + "WHEN 'P5' THEN '5to Periodo'"
                + "ELSE '' END AS PERIODO_REE,"
                + "CASE NVL(CG.CPERIODO_REE,0) WHEN '0' THEN "
                + "UTIL.FUN_INGRESOS_PERS_GRADO(?,?,TG.NNIVEL_GRADO_CODIGO,CG.CODGRD) ELSE "
                + "UTIL.FUN_INGRESOS_PERS_GRADO_REE(?,?,9,CG.CODGRD,CG.CPERIODO_REE) END AS IMPORTE,"
                + "TG.NNIVEL_GRADO_CODIGO AS NIVEL "
                + "FROM SIPE_CONCEPTO_INGRE_GRADO CG JOIN TABGRD TG ON "
                + "(CG.CODGRD=TG.CODGRD) "
                + "WHERE CG.NCONCEPTO_INGRESOS_COD=? "
                + "ORDER BY CG.CODGRD,CG.CPERIODO_REE";        
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanIngresosGrado.getPeriodo());
            objPreparedStatement.setInt(2, objBeanIngresosGrado.getCodConcepto());
            objPreparedStatement.setString(3, objBeanIngresosGrado.getPeriodo());
            objPreparedStatement.setInt(4, objBeanIngresosGrado.getCodConcepto());
            objPreparedStatement.setInt(5, objBeanIngresosGrado.getCodConcepto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnIngresosGrado = new BeanIngresosPorGrado();
                objBnIngresosGrado.setDesConcepto(objResultSet.getString("CODIGO"));
                objBnIngresosGrado.setCodGrado(objResultSet.getString("CODGRD"));
                objBnIngresosGrado.setPeriodoRee(objResultSet.getString("CPERIODO_REE"));
                objBnIngresosGrado.setAbvGrado(objResultSet.getString("GRADO"));                
                objBnIngresosGrado.setDesGrado(objResultSet.getString("NOMGRD"));
                objBnIngresosGrado.setDesPeriodo(objResultSet.getString("PERIODO_REE"));
                objBnIngresosGrado.setIngresoGrado(objResultSet.getDouble("IMPORTE"));
                objBnIngresosGrado.setNivelGrado(objResultSet.getInt("NIVEL"));
                lista.add(objBnIngresosGrado);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsultaConceptoIngreso(objBeanIngresosGrado) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_CONCEPTO_INGRE_GRADO");
            objBnMsgerr.setTipo(objBeanIngresosGrado.getMode().toUpperCase());
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
    public BeanIngresosPorGrado getConceptoIngresos(BeanIngresosPorGrado objBeanIngresosGrado, String usuario) {
        sql = "SELECT CP.NCONCEPTO_INGRESOS_COD AS CODIGO,"
                + "CP.VCONCEPTO_INGRESOS_DESCRIP AS DESCRIPCION "
                + "FROM SIPE_CONCEP_INGRESOS_PERS CP "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setInt(1, objBeanIngresosGrado.getCodConcepto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBeanIngresosGrado.setCodConcepto(objResultSet.getInt("CODIGO"));
                objBeanIngresosGrado.setDesConcepto(objResultSet.getString("DESCRIPCION"));
                lista.add(objBnIngresosGrado);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConceptoIngresos(objBeanIngresosGrado) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_CONCEP_INGRESOS_PERS");
            objBnMsgerr.setTipo(objBeanIngresosGrado.getMode().toUpperCase());
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
        return objBeanIngresosGrado;
    }

    @Override
    public int iduConceptoIngresos(BeanIngresosPorGrado objBeanIngresosGrado, String usuario) {
        sql = "{CALL SP_IDU_INGRESO_PERSONAL(?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanIngresosGrado.getPeriodo());
            cs.setInt(2, objBeanIngresosGrado.getCodConcepto());
            cs.setInt(3, objBeanIngresosGrado.getNivelGrado());
            cs.setString(4, objBeanIngresosGrado.getCodGrado().trim());
            cs.setString(5, objBeanIngresosGrado.getPeriodoRee());
            cs.setDouble(6, objBeanIngresosGrado.getIngresoGrado());
            cs.setString(7, usuario);
            cs.setString(8, objBeanIngresosGrado.getMode().toUpperCase());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduIngresoGrado : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_INGRESOS_PERSONAL_EP");
            objBnMsgerr.setTipo(objBeanIngresosGrado.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduConceptoIngresos : " + e.toString());
            }
        }
        return s;
    }
}
