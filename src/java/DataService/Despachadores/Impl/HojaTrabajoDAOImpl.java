/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanHojaTrabajo;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.HojaTrabajoDAO;
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
public class HojaTrabajoDAOImpl implements HojaTrabajoDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanHojaTrabajo objBnHojaTrabajo;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public HojaTrabajoDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaHojaTrabajo(BeanHojaTrabajo objBeanHojaTrabajo, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CODECN AS CORRELATIVO, UPPER(DESITM) AS ITEM, "
                + "UTIL_NEW.FUN_NOMBRE_UNIDAD_MEDIDA(COUNME) UNIDAD_MEDIDA, "
                + "PREVTA AS PRECIO, CANREQ AS CANTIDAD, (PREVTA*CANREQ) AS TOTAL, "
                + "COCAGA||'-'||UTIL.FUN_NOMBRE_CADGAS(COCAGA) AS CADENA_GASTO, "
                + "UTIL_NEW.FUN_NOMGEN(CODGEN) AS GENERICA, CHEKOB, COMEOP||'-'||UTIL_NEW.FUN_NOMEOP(COMEOP) AS TAREA "
                + "FROM TAHOTR WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "CODEVE=? AND "
                + "COEVFI=? "
                + "ORDER BY CORRELATIVO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanHojaTrabajo.getPeriodo());
            objPreparedStatement.setString(2, objBeanHojaTrabajo.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanHojaTrabajo.getPresupuesto());
            objPreparedStatement.setString(4, objBeanHojaTrabajo.getTarea());
            objPreparedStatement.setString(5, objBeanHojaTrabajo.getEventoPrincipal());
            objPreparedStatement.setString(6, objBeanHojaTrabajo.getEventoFinal());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnHojaTrabajo = new BeanHojaTrabajo();
                objBnHojaTrabajo.setCorrelativo(objResultSet.getInt("CORRELATIVO"));
                objBnHojaTrabajo.setItem(objResultSet.getString("ITEM"));
                objBnHojaTrabajo.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBnHojaTrabajo.setPrecio(objResultSet.getDouble("PRECIO"));
                objBnHojaTrabajo.setCantidad(objResultSet.getDouble("CANTIDAD"));
                objBnHojaTrabajo.setTotal(objResultSet.getDouble("TOTAL"));
                objBnHojaTrabajo.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnHojaTrabajo.setGenericaGasto(objResultSet.getString("GENERICA"));
                objBnHojaTrabajo.setMode(objResultSet.getString("CHEKOB"));
                lista.add(objBnHojaTrabajo);
                objBeanHojaTrabajo.setDescripcion(objResultSet.getString("TAREA"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaHojaTrabajo(objBeanHojaTrabajo) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAHOTR");
            objBnMsgerr.setTipo(objBeanHojaTrabajo.getMode().toUpperCase());
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
    public BeanHojaTrabajo getHojaTrabajo(BeanHojaTrabajo objBeanHojaTrabajo, String usuario) {
        sql = "SELECT COITEM AS CODIGO, DESITM AS ITEM, COCAGA AS CADENA_GASTO, COUNME AS UNIDAD_MEDIDA, "
                + "CANREQ AS CANTIDAD, PREVTA AS PRECIO "
                + "FROM TAHOTR WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "CODEVE=? AND "
                + "COEVFI=? AND "
                + "CODECN=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanHojaTrabajo.getPeriodo());
            objPreparedStatement.setString(2, objBeanHojaTrabajo.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanHojaTrabajo.getPresupuesto());
            objPreparedStatement.setString(4, objBeanHojaTrabajo.getTarea());
            objPreparedStatement.setString(5, objBeanHojaTrabajo.getEventoPrincipal());
            objPreparedStatement.setString(6, objBeanHojaTrabajo.getEventoFinal());
            objPreparedStatement.setInt(7, objBeanHojaTrabajo.getCorrelativo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanHojaTrabajo.setCodigo(objResultSet.getString("CODIGO"));
                objBeanHojaTrabajo.setItem(objResultSet.getString("ITEM"));
                objBeanHojaTrabajo.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBeanHojaTrabajo.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBeanHojaTrabajo.setCantidad(objResultSet.getDouble("CANTIDAD"));
                objBeanHojaTrabajo.setPrecio(objResultSet.getDouble("PRECIO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getHojaTrabajo(objBeanEvento) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAHOTR");
            objBnMsgerr.setTipo(objBeanHojaTrabajo.getMode().toUpperCase());
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
        return objBeanHojaTrabajo;
    }

    @Override
    public Double getSaldoHojaTrabajo(BeanHojaTrabajo objBeanHojaTrabajo, String usuario) {
        Double saldo = 0.0;
        sql = "SELECT  "
                + "SUM(NPROGRAMACION_MULTI_IMPORTE)-NVL(SD_PFE.FUN_TOTAL_HOJA_TRABAJO_DEP(CANIO_REGISTRO, CUNIDAD_OPERATIVA_CODIGO, "
                + "NPRESUPUESTO_CODIGO, CTAREA_CODIGO, CDEPENDENCIA_CODIGO, VCADENA_GASTO_CODIGO),0) AS SALDO "
                + "FROM SIPE_PROGRAMACION_MULTI_DETALL WHERE "
                + "CANIO_REGISTRO=? AND "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO='" + objBeanHojaTrabajo.getPresupuesto() + "' AND "
                + "CTAREA_CODIGO='" + objBeanHojaTrabajo.getTarea() + "' AND "
                + "CDEPENDENCIA_CODIGO=? AND "
                + "VCADENA_GASTO_CODIGO='" + objBeanHojaTrabajo.getCadenaGasto() + "' "
                + "GROUP BY CANIO_REGISTRO, CUNIDAD_OPERATIVA_CODIGO, NPRESUPUESTO_CODIGO, CTAREA_CODIGO, CDEPENDENCIA_CODIGO, VCADENA_GASTO_CODIGO"; 
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanHojaTrabajo.getPeriodo());
            objPreparedStatement.setString(2, objBeanHojaTrabajo.getPeriodo());
            objPreparedStatement.setString(3, objBeanHojaTrabajo.getUnidadOperativa());
            objPreparedStatement.setString(4, objBeanHojaTrabajo.getDependencia());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                saldo = objResultSet.getDouble("SALDO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getSaldoHojaTrabajo(objBeanEvento) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAHOTR");
            objBnMsgerr.setTipo(objBeanHojaTrabajo.getMode().toUpperCase());
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
        return saldo;
    }

    @Override
    public int iduHojaTrabajo(BeanHojaTrabajo objBeanEvento, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_TAHOTR(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEvento.getPeriodo());
            cs.setString(2, objBeanEvento.getUnidadOperativa());
            cs.setInt(3, objBeanEvento.getPresupuesto());
            cs.setString(4, objBeanEvento.getTarea());
            cs.setString(5, objBeanEvento.getEventoPrincipal());
            cs.setString(6, objBeanEvento.getEventoFinal());
            cs.setInt(7, objBeanEvento.getCorrelativo());
            cs.setString(8, objBeanEvento.getCadenaGasto());
            cs.setString(9, objBeanEvento.getCodigo());
            cs.setString(10, objBeanEvento.getItem());
            cs.setString(11, objBeanEvento.getUnidadMedida());
            cs.setDouble(12, objBeanEvento.getCantidad());
            cs.setDouble(13, objBeanEvento.getPrecio());
            cs.setString(14, usuario);
            cs.setString(15, objBeanEvento.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduHojaTrabajo : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAHOTR");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
