/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanProveedores;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.ProveedoresDAO;
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
public class ProveedoresDAOImpl implements ProveedoresDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanProveedores objBnProveedores;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ProveedoresDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaProveedores(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT UTIL_NEW.FUN_COUUOO_PROVEEDOR(TRIM(CPROVEEDOR_RUC)) AS CODIGO, CPROVEEDOR_RUC AS RUC, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VPROVEEDOR_RAZON_SOCIAL),'''',''),'\n"
                + "', ' ') AS RAZON_SOCIAL, REPLACE(REGEXP_REPLACE(UPPER(VPROVEEDOR_REPRESENTANTE),'''',''),'\n"
                + "', ' ') AS REPRESENTANTE,"
                + "VPROVEEDOR_TELEFONO AS TELEFONO, REPLACE(REGEXP_REPLACE(UPPER(VPROVEEDOR_DIRECCION),'''',''),'\n"
                + "', ' ') AS DIRECCION, "
                + "UTIL_NEW.FUN_REGISTRO_CCI(CPROVEEDOR_RUC) CCI, UTIL_NEW.FUN_RUBRO_PROVEEDOR(CPROVEEDOR_RUC) RUBRO, "
                + "CASE CTIPO_PROVEEDOR WHEN  'N' THEN 'NATURAL' WHEN 'J' THEN 'JURIDICO' ELSE 'VERIFICAR' END AS TIPO, CPROVEEDOR_DNI AS DNI, "
                + "CASE CPROVEEDOR_ESTADO WHEN  'AC' THEN  'ACTIVO' WHEN 'IN' THEN 'INACTIVO' ELSE 'VERIFICAR' END AS ESTADO "
                + "FROM SIPE_PROVEEDOR "
                + "ORDER BY RAZON_SOCIAL";        
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnProveedores = new BeanProveedores();
                objBnProveedores.setCodigo(objResultSet.getString("CODIGO"));
                objBnProveedores.setRUC(objResultSet.getString("RUC"));
                objBnProveedores.setRazonSocial(objResultSet.getString("RAZON_SOCIAL"));
                objBnProveedores.setRepresentante(objResultSet.getString("REPRESENTANTE"));
                objBnProveedores.setTelefono(objResultSet.getString("TELEFONO"));
                objBnProveedores.setDireccion(objResultSet.getString("DIRECCION"));
                objBnProveedores.setCCI(objResultSet.getString("CCI"));
                objBnProveedores.setRubro(objResultSet.getString("RUBRO"));
                objBnProveedores.setTipo(objResultSet.getString("TIPO"));
                objBnProveedores.setDNI(objResultSet.getString("DNI"));
                objBnProveedores.setEstado(objResultSet.getString("ESTADO"));
                lista.add(objBnProveedores);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaProveedores(usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROVEEDOR");
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
    public BeanProveedores getProveedor(BeanProveedores objBeanProveedor, String usuario) {
        sql="SELECT CPROVEEDOR_RUC, VPROVEEDOR_RAZON_SOCIAL, VPROVEEDOR_REPRESENTANTE, "
                + "VPROVEEDOR_TELEFONO, VPROVEEDOR_DIRECCION, CTIPO_PROVEEDOR, "
                + "CPROVEEDOR_DNI, CPROVEEDOR_ESTADO "
                + "FROM SIPE_PROVEEDOR WHERE "
                + "CPROVEEDOR_RUC=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProveedor.getRUC());            
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanProveedor.setRUC(objResultSet.getString("CPROVEEDOR_RUC"));
                objBeanProveedor.setRazonSocial(objResultSet.getString("VPROVEEDOR_RAZON_SOCIAL"));
                objBeanProveedor.setRepresentante(objResultSet.getString("VPROVEEDOR_REPRESENTANTE"));
                objBeanProveedor.setTelefono(objResultSet.getString("VPROVEEDOR_TELEFONO"));
                objBeanProveedor.setDireccion(objResultSet.getString("VPROVEEDOR_DIRECCION"));
                objBeanProveedor.setTipo(objResultSet.getString("CTIPO_PROVEEDOR"));
                objBeanProveedor.setDNI(objResultSet.getString("CPROVEEDOR_DNI"));
                objBeanProveedor.setEstado(objResultSet.getString("CPROVEEDOR_ESTADO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getProveedor(objBeanProveedor) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROVEEDOR");
            objBnMsgerr.setTipo(objBeanProveedor.getMode());
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
        return objBeanProveedor;
    }
    
    @Override
    public int iduProveedor(BeanProveedores objBeanProveedor, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA TABLA TAPAIN, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA,
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql="{CALL SP_IDU_PROVEEDOR(?,?,?,?,?,?,?,?,?,?)}";
        try {
            try (CallableStatement cs = objConnection.prepareCall(sql)) {
                cs.setString(1,objBeanProveedor.getRUC());
                cs.setString(2,objBeanProveedor.getRazonSocial().toUpperCase());
                cs.setString(3,objBeanProveedor.getRepresentante().toUpperCase());
                cs.setString(4,objBeanProveedor.getDireccion());
                cs.setString(5,objBeanProveedor.getTipo());
                cs.setString(6,objBeanProveedor.getDNI());
                cs.setString(7,objBeanProveedor.getTelefono());
                cs.setString(8,objBeanProveedor.getEstado());
                cs.setString(9,usuario);
                cs.setString(10,objBeanProveedor.getMode());
                objResultSet = cs.executeQuery();
                s++;
            }
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduProveedor : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROVEEDOR");
            objBnMsgerr.setTipo(objBeanProveedor.getMode().toUpperCase());
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
