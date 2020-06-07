/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanFuerzaOperativa;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.FuerzaOperativaDAO;
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
public class FuerzaOperativaDAOImpl implements FuerzaOperativaDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanFuerzaOperativa objBnFuerzaOperativa;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public FuerzaOperativaDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaFuerzaOperativa(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CCODIGO_CORRELATIVO AS CODIGO,"
                + "UTIL_NEW.FUN_ABRDEP(CUNIDAD_OPERATIVA_CODIGO,CDEPENDENCIA_CODIGO) AS DEPENDENCIA,"
                + "UTIL_NEW.FUN_NOMBRE_DEPARTAMENTO(CDEPARTAMENTO_CODIGO) AS DEPARTAMENTO,"
                + "CDEPARTAMENTO_CODIGO,"
                + "CCOMENTARIO_RESOLUCION AS COMENTARIO,"
                + "CASE CESTADO_CODIGO WHEN 'AC' THEN 'ACTIVO' WHEN 'DE' THEN 'DESACTIVADO' ELSE '' END AS ESTADO,"
                + "VCOMENTARIO_DESACTIVACION AS DESACTIVACION "
                + "FROM SIPE_PROGRAMACION_FUERZA_OPE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NNIVEL_DETALLE=1 AND "
                + "CESTADO_CODIGO NOT IN ('AN') ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanFuerzaOperativa.getPeriodo());
            objPreparedStatement.setString(2, objBeanFuerzaOperativa.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnFuerzaOperativa = new BeanFuerzaOperativa();
                objBnFuerzaOperativa.setCodigo(objResultSet.getString("CODIGO"));
                objBnFuerzaOperativa.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnFuerzaOperativa.setNombreDepartamento(objResultSet.getString("DEPARTAMENTO"));
                objBnFuerzaOperativa.setCodigoDepartamento(objResultSet.getString("CDEPARTAMENTO_CODIGO"));
                objBnFuerzaOperativa.setComentario(objResultSet.getString("COMENTARIO"));
                objBnFuerzaOperativa.setEstado(objResultSet.getString("ESTADO"));
                objBnFuerzaOperativa.setDesactivacion(objResultSet.getString("DESACTIVACION"));
                lista.add(objBnFuerzaOperativa);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaFuerzaOperativa(objBeanPrgFuerzaOperativa) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_FUERZA_OPE");
            objBnMsgerr.setTipo(objBeanFuerzaOperativa.getMode().toUpperCase());
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
    public List getListaFuerzaOperativaDetalle(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT PF.CCODIGO_CORRELATIVO AS CODIGO,"
                + "UTIL_NEW.FUN_ABRDEP(PF.CUNIDAD_OPERATIVA_CODIGO,PF.CDEPENDENCIA_CODIGO) AS DEPENDENCIA,"
                + "PF.CDEPENDENCIA_CODIGO AS CODDEP,"
                + "UTIL_NEW.FUN_DESCRIP_TIPO_FUERZA(PF.NTIPO_FUERZA_CODIGO) AS TIPO_FUERZA,"
                + "PF.CCOMENTARIO_RESOLUCION AS COMENTARIO,"
                + "CASE PF.CESTADO_CODIGO WHEN 'AC' THEN 'ACTIVO' WHEN 'GE' THEN 'GENERADO' WHEN 'DE' THEN 'DESACTIVADO' ELSE '' END AS ESTADO,"
                + "PF.VCOMENTARIO_DESACTIVACION AS DESACTIVACION, "
                + "CASE WHEN PF.NCANTIDAD_OFICINAS=0 THEN 1 ELSE PF.NCANTIDAD_OFICINAS END AS CANTIDAD,"
                + "TF.NIMPORTE_TIPO_FUERZA AS IMPORTE,"
                + "CASE WHEN PF.NCANTIDAD_OFICINAS=0 THEN 1*TF.NIMPORTE_TIPO_FUERZA ELSE PF.NCANTIDAD_OFICINAS*TF.NIMPORTE_TIPO_FUERZA END AS IMP_MENSUAL, "
                + "CASE WHEN PF.NTIPO_FUERZA_CODIGO=13 THEN (1*TF.NIMPORTE_TIPO_FUERZA) WHEN PF.NCANTIDAD_OFICINAS=0 THEN (1*TF.NIMPORTE_TIPO_FUERZA)*12  ELSE (PF.NCANTIDAD_OFICINAS*TF.NIMPORTE_TIPO_FUERZA)*12 END AS IMP_ANUAL "
                + "FROM SIPE_PROGRAMACION_FUERZA_OPE PF JOIN SIPE_PROGRAMACION_TIPO_FUERZA TF ON "
                + "(PF.NTIPO_FUERZA_CODIGO=TF.NTIPO_FUERZA_CODIGO)"
                + "  WHERE "
                + "PF.CPERIODO_CODIGO=? AND "
                + "PF.CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "SUBSTR(PF.CCODIGO_CORRELATIVO,1,8)=? AND "
                + "PF.NNIVEL_DETALLE=2 AND "
                + "PF.CESTADO_CODIGO NOT IN ('AN') ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanFuerzaOperativa.getPeriodo());
            objPreparedStatement.setString(2, objBeanFuerzaOperativa.getUnidadOperativa());
            objPreparedStatement.setString(3, objBeanFuerzaOperativa.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnFuerzaOperativa = new BeanFuerzaOperativa();
                objBnFuerzaOperativa.setCodigo(objResultSet.getString("CODIGO"));
                objBnFuerzaOperativa.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnFuerzaOperativa.setDependenciaDetalle(objResultSet.getString("CODDEP"));
                objBnFuerzaOperativa.setDescripFuerzaOperativa(objResultSet.getString("TIPO_FUERZA"));
                objBnFuerzaOperativa.setComentario(objResultSet.getString("COMENTARIO"));
                objBnFuerzaOperativa.setEstado(objResultSet.getString("ESTADO"));
                objBnFuerzaOperativa.setDesactivacion(objResultSet.getString("DESACTIVACION"));
                objBnFuerzaOperativa.setCantidadOficina(objResultSet.getInt("CANTIDAD"));
                objBnFuerzaOperativa.setTotalRemuneracion(objResultSet.getDouble("IMPORTE"));
                objBnFuerzaOperativa.setImporteMensual(objResultSet.getDouble("IMP_MENSUAL"));
                objBnFuerzaOperativa.setImporteAnual(objResultSet.getDouble("IMP_ANUAL"));
                lista.add(objBnFuerzaOperativa);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaFuerzaOperativaDetalle(objBeanPrgFuerzaOperativa) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_FUERZA_OPE");
            objBnMsgerr.setTipo(objBeanFuerzaOperativa.getMode().toUpperCase());
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
    public BeanFuerzaOperativa getFuerzaOperativa(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario) {
        sql = "SELECT CDEPENDENCIA_CODIGO AS DEPENDENCIA,"
                + "CDEPARTAMENTO_CODIGO AS DEPARTAMENTO,"
                + "NVL(CCOMENTARIO_RESOLUCION, ' ') AS COMENTARIO "
                + "FROM SIPE_PROGRAMACION_FUERZA_OPE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "CCODIGO_CORRELATIVO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanFuerzaOperativa.getPeriodo());
            objPreparedStatement.setString(2, objBeanFuerzaOperativa.getUnidadOperativa());
            objPreparedStatement.setString(3, objBeanFuerzaOperativa.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanFuerzaOperativa.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBeanFuerzaOperativa.setCodigoDepartamento(objResultSet.getString("DEPARTAMENTO"));
                objBeanFuerzaOperativa.setComentario(objResultSet.getString("COMENTARIO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getFuerzaOperativa(objBeanPrgFuerzaOperativa) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_FUERZA_OPE");
            objBnMsgerr.setTipo(objBeanFuerzaOperativa.getMode().toUpperCase());
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
        return objBeanFuerzaOperativa;
    }

    @Override
    public BeanFuerzaOperativa getFuerzaOperativaDetalle(BeanFuerzaOperativa objBeanPrgFuerzaOperativa, String usuario) {
        sql = "SELECT CDEPENDENCIA_CODIGO AS DEPENDENCIA,"
                + "NVL(CCOMENTARIO_RESOLUCION, ' ') AS COMENTARIO,"
                + "NTIPO_FUERZA_CODIGO AS TIPO_FUERZA, "
                + "NCANTIDAD_OFICINAS AS CANTIDAD "
                + "FROM SIPE_PROGRAMACION_FUERZA_OPE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "CCODIGO_CORRELATIVO=? AND "
                + "NNIVEL_DETALLE=2 ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPrgFuerzaOperativa.getPeriodo());
            objPreparedStatement.setString(2, objBeanPrgFuerzaOperativa.getUnidadOperativa());
            objPreparedStatement.setString(3, objBeanPrgFuerzaOperativa.getDependenciaDetalle());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanPrgFuerzaOperativa.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBeanPrgFuerzaOperativa.setComentario(objResultSet.getString("COMENTARIO"));
                objBeanPrgFuerzaOperativa.setTipoFuerzaOperativa(objResultSet.getInt("TIPO_FUERZA"));
                objBeanPrgFuerzaOperativa.setCantidadOficina(objResultSet.getInt("CANTIDAD"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getFuerzaOperativaDetalle(objBeanPrgFuerzaOperativa) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_FUERZA_OPE");
            objBnMsgerr.setTipo(objBeanPrgFuerzaOperativa.getMode().toUpperCase());
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
        return objBeanPrgFuerzaOperativa;
    }

    @Override
    public int iduFuerzaOperativa(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario) {
        sql = "{CALL SP_IDU_PROGRAMACION_FUERZA_OPE(?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanFuerzaOperativa.getPeriodo());
            cs.setString(2, objBeanFuerzaOperativa.getUnidadOperativa());
            cs.setString(3, objBeanFuerzaOperativa.getDependencia());
            cs.setString(4, objBeanFuerzaOperativa.getCodigo());
            cs.setString(5, objBeanFuerzaOperativa.getComentario());
            cs.setString(6, objBeanFuerzaOperativa.getCodigoDepartamento());
            cs.setString(7, objBeanFuerzaOperativa.getDesactivacion());
            cs.setInt(8, objBeanFuerzaOperativa.getTipoFuerzaOperativa());
            cs.setString(9, usuario);
            cs.setString(10, objBeanFuerzaOperativa.getMode().toUpperCase());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPrgFuerzaOperativa : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_FUERZA_OPE");
            objBnMsgerr.setTipo(objBeanFuerzaOperativa.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduFuerzaOperativaDetalle(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario) {
        sql = "{CALL SP_IDU_PROGR_FUERZA_OPE_DET(?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanFuerzaOperativa.getPeriodo());
            cs.setString(2, objBeanFuerzaOperativa.getUnidadOperativa());
            cs.setString(3, objBeanFuerzaOperativa.getDependencia());
            cs.setString(4, objBeanFuerzaOperativa.getCodigoDepartamento());
            cs.setString(5, objBeanFuerzaOperativa.getCodigo());
            cs.setString(6, objBeanFuerzaOperativa.getDependenciaDetalle());
            cs.setString(7, objBeanFuerzaOperativa.getComentario());
            cs.setInt(8, objBeanFuerzaOperativa.getTipoFuerzaOperativa());
            cs.setString(9, objBeanFuerzaOperativa.getDesactivacion());
            cs.setInt(10, objBeanFuerzaOperativa.getCantidadOficina());
            cs.setString(11, usuario);
            cs.setString(12, objBeanFuerzaOperativa.getMode().toUpperCase());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPrgFuerzaOperativaDet : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_FUERZA_OPE");
            objBnMsgerr.setTipo(objBeanFuerzaOperativa.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public List getListaEfectivoFuerOperativa(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CODGRD||''||NVL(CPERIODO_REE,0) AS CODIGO,"
                + "UTIL_NEW.FUN_DESCRIPCION_GRADO(CODGRD) AS NOMGRADO,"
                + "UTIL_NEW.FUN_NOMBRE_GRADO(CODGRD) AS ABRGRADO,"
                + "CASE CPERIODO_REE WHEN 'P1' THEN '1er Periodo' WHEN 'P2' THEN '2do Periodo' "
                + "WHEN 'P3' THEN '3er Periodo' WHEN 'P4' THEN '4to Periodo' WHEN 'P5' THEN '5to Periodo' ELSE "
                + "'' END AS PERIODO_REE,"
                + "SUM(NIMPORTE) AS IMPORTE,"
                + "UTIL.FUN_CANTIDAD_EFEC_FUERZA_OPE(CODPER,?,CODGRD,NVL(CPERIODO_REE,0)) AS CANTIDAD,"
                + "SUM(NIMPORTE)*UTIL.FUN_CANTIDAD_EFEC_FUERZA_OPE(CODPER,?,CODGRD,CPERIODO_REE) AS TOTAL,"
                + "CODGRD,NVL(CPERIODO_REE,0) AS CPERIODO_REE,"
                + "UTIL.FUN_DESCRIPCION_NIVEL_GRD(NNIVEL_GRADO_CODIGO) AS NIVEL "
                + "FROM SIPE_INGRESOS_PERSONAL_EP "
                + "WHERE CODPER=? "
                + "GROUP BY CODGRD,CPERIODO_REE,CODPER,NNIVEL_GRADO_CODIGO "
                + "ORDER BY CODIGO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanFuerzaOperativa.getCodigo());
            objPreparedStatement.setString(2, objBeanFuerzaOperativa.getCodigo());
            objPreparedStatement.setString(3, objBeanFuerzaOperativa.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnFuerzaOperativa = new BeanFuerzaOperativa();
                objBnFuerzaOperativa.setCodigo(objResultSet.getString("CODIGO"));
                objBnFuerzaOperativa.setDependencia(objResultSet.getString("NOMGRADO"));
                objBnFuerzaOperativa.setDependenciaDetalle(objResultSet.getString("ABRGRADO"));
                objBnFuerzaOperativa.setPeriodoREE(objResultSet.getString("PERIODO_REE"));
                objBnFuerzaOperativa.setRemuneracion(objResultSet.getDouble("IMPORTE"));
                objBnFuerzaOperativa.setCantidadOficina(objResultSet.getInt("CANTIDAD"));
                objBnFuerzaOperativa.setTotalRemuneracion(objResultSet.getDouble("TOTAL"));
                objBnFuerzaOperativa.setCodigoDepartamento(objResultSet.getString("CODGRD"));
                objBnFuerzaOperativa.setComentario(objResultSet.getString("CPERIODO_REE"));
                objBnFuerzaOperativa.setEstado(objResultSet.getString("NIVEL"));
                lista.add(objBnFuerzaOperativa);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaEfectivoFuerOperativa(objBeanPrgFuerzaOperativa) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_INGRESOS_PERSONAL_EP");
            objBnMsgerr.setTipo(objBeanFuerzaOperativa.getMode().toUpperCase());
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
    public int iduEfectivoFuerzaOpe(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario) {
        sql = "{CALL SP_IDU_EFECTIVO_FUERZA_OPERAT(?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanFuerzaOperativa.getPeriodo());
            cs.setString(2, objBeanFuerzaOperativa.getUnidadOperativa());
            cs.setString(3, objBeanFuerzaOperativa.getDependencia());
            cs.setString(4, objBeanFuerzaOperativa.getCodigo());
            cs.setString(5, objBeanFuerzaOperativa.getCodigoDepartamento());
            cs.setString(6, objBeanFuerzaOperativa.getPeriodoREE());
            cs.setDouble(7, 0);
            cs.setInt(8, objBeanFuerzaOperativa.getCantidadOficina());
            cs.setString(9, usuario);
            cs.setString(10, objBeanFuerzaOperativa.getMode().toUpperCase());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduEfectivoFuerzaOpe : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_EFECTIVO_FUER_OPERATIVA");
            objBnMsgerr.setTipo(objBeanFuerzaOperativa.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduGenerarFuncionamientoFO(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario) {
        sql = "{CALL SP_INS_FUNCIONAMIENTO_FO(?,?,?)}";       
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanFuerzaOperativa.getPeriodo());
            cs.setString(2, objBeanFuerzaOperativa.getUnidadOperativa());
            cs.setString(3, usuario);
            s = cs.executeUpdate();        
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduGenerarFuncionamientoFO : "  + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_EFECTIVO_FUER_OPERATIVA");
            objBnMsgerr.setTipo("P");
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }
}
