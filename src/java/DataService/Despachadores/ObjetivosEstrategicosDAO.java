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
public interface ObjetivosEstrategicosDAO {

    public List getListaObjetivosEstrategicos(String periodo, String usuario);

    public BeanPlaneamiento getObjetivosEstrategicos(BeanPlaneamiento objBeanObjetivos, String usuario);

    public Integer getPrioridadObjetivosEstrategicos(String periodo, String usuario);

    public int iduObjetivosEstrategicos(BeanPlaneamiento objBeanObjetivos, String usuario);

}
