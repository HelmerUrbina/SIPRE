/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanPlanillaMovilidad;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface PlanillaMovilidadDAO {

    public List getListaPlanillaMovilidad(BeanPlanillaMovilidad objBeanPlanillaMovilidad, String usuario);

    public int iduPlanillaMovilidad(BeanPlanillaMovilidad objBeanPlanillaMovilidad, String usuario);

    public BeanPlanillaMovilidad getPlanillaMovilidad(BeanPlanillaMovilidad objBeanPlanillaMovilidad, String usuario);

    public List getListaPlanillaConsolidado(BeanPlanillaMovilidad objBeanPlanillaMovilidad, String usuario);

    public int iduConsolidadoMovilidad(BeanPlanillaMovilidad objBeanPlanillaMovilidad, String usuario);
}
