/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanEjecucionEstado;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface EjecucionEstadoDAO {

    public List getListaEjecucionEstado(BeanEjecucionEstado objBeanEjecucionEstado, String usuario);

    public Integer getCodigoEjecucionEstado(BeanEjecucionEstado objBeanEjecucionEstado, String usuario);

    public int iduEjecucionEstado(BeanEjecucionEstado objBeanEjecucionEstado, String usuario);

}
