/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanCadenaFuncional;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface CadenaFuncionalProgramacionDAO {

    public List getListaCadenaFuncional(BeanCadenaFuncional objBeanCadenaFuncional, String usuario);

    public String getSecuenciaFuncional(BeanCadenaFuncional objBeanCadenaFuncional, String usuario);

    public String getMetaPresupuestal(BeanCadenaFuncional objBeanCadenaFuncional, String usuario);

    public BeanCadenaFuncional getCadenaFuncional(BeanCadenaFuncional objBeanCadenaFuncional, String usuario);

    public int iduCadenaFuncional(BeanCadenaFuncional objBeanCadenaFuncional, String usuario);

}
