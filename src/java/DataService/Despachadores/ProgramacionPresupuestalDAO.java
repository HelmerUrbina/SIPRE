/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanProgramacionPresupuestal;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface ProgramacionPresupuestalDAO {

    public List getListaProgramacion(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public List getListaProgramacionDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public BeanProgramacionPresupuestal getProgramado(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public BeanProgramacionPresupuestal getProgramadoDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public Double getSaldoProgramacion(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public Double getSaldoEnteGenerador(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public int iduProgramacion(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public int iduProgramacionDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

}
