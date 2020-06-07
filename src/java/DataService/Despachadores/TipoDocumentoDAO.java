/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanTipoDocumento;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface TipoDocumentoDAO {

    public List getListaTipoDocumento(BeanTipoDocumento objBeanTipoDocumento, String usuario);

    public BeanTipoDocumento getTipoDocumento(BeanTipoDocumento objBeanTipoDocumento, String usuario);

    public int iduTipoDocumento(BeanTipoDocumento objBeanTipoDocumento, String usuario);
}
