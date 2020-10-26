/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPCA;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PCADAO;
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
public class PCADAOImpl implements PCADAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPCA objBnPCA;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public PCADAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaPCA(BeanPCA objBeanPCA, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT "
                + "CDEPENDENCIA_CODIGO||':'||UTIL_NEW.FUN_ABRDEP(CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "UTIL.FUN_DESCRIPCION_RESOLUCION(CPERIODO_CODIGO, NRESOLUCION_CODIGO) AS RESOLUCION, "
                + "UTIL_NEW.FUN_PROGRAMA_SECFUN(CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) CATEGORIA_PRESUPUESTAL, "
                + "UTIL_NEW.FUN_PRODUCTO_SECFUN(CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) PRODUCTO, "
                + "UTIL_NEW.FUN_ACTIVIDAD_SECFUN(CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) ACTIVIDAD, "
                + "CSECUENCIA_FUNCIONAL_CODIGO||':'||UTIL_NEW.FUN_DESMET(CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) SECUENCIA_FUNCIONAL, "
                + "CTAREA_CODIGO||':'||UTIL_NEW.FUN_NOMEOP(CTAREA_CODIGO) TAREA, "
                + "CADENA_GASTO||':'||UTIL.FUN_NOMBRE_CADGAS(CADENA_GASTO) CADENA_GASTO, "
                + "UTIL_NEW.FUN_NOMBRE_GENERICA_COCAGA(CADENA_GASTO) AS GENERICA_GASTO, "
                + "SUM(PIA) AS PIA, SUM(PIM) AS PIM, SUM(PCA) AS PCA, "
                + "SUM(CERTIFICADO) AS CERTIFICADO, SUM(SOLICITUD) AS SOLICITUD, SUM(NOTA) AS NOTA, "
                + "SUM(PCA)-(SUM(CERTIFICADO)+SUM(SOLICITUD)+SUM(NOTA)) AS SALDO "
                + "FROM V_PIM_PCA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "TRIM(CGENERICA_GASTO_CODIGO)=? "
                + "GROUP BY CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO, "
                + "CTAREA_CODIGO, CADENA_GASTO, NRESOLUCION_CODIGO "
                + "HAVING (SUM(PIM)+SUM(PCA))>0 "
                + "ORDER BY NRESOLUCION_CODIGO, CDEPENDENCIA_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO, CTAREA_CODIGO, CADENA_GASTO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPCA.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPCA.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPCA.getUnidadOperativa());
            objPreparedStatement.setString(4, objBeanPCA.getGenericaGasto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnPCA = new BeanPCA();
                objBnPCA.setDependencia(objResultSet.getString("DEPENDENCIA"));
                objBnPCA.setResolucion(objResultSet.getString("RESOLUCION"));
                objBnPCA.setCategoriaPresupuestal(objResultSet.getString("CATEGORIA_PRESUPUESTAL"));
                objBnPCA.setProducto(objResultSet.getString("PRODUCTO"));
                objBnPCA.setActividad(objResultSet.getString("ACTIVIDAD"));
                objBnPCA.setSecuenciaFuncional(objResultSet.getString("SECUENCIA_FUNCIONAL"));
                objBnPCA.setTareaPresupuestal(objResultSet.getString("TAREA"));
                objBnPCA.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnPCA.setGenericaGasto(objResultSet.getString("GENERICA_GASTO"));
                objBnPCA.setPIA(objResultSet.getDouble("PIA"));
                objBnPCA.setPIM(objResultSet.getDouble("PIM"));
                objBnPCA.setPCA(objResultSet.getDouble("PCA"));
                objBnPCA.setCertificado(objResultSet.getDouble("CERTIFICADO"));
                objBnPCA.setSolicitud(objResultSet.getDouble("SOLICITUD"));
                objBnPCA.setNota(objResultSet.getDouble("NOTA"));
                objBnPCA.setSaldo(objResultSet.getDouble("SALDO"));
                lista.add(objBnPCA);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPCA(objBeanPCA) : " + e.getMessage());
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
    public ArrayList getListaPCAUnidadOperativa(BeanPCA objBeanPCA, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT NPCA_AUTORIZACION AS PCA_AUTORIZACION, UTIL_NEW.FUN_DESC_USUARIO(VUSUARIO_CODIGO) AS USUARIO, "
                + "TO_CHAR(DUSUARIO_FECHA,'DD/MM/YYYY') AS FECHA, "
                + "SUM(CASE WHEN NPCA_IMPORTE<0 THEN ABS(NPCA_IMPORTE) ELSE 0 END) AS ANULACION, "
                + "SUM(CASE WHEN NPCA_IMPORTE>0 THEN ABS(NPCA_IMPORTE) ELSE 0 END) AS CREDITO "
                + "FROM SIPRE_PCA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "SUBSTR(VCADENA_GASTO_CODIGO,3,1)=? AND "
                + "NPCA_AUTORIZACION IS NOT NULL "
                + "GROUP BY NPCA_AUTORIZACION, VUSUARIO_CODIGO, TO_CHAR(DUSUARIO_FECHA,'DD/MM/YYYY') "
                + "ORDER BY NPCA_AUTORIZACION";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPCA.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPCA.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPCA.getUnidadOperativa());
            objPreparedStatement.setString(4, objBeanPCA.getGenericaGasto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("PCA_AUTORIZACION") + "+++"
                        + objResultSet.getString("USUARIO") + "+++"
                        + objResultSet.getString("FECHA") + "+++"
                        + objResultSet.getString("ANULACION") + "+++"
                        + objResultSet.getString("CREDITO");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPCAUnidadOperativa(BeanPCA) : " + e.getMessage());
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
    public ArrayList getListaPCAVAriacion(BeanPCA objBeanPCA, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT NRESOLUCION_CODIGO||'---'||CDEPENDENCIA_CODIGO||'---'||TRIM(NTIPO_CALENDARIO_CODIGO)||'---'||CSECUENCIA_FUNCIONAL_CODIGO||'---'||CTAREA_CODIGO||'---'||CADENA_GASTO AS CODIGO, "
                + "UTIL_NEW.FUN_ABRDEP(CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "UTIL.FUN_DESCRIPCION_RESOLUCION(CPERIODO_CODIGO, NRESOLUCION_CODIGO) AS RESOLUCION, "
                + "TRIM(NTIPO_CALENDARIO_CODIGO)||':'||UTIL_NEW.FUN_DESTIP(TRIM(NTIPO_CALENDARIO_CODIGO), NPRESUPUESTO_CODIGO) AS TIPO_CALENDARIO, "
                + "CSECUENCIA_FUNCIONAL_CODIGO||':'||UTIL_NEW.FUN_DESMET(CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) SECUENCIA_FUNCIONAL, "
                + "CTAREA_CODIGO||':'||UTIL_NEW.FUN_NOMEOP(CTAREA_CODIGO) TAREA, "
                + "CADENA_GASTO||':'||UTIL.FUN_NOMBRE_CADGAS(CADENA_GASTO) CADENA_GASTO, "
                + "SUM(PIM) AS PIM, SUM(PCA) AS PCA, (-1)*(SUM(PCA)-(SUM(CERTIFICADO)+SUM(SOLICITUD)+SUM(NOTA))) AS DISPONIBLE "
                + "FROM V_PIM_PCA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "TRIM(CGENERICA_GASTO_CODIGO)=? "
                + "GROUP BY CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO, NTIPO_CALENDARIO_CODIGO, "
                + "CSECUENCIA_FUNCIONAL_CODIGO,  CTAREA_CODIGO, CADENA_GASTO, NRESOLUCION_CODIGO "
                + "HAVING SUM(PCA)-(SUM(CERTIFICADO)+SUM(SOLICITUD)+SUM(NOTA))>0 "
                + "UNION ALL "
                + "SELECT NRESOLUCION_CODIGO||'---'||CDEPENDENCIA_CODIGO||'---'||TRIM(NTIPO_CALENDARIO_CODIGO)||'---'||CSECUENCIA_FUNCIONAL_CODIGO||'---'||CTAREA_CODIGO||'---'||CADENA_GASTO AS CODIGO, "
                + "UTIL_NEW.FUN_ABRDEP(CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "UTIL.FUN_DESCRIPCION_RESOLUCION(CPERIODO_CODIGO, NRESOLUCION_CODIGO) AS RESOLUCION, "
                + "TRIM(NTIPO_CALENDARIO_CODIGO)||':'||UTIL_NEW.FUN_DESTIP(TRIM(NTIPO_CALENDARIO_CODIGO), NPRESUPUESTO_CODIGO) AS TIPO_CALENDARIO, "
                + "CSECUENCIA_FUNCIONAL_CODIGO||':'||UTIL_NEW.FUN_DESMET(CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) SECUENCIA_FUNCIONAL,"
                + "CTAREA_CODIGO||':'||UTIL_NEW.FUN_NOMEOP(CTAREA_CODIGO) TAREA, "
                + "CADENA_GASTO||':'||UTIL.FUN_NOMBRE_CADGAS(CADENA_GASTO) CADENA_GASTO, "
                + "SUM(PIM) AS PIM, SUM(PCA) AS PCA, SUM(PIM)-(SUM(PCA)) AS DISPONIBLE "
                + "FROM V_PIM_PCA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "TRIM(CGENERICA_GASTO_CODIGO)=?"
                + "GROUP BY CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO, NTIPO_CALENDARIO_CODIGO, "
                + "CSECUENCIA_FUNCIONAL_CODIGO, CTAREA_CODIGO, CADENA_GASTO, NRESOLUCION_CODIGO "
                + "HAVING SUM(PCA)-(SUM(PIM))<0 "
                + "ORDER BY 1";
        
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPCA.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPCA.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPCA.getUnidadOperativa());
            objPreparedStatement.setString(4, objBeanPCA.getGenericaGasto());
            objPreparedStatement.setString(5, objBeanPCA.getPeriodo());
            objPreparedStatement.setInt(6, objBeanPCA.getPresupuesto());
            objPreparedStatement.setString(7, objBeanPCA.getUnidadOperativa());
            objPreparedStatement.setString(8, objBeanPCA.getGenericaGasto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("DEPENDENCIA") + "+++"
                        + objResultSet.getString("RESOLUCION") + "+++"
                        + objResultSet.getString("TIPO_CALENDARIO") + "+++"
                        + objResultSet.getString("SECUENCIA_FUNCIONAL") + "+++"
                        + objResultSet.getString("TAREA") + "+++"
                        + objResultSet.getString("CADENA_GASTO") + "+++"
                        + objResultSet.getDouble("PIM") + "+++"
                        + objResultSet.getDouble("PCA") + "+++"
                        + objResultSet.getDouble("DISPONIBLE");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPCAVAriacion(BeanPCA) : " + e.getMessage());
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
    public Integer getAutorizacionPCA(BeanPCA objBeanPCA, String usuario) {
        Integer autorizacion = 0;
        sql = "SELECT NVL(MAX(NPCA_AUTORIZACION)+1,1) AS PCA_AUTORIZACION "
                + "FROM SIPRE_PCA WHERE "
                + "CPERIODO_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPCA.getPeriodo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                autorizacion = objResultSet.getInt("PCA_AUTORIZACION");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getAutorizacionPCA(objBeanPAAC) : " + e.getMessage());
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
        return autorizacion;
    }

    @Override
    public int iduPCA(BeanPCA objBeanPCA, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL  SP_IDU_PCA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanPCA.getPeriodo());
            cs.setInt(2, objBeanPCA.getPresupuesto());
            cs.setString(3, objBeanPCA.getUnidadOperativa());
            cs.setInt(4, objBeanPCA.getCodigo());
            cs.setString(5, objBeanPCA.getCategoriaPresupuestal());
            cs.setString(6, objBeanPCA.getTipo());
            cs.setString(7, objBeanPCA.getResolucion());
            cs.setString(8, objBeanPCA.getDependencia());
            cs.setString(9, objBeanPCA.getTipoCalendario());
            cs.setString(10, objBeanPCA.getSecuenciaFuncional());
            cs.setString(11, objBeanPCA.getTareaPresupuestal());
            cs.setString(12, objBeanPCA.getCadenaGasto());
            cs.setDouble(13, objBeanPCA.getPCA());
            cs.setString(14, usuario);
            cs.setString(15, objBeanPCA.getMode());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPAAC : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PCA");
            objBnMsgerr.setTipo(objBeanPCA.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }
}
