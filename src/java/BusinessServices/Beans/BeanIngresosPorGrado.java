/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BusinessServices.Beans;

import java.io.Serializable;

/**
 *
 * @author H-TECCSI-V
 */

public class BeanIngresosPorGrado implements Serializable{
    public int codConcepto;
    public String desConcepto;
    public String codGrado;
    public String desGrado;
    public double ingresoGrado;
    public String periodo;
    public String Mode;
    public int nivelGrado;
    public String abvGrado;
    public String periodoRee;
    public String desPeriodo;

    public String getDesPeriodo() {
        return desPeriodo;
    }
    

    public void setDesPeriodo(String desPeriodo) {
        this.desPeriodo = desPeriodo;
    }
    
    public String getPeriodoRee() {
        return periodoRee;
    }

    public void setPeriodoRee(String periodoRee) {
        this.periodoRee = periodoRee;
    }    
    
    public String getAbvGrado() {
        return abvGrado;
    }

    public void setAbvGrado(String abvGrado) {
        this.abvGrado = abvGrado;
    }    
    
    public int getNivelGrado() {
        return nivelGrado;
    }

    public void setNivelGrado(int nivelGrado) {
        this.nivelGrado = nivelGrado;
    }    
    
    public String getMode() {
        return Mode;
    }

    public void setMode(String Mode) {
        this.Mode = Mode;
    }  
    
    public String getPeriodo() {
        return periodo;
    }

    public void setPeriodo(String periodo) {
        this.periodo = periodo;
    }    
    
    public int getCodConcepto() {
        return codConcepto;
    }

    public void setCodConcepto(int codConcepto) {
        this.codConcepto = codConcepto;
    }

    public String getDesConcepto() {
        return desConcepto;
    }

    public void setDesConcepto(String desConcepto) {
        this.desConcepto = desConcepto;
    }

    public String getCodGrado() {
        return codGrado;
    }

    public void setCodGrado(String codGrado) {
        this.codGrado = codGrado;
    }

    public String getDesGrado() {
        return desGrado;
    }

    public void setDesGrado(String desGrado) {
        this.desGrado = desGrado;
    }

    public double getIngresoGrado() {
        return ingresoGrado;
    }

    public void setIngresoGrado(double ingresoGrado) {
        this.ingresoGrado = ingresoGrado;
    }
    
        
}
