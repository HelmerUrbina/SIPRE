/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanDemandaAdicional;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.DemandaAdicionalDAO;
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
 * @author H-URBINA-M
 */
public class DemandaAdicionalDAOImpl implements DemandaAdicionalDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanDemandaAdicional objBnDemandaAdicional;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public DemandaAdicionalDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NDEMANDA_ADICIONAL_CODIGO AS CODIGO, REPLACE(VDEMANDA_ADICIONAL_DESCRIPCION,'\n"
                + "', ' ') AS DESCRIPCION, "
                + "SD_PFE.FUN_MONTO_DEMANDA_ADICIONAL(CPERIODO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, NDEMANDA_ADICIONAL_CODIGO) AS IMPORTE, "
                + "SD_PFE.FUN_MONTO_APROBADO_DEMANDA_ADI(CPERIODO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, NDEMANDA_ADICIONAL_CODIGO) AS IMPORTE_APROBADO, "
                + "CASE CESTADO_CODIGO WHEN 'PE' THEN 'PENDIENTE' WHEN 'CE' THEN 'CERRADO' WHEN 'AN' THEN 'ANULADO' WHEN 'AP' THEN 'APROBADO' ELSE 'VERIFICAR' END AS ESTADO, "
                + "VDEMANA_ADICIONAL_DOCUMENTO AS ARCHIVO, DDEMANDA_ADICIONAL_FECHA AS FECHA "
                + "FROM SIPE_DEMANDA_ADICIONAL WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=?  "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDemandaAdicional.getPeriodo());
            objPreparedStatement.setString(2, objBeanDemandaAdicional.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanDemandaAdicional.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnDemandaAdicional = new BeanDemandaAdicional();
                objBnDemandaAdicional.setCodigo(objResultSet.getInt("CODIGO"));
                objBnDemandaAdicional.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnDemandaAdicional.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnDemandaAdicional.setCantidad(objResultSet.getDouble("IMPORTE_APROBADO"));
                objBnDemandaAdicional.setEstado(objResultSet.getString("ESTADO"));
                objBnDemandaAdicional.setTarea(objResultSet.getString("ARCHIVO"));
                objBnDemandaAdicional.setCadenaGasto(objResultSet.getString("FECHA"));
                lista.add(objBnDemandaAdicional);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDemandaAdicional(BeanDemandaAdicional) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DEMANDA_ADICIONAL");
            objBnMsgerr.setTipo(objBeanDemandaAdicional.getMode().toUpperCase());
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
    public BeanDemandaAdicional getDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario) {
        sql = "SELECT VDEMANDA_ADICIONAL_DESCRIPCION "
                + "FROM SIPE_DEMANDA_ADICIONAL WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NDEMANDA_ADICIONAL_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDemandaAdicional.getPeriodo());
            objPreparedStatement.setString(2, objBeanDemandaAdicional.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanDemandaAdicional.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanDemandaAdicional.setDescripcion(objResultSet.getString("VDEMANDA_ADICIONAL_DESCRIPCION"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getDemandaAdicional(BeanDemandaAdicional) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DEMANDA_ADICIONAL");
            objBnMsgerr.setTipo(objBeanDemandaAdicional.getMode().toUpperCase());
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
        return objBeanDemandaAdicional;
    }

    @Override
    public ArrayList getListaDetalleDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT CDEPENDENCIA_CODIGO||':'||UTIL_NEW.FUN_ABRDEP(CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "CTAREA_CODIGO||'-'||UTIL_NEW.FUN_NTAREA(CTAREA_CODIGO) AS TAREA, "
                + "UTIL_NEW.FUN_NOUNME_TAPAIN(CTAREA_CODIGO) AS UNIDAD_MEDIDA, "
                + "VCADENA_GASTO_CODIGO||':'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(VCADENA_GASTO_CODIGO) AS CADENA_GASTO, "
                + "NDEMANDA_ADICIONAL_IMPORTE AS IMPORTE_REQUERIDO, NDEMANDA_ADICIONAL_CANTIDAD AS CANTIDAD_REQUERIDA,  "
                + "NIMPORTE_APROBADO AS IMPORTE_APROBADO,  NCANTIDAD_APROBADA AS CANTIDAD_APROBADA "
                + "FROM SIPE_DEMANDA_ADICIONAL_DETALLE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NDEMANDA_ADICIONAL_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDemandaAdicional.getPeriodo());
            objPreparedStatement.setString(2, objBeanDemandaAdicional.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanDemandaAdicional.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("DEPENDENCIA") + "+++"
                        + objResultSet.getString("TAREA") + "+++"
                        + objResultSet.getString("UNIDAD_MEDIDA") + "+++"
                        + objResultSet.getString("CADENA_GASTO") + "+++"
                        + objResultSet.getDouble("IMPORTE_REQUERIDO") + "+++"
                        + objResultSet.getInt("CANTIDAD_REQUERIDA") + "+++"
                        + objResultSet.getDouble("IMPORTE_APROBADO") + "+++"
                        + objResultSet.getInt("CANTIDAD_APROBADA");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaDetalleDemandaAdicional(objBeanDemandaAdicional) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DEMANDA_ADICIONAL");
            objBnMsgerr.setTipo(objBeanDemandaAdicional.getMode().toUpperCase());
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
        return Arreglo;
    }

    @Override
    public ArrayList getListaMetaFisicaDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT CTAREA_CODIGO||'-'||UTIL_NEW.FUN_NTAREA(CTAREA_CODIGO) AS TAREA, "
                + "UTIL_NEW.FUN_NOUNME_TAPAIN(CTAREA_CODIGO) AS UNIDAD_MEDIDA, "
                + "MAX(NDEMANDA_ADICIONAL_CANTIDAD) AS CANTIDAD "
                + "FROM SIPE_DEMANDA_ADICIONAL_DETALLE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NDEMANDA_ADICIONAL_CODIGO=? "
                + "GROUP BY CTAREA_CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDemandaAdicional.getPeriodo());
            objPreparedStatement.setString(2, objBeanDemandaAdicional.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanDemandaAdicional.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("TAREA") + "+++"
                        + objResultSet.getString("UNIDAD_MEDIDA") + "+++"
                        + objResultSet.getDouble("CANTIDAD");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaMetaFisicaDemandaAdicional(objBeanDemandaAdicional) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DEMANDA_ADICIONAL");
            objBnMsgerr.setTipo(objBeanDemandaAdicional.getMode().toUpperCase());
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
        return Arreglo;
    }

    @Override
    public Integer getCodigoDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario) {
        Integer codigo = 0;
        sql = "SELECT COUNT(NDEMANDA_ADICIONAL_CODIGO)+1 AS CODIGO "
                + "FROM SIPE_DEMANDA_ADICIONAL WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanDemandaAdicional.getPeriodo());
            objPreparedStatement.setString(2, objBeanDemandaAdicional.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                codigo = objResultSet.getInt("CODIGO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCodigoDemandaAdicional(BeanDemandaAdicional) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DEMANDA_ADICIONAL");
            objBnMsgerr.setTipo(objBeanDemandaAdicional.getMode().toUpperCase());
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
        return codigo;
    }

    @Override
    public int iduDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA DEMANDA ADICIONAL, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * SIPE_DEMANDA_ADICIONAL, EN CASO DE OBTENER ALGUN ERROR SE ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE MOSTRARA EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_DEMANDA_ADICIONAL(?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanDemandaAdicional.getPeriodo());
            cs.setString(2, objBeanDemandaAdicional.getUnidadOperativa());
            cs.setInt(3, objBeanDemandaAdicional.getPresupuesto());
            cs.setInt(4, objBeanDemandaAdicional.getCodigo());
            cs.setString(5, objBeanDemandaAdicional.getDescripcion());
            cs.setString(6, usuario);
            cs.setString(7, objBeanDemandaAdicional.getMode());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduDemandaAdicional : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DEMANDA_ADICIONAL");
            objBnMsgerr.setTipo(objBeanDemandaAdicional.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduDemandaAdicional : " + e.toString());
            }
        }
        return s;
    }

    @Override
    public int iduDetalleDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA DEMANDA ADICIONAL DETALLE, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * SIPE_DEMANDA_ADICIONAL_DETALLE, EN CASO DE OBTENER ALGUN ERROR SE ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE MOSTRARA EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_DEMANDA_ADICIONAL_DETAL(?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanDemandaAdicional.getPeriodo());
            cs.setString(2, objBeanDemandaAdicional.getUnidadOperativa());
            cs.setInt(3, objBeanDemandaAdicional.getCodigo());
            cs.setString(4, objBeanDemandaAdicional.getDependencia());
            cs.setString(5, objBeanDemandaAdicional.getTarea());
            cs.setString(6, objBeanDemandaAdicional.getCadenaGasto());
            cs.setDouble(7, objBeanDemandaAdicional.getImporte());
            cs.setString(8, usuario);
            cs.setString(9, objBeanDemandaAdicional.getMode());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduDetalleDemandaAdicional : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DEMANDA_ADICIONAL");
            objBnMsgerr.setTipo(objBeanDemandaAdicional.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduDetalleDemandaAdicional : " + e.toString());
            }
        }
        return s;
    }

    @Override
    public int iduMetaFisicaDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA DEMANDA ADICIONAL META FISICA, EN EL
         * CUAL ACTUALIZAMOS EL REGISTRO DE LA CANTIDAD DE LA TABLA
         * SIPE_DEMANDA_ADICIONAL_DETALLE, EN CASO DE OBTENER ALGUN ERROR SE ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE MOSTRARA EL MOTIVO DEL ERROR.
         */
        sql = "UPDATE SIPE_DEMANDA_ADICIONAL_DETALLE SET "
                + "NDEMANDA_ADICIONAL_CANTIDAD=?, "
                + "CUSUARIO_META=?, "
                + "DUSUARIO_META=SYSDATE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NDEMANDA_ADICIONAL_CODIGO=? AND "
                + "CTAREA_CODIGO=?";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setDouble(1, objBeanDemandaAdicional.getImporte());
            cs.setString(2, usuario);
            cs.setString(3, objBeanDemandaAdicional.getPeriodo());
            cs.setString(4, objBeanDemandaAdicional.getUnidadOperativa());
            cs.setInt(5, objBeanDemandaAdicional.getCodigo());
            cs.setString(6, objBeanDemandaAdicional.getTarea());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduMetaFisicaDemandaAdicional : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DEMANDA_ADICIONAL");
            objBnMsgerr.setTipo(objBeanDemandaAdicional.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduMetaFisicaDemandaAdicional : " + e.toString());
            }
        }
        return s;
    }

    @Override
    public int udpAprobacionDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA DEMANDA ADICIONAL META FISICA, EN EL
         * CUAL ACTUALIZAMOS EL REGISTRO DE LA CANTIDAD DE LA TABLA
         * SIPE_DEMANDA_ADICIONAL_DETALLE, EN CASO DE OBTENER ALGUN ERROR SE ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE MOSTRARA EL MOTIVO DEL ERROR.
         */
        sql = "UPDATE SIPE_DEMANDA_ADICIONAL_DETALLE SET "
                + "NIMPORTE_APROBADO=?, "
                + "NCANTIDAD_APROBADA=?, "
                + "VUSUARIO_APRUEBA=?, "
                + "DUSUARIO_APRUEBA=SYSDATE WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NDEMANDA_ADICIONAL_CODIGO=? AND "
                + "CDEPENDENCIA_CODIGO=? AND "
                + "CTAREA_CODIGO=? AND "
                + "VCADENA_GASTO_CODIGO=? ";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setDouble(1, objBeanDemandaAdicional.getImporte());
            cs.setDouble(2, objBeanDemandaAdicional.getCantidad());
            cs.setString(3, usuario);
            cs.setString(4, objBeanDemandaAdicional.getPeriodo());
            cs.setString(5, objBeanDemandaAdicional.getUnidadOperativa());
            cs.setInt(6, objBeanDemandaAdicional.getCodigo());
            cs.setString(7, objBeanDemandaAdicional.getDependencia());
            cs.setString(8, objBeanDemandaAdicional.getTarea());
            cs.setString(9, objBeanDemandaAdicional.getCadenaGasto());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar udpAprobacionDemandaAdicional : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_DEMANDA_ADICIONAL");
            objBnMsgerr.setTipo(objBeanDemandaAdicional.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduMetaFisicaDemandaAdicional : " + e.toString());
            }
        }
        return s;
    }
}
