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
public interface EventoSecundarioDAO {

    public BeanEventos getEventoPrincipal(BeanEventos objBeanEvento, String usuario);
    
    public BeanEventos getEventoSecundario(BeanEventos objBeanEvento, String usuario);

    public List getListaEventoPrincipal(BeanEventos objBeanEvento, String usuario);

    public List getListaEventoFinal(BeanEventos objBeanEvento, String usuario);

    public List getListaEventoSecundario(BeanEventos objBeanEvento, String usuario);

    public String getCodigoEventoSecundario(BeanEventos objBeanEvento, String usuario);
    
    public int iduEventoSecundario(BeanEventos objBeanEvento, String usuario);

}
