/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanItem;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.ItemDAO;
import DataService.Despachadores.MsgerrDAO;
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
public class ItemDAOImpl implements ItemDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanItem objBnItem;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;

    public ItemDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaItem(BeanItem objBeanItem, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CCATALOGO_COD AS CODIGO, REPLACE(REGEXP_REPLACE(UPPER(VCATALOGO_NOMBRE),'[\"''%]',''),'\n"
                + "', ' ') AS DESCRIPCION, VRUBRO_NOMBRE AS RUBRO, VMEDIDA_NOMBRE AS UNIDAD_MEDIDA, "
                + "VCADENA_GASTO_CODIGO||'-'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(VCADENA_GASTO_CODIGO) AS CADENA_GASTO "
                + "FROM SIPE_VLOG_CATALOGO_OPRE LEFT OUTER JOIN SIPE_ITEM_ESPECIFICA_GASTO ON "
                + "CCATALOGO_COD=VITEM_CODIGO WHERE "
                + "UPPER(VCATALOGO_NOMBRE) LIKE ? "
                + "ORDER BY 2";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, "%" + objBeanItem.getItem().toUpperCase().replaceAll(" ", "%") + "%");
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnItem = new BeanItem();
                objBnItem.setCodigo(objResultSet.getString("CODIGO"));
                objBnItem.setItem(objResultSet.getString("DESCRIPCION"));
                objBnItem.setRubro(objResultSet.getString("RUBRO"));
                objBnItem.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBnItem.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                lista.add(objBnItem);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaItem(objBeanItem, usuario) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_VLOG_CATALOGO_OPRE");
            objBnMsgerr.setTipo("G");
            objBnMsgerr.setDescripcion(e.getMessage());
            int s = objDsMsgerr.iduMsgerr(objBnMsgerr);
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

}
