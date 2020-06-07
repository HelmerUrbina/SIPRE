/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanConsultaIngresoSalida;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface ConsultaIngresoSalidaDAO {

    public List getListaIngresoSalida(BeanConsultaIngresoSalida objBeanIngresoSalida, String usuario);

}
