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
public interface ProgramacionMultianualEnteGeneradorDAO {

    public List getListaProgramacionMultianualEnteGenerador(BeanEnteRecaudador objBeanEnteGenerador, String usuario);
    
    public List getListaProgramacionMultianualEnteGeneradorDetalle(BeanEnteRecaudador objBeanEnteGenerador, String usuario);

    public BeanEnteRecaudador getProgramacionMultianualEnteGenerador(BeanEnteRecaudador objBeanEnteGenerador, String usuario);

    public int iduProgramacionMultianualEnteGenerador(BeanEnteRecaudador objBeanEnteGenerador, String usuario);

}
