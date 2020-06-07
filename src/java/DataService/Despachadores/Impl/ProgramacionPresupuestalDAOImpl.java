/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanProgramacionPresupuestal;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.ProgramacionPresupuestalDAO;
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
public class ProgramacionPresupuestalDAOImpl implements ProgramacionPresupuestalDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanProgramacionPresupuestal objBnProgramacion;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public ProgramacionPresupuestalDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaProgramacion(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT TRIM(COMEOP||'-'||TRIM(TIPPAU)) AS CODIGO, COMEOP||'-'||UTIL_NEW.FUN_NTAREA(COMEOP) AS TAREA, "
                + "UTIL_NEW.FUN_CODIGO_COCAFU3_PRG(CODPER, COPPTO, SECFUN)||' '||UTIL_NEW.FUN_CODIGO_COCAFU_PROG(CODPER, COPPTO, SECFUN) AS CADENA_FUNCIONAL, "
                + "MOASAN AS PROGRAMADO, OPRE_NEW.FUN_IMPORTE_DETALLE_DEPAIN(CODPER, COUUOO, COPPTO, TIPPAU, COGEGA, SECFUN, COMEOP) AS IMPORTE_DETALLE, "
                + "CASE ESTADO WHEN 'CE' THEN 'CERRADO' ELSE 'ACTIVO' END AS ESTADO, UTIL_NEW.FUN_NOMGEN(COGEGA) AS GENERICA, "
                + "UTIL_NEW.FUN_NOUNME_TAPAIN(COMEOP) AS UNIDAD_MEDIDA, UTIL_NEW.FUN_DESTIP(TRIM(TIPPAU), COPPTO) AS TIPO_CALENDARIO "
                + "FROM TAPAIN WHERE "
                + "CODPER=? AND "
                + "COUUOO=? AND "
                + "COPPTO=? "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setString(2, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanProgramacion.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnProgramacion = new BeanProgramacionPresupuestal();
                objBnProgramacion.setCodigo(objResultSet.getString("CODIGO"));
                objBnProgramacion.setTarea(objResultSet.getString("TAREA"));
                objBnProgramacion.setCadenaFuncional(objResultSet.getString("CADENA_FUNCIONAL"));
                objBnProgramacion.setProgramado(objResultSet.getDouble("PROGRAMADO"));
                objBnProgramacion.setImporte(objResultSet.getDouble("IMPORTE_DETALLE"));
                objBnProgramacion.setEstado(objResultSet.getString("ESTADO"));
                objBnProgramacion.setGenericaGasto(objResultSet.getString("GENERICA"));
                objBnProgramacion.setUnidadMedida(objResultSet.getString("UNIDAD_MEDIDA"));
                objBnProgramacion.setTipoCalendario(objResultSet.getString("TIPO_CALENDARIO"));
                lista.add(objBnProgramacion);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsultaProgramacion(objBeanProgramacion) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPAIN");
            objBnMsgerr.setTipo(objBeanProgramacion.getMode().toUpperCase());
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
    public List getListaProgramacionDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        lista = new LinkedList<>();
        if (Utiles.Utiles.checkNum(objBeanProgramacion.getPeriodo()) > 2017) {
            sql = "SELECT TRIM(COMEOP||'-'||TRIM(2)) AS TAREA, '' CODIGO, "
                    + "UTIL_NEW.FUN_ABRDEP(COUUOO, CODDEP) AS ABRDEP, "
                    + "COCAGA||'-'||UTIL_NEW.FUN_NOMBRE_CADENA_GASTO(COCAGA) AS CADENA_GASTO, "
                    + "CEIL(SUM(PREVTA*CANREQ)) AS MONASI, "
                    + "0 AS ENERO, 0 AS FEBRERO, 0 AS MARZO, 0 AS ABRIL, 0 AS MAYO, "
                    + "0 AS JUNIO,0 AS JULIO, 0 AS AGOSTO, 0 AS SETIEMBRE, 0 AS OCTUBRE, "
                    + "0 AS NOVIEMBRE, 0 AS DICIEMBRE "
                    + "FROM TAHOTR WHERE "
                    + "CODPER=? AND "
                    + "COUUOO=? AND "
                    + "COPPTO=? "
                    + "GROUP BY COUUOO, CODDEP, COMEOP, COCAGA "
                    + "ORDER BY ABRDEP, COCAGA ";
        } else {
            sql = "SELECT TRIM(COMEOP||'-'||TRIM(TIPPAU)) AS TAREA, CODIGO, ABRDEP, COCAGA||'-'||NOCAGA AS CADENA_GASTO, "
                    + "SUM(ENERO+FEBRERO+MARZO+ABRIL+MAYO+JUNIO+JULIO+AGOSTO+SETIEMBRE+OCTUBRE+NOVIEMBRE+DICIEMBRE) AS MONASI, "
                    + "SUM(ENERO) AS ENERO, SUM(FEBRERO) AS FEBRERO, SUM(MARZO) AS MARZO, SUM(ABRIL) AS ABRIL, SUM(MAYO) AS MAYO, "
                    + "SUM(JUNIO) AS JUNIO, SUM(JULIO) AS JULIO, SUM(AGOSTO) AS AGOSTO, SUM(SETIEMBRE) AS SETIEMBRE, SUM(OCTUBRE) AS OCTUBRE, "
                    + "SUM(NOVIEMBRE) AS NOVIEMBRE, SUM(DICIEMBRE) AS DICIEMBRE "
                    + "FROM V_DEPAIN_NEW WHERE "
                    + "CODPER=? AND "
                    + "COUUOO=? AND "
                    + "COPPTO=? "
                    + "GROUP BY COMEOP||'-'||TRIM(TIPPAU), CODIGO, COCAGA, ABRDEP, NOCAGA "
                    + "ORDER BY ABRDEP, COCAGA ";
        }
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setString(2, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setInt(3, objBeanProgramacion.getPresupuesto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnProgramacion = new BeanProgramacionPresupuestal();
                objBnProgramacion.setTarea(objResultSet.getString("TAREA"));
                objBnProgramacion.setCodigo(objResultSet.getString("CODIGO"));
                objBnProgramacion.setDependencia(objResultSet.getString("ABRDEP"));
                objBnProgramacion.setCadenaGasto(objResultSet.getString("CADENA_GASTO"));
                objBnProgramacion.setImporte(objResultSet.getDouble("MONASI"));
                objBnProgramacion.setEnero(objResultSet.getDouble("ENERO"));
                objBnProgramacion.setFebrero(objResultSet.getDouble("FEBRERO"));
                objBnProgramacion.setMarzo(objResultSet.getDouble("MARZO"));
                objBnProgramacion.setAbril(objResultSet.getDouble("ABRIL"));
                objBnProgramacion.setMayo(objResultSet.getDouble("MAYO"));
                objBnProgramacion.setJunio(objResultSet.getDouble("JUNIO"));
                objBnProgramacion.setJulio(objResultSet.getDouble("JULIO"));
                objBnProgramacion.setAgosto(objResultSet.getDouble("AGOSTO"));
                objBnProgramacion.setSetiembre(objResultSet.getDouble("SETIEMBRE"));
                objBnProgramacion.setOctubre(objResultSet.getDouble("OCTUBRE"));
                objBnProgramacion.setNoviembre(objResultSet.getDouble("NOVIEMBRE"));
                objBnProgramacion.setDiciembre(objResultSet.getDouble("DICIEMBRE"));
                lista.add(objBnProgramacion);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaProgramacionDetalle(objBeanProgramacion) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPAIN");
            objBnMsgerr.setTipo(objBeanProgramacion.getMode().toUpperCase());
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
    public BeanProgramacionPresupuestal getProgramado(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        sql = "SELECT SECFUN, TIPPAU, MOASAN, COGEGA, CUNIDAD_MEDIDA_CODIGO "
                + "FROM TAPAIN WHERE "
                + "CODPER=? AND "
                + "COPPTO=? AND "
                + "COUUOO=? AND  "
                + "COMEOP||'-'||TRIM(TIPPAU)=?  ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setInt(2, objBeanProgramacion.getPresupuesto());
            objPreparedStatement.setString(3, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setString(4, objBeanProgramacion.getCodigo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanProgramacion.setCadenaFuncional(objResultSet.getString("SECFUN"));
                objBeanProgramacion.setTipoCalendario(objResultSet.getString("TIPPAU"));
                objBeanProgramacion.setImporte(objResultSet.getDouble("MOASAN"));
                objBeanProgramacion.setGenericaGasto(objResultSet.getString("COGEGA"));
                objBeanProgramacion.setUnidadMedida(objResultSet.getString("CUNIDAD_MEDIDA_CODIGO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getProgramado(objBeanProgramacion) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPAIN");
            objBnMsgerr.setTipo(objBeanProgramacion.getMode().toUpperCase());
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
        return objBeanProgramacion;
    }

    @Override
    public BeanProgramacionPresupuestal getProgramadoDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public Double getSaldoProgramacion(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public Double getSaldoEnteGenerador(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        Double saldo = 0.0;
        sql = "SELECT SUM(UTILIDAD-IMPORTE) AS SALDO FROM (SELECT "
                + "ROUND(SUM((CASE EI.CTIPO_AFECTACION WHEN 'A' THEN DE.NIMPORTE_RECAUDACION-(DE.NIMPORTE_RECAUDACION)*SD_PFE.FUN_IGV('2017')-DE.NIMPORTE_COSTO_OPERATIVO ELSE "
                + "DE.NIMPORTE_RECAUDACION-DE.NIMPORTE_COSTO_OPERATIVO END) *(EI.NPORCENTAJE_RDR_UO/100))) AS UTILIDAD, 0 AS IMPORTE "
                + "FROM SIPE_ENTE_GENERADOR EG INNER JOIN SIPE_ENTE_GENERADOR_DET DE ON ("
                + "EG.CPERIODO_CODIGO=DE.CPERIODO_CODIGO AND EG.NPRESUPUESTO_CODIGO=DE.NPRESUPUESTO_CODIGO AND "
                + "EG.CUNIDAD_OPERATIVA_CODIGO=DE.CUNIDAD_OPERATIVA_CODIGO AND EG.NCOD_ENTE_GENERADOR=DE.NCOD_ENTE_GENERADOR) LEFT OUTER JOIN SIPE_ESTIMACION_INGRESOS EI ON ("
                + "EG.CPERIODO_CODIGO=EI.CPERIODO_CODIGO AND EG.NPRESUPUESTO_CODIGO=EI.NPRESUPUESTO_CODIGO AND EG.NESTIMACION_INGRESO_CODIGO=EI.NESTIMACION_INGRESO_CODIGO) WHERE "
                + "EG.CPERIODO_CODIGO=? AND "
                + "EG.NPRESUPUESTO_CODIGO=? AND "
                + "EG.CUNIDAD_OPERATIVA_CODIGO=? AND "
                + "EG.CENTE_GENERADOR_ESTADO='GE' "
                + "UNION "
                + "SELECT 0 AS UTILIDAD, "
                + "NVL(SUM(MOASAN),0) AS IMPORTE "
                + "FROM TAPAIN WHERE "
                + "CODPER=? AND "
                + "COPPTO=? AND "
                + "COUUOO=? AND "
                + "COMEOP NOT IN ('0001'))";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setInt(2, objBeanProgramacion.getPresupuesto());
            objPreparedStatement.setString(3, objBeanProgramacion.getUnidadOperativa());
            objPreparedStatement.setString(4, objBeanProgramacion.getPeriodo());
            objPreparedStatement.setInt(5, objBeanProgramacion.getPresupuesto());
            objPreparedStatement.setString(6, objBeanProgramacion.getUnidadOperativa());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                saldo = objResultSet.getDouble("SALDO");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getSaldoEnteGenerador(objBeanProgramacion) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPAIN");
            objBnMsgerr.setTipo(objBeanProgramacion.getMode().toUpperCase());
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
        return saldo;

    }

    @Override
    public int iduProgramacion(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LA TABLA TAPAIN, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA,
         * EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_TAPAIN(?,?,?,?,?,?,?,?,?,?,?)}";
        try {
            CallableStatement cs = objConnection.prepareCall(sql);
            cs.setString(1, objBeanProgramacion.getPeriodo());
            cs.setString(2, objBeanProgramacion.getUnidadOperativa());
            cs.setInt(3, objBeanProgramacion.getPresupuesto());
            cs.setString(4, objBeanProgramacion.getTarea());
            cs.setString(5, objBeanProgramacion.getCadenaFuncional());
            cs.setString(6, objBeanProgramacion.getTipoCalendario());
            cs.setDouble(7, objBeanProgramacion.getImporte());
            cs.setString(8, objBeanProgramacion.getGenericaGasto());
            cs.setString(9, objBeanProgramacion.getUnidadMedida());
            cs.setString(10, usuario);
            cs.setString(11, objBeanProgramacion.getMode());
            objResultSet = cs.executeQuery();
            s++;
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduProgramacion : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TAPAIN");
            objBnMsgerr.setTipo(objBeanProgramacion.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println(e.toString());
            }
        }
        return s;
    }

    @Override
    public int iduProgramacionDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

}
