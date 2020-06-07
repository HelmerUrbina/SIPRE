/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanEstimacionIngresos;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface EstimacionIngresosDAO {

    public List getListaEstimacionIngresos(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario);

    public BeanEstimacionIngresos getEstimacionIngresos(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario);

    public int iduEstimacionIngresos(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario);

}
