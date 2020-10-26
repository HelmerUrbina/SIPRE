/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanPersonal;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author H-TECCSI-V
 */
public interface PersonalDAO {

    public List getListaPersonal(String usuario);

    public List getListaPersonalFamilia(String usuario);

    public BeanPersonal getPersonal(BeanPersonal objBeanPersonal, String usuario);

    public ArrayList getDatosFamiliares(BeanPersonal objBeanPersonal, String usuario);

    public int iduPersonal(BeanPersonal objBeanPersonal, String usuario);

    public int iduFamilia(BeanPersonal objBeanPersonal, String usuario);

    public byte[] getImagen(Integer persona);
}
