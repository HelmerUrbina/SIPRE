/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMesaParte;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.DecretoDAO;
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
 * @author H-TECCSI-V
 */
public class DecretoDAOImpl implements DecretoDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanMesaParte objBnDecreto;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public DecretoDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getConsultaDocumentos(BeanMesaParte objBeanDecreto, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CDOCUMENTO_NUMERO AS CODIGO, "
                + "PK_MESA_PARTES.FUN_NOMBRE_TIPO_DOCUMENTO(NTIPO_DOCUMENTO_CODIGO)||'-'||CDOCUMENTO_NRO_DOCUMENTO AS NUMERO, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VDOCUMENTO_ASUNTO),'''',''),'\n"
                + "', ' ') AS ASUNTO, PK_MESA_PARTES.FUN_NOMBRE_PRIORIDAD(CPRIORIDAD_CODIGO) AS PRIORIDAD, "
                + "PK_MESA_PARTES.FUN_NOMBRE_INSTITUCION(CORGANISMO_CODIGO, CINSTITUCION_CODIGO) AS INSTITUCION, "
                + "DDOCUMENTO_FECHA_DOCUMENTO AS FECHA_DOCUMENTO, "
                + "DDOCUMENTO_FECHA_RECEPCION AS FECHA_RECEPCION, REGEXP_REPLACE(UPPER(VPOST_FIRMA),'''','') AS FIRMA, "
                + "PK_MESA_PARTES.FUN_DOCUMENTO_RESPUESTA(CPERIODO_CODIGO, CDOCUMENTO_TIPO, CDOCUMENTO_NUMERO) AS DOC_RESPUESTA, "
                + "UTIL_NEW.FUN_NOMUSU('0003',VUSUARIO_RESPONSABLE) AS USUARIO_RESPUESTA, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VDOCUMENTO_DIGITAL),'''',''),'\n"
                + "', ' ') AS DOCUMENTO "
                + "FROM SIPE_DOCUMENTO WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CMES_CODIGO=? AND "
                + "CDOCUMENTO_TIPO=? AND "
                + "CDOCUMENTO_ESTADO=? AND "
                + "CDOCUMENTO_ESTADO NOT IN ('AN')"
                + "ORDER BY CODIGO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDecreto.getPeriodo());
            objPreparedStatement.setString(2, objBeanDecreto.getMes());
            objPreparedStatement.setString(3, objBeanDecreto.getTipo());
            objPreparedStatement.setString(4, objBeanDecreto.getEstado());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDecreto = new BeanMesaParte();
                objBnDecreto.setNumero(objResultSet.getString("CODIGO"));
                objBnDecreto.setNumeroDocumento(objResultSet.getString("NUMERO"));
                objBnDecreto.setAsunto(objResultSet.getString("ASUNTO"));
                objBnDecreto.setPrioridad(objResultSet.getString("PRIORIDAD"));
                objBnDecreto.setSubGrupo(objResultSet.getString("INSTITUCION"));
                objBnDecreto.setFecha(objResultSet.getDate("FECHA_DOCUMENTO"));
                objBnDecreto.setFechaRegistro(objResultSet.getDate("FECHA_RECEPCION"));
                objBnDecreto.setHora(objResultSet.getString("FIRMA"));
                objBnDecreto.setReferencia(objResultSet.getString("DOC_RESPUESTA"));
                objBnDecreto.setUsuarioResponsable(objResultSet.getString("USUARIO_RESPUESTA"));
                objBnDecreto.setArchivo(objResultSet.getString("DOCUMENTO"));
                lista.add(objBnDecreto);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsultaDocumentos(objBnDecreto) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DOCUMENTO");
            objBnMsgerr.setTipo(objBnDecreto.getMode().toUpperCase());
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
    public int iduDecretarDocumento(BeanMesaParte objBnDecreto, String usuario) {
        sql = "{CALL SP_IDU_DECRETO_DOCUMENTO(?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBnDecreto.getPeriodo());
            cs.setString(2, objBnDecreto.getTipo());
            cs.setString(3, objBnDecreto.getNumero());
            cs.setString(4, objBnDecreto.getComentario());
            cs.setString(5, objBnDecreto.getUsuarioResponsable());
            cs.setString(6, objBnDecreto.getPrioridad());
            cs.setString(7, objBnDecreto.getArea());
            cs.setString(8, objBnDecreto.getUsuario());
            cs.setString(9, usuario);
            cs.setString(10, objBnDecreto.getMode().toUpperCase());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduDecretarDocumento : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DECRETO_DOCUMENTO");
            objBnMsgerr.setTipo(objBnDecreto.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public ArrayList getListaDetalleDocumentoDecretado(BeanMesaParte objBeanDecreto, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT DD.NDECRETO_DOCUMENTO,UTIL_NEW.FUN_NOMUSU('0003',DD.VUSUARIO_RECEPCION) AS USUARIO,"
                + "PK_MESA_PARTES.FUN_NOMBRE_PRIORIDAD(CPRIORIDAD_CODIGO) AS PRIORIDAD,"
                + "DD.VDECRETO_OBSERVACION AS COMENTARIO,TO_CHAR(DD.DFECHA_DECRETO,'DD/MM/YYYY') AS DFECHA_DECRETO,"
                + "TO_CHAR(DD.DFECHA_RECEPCION,'DD/MM/YYYY') AS DFECHA_RECEPCION,"
                + "CASE WHEN (SELECT MAX(NDECRETO_DOCUMENTO) FROM SIPE_DECRETO_DOCUMENTO WHERE CPERIODO_CODIGO=DD.CPERIODO_CODIGO AND "
                + "CDOCUMENTO_TIPO=DD.CDOCUMENTO_TIPO AND CDOCUMENTO_NUMERO=DD.CDOCUMENTO_NUMERO)=DD.NDECRETO_DOCUMENTO "
                + "THEN 'DOC' ELSE '' END AS ESTADO "
                + "FROM SIPE_DECRETO_DOCUMENTO DD WHERE DD.CPERIODO_CODIGO=? AND "
                + "DD.CDOCUMENTO_TIPO=? AND "
                + "DD.CDOCUMENTO_NUMERO=? "
                + "ORDER BY DD.NDECRETO_DOCUMENTO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDecreto.getPeriodo());
            objPreparedStatement.setString(2, objBeanDecreto.getTipo());
            objPreparedStatement.setString(3, objBeanDecreto.getNumero());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("NDECRETO_DOCUMENTO") + "+++"
                        + objResultSet.getString("USUARIO") + "+++"
                        + objResultSet.getString("PRIORIDAD") + "+++"
                        + objResultSet.getString("COMENTARIO") + "+++"
                        + objResultSet.getString("DFECHA_DECRETO") + "+++"
                        + objResultSet.getString("DFECHA_RECEPCION") + "+++"
                        + objResultSet.getString("ESTADO");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDetalleDocumentoDecretado(objBnDecreto) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DECRETO_DOCUMENTO");
            objBnMsgerr.setTipo(objBeanDecreto.getMode().toUpperCase());
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
        return Arreglo;
    }

    @Override
    public BeanMesaParte getDecretoDocumento(BeanMesaParte objBeanDecreto, String usuario) {
        sql = "SELECT VUSUARIO_EMISOR FROM SIPE_DECRETO_DOCUMENTO WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CDOCUMENTO_TIPO=? AND "
                + "CDOCUMENTO_NUMERO=? AND "
                + "NDECRETO_DOCUMENTO=1 "
                + "GROUP BY VUSUARIO_EMISOR";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDecreto.getPeriodo());
            objPreparedStatement.setString(2, objBeanDecreto.getTipo());
            objPreparedStatement.setString(3, objBeanDecreto.getNumero());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanDecreto.setUsuarioResponsable(objResultSet.getString("VUSUARIO_EMISOR"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getDecretoDocumento(objBeanDecreto) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DECRETO_DOCUMENTO");
            objBnMsgerr.setTipo(objBeanDecreto.getMode().toUpperCase());
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
        return objBeanDecreto;
    }
}
