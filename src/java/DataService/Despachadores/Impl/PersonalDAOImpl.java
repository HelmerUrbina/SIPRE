/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPersonal;
import DataService.Despachadores.MsgerrDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import DataService.Despachadores.PersonalDAO;

/**
 *
 * @author H-TECCSI-V
 */
public class PersonalDAOImpl implements PersonalDAO {

    private final Connection objConnection;
    private List lista;
    private String sql;
    private ResultSet objResultSet;
    private BeanPersonal objBnRegistroPersonal;
    private PreparedStatement objPreparedStatement;
    private MsgerrDAO objDsMsgerr;
    private BeanMsgerr objBnMsgerr;
    private int s = 0;

    public PersonalDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public List getListaPersonal(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NPERSONAL_CODIGO AS PERSONAL, VPERSONAL_DOCUMENTO AS DOCUMENTO, "
                + "VPERSONAL_APELLIDO_PATERNO||' '||VPERSONAL_APELLIDO_MATERNO||', '||VPERSONAL_NOMBRES AS APELLIDOS_NOMBRES, "
                + "VPERSONAL_DIRECCION AS DIRECCION, "
                + "VPERSONAL_TELEFONO AS TELEFONO, "
                + "DPERSONAL_NACIMIENTO AS FECHA_NACIMIENTO,"
                + "UTIL_NEW.FUN_NOMBRE_AREA_LABORAL(CAREA_LABORAL_CODIGO) AS AREA, "
                + "VPERSONAL_CARGO AS CARGO, "
                + "CASE CESTADO_CODIGO WHEN 'AC' THEN 'ACTIVO' ELSE 'BAJA' END AS ESTADO, "
                + "UTIL_NEW.FUN_NOMBRE_GRADO(CGRADO_CODIGO)  AS GRADO, "
                + "VPERSONAL_FOTO AS FOTO "
                + "FROM SIPRE_PERSONAL "
                + "ORDER BY CESTADO_CODIGO, APELLIDOS_NOMBRES";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnRegistroPersonal = new BeanPersonal();
                objBnRegistroPersonal.setPersonal(objResultSet.getInt("PERSONAL"));
                objBnRegistroPersonal.setDocumento(objResultSet.getString("DOCUMENTO"));
                objBnRegistroPersonal.setPaterno(objResultSet.getString("APELLIDOS_NOMBRES"));
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
            System.out.println("Error al obtener getListaPersonal(" + usuario + ") : " + e.getMessage());
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
    public List getListaPersonalFamilia(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT NPERSONAL_CODIGO AS PERSONAL, NPERSONAL_FAMILIA_CODIGO AS CODIGO, "
                + "VPERSONAL_FAMILIA_DOCUMENTO AS DOCUMENTO, "
                + "UTIL_NEW.FUN_NOMBRE_PARENTESCO(CPARENTESCO_CODIGO) AS PARENTESCO, "
                + "VPERSONAL_FAMILIA_PATERNO||' '||VPERSONAL_FAMILIA_MATERNO||', '||VPERSONAL_FAMILIA_NOMBRES AS NOMBRES, "
                + "VPERSONAL_FAMILIA_TELEFONO AS TELEFONO, DPERSONAL_FAMILIA_NACIMIENTO AS FECHA_NACIMIENTO, "
                + "CASE WHEN CESTADO_CODIGO!='AC' THEN ' ' ELSE UTIL_NEW.FUN_NOMBRE_ESTADO(CESTADO_CODIGO) END OBSERVACION "
                + "FROM SIPRE_PERSONAL_FAMILIA ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnRegistroPersonal = new BeanPersonal();
                objBnRegistroPersonal.setPersonal(objResultSet.getInt("PERSONAL"));
                objBnRegistroPersonal.setFamilia(objResultSet.getInt("CODIGO"));
                objBnRegistroPersonal.setDocumento(objResultSet.getString("DOCUMENTO"));
                objBnRegistroPersonal.setParentesco(objResultSet.getString("PARENTESCO"));
                objBnRegistroPersonal.setNombres(objResultSet.getString("NOMBRES").trim());
                objBnRegistroPersonal.setTelefono(objResultSet.getString("TELEFONO"));
                objBnRegistroPersonal.setFechaNacimiento(objResultSet.getDate("FECHA_NACIMIENTO"));
                objBnRegistroPersonal.setEstado(objResultSet.getString("OBSERVACION"));
                lista.add(objBnRegistroPersonal);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaPersonalFamilia(" + usuario + ") : " + e.getMessage());
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
    public BeanPersonal getPersonal(BeanPersonal objBeanPersonal, String usuario) {
        sql = "SELECT CPERSONAL_TIPO_DOCUMENTO, VPERSONAL_DOCUMENTO, VPERSONAL_APELLIDO_PATERNO, "
                + "VPERSONAL_APELLIDO_MATERNO, VPERSONAL_NOMBRES, DPERSONAL_NACIMIENTO, "
                + "CPERSONAL_SEXO, VPERSONAL_TELEFONO, VPERSONAL_DIRECCION, VPERSONAL_CORREO, "
                + "CPERSONAL_CIP, CAREA_LABORAL_CODIGO, CGRADO_CODIGO, VPERSONAL_CARGO, "
                + "DPERSONAL_NACIMIENTO AS FECNACIMIENTO,"
                + "CAREA_LABORAL_CODIGO AS AREA,"
                + "VPERSONAL_CARGO AS CARGO, "
                + "CGRADO_CODIGO AS GRADO "
                + "FROM SIPRE_PERSONAL WHERE "
                + "NPERSONAL_CODIGO=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setInt(1, objBeanPersonal.getPersonal());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanPersonal.setTipoDocumento(objResultSet.getString("CPERSONAL_TIPO_DOCUMENTO"));
                objBeanPersonal.setDocumento(objResultSet.getString("VPERSONAL_DOCUMENTO"));
                objBeanPersonal.setPaterno(objResultSet.getString("VPERSONAL_APELLIDO_PATERNO"));
                objBeanPersonal.setMaterno(objResultSet.getString("VPERSONAL_APELLIDO_MATERNO"));
                objBeanPersonal.setNombres(objResultSet.getString("VPERSONAL_NOMBRES"));
                objBeanPersonal.setFechaNacimiento(objResultSet.getDate("DPERSONAL_NACIMIENTO"));
                objBeanPersonal.setSexo(objResultSet.getString("CPERSONAL_SEXO"));
                objBeanPersonal.setTelefono(objResultSet.getString("VPERSONAL_TELEFONO"));
                objBeanPersonal.setDireccion(objResultSet.getString("VPERSONAL_DIRECCION"));
                objBeanPersonal.setCorreo(objResultSet.getString("VPERSONAL_CORREO"));
                objBeanPersonal.setCIP(objResultSet.getString("CPERSONAL_CIP"));
                objBeanPersonal.setAreaLaboral(objResultSet.getString("CAREA_LABORAL_CODIGO"));
                objBeanPersonal.setGrado(objResultSet.getString("CGRADO_CODIGO"));
                objBeanPersonal.setCargo(objResultSet.getString("VPERSONAL_CARGO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getPersonal(" + objBeanPersonal + ", " + usuario + ") : " + e.getMessage());
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
        return objBeanPersonal;
    }

    @Override
    public ArrayList getDatosFamiliares(BeanPersonal objBeanPersonal, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT NPERSONAL_FAMILIA_CODIGO AS DETALLE, CPARENTESCO_CODIGO AS PARENTESCO, "
                //+ "UTIL_NEW.FUN_NOMBRE_PARENTESCO(CPARENTESCO_CODIGO) AS PARENTESCO, "
                + "CPERSONAL_TIPO_DOCUMENTO AS TIPO_DOCUMENTO, VPERSONAL_FAMILIA_DOCUMENTO AS DOCUMENTO, "
                + "VPERSONAL_FAMILIA_PATERNO AS PATERNO, VPERSONAL_FAMILIA_MATERNO AS MATERNO, VPERSONAL_FAMILIA_NOMBRES AS NOMBRES, "
                + "CPERSONAL_FAMILIA_SEXO AS SEXO, DPERSONAL_FAMILIA_NACIMIENTO AS FECHA_NACIMIENTO, "
                + "VPERSONAL_FAMILIA_TELEFONO AS TELEFONO, VPERSONAL_FAMILIA_DIRECCION AS DIRECCION, "
                + "VPERSONAL_FAMILIA_CORREO AS CORREO, "
                + "CASE WHEN CESTADO_CODIGO!='AC' THEN ' ' ELSE UTIL_NEW.FUN_NOMBRE_ESTADO(CESTADO_CODIGO) END OBSERVACION "
                + "FROM SIPRE_PERSONAL_FAMILIA WHERE "
                + "NPERSONAL_CODIGO=? "
                + "ORDER BY CPARENTESCO_CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setInt(1, objBeanPersonal.getPersonal());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("DETALLE") + "+++"
                        + objResultSet.getString("PARENTESCO") + "+++"
                        + objResultSet.getString("TIPO_DOCUMENTO") + "+++"
                        + objResultSet.getString("DOCUMENTO") + "+++"
                        + objResultSet.getString("PATERNO") + "+++"
                        + objResultSet.getString("MATERNO") + "+++"
                        + objResultSet.getString("NOMBRES") + "+++"
                        + objResultSet.getString("SEXO") + "+++"
                        + objResultSet.getString("FECHA_NACIMIENTO") + "+++"
                        + objResultSet.getString("TELEFONO") + "+++"
                        + objResultSet.getString("DIRECCION") + "+++"
                        + objResultSet.getString("CORREO") + "+++"
                        + objResultSet.getString("OBSERVACION");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getDatosFamiliares(" + objBeanPersonal + ", " + usuario + ") : " + e.getMessage());
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
    public int iduPersonal(BeanPersonal objBeanPersonal, String usuario) {
        sql = "{CALL SP_IDU_PERSONAL(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setInt(1, objBeanPersonal.getPersonal());
            cs.setString(2, objBeanPersonal.getTipoDocumento());
            cs.setString(3, objBeanPersonal.getDocumento());
            cs.setString(4, objBeanPersonal.getPaterno());
            cs.setString(5, objBeanPersonal.getMaterno());
            cs.setString(6, objBeanPersonal.getNombres());
            cs.setDate(7, objBeanPersonal.getFechaNacimiento());
            cs.setString(8, objBeanPersonal.getSexo());
            cs.setString(9, objBeanPersonal.getTelefono());
            cs.setString(10, objBeanPersonal.getDireccion());
            cs.setString(11, objBeanPersonal.getCorreo());
            cs.setString(12, objBeanPersonal.getCIP());
            cs.setString(13, objBeanPersonal.getAreaLaboral());
            cs.setString(14, objBeanPersonal.getGrado());
            cs.setString(15, objBeanPersonal.getCargo());
            cs.setString(16, objBeanPersonal.getFoto());
            cs.setBlob(17, objBeanPersonal.getImage());
            cs.setString(18, usuario);
            cs.setString(19, objBeanPersonal.getMode().toUpperCase());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduPersonal : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PERSONAL");
            objBnMsgerr.setTipo(objBeanPersonal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public int iduFamilia(BeanPersonal objBeanPersonal, String usuario) {
        sql = "{CALL SP_IDU_REGISTRO_FAMILIA(?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanPersonal.getDocumento());
            cs.setString(2, objBeanPersonal.getDocumento());
            cs.setString(3, objBeanPersonal.getParentesco());
            cs.setString(4, objBeanPersonal.getNombres());
            cs.setString(5, objBeanPersonal.getPaterno());
            cs.setString(6, objBeanPersonal.getTelefono());
            cs.setString(7, objBeanPersonal.getTelefono());
            cs.setString(8, usuario);
            cs.setString(9, objBeanPersonal.getMode().toUpperCase());
            s = cs.executeUpdate();
            cs.close();
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduRegistroFamiliar : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("SIPRE_PERSONAL_FAMILIA");
            objBnMsgerr.setTipo(objBeanPersonal.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        }
        return s;
    }

    @Override
    public byte[] getImagen(Integer persona) {
        sql = "SELECT BPERSONAL_IMAGEN "
                + "FROM SIPRE_PERSONAL WHERE "
                + "NPERSONAL_CODIGO=? ";
        byte[] imgData = null;
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setInt(1, persona);
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                imgData = objResultSet.getBytes("BPERSONAL_IMAGEN");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getImage(" + persona + ") : " + e.getMessage());
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
        return imgData;
    }

}
