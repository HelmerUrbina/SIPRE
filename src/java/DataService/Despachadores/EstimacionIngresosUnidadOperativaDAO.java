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
public interface EstimacionIngresosUnidadOperativaDAO {
    
    public List getListaEstimacionIngresosUnidadOperativa(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario);

    public List getListaEstimacionIngresos(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario);

    public int iduEstimacionIngresosUnidadOperativa(BeanEstimacionIngresos objBeanEstimacionIngresos, String usuario);
    
}
