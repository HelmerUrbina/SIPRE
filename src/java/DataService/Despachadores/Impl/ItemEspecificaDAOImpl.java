/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanItemEspecifica;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.ItemEspecificaDAO;
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
 * @author H-URBINA-M
 */
public class ItemEspecificaDAOImpl implements ItemEspecificaDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanItemEspecifica objBnItemEspecifica;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ItemEspecificaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaItemEspecifica(String cadenaGasto, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT VITEM_CODIGO AS CODIGO, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VITEM_DESCRIPCION),'''',''),'\n"
                + "', ' ') AS ITEM, VUNIDAD_MEDIDA AS UNIDAD_MEDIDA "
                + "FROM SIPE_ITEM_ESPECIFICA_GASTO WHERE "
                + "VCADENA_GASTO_CODIGO=? "
                + "ORDER BY ITEM";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, cadenaGasto);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnItemEspecifica = new BeanItemEspecifica();
                objBnItemEspecifica.setCodigo(objResultSet.getString("CODIGO"));
                objBnItemEspecifica.setItem(objResultSet.getString("ITEM"));
                objBnItemEspecifica.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                lista.add(objBnItemEspecifica);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaItemEspecifica(" + cadenaGasto + ", " + usuario + ") : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ITEM_ESPECIFICA_GASTO");
            objBnMsgerr.setTipo("G");
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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
    public ArrayList getItem(String busqueda) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT CCATALOGO_COD AS CODIGO, CCATALOGO_COD||'---'||VMEDIDA_NOMBRE AS ITEM, "
                + "VCATALOGO_NOMBRE||' - '||VMEDIDA_NOMBRE AS DESCRIPCION "
                + "FROM SIPE_VLOG_CATALOGO_OPRE WHERE "
                + "UPPER(VCATALOGO_NOMBRE) LIKE ? "
                + "ORDER BY DESCRIPCION";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, "%" + busqueda.toUpperCase().replaceAll(" ", "%") + "%");
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("ITEM") + "+++"
                        + objResultSet.getString("DESCRIPCION");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getItem() : " + e.getMessage());
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
    public ArrayList getItemAsignados(String cadenaGasto, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        sql = "SELECT VITEM_CODIGO AS CODIGO "
                + "FROM SIPE_ITEM_ESPECIFICA_GASTO WHERE "
                + "VCADENA_GASTO_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, cadenaGasto);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Arreglo.add(objResultSet.getString("CODIGO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getItemAsignados(cadenaGasto, usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ITEM_ESPECIFICA_GASTO");
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
    public int iduItemEspecifica(BeanItemEspecifica objBeanItemEspecifica, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_ITEM_ESPECIFICA_GASTO(?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanItemEspecifica.getCadenaGasto());
            cs.setString(2, objBeanItemEspecifica.getCodigo());
            cs.setString(3, objBeanItemEspecifica.getUnidadMedida());
            cs.setString(4, usuario);
            cs.setString(5, objBeanItemEspecifica.getMode().toUpperCase());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduItemEspecifica : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ITEM_ESPECIFICA_GASTO");
            objBnMsgerr.setTipo(objBeanItemEspecifica.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int eliminarItemEspecifica(BeanItemEspecifica objBeanItemEspecifica, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "DELETE SIPE_ITEM_ESPECIFICA_GASTO WHERE "
                + "VCADENA_GASTO_CODIGO=? AND "
                + "VITEM_CODIGO=? ";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanItemEspecifica.getCadenaGasto());
            cs.setString(2, objBeanItemEspecifica.getCodigo());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar eliminarItemEspecifica : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_ITEM_ESPECIFICA_GASTO");
            objBnMsgerr.setTipo(objBeanItemEspecifica.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }
}
