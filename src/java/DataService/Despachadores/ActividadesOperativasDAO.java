/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanPlaneamiento;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface ActividadesOperativasDAO {

    public List getListaActividadesOperativas(BeanPlaneamiento objBeanActividad, String usuario);

    public BeanPlaneamiento getActividadesOperativas(BeanPlaneamiento objBeanActividad, String usuario);

    public Integer getPrioridadActividadesOperativas(BeanPlaneamiento objBeanActividad, String usuario);

    public ArrayList getListaActividadesOperativasDetalleDetalle(BeanPlaneamiento objBeanActividad, String usuario);

    public String getActividadesOperativasDetalleDetalle(BeanPlaneamiento objBeanActividad, String usuario);

    public int iduActividadesOperativas(BeanPlaneamiento objBeanActividad, String usuario);

    public int iduActividadesOperativasDetalle(BeanPlaneamiento objBeanActividad, String usuario);

}
