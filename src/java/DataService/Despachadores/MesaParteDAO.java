/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanMesaParte;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface MesaParteDAO {

    public List getListaMesaPartes(BeanMesaParte objBeanMesaParte, String usuario);

    public BeanMesaParte getMesaParte(BeanMesaParte objBeanMesaParte, String usuario);

    public String getNumeroDocumento(BeanMesaParte objBnMesaParte, String usuario);

    public String iduMesaParte(BeanMesaParte objBeanMesaParte, String usuario);

    public String getDocumentosPendientes(String usuario);

    public List getConsultaDocumentoRespuesta(BeanMesaParte objMesaParte, String usuario);

    public List getListaRemisionDocumento(BeanMesaParte objBeanMesaParte, String usuario);

    public String getNumeroDocumentoSalida(BeanMesaParte objBnMesaParte, String usuario);

    public List getConsultaMesaPartes(BeanMesaParte objBeanMesaParte, String usuario);
}
