/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMesaParte;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.MesaParteDAO;
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
 * @author H-TECCSI-V
 */
public class MesaParteDAOImpl implements MesaParteDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanMesaParte objBnMesaParte;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public MesaParteDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaMesaPartes(BeanMesaParte objBeanMesaParte, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CDOCUMENTO_NUMERO AS CODIGO, "
                + "PK_MESA_PARTES.FUN_NOMBRE_TIPO_DOCUMENTO(NTIPO_DOCUMENTO_CODIGO)||'-'||CDOCUMENTO_NRO_DOCUMENTO AS NUMERO, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VDOCUMENTO_ASUNTO),'''',''),'\n"
                + "', ' ') AS ASUNTO, PK_MESA_PARTES.FUN_NOMBRE_PRIORIDAD(CPRIORIDAD_CODIGO) AS PRIORIDAD, "
                + "PK_MESA_PARTES.FUN_NOMBRE_INSTITUCION(CORGANISMO_CODIGO, CINSTITUCION_CODIGO) AS INSTITUCION, "
                + "DDOCUMENTO_FECHA_DOCUMENTO AS FECHA_DOCUMENTO, "
                + "CASE CDOCUMENTO_ESTADO WHEN 'RE' THEN 'RECIBIDO' WHEN 'DE' THEN 'DECRETADO' "
                + "WHEN 'RS' THEN 'RESPONDIDO' WHEN 'RM' THEN 'REMITIDO' ELSE 'PENDIENTE' END AS ESTADO, "
                + "DDOCUMENTO_FECHA_RECEPCION AS FECHA_RECEPCION, REPLACE(REGEXP_REPLACE(UPPER(VPOST_FIRMA),'''',''),'\n"
                + "', ' ') AS FIRMA, "
                + "NCANTIDAD_LEGAJOS AS LEGAJO,NCANTIDAD_FOLIOS AS FOLIO, "
                + "UTIL_NEW.FUN_NOMUSU('0003',VUSUARIO_RESPONSABLE) AS USUARIO_RESPUESTA, VUSUARIO_RESPONSABLE, "
                + "PK_MESA_PARTES.FUN_DOCUMENTO_RESPUESTA(CPERIODO_CODIGO, CDOCUMENTO_TIPO, CDOCUMENTO_NUMERO) AS DOC_RESPUESTA, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VDOCUMENTO_DIGITAL),'''',''),'\n"
                + "', ' ') AS DOCUMENTO, VDOCUMENTO_CORREO AS CORREO "
                + "FROM SIPE_DOCUMENTO WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CMES_CODIGO=? AND "
                + "CDOCUMENTO_TIPO=? AND "
                + "TO_CHAR(DDOCUMENTO_FECHA_RECEPCION,'DD') = LPAD(?,2,0) AND "
                + "CDOCUMENTO_ESTADO NOT IN ('AN')"
                + "ORDER BY CODIGO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanMesaParte.getPeriodo());
            objPreparedStatement.setString(2, objBeanMesaParte.getMes());
            objPreparedStatement.setString(3, objBeanMesaParte.getTipo());
            objPreparedStatement.setString(4, objBeanMesaParte.getFechaBus());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnMesaParte = new BeanMesaParte();
                objBnMesaParte.setNumero(objResultSet.getString("CODIGO"));
                objBnMesaParte.setNumeroDocumento(objResultSet.getString("NUMERO"));
                objBnMesaParte.setAsunto(objResultSet.getString("ASUNTO"));
                objBnMesaParte.setPrioridad(objResultSet.getString("PRIORIDAD"));
                objBnMesaParte.setSubGrupo(objResultSet.getString("INSTITUCION"));
                objBnMesaParte.setFecha(objResultSet.getDate("FECHA_DOCUMENTO"));
                objBnMesaParte.setEstado(objResultSet.getString("ESTADO"));
                objBnMesaParte.setFechaRegistro(objResultSet.getDate("FECHA_RECEPCION"));
                objBnMesaParte.setHora(objResultSet.getString("FIRMA"));
                objBnMesaParte.setLegajo(objResultSet.getInt("LEGAJO"));
                objBnMesaParte.setFolio(objResultSet.getInt("FOLIO"));
                objBnMesaParte.setUsuarioResponsable(objResultSet.getString("USUARIO_RESPUESTA"));
                objBnMesaParte.setArea(objResultSet.getString("VUSUARIO_RESPONSABLE"));
                objBnMesaParte.setReferencia(objResultSet.getString("DOC_RESPUESTA"));
                objBnMesaParte.setArchivo(objResultSet.getString("DOCUMENTO"));
                objBnMesaParte.setCorreo(objResultSet.getString("CORREO"));
                lista.add(objBnMesaParte);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaMesaPartes(objBeanMesaParte) : " + e.getMessage());
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
    public BeanMesaParte getMesaParte(BeanMesaParte objBeanMesaParte, String usuario) {
        sql = "SELECT CDOCUMENTO_NUMERO, CDOCUMENTO_NRO_DOCUMENTO, "
                + "DDOCUMENTO_FECHA_DOCUMENTO, "
                + "VDOCUMENTO_OBSERVACION, VDOCUMENTO_ASUNTO, "
                + "TO_CHAR(DDOCUMENTO_FECHA_RECEPCION,'DD/MM/YYYY') AS FEC_RECEPCION, "
                + "CDOCUMENTO_TIPO, CORGANISMO_CODIGO, "
                + "NTIPO_DOCUMENTO_CODIGO, CCLASIFICACION_DOCUMENTO_CODIG, "
                + "CINSTITUCION_CODIGO, CMES_CODIGO, CPRIORIDAD_CODIGO, CDOCUMENTO_ESTADO,VPOST_FIRMA AS FIRMA, "
                + "NCANTIDAD_LEGAJOS AS LEGAJO,NCANTIDAD_FOLIOS AS FOLIO, "
                + "VAREA_RESPONSABLE, UTIL_NEW.FUN_NOMUSU('0003',VUSUARIO_RESPONSABLE) AS VUSUARIO_RESPONSABLE, "
                + "CDOCUMENTO_RESP_NUMERO, "
                + "PK_MESA_PARTES.FUN_NOMBRE_INSTITUCION(CORGANISMO_CODIGO, CINSTITUCION_CODIGO) AS INSTITUCION "
                + "FROM SIPE_DOCUMENTO WHERE "
                + "CPERIODO_CODIGO=? AND  "
                + "CMES_CODIGO=? AND "
                + "CDOCUMENTO_TIPO=? AND  "
                + "CDOCUMENTO_NUMERO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanMesaParte.getPeriodo());
            objPreparedStatement.setString(2, objBeanMesaParte.getMes());
            objPreparedStatement.setString(3, objBeanMesaParte.getTipo());
            objPreparedStatement.setString(4, objBeanMesaParte.getNumero());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanMesaParte.setNumero(objResultSet.getString("CDOCUMENTO_NUMERO"));
                objBeanMesaParte.setNumeroDocumento(objResultSet.getString("CDOCUMENTO_NRO_DOCUMENTO"));
                objBeanMesaParte.setFecha(objResultSet.getDate("DDOCUMENTO_FECHA_DOCUMENTO"));
                objBeanMesaParte.setObservacion(objResultSet.getString("VDOCUMENTO_OBSERVACION"));
                objBeanMesaParte.setAsunto(objResultSet.getString("VDOCUMENTO_ASUNTO"));
                objBeanMesaParte.setFechaBus(objResultSet.getString("FEC_RECEPCION"));
                objBeanMesaParte.setGrupo(objResultSet.getString("CORGANISMO_CODIGO"));
                objBeanMesaParte.setTipoDocumento(objResultSet.getString("NTIPO_DOCUMENTO_CODIGO"));
                objBeanMesaParte.setClasificacion(objResultSet.getString("CCLASIFICACION_DOCUMENTO_CODIG"));
                objBeanMesaParte.setSubGrupo(objResultSet.getString("CINSTITUCION_CODIGO"));
                objBeanMesaParte.setInstitucion(objResultSet.getString("INSTITUCION"));
                objBeanMesaParte.setPrioridad(objResultSet.getString("CPRIORIDAD_CODIGO"));
                objBeanMesaParte.setEstado(objResultSet.getString("CDOCUMENTO_ESTADO"));
                objBeanMesaParte.setHora(objResultSet.getString("FIRMA"));
                objBeanMesaParte.setLegajo(objResultSet.getInt("LEGAJO"));
                objBeanMesaParte.setFolio(objResultSet.getInt("FOLIO"));
                objBeanMesaParte.setArea(objResultSet.getString("VAREA_RESPONSABLE"));
                objBeanMesaParte.setUsuarioResponsable(objResultSet.getString("VUSUARIO_RESPONSABLE"));
                objBeanMesaParte.setReferencia(objResultSet.getString("CDOCUMENTO_RESP_NUMERO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getMesaParte(objBeanMesaParte) : " + e.getMessage());
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
        return objBeanMesaParte;
    }

    @Override
    public String getNumeroDocumento(BeanMesaParte objBnMesaParte, String usuario) {
        String result = "00001";
        sql = "SELECT LPAD(NVL(MAX(CDOCUMENTO_NUMERO)+1,1),5,0) AS CODIGO "
                + "FROM SIPE_DOCUMENTO WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CDOCUMENTO_TIPO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBnMesaParte.getPeriodo());
            objPreparedStatement.setString(2, objBnMesaParte.getTipo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("CODIGO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getNumeroDocumento(objBnMesaParte) : " + e.getMessage());
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
        return result;
    }

    @Override
    public String iduMesaParte(BeanMesaParte objBeanMesaParte, String usuario) {
        String numero = "";
        sql = "{CALL SP_IDU_MESAPARTE(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanMesaParte.getPeriodo());
            cs.setString(2, objBeanMesaParte.getTipo());
            cs.setString(3, objBeanMesaParte.getNumero());
            cs.setString(4, objBeanMesaParte.getMes());
            cs.setString(5, objBeanMesaParte.getGrupo());
            cs.setString(6, objBeanMesaParte.getSubGrupo());
            cs.setString(7, objBeanMesaParte.getPrioridad());
            cs.setString(8, objBeanMesaParte.getTipoDocumento());
            cs.setString(9, objBeanMesaParte.getNumeroDocumento());
            cs.setString(10, objBeanMesaParte.getClasificacion());
            cs.setDate(11, objBeanMesaParte.getFecha());
            cs.setDate(12, objBeanMesaParte.getFechaRecepcion());
            cs.setString(13, objBeanMesaParte.getAsunto());
            cs.setString(14, objBeanMesaParte.getObservacion());
            cs.setString(15, objBeanMesaParte.getEstado());
            cs.setString(16, objBeanMesaParte.getUsuario());
            cs.setInt(17, objBeanMesaParte.getLegajo());
            cs.setInt(18, objBeanMesaParte.getFolio());
            cs.setString(19, objBeanMesaParte.getArchivo());
            cs.setString(20, objBeanMesaParte.getArea());
            cs.setString(21, objBeanMesaParte.getUsuarioResponsable());
            cs.setString(22, objBeanMesaParte.getReferencia());
            cs.setString(23, objBeanMesaParte.getCorreo());
            cs.setString(24, usuario);
            cs.setString(25, objBeanMesaParte.getMode().toUpperCase());
            cs.registerOutParameter(26, java.sql.Types.VARCHAR);
            s = cs.executeUpdate();
            numero = cs.getString(26);
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduMesaParte : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DOCUMENTO");
            objBnMsgerr.setTipo(objBeanMesaParte.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return "0";
        }
        return numero;
    }

    @Override
    public String getDocumentosPendientes(String usuario) {
        String result = "0";
        sql = "SELECT COUNT(*) AS DOCUMENTO "
                + "FROM SIPE_DECRETO_DOCUMENTO WHERE "
                + "VUSUARIO_RECEPCION=? AND "
                + "CESTADO_CODIGO IN ('DE')";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, usuario);
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("DOCUMENTO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getDocumentosPendientes(" + usuario + ") : " + e.getMessage());
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
        return result;
    }

    @Override
    public List getConsultaDocumentoRespuesta(BeanMesaParte objBeanMesaParte, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT D.CPERIODO_CODIGO AS PERIODO,D.CDOCUMENTO_NUMERO AS CODIGO, "
                + "PK_MESA_PARTES.FUN_NOMBRE_TIPO_DOCUMENTO(D.NTIPO_DOCUMENTO_CODIGO)||'-'||D.CDOCUMENTO_NRO_DOCUMENTO AS NUMERO, "
                + "D.VDOCUMENTO_ASUNTO AS ASUNTO, PK_MESA_PARTES.FUN_NOMBRE_PRIORIDAD(D.CPRIORIDAD_CODIGO) AS PRIORIDAD, "
                + "PK_MESA_PARTES.FUN_NOMBRE_INSTITUCION(D.CORGANISMO_CODIGO, D.CINSTITUCION_CODIGO) AS INSTITUCION, "
                + "D.DDOCUMENTO_FECHA_DOCUMENTO AS FECHA_DOCUMENTO, "
                + "CASE DD.CESTADO_CODIGO WHEN 'RE' THEN 'RECIBIDO' WHEN 'DE' THEN 'DECRETADO' "
                + "WHEN 'RS' THEN 'RESPONDIDO' ELSE 'PENDIENTE' END AS ESTADO,"
                + "D.VPOST_FIRMA AS FIRMA,D.NCANTIDAD_LEGAJOS AS LEGAJO,D.NCANTIDAD_FOLIOS AS FOLIO,"
                + "UTIL_NEW.FUN_NOMUSU('0003',DD.VUSUARIO_RECEPCION) AS USUARIO_RESPUESTA,"
                + "D.VDOCUMENTO_DIGITAL AS ARCHIVO,"
                + "DD.VDECRETO_OBSERVACION AS COMENTARIO "
                + "FROM SIPE_DOCUMENTO D JOIN SIPE_DECRETO_DOCUMENTO DD ON "
                + "(D.CPERIODO_CODIGO=DD.CPERIODO_CODIGO AND "
                + "D.CDOCUMENTO_NUMERO=DD.CDOCUMENTO_NUMERO )  WHERE "
                + "DD.CPERIODO_CODIGO=? AND "
                + "DD.VUSUARIO_RECEPCION=? AND "
                + "DD.CESTADO_CODIGO IN ('DE','RE') AND "
                + "D.CDOCUMENTO_TIPO='E' "
                + "ORDER BY DD.CESTADO_CODIGO, D.CDOCUMENTO_NUMERO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanMesaParte.getPeriodo());
            objPreparedStatement.setString(2, objBeanMesaParte.getUsuarioResponsable());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnMesaParte = new BeanMesaParte();
                objBnMesaParte.setPeriodo(objResultSet.getString("PERIODO"));
                objBnMesaParte.setNumero(objResultSet.getString("CODIGO"));
                objBnMesaParte.setNumeroDocumento(objResultSet.getString("NUMERO"));
                objBnMesaParte.setAsunto(objResultSet.getString("ASUNTO"));
                objBnMesaParte.setPrioridad(objResultSet.getString("PRIORIDAD"));
                objBnMesaParte.setSubGrupo(objResultSet.getString("INSTITUCION"));
                objBnMesaParte.setFecha(objResultSet.getDate("FECHA_DOCUMENTO"));
                objBnMesaParte.setEstado(objResultSet.getString("ESTADO"));
                objBnMesaParte.setHora(objResultSet.getString("FIRMA"));
                objBnMesaParte.setLegajo(objResultSet.getInt("LEGAJO"));
                objBnMesaParte.setFolio(objResultSet.getInt("FOLIO"));
                objBnMesaParte.setUsuarioResponsable(objResultSet.getString("USUARIO_RESPUESTA"));
                objBnMesaParte.setArchivo(objResultSet.getString("ARCHIVO"));
                objBnMesaParte.setComentario(objResultSet.getString("COMENTARIO"));
                lista.add(objBnMesaParte);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsultaDocumentoRespuesta(objBeanMesaParte) : " + e.getMessage());
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
    public List getListaRemisionDocumento(BeanMesaParte objBeanMesaParte, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CDOCUMENTO_NUMERO AS CODIGO, "
                + "PK_MESA_PARTES.FUN_NOMBRE_TIPO_DOCUMENTO(NTIPO_DOCUMENTO_CODIGO)||'-'||CDOCUMENTO_NRO_DOCUMENTO AS NUMERO, "
                + "VDOCUMENTO_ASUNTO AS ASUNTO, PK_MESA_PARTES.FUN_NOMBRE_PRIORIDAD(CPRIORIDAD_CODIGO) AS PRIORIDAD, "
                + "PK_MESA_PARTES.FUN_NOMBRE_INSTITUCION(CORGANISMO_CODIGO, CINSTITUCION_CODIGO) AS INSTITUCION, "
                + "DDOCUMENTO_FECHA_DOCUMENTO AS FECHA_DOCUMENTO, "
                + "CASE CDOCUMENTO_ESTADO WHEN 'RE' THEN 'RECIBIDO' WHEN 'DE' THEN 'DECRETADO' "
                + "WHEN 'RS' THEN 'RESPONDIDO' WHEN 'RM' THEN 'REMITIDO' ELSE 'PENDIENTE' END AS ESTADO, "
                + "DDOCUMENTO_FECHA_RECEPCION AS FECHA_RECEPCION,VPOST_FIRMA AS FIRMA, "
                + "NCANTIDAD_LEGAJOS AS LEGAJO,NCANTIDAD_FOLIOS AS FOLIO, "
                + "PK_MESA_PARTES.FUN_DOCUMENTO_RESPUESTA(CPERIODO_CODIGO, CDOCUMENTO_TIPO,CDOCUMENTO_NUMERO) AS DOC_RESPUESTA, "
                + "VDOCUMENTO_DIGITAL AS DOCUMENTO "
                + "FROM SIPE_DOCUMENTO WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CMES_CODIGO=? AND "
                + "CDOCUMENTO_TIPO=? AND "
                + "VUSUARIO_CREADOR=? AND "
                + "CDOCUMENTO_ESTADO NOT IN ('AN') "
                + "ORDER BY ESTADO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanMesaParte.getPeriodo());
            objPreparedStatement.setString(2, objBeanMesaParte.getMes());
            objPreparedStatement.setString(3, objBeanMesaParte.getTipo());
            objPreparedStatement.setString(4, usuario);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnMesaParte = new BeanMesaParte();
                objBnMesaParte.setNumero(objResultSet.getString("CODIGO"));
                objBnMesaParte.setNumeroDocumento(objResultSet.getString("NUMERO"));
                objBnMesaParte.setAsunto(objResultSet.getString("ASUNTO"));
                objBnMesaParte.setPrioridad(objResultSet.getString("PRIORIDAD"));
                objBnMesaParte.setSubGrupo(objResultSet.getString("INSTITUCION"));
                objBnMesaParte.setFecha(objResultSet.getDate("FECHA_DOCUMENTO"));
                objBnMesaParte.setEstado(objResultSet.getString("ESTADO"));
                objBnMesaParte.setFechaRegistro(objResultSet.getDate("FECHA_RECEPCION"));
                objBnMesaParte.setHora(objResultSet.getString("FIRMA"));
                objBnMesaParte.setLegajo(objResultSet.getInt("LEGAJO"));
                objBnMesaParte.setFolio(objResultSet.getInt("FOLIO"));
                objBnMesaParte.setReferencia(objResultSet.getString("DOC_RESPUESTA"));
                objBnMesaParte.setArchivo(objResultSet.getString("DOCUMENTO"));
                lista.add(objBnMesaParte);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaRemisionDocumento(objBeanMesaParte) : " + e.getMessage());
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
    public String getNumeroDocumentoSalida(BeanMesaParte objBnMesaParte, String usuario) {
        String result = "00001";
        sql = "SELECT LPAD(NVL(MAX(CNUMERO_DOCUMENTO)+1,1),5,0) AS CODIGO "
                + "FROM SIPE_CORRELATIVO_DOCUMENTO WHERE "
                + "CPERIODO_CODIGO = ? AND "
                + "NTIPO_DOCUMENTO_CODIGO = ? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBnMesaParte.getPeriodo());
            objPreparedStatement.setString(2, objBnMesaParte.getTipoDocumento());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("CODIGO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getNumeroDocumentoSalida(objBnMesaParte) : " + e.getMessage());
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
        return result;
    }

    @Override
    public List getConsultaMesaPartes(BeanMesaParte objBeanMesaParte, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NUMERO AS CODIGO, "
                + "TIPDOC||'-'||NRODOC AS NUMERO, "
                + "REPLACE(REGEXP_REPLACE(UPPER(ASUDOC),'[\"''%]',''),'\n"
                + "', ' ') AS ASUNTO, "
                + "CLFDOC AS PRIORIDAD, "
                + "SUBGRU AS INSTITUCION, FECDOC AS FECHA_DOCUMENTO,ESTADO, "
                + "FECREC AS FECHA_RECEPCION,"
                + "REPLACE(REGEXP_REPLACE(UPPER(OBSDO1),'[\"''%]',''),'', ' ') AS OBSERVACION, "
                + "CANLEG AS LEGAJO,NROFOL AS FOLIO,USUARIO AS USUARIO_RESPUESTA, "
                + "DOC_RESPUESTA, "
                + "REPLACE(REGEXP_REPLACE(UPPER(VDOCUMENTO_DIGITAL),'[\"''%]',''),'\n"
                + "', ' ')  AS DOCUMENTO "
                + "FROM V_CONSULTA_MESA_PARTES WHERE "
                + "CODPER=? AND "
                + "MESPER=? AND "
                + "FLAGES=? "
                + "ORDER BY CODIGO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanMesaParte.getPeriodo());
            objPreparedStatement.setString(2, objBeanMesaParte.getMes());
            objPreparedStatement.setString(3, objBeanMesaParte.getTipo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnMesaParte = new BeanMesaParte();
                objBnMesaParte.setNumero(objResultSet.getString("CODIGO"));
                objBnMesaParte.setNumeroDocumento(objResultSet.getString("NUMERO"));
                objBnMesaParte.setAsunto(objResultSet.getString("ASUNTO"));
                objBnMesaParte.setPrioridad(objResultSet.getString("PRIORIDAD"));
                objBnMesaParte.setSubGrupo(objResultSet.getString("INSTITUCION"));
                objBnMesaParte.setFecha(objResultSet.getDate("FECHA_DOCUMENTO"));
                objBnMesaParte.setEstado(objResultSet.getString("ESTADO"));
                objBnMesaParte.setFechaRegistro(objResultSet.getDate("FECHA_RECEPCION"));
                objBnMesaParte.setHora(objResultSet.getString("OBSERVACION"));
                objBnMesaParte.setLegajo(objResultSet.getInt("LEGAJO"));
                objBnMesaParte.setFolio(objResultSet.getInt("FOLIO"));
                objBnMesaParte.setUsuarioResponsable(objResultSet.getString("USUARIO_RESPUESTA"));
                objBnMesaParte.setReferencia(objResultSet.getString("DOC_RESPUESTA"));
                objBnMesaParte.setArchivo(objResultSet.getString("DOCUMENTO"));
                lista.add(objBnMesaParte);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsultaMesaPartes(objBeanMesaParte) : " + e.getMessage());
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
}
