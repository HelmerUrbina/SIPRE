/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanTipoDocumento;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.TipoDocumentoDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public class TipoDocumentoDAOImpl implements TipoDocumentoDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanTipoDocumento objBnTipoDocumento;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public TipoDocumentoDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaTipoDocumento(BeanTipoDocumento objBeanTipoDocumento, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NTIPO_DOCUMENTO_CODIGO,VTIPO_DOCUMENTO_DESCRIPCION,"
                + "VTIPO_DOCUMENTO_ABREVIATURA "
                + " FROM SIPE_TIPO_DOCUMENTO  "
                + "ORDER BY NTIPO_DOCUMENTO_CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnTipoDocumento = new BeanTipoDocumento();
                objBnTipoDocumento.setCodigo(objResultSet.getInt("NTIPO_DOCUMENTO_CODIGO"));
                objBnTipoDocumento.setDescripcion(objResultSet.getString("VTIPO_DOCUMENTO_DESCRIPCION"));
                objBnTipoDocumento.setAbreviatura(objResultSet.getString("VTIPO_DOCUMENTO_ABREVIATURA"));
                lista.add(objBnTipoDocumento);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaTipoDocumento(objBeanTipoDocumento, usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_TIPO_DOCUMENTO");
            objBnMsgerr.setTipo(objBeanTipoDocumento.getMode());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.toString());
            }
        }
        return lista;
    }

    @Override
    public BeanTipoDocumento getTipoDocumento(BeanTipoDocumento objBeanTipoDocumento, String usuario) {
        sql = "SELECT VTIPO_DOCUMENTO_DESCRIPCION,"
                + "VTIPO_DOCUMENTO_ABREVIATURA "
                + " FROM SIPE_TIPO_DOCUMENTO  "
                + "WHERE NTIPO_DOCUMENTO_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setInt(1, objBeanTipoDocumento.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanTipoDocumento.setDescripcion(objResultSet.getString("VTIPO_DOCUMENTO_DESCRIPCION"));
                objBeanTipoDocumento.setAbreviatura(objResultSet.getString("VTIPO_DOCUMENTO_ABREVIATURA"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getTipoDocumento(objBeanTipoDocumento) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_TIPO_DOCUMENTO");
            objBnMsgerr.setTipo(objBeanTipoDocumento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                    objPreparedStatement.close();
                }
            } catch (SQLException e) {
                System.out.println(e.toString());
            }
        }
        return objBeanTipoDocumento;
    }

    @Override
    public int iduTipoDocumento(BeanTipoDocumento objBeanTipoDocumento, String usuario) {
        sql = "{CALL SP_IDU_TIPO_DOCUMENTO(?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setInt(1, objBeanTipoDocumento.getCodigo());
            cs.setString(2, objBeanTipoDocumento.getDescripcion());
            cs.setString(3, objBeanTipoDocumento.getAbreviatura());
            cs.setString(4, usuario);
            cs.setString(5, objBeanTipoDocumento.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduTipoDocumento : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_TIPO_DOCUMENTO");
            objBnMsgerr.setTipo(objBeanTipoDocumento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduTipoDocumento : " + e.toString());
            }
        }
        return s;
    }
}
