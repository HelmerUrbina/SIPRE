/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanRegistroPersonal;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.RegistroPersonalDAO;
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
 * @author H-TECCSI-V
 */
public class RegistroPersonalDAOImpl implements RegistroPersonalDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanRegistroPersonal objBnRegistroPersonal;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public RegistroPersonalDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaPersonal(BeanRegistroPersonal objBeanRegistroPersonal, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT VDNI_PERSONAL AS DNI_PERSONAL,"
                + "VNOMBRES_PERSONAL||', '||VAPELLIDOS_PERSONAL AS NOMBRES,"
                + "VDIRECCION_PERSONAL AS DIRECCION,"
                + "VNUMERO_TELEFONO AS TELEFONO,"
                + "DFECNAC_PERSONAL AS FECHA_NACIMIENTO,"
                + "UTIL_NEW.FUN_DPTO_CAJAS(CAREA_LABORAL) AS AREA,"
                + "VCARGO_PERSONAL AS CARGO,"
                + "CASE CESTADO_PERSONAL WHEN 'AC' THEN 'ACTIVO' ELSE 'BAJA' END AS ESTADO,"
                + "UTIL_NEW.FUN_NOMBRE_GRADO(CCODIGO_GRADO)  AS GRADO,"
                + "VFOTO_PERSONAL AS FOTO "
                + "FROM SIPE_REGISTRO_PERSONAL "
                + "ORDER BY NOMBRES";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnRegistroPersonal = new BeanRegistroPersonal();
                objBnRegistroPersonal.setDni(objResultSet.getString("DNI_PERSONAL"));
                objBnRegistroPersonal.setApellidosPersonal(objResultSet.getString("NOMBRES"));
                objBnRegistroPersonal.setDireccion(objResultSet.getString("DIRECCION"));
                objBnRegistroPersonal.setTelefono(objResultSet.getString("TELEFONO"));
                objBnRegistroPersonal.setFechaNacimiento(objResultSet.getDate("FECHA_NACIMIENTO"));
                objBnRegistroPersonal.setAreaLaboral(objResultSet.getString("AREA"));
                objBnRegistroPersonal.setCargo(objResultSet.getString("CARGO"));
                objBnRegistroPersonal.setEstado(objResultSet.getString("ESTADO"));
                objBnRegistroPersonal.setGrado(objResultSet.getString("GRADO"));
                objBnRegistroPersonal.setFoto(objResultSet.getString("FOTO"));
                lista.add(objBnRegistroPersonal);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPersonal(objBeanRegistroPersonal, usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_PERSONAL");
            objBnMsgerr.setTipo(objBeanRegistroPersonal.getMode());
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
    public BeanRegistroPersonal getPersonal(BeanRegistroPersonal objBeanRegistroPersonal, String usuario) {
        sql = "SELECT VNOMBRES_PERSONAL AS NOMBRES,"
                + "VAPELLIDOS_PERSONAL AS APELLIDOS,"
                + "VDIRECCION_PERSONAL AS DIRECCION,"
                + "VNUMERO_TELEFONO AS TELEFONO,"
                + "DFECNAC_PERSONAL AS FECNACIMIENTO,"
                + "CAREA_LABORAL AS AREA,"
                + "VCARGO_PERSONAL AS CARGO,"
                + "CCODIGO_GRADO AS GRADO "
                + " FROM SIPE_REGISTRO_PERSONAL WHERE "
                + "VDNI_PERSONAL=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanRegistroPersonal.getDni());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanRegistroPersonal.setNombresPersonal(objResultSet.getString("NOMBRES"));
                objBeanRegistroPersonal.setApellidosPersonal(objResultSet.getString("APELLIDOS"));
                objBeanRegistroPersonal.setDireccion(objResultSet.getString("DIRECCION"));
                objBeanRegistroPersonal.setTelefono(objResultSet.getString("TELEFONO"));
                objBeanRegistroPersonal.setFechaNacimiento(objResultSet.getDate("FECNACIMIENTO"));
                objBeanRegistroPersonal.setAreaLaboral(objResultSet.getString("AREA"));
                objBeanRegistroPersonal.setCargo(objResultSet.getString("CARGO"));
                objBeanRegistroPersonal.setGrado(objResultSet.getString("GRADO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPersonal(objBeanRegistroPersonal) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_PERSONAL");
            objBnMsgerr.setTipo(objBeanRegistroPersonal.getMode().toUpperCase());
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
        return objBeanRegistroPersonal;
    }

    @Override
    public int iduRegistroPersonal(BeanRegistroPersonal objBeanRegistroPersonal, String usuario) {

        sql = "{CALL SP_IDU_REGISTRO_PERSONAL(?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanRegistroPersonal.getDni());
            cs.setString(2, objBeanRegistroPersonal.getNombresPersonal());
            cs.setString(3, objBeanRegistroPersonal.getApellidosPersonal());
            cs.setString(4, objBeanRegistroPersonal.getDireccion());
            cs.setString(5, objBeanRegistroPersonal.getTelefono());
            cs.setDate(6, objBeanRegistroPersonal.getFechaNacimiento());
            cs.setString(7, objBeanRegistroPersonal.getAreaLaboral());
            cs.setString(8, objBeanRegistroPersonal.getCargo());
            cs.setString(9, objBeanRegistroPersonal.getFoto());
            cs.setString(10, objBeanRegistroPersonal.getGrado());
            cs.setString(11, usuario);
            cs.setString(12, objBeanRegistroPersonal.getMode().toUpperCase());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduRegistroPersonal : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_PERSONAL");
            objBnMsgerr.setTipo(objBeanRegistroPersonal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduRegistroPersonal : " + e.toString());
            }
        }

        return s;
    }

    @Override
    public List getListaPersonalFamilia(BeanRegistroPersonal objBeanRegistroPersonal, String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT VDNI_PERSONAL AS DNI_PERSONAL,"
                + "NCODIGO_FAMILIA AS CODIGO,"
                + "VDOCUMENTO_FAMILIA AS DOC_FAMILIA,"
                + "UTIL_NEW.FUN_NOMBRE_PARENTESCO(CCODIGO_PARENTESCO) AS PARENTESCO,"
                + "VNOMBRES_FAMILIA||', '||VAPELLIDOS_FAMILIA AS NOMBRES,"
                + "VCELULAR_FAMILIA AS CELULAR,"
                + "VTELEFONO_FIJO AS FIJO "
                + " FROM SIPE_REGISTRO_FAMILIA WHERE "
                + "CESTADO_FAMILIA='AC'  ";

        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnRegistroPersonal = new BeanRegistroPersonal();
                objBnRegistroPersonal.setDni(objResultSet.getString("DNI_PERSONAL"));
                objBnRegistroPersonal.setCodigoFamiliar(objResultSet.getInt("CODIGO"));
                objBnRegistroPersonal.setDocumentoFamiliar(objResultSet.getString("DOC_FAMILIA"));
                objBnRegistroPersonal.setParentesco(objResultSet.getString("PARENTESCO"));
                objBnRegistroPersonal.setNombreFamiliar(objResultSet.getString("NOMBRES").trim());
                objBnRegistroPersonal.setTelefonoFamiliar(objResultSet.getString("CELULAR"));
                objBnRegistroPersonal.setTelefono(objResultSet.getString("FIJO"));
                lista.add(objBnRegistroPersonal);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPersonalFamilia(objBeanRegistroPersonal, usuario) : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_FAMILIA");
            objBnMsgerr.setTipo(objBeanRegistroPersonal.getMode());
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
    public ArrayList getDatosFamiliares(BeanRegistroPersonal objBeanRegistroPersonal, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT NCODIGO_FAMILIA AS CODIGO,"
                + "VDOCUMENTO_FAMILIA AS DOCUMENTO,"
                + "UTIL_NEW.FUN_NOMBRE_PARENTESCO(CCODIGO_PARENTESCO) AS PARENTESCO,"
                + "VNOMBRES_FAMILIA AS NOMBRES,"
                + "VAPELLIDOS_FAMILIA AS APELLIDOS,"
                + "VCELULAR_FAMILIA AS CELULAR,"
                + "VTELEFONO_FIJO AS FIJO,"
                + "CCODIGO_PARENTESCO  "
                + "FROM SIPE_REGISTRO_FAMILIA WHERE "
                + "VDNI_PERSONAL=? AND "
                + "CESTADO_FAMILIA='AC' ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanRegistroPersonal.getDni());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("DOCUMENTO") + "+++"
                        + objResultSet.getString("PARENTESCO") + "+++"
                        + objResultSet.getString("NOMBRES").trim() + "+++"
                        + objResultSet.getString("APELLIDOS").trim() + "+++"
                        + objResultSet.getString("FIJO") + "+++"
                        + objResultSet.getString("CELULAR") + "+++"
                        + objResultSet.getString("CCODIGO_PARENTESCO");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (Exception e) {
            System.out.println("Error al obtener getDatosFamiliares(objBeanRegistroPersonal) : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_FAMILIA");
            objBnMsgerr.setTipo(objBeanRegistroPersonal.getMode().toUpperCase());
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
        return Arreglo;
    }

    @Override
    public int iduRegistroFamiliar(BeanRegistroPersonal objBeanRegistroPersonal, String usuario) {
        sql = "{CALL SP_IDU_REGISTRO_FAMILIA(?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanRegistroPersonal.getDni());
            cs.setString(2, objBeanRegistroPersonal.getDocumentoFamiliar());
            cs.setString(3, objBeanRegistroPersonal.getParentesco());
            cs.setString(4, objBeanRegistroPersonal.getNombreFamiliar());
            cs.setString(5, objBeanRegistroPersonal.getApellidoFamiliar());
            cs.setString(6, objBeanRegistroPersonal.getTelefono());
            cs.setString(7, objBeanRegistroPersonal.getTelefonoFamiliar());
            cs.setString(8, usuario);
            cs.setString(9, objBeanRegistroPersonal.getMode().toUpperCase());
            s = cs.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduRegistroFamiliar : " + e.toString());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPE_REGISTRO_FAMILIA");
            objBnMsgerr.setTipo(objBeanRegistroPersonal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.toString());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduRegistroFamiliar : " + e.toString());
            }
        }
        return s;
    }

}
