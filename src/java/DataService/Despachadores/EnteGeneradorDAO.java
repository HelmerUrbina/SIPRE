/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanEnteGenerador;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface EnteGeneradorDAO {

    public List getListaEnteGenerador(BeanEnteGenerador objBeanEnteGenerador, String usuario);

    public BeanEnteGenerador getEnteGenerador(BeanEnteGenerador objBeanEnteGenerador, String usuario);      

    public int iduEnteGenerador(BeanEnteGenerador objBeanEnteGenerador, String usuario);

    public int iduGeneraCNV(BeanEnteGenerador objBeanEnteGenerador, String usuario);

    public String getCNV(BeanEnteGenerador objBeanEnteGenerador, String usuario);
}
