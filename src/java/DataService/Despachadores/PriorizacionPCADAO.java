/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanPriorizacionPCA;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface PriorizacionPCADAO {

    public List getListaPriorizacionPCA(BeanPriorizacionPCA objBeanPriorizacion, String usuario);

    public ArrayList getListaPriorizacionPCADetalle(BeanPriorizacionPCA objBeanPriorizacion, String usuario);

    public ArrayList getListaPriorizacionPCAPendiente(BeanPriorizacionPCA objBeanPriorizacion, String usuario);

    public ArrayList getPriorizacionPCADetalle(BeanPriorizacionPCA objBeanPriorizacion, String usuario);

    public Integer getNumeroPriorizacionPCA(BeanPriorizacionPCA objBeanPriorizacion, String usuario);

    public int iduPriorizacionPCA(BeanPriorizacionPCA objBeanPriorizacion, String usuario);

    public int iduPriorizacionPCADetalle(BeanPriorizacionPCA objBeanPriorizacion, String usuario);

}
