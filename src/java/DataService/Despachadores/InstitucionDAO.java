/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanInstitucion;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface InstitucionDAO {

    public List getListaInstitucion(BeanInstitucion objBeanInstitucion, String usuario);

    public BeanInstitucion getInstitucion(BeanInstitucion objBeanInstitucion, String usuario);

    public int iduInstitucion(BeanInstitucion objBeanInstitucion, String usuario);

}
