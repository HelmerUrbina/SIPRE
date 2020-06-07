/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanUnidadOperativa;

import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface UnidadOperativaDAO {

    public List getListaUnidadesOperativas(String usuario);

    public BeanUnidadOperativa getUnidadOperativa(BeanUnidadOperativa objBeanUnidadOperativa, String usuario);

    public int iduUnidadOperativa(BeanUnidadOperativa objBeanUnidadOperativa, String usuario);

}
