/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BusinessServices.Beans;

import java.io.Serializable;
import java.sql.Blob;
import java.sql.Date;

/**
 *
 * @author heurbinam
 */
public class BeanRegistroPersonal implements Serializable {

    private String Mode;
    private String Dni;
    private String NombresPersonal;
    private String ApellidosPersonal;
    private String Direccion;
    private String Telefono;
    private Date FechaNacimiento;
    private String Ubigeo;
    private String AreaLaboral;
    private String Cargo;
    private String Foto;
    private String Estado;
    private String DocumentoFamiliar;
    private Integer CodigoFamiliar;
    private String Parentesco;
    private String NombreFamiliar;
    private String ApellidoFamiliar;
    private String TelefonoFamiliar;
    private String RutaFile;
    private String Grado;
    private Blob Imagen;

    public String getMode() {
        return Mode;
    }

    public void setMode(String Mode) {
        this.Mode = Mode;
    }

    public String getDni() {
        return Dni;
    }

    public void setDni(String Dni) {
        this.Dni = Dni;
    }

    public String getNombresPersonal() {
        return NombresPersonal;
    }

    public void setNombresPersonal(String NombresPersonal) {
        this.NombresPersonal = NombresPersonal;
    }

    public String getApellidosPersonal() {
        return ApellidosPersonal;
    }

    public void setApellidosPersonal(String ApellidosPersonal) {
        this.ApellidosPersonal = ApellidosPersonal;
    }

    public String getDireccion() {
        return Direccion;
    }

    public void setDireccion(String Direccion) {
        this.Direccion = Direccion;
    }

    public String getTelefono() {
        return Telefono;
    }

    public void setTelefono(String Telefono) {
        this.Telefono = Telefono;
    }

    public Date getFechaNacimiento() {
        return FechaNacimiento;
    }

    public void setFechaNacimiento(Date FechaNacimiento) {
        this.FechaNacimiento = FechaNacimiento;
    }

    public String getUbigeo() {
        return Ubigeo;
    }

    public void setUbigeo(String Ubigeo) {
        this.Ubigeo = Ubigeo;
    }

    public String getAreaLaboral() {
        return AreaLaboral;
    }

    public void setAreaLaboral(String AreaLaboral) {
        this.AreaLaboral = AreaLaboral;
    }

    public String getCargo() {
        return Cargo;
    }

    public void setCargo(String Cargo) {
        this.Cargo = Cargo;
    }

    public String getFoto() {
        return Foto;
    }

    public void setFoto(String Foto) {
        this.Foto = Foto;
    }

    public String getEstado() {
        return Estado;
    }

    public void setEstado(String Estado) {
        this.Estado = Estado;
    }

    public String getDocumentoFamiliar() {
        return DocumentoFamiliar;
    }

    public void setDocumentoFamiliar(String DocumentoFamiliar) {
        this.DocumentoFamiliar = DocumentoFamiliar;
    }

    public Integer getCodigoFamiliar() {
        return CodigoFamiliar;
    }

    public void setCodigoFamiliar(Integer CodigoFamiliar) {
        this.CodigoFamiliar = CodigoFamiliar;
    }

    public String getParentesco() {
        return Parentesco;
    }

    public void setParentesco(String Parentesco) {
        this.Parentesco = Parentesco;
    }

    public String getNombreFamiliar() {
        return NombreFamiliar;
    }

    public void setNombreFamiliar(String NombreFamiliar) {
        this.NombreFamiliar = NombreFamiliar;
    }

    public String getApellidoFamiliar() {
        return ApellidoFamiliar;
    }

    public void setApellidoFamiliar(String ApellidoFamiliar) {
        this.ApellidoFamiliar = ApellidoFamiliar;
    }

    public String getTelefonoFamiliar() {
        return TelefonoFamiliar;
    }

    public void setTelefonoFamiliar(String TelefonoFamiliar) {
        this.TelefonoFamiliar = TelefonoFamiliar;
    }

    public String getRutaFile() {
        return RutaFile;
    }

    public void setRutaFile(String RutaFile) {
        this.RutaFile = RutaFile;
    }

    public String getGrado() {
        return Grado;
    }

    public void setGrado(String Grado) {
        this.Grado = Grado;
    }

    public Blob getImagen() {
        return Imagen;
    }

    public void setImagen(Blob Imagen) {
        this.Imagen = Imagen;
    }
    
}
