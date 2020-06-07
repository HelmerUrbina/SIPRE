/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanEjecucionEstado;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.EjecucionEstadoDAO;
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
public class EjecucionEstadoDAOImpl implements EjecucionEstadoDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEjecucionEstado objBnEjecucionEstado;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public EjecucionEstadoDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaEjecucionEstado(BeanEjecucionEstado objBeanEjecucionEstado, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT MAX(EJE.NEJECUCION_ESTADO_CODIGO) AS CODIGO, UNI.COUUOO, UNI.COUUOO||':'||UNI.ABUUOO AS UNIDAD, "
                + "CASE EJE.CEJECUCION_ESTADO_TIPO WHEN 'Y' THEN 'true' ELSE 'false' END AS TIPO, "
                + "DEJECUCION_ESTADO_DESDE AS DESDE, DEJECUCION_ESTADO_HASTA HASTA "
                + "FROM TAUUOO UNI LEFT OUTER JOIN SIPE_EJECUCION_ESTADO EJE ON "
                + "UNI.COUUOO=EJE.CUNIDAD_OPERATIVA_CODIGO WHERE "
                + "EJE.CPERIODO_CODIGO=? AND "
                + "EJE.NPRESUPUESTO_CODIGO=? AND "
                + "EJE.CEJECUCION_ESTADO_OPCION=? AND "
                + "EJE.CEJECUCION_ESTADO_ESTADO='AC' AND "
                + "UNI.TIUUOO='U' AND "
                + "UNI.ESTREG='AC' AND "
                + "UNI.COUUOO NOT IN ('*   ','0003') "
                + "GROUP BY UNI.COUUOO, UNI.ABUUOO, CEJECUCION_ESTADO_TIPO, DEJECUCION_ESTADO_DESDE, DEJECUCION_ESTADO_HASTA "
                + "ORDER BY UNI.COUUOO";        
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionEstado.getPeriodo());
            objPreparedStatement.setInt(2, objBeanEjecucionEstado.getPresupuesto());
            objPreparedStatement.setString(3, objBeanEjecucionEstado.getOpcion());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEjecucionEstado = new BeanEjecucionEstado();
                objBnEjecucionEstado.setCodigo(objResultSet.getInt("CODIGO"));
                objBnEjecucionEstado.setOpcion(objResultSet.getString("COUUOO"));
                objBnEjecucionEstado.setUnidadOperativa(objResultSet.getString("UNIDAD"));
                objBnEjecucionEstado.setTipo(objResultSet.getString("TIPO"));
                objBnEjecucionEstado.setDesde(objResultSet.getDate("DESDE"));
                objBnEjecucionEstado.setHasta(objResultSet.getDate("HASTA"));
                lista.add(objBnEjecucionEstado);
            }
            if (lista.isEmpty()) {
                sql = "SELECT COUUOO, COUUOO||':'||ABUUOO AS UNIDAD, 'true' AS TIPO, "
                        + "SYSDATE AS DESDE, TO_DATE('31/12/'||extract (year  from sysdate),'DD/MM/YYYY') AS HASTA "
                        + "FROM TAUUOO WHERE "
                        + "TIUUOO='U' AND "
                        + "ESTREG='AC' AND "
                        + "COUUOO NOT IN ('*   ','0003') "
                        + "GROUP BY COUUOO, ABUUOO "
                        + "ORDER BY COUUOO";
                objPreparedStatement = objConnection.prepareStatement(sql);
                objResultSet = objPreparedStatement.executeQuery();
                while (objResultSet.next()) {
                    objBnEjecucionEstado = new BeanEjecucionEstado();
                    objBnEjecucionEstado.setUnidadOperativa(objResultSet.getString("UNIDAD"));
                    objBnEjecucionEstado.setOpcion(objResultSet.getString("COUUOO"));
                    objBnEjecucionEstado.setTipo(objResultSet.getString("TIPO"));
                    objBnEjecucionEstado.setDesde(objResultSet.getDate("DESDE"));
                    objBnEjecucionEstado.setHasta(objResultSet.getDate("HASTA"));
                    lista.add(objBnEjecucionEstado);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaEjecucionEstado(objBeanEjecucionEstado) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_EJECUCION_ESTADO");
            objBnMsgerr.setTipo(objBeanEjecucionEstado.getMode().toUpperCase());
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
        return lista;
    }

    @Override
    public Integer getCodigoEjecucionEstado(BeanEjecucionEstado objBeanEjecucionEstado, String usuario) {
        Integer codigo = 0;
        sql = "SELECT NVL(MAX(NEJECUCION_ESTADO_CODIGO+1),1) AS CODIGO "
                + "FROM SIPE_EJECUCION_ESTADO WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CEJECUCION_ESTADO_OPCION=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEjecucionEstado.getPeriodo());
            objPreparedStatement.setInt(2, objBeanEjecucionEstado.getPresupuesto());
            objPreparedStatement.setString(3, objBeanEjecucionEstado.getOpcion());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                codigo = objResultSet.getInt("CODIGO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCodigoEjecucionEstado(objBeanEjecucionEstado) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_EJECUCION_ESTADO");
            objBnMsgerr.setTipo(objBeanEjecucionEstado.getMode().toUpperCase());
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
        return codigo;
    }

    @Override
    public int iduEjecucionEstado(BeanEjecucionEstado objBeanEjecucionEstado, String usuario) {
        sql = "{CALL SP_IDU_EJECUCION_ESTADO(?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEjecucionEstado.getPeriodo());
            cs.setInt(2, objBeanEjecucionEstado.getPresupuesto());
            cs.setString(3, objBeanEjecucionEstado.getOpcion());
            cs.setInt(4, objBeanEjecucionEstado.getCodigo());
            cs.setString(5, objBeanEjecucionEstado.getUnidadOperativa());
            cs.setString(6, objBeanEjecucionEstado.getTipo());
            cs.setDate(7, objBeanEjecucionEstado.getDesde());
            cs.setDate(8, objBeanEjecucionEstado.getHasta());
            cs.setString(9, usuario);
            cs.setString(10, objBeanEjecucionEstado.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduEjecucionEstado : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_EJECUCION_ESTADO");
            objBnMsgerr.setTipo(objBeanEjecucionEstado.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }
}
