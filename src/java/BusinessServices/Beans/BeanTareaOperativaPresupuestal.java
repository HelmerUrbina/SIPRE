/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BusinessServices.Beans;

import java.io.Serializable;

/**
 *
 * @author H-URBINA-M
 */
public class BeanTareaOperativaPresupuestal implements Serializable {

    private String Mode;
    private String Codigo;
    private String Periodo;
    private String TareaOperativa;
    private String TareaPresupuestal;
    private String Estado;

    public String getMode() {
        return Mode;
    }

    public void setMode(String Mode) {
        this.Mode = Mode;
    }

    public String getCodigo() {
        return Codigo;
    }

    public void setCodigo(String Codigo) {
        this.Codigo = Codigo;
    }

    public String getPeriodo() {
        return Periodo;
    }

    public void setPeriodo(String Periodo) {
        this.Periodo = Periodo;
    }

    public String getTareaOperativa() {
        return TareaOperativa;
    }

    public void setTareaOperativa(String TareaOperativa) {
        this.TareaOperativa = TareaOperativa;
    }

    public String getTareaPresupuestal() {
        return TareaPresupuestal;
    }

    public void setTareaPresupuestal(String TareaPresupuestal) {
        this.TareaPresupuestal = TareaPresupuestal;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

}
