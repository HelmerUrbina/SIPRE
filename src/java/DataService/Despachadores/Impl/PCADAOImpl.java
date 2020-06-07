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
                + "CUNIDAD_OPERATIVA_CODIGO=? "
                + "GROUP BY CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO, "
                + "CTAREA_CODIGO, CADENA_GASTO, NRESOLUCION_CODIGO "
                + "ORDER BY NRESOLUCION_CODIGO, CDEPENDENCIA_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO, CTAREA_CODIGO, CADENA_GASTO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPCA.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPCA.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPCA.getUnidadOperativa());
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
                    objPreparedStatement.close();
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        return lista;
    }

    @Override
    public ArrayList getListaPCAVAriacion(BeanPCA objBeanPCA, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT NRESOLUCION_CODIGO||'-'||CDEPENDENCIA_CODIGO||'-'||CSECUENCIA_FUNCIONAL_CODIGO||'-'||CTAREA_CODIGO||'-'||CADENA_GASTO AS CODIGO, "
                + "UTIL_NEW.FUN_ABRDEP(CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "UTIL.FUN_DESCRIPCION_RESOLUCION(CPERIODO_CODIGO, NRESOLUCION_CODIGO) AS RESOLUCION, "
                + "CSECUENCIA_FUNCIONAL_CODIGO||':'||UTIL_NEW.FUN_DESMET(CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) SECUENCIA_FUNCIONAL, "
                + "CTAREA_CODIGO||':'||UTIL_NEW.FUN_NOMEOP(CTAREA_CODIGO) TAREA, "
                + "CADENA_GASTO||':'||UTIL.FUN_NOMBRE_CADGAS(CADENA_GASTO) CADENA_GASTO, "
                + "SUM(PIM) AS PIM, SUM(PCA) AS PCA, (-1)*(SUM(PCA)-(SUM(CERTIFICADO)+SUM(SOLICITUD)+SUM(NOTA))) AS DISPONIBLE "
                + "FROM V_PIM_PCA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? "
                + "GROUP BY CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO, "
                + "CSECUENCIA_FUNCIONAL_CODIGO,  CTAREA_CODIGO, CADENA_GASTO, NRESOLUCION_CODIGO "
                + "HAVING SUM(PCA)-(SUM(CERTIFICADO)+SUM(SOLICITUD)+SUM(NOTA))!=0 "
                + "UNION ALL "
                + "SELECT NRESOLUCION_CODIGO||'-'||CDEPENDENCIA_CODIGO||'-'||CSECUENCIA_FUNCIONAL_CODIGO||'-'||CTAREA_CODIGO||'-'||CADENA_GASTO AS CODIGO, "
                + "UTIL_NEW.FUN_ABRDEP(CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO) AS DEPENDENCIA, "
                + "UTIL.FUN_DESCRIPCION_RESOLUCION(CPERIODO_CODIGO, NRESOLUCION_CODIGO) AS RESOLUCION, "
                + "CSECUENCIA_FUNCIONAL_CODIGO||':'||UTIL_NEW.FUN_DESMET(CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CSECUENCIA_FUNCIONAL_CODIGO) SECUENCIA_FUNCIONAL,"
                + "CTAREA_CODIGO||':'||UTIL_NEW.FUN_NOMEOP(CTAREA_CODIGO) TAREA, "
                + "CADENA_GASTO||':'||UTIL.FUN_NOMBRE_CADGAS(CADENA_GASTO) CADENA_GASTO, "
                + "SUM(PIM) AS PIM, SUM(PCA) AS PCA, SUM(PIM)-(SUM(PCA)) AS DISPONIBLE "
                + "FROM V_PIM_PCA WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NPRESUPUESTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? "
                + "GROUP BY CPERIODO_CODIGO, NPRESUPUESTO_CODIGO, CUNIDAD_OPERATIVA_CODIGO, CDEPENDENCIA_CODIGO, "
                + "CSECUENCIA_FUNCIONAL_CODIGO, CTAREA_CODIGO, CADENA_GASTO, NRESOLUCION_CODIGO "
                + "HAVING SUM(PCA)-(SUM(PIM))<0";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPCA.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPCA.getPresupuesto());
            objPreparedStatement.setString(3, objBeanPCA.getUnidadOperativa());
            objPreparedStatement.setString(4, objBeanPCA.getPeriodo());
            objPreparedStatement.setInt(5, objBeanPCA.getPresupuesto());
            objPreparedStatement.setString(6, objBeanPCA.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("DEPENDENCIA") + "+++"
                        + objResultSet.getString("RESOLUCION") + "+++"
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
    public BeanPCA getPCAMensualizar(BeanPCA objBeanPCA, String usuario) {
        sql = "SELECT UTIL_NEW.FUN_DESC_TIPO_PROCESO(CTIPO_PROCESO_CODIGO)||'-'||VPAAC_NUMERO_PROCESO AS PROCESO, "
                + "NPAAC_VALOR_REFERENCIAL, "
                + "NPAAC_ENERO, NPAAC_FEBRERO, NPAAC_MARZO, NPAAC_ABRIL, NPAAC_MAYO, NPAAC_JUNIO, NPAAC_JULIO, "
                + "NPAAC_AGOSTO, NPAAC_SETIEMBRE, NPAAC_OCTUBRE, NPAAC_NOVIEMBRE, NPAAC_DICIEMBRE "
                + "FROM SIPE_PAAC WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "NPAAC_CODIGO=?";
        /*try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPCA.getPeriodo());
            objPreparedStatement.setString(2, objBeanPCA.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanPCA.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanPCA.setTipo(objResultSet.getString("PROCESO"));
                objBeanPCA.setValorReferencial(objResultSet.getDouble("NPAAC_VALOR_REFERENCIAL"));
                objBeanPCA.setEnero(objResultSet.getDouble("NPAAC_ENERO"));
                objBeanPCA.setFebrero(objResultSet.getDouble("NPAAC_FEBRERO"));
                objBeanPCA.setMarzo(objResultSet.getDouble("NPAAC_MARZO"));
                objBeanPCA.setAbril(objResultSet.getDouble("NPAAC_ABRIL"));
                objBeanPCA.setMayo(objResultSet.getDouble("NPAAC_MAYO"));
                objBeanPCA.setJunio(objResultSet.getDouble("NPAAC_JUNIO"));
                objBeanPCA.setJulio(objResultSet.getDouble("NPAAC_JULIO"));
                objBeanPCA.setAgosto(objResultSet.getDouble("NPAAC_AGOSTO"));
                objBeanPCA.setSetiembre(objResultSet.getDouble("NPAAC_SETIEMBRE"));
                objBeanPCA.setOctubre(objResultSet.getDouble("NPAAC_OCTUBRE"));
                objBeanPCA.setNoviembre(objResultSet.getDouble("NPAAC_NOVIEMBRE"));
                objBeanPCA.setDiciembre(objResultSet.getDouble("NPAAC_DICIEMBRE"));
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
        }*/
        return objBeanPCA;
    }

    @Override
    public int iduPCA(BeanPCA objBeanEvento, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
 /* sql = "{CALL  SP_IDU_PAAC(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
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
        }*/
        return s;
    }
}
