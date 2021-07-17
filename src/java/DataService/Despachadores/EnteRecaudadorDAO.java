/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanEnteRecaudador;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface EnteRecaudadorDAO {

    public List getListaEnteRecaudador(BeanEnteRecaudador objBeanEnteRecaudador);

    public BeanEnteRecaudador getEnteRecaudador(BeanEnteRecaudador objBeanEnteRecaudador);

    public int iduEnteRecaudador(BeanEnteRecaudador objBeanEnteRecaudador, String usuario);

}
