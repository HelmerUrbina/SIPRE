/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanHoraVuelo;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface HoraVueloDAO {

    public List getListaHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario);

    public BeanHoraVuelo getHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario);

    public int iduHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario);

    public List getListaCosteoHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario);

    public int iduCosteoHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario);

    public BeanHoraVuelo getCosteoHoraVuelo(BeanHoraVuelo objBeanHoraVuelo, String usuario);

    public String getCostoAeronaveHV(BeanHoraVuelo objBeanHoraVuelo, String usuario);

    public String getCosteoAeronaveHVEntidades(BeanHoraVuelo objBeanHoraVuelo, String usuario);

    public int iduHoraVueloCNV(BeanHoraVuelo objBeanHoraVuelo, String usuario);

    public String getCodigoHoraVueloCNV(BeanHoraVuelo objBeanHoraVuelo, String usuario);

}
