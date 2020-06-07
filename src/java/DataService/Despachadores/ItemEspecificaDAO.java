/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanItemEspecifica;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface ItemEspecificaDAO {

    public List getListaItemEspecifica(String cadenaGasto, String usuario);

    public ArrayList getItem(String busqueda);

    public ArrayList getItemAsignados(String cadenaGasto, String usuario);

    public int iduItemEspecifica(BeanItemEspecifica objBeanItemEspecifica, String usuario);

    public int eliminarItemEspecifica(BeanItemEspecifica objBeanItemEspecifica, String usuario);

}
