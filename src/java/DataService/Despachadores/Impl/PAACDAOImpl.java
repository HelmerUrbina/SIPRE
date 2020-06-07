/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanPAAC;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.PAACDAO;
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
public class PAACDAOImpl implements PAACDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPAAC objBnPAAC;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public PAACDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaPAAC(BeanPAAC objBeanPAAC, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NPAAC_CODIGO AS CODIGO, "
                + "UTIL_NEW.FUN_TIPO_PROCESO(CTIPO_PROCESO_CODIGO) AS TIPO, "
                + "VPAAC_NUMERO_PROCESO AS NUMERO, VPAAC_OBJETO AS OBJETO, "
                + "DPAAC_FECHA_EMISION AS FECHA, NPAAC_CERTIFICADO AS CESTIFICADO, "
                + "NPAAC_VALOR_REFERENCIAL AS VALOR_REFERENCIAL, "
                + "CASE CPAAC_ESTADO WHEN 'AC' THEN 'ACTIVO' WHEN 'AN' THEN 'ANULADO' ELSE 'VERIFICAR' END AS ESTADO, "
                + "CASE CPAAC_ACOMPRAS WHEN '1' THEN 'SI' WHEN '0' THEN 'NO' ELSE 'VERIFICA' END AS COMPRA "
                + "FROM SIPE_PAAC WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPAAC.getPeriodo());
            objPreparedStatement.setString(2, objBeanPAAC.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnPAAC = new BeanPAAC();
                objBnPAAC.setCodigo(objResultSet.getInt("CODIGO"));
                objBnPAAC.setTipo(objResultSet.getString("TIPO"));
                objBnPAAC.setNumero(objResultSet.getString("NUMERO"));
                objBnPAAC.setObjeto(objResultSet.getString("OBJETO"));
                objBnPAAC.setFecha(objResultSet.getDate("FECHA"));
                objBnPAAC.setCertificado(objResultSet.getString("CESTIFICADO"));
                objBnPAAC.setValorReferencial(objResultSet.getDouble("VALOR_REFERENCIAL"));
                objBnPAAC.setEstado(objResultSet.getString("ESTADO"));
                objBnPAAC.setCompra(objResultSet.getString("COMPRA"));
                lista.add(objBnPAAC);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPAAC(objBeanPAAC) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PAAC");
            objBnMsgerr.setTipo(objBeanPAAC.getMode().toUpperCase());
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
    public BeanPAAC getPAAC(BeanPAAC objBeanPAAC, String usuario) {
        sql = "SELECT CTIPO_PROCESO_CODIGO, VPAAC_NUMERO_PROCESO, VPAAC_OBJETO, "
                + "DPAAC_FECHA_EMISION, NPAAC_CERTIFICADO, NPAAC_VALOR_REFERENCIAL, CPAAC_ACOMPRAS "
                + "FROM SIPE_PAAC WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPAAC_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPAAC.getPeriodo());
            objPreparedStatement.setString(2, objBeanPAAC.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanPAAC.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanPAAC.setTipo(objResultSet.getString("CTIPO_PROCESO_CODIGO"));
                objBeanPAAC.setNumero(objResultSet.getString("VPAAC_NUMERO_PROCESO"));
                objBeanPAAC.setObjeto(objResultSet.getString("VPAAC_OBJETO"));
                objBeanPAAC.setFecha(objResultSet.getDate("DPAAC_FECHA_EMISION"));
                objBeanPAAC.setCertificado(objResultSet.getString("NPAAC_CERTIFICADO"));
                objBeanPAAC.setValorReferencial(objResultSet.getDouble("NPAAC_VALOR_REFERENCIAL"));
                objBeanPAAC.setCompra(objResultSet.getString("CPAAC_ACOMPRAS"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPAAC(objBeanPAAC) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PAAC");
            objBnMsgerr.setTipo(objBeanPAAC.getMode().toUpperCase());
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
        return objBeanPAAC;
    }

    @Override
    public BeanPAAC getPAACMensualizar(BeanPAAC objBeanPAAC, String usuario) {
        sql = "SELECT UTIL_NEW.FUN_DESC_TIPO_PROCESO(CTIPO_PROCESO_CODIGO)||'-'||VPAAC_NUMERO_PROCESO AS PROCESO, "
                + "NPAAC_VALOR_REFERENCIAL, "
                + "NPAAC_ENERO, NPAAC_FEBRERO, NPAAC_MARZO, NPAAC_ABRIL, NPAAC_MAYO, NPAAC_JUNIO, NPAAC_JULIO, "
                + "NPAAC_AGOSTO, NPAAC_SETIEMBRE, NPAAC_OCTUBRE, NPAAC_NOVIEMBRE, NPAAC_DICIEMBRE "
                + "FROM SIPE_PAAC WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPAAC_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPAAC.getPeriodo());
            objPreparedStatement.setString(2, objBeanPAAC.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanPAAC.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanPAAC.setTipo(objResultSet.getString("PROCESO"));
                objBeanPAAC.setValorReferencial(objResultSet.getDouble("NPAAC_VALOR_REFERENCIAL"));
                objBeanPAAC.setEnero(objResultSet.getDouble("NPAAC_ENERO"));
                objBeanPAAC.setFebrero(objResultSet.getDouble("NPAAC_FEBRERO"));
                objBeanPAAC.setMarzo(objResultSet.getDouble("NPAAC_MARZO"));
                objBeanPAAC.setAbril(objResultSet.getDouble("NPAAC_ABRIL"));
                objBeanPAAC.setMayo(objResultSet.getDouble("NPAAC_MAYO"));
                objBeanPAAC.setJunio(objResultSet.getDouble("NPAAC_JUNIO"));
                objBeanPAAC.setJulio(objResultSet.getDouble("NPAAC_JULIO"));
                objBeanPAAC.setAgosto(objResultSet.getDouble("NPAAC_AGOSTO"));
                objBeanPAAC.setSetiembre(objResultSet.getDouble("NPAAC_SETIEMBRE"));
                objBeanPAAC.setOctubre(objResultSet.getDouble("NPAAC_OCTUBRE"));
                objBeanPAAC.setNoviembre(objResultSet.getDouble("NPAAC_NOVIEMBRE"));
                objBeanPAAC.setDiciembre(objResultSet.getDouble("NPAAC_DICIEMBRE"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPAACMensualizar(objBeanPAAC) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PAAC");
            objBnMsgerr.setTipo(objBeanPAAC.getMode().toUpperCase());
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
        return objBeanPAAC;
    }

    @Override
    public int iduPAAC(BeanPAAC objBeanEvento, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL  SP_IDU_PAAC(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanEvento.getPeriodo());
            cs.setString(2, objBeanEvento.getUnidadOperativa());
            cs.setInt(3, objBeanEvento.getCodigo());
            cs.setString(4, objBeanEvento.getTipo());
            cs.setString(5, objBeanEvento.getNumero());
            cs.setString(6, objBeanEvento.getObjeto());
            cs.setDate(7, objBeanEvento.getFecha());
            cs.setString(8, objBeanEvento.getCertificado());
            cs.setDouble(9, objBeanEvento.getValorReferencial());
            cs.setDouble(10, objBeanEvento.getEnero());
            cs.setDouble(11, objBeanEvento.getFebrero());
            cs.setDouble(12, objBeanEvento.getMarzo());
            cs.setDouble(13, objBeanEvento.getAbril());
            cs.setDouble(14, objBeanEvento.getMayo());
            cs.setDouble(15, objBeanEvento.getJunio());
            cs.setDouble(16, objBeanEvento.getJulio());
            cs.setDouble(17, objBeanEvento.getAgosto());
            cs.setDouble(18, objBeanEvento.getSetiembre());
            cs.setDouble(19, objBeanEvento.getOctubre());
            cs.setDouble(20, objBeanEvento.getNoviembre());
            cs.setDouble(21, objBeanEvento.getDiciembre());
            cs.setString(22, objBeanEvento.getCompra());
            cs.setString(23, usuario);
            cs.setString(24, objBeanEvento.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPAAC : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PAAC");
            objBnMsgerr.setTipo(objBeanEvento.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }
}
