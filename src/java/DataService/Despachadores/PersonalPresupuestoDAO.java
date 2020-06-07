/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanPersonalPresupuesto;
import java.util.List;


/**
 *
 * @author hateccsiv
 */
public interface PersonalPresupuestoDAO {
          
    public List getConsultaPersonalPresupuesto(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario);
    
    public List getconsultaPersonalPresupDet(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario);
    
    public List getconsultaPersonalPresupDetREE(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario);
    
    public int iduPersonalPresupuesto(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario);
    
    public String getImporteGrado(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario);
    
    public String getImporteRee(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario);
    
    public String getVerificarDatos(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario);
    
    public String getVerificarDatosRee(BeanPersonalPresupuesto objBeanPersonalPresupuesto, String usuario);
}
