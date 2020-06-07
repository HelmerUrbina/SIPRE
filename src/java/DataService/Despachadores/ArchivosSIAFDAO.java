/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanArchivosSIAF;

/**
 *
 * @author H-URBINA-M
 */
public interface ArchivosSIAFDAO {

    public int iduMarcoPresupuestal(BeanArchivosSIAF objBeanArchivoSIAF, String usuario);

    public int iduCertificadoSIAF(BeanArchivosSIAF objBeanArchivoSIAF, String usuario);

    public int iduPriorizacionSIAF(BeanArchivosSIAF objBeanArchivoSIAF, String usuario);

    public int iduNotasModificatoriasSIAF(BeanArchivosSIAF objBeanArchivoSIAF, String usuario);

}
