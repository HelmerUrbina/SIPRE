/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanResolucionesAdministrativas;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface ResolucionesAdministrativasDAO {

    public List getListaResolucionesAdministrativas(BeanResolucionesAdministrativas objBeanResoluaciones, String usuario);

    public List getListaResolucionesAdministrativasDetalle(BeanResolucionesAdministrativas objBeanResoluaciones, String usuario);

    public ArrayList getListaResolucionAdministrativaDetalle(BeanResolucionesAdministrativas objBeanResoluaciones, String usuario);

    public int iduResolucionesAdministrativas(BeanResolucionesAdministrativas objBeanResoluaciones, String usuario);

}
