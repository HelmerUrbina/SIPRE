package DataService.Despachadores.Impl;

import BusinessServices.Beans.BeanMsgerr;
import DataService.Despachadores.MsgerrDAO;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;

public class MsgerrDAOImpl implements MsgerrDAO {

    private final Connection objConnection;
    private PreparedStatement objPreparedStatement;
    private ResultSet objResultSet;
    private String sql;

    public MsgerrDAOImpl(Connection objConnection1) {
        objConnection = objConnection1;
    }

    @Override
    public BeanMsgerr getMsgerr(BeanMsgerr objBnMsgerr) {
        /*
         *  OBTENEMOS UN MENSAJE DE ERROR PRODUCIDO EN LA CUAL NOS MOSTRARA EL TIPO DE ERROR,
         *  EL USUARIO QUE OCURRIO EL ERROR, EL NOMBRE DE LA TABLA EN ERROR Y LA DESCRIPCION DEL ERROR
         *  DE LA TABLA DE MENSAJE DE ERROR, LA CONSULTA SE REALIZARA POR CODIGO DE USUARIO, TABLA DE ERROR Y EL
         *  TIPO DE ERROR.
         */
        sql = "SELECT TIPERR, CODUSU, NOMTAB, NOMERR "
                + "FROM MSGERR WHERE "
                + "CODUSU=? AND "
                + "NOMTAB=? AND "
                + "TIPERR=? ";
        try {
            objPreparedStatement = objConnection.prepareStatement(sql);
            objPreparedStatement.setString(1, objBnMsgerr.getUsuario());
            objPreparedStatement.setString(2, objBnMsgerr.getTabla().toUpperCase());
            objPreparedStatement.setString(3, objBnMsgerr.getTipo());
            objResultSet = objPreparedStatement.executeQuery();
            if (objResultSet.next()) {
                objBnMsgerr.setUsuario(objResultSet.getString("CODUSU"));
                objBnMsgerr.setTabla(objResultSet.getString("NOMTAB"));
                objBnMsgerr.setTipo(objResultSet.getString("TIPERR"));
                objBnMsgerr.setDescripcion(objResultSet.getString("NOMERR"));
            }
        } catch (SQLException e) {
            System.out.println("Error al ejecutar getMsgerr : " + e.toString());
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
        return objBnMsgerr;
    }

    @Override
    public Integer iduMsgerr(BeanMsgerr objMsgerr) {
        int n = 0;
        try {
            /*
             *  EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS MENSAJES DE ERROR, EN EL CUAL PODEMOS
             *  ELIMINAMOS SI EXISTE UN ERROR CON EL MISMO USUARIO, EN LA MISMA TABLA Y EL MISMO TIPO DE ERROR
             *  Y LUEGO INSERTAMOS UN REGISTRO DE MENSAJE DE ERROR, EN CASO DE OBTENER
             *  ALGUN ERROR ACTIVARA LA OPCION DE EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
             */
            CallableStatement cs = objConnection.prepareCall("{CALL SP_IDU_MSGERR(?,?,?,?)}");
            cs.setString(1, objMsgerr.getUsuario());
            cs.setString(2, objMsgerr.getTabla());
            cs.setString(3, objMsgerr.getTipo());
            cs.setString(4, objMsgerr.getDescripcion());
            objResultSet = cs.executeQuery();
            n++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduMsgerr : " + e.toString());
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
        return n;
    }

    @Override
    public Integer iduLog(String usuario, String tipo, String mensaje, HttpServletRequest request) {
        int n = 0;
        try {
            /*
             *  EJECUTAMOS EL PROCEDIMIENTO ALMACENADO PARA LOS MENSAJES DE ERROR, EN EL CUAL PODEMOS
             *  ELIMINAMOS SI EXISTE UN ERROR CON EL MISMO USUARIO, EN LA MISMA TABLA Y EL MISMO TIPO DE ERROR
             *  Y LUEGO INSERTAMOS UN REGISTRO DE MENSAJE DE ERROR, EN CASO DE OBTENER
             *  ALGUN ERROR ACTIVARA LA OPCION DE EXCEPCIONES EN LA CUAL SE REGISTRARA EL ERROR EL MOTIVO DEL ERROR.
             */
            CallableStatement cs = objConnection.prepareCall("{CALL SP_IDU_LOG(?,?,?,?,?)}");
            cs.setString(1, usuario);
            cs.setString(2, request.getServletPath());
            cs.setString(3, tipo);
            cs.setString(4, mensaje);
            cs.setString(5, request.getRemoteHost());
            objResultSet = cs.executeQuery();
            n++;
        } catch (SQLException e) {
            System.out.println("Error al ejecutar iduLog : " + e.toString());
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
        return n;
    }
}
