/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanEventos;
import BusinessServices.Beans.BeanHojaTrabajo;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.EventoFinalDAO;
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
public class EventoFinalDAOImpl implements EventoFinalDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEventos objBnEvento;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public EventoFinalDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaEventoFinal(BeanEventos objBeanEvento, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT COEVFI AS EVENTO_FINAL, NOEVFI AS NOMBRE_EVENTO, UTIL_NEW.FUN_ABRDEP(COUUOO, CODDEP) AS DEPENDENCIA, "
                + "ORDCNV ORDEN, SD_PFE.FUN_MONTO_TAEVFI(CODPER, COPPTO, COUUOO, CODDEP, COMEOP, CODEVE, COEVFI) AS MONTO, "
                + "CASE ESTADO WHEN 'CE' THEN 'CERRADO' WHEN 'AN' THEN 'ANULADO' ELSE 'PENDIENTE' END AS ESTADO, "
                + "NMETA_FISICA AS CANTIDAD, COMEOP||'-'||UTIL_NEW.FUN_NOMEOP(COMEOP) AS TAREA, CODDEP AS CODIGO_DEPENDENCIA "
                + "FROM TAEVFI WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "CODEVE=? AND "
                + "ESTREG!='AN' "
                + "ORDER BY ORDEN";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEvento.getPeriodo());
            objPreparedStatement.setString(2, objBeanEvento.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEvento.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEvento.getTarea());
            objPreparedStatement.setString(5, objBeanEvento.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEvento = new BeanEventos();
                objBnEvento.setCodigo(objResultSet.getString("EVENTO_FINAL"));
                objBnEvento.setNombreEvento(objResultSet.getString("NOMBRE_EVENTO"));
                objBnEvento.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnEvento.setOrden(objResultSet.getInt("ORDEN"));
                objBnEvento.setProgramado(objResultSet.getDouble("MONTO"));
                objBnEvento.setEstado(objResultSet.getString("ESTADO"));
                objBnEvento.setCantidad(objResultSet.getInt("CANTIDAD"));
                objBnEvento.setUnidadOperativa(objResultSet.getString("CODIGO_DEPENDENCIA"));
                lista.add(objBnEvento);
                objBeanEvento.setComentario(objResultSet.getString("TAREA"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaEventoFinal(BeanEvento) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAEVFI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
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
    public List getListaHojaTrabajo(BeanEventos objBeanEvento, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT COITEM, UPPER(DESITM) AS ITEM, COUNME AS UNIDAD_MEDIDA, "
                + "PREVTA AS PRECIO, CANREQ AS CANTIDAD, COCAGA AS CADENA_GASTO "
                + "FROM TAHOTR WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "CODEVE=? AND "
                + "COEVFI=? "
                + "ORDER BY CODECN";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEvento.getPeriodo());
            objPreparedStatement.setString(2, objBeanEvento.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEvento.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEvento.getTarea());
            objPreparedStatement.setString(5, objBeanEvento.getCodigo());
            objPreparedStatement.setInt(6, objBeanEvento.getEvento());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                BeanHojaTrabajo objBnHojaTrabajo = new BeanHojaTrabajo();
                objBnHojaTrabajo.setCodigo(objResultSet.getString("COITEM"));
                objBnHojaTrabajo.setItem(objResultSet.getString("ITEM"));
                objBnHojaTrabajo.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBnHojaTrabajo.setPrecio(objResultSet.getDouble("PRECIO"));
                objBnHojaTrabajo.setCantidad(objResultSet.getDouble("CANTIDAD"));
                objBnHojaTrabajo.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                lista.add(objBnHojaTrabajo);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaHojaTrabajo(objBeanEvento) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAHOTR");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
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
    public String getUltimoEventoFinal(BeanEventos objBeanEvento, String usuario) {
        String result = "";
        sql = "SELECT MAX(TO_NUMBER(COEVFI)) AS EVENTO_FINAL "
                + "FROM TAEVFI WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "CODEVE=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEvento.getPeriodo());
            objPreparedStatement.setString(2, objBeanEvento.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEvento.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEvento.getTarea());
            objPreparedStatement.setString(5, objBeanEvento.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("EVENTO_FINAL");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getUltimoEventoFinal(objBeanEvento) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAEVFI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
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
        return result;
    }

    @Override
    public BeanEventos getEventoFinal(BeanEventos objBeanEvento, String usuario) {
        sql = "SELECT NOEVFI AS NOMBRE_EVENTO, CODDEP AS DEPENDENCIA, "
                + "NMETA_FISICA AS CANTIDAD, ORDCNV AS ORDEN "
                + "FROM TAEVFI WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "CODEVE=? AND "
                + "COEVFI=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEvento.getPeriodo());
            objPreparedStatement.setString(2, objBeanEvento.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEvento.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEvento.getTarea());
            objPreparedStatement.setString(5, objBeanEvento.getCodigo());
            objPreparedStatement.setInt(6, objBeanEvento.getEvento());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanEvento.setNombreEvento(objResultSet.getString("NOMBRE_EVENTO"));
                objBeanEvento.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBeanEvento.setOrden(objResultSet.getInt("ORDEN"));
                objBeanEvento.setCantidad(objResultSet.getInt("CANTIDAD"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getEventoFinal(objBeanEvento) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAEVFI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
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
        return objBeanEvento;
    }

    @Override
    public int iduEventoFinal(BeanEventos objBeanEvento, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_TAEVFI(?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEvento.getPeriodo());
            cs.setString(2, objBeanEvento.getUnidadOperativa());
            cs.setInt(3, objBeanEvento.getPresupuesto());
            cs.setString(4, objBeanEvento.getTarea());
            cs.setString(5, objBeanEvento.getCodigo());
            cs.setInt(6, objBeanEvento.getEvento());
            cs.setString(7, objBeanEvento.getNombreEvento());
            cs.setString(8, objBeanEvento.getDependencia());
            cs.setInt(9, objBeanEvento.getOrden());
            cs.setInt(10, objBeanEvento.getCantidad());
            cs.setString(11, usuario);
            cs.setString(12, objBeanEvento.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduEventoFinal : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAEVFI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
