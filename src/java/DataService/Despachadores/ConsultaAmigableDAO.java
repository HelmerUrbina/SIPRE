/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanConsultaAmigable;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface ConsultaAmigableDAO {

    public List getListaEjecutora(BeanConsultaAmigable objBeanAmigable, String usuario);
    
    //public List getListaEjecutora(BeanConsultaAmigable objBeanAmigable, String usuario);

}
