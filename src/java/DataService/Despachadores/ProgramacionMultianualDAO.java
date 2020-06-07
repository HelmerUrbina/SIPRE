/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanProgramacionPresupuestal;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface ProgramacionMultianualDAO {

    public List getListaProgramacionMultianual(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public List getListaProgramacionMultianualDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public ArrayList getDatosProgramacionMultianualDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public BeanProgramacionPresupuestal getProgramadoMultianual(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public BeanProgramacionPresupuestal getProgramadoMultianualDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public BeanProgramacionPresupuestal getProgramadoMultianualMetaFisica(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public BeanProgramacionPresupuestal getSaldoUtilidadEnteGenerador(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public BeanProgramacionPresupuestal getSaldoFuerzaOperativa(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public int iduProgramacionMultianual(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

    public int iduProgramacionMultianualDetalle(BeanProgramacionPresupuestal objBeanProgramacion, String usuario);

}
