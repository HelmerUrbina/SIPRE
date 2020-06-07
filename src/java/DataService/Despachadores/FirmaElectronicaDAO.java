/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanFirmaElectronica;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface FirmaElectronicaDAO {

    public List getListaCertificadosPresupuestales(BeanFirmaElectronica objBeanFirmaElectronica, String usuario);

    public List getListaCompromisosAnuales(BeanFirmaElectronica objBeanFirmaElectronica, String usuario);

    public List getListaCompromisosMensuales(BeanFirmaElectronica objBeanFirmaElectronica, String usuario);

    public List getListaDisponibilidadPresupuestal(BeanFirmaElectronica objBeanFirmaElectronica, String usuario);

    public List getListaFirmaUnidad(BeanFirmaElectronica objBeanFirmaElectronica, String usuario);
    
    public String getCodigoFirma(BeanFirmaElectronica objBeanFirmaElectronica, String usuario);

    public int iduFirmaElectronica(BeanFirmaElectronica objBeanFirmaElectronica, String usuario);

    public int iduFirma(BeanFirmaElectronica objBeanFirmaElectronica, String usuario);

}
