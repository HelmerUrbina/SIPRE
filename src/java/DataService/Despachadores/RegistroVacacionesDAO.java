/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanRegistroVacaciones;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface RegistroVacacionesDAO {

    public List getListaVacaciones(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario);

    public BeanRegistroVacaciones getVacacionesPersonal(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario);

    public int iduRegistroVacaciones(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario);

    public int getDiasDisponibles(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario);

    public List getListaConsolidadoVacaciones(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario);

    public ArrayList getListaVacacionesPersonal(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario);

    public int updRegistroVacaciones(BeanRegistroVacaciones objBeanRegistroVacaciones, String usuario);

}
