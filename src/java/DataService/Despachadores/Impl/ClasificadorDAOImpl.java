/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanClasificador;
import DataService.Despachadores.ClasificadorDAO;
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
public class ClasificadorDAOImpl implements ClasificadorDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanClasificador objBnClasificador;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ClasificadorDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaClasificador(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT TRIM(COTITR)||'.'||TRIM(COGEGA)||'.'||TRIM(COGEG1)||'.'||TRIM(COGEG2)||'.'||TRIM(COESG1)||'.'||TRIM(COESG2) AS CADENA, "
                + "CASE COTITR WHEN '1' THEN '1:INGRESOS PRESUPUESTALES' WHEN '2' THEN '2:GASTOS PRESUPUESTARIOS' ELSE 'REVISE' END AS TIPO_TRANSACCION, "
                + "TRIM(COGEGA)||':'||UTIL_NEW.FUN_NOMGEN_GAS_ING(TRIM(COGEGA), TRIM(COTITR)) AS GENERICA, "
                + "TRIM(COGEG1)||':'||UTIL_NEW.FUN_NOMBRE_GENGAS_1(TRIM(COTITR), TRIM(COGEGA), TRIM(COGEG1)) AS SUB_GENERICA, "
                + "TRIM(COGEG2)||':'||UTIL_NEW.FUN_NOMBRE_GENGA_2(TRIM(COTITR), TRIM(COGEGA), TRIM(COGEG1), TRIM(COGEG2)) AS SUB_GENERICA_DETALLE, "
                + "TRIM(COESG1)||':'||UTIL_NEW.FUN_NOMBRE_ESPGA_1(TRIM(COTITR), TRIM(COGEGA), TRIM(COGEG1), TRIM(COGEG2), TRIM(COESG1)) AS ESPECIFICA, "
                + "TRIM(COESG2)||':'||NOCAGA AS ESPECIFICA_DETALLE, "
                + "DECAGA AS DESCRIPCION, "
                + "CASE TIPO WHEN 'R' THEN 'RESTRINGIDA' WHEN 'L' THEN 'LIBRE' ELSE 'REVISE' END AS TIPO "
                + "FROM CADGAS "
                + "ORDER BY TO_NUMBER(COTITR), TO_NUMBER(COGEGA), TO_NUMBER(COGEG1), TO_NUMBER(COGEG2), TO_NUMBER(COESG1), TO_NUMBER(COESG2)";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnClasificador = new BeanClasificador();
                objBnClasificador.setCadena(objResultSet.getString("CADENA"));
                objBnClasificador.setTipoTransaccion(objResultSet.getString("TIPO_TRANSACCION"));
                objBnClasificador.setGenerica(objResultSet.getString("GENERICA"));
                objBnClasificador.setSubGenerica(objResultSet.getString("SUB_GENERICA"));
                objBnClasificador.setSubGenericaDetalle(objResultSet.getString("SUB_GENERICA_DETALLE"));
                objBnClasificador.setEspecifica(objResultSet.getString("ESPECIFICA"));
                objBnClasificador.setEspecificaDetalle(objResultSet.getString("ESPECIFICA_DETALLE"));
                objBnClasificador.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnClasificador.setTipo(objResultSet.getString("TIPO"));
                lista.add(objBnClasificador);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaClasificador(usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("CADGAS");
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
}
