/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanEjecucionPresupuestal;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface DeclaracionJuradaDAO {

    public List getListaDeclaracionJurada(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public List getListaDeclaracionJuradaDetalle(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public String getNumeroDeclaracionJurada(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public BeanEjecucionPresupuestal getTipoCalendarioCompromiso(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public BeanEjecucionPresupuestal getDeclaracionJurada(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public ArrayList getListaDetalleDeclaracionJurada(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public int iduDeclaracionJurada(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public int iduDeclaracionJuradaDetalle(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public int iduGenerarCoberturaMensual(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public int iduTransferirCobertura(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

}
