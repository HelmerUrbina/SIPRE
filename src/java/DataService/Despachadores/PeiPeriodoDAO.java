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
public interface PeiPeriodoDAO {

    public List getListaPeiPeriodo(String usuario);

    public BeanPlaneamiento getPeiPeriodo(BeanPlaneamiento objBeanPeiPeriodo, String usuario);

    public int iduPeiPeriodo(BeanPlaneamiento objBeanPeiPeriodo, String usuario);

}
