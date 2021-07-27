/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BusinessServices.Beans;

import java.io.Serializable;
import lombok.Data;

/**
 *
 * @author H-URBINA-M
 */
@Data
public class BeanEnteRecaudador implements Serializable {

    private String Mode;
    private String Periodo;
    private String UnidadOperativa;
    private String Mes;
    private String Clasificador;
    private String Descripcion;
    private String Estado;
    private Integer Presupuesto;
    private Integer EstimacionIngreso;
    private Integer Codigo;
    private Double Recaudacion;
    private Double Detraccion;
    private Double IGV;
    private Double UtilidadNeta;
    private Double UtilidadUO;
    private Double UtilidadUE;

}
