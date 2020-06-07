/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPersonalPresupuesto;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PersonalPresupuestoDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author hateccsiv
 */
public class PersonalPresupuestoDAOImpl implements PersonalPresupuestoDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPersonalPresupuesto objBnPersonalPresupuesto;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    @Override
    public List getConsultaPersonalPresupuesto(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NNIVEL_GRADO AS CODNIVEL,UTIL.FUN_DESCRIPCION_NIVEL_GRD(NNIVEL_GRADO) AS NIVEL,"
                + "CMETA_OPERATIVA_CODIGO||':'||UTIL_NEW.FUN_NTAREA(CMETA_OPERATIVA_CODIGO) AS TAREA,"
                + "VCADENA_GASTO_CODIGO||':'||UTIL_NEW.FUN_NOCLAS(VCADENA_GASTO_CODIGO) AS CADENAGASTO,"
                + "SUM(NCANTIDAD_EFECTIVO) AS CANTIDAD,"
                + "SUM(NIMPORTE_EFECTIVO) AS IMPORTE,"
                + "SUM(NTOTAL_EFECTIVO) AS TOTAL "
                + "FROM SIPE_PERSONAL_PRESUP_PRG "
                + "WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NCONCEPTO_CODIGO=? "
                + "GROUP BY NNIVEL_GRADO,CMETA_OPERATIVA_CODIGO,VCADENA_GASTO_CODIGO "
                + "ORDER BY NNIVEL_GRADO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPersonalPresupuesto.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPersonalPresupuesto.getCodConcepto());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnPersonalPresupuesto = new BeanPersonalPresupuesto();
                objBnPersonalPresupuesto.setNivelGrado(objResultSet.getInt("CODNIVEL"));
                objBnPersonalPresupuesto.setNivelDescripcion(objResultSet.getString("NIVEL"));
                objBnPersonalPresupuesto.setTarea(objResultSet.getString("TAREA"));
                objBnPersonalPresupuesto.setCadenaGasto(objResultSet.getString("CADENAGASTO"));
                objBnPersonalPresupuesto.setCantidad(objResultSet.getInt("CANTIDAD"));
                objBnPersonalPresupuesto.setImporte(objResultSet.getInt("IMPORTE"));
                objBnPersonalPresupuesto.setTotal(objResultSet.getDouble("TOTAL"));
                lista.add(objBnPersonalPresupuesto);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getConsultaPersonalPresupuesto(objBeanPersonalPresupuesto) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PERSONAL_PRESUP_PRG");
            objBnMsgerr.setTipo(objBeanPersonalPresupuesto.getMode().toUpperCase());
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
    public int iduPersonalPresupuesto(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario) {

        sql = "{CALL SP_IDU_PERSONAL_PRESUPUESTO(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanPersonalPresupuesto.getPeriodo());
            cs.setInt(2, objBeanPersonalPresupuesto.getCodConcepto());
            cs.setString(3, objBeanPersonalPresupuesto.getCadenaGasto());
            cs.setString(4, objBeanPersonalPresupuesto.getTarea());
            cs.setString(5, objBeanPersonalPresupuesto.getDepartamento());
            cs.setString(6, objBeanPersonalPresupuesto.getUnidad());
            cs.setString(7, objBeanPersonalPresupuesto.getCodGrd());
            cs.setString(8, objBeanPersonalPresupuesto.getPeriodoRee());
            cs.setInt(9, objBeanPersonalPresupuesto.getCantidad());
            cs.setDouble(10, objBeanPersonalPresupuesto.getImporte());
            cs.setInt(11, objBeanPersonalPresupuesto.getNivelGrado());
            cs.setString(12, usuario);
            cs.setString(13, objBeanPersonalPresupuesto.getMode());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPersonalPresupuesto : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PERSONAL_PRESUP_PRG");
            objBnMsgerr.setTipo(objBeanPersonalPresupuesto.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduHojaTrabajo : " + e.toString());
            }
        }
        return s;
    }

    public PersonalPresupuestoDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getconsultaPersonalPresupDet(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NNIVEL_GRADO AS CODNIVEL,CODGRD,"
                + "UTIL_NEW.FUN_NOMBRE_GRADO(CODGRD) AS GRADO,"
                + "UTIL.FUN_INGRESOS_PERS_GRADO(CPERIODO_CODIGO,NCONCEPTO_CODIGO,NNIVEL_GRADO,CODGRD) AS RENUMERACION,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '01' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS AMAZONAS,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '01' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_AMAZONAS,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '02' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS ANCASH,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '02' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_ANCASH,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '03' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS APURIMAC,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '03' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_APURIMAC,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '04' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS AREQUIPA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '04' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_AREQUIPA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '05' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS AYACUCHO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '05' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_AYACUCHO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '06' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS CAJAMARCA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '06' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_CAJAMARCA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '07' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS CALLAO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '07' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_CALLAO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '08' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS CUSCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '08' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_CUSCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '09' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS HUANCAVELICA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '09' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_HUANCAVELICA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '10' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS HUANUCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '10' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_HUANUCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '11' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS ICA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '11' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_ICA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '12' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS JUNIN,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '12' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_JUNIN,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '13' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS LIBERTAD,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '13' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_LIBERTAD,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '14' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS LAMBAYEQUE,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '14' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_LAMBAYEQUE,"                
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '15' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS LIMA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '15' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_LIMA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '16' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS LORETO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '16' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_LORETO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '17' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS MDDIOS,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '17' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_MDDIOS,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '18' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS MOQUEGUA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '18' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_MOQUEGUA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '19' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS PASCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '19' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_PASCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '20' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS PIURA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '20' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_PIURA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '21' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS PUNO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '21' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_PUNO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '22' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS SMARTIN,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '22' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_SMARTIN,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '23' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS TACNA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '23' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_TACNA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '24' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS TUMBES,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '24' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_TUMBES,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '25' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS UCAYALI,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '25' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_UCAYALI,"
                + "SUM(NCANTIDAD_EFECTIVO) AS TOTAL_EFECTIVO,"
                + "SUM(NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO) AS IMP_TOTAL "
                + "FROM SIPE_PERSONAL_PRESUP_PRG "
                + "WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NCONCEPTO_CODIGO=? AND "
                + "NNIVEL_GRADO=? "
                + "GROUP BY CPERIODO_CODIGO,NCONCEPTO_CODIGO,NNIVEL_GRADO,CODGRD "
                + "ORDER BY CODGRD";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPersonalPresupuesto.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPersonalPresupuesto.getCodConcepto());
            objPreparedStatement.setInt(3, objBeanPersonalPresupuesto.getNivelGrado());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnPersonalPresupuesto = new BeanPersonalPresupuesto();
                objBnPersonalPresupuesto.setNivelGrado(objResultSet.getInt("CODNIVEL"));
                objBnPersonalPresupuesto.setCodGrd(objResultSet.getString("CODGRD"));
                objBnPersonalPresupuesto.setGrado(objResultSet.getString("GRADO"));
                objBnPersonalPresupuesto.setImpRemuneracion(objResultSet.getDouble("RENUMERACION"));
                objBnPersonalPresupuesto.setAmazonas(objResultSet.getInt("AMAZONAS"));
                objBnPersonalPresupuesto.setImpAmazonas(objResultSet.getDouble("IMP_AMAZONAS"));
                objBnPersonalPresupuesto.setAncash(objResultSet.getInt("ANCASH"));
                objBnPersonalPresupuesto.setImpAncash(objResultSet.getDouble("IMP_ANCASH"));
                objBnPersonalPresupuesto.setApurimac(objResultSet.getInt("APURIMAC"));
                objBnPersonalPresupuesto.setImpApurimac(objResultSet.getDouble("IMP_APURIMAC"));
                objBnPersonalPresupuesto.setArequipa(objResultSet.getInt("AREQUIPA"));
                objBnPersonalPresupuesto.setImpArequipa(objResultSet.getDouble("IMP_AREQUIPA"));
                objBnPersonalPresupuesto.setAyacucho(objResultSet.getInt("AYACUCHO"));
                objBnPersonalPresupuesto.setImpAyacucho(objResultSet.getDouble("IMP_AYACUCHO"));
                objBnPersonalPresupuesto.setCajamarca(objResultSet.getInt("CAJAMARCA"));
                objBnPersonalPresupuesto.setImpCajamarca(objResultSet.getDouble("IMP_CAJAMARCA"));
                objBnPersonalPresupuesto.setCallao(objResultSet.getInt("CALLAO"));
                objBnPersonalPresupuesto.setImpCallao(objResultSet.getDouble("IMP_CALLAO"));
                objBnPersonalPresupuesto.setCusco(objResultSet.getInt("CUSCO"));
                objBnPersonalPresupuesto.setImpCusco(objResultSet.getDouble("IMP_CUSCO"));
                objBnPersonalPresupuesto.setHuancavelica(objResultSet.getInt("HUANCAVELICA"));
                objBnPersonalPresupuesto.setImpHuancavelica(objResultSet.getDouble("IMP_HUANCAVELICA"));
                objBnPersonalPresupuesto.setHuanuco(objResultSet.getInt("HUANUCO"));
                objBnPersonalPresupuesto.setImpHuanuco(objResultSet.getDouble("IMP_HUANUCO"));
                objBnPersonalPresupuesto.setIca(objResultSet.getInt("ICA"));
                objBnPersonalPresupuesto.setImpIca(objResultSet.getDouble("IMP_ICA"));
                objBnPersonalPresupuesto.setJunin(objResultSet.getInt("JUNIN"));
                objBnPersonalPresupuesto.setImpJunin(objResultSet.getDouble("IMP_JUNIN"));
                objBnPersonalPresupuesto.setLibertad(objResultSet.getInt("LIBERTAD"));
                objBnPersonalPresupuesto.setImpLibertad(objResultSet.getDouble("IMP_LIBERTAD"));
                objBnPersonalPresupuesto.setLambayeque(objResultSet.getInt("LAMBAYEQUE"));
                objBnPersonalPresupuesto.setImpLambayeque(objResultSet.getDouble("IMP_LAMBAYEQUE"));
                objBnPersonalPresupuesto.setLima(objResultSet.getInt("LIMA"));
                objBnPersonalPresupuesto.setImpLima(objResultSet.getDouble("IMP_LIMA"));
                objBnPersonalPresupuesto.setLoreto(objResultSet.getInt("LORETO"));
                objBnPersonalPresupuesto.setImpLoreto(objResultSet.getDouble("IMP_LORETO"));
                objBnPersonalPresupuesto.setMddios(objResultSet.getInt("MDDIOS"));
                objBnPersonalPresupuesto.setImpMddios(objResultSet.getDouble("IMP_MDDIOS"));
                objBnPersonalPresupuesto.setMoquegua(objResultSet.getInt("MOQUEGUA"));
                objBnPersonalPresupuesto.setImpMoquegua(objResultSet.getDouble("IMP_MOQUEGUA"));
                objBnPersonalPresupuesto.setPasco(objResultSet.getInt("PASCO"));
                objBnPersonalPresupuesto.setImpPasco(objResultSet.getDouble("IMP_PASCO"));
                objBnPersonalPresupuesto.setPiura(objResultSet.getInt("PIURA"));
                objBnPersonalPresupuesto.setImpPiura(objResultSet.getDouble("IMP_PIURA"));
                objBnPersonalPresupuesto.setPuno(objResultSet.getInt("PUNO"));
                objBnPersonalPresupuesto.setImpPuno(objResultSet.getDouble("IMP_PUNO"));
                objBnPersonalPresupuesto.setSmartin(objResultSet.getInt("SMARTIN"));
                objBnPersonalPresupuesto.setImpSmartin(objResultSet.getDouble("IMP_SMARTIN"));
                objBnPersonalPresupuesto.setTacna(objResultSet.getInt("TACNA"));
                objBnPersonalPresupuesto.setImpTacna(objResultSet.getDouble("IMP_TACNA"));
                objBnPersonalPresupuesto.setTumbes(objResultSet.getInt("TUMBES"));
                objBnPersonalPresupuesto.setImpTumbes(objResultSet.getDouble("IMP_TUMBES"));
                objBnPersonalPresupuesto.setUcayali(objResultSet.getInt("UCAYALI"));
                objBnPersonalPresupuesto.setImpUcayali(objResultSet.getDouble("IMP_UCAYALI"));
                
                objBnPersonalPresupuesto.setCantidad(objResultSet.getInt("TOTAL_EFECTIVO"));
                objBnPersonalPresupuesto.setTotal(objResultSet.getDouble("IMP_TOTAL"));
                lista.add(objBnPersonalPresupuesto);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getconsultaPersonalPresupDet(objBeanPersonalPresupuesto) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PERSONAL_PRESUP_PRG");
            objBnMsgerr.setTipo(objBeanPersonalPresupuesto.getMode().toUpperCase());
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
    public String getImporteGrado(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario) {
        String importe = "";
        sql = "SELECT NIMPORTE AS IMPORTE FROM SIPE_INGRESOS_PERSONAL_EP "
                + "WHERE "
                + "CODPER=? AND "
                + "NCONCEPTO_INGRESOS_COD=? AND "
                + "NNIVEL_GRADO_CODIGO=? AND "
                + "CODGRD=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPersonalPresupuesto.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPersonalPresupuesto.getCodConcepto());
            objPreparedStatement.setInt(3, objBeanPersonalPresupuesto.getNivelGrado());
            objPreparedStatement.setString(4, objBeanPersonalPresupuesto.getCodGrd());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                importe = objResultSet.getString("IMPORTE");
            } else {
                importe = "0";
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getImporteGrado(objBeanPersonalPresupuesto) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_INGRESOS_PERSONAL_EP");
            objBnMsgerr.setTipo(objBeanPersonalPresupuesto.getMode().toUpperCase());
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
        return importe;
    }

    @Override
    public String getVerificarDatos(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario) {
        String msg = "";
        int dato = 0;
        sql = "SELECT COUNT(*) AS VALOR FROM SIPE_PERSONAL_PRESUP_PRG "
                + "WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NCONCEPTO_CODIGO=? AND "
                + "NNIVEL_GRADO=? AND "
                + "CDEPARTAMENTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO||'.'||CDEPARTAMENTO_CODIGO=? AND "
                + "CODGRD=? AND "
                + "VCADENA_GASTO_CODIGO=? AND "
                + "CMETA_OPERATIVA_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPersonalPresupuesto.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPersonalPresupuesto.getCodConcepto());
            objPreparedStatement.setInt(3, objBeanPersonalPresupuesto.getNivelGrado());
            objPreparedStatement.setString(4, objBeanPersonalPresupuesto.getDepartamento());
            objPreparedStatement.setString(5, objBeanPersonalPresupuesto.getUnidad());
            objPreparedStatement.setString(6, objBeanPersonalPresupuesto.getCodGrd());
            objPreparedStatement.setString(7, objBeanPersonalPresupuesto.getCadenaGasto());
            objPreparedStatement.setString(8, objBeanPersonalPresupuesto.getTarea());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                dato = objResultSet.getInt("VALOR");
            }
            if (dato > 0) {
                msg = "EXISTE";
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getVerificarDatos(objBeanPersonalPresupuesto) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PERSONAL_PRESUP_PRG");
            objBnMsgerr.setTipo(objBeanPersonalPresupuesto.getMode().toUpperCase());
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
        return msg;
    }
    

    @Override
    public List getconsultaPersonalPresupDetREE(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CPERIODO_REE||':'||CODGRD AS CODIGO,"
                + "CASE WHEN CPERIODO_REE='P1' THEN '1er Periodo' "
                + "WHEN CPERIODO_REE='P2' THEN '2do Periodo' "
                + "WHEN CPERIODO_REE='P3' THEN '3er Periodo' "
                + "WHEN CPERIODO_REE='P4' THEN '4to Periodo' "
                + "WHEN CPERIODO_REE='P5' THEN '5to Periodo' ELSE '' END AS PERIODO, "
                + "CPERIODO_REE AS PERIODO_REE,"
                + "CODGRD,"
                + "UTIL_NEW.FUN_NOMBRE_GRADO(CODGRD) AS GRADO,"
                + "UTIL.FUN_INGRESOS_PERS_GRADO_REE(CPERIODO_CODIGO,NCONCEPTO_CODIGO,NNIVEL_GRADO,CODGRD,CPERIODO_REE) AS RENUMERACION,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '01' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS AMAZONAS,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '01' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_AMAZONAS,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '02' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS ANCASH,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '02' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_ANCASH,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '03' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS APURIMAC,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '03' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_APURIMAC,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '04' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS AREQUIPA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '04' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_AREQUIPA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '05' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS AYACUCHO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '05' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_AYACUCHO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '06' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS CAJAMARCA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '06' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_CAJAMARCA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '07' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS CALLAO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '07' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_CALLAO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '08' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS CUSCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '08' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_CUSCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '09' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS HUANCAVELICA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '09' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_HUANCAVELICA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '10' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS HUANUCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '10' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_HUANUCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '11' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS ICA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '11' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_ICA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '12' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS JUNIN,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '12' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_JUNIN,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '13' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS LIBERTAD,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '13' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_LIBERTAD,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '14' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS LAMBAYEQUE,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '14' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_LAMBAYEQUE,"                
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '15' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS LIMA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '15' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_LIMA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '16' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS LORETO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '16' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_LORETO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '17' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS MDDIOS,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '17' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_MDDIOS,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '18' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS MOQUEGUA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '18' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_MOQUEGUA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '19' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS PASCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '19' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_PASCO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '20' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS PIURA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '20' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_PIURA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '21' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS PUNO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '21' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_PUNO,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '22' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS SMARTIN,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '22' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_SMARTIN,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '23' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS TACNA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '23' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_TACNA,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '24' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS TUMBES,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '24' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_TUMBES,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '25' THEN NCANTIDAD_EFECTIVO ELSE 0 END) AS UCAYALI,"
                + "SUM(CASE CDEPARTAMENTO_CODIGO WHEN '25' THEN NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO ELSE 0 END) AS IMP_UCAYALI,"
                + "SUM(NCANTIDAD_EFECTIVO) AS TOTAL_EFECTIVO,"
                + "SUM(NCANTIDAD_EFECTIVO*NIMPORTE_EFECTIVO) AS IMP_TOTAL "
                + "FROM SIPE_PERSONAL_PRESUP_PRG "
                + "WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NCONCEPTO_CODIGO=? AND "
                + "NNIVEL_GRADO=? "
                + "GROUP BY CPERIODO_REE,CODGRD,NCONCEPTO_CODIGO,NNIVEL_GRADO "
                + "ORDER BY PERIODO_REE,CODGRD";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPersonalPresupuesto.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPersonalPresupuesto.getCodConcepto());
            objPreparedStatement.setInt(3, objBeanPersonalPresupuesto.getNivelGrado());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnPersonalPresupuesto = new BeanPersonalPresupuesto();
                objBnPersonalPresupuesto.setCodigo(objResultSet.getString("CODIGO"));
                objBnPersonalPresupuesto.setCodPeriodo(objResultSet.getString("PERIODO_REE"));
                objBnPersonalPresupuesto.setPeriodoRee(objResultSet.getString("PERIODO"));
                objBnPersonalPresupuesto.setCodGrd(objResultSet.getString("CODGRD"));
                objBnPersonalPresupuesto.setGrado(objResultSet.getString("GRADO"));
               objBnPersonalPresupuesto.setImpRemuneracion(objResultSet.getDouble("RENUMERACION"));
                objBnPersonalPresupuesto.setAmazonas(objResultSet.getInt("AMAZONAS"));
                objBnPersonalPresupuesto.setImpAmazonas(objResultSet.getDouble("IMP_AMAZONAS"));
                objBnPersonalPresupuesto.setAncash(objResultSet.getInt("ANCASH"));
                objBnPersonalPresupuesto.setImpAncash(objResultSet.getDouble("IMP_ANCASH"));
                objBnPersonalPresupuesto.setApurimac(objResultSet.getInt("APURIMAC"));
                objBnPersonalPresupuesto.setImpApurimac(objResultSet.getDouble("IMP_APURIMAC"));
                objBnPersonalPresupuesto.setArequipa(objResultSet.getInt("AREQUIPA"));
                objBnPersonalPresupuesto.setImpArequipa(objResultSet.getDouble("IMP_AREQUIPA"));
                objBnPersonalPresupuesto.setAyacucho(objResultSet.getInt("AYACUCHO"));
                objBnPersonalPresupuesto.setImpAyacucho(objResultSet.getDouble("IMP_AYACUCHO"));
                objBnPersonalPresupuesto.setCajamarca(objResultSet.getInt("CAJAMARCA"));
                objBnPersonalPresupuesto.setImpCajamarca(objResultSet.getDouble("IMP_CAJAMARCA"));
                objBnPersonalPresupuesto.setCallao(objResultSet.getInt("CALLAO"));
                objBnPersonalPresupuesto.setImpCallao(objResultSet.getDouble("IMP_CALLAO"));
                objBnPersonalPresupuesto.setCusco(objResultSet.getInt("CUSCO"));
                objBnPersonalPresupuesto.setImpCusco(objResultSet.getDouble("IMP_CUSCO"));
                objBnPersonalPresupuesto.setHuancavelica(objResultSet.getInt("HUANCAVELICA"));
                objBnPersonalPresupuesto.setImpHuancavelica(objResultSet.getDouble("IMP_HUANCAVELICA"));
                objBnPersonalPresupuesto.setHuanuco(objResultSet.getInt("HUANUCO"));
                objBnPersonalPresupuesto.setImpHuanuco(objResultSet.getDouble("IMP_HUANUCO"));
                objBnPersonalPresupuesto.setIca(objResultSet.getInt("ICA"));
                objBnPersonalPresupuesto.setImpIca(objResultSet.getDouble("IMP_ICA"));
                objBnPersonalPresupuesto.setJunin(objResultSet.getInt("JUNIN"));
                objBnPersonalPresupuesto.setImpJunin(objResultSet.getDouble("IMP_JUNIN"));
                objBnPersonalPresupuesto.setLibertad(objResultSet.getInt("LIBERTAD"));
                objBnPersonalPresupuesto.setImpLibertad(objResultSet.getDouble("IMP_LIBERTAD"));
                objBnPersonalPresupuesto.setLambayeque(objResultSet.getInt("LAMBAYEQUE"));
                objBnPersonalPresupuesto.setImpLambayeque(objResultSet.getDouble("IMP_LAMBAYEQUE"));
                objBnPersonalPresupuesto.setLima(objResultSet.getInt("LIMA"));
                objBnPersonalPresupuesto.setImpLima(objResultSet.getDouble("IMP_LIMA"));
                objBnPersonalPresupuesto.setLoreto(objResultSet.getInt("LORETO"));
                objBnPersonalPresupuesto.setImpLoreto(objResultSet.getDouble("IMP_LORETO"));
                objBnPersonalPresupuesto.setMddios(objResultSet.getInt("MDDIOS"));
                objBnPersonalPresupuesto.setImpMddios(objResultSet.getDouble("IMP_MDDIOS"));
                objBnPersonalPresupuesto.setMoquegua(objResultSet.getInt("MOQUEGUA"));
                objBnPersonalPresupuesto.setImpMoquegua(objResultSet.getDouble("IMP_MOQUEGUA"));
                objBnPersonalPresupuesto.setPasco(objResultSet.getInt("PASCO"));
                objBnPersonalPresupuesto.setImpPasco(objResultSet.getDouble("IMP_PASCO"));
                objBnPersonalPresupuesto.setPiura(objResultSet.getInt("PIURA"));
                objBnPersonalPresupuesto.setImpPiura(objResultSet.getDouble("IMP_PIURA"));
                objBnPersonalPresupuesto.setPuno(objResultSet.getInt("PUNO"));
                objBnPersonalPresupuesto.setImpPuno(objResultSet.getDouble("IMP_PUNO"));
                objBnPersonalPresupuesto.setSmartin(objResultSet.getInt("SMARTIN"));
                objBnPersonalPresupuesto.setImpSmartin(objResultSet.getDouble("IMP_SMARTIN"));
                objBnPersonalPresupuesto.setTacna(objResultSet.getInt("TACNA"));
                objBnPersonalPresupuesto.setImpTacna(objResultSet.getDouble("IMP_TACNA"));
                objBnPersonalPresupuesto.setTumbes(objResultSet.getInt("TUMBES"));
                objBnPersonalPresupuesto.setImpTumbes(objResultSet.getDouble("IMP_TUMBES"));
                objBnPersonalPresupuesto.setUcayali(objResultSet.getInt("UCAYALI"));
                objBnPersonalPresupuesto.setImpUcayali(objResultSet.getDouble("IMP_UCAYALI"));
                
                objBnPersonalPresupuesto.setCantidad(objResultSet.getInt("TOTAL_EFECTIVO"));
                objBnPersonalPresupuesto.setTotal(objResultSet.getDouble("IMP_TOTAL"));
                lista.add(objBnPersonalPresupuesto);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getconsultaPersonalPresupDetREE(objBeanPersonalPresupuesto) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PERSONAL_PRESUP_PRG");
            objBnMsgerr.setTipo(objBeanPersonalPresupuesto.getMode().toUpperCase());
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
    public String getImporteRee(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario) {
        String importe = "";
        sql = "SELECT NIMPORTE AS IMPORTE FROM SIPE_INGRESOS_PERSONAL_EP "
                + "WHERE "
                + "CODPER=? AND "
                + "NCONCEPTO_INGRESOS_COD=? AND "
                + "NNIVEL_GRADO_CODIGO=? AND "
                + "CODGRD=? AND "
                + "CPERIODO_REE=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPersonalPresupuesto.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPersonalPresupuesto.getCodConcepto());
            objPreparedStatement.setInt(3, objBeanPersonalPresupuesto.getNivelGrado());
            objPreparedStatement.setString(4, objBeanPersonalPresupuesto.getCodGrd());
            objPreparedStatement.setString(5, objBeanPersonalPresupuesto.getPeriodoRee());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                importe = objResultSet.getString("IMPORTE");
            } else {
                importe = "0";
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getImporteRee(objBeanPersonalPresupuesto) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_INGRESOS_PERSONAL_EP");
            objBnMsgerr.setTipo(objBeanPersonalPresupuesto.getMode().toUpperCase());
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
        return importe;
    }

    @Override
    public String getVerificarDatosRee(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario) {
        String msg = "";
        int dato = 0;
        sql = "SELECT COUNT(*) AS VALOR FROM SIPE_PERSONAL_PRESUP_PRG "
                + "WHERE "
                + "CPERIODO_CODIGO=? AND "
                + "NCONCEPTO_CODIGO=? AND "
                + "NNIVEL_GRADO=? AND "
                + "CDEPARTAMENTO_CODIGO=? AND "
                + "CUNIDAD_OPERATIVA_CODIGO||'.'||CDEPENDENCIA_CODIGO=? AND "
                + "CODGRD=? AND "
                + "CPERIODO_REE=? AND "
                + "VCADENA_GASTO_CODIGO=? AND "
                + "CMETA_OPERATIVA_CODIGO=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanPersonalPresupuesto.getPeriodo());
            objPreparedStatement.setInt(2, objBeanPersonalPresupuesto.getCodConcepto());
            objPreparedStatement.setInt(3, objBeanPersonalPresupuesto.getNivelGrado());
            objPreparedStatement.setString(4, objBeanPersonalPresupuesto.getDepartamento());
            objPreparedStatement.setString(5, objBeanPersonalPresupuesto.getUnidad());
            objPreparedStatement.setString(6, objBeanPersonalPresupuesto.getCodGrd());
            objPreparedStatement.setString(7, objBeanPersonalPresupuesto.getPeriodoRee());
            objPreparedStatement.setString(8, objBeanPersonalPresupuesto.getCadenaGasto());
            objPreparedStatement.setString(9, objBeanPersonalPresupuesto.getTarea());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                dato = objResultSet.getInt("VALOR");
            }
            if (dato > 0) {
                msg = "EXISTE";
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getVerificarDatosRee(objBeanPersonalPresupuesto) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_PERSONAL_PRESUP_PRG");
            objBnMsgerr.setTipo(objBeanPersonalPresupuesto.getMode().toUpperCase());
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
        return msg;
    }

}
