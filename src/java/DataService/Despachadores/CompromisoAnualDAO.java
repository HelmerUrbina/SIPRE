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
public interface CompromisoAnualDAO {

    public List getListaCompromisosAnuales(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public List getListaCompromisosAnualesDetalle(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public ArrayList getListaCompromisoAnualDetalle(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public String getNumeroCompromisoAnual(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public String getTipoCalendarioSolicitud(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public BeanEjecucionPresupuestal getCompromisoAnual(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public int iduCompromisoAnual(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public int iduCompromisoAnualDetalle(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

    public int iduTransferirCompromisoAnual(BeanEjecucionPresupuestal objBeanEjecucionPresupuestal, String usuario);

}
