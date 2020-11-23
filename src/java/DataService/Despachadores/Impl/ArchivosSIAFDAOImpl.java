/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanArchivosSIAF;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.ArchivosSIAFDAO;
import DataService.Despachadores.MsgerrDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

/**
 *
 * @author H-URBINA-M
 */
public class ArchivosSIAFDAOImpl implements ArchivosSIAFDAO {

    private final Connection objConnection;
    private String sql;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ArchivosSIAFDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public int iduMarcoPresupuestal(BeanArchivosSIAF objBeanArchivo, String usuario) {
        sql = "{CALL SP_SIAF_MARCO_PPTAL(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanArchivo.getPeriodo());
            cs.setString(2, objBeanArchivo.getSecuenciaFuncional());
            cs.setString(3, objBeanArchivo.getPresupuesto());
            cs.setString(4, objBeanArchivo.getTipoTransaccion());
            cs.setString(5, objBeanArchivo.getGenericaGasto());
            cs.setString(6, objBeanArchivo.getSubGenericaGasto());
            cs.setString(7, objBeanArchivo.getSubGenericaDetalleGasto());
            cs.setString(8, objBeanArchivo.getEspecificaGasto());
            cs.setString(9, objBeanArchivo.getEspecificaDetalleGasto());
            cs.setDouble(10, objBeanArchivo.getPIM());
            cs.setDouble(11, objBeanArchivo.getEjecucion());
            cs.setDouble(12, objBeanArchivo.getSaldo());
            cs.setDouble(13, objBeanArchivo.getMonto());
            cs.setDouble(14, objBeanArchivo.getEnero());
            cs.setDouble(15, objBeanArchivo.getFebrero());
            cs.setDouble(16, objBeanArchivo.getMarzo());
            cs.setDouble(17, objBeanArchivo.getAbril());
            cs.setDouble(18, objBeanArchivo.getMayo());
            cs.setDouble(19, objBeanArchivo.getJunio());
            cs.setDouble(20, objBeanArchivo.getJulio());
            cs.setDouble(21, objBeanArchivo.getAgosto());
            cs.setDouble(22, objBeanArchivo.getSetiembre());
            cs.setDouble(23, objBeanArchivo.getOctubre());
            cs.setDouble(24, objBeanArchivo.getNoviembre());
            cs.setDouble(25, objBeanArchivo.getDiciembre());
            cs.setString(26, objBeanArchivo.getActividad());
            cs.setString(27, objBeanArchivo.getCategoriaPresupuestal());
            cs.setString(28, objBeanArchivo.getProducto());
            cs.setString(29, objBeanArchivo.getFuncion());
            cs.setString(30, objBeanArchivo.getDivisionFuncional());
            cs.setString(31, objBeanArchivo.getGrupoFuncional());
            cs.setString(32, objBeanArchivo.getMeta());
            cs.setString(33, objBeanArchivo.getFinalidad());
            cs.setString(34, objBeanArchivo.getUnidadMedida());
            cs.setDouble(35, objBeanArchivo.getMontoNacional());
            cs.setString(36, usuario);
            cs.setString(37, objBeanArchivo.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduMarcoPresupuestal : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("ARCHIVOS_SIAF");
            objBnMsgerr.setTipo(objBeanArchivo.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduCertificadoSIAF(BeanArchivosSIAF objBeanArchivo, String usuario) {
        sql = "{CALL SP_SIAF_CERTIFICADO(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanArchivo.getPeriodo());
            cs.setString(2, objBeanArchivo.getEjecutora());
            cs.setString(3, objBeanArchivo.getCertificado());
            cs.setString(4, objBeanArchivo.getSecuencia());
            cs.setString(5, objBeanArchivo.getCorrelativo());
            cs.setString(6, objBeanArchivo.getPresupuesto());
            cs.setString(7, objBeanArchivo.getDocumento());
            cs.setString(8, objBeanArchivo.getNumeroDocumento());
            cs.setDate(9, objBeanArchivo.getFechaDocumento());
            cs.setString(10, objBeanArchivo.getRUC());
            cs.setString(11, objBeanArchivo.getCadenaGasto());
            cs.setString(12, objBeanArchivo.getSecuenciaFuncional());
            cs.setString(13, objBeanArchivo.getMoneda());
            cs.setDouble(14, objBeanArchivo.getTipoCambio());
            cs.setDouble(15, objBeanArchivo.getMonto());
            cs.setDouble(16, objBeanArchivo.getMontoNacional());
            cs.setString(17, objBeanArchivo.getEstado());
            cs.setString(18, objBeanArchivo.getTipoRegistro());
            cs.setString(19, objBeanArchivo.getEstadoRegistro());
            cs.setString(20, objBeanArchivo.getEstadoEnvio());
            cs.setString(21, objBeanArchivo.getTipoTransaccion());
            cs.setString(22, objBeanArchivo.getGenericaGasto());
            cs.setString(23, objBeanArchivo.getSubGenericaGasto());
            cs.setString(24, objBeanArchivo.getSubGenericaDetalleGasto());
            cs.setString(25, objBeanArchivo.getEspecificaGasto());
            cs.setString(26, objBeanArchivo.getEspecificaDetalleGasto());
            cs.setString(27, objBeanArchivo.getRegistroTipo());
            cs.setString(28, usuario);
            cs.setString(29, objBeanArchivo.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduCertificadoSIAF : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("ARCHIVOS_SIAF");
            objBnMsgerr.setTipo(objBeanArchivo.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduPriorizacionSIAF(BeanArchivosSIAF objBeanArchivo, String usuario) {
        sql = "{CALL SP_SIAF_PRIORIZACION(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanArchivo.getPeriodo());
            cs.setString(2, objBeanArchivo.getPresupuesto());
            cs.setString(3, objBeanArchivo.getTipoTransaccion());
            cs.setString(4, objBeanArchivo.getGenericaGasto());
            cs.setString(5, objBeanArchivo.getSubGenericaGasto());
            cs.setString(6, objBeanArchivo.getSubGenericaDetalleGasto());
            cs.setString(7, objBeanArchivo.getEspecificaGasto());
            cs.setString(8, objBeanArchivo.getEspecificaDetalleGasto());
            cs.setDouble(9, objBeanArchivo.getMonto());
            cs.setDouble(10, objBeanArchivo.getPIM());
            cs.setDouble(11, objBeanArchivo.getEnero());
            cs.setDouble(12, objBeanArchivo.getFebrero());
            cs.setDouble(13, objBeanArchivo.getMarzo());
            cs.setString(14, usuario);
            cs.setString(15, objBeanArchivo.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPriorizacionSIAF : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("ARCHIVOS_SIAF");
            objBnMsgerr.setTipo(objBeanArchivo.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduNotasModificatoriasSIAF(BeanArchivosSIAF objBeanArchivo, String usuario) {
        sql = "{CALL SP_IDU_CERTIFICADO_SIAF(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanArchivo.getPeriodo());
            cs.setString(2, objBeanArchivo.getEjecutora());
            cs.setString(3, objBeanArchivo.getCertificado());
            cs.setString(4, objBeanArchivo.getSecuencia());
            cs.setString(5, objBeanArchivo.getCorrelativo());
            cs.setString(6, objBeanArchivo.getPresupuesto());
            cs.setString(7, objBeanArchivo.getDocumento());
            cs.setString(8, objBeanArchivo.getNumeroDocumento());
            cs.setDate(9, objBeanArchivo.getFechaDocumento());
            cs.setString(10, objBeanArchivo.getRUC());
            cs.setString(11, objBeanArchivo.getCadenaGasto());
            cs.setString(12, objBeanArchivo.getSecuenciaFuncional());
            cs.setString(13, objBeanArchivo.getMoneda());
            cs.setDouble(14, objBeanArchivo.getTipoCambio());
            cs.setDouble(15, objBeanArchivo.getMonto());
            cs.setDouble(16, objBeanArchivo.getMontoNacional());
            cs.setString(17, objBeanArchivo.getEstado());
            cs.setString(18, objBeanArchivo.getTipoRegistro());
            cs.setString(19, objBeanArchivo.getEstadoRegistro());
            cs.setString(20, objBeanArchivo.getEstadoEnvio());
            cs.setString(21, objBeanArchivo.getTipoTransaccion());
            cs.setString(22, objBeanArchivo.getGenericaGasto());
            cs.setString(23, objBeanArchivo.getSubGenericaGasto());
            cs.setString(24, objBeanArchivo.getSubGenericaDetalleGasto());
            cs.setString(25, objBeanArchivo.getEspecificaGasto());
            cs.setString(26, objBeanArchivo.getEspecificaDetalleGasto());
            cs.setString(27, objBeanArchivo.getRegistroTipo());
            cs.setString(28, usuario);
            cs.setString(29, objBeanArchivo.getMode());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduCertificadoSIAF : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("ARCHIVOS_SIAF");
            objBnMsgerr.setTipo(objBeanArchivo.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

}
