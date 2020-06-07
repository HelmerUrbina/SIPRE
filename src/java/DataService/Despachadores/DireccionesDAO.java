/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanDirecciones;

import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface DireccionesDAO {

    public List getListaDirecciones(String usuario);    

    public int iduDireccion(BeanDirecciones objBeanDireccion, String usuario);

}
