/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanTareaEspecifica;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.TareaEspecificaDAO;
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
public class TareaEspecificaDAOImpl implements TareaEspecificaDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanTareaEspecifica objBnTareaEspecifica;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public TareaEspecificaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaTareasEspecificas(BeanTareaEspecifica objBeanTareaEspecifica, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT COMEOP||'.'||COCAGA AS CODIGO, COMEOP||'-'||UTIL_NEW.FUN_NTAREA(COMEOP) AS TAREA, "
                + "COCAGA||'-'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(COCAGA) AS CADENA_GASTO "
                + "FROM SIPE_TAREA_ESPECIFICA WHERE "
                + "CODPER=? "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanTareaEspecifica.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnTareaEspecifica = new BeanTareaEspecifica();
                objBnTareaEspecifica.setCodigo(objResultSet.getString("CODIGO"));
                objBnTareaEspecifica.setTarea(objResultSet.getString("TAREA"));
                objBnTareaEspecifica.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                lista.add(objBnTareaEspecifica);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaTareasEspecificas(usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_TAREA_ESPECIFICA");
            objBnMsgerr.setTipo("G");
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
    public ArrayList getCadenaGasto(BeanTareaEspecifica objBeanTareaEspecifica, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT TO_NUMBER(COTITR)||'.'||TO_NUMBER(COGEGA)||'.'||TO_NUMBER(TRIM(COGEG1))||'.'||TO_NUMBER(TRIM(COGEG2))||'.'||TO_NUMBER(TRIM(COESG1))||'.'||TO_NUMBER(TRIM(COESG2)) AS CODIGO, "
                + "TO_NUMBER(COTITR)||'.'||TO_NUMBER(COGEGA)||'.'||TO_NUMBER(TRIM(COGEG1))||'.'||TO_NUMBER(TRIM(COGEG2))||'.'||TO_NUMBER(TRIM(COESG1))||'.'||TO_NUMBER(TRIM(COESG2))||':'||NOCAGA AS DESCRIPCION "
                + "FROM CADGAS WHERE "
                + "COTITR='2' AND "
                + "TO_NUMBER(COTITR)||'.'||TO_NUMBER(COGEGA)||'.'||TO_NUMBER(TRIM(COGEG1))||'.'||TO_NUMBER(TRIM(COGEG2))||'.'||TO_NUMBER(TRIM(COESG1))||'.'||TO_NUMBER(TRIM(COESG2)) NOT IN ("
                + "SELECT COCAGA AS CODIGO "
                + "FROM SIPE_TAREA_ESPECIFICA WHERE "
                + "CODPER=? AND "
                + "COMEOP=?) "
                + "ORDER BY "
                + "TO_NUMBER(COTITR), TO_NUMBER(COGEGA), TO_NUMBER(TRIM(COGEG1)), TO_NUMBER(TRIM(COGEG2)), "
                + "TO_NUMBER(TRIM(COESG1)), TO_NUMBER(TRIM(COESG2))";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanTareaEspecifica.getPeriodo());
            objPreparedStatement.setString(2, objBeanTareaEspecifica.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("DESCRIPCION");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCadenaGasto(objBeanTareaEspecifica, usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_TAREA_ESPECIFICA");
            objBnMsgerr.setTipo("O");
            objBnMsgerr.setDescripcion(e.toString());
            objDsMsgerr.iduMsgerr(objBnMsgerr);
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
    public int iduTareasEspecificas(BeanTareaEspecifica objBeanTareaEspecifica, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA TABLA TAPAIN, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA,
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_TAREA_ESPECIFICA(?,?,?,?,?)}";
        try {
            try (CallableStatement cs = objConnection.prepareCall(sql)) {
                cs.setString(1, objBeanTareaEspecifica.getPeriodo());
                cs.setString(2, objBeanTareaEspecifica.getTarea());
                cs.setString(3, objBeanTareaEspecifica.getCadenaGasto());
                cs.setString(4, usuario);
                cs.setString(5, objBeanTareaEspecifica.getMode());
                objResultSet = cs.executeQuery();
                s++;
            }
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduTareasEspecificas : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_TAREA_ESPECIFICA");
            objBnMsgerr.setTipo(objBeanTareaEspecifica.getMode());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println(e.toString());
            }
        }
        return s;
    }
}
