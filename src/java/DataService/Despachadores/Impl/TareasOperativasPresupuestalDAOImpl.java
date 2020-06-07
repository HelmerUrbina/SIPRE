/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanTareaOperativaPresupuestal;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.TareasOperativasPresupuestalDAO;
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
public class TareasOperativasPresupuestalDAOImpl implements TareasOperativasPresupuestalDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanTareaOperativaPresupuestal objBnTareaOperativaPresupuestal;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public TareasOperativasPresupuestalDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaTareasOperativasPresupuestales(BeanTareaOperativaPresupuestal objBeanTareasOperativasPresupuestales, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CTAREA_CODIGO||'.'||NTAREA_OPERATIVA_CODIGO AS CODIGO, CTAREA_CODIGO||':'||UTIL_NEW.FUN_NTAREA(CTAREA_CODIGO) AS TAREA_PRESUPUESTAL, "
                + "NTAREA_OPERATIVA_CODIGO||':'||PK_PLANEAMIENTO.FUN_ABREVIATURA_TAREA_OPERATIV(NTAREA_OPERATIVA_CODIGO) AS TAREA_OPERATIVA "
                + "FROM SIPRE_TAREA_PRESUPUESTAL_OPERA WHERE "
                + "CPERIODO_CODIGO=? "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanTareasOperativasPresupuestales.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnTareaOperativaPresupuestal = new BeanTareaOperativaPresupuestal();
                objBnTareaOperativaPresupuestal.setCodigo(objResultSet.getString("CODIGO"));
                objBnTareaOperativaPresupuestal.setTareaOperativa(objResultSet.getString("TAREA_OPERATIVA"));
                objBnTareaOperativaPresupuestal.setTareaPresupuestal(objResultSet.getString("TAREA_PRESUPUESTAL"));
                lista.add(objBnTareaOperativaPresupuestal);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaTareasOperativasPresupuestales(usuario) : " + e.getMessage());
        } finally {
            try {
                if (objResultSet != null) {
                    objPreparedStatement.close();
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return lista;
    }

    @Override
    public ArrayList getTareasPresupuestales(BeanTareaOperativaPresupuestal objBeanTareasOperativasPresupuestales, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT COMEOP AS CODIGO, "
                + "COMEOP||':'||NTAREA AS DESCRIPCION "
                + "FROM TAMEOP WHERE "
                + "TO_NUMBER(COMEOP) NOT IN ("
                + "SELECT TO_NUMBER(CTAREA_CODIGO) "
                + "FROM SIPRE_TAREA_PRESUPUESTAL_OPERA WHERE "
                + "CPERIODO_CODIGO=?) "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanTareasOperativasPresupuestales.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("DESCRIPCION");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getTareasPresupuestales(objBeanTareaEspecifica, usuario) : " + e.getMessage());
        } finally {
            try {
                if (objResultSet != null) {
                    objPreparedStatement.close();
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return Arreglo;
    }

    @Override
    public int iduTareasOperativasPresupuestales(BeanTareaOperativaPresupuestal objBeanTareasOperativasPresupuestales, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA TABLA TAPAIN, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA,
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_TAREA_OPERATIVA_PRESUPU(?,?,?,?,?)}";
        try {
            try (CallableStatement cs = objConnection.prepareCall(sql)) {                
                cs.setString(1, objBeanTareasOperativasPresupuestales.getPeriodo());
                cs.setString(2, objBeanTareasOperativasPresupuestales.getTareaOperativa());
                cs.setString(3, objBeanTareasOperativasPresupuestales.getTareaPresupuestal());
                cs.setString(4, usuario);
                cs.setString(5, objBeanTareasOperativasPresupuestales.getMode());
                s = cs.executeUpdate();
            }
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduTareasOperativasPresupuestales : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_TAREA_PRESUPUESTAL_OPERA");
            objBnMsgerr.setTipo(objBnTareaOperativaPresupuestal.getMode());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return s;
    }

}
