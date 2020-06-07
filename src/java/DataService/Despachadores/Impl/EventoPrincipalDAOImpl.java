/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanEventos;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.EventoPrincipalDAO;
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
public class EventoPrincipalDAOImpl implements EventoPrincipalDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEventos objBnEventoPrincipal;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public EventoPrincipalDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getTotalesEventoPrincipal(BeanEventos objBeanEvento, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT TAPAIN.COMEOP AS CODIGO, TAPAIN.COMEOP||':'||UTIL_NEW.FUN_NOMEOP(TAPAIN.COMEOP) AS TAREA, "
                + "SD_PFE.FUN_MONTO_EVEPRI_TAREA(TAPAIN.CODPER, TAPAIN.COPPTO, TAPAIN.COUUOO, EVEPRI.CODDEP, TAPAIN.COMEOP) TOTAL, "
                + "SD_PFE.FUN_META_FISICA_EVEPRI(TAPAIN.CODPER, TAPAIN.COUUOO, TAPAIN.COPPTO, TAPAIN.COMEOP) AS CANTIDAD, "
                + "UTIL_NEW.FUN_NOUNME_TAPAIN(TAPAIN.COMEOP) AS UNIDAD_MEDIDA, "
                + "OPRE.FUN_IMPORTE_TAREA_PROG(TAPAIN.CODPER, TAPAIN.COPPTO, TAPAIN.COUUOO, TAPAIN.COMEOP) AS PROGRAMADO "
                + "FROM TAPAIN LEFT OUTER JOIN EVEPRI ON (TAPAIN.CODPER=EVEPRI.CODPER AND TAPAIN.COUUOO=EVEPRI.COUUOO AND "
                + "TAPAIN.COMEOP=EVEPRI.COMEOP AND TAPAIN.COPPTO=EVEPRI.COPPTO) WHERE "
                + "TAPAIN.CODPER = ? AND "
                + "TAPAIN.COUUOO = ? AND "
                + "TAPAIN.COPPTO = ? AND (EVEPRI.CODDEP IS NULL OR EVEPRI.CODDEP = '001') "
                + "GROUP BY TAPAIN.CODPER, TAPAIN.COPPTO, TAPAIN.COUUOO, EVEPRI.CODDEP, TAPAIN.COMEOP "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEvento.getPeriodo());
            objPreparedStatement.setString(2, objBeanEvento.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEvento.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEventoPrincipal = new BeanEventos();
                objBnEventoPrincipal.setCodigo(objResultSet.getString("CODIGO"));
                objBnEventoPrincipal.setTarea(objResultSet.getString("TAREA"));
                objBnEventoPrincipal.setTotal(objResultSet.getDouble("TOTAL"));
                objBnEventoPrincipal.setCantidad(objResultSet.getInt("CANTIDAD"));
                objBnEventoPrincipal.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBnEventoPrincipal.setProgramado(objResultSet.getDouble("PROGRAMADO"));
                lista.add(objBnEventoPrincipal);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getTotalesEventoPrincipal(BeanEventoPrincipal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
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
    public List getListaEventoPrincipal(BeanEventos objBeanEventoPrincipal, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CODEVE AS CODIGO, NOMEVE AS NOMBRE_EVENTO, NUMEVE AS EVENTO, CODNIV AS NIVEL, "
                + "SD_PFE.FUN_CANT_EVEPRI(CODPER, COPPTO, COUUOO, CODDEP, COMEOP, CODEVE) CANTIDAD,"
                + "SD_PFE.FUN_MONTO_EVEPRI(CODPER, COPPTO, COUUOO, CODDEP, COMEOP, CODEVE) MONTO, "
                + "CANENE AS ENERO, CANFEB AS FEBRERO, CANMAR AS MARZO, CANABR AS ABRIL, CANMAY AS MAYO, CANJUN AS JUNIO, "
                + "CANJUL AS JULIO, CANAGO AS AGOSTO, CANSET AS SETIEMBRE, CANOCT AS OCTUBRE, CANNOV AS NOVIEMBRE, CANDIC AS DICIEMBRE, "
                + "(CANENE+CANFEB+CANMAR+CANABR+CANMAY+CANJUN+CANJUL+CANAGO+CANSET+CANOCT+CANNOV+CANDIC) AS TOTAL, "
                + "COMEOP||'-'||UTIL_NEW.FUN_NOMEOP(COMEOP) AS TAREA "
                + "FROM EVEPRI WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "NIVEVE=0 "
                + "ORDER BY NUMEVE";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEventoPrincipal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEventoPrincipal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEventoPrincipal.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEventoPrincipal.getTarea());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEventoPrincipal = new BeanEventos();
                objBnEventoPrincipal.setCodigo(objResultSet.getString("CODIGO"));
                objBnEventoPrincipal.setNombreEvento(objResultSet.getString("NOMBRE_EVENTO"));
                objBnEventoPrincipal.setEvento(objResultSet.getInt("EVENTO"));
                objBnEventoPrincipal.setNivel(objResultSet.getInt("NIVEL"));
                objBnEventoPrincipal.setCantidad(objResultSet.getInt("CANTIDAD"));
                objBnEventoPrincipal.setProgramado(objResultSet.getDouble("MONTO"));
                objBnEventoPrincipal.setEnero(objResultSet.getDouble("ENERO"));
                objBnEventoPrincipal.setFebrero(objResultSet.getDouble("FEBRERO"));
                objBnEventoPrincipal.setMarzo(objResultSet.getDouble("MARZO"));
                objBnEventoPrincipal.setAbril(objResultSet.getDouble("ABRIL"));
                objBnEventoPrincipal.setMayo(objResultSet.getDouble("MAYO"));
                objBnEventoPrincipal.setJunio(objResultSet.getDouble("JUNIO"));
                objBnEventoPrincipal.setJulio(objResultSet.getDouble("JULIO"));
                objBnEventoPrincipal.setAgosto(objResultSet.getDouble("AGOSTO"));
                objBnEventoPrincipal.setSetiembre(objResultSet.getDouble("SETIEMBRE"));
                objBnEventoPrincipal.setOctubre(objResultSet.getDouble("OCTUBRE"));
                objBnEventoPrincipal.setNoviembre(objResultSet.getDouble("NOVIEMBRE"));
                objBnEventoPrincipal.setDiciembre(objResultSet.getDouble("DICIEMBRE"));
                objBnEventoPrincipal.setTotal(objResultSet.getDouble("TOTAL"));
                lista.add(objBnEventoPrincipal);
                objBeanEventoPrincipal.setComentario(objResultSet.getString("TAREA"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getEventoPrincipal(BeanEventoPrincipal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBeanEventoPrincipal.getMode().toUpperCase());
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
    public String getCodigoEventoPrincipal(BeanEventos objBeanEventoPrincipal, String usuario) {
        String codigo = "";
        sql = "SELECT (NVL(MAX(NUMEVE),0)+1) AS CODIGO "
                + "FROM EVEPRI WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "NIVEVE = 0 ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEventoPrincipal.getPeriodo());
            objPreparedStatement.setString(2, objBeanEventoPrincipal.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEventoPrincipal.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEventoPrincipal.getTarea());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                codigo = "CNV" + "-" + objBeanEventoPrincipal.getTarea() + "-" + objResultSet.getInt("CODIGO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCodigoEventoPrincipal(BeanEventoPrincipal : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBeanEventoPrincipal.getMode().toUpperCase());
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
    public BeanEventos getEventoPrincipal(BeanEventos objBeanEvento, String usuario) {
        sql = "SELECT NOMEVE AS NOMBRE_EVENTO, CAEVPR AS CANTIDAD, CODNIV AS NIVEL, COMENTARIO, EVENTO_FINAL "
                + "FROM EVEPRI WHERE "
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
            objPreparedStatement.setString(5, objBeanEvento.getCodigo().toUpperCase());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanEvento.setNombreEvento(objResultSet.getString("NOMBRE_EVENTO"));
                objBeanEvento.setCantidad(objResultSet.getInt("CANTIDAD"));
                objBeanEvento.setNivel(objResultSet.getInt("NIVEL"));
                objBeanEvento.setComentario(objResultSet.getString("COMENTARIO"));
                objBeanEvento.setUltimoEvento(objResultSet.getBoolean("EVENTO_FINAL"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getEventoPrincipal(objBeanEvento) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
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
    public BeanEventos getCantidadesFisicas(BeanEventos objBeanEvento, String usuario) {
        sql = "SELECT UTIL_NEW.FUN_NOMEOP(COMEOP) AS TAREA, UTIL_NEW.FUN_NOUNME_TAPAIN(COMEOP) AS UNIDAD_MEDIDA, "
                + "CANENE AS ENERO, CANFEB AS FEBRERO, CANMAR AS MARZO, CANABR AS ABRIL, CANMAY AS MAYO, CANJUN AS JUNIO, "
                + "CANJUL AS JULIO, CANAGO AS AGOSTO, CANSET AS SETIEMBRE, CANOCT AS OCTUBRE, CANNOV AS NOVIEMBRE, CANDIC AS DICIEMBRE, "
                + "(CANENE+CANFEB+CANMAR+CANABR+CANMAY+CANJUN+CANJUL+CANAGO+CANSET+CANOCT+CANNOV+CANDIC) AS TOTAL "
                + "FROM EVEPRI WHERE "
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
            objPreparedStatement.setString(5, objBeanEvento.getCodigo().toUpperCase());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanEvento.setNombreEvento(objResultSet.getString("TAREA"));
                objBeanEvento.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBeanEvento.setEnero(objResultSet.getDouble("ENERO"));
                objBeanEvento.setFebrero(objResultSet.getDouble("FEBRERO"));
                objBeanEvento.setMarzo(objResultSet.getDouble("MARZO"));
                objBeanEvento.setAbril(objResultSet.getDouble("ABRIL"));
                objBeanEvento.setMayo(objResultSet.getDouble("MAYO"));
                objBeanEvento.setJunio(objResultSet.getDouble("JUNIO"));
                objBeanEvento.setJulio(objResultSet.getDouble("JULIO"));
                objBeanEvento.setAgosto(objResultSet.getDouble("AGOSTO"));
                objBeanEvento.setSetiembre(objResultSet.getDouble("SETIEMBRE"));
                objBeanEvento.setOctubre(objResultSet.getDouble("OCTUBRE"));
                objBeanEvento.setNoviembre(objResultSet.getDouble("NOVIEMBRE"));
                objBeanEvento.setDiciembre(objResultSet.getDouble("DICIEMBRE"));
                objBeanEvento.setTotal(objResultSet.getDouble("TOTAL"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCantidadesFisicas(objBeanEvento) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
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
    public int iduEventoPrincipal(BeanEventos objBeanEvento, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_EVEPRI(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEvento.getPeriodo());
            cs.setString(2, objBeanEvento.getUnidadOperativa());
            cs.setInt(3, objBeanEvento.getPresupuesto());
            cs.setString(4, objBeanEvento.getTarea());
            cs.setString(5, objBeanEvento.getCodigo());
            cs.setString(6, objBeanEvento.getNombreEvento());
            cs.setInt(7, objBeanEvento.getNiveles());
            cs.setInt(8, objBeanEvento.getCantidad());
            cs.setInt(9, objBeanEvento.getNivel());
            cs.setString(10, objBeanEvento.getComentario());
            cs.setBoolean(11, objBeanEvento.getUltimoEvento());
            cs.setString(12, usuario);
            cs.setString(13, objBeanEvento.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduEventoPrincipal : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduCantidadesFisicas(BeanEventos objBeanEvento, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_TAMOFI(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEvento.getPeriodo());
            cs.setString(2, objBeanEvento.getUnidadOperativa());
            cs.setInt(3, objBeanEvento.getPresupuesto());
            cs.setString(4, objBeanEvento.getTarea());
            cs.setString(5, objBeanEvento.getCodigo());
            cs.setDouble(6, objBeanEvento.getEnero());
            cs.setDouble(7, objBeanEvento.getFebrero());
            cs.setDouble(8, objBeanEvento.getMarzo());
            cs.setDouble(9, objBeanEvento.getAbril());
            cs.setDouble(10, objBeanEvento.getMayo());
            cs.setDouble(11, objBeanEvento.getJunio());
            cs.setDouble(12, objBeanEvento.getJulio());
            cs.setDouble(13, objBeanEvento.getAgosto());
            cs.setDouble(14, objBeanEvento.getSetiembre());
            cs.setDouble(15, objBeanEvento.getOctubre());
            cs.setDouble(16, objBeanEvento.getNoviembre());
            cs.setDouble(17, objBeanEvento.getDiciembre());
            cs.setString(18, usuario);
            s = cs.executeUpdate();
            cs.close();
        } catch (Exception e) {
            System.out.println("Error al ejecutar iduEventoPrincipal : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
