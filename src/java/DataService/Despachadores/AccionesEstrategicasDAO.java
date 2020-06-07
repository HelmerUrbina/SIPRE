/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanPlaneamiento;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface AccionesEstrategicasDAO {

    public List getListaAccionesEstrategicas(BeanPlaneamiento objBeanAcciones, String usuario);

    public BeanPlaneamiento getAccionesEstrategicas(BeanPlaneamiento objBeanAcciones, String usuario);

    public Integer getPrioridadAccionesEstrategicas(BeanPlaneamiento objBeanAcciones, String usuario);

    public int iduAccionesEstrategicas(BeanPlaneamiento objBeanAcciones, String usuario);

}
