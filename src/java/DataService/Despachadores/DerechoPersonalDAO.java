/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanDerechoPersonal;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface DerechoPersonalDAO {

    public ArrayList getListaPedidoJADPE(BeanDerechoPersonal objBeanDerechoPersonal, String usuario);

    public ArrayList getListaBeneficiarioJADPE(BeanDerechoPersonal objBeanDerechoPersonal, String usuario);

    public int iduRelacionJADPE(BeanDerechoPersonal objBeanDerechoPersonal, String usuario);

    public List getConsultaJADPE(BeanDerechoPersonal objBeanDerechoPersonal, String usuario);

}
