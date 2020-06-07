/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanEventos;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface EventoPrincipalDAO {

    public List getTotalesEventoPrincipal(BeanEventos objBeanEventoPrincipal, String usuario);

    public List getListaEventoPrincipal(BeanEventos objBeanEventoPrincipal, String usuario);

    public String getCodigoEventoPrincipal(BeanEventos objBeanEventoPrincipal, String usuario);

    public BeanEventos getEventoPrincipal(BeanEventos objBeanEventoPrincipal, String usuario);

    public BeanEventos getCantidadesFisicas(BeanEventos objBeanEventoPrincipal, String usuario);

    public int iduEventoPrincipal(BeanEventos objBeanEventoPrincipal, String usuario);

    public int iduCantidadesFisicas(BeanEventos objBeanEventoPrincipal, String usuario);

}
