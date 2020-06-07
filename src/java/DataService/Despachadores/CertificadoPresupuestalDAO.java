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
public interface CertificadoPresupuestalDAO {

    public List getListaCertificados(BeanEjecucionPresupuestal objBeanCertificado, String usuario);

    public List getListaCertificadosDetalle(BeanEjecucionPresupuestal objBeanCertificado, String usuario);

    public ArrayList getListaCertificadoDetalle(BeanEjecucionPresupuestal objBeanCertificado, String usuario);

    public String getNumeroCertificado(BeanEjecucionPresupuestal objBeanCertificado, String usuario);

    public BeanEjecucionPresupuestal getCertificado(BeanEjecucionPresupuestal objBeanCertificado, String usuario);

    public String iduCertificado(BeanEjecucionPresupuestal objBeanCertificado, String usuario);

    public int iduCertificadoDetalle(BeanEjecucionPresupuestal objBeanCertificado, String usuario);

    public int iduGenerarSolicitud(BeanEjecucionPresupuestal objBeanCertificado, String usuario);

    public int iduCertificadoSIAF(BeanEjecucionPresupuestal objBeanCertificado, String usuario);

}
