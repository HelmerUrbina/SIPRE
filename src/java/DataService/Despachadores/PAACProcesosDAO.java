/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanPAACProcesos;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface PAACProcesosDAO {

    public List getListaPAACProcesos(BeanPAACProcesos objBeanPAACProcesos, String usuario);

    public ArrayList getListaPAACProcesosDetalle(BeanPAACProcesos objBeanPAACProcesos, String usuario);

    public ArrayList getListaPAACProcesosAfectacion(BeanPAACProcesos objBeanPAACProcesos, String usuario);

    public BeanPAACProcesos getPAACProceso(BeanPAACProcesos objBeanPAACProcesos, String usuario);

    public BeanPAACProcesos getPAACProcesoDetalle(BeanPAACProcesos objBeanPAACProcesos, String usuario);

    public int iduPAACProcesos(BeanPAACProcesos objBeanPAACProcesos, String usuario);

    public int iduPAACProcesosDetalle(BeanPAACProcesos objBeanPAACProcesos, String usuario);

    public int iduPAACProcesosAfectacion(BeanPAACProcesos objBeanPAACProcesos, String usuario);

    public int iduPAACProcesosDetalleContratoAfectacion(BeanPAACProcesos objBeanPAACProcesos, String usuario);

}
