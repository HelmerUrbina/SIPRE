/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DataService.Despachadores;

import BusinessServices.Beans.BeanProveedores;
import java.util.List;

/**
 *
 * @author H-URBINA-M
 */
public interface ProveedoresDAO {

    public List getListaProveedores(String usuario);

    public BeanProveedores getProveedor(BeanProveedores objBeanProveedor, String usuario);

    public int iduProveedor(BeanProveedores objBeanProveedor, String usuario);

}
