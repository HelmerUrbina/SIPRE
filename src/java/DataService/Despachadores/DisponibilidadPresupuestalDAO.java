/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanDisponibilidadPresupuestal;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface DisponibilidadPresupuestalDAO {

    public List getListaDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario);

    public List getListaDisponibilidadPresupuestalDetalle(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario);

    public ArrayList getListaDetalleDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario);

    public BeanDisponibilidadPresupuestal getDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario);
    
    public String getCodigoDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario);

    public int iduDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario);

    public int iduDisponibilidadPresupuestalDetalle(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario);

    public int iduEnvioDisponibilidadPresupuestal(BeanDisponibilidadPresupuestal objBeanDisponibilidad, String usuario);

}
