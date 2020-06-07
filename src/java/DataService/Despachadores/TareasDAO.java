/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanTareas;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface TareasDAO {

    public List getListaTareas(String usuario);

    public BeanTareas getTareas(BeanTareas objBeanTareas, String usuario);

    public int iduTareas(BeanTareas objBeanTareas, String usuario);

}
