/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanNotaModificatoria;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface NotaModificatoriaDAO {

    public List getListaNotasModificatorias(BeanNotaModificatoria objBeanEjecucionPresupuestal, String usuario);

    public List getListaNotasModificatoriasDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public ArrayList getListaNotaModificatoriaDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public ArrayList getListaNotaModificatoriaMetaFisica(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public BeanNotaModificatoria getNotaModificatoria(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public BeanNotaModificatoria getNotaModificatoriaInforme(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public String getNumeroNotaModificatoria(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public int iduNotaModificatoria(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public int iduNotaModificatoriaDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public int iduNotaModificatoriaDetalleMensualizacion(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public int iduNotaModificatoriaMetaFisica(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public int iduNotaModificatoriaInforme(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public int iduNotaModificatoriaVerifica(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

}
