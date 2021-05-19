/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanEventos;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.EventoSecundarioDAO;
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
public class EventoSecundarioDAOImpl implements EventoSecundarioDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanEventos objBnEvento;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public EventoSecundarioDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public BeanEventos getEventoPrincipal(BeanEventos objBeanEvento, String usuario) {
        sql = "SELECT CODNIV AS NIVELES, NUMEVE AS EVENTO, COMEOP||'-'||UTIL_NEW.FUN_NOMEOP(COMEOP) AS TAREA "
                + "FROM EVEPRI WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "CODEVE LIKE ? AND "
                + "ESTREG!='AN' ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEvento.getPeriodo());
            objPreparedStatement.setString(2, objBeanEvento.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEvento.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEvento.getTarea());
            objPreparedStatement.setString(5, "%"+objBeanEvento.getCodigo().substring(3));
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanEvento.setNiveles(objResultSet.getInt("NIVELES"));
                objBeanEvento.setEvento(objResultSet.getInt("EVENTO"));
                objBeanEvento.setComentario(objResultSet.getString("TAREA"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getEventoPrincipal(objBeanEvento) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
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
        return objBeanEvento;
    }
    
    @Override
    public BeanEventos getEventoSecundario(BeanEventos objBeanEvento, String usuario) {
        sql = "SELECT  CODEVE AS CODIGO, NOMEVE AS NOMBRE_EVENTO "
                + "FROM EVEPRI WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "CODEVE=? AND "
                + "ESTREG!='AN' ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEvento.getPeriodo());
            objPreparedStatement.setString(2, objBeanEvento.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEvento.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEvento.getTarea());
            objPreparedStatement.setString(5, objBeanEvento.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanEvento.setCodigo(objResultSet.getString("CODIGO"));
                objBeanEvento.setNombreEvento(objResultSet.getString("NOMBRE_EVENTO"));                
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getEventoSecundario(objBeanEvento) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
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
        return objBeanEvento;
    }

    @Override
    public List getListaEventoPrincipal(BeanEventos objBeanEvento, String usuario) {
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
                + "NIVEVE=0 AND "
                + "ESTREG!='AN' "
                + "ORDER BY NUMEVE";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEvento.getPeriodo());
            objPreparedStatement.setString(2, objBeanEvento.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEvento.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEvento.getTarea());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBeanEvento = new BeanEventos();
                objBeanEvento.setCodigo(objResultSet.getString("CODIGO"));
                objBeanEvento.setNombreEvento(objResultSet.getString("NOMBRE_EVENTO"));
                objBeanEvento.setEvento(objResultSet.getInt("EVENTO"));
                objBeanEvento.setNivel(objResultSet.getInt("NIVEL"));
                objBeanEvento.setCantidad(objResultSet.getInt("CANTIDAD"));
                objBeanEvento.setProgramado(objResultSet.getDouble("MONTO"));
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
                lista.add(objBeanEvento);
                objBeanEvento.setComentario(objResultSet.getString("TAREA"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getEventoPrincipal(BeanEventoPrincipal) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
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
            System.out.println("Error al obtener getListaEventoFinal(BeanEventoPrincipal) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
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
    public List getListaEventoSecundario(BeanEventos objBeanEvento, String usuario) {
        String codigo = "HTS" + objBeanEvento.getCodigo().substring(3);        
        lista = new LinkedList<>();
        sql = "SELECT CODEVE AS CODIGO, NOMEVE AS NOMBRE_EVENTO, "
                + "SD_PFE.FUN_MONTO_EVEPRI(CODPER, COPPTO, COUUOO, CODDEP, COMEOP, CODEVE) MONTO "
                + "FROM EVEPRI WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "CODEVE LIKE ? AND "
                + "NIVEVE=? AND "
                + "ESTREG!='AN' "
                + "ORDER BY NUMEVE";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEvento.getPeriodo());
            objPreparedStatement.setString(2, objBeanEvento.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEvento.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEvento.getTarea());
            objPreparedStatement.setString(5, codigo+'%');
            objPreparedStatement.setInt(6, objBeanEvento.getNivel());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnEvento = new BeanEventos();
                objBnEvento.setCodigo(objResultSet.getString("CODIGO"));
                objBnEvento.setNombreEvento(objResultSet.getString("NOMBRE_EVENTO"));  
                objBnEvento.setTotal(objResultSet.getDouble("MONTO"));  
                lista.add(objBnEvento);                
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaEventoSecundario(objBeanEvento) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
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
    public String getCodigoEventoSecundario(BeanEventos objBeanEvento, String usuario) {
        String codigo = "HTS" + objBeanEvento.getCodigo().substring(3);
        sql = "SELECT (NVL(MAX(NUMEVE),0)+1) AS CODIGO "
                + "FROM EVEPRI WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? AND "
                + "COMEOP=? AND "
                + "CODEVE LIKE ? AND "
                + "NIVEVE=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanEvento.getPeriodo());
            objPreparedStatement.setString(2, objBeanEvento.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanEvento.getPresupuesto());
            objPreparedStatement.setString(4, objBeanEvento.getTarea());
            objPreparedStatement.setString(5, codigo+'%');
            objPreparedStatement.setInt(6, objBeanEvento.getNivel());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                codigo = codigo + "-" + objResultSet.getInt("CODIGO");               
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCodigoEventoSecundario(BeanEvento : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
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
        return codigo;
    }
    
    @Override
    public int iduEventoSecundario(BeanEventos objBeanEvento, String usuario) {
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
            cs.setInt(8, 0);            
            cs.setInt(9, objBeanEvento.getNivel());
            cs.setString(10, "");
            cs.setBoolean(11, false);
            cs.setString(12, usuario);
            cs.setString(13, objBeanEvento.getMode());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduEventoSecundario : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("EVEPRI");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduEventoPrincipal : " + e.toString());
            }
        }
        return s;
    }

}
