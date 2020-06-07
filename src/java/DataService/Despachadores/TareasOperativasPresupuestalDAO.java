/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanTareaOperativaPresupuestal;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface TareasOperativasPresupuestalDAO {

    public List getListaTareasOperativasPresupuestales(BeanTareaOperativaPresupuestal objBeanTareaOperativaPresupuestal, String usuario);

    public ArrayList getTareasPresupuestales(BeanTareaOperativaPresupuestal objBeanTareaOperativaPresupuestal, String usuario);

    public int iduTareasOperativasPresupuestales(BeanTareaOperativaPresupuestal objBeanTareaOperativaPresupuestal, String usuario);

}
