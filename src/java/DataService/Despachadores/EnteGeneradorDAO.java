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
public interface EnteGeneradorDAO {

    public List getListaEnteGenerador(BeanEnteRecaudador objBeanEnteGenerador, String usuario);

    public BeanEnteRecaudador getEnteGenerador(BeanEnteRecaudador objBeanEnteGenerador, String usuario);      

    public int iduEnteGenerador(BeanEnteRecaudador objBeanEnteGenerador, String usuario);

    public int iduGeneraCNV(BeanEnteRecaudador objBeanEnteGenerador, String usuario);

    public String getCNV(BeanEnteRecaudador objBeanEnteGenerador, String usuario);
}
