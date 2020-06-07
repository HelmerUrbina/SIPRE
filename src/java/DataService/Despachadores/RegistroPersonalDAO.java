/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanRegistroPersonal;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface RegistroPersonalDAO {

    public List getListaPersonal(BeanRegistroPersonal objBeanRegistroPersonal, String usuario);

    public BeanRegistroPersonal getPersonal(BeanRegistroPersonal objBeanRegistroPersonal, String usuario);

    public int iduRegistroPersonal(BeanRegistroPersonal objBeanRegistroPersonal, String usuario);

    public List getListaPersonalFamilia(BeanRegistroPersonal objBeanRegistroPersonal, String usuario);

    public ArrayList getDatosFamiliares(BeanRegistroPersonal objBeanRegistroPersonal, String usuario);

    public int iduRegistroFamiliar(BeanRegistroPersonal objBeanRegistroPersonal, String usuario);
}
