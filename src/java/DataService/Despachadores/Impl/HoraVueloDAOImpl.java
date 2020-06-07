/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanHoraVuelo;
import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.HoraVueloDAO;
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
public class HoraVueloDAOImpl implements HoraVueloDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanHoraVuelo objBnHoraVuelo;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public HoraVueloDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NCODIGO_AERONAVE AS CODIGO,"
                + "VDESCRIPCION_AERONAVE AS DESCRIPCION,"
                + "CASE CTIPO_AERONAVE WHEN 'H' THEN 'HELICOPTEROS' WHEN 'T' THEN 'TRANSPORTE' "
                + "WHEN 'G' THEN 'DE COMBATE' ELSE '' END AS TIPO_AERONAVE,"
                + "UTIL.FUN_COSTO_POR_AERONAVE_SINIGV(?,NCODIGO_AERONAVE) AS COSTO_SINIGV, "
                + "UTIL.FUN_COSTO_POR_AERONAVE_SINIGV(?,NCODIGO_AERONAVE)+UTIL.FUN_COSTO_POR_AERONAVE_COMBU(?,NCODIGO_AERONAVE) AS COSTO_COMBU,"
                + "UTIL.FUN_COSTO_POR_AERONAVE_SINIGV(?,NCODIGO_AERONAVE)+UTIL.FUN_COSTO_POR_AERONAVE_CONIGV(?,NCODIGO_AERONAVE) AS COSTO_CONIGV "
                + " FROM SIPE_PROGRAMACION_AERONAVE "
                + "WHERE CESTADO_AERONAVE='AC' "
                + "ORDER BY CODIGO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanHoraVuelo.getPeriodo());
            objPreparedStatement.setString(2, objBeanHoraVuelo.getPeriodo());
            objPreparedStatement.setString(3, objBeanHoraVuelo.getPeriodo());
            objPreparedStatement.setString(4, objBeanHoraVuelo.getPeriodo());
            objPreparedStatement.setString(5, objBeanHoraVuelo.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnHoraVuelo = new BeanHoraVuelo();
                objBnHoraVuelo.setCodigoAeronave(objResultSet.getInt("CODIGO"));
                objBnHoraVuelo.setAeronave(objResultSet.getString("DESCRIPCION"));
                objBnHoraVuelo.setTipoAeronave(objResultSet.getString("TIPO_AERONAVE"));
                objBnHoraVuelo.setImporte(objResultSet.getDouble("COSTO_SINIGV"));
                objBnHoraVuelo.setCostoCCFFAA(objResultSet.getDouble("COSTO_COMBU"));
                objBnHoraVuelo.setCostoEntidades(objResultSet.getDouble("COSTO_CONIGV"));
                lista.add(objBnHoraVuelo);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaHoraVuelo(objBeanPrgFuerzaOperativa) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_AERONAVE");
            objBnMsgerr.setTipo(objBeanHoraVuelo.getMode().toUpperCase());
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
    public BeanHoraVuelo getHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario) {
        sql = "SELECT CTIPO_AERONAVE,"
                + "VDESCRIPCION_AERONAVE "
                + " FROM SIPE_PROGRAMACION_AERONAVE "
                + "WHERE NCODIGO_AERONAVE=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setInt(1, objBeanHoraVuelo.getCodigoAeronave());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanHoraVuelo.setTipoAeronave(objResultSet.getString("CTIPO_AERONAVE"));
                objBeanHoraVuelo.setAeronave(objResultSet.getString("VDESCRIPCION_AERONAVE"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getHoraVuelo(objBeanHoraVuelo) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_AERONAVE");
            objBnMsgerr.setTipo(objBeanHoraVuelo.getMode().toUpperCase());
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
        return objBeanHoraVuelo;
    }

    @Override
    public int iduHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario) {
        sql = "{CALL SP_IDU_AERONAVE(?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setInt(1, objBeanHoraVuelo.getCodigoAeronave());
            cs.setString(2, objBeanHoraVuelo.getAeronave());
            cs.setString(3, objBeanHoraVuelo.getTipoAeronave());
            cs.setString(4, usuario);
            cs.setString(5, objBeanHoraVuelo.getMode().toUpperCase());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduHoraVuelo : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROGRAMACION_AERONAVE");
            objBnMsgerr.setTipo(objBeanHoraVuelo.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduHoraVuelo : " + e.toString());
            }
        }
        return s;
    }

    @Override
    public List getListaCosteoHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NCOSTEO_CODIGO AS CODIGO,"
                + "VCADENA_GASTO_CODIGO||':'||UTIL_NEW.FUN_NOCLAS(VCADENA_GASTO_CODIGO) AS CADENA_GASTO,"
                + "NIMPORTE_COSTEO AS IMPORTE,"
                + "CASE CTIPO_COSTO WHEN 'CD' THEN 'COSTOS DIRECTOS' WHEN 'CI' THEN 'COSTOS INDIRECTOS' ELSE '' END AS TIPO_COSTO "
                + " FROM SIPE_PROG_COSTEO_AERONAVE "
                + "WHERE CESTADO_COSTEO='AC' AND "
                + "CPERIODO_CODIGO=? AND "
                + "NCODIGO_AERONAVE=? "
                + "ORDER BY CODIGO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanHoraVuelo.getPeriodo());
            objPreparedStatement.setInt(2, objBeanHoraVuelo.getCodigoAeronave());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnHoraVuelo = new BeanHoraVuelo();
                objBnHoraVuelo.setCodigoCosteo(objResultSet.getInt("CODIGO"));
                objBnHoraVuelo.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnHoraVuelo.setImporte(objResultSet.getDouble("IMPORTE"));
                objBnHoraVuelo.setTipoCosto(objResultSet.getString("TIPO_COSTO"));
                lista.add(objBnHoraVuelo);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaCosteoHoraVuelo(objBeanPrgFuerzaOperativa) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROG_COSTEO_AERONAVE");
            objBnMsgerr.setTipo(objBeanHoraVuelo.getMode().toUpperCase());
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
    public int iduCosteoHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario) {
        sql = "{CALL SP_IDU_COSTEO_AERONAVE(?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanHoraVuelo.getPeriodo());
            cs.setInt(2, objBeanHoraVuelo.getCodigoCosteo());
            cs.setInt(3, objBeanHoraVuelo.getCodigoAeronave());
            cs.setString(4, objBeanHoraVuelo.getTipoCosto());
            cs.setString(5, objBeanHoraVuelo.getCadenaGasto());
            cs.setDouble(6, objBeanHoraVuelo.getImporte());
            cs.setString(7, usuario);
            cs.setString(8, objBeanHoraVuelo.getMode().toUpperCase());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduCosteoHoraVuelo : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROG_COSTEO_AERONAVE");
            objBnMsgerr.setTipo(objBeanHoraVuelo.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduCosteoHoraVuelo : " + e.toString());
            }
        }
        return s;
    }

    @Override
    public BeanHoraVuelo getCosteoHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario) {
        sql = "SELECT CTIPO_COSTO,"
                + "VCADENA_GASTO_CODIGO,"
                + "NIMPORTE_COSTEO "
                + " FROM SIPE_PROG_COSTEO_AERONAVE "
                + "WHERE CPERIODO_CODIGO=? AND "
                + "NCOSTEO_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanHoraVuelo.getPeriodo());
            objPreparedStatement.setInt(2, objBeanHoraVuelo.getCodigoCosteo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanHoraVuelo.setTipoCosto(objResultSet.getString("CTIPO_COSTO"));
                objBeanHoraVuelo.setCadenaGasto(objResultSet.getString("VCADENA_GASTO_CODIGO"));
                objBeanHoraVuelo.setImporte(objResultSet.getDouble("NIMPORTE_COSTEO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCosteoHoraVuelo(objBeanHoraVuelo) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROG_COSTEO_AERONAVE");
            objBnMsgerr.setTipo(objBeanHoraVuelo.getMode().toUpperCase());
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
        return objBeanHoraVuelo;
    }

    @Override
    public String getCostoAeronaveHV(BeanHoraVuelo objBeanHoraVuelo, String usuario) {
        String dato = "0";

        sql = "SELECT NVL(SUM(NIMPORTE_COSTEO),0)+UTIL.FUN_COSTO_POR_AERONAVE_COMBU(CPERIODO_CODIGO,NCODIGO_AERONAVE) AS IMPORTE "
                + " FROM SIPE_PROG_COSTEO_AERONAVE "
                + "WHERE CPERIODO_CODIGO=? AND "
                + "NCODIGO_AERONAVE=? AND "
                + "CESTADO_COSTEO='AC' "
                + "GROUP BY CPERIODO_CODIGO,NCODIGO_AERONAVE";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);

            objPreparedStatement.setString(1, objBeanHoraVuelo.getPeriodo());
            objPreparedStatement.setInt(2, objBeanHoraVuelo.getCodigoAeronave());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                dato = objResultSet.getString("IMPORTE");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCostoAeronaveHV(objBeanHoraVuelo) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROG_COSTEO_AERONAVE");
            objBnMsgerr.setTipo(objBeanHoraVuelo.getMode().toUpperCase());
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
        return dato;
    }

    @Override
    public String getCosteoAeronaveHVEntidades(BeanHoraVuelo objBeanHoraVuelo, String usuario) {
        String dato = "0";

        sql = "SELECT NVL(SUM(NIMPORTE_COSTEO),0)+UTIL.FUN_COSTO_POR_AERONAVE_CONIGV(CPERIODO_CODIGO,NCODIGO_AERONAVE) AS IMPORTE  "
                + " FROM SIPE_PROG_COSTEO_AERONAVE "
                + "WHERE CPERIODO_CODIGO=? AND "
                + "NCODIGO_AERONAVE=? AND "
                + "CESTADO_COSTEO='AC' "
                + "GROUP BY CPERIODO_CODIGO,NCODIGO_AERONAVE";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);

            objPreparedStatement.setString(1, objBeanHoraVuelo.getPeriodo());
            objPreparedStatement.setInt(2, objBeanHoraVuelo.getCodigoAeronave());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                dato = objResultSet.getString("IMPORTE");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCosteoAeronaveHVEntidades(objBeanHoraVuelo) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PROG_COSTEO_AERONAVE");
            objBnMsgerr.setTipo(objBeanHoraVuelo.getMode().toUpperCase());
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
        return dato;
    }

    @Override
    public int iduHoraVueloCNV(BeanHoraVuelo objBeanHoraVuelo, String usuario) {
        sql = "{CALL SP_INS_HORA_VUELO_CNV(?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanHoraVuelo.getPeriodo());
            cs.setInt(2, objBeanHoraVuelo.getCodigoProgramacion());
            cs.setString(3, objBeanHoraVuelo.getTarea());
            cs.setString(4, objBeanHoraVuelo.getTipoAeronave());
            cs.setString(5, objBeanHoraVuelo.getAeronave());
            cs.setString(6, objBeanHoraVuelo.getPlacaAeronave());
            cs.setInt(7, objBeanHoraVuelo.getCantidad());
            cs.setInt(8, objBeanHoraVuelo.getCodigoAeronave());
            cs.setString(9, usuario);
            cs.setString(10, objBeanHoraVuelo.getMode().toUpperCase());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduHoraVueloCNV : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_HORAS_VUELO_CNV");
            objBnMsgerr.setTipo(objBeanHoraVuelo.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduCosteoHoraVuelo : " + e.toString());
            }
        }
        return s;
    }

    @Override
    public String getCodigoHoraVueloCNV(BeanHoraVuelo objBeanHoraVuelo, String usuario) {
        String codigo = "0";

        sql = "SELECT NVL(MAX(NCORRELATIVO_CODIGO+1),'1') AS CODIGO "
                + "FROM SIPE_HORAS_VUELO_CNV WHERE "
                + "CPERIODO_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);

            objPreparedStatement.setString(1, objBeanHoraVuelo.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                codigo = objResultSet.getString("CODIGO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCodigoHoraVueloCNV(objBeanHoraVuelo) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_HORAS_VUELO_CNV");
            objBnMsgerr.setTipo(objBeanHoraVuelo.getMode().toUpperCase());
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

}
