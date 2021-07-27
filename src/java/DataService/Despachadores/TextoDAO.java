/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface TextoDAO {

    public List getItem(String busqueda);

    public String getCategoriaPresupuesta(String codigo);

    public String getProducto(String codigo);

    public String getActividad(String codigo);

    public String getFuncion(String codigo);

    public String getDivisionFuncional(String codigo);

    public String getGrupoFuncional(String codigo);

    //MESA DE PARTES
    public List getInstitucion(String busqueda);

    //EJECUCION PRESUPUESTAL    
    public String getMensualizarNotaModificatoria(String periodo, String presupuesto, String unidadOperativa, String resolucion,
            String tipoCalendario, String dependencia, String secuenciaFuncional, String tarea, String cadenaGasto);
    
    public String getIGV(String codigo);

}
