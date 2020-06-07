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
public interface EventoFinalDAO {

    public List getListaEventoFinal(BeanEventos objBeanEvento, String usuario);

    public List getListaHojaTrabajo(BeanEventos objBeanEvento, String usuario);

    public String getUltimoEventoFinal(BeanEventos objBeanEvento, String usuario);

    public BeanEventos getEventoFinal(BeanEventos objBeanEvento, String usuario);

    public int iduEventoFinal(BeanEventos objBeanEvento, String usuario);

}
