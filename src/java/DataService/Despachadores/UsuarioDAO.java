package DataService.Despachadores;

import BusinessServices.Beans.BeanUsuario;
import java.util.ArrayList;
import java.util.List;

public interface UsuarioDAO {

    public BeanUsuario autentica(String usuario, String password, String periodo);

    public List getModulos(String usuario);

    public List getMenu(String usuario);

    public ArrayList getMenu();

    public ArrayList getOpciones(BeanUsuario objBeanUsuario, String usuario);

    public List getListaUsuarios(String usuario);

    public BeanUsuario getUsuario(BeanUsuario objBeanUsuario, String usuario);

    public int iduUsuario(BeanUsuario objBeanUsuario, String usuario);

    public int iduOpciones(BeanUsuario objBeanUsuario, String usuario);

}
