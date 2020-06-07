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
public interface TareasOperativasDAO {

    public List getListaTareasOperativas(String usuario);

    public BeanTareas getTareasOperativas(BeanTareas objBeanTareasOperativas, String usuario);

    public int iduTareasOperativas(BeanTareas objBeanTareasOperativas, String usuario);

}
