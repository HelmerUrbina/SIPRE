package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import BusinessServices.Beans.BeanUsuarioMenu;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.UsuarioDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class UsuarioDAOImpl implements UsuarioDAO {

    private final Connection objConnection;
    private PreparedStatement objPreparedStatement;
    private ResultSet objResultSet;
    private String sql;
    private List lista;
    private BeanUsuario objBnUsuario;
    private BeanUsuarioMenu objBnUsuarioMenu;
    private BeanMsgerr objBnMsgerr;
    private MsgerrDAO objDsMsgerr;
    private Integer s = 0;

    public UsuarioDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public BeanUsuario autentica(String usuario, String password, String periodo) {
        password = EncriptarCadena(password, true);
        sql = "SELECT CODUSU, COUUOO, APEUSU, NOMUSU, CASE DIPPTO WHEN 'S' THEN 'TRUE' ELSE 'FALSE' END AS DIPPTO, "
                + "UTIL_NEW.FUN_ABUUOO(COUUOO) AS UNIDAD_OPERATIVA, "
                + "UTIL_NEW.FUN_COPPTO_SECTORISTA('" + periodo + "', COUUOO, CODUSU) AS PRESUPUESTO  "
                + "FROM TABUSU WHERE "
                + "CODUSU=? AND "
                + "PASUSU=? AND "
                + "ACTA='S' AND "
                + "ESTREG=?";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, usuario);
            objPreparedStatement.setString(2, password);
            objPreparedStatement.setString(3, "AC");
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBnUsuario = new BeanUsuario();
                objBnUsuario.setUsuario(objResultSet.getString("CODUSU"));
                objBnUsuario.setUnidadOperativa(objResultSet.getString("COUUOO"));
                objBnUsuario.setApellido(objResultSet.getString("APEUSU"));
                objBnUsuario.setNombre(objResultSet.getString("NOMUSU"));
                objBnUsuario.setAutorizacion(objResultSet.getBoolean("DIPPTO"));
                objBnUsuario.setUnidadOperativaDetalle(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnUsuario.setPresupuesto(objResultSet.getInt("PRESUPUESTO"));
                objBnUsuario.setSistema("SIPRE");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
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
        return objBnUsuario;
    }

    @Override
    public List getModulos(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT DISTINCT SYSMOD.CODMOD AS CODIGO, SYSMOD.DESMOD AS DESCRIPCION "
                + "FROM MENUSU INNER JOIN SYSMOD ON "
                + "(MENUSU.CODMOD=SYSMOD.CODMOD) WHERE "
                + "MENUSU.CODMOD NOT IN ('11') AND "
                + "MENUSU.CODUSU=? "
                + "ORDER BY CODIGO";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, usuario);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnUsuarioMenu = new BeanUsuarioMenu();
                objBnUsuarioMenu.setModulo(objResultSet.getString("CODIGO"));
                objBnUsuarioMenu.setDescripcion(objResultSet.getString("DESCRIPCION"));
                lista.add(objBnUsuarioMenu);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener Modulos(usuario) : " + e.getMessage());
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
    public List getMenu(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT MENUSU.CODMOD AS MODULO, SYSMEN.CODMEN AS MENU, SYSMEN.DESMEN AS DESCRIPCION, SYSMEN.SERMEN AS SERVLET, SYSMEN.MODMEN AS MODO, "
                + "NVL(SYSMEN.CODNIV,'0') AS NIVEL, SYSMEN.DESNIV AS DESC_NIVEL "
                + "FROM MENUSU INNER JOIN SYSMEN ON (MENUSU.CODMOD=SYSMEN.CODMOD AND MENUSU.CODMEN=SYSMEN.CODMEN) WHERE "
                + "MENUSU.CODUSU=? "
                + "ORDER BY 1, 2 ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, usuario);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnUsuarioMenu = new BeanUsuarioMenu();
                objBnUsuarioMenu.setModulo(objResultSet.getString("MODULO"));
                objBnUsuarioMenu.setMenu(objResultSet.getString("MENU"));
                objBnUsuarioMenu.setDescripcion(objResultSet.getString("DESCRIPCION"));
                objBnUsuarioMenu.setServlet(objResultSet.getString("SERVLET"));
                objBnUsuarioMenu.setModo(objResultSet.getString("MODO"));
                objBnUsuarioMenu.setCodNivel(objResultSet.getString("NIVEL"));
                objBnUsuarioMenu.setDesNivel(objResultSet.getString("DESC_NIVEL"));
                lista.add(objBnUsuarioMenu);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getMenu(usuario) : " + e.getMessage());
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
    public ArrayList getMenu() {
        ArrayList<String> Arreglo = new ArrayList<>();
        ArrayList<String> Filas = new ArrayList<>();
        sql = "SELECT MO.CODMOD||ME.CODMEN AS CODIGO, MO.CODMOD, MO.DESMOD AS MODULO, ME.DESMEN AS MENU "
                + "FROM SYSMOD MO INNER JOIN SYSMEN ME ON "
                + "(MO.CODMOD=ME.CODMOD) WHERE "
                + "MO.CODMOD!='11' "
                + "ORDER BY CODIGO ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Filas.clear();
                String arreglo = objResultSet.getString("CODIGO") + "+++"
                        + objResultSet.getString("CODMOD") + "+++"
                        + objResultSet.getString("MODULO") + "+++"
                        + objResultSet.getString("MENU");
                Filas.add(arreglo);
                Arreglo.add("" + Filas);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getMenu() : " + e.getMessage());
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
        return Arreglo;
    }

    @Override
    public ArrayList getOpciones(BeanUsuario objBeanUsuario, String usuario) {
        ArrayList<String> Arreglo = new ArrayList<>();
        sql = "SELECT CODMOD||CODMEN AS CODIGO "
                + "FROM MENUSU "
                + "WHERE CODUSU=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanUsuario.getUsuario());
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                Arreglo.add(objResultSet.getString("CODIGO"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getOpciones(objBeanUsuario, usuario) : " + e.getMessage());
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
    public List getListaUsuarios(String usuario) {
        lista = new LinkedList<>();
        sql = "SELECT CODUSU AS USUARIO, COUUOO||':'||UTIL_NEW.FUN_ABUUOO(COUUOO) AS UNIDAD_OPERATIVA, "
                + "APEUSU||', '||NOMUSU AS APELLIDOS_NOMBRES,  INIUSU AS INICIALES, "
                + "UTIL_NEW.FUN_NOMBRE_AREA_LABORAL(COARLB) AS AREA, "
                + "CASE ESTREG WHEN 'AC' THEN 'ACTIVO' WHEN 'IN' THEN 'INACTIVO' ELSE 'VERIFICAR' END AS ESTADO, "
                + "CASE DIPPTO WHEN 'S' THEN 'SI' ELSE 'NO' END AS OPRE, "
                + "CASE ACTA WHEN 'S' THEN 'SI' ELSE 'NO' END AS ACTA "
                + "FROM TABUSU "
                + "ORDER BY 2,3";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objResultSet = objPreparedStatement.executeQuery();
            while (objResultSet.next()) {
                objBnUsuario = new BeanUsuario();
                objBnUsuario.setUsuario(objResultSet.getString("USUARIO"));
                objBnUsuario.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBnUsuario.setApellido(objResultSet.getString("APELLIDOS_NOMBRES"));
                objBnUsuario.setIniciales(objResultSet.getString("INICIALES"));
                objBnUsuario.setAreaLaboral(objResultSet.getString("AREA"));
                objBnUsuario.setEstado(objResultSet.getString("ESTADO"));
                objBnUsuario.setOpre(objResultSet.getString("OPRE"));
                objBnUsuario.setActa(objResultSet.getString("ACTA"));
                lista.add(objBnUsuario);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getListaUsuarios() : " + e.getMessage());
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
    public BeanUsuario getUsuario(BeanUsuario objBeanUsuario, String usuario) {
        sql = "SELECT COUUOO AS UNIDAD_OPERATIVA, "
                + "APEUSU AS APELLIDO, NOMUSU AS NOMBRES,  INIUSU AS INICIALES, "
                + "COARLB AS AREA, "
                + "ESTREG AS ESTADO, "
                + "DIPPTO AS OPRE, "
                + "ACTA AS ACTA "
                + "FROM TABUSU WHERE "
                + "CODUSU=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBeanUsuario.getUsuario());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBeanUsuario.setUnidadOperativa(objResultSet.getString("UNIDAD_OPERATIVA"));
                objBeanUsuario.setApellido(objResultSet.getString("APELLIDO"));
                objBeanUsuario.setNombre(objResultSet.getString("NOMBRES"));
                objBeanUsuario.setIniciales(objResultSet.getString("INICIALES"));
                objBeanUsuario.setAreaLaboral(objResultSet.getString("AREA"));
                objBeanUsuario.setEstado(objResultSet.getString("ESTADO"));
                objBeanUsuario.setOpre(objResultSet.getString("OPRE"));
                objBeanUsuario.setActa(objResultSet.getString("ACTA"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener getUsuario() : " + e.getMessage());
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
        return objBeanUsuario;
    }

    @Override
    public int iduUsuario(BeanUsuario objBeanUsuario, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        String password = "";
        if (objBeanUsuario.getMode().equals("I") || objBeanUsuario.getMode().equals("P")) {
            password = EncriptarCadena(objBeanUsuario.getPassword(), true);
        }
        sql = "{CALL SP_IDU_TABUSU(?,?,?,?,?,?,?,?,?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanUsuario.getUsuario());
            cs.setString(2, objBeanUsuario.getUnidadOperativa());
            cs.setString(3, objBeanUsuario.getApellido().toUpperCase());
            cs.setString(4, objBeanUsuario.getNombre().toUpperCase());
            cs.setString(5, password);
            cs.setString(6, objBeanUsuario.getAreaLaboral());
            cs.setString(7, objBeanUsuario.getIniciales().toUpperCase());
            cs.setString(8, objBeanUsuario.getOpre());
            cs.setString(9, objBeanUsuario.getActa());
            cs.setString(10, objBeanUsuario.getEstado());
            cs.setString(11, usuario);
            cs.setString(12, objBeanUsuario.getMode());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduUsuario : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TABUSU");
            objBnMsgerr.setTipo(objBeanUsuario.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduUsuario : " + e.toString());
            }
        }
        return s;
    }

    @Override
    public int iduOpciones(BeanUsuario objBeanUsuario, String usuario) {
        /*
         * EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS PROVEEDORES, EN EL
         * CUAL PODEMOS INSERTAR, MODIFICAR O ELIMINAR UN REGISTRO DE LA TABLA
         * USUARIO, EN CASO DE OBTENER ALGUN ERROR ACTIVARA LA OPCION DE
         * EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
         */
        sql = "{CALL SP_IDU_MENUSU(?,?,?,?)}";
        try (CallableStatement cs = objConnection.prepareCall(sql)) {
            cs.setString(1, objBeanUsuario.getUsuario());
            cs.setString(2, objBeanUsuario.getModulo());
            cs.setString(3, objBeanUsuario.getMenu());
            cs.setString(4, objBeanUsuario.getMode());
            objResultSet = cs.executeQuery();
            s++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduOpciones : " + e.getMessage());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(usuario);
            objBnMsgerr.setTabla("TABUSU");
            objBnMsgerr.setTipo(objBeanUsuario.getMode().toUpperCase());
            objBnMsgerr.setDescripcion(e.getMessage());
            s = objDsMsgerr.iduMsgerr(objBnMsgerr);
            return 0;
        } finally {
            try {
                if (objResultSet != null) {
                    objResultSet.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al ejecutar iduOpciones : " + e.toString());
            }
        }
        return s;
    }

    public String EncriptarCadena(String cadena, boolean a) {
        String retorno = "";
        int it = cadena.length();
        int temp;
        int[] textoascii = new int[it];
        if (a) {
            for (int i = 0; i < it; i++) {
                textoascii[i] = cadena.charAt(i);
                temp = textoascii[i];
                temp = temp + 200 % 27;
                if (temp > 127) {
                    int v = temp / 127;
                    temp = temp - 128 * v;
                }
                retorno = retorno + (char) temp;
            }
        } else {
            for (int i = 0; i < it; i++) {
                textoascii[i] = cadena.charAt(i);
                temp = textoascii[i];
                temp = temp - 200 % 27;
                if (temp > 127) {
                    int v = temp / 127;
                    temp = temp - 128 * v;
                }
                retorno = retorno + (char) temp;
            }
        }
        return retorno;
    }
}
