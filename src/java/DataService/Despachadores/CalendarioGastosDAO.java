/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanCalendarioGastos;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface CalendarioGastosDAO {

    public List getListaCalendarioGastos(BeanCalendarioGastos objBeanCalendarioGastos, String usuario);

    public List getListaCalendarioGastosDetalle(BeanCalendarioGastos objBeanCalendarioGastos, String usuario);

    public ArrayList getListaCalendarioGastoDetalle(BeanCalendarioGastos objBeanCalendarioGastos, String usuario);

    public int iduCalendarioGastoDetalle(BeanCalendarioGastos objBeanCalendarioGastos, String usuario);
}
