/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanIngresosPorGrado;
import java.util.List;

/**
 *
 * @author H-TECCSI-V
 */
public interface ConceptoIngresosDAO {

    public List getConsultaConceptoIngreso(BeanIngresosPorGrado objBnIngresosGrado, String usuario);

    public BeanIngresosPorGrado getConceptoIngresos(BeanIngresosPorGrado objBnIngresosGrado, String usuario);

    public int iduConceptoIngresos(BeanIngresosPorGrado objBnIngresosGrado, String usuario);

}
