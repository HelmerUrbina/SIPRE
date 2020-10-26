/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanComun;
import DataService.Despachadores.TextoDAO;
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
public class TextoDAOImpl implements TextoDAO {

    private final Connection objConnection;
    private ResultSet objResultSet;
    private PreparedStatement objPreparedStatement;
    private String sql;
    private List lista;
    private BeanComun comun;
    private String result = "";

    public TextoDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getItem(String busqueda) {
        lista = new LinkedList<>();
        /*
         * OBTENEMOS LOS DATOS DEL TIPO DE CALENDARIO ASIGNADOS A LA UNIDAD OPERATIVA
         * Y LO ALMACENAMOS EN UNA LISTA
         */
        sql = "SELECT CCATALOGO_COD AS CODIGO, REPLACE(REGEXP_REPLACE(UPPER(VCATALOGO_NOMBRE),'''',''),'\n"
                + "', ' ') AS DESCRIPCION "
                + "FROM SIPE_VLOG_CATALOGO_OPRE WHERE "
                + "UPPER(VCATALOGO_NOMBRE) LIKE '" + busqueda.toUpperCase() + "%' "
                + "ORDER BY 2";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                comun = new BeanComun();
                comun.setCodigo(objResultSet.getString("CODIGO"));
                comun.setDescripcion(objResultSet.getString("DESCRIPCION"));
                lista.add(comun);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getItem(" + busqueda + ") " + e.getMessage());
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
    public String getCategoriaPresupuesta(String codigo) {
        sql = "SELECT VCATEGORIA_PRESUPUESTAL_NOMBRE AS DESCRIPCION "
                + "FROM SIPRE_CATEGORIA_PRESUPUESTAL WHERE "
                + "TO_NUMBER(CCATEGORIA_PRESUPUESTAL_CODIGO)=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, codigo);
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("DESCRIPCION");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getCategoriaPresupuesta(" + codigo + ") " + e.getMessage());
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
    public String getProducto(String codigo) {
        sql = "SELECT VPRODUCTO_NOMBRE AS DESCRIPCION "
                + "FROM SIPRE_PRODUCTO WHERE "
                + "CPRODUCTO_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, codigo);
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("DESCRIPCION");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getProducto(" + codigo + ") " + e.getMessage());
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
    public String getActividad(String codigo) {
        sql = "SELECT VACTIVIDAD_NOMBRE AS DESCRIPCION "
                + "FROM SIPRE_ACTIVIDAD WHERE "
                + "CACTIVIDAD_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, codigo);
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("DESCRIPCION");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getActividad(codigo) " + e.getMessage());
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
    public String getFuncion(String codigo) {
        sql = "SELECT DESFUN AS DESCRIPCION "
                + "FROM TABFUN WHERE "
                + "CODFUN=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, codigo);
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("DESCRIPCION");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getFuncion(codigo) " + e.getMessage());
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
    public String getDivisionFuncional(String codigo) {
        sql = "SELECT DESPRG AS DESCRIPCION "
                + "FROM TABPRG WHERE "
                + "CODPRG=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, codigo);
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("DESCRIPCION");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getDivisionFuncional(codigo) " + e.getMessage());
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
    public String getGrupoFuncional(String codigo) {
        sql = "SELECT DESPRG AS DESCRIPCION "
                + "FROM TASPRG WHERE "
                + "COSPRG=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, codigo);
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getString("DESCRIPCION");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getGrupoFuncional(codigo) " + e.getMessage());
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

    //MESA DE PARTES
    @Override
    public List getInstitucion(String busqueda) {
        lista = new LinkedList<>();
        sql = "SELECT CINSTITUCION_CODIGO AS CODIGO, VINSTITUCION_ABREVIATURA||'-'||VINSTITUCION_DESCRIPCION AS DESCRIPCION "
                + "FROM SIPE_INSTITUCION WHERE "
                + "CORGANISMO_CODIGO = '01' AND "
                + "UPPER(VINSTITUCION_ABREVIATURA) LIKE '%" + busqueda.toUpperCase() + "%' OR "
                + "UPPER(VINSTITUCION_DESCRIPCION) LIKE '%" + busqueda.toUpperCase() + "%' "
                + "ORDER BY DESCRIPCION ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                comun = new BeanComun();
                comun.setCodigo(objResultSet.getString("CODIGO"));
                comun.setDescripcion(objResultSet.getString("DESCRIPCION"));
                lista.add(comun);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getInstitucion(busqueda) " + e.getMessage());
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

    //EJECUCION PRESUPUESTAL
    @Override
    public String getMensualizarNotaModificatoria(String periodo, String presupuesto, String unidadOperativa, String resolucion,
            String tipoCalendario, String dependencia, String secuenciaFuncional, String tarea, String cadenaGasto) {
        String add = "";
        if (Integer.parseInt(periodo) > 2012) {
            add = " NCODIGO_RESOLUCION=" + resolucion + " AND ";
        }
        sql = "SELECT SUM(CASE MESPER WHEN '01' THEN IMPORT ELSE 0 END ) AS ENERO, "
                + "SUM(CASE MESPER WHEN '02' THEN IMPORT ELSE 0 END ) AS FEBRERO,"
                + "SUM(CASE MESPER WHEN '03' THEN IMPORT ELSE 0 END ) AS MARZO,"
                + "SUM(CASE MESPER WHEN '04' THEN IMPORT ELSE 0 END ) AS ABRIL,"
                + "SUM(CASE MESPER WHEN '05' THEN IMPORT ELSE 0 END ) AS MAYO,"
                + "SUM(CASE MESPER WHEN '06' THEN IMPORT ELSE 0 END ) AS JUNIO,"
                + "SUM(CASE MESPER WHEN '07' THEN IMPORT ELSE 0 END ) AS JULIO,"
                + "SUM(CASE MESPER WHEN '08' THEN IMPORT ELSE 0 END ) AS AGOSTO,"
                + "SUM(CASE MESPER WHEN '09' THEN IMPORT ELSE 0 END ) AS SETIEMBRE,"
                + "SUM(CASE MESPER WHEN '10' THEN IMPORT ELSE 0 END ) AS OCTUBRE,"
                + "SUM(CASE MESPER WHEN '11' THEN IMPORT ELSE 0 END ) AS NOVIEMBRE,"
                + "SUM(CASE MESPER WHEN '12' THEN IMPORT ELSE 0 END ) AS DICIEMBRE "
                + "FROM MODEPA WHERE "
                + "CODPER=? AND "
                + "COPPTO=? AND "
                + "COUUOO=? AND "
                + add
                + "CODDEP=? AND "
                + "TRIM(TIPPAU)=? AND "
                + "SECFUN=? AND "
                + "COMEOP=? AND "
                + "COCAGA=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, periodo);
            objPreparedStatement.setString(2, presupuesto);
            objPreparedStatement.setString(3, unidadOperativa);
            objPreparedStatement.setString(4, dependencia);
            objPreparedStatement.setString(5, tipoCalendario);
            objPreparedStatement.setString(6, secuenciaFuncional);
            objPreparedStatement.setString(7, tarea);
            objPreparedStatement.setString(8, cadenaGasto);
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                result = objResultSet.getDouble("ENERO") + "+++"
                        + objResultSet.getDouble("FEBRERO") + "+++"
                        + objResultSet.getDouble("MARZO") + "+++"
                        + objResultSet.getDouble("ABRIL") + "+++"
                        + objResultSet.getDouble("MAYO") + "+++"
                        + objResultSet.getDouble("JUNIO") + "+++"
                        + objResultSet.getDouble("JULIO") + "+++"
                        + objResultSet.getDouble("AGOSTO") + "+++"
                        + objResultSet.getDouble("SETIEMBRE") + "+++"
                        + objResultSet.getDouble("OCTUBRE") + "+++"
                        + objResultSet.getDouble("NOVIEMBRE") + "+++"
                        + objResultSet.getDouble("DICIEMBRE");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getMensualizarNotaModificatoria(" + periodo + ", " + presupuesto + ", "
                    + unidadOperativa + ", " + resolucion + ", " + dependencia + ", " + tipoCalendario + ", "
                    + secuenciaFuncional + ", " + tarea + ", " + cadenaGasto + ")" + e.getMessage());
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
}
