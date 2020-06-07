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
public interface ConsolidadoNotaModificatoriaDAO {

    public List getListaConsolidadoNotasModificatorias(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public List getListaConsolidadoNotasModificatoriasDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public List getListaConsolidadoNotaModificatoriaSIAF(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public ArrayList getConsolidadoNotaModificatoriaVerificada(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public ArrayList getConsolidadoNotaModificatoriaDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public String getCodigoConsolidadoNota(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);
    
    public BeanNotaModificatoria getConsolidadoNotaModificatoriaInforme(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public int iduConsolidarNotaModificatoria(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);

    public int iduConsolidadoNotaModificatoriaDetalle(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);
    
    public int eliminaDetalleConsolidadoNotaModificatoria(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);
    
    public int iduConsolidadoNotaModificatoriaInforme(BeanNotaModificatoria objBeanNotaModificatoria, String usuario);
}
