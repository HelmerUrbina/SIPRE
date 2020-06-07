/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanDemandaAdicional;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface DemandaAdicionalDAO {

    public List getListaDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario);

    public BeanDemandaAdicional getDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario);
    
    public ArrayList getListaDetalleDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario);
    
    public ArrayList getListaMetaFisicaDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario);
    
    public Integer getCodigoDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario);

    public int iduDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario);

    public int iduDetalleDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario);
    
    public int iduMetaFisicaDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario);
    
    public int udpAprobacionDemandaAdicional(BeanDemandaAdicional objBeanDemandaAdicional, String usuario);

}
