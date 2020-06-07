/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanPAAC;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface PAACDAO {

    public List getListaPAAC(BeanPAAC objBeanPAAC, String usuario);

    public BeanPAAC getPAAC(BeanPAAC objBeanPAAC, String usuario);
    
    public BeanPAAC getPAACMensualizar(BeanPAAC objBeanPAAC, String usuario);

    public int iduPAAC(BeanPAAC objBeanPAAC, String usuario);

}
