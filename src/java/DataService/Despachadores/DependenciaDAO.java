/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanDependencia;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface DependenciaDAO {

    public List getListaDependencia(BeanDependencia objBeanDependencia, String usuario);

    public BeanDependencia getDependencia(BeanDependencia objBeanDependencia, String usuario);

    public int iduDependencia(BeanDependencia objBeanDependencia, String usuario);

}
