/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanMesaParte;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface DecretoDAO {

    public List getConsultaDocumentos(BeanMesaParte objBnDecreto, String usuario);

    public int iduDecretarDocumento(BeanMesaParte objBnDecreto, String usuario);

    public BeanMesaParte getDecretoDocumento(BeanMesaParte objBeanDecreto, String usuario);

    public ArrayList getListaDetalleDocumentoDecretado(BeanMesaParte objBeanDecreto);

    public ArrayList getListaSeguimientoDecretado(BeanMesaParte objBeanDecreto);
}
