package DataService.SQL;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ConnectionMySQL {

    public Connection getConnection() {
        Connection objConnection = null;
        try {
            Context c = new InitialContext();
            DataSource ds = (DataSource) c.lookup("java:comp/env/BIOSTAR");
            objConnection = ds.getConnection();
        } catch (NamingException | SQLException e) {
            System.out.println("Problemas!: Fallo la creacion del Pool de Conexiones... BIOSTAR \n" + e.getMessage());
        }
        return objConnection;
    }
}
