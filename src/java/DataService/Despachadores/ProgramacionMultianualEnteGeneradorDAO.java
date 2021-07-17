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
public interface ProgramacionMultianualEnteGeneradorDAO {

    public List getListaProgramacionMultianualEnteGenerador(BeanEnteGenerador objBeanEnteGenerador, String usuario);

    public List getListaProgramacionMultianualEnteGeneradorDetalle(BeanEnteGenerador objBeanEnteGenerador, String usuario);

    public BeanEnteGenerador getProgramacionMultianualEnteGenerador(BeanEnteGenerador objBeanEnteGenerador, String usuario);

    public int iduProgramacionMultianualEnteGenerador(BeanEnteGenerador objBeanEnteGenerador, String usuario);

}
