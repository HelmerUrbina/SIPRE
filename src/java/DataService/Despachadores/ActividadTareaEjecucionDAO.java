/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanActividadTarea;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface ActividadTareaEjecucionDAO {

    public List getListaActividadTarea(BeanActividadTarea objBeanActividadTarea, String usuario);   

    public int iduActividadTarea(BeanActividadTarea objBeanActividadTarea, String usuario);

}
