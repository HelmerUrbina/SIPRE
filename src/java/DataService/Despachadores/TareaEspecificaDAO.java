/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanTareaEspecifica;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface TareaEspecificaDAO {

    public List getListaTareasEspecificas(BeanTareaEspecifica objBeanTareaEspecifica, String usuario);

    public ArrayList getCadenaGasto(BeanTareaEspecifica objBeanTareaEspecifica, String usuario);

    public int iduTareasEspecificas(BeanTareaEspecifica objBeanTareaEspecifica, String usuario);

}
