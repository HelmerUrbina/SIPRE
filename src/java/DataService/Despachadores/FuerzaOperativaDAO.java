/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanFuerzaOperativa;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface FuerzaOperativaDAO {

    public List getListaFuerzaOperativa(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario);

    public List getListaFuerzaOperativaDetalle(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario);

    public BeanFuerzaOperativa getFuerzaOperativa(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario);

    public BeanFuerzaOperativa getFuerzaOperativaDetalle(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario);

    public int iduFuerzaOperativa(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario);

    public int iduFuerzaOperativaDetalle(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario);

    public List getListaEfectivoFuerOperativa(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario);

    public int iduEfectivoFuerzaOpe(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario);

    public int iduGenerarFuncionamientoFO(BeanFuerzaOperativa objBeanFuerzaOperativa, String usuario);

}
