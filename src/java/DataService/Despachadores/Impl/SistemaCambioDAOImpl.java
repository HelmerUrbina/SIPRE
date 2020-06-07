/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanSistemaCambio;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.SistemaCambioDAO;
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
public class SistemaCambioDAOImpl implements SistemaCambioDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanSistemaCambio objBnSistemaCambio;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public SistemaCambioDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaSistemaCambio(BeanSistemaCambio objBeanSistemaCambio, String usuario) {
        lista = new LinkedList<>();
        if (usuario.equals("43305891") || usuario.equals("10714635") || usuario.equals("44469132") || usuario.equals("125534700")) {
            usuario = "%";
        }
        sql = "SELECT VSISTEMA_CAMBIO_USUARIO||'.'||NSISTEMA_CAMBIO_CODIGO AS CODIGO, "
                + "UTIL_NEW.FUN_DESC_USUARIO(VSISTEMA_CAMBIO_USUARIO) AS USUARIO, "
                + "CUNIDAD_OPERATIVA_CODIGO||':'||UTIL_NEW.FUN_ABUUOO(CUNIDAD_OPERATIVA_CODIGO) AS UNIDAD_OPERATIVA, "
                + "DSISTEMA_CAMBIO_FECHA AS FECHA, CASE CSISTEMA_CAMBIO_FASE WHEN 'CE' THEN 'CERTIFICADO' "
                + "WHEN 'CO' THEN 'COMPROMISO ANUAL' WHEN 'DE' THEN 'DECLARACION JURADA' WHEN 'NO' THEN 'NOTA_MODIFICATORIA' "
                + "ELSE 'REVISAR' END FASE, REPLACE(REGEXP_REPLACE(UPPER(VSISTEMA_CAMBIO_ASUNTO),'''',''),'\n"
                + "', ' ') AS ASUNTO, REPLACE(REGEXP_REPLACE(UPPER(VSISTEMA_CAMBIO_DESCRIPCION),'''',''),'\n"
                + "', ' ') AS DESCRIPCION, REPLACE(REGEXP_REPLACE(UPPER(VSISTEMA_CAMBIO_OBSERVACION),'''',''),'\n"
                + "', ' ') AS OBSERVACIONES, CASE CESTADO_CODIGO WHEN 'PE' THEN 'PENDIENTE' WHEN 'AT' THEN 'ATENDIDO' "
                + "WHEN 'VE' THEN 'VERIFICANDO' ELSE 'REVISAR' END AS ESTADO, "
                + "UTIL_NEW.FUN_DESC_USUARIO(VSISTEMA_CAMBIO_RESPONSABLE) AS RESPONSABLE, "
                + "DSISTEMA_CAMBIO_FECHA_SOLUCION AS FECHA_SOLUCION, VSISTEMA_CAMBIO_ACCION AS SOLUCION "
                + "FROM SIPE_SISTEMA_CAMBIO WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "VSISTEMA_CAMBIO_USUARIO LIKE ? "
                + "ORDER BY VSISTEMA_CAMBIO_USUARIO, NSISTEMA_CAMBIO_CODIGO DESC";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanSistemaCambio.getPeriodo());
            objPreparedStatement.setString(2, usuario);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnSistemaCambio = new BeanSistemaCambio();
                objBnSistemaCambio.setCodigo(objResultSet.getString("CODIGO"));
                objBnSistemaCambio.setUsuario(objResultSet.getString("USUARIO"));
                objBnSistemaCambio.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnSistemaCambio.setFecha(objResultSet.getDate("FECHA"));
                objBnSistemaCambio.setFase(objResultSet.getString("FASE"));
                objBnSistemaCambio.setAsunto(objResultSet.getString("ASUNTO"));
                objBnSistemaCambio.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnSistemaCambio.setObservacion(objResultSet.getString("OBSERVACIONES"));
                objBnSistemaCambio.setEstado(objResultSet.getString("ESTADO"));
                objBnSistemaCambio.setResponsable(objResultSet.getString("RESPONSABLE"));
                objBnSistemaCambio.setFechaSolucion(objResultSet.getDate("FECHA_SOLUCION"));
                objBnSistemaCambio.setAccion(objResultSet.getString("SOLUCION"));
                lista.add(objBnSistemaCambio);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaSistemaCambio(objBeanSistemaCambio," + usuario + ") : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_SISTEMA_CAMBIO");
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
                System.out.println(e.toString());
            }
        }
        return lista;
    }

    @Override
    public int iduSistemaCambio(BeanSistemaCambio objBeanSistemaCambio, String usuario) {
        sql = "{CALL SP_IDU_SOLICITUD_CAMBIO(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try {
            try (CallableStatement cs = objConnection.prepareCall(sql)) {
                cs.setString(1, objBeanSistemaCambio.getPeriodo());
                cs.setString(2, objBeanSistemaCambio.getUsuario());
                cs.setString(3, objBeanSistemaCambio.getCodigo());
                cs.setDate(4, objBeanSistemaCambio.getFecha());
                cs.setString(5, objBeanSistemaCambio.getFase());
                cs.setString(6, objBeanSistemaCambio.getUnidadOperativa());
                cs.setString(7, objBeanSistemaCambio.getAsunto());
                cs.setString(8, objBeanSistemaCambio.getDescripcion());
                cs.setString(9, objBeanSistemaCambio.getObservacion());
                cs.setDate(10, objBeanSistemaCambio.getFechaSolucion());
                cs.setString(11, objBeanSistemaCambio.getAccion());
                cs.setString(12, usuario);
                cs.setString(13, objBeanSistemaCambio.getMode().toUpperCase());
                s = cs.executeUpdate();
                cs.close();
            }
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduSistemaCambio : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_SISTEMA_CAMBIO");
            objBnMsgerr.setTipo(objBeanSistemaCambio.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }
}
