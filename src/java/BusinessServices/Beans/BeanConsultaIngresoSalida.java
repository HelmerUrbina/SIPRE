/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BusinessServices.Beans;

import java.io.Serializable;
import java.sql.Date;

/**
 *
 * @author H-TECCSI-V
 */
public class BeanConsultaIngresoSalida implements Serializable {

    private String Mode;
    private String IdUsuario;
    private String Nombre;
    private Date FechaMarcacion;
    private String HoraEntrada;
    private String HoraSalida;

    public String getMode() {
        return Mode;
    }

    public void setMode(String Mode) {
        this.Mode = Mode;
    }

    public String getIdUsuario() {
        return IdUsuario;
    }

    public void setIdUsuario(String IdUsuario) {
        this.IdUsuario = IdUsuario;
    }

    public String getNombre() {
        return Nombre;
    }

    public void setNombre(String Nombre) {
        this.Nombre = Nombre;
    }

    public Date getFechaMarcacion() {
        return FechaMarcacion;
    }

    public void setFechaMarcacion(Date FechaMarcacion) {
        this.FechaMarcacion = FechaMarcacion;
    }

    public String getHoraEntrada() {
        return HoraEntrada;
    }

    public void setHoraEntrada(String HoraEntrada) {
        this.HoraEntrada = HoraEntrada;
    }

    public String getHoraSalida() {
        return HoraSalida;
    }

    public void setHoraSalida(String HoraSalida) {
        this.HoraSalida = HoraSalida;
    }

}
