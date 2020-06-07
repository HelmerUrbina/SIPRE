/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanResoluciones;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface ResolucionesDAO {

    public List getListaResoluciones(BeanResoluciones objBeanResolucion, String usuario);

    public BeanResoluciones getResolucion(BeanResoluciones objBeanResolucion, String usuario);

    public int iduResolucion(BeanResoluciones objBeanResolucion, String usuario);

}
