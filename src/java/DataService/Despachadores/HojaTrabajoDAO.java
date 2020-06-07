/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanHojaTrabajo;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface HojaTrabajoDAO {

    public List getListaHojaTrabajo(BeanHojaTrabajo objBeanHojaTrabajo, String usuario);

    public BeanHojaTrabajo getHojaTrabajo(BeanHojaTrabajo objBeanHojaTrabajo, String usuario);

    public Double getSaldoHojaTrabajo(BeanHojaTrabajo objBeanHojaTrabajo, String usuario);

    public int iduHojaTrabajo(BeanHojaTrabajo objBeanHojaTrabajo, String usuario);

}
