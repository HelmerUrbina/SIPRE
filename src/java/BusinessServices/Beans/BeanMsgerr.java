package BusinessServices.Beans;

import java.io.Serializable;

/**
 *
 * @author H-URBINA-M
 */
public class BeanMsgerr implements Serializable {

    private String Usuario;
    private String Tipo;
    private String Tabla;
    private String Descripcion;

    public BeanMsgerr() {
    }

    public String getUsuario() {
        return Usuario;
    }

    public void setUsuario(String Usuario) {
        this.Usuario = Usuario;
    }

    public String getTipo() {
        return Tipo;
    }

    public void setTipo(String Tipo) {
        this.Tipo = Tipo;
    }

    public String getTabla() {
        return Tabla;
    }

    public void setTabla(String Tabla) {
        this.Tabla = Tabla;
    }

    public String getDescripcion() {
        return Descripcion;
    }

    public void setDescripcion(String Descripcion) {
        this.Descripcion = Descripcion;
    }

}
