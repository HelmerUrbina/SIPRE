/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanCalendarioGastos;
import BusinessServices.Beans.BeanPIMInforme;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface ConsultaEjecucionDAO {

    public List getListaConsultaEjecucion(BeanPIMInforme objBeanEjecucion, String usuario);

    public List getListaConsultaAmigable(BeanPIMInforme objBeanEjecucion, String usuario);

    public List getListaConsultaMensual(BeanCalendarioGastos objBeanEjecucion, String usuario);

}
