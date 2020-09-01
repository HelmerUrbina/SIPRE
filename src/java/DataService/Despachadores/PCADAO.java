/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanPCA;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface PCADAO {

    public List getListaPCA(BeanPCA objBeanPCA, String usuario);

    public ArrayList getListaPCAUnidadOperativa(BeanPCA objBeanPCA, String usuario);
    
    public ArrayList getListaPCAVAriacion(BeanPCA objBeanPCA, String usuario);

    public Integer getAutorizacionPCA(BeanPCA objBeanPCA, String usuario);

    public int iduPCA(BeanPCA objBeanPCA, String usuario);

}
