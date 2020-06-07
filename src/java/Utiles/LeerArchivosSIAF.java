/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utiles;

import BusinessServices.Beans.BeanArchivosSIAF;
import DataService.Despachadores.ArchivosSIAFDAO;
import DataService.Despachadores.Impl.ArchivosSIAFDAOImpl;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

/**
 *
 * @author H-URBINA-M
 */
public class LeerArchivosSIAF {

    private static ArchivosSIAFDAO objDsArchivos;
    private static BeanArchivosSIAF archivosSIAF = null;
    private static final String location = "D:\\SIPRE\\SIAF\\ArchivosSIAF\\";

    public static String subirMarcoPresupuestal(File archivo, Connection objConnection, String usuario) throws ParseException {
        InputStream excelStream = null;
        try {
            excelStream = new FileInputStream(location + archivo);
            // Representación del más alto nivel de la hoja excel.
            HSSFWorkbook hssfWorkbook = new HSSFWorkbook(excelStream);
            // Elegimos la hoja que se pasa por parámetro.
            HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(0);
            // Objeto que nos permite leer un fila de la hoja excel, y de aquí extraer el contenido de las celdas.
            HSSFRow hssfRow;
            // Obtengo el número de filas ocupadas en la hoja
            int rows = hssfSheet.getLastRowNum();
            objDsArchivos = new ArchivosSIAFDAOImpl(objConnection);
            // Para este ejemplo vamos a recorrer las filas obteniendo los datos que queremos
            for (int r = 1; r <= rows; r++) {
                hssfRow = hssfSheet.getRow(r);
                if (hssfRow == null) {
                    break;
                } else {
                    archivosSIAF = new BeanArchivosSIAF();
                    archivosSIAF.setMode("I");
                    archivosSIAF.setPeriodo(hssfRow.getCell(0).getStringCellValue());
                    archivosSIAF.setSecuenciaFuncional(hssfRow.getCell(4).getStringCellValue());
                    archivosSIAF.setCategoriaPresupuestal(hssfRow.getCell(5).getStringCellValue());
                    archivosSIAF.setProducto(hssfRow.getCell(6).getStringCellValue());
                    archivosSIAF.setActividad(hssfRow.getCell(7).getStringCellValue());
                    archivosSIAF.setFuncion(hssfRow.getCell(8).getStringCellValue());
                    archivosSIAF.setDivisionFuncional(hssfRow.getCell(9).getStringCellValue());
                    archivosSIAF.setGrupoFuncional(hssfRow.getCell(10).getStringCellValue());
                    archivosSIAF.setMeta(hssfRow.getCell(11).getStringCellValue());
                    archivosSIAF.setFinalidad(hssfRow.getCell(12).getStringCellValue());
                    archivosSIAF.setUnidadMedida(hssfRow.getCell(13).getStringCellValue());
                    archivosSIAF.setMontoNacional(hssfRow.getCell(14).getNumericCellValue());
                    archivosSIAF.setPresupuesto(hssfRow.getCell(19).getStringCellValue());
                    archivosSIAF.setTipoTransaccion(hssfRow.getCell(23).getStringCellValue());
                    archivosSIAF.setGenericaGasto(hssfRow.getCell(24).getStringCellValue());
                    archivosSIAF.setSubGenericaGasto(hssfRow.getCell(25).getStringCellValue());
                    archivosSIAF.setSubGenericaDetalleGasto(hssfRow.getCell(26).getStringCellValue());
                    archivosSIAF.setEspecificaGasto(hssfRow.getCell(27).getStringCellValue());
                    archivosSIAF.setEspecificaDetalleGasto(hssfRow.getCell(28).getStringCellValue());
                    archivosSIAF.setMonto(hssfRow.getCell(29).getNumericCellValue());
                    archivosSIAF.setPIM(hssfRow.getCell(31).getNumericCellValue());
                    archivosSIAF.setEnero(hssfRow.getCell(32).getNumericCellValue());
                    archivosSIAF.setFebrero(hssfRow.getCell(33).getNumericCellValue());
                    archivosSIAF.setMarzo(hssfRow.getCell(34).getNumericCellValue());
                    archivosSIAF.setAbril(hssfRow.getCell(35).getNumericCellValue());
                    archivosSIAF.setMayo(hssfRow.getCell(36).getNumericCellValue());
                    archivosSIAF.setJunio(hssfRow.getCell(37).getNumericCellValue());
                    archivosSIAF.setJulio(hssfRow.getCell(38).getNumericCellValue());
                    archivosSIAF.setAgosto(hssfRow.getCell(39).getNumericCellValue());
                    archivosSIAF.setSetiembre(hssfRow.getCell(40).getNumericCellValue());
                    archivosSIAF.setOctubre(hssfRow.getCell(41).getNumericCellValue());
                    archivosSIAF.setNoviembre(hssfRow.getCell(42).getNumericCellValue());
                    archivosSIAF.setDiciembre(hssfRow.getCell(43).getNumericCellValue());
                    archivosSIAF.setEjecucion(hssfRow.getCell(44).getNumericCellValue());
                    archivosSIAF.setSaldo(hssfRow.getCell(45).getNumericCellValue());
                    objDsArchivos.iduMarcoPresupuestal(archivosSIAF, usuario);
                }
            }
        } catch (FileNotFoundException fileNotFoundException) {
            return "No se encontró el fichero: " + fileNotFoundException;
        } catch (IOException ex) {
            return "Error al procesar el fichero: " + ex.getMessage();
        } finally {
            try {
                excelStream.close();
            } catch (IOException ex) {
                return "Error al procesar el fichero después de cerrarlo: " + ex.getMessage();
            }
        }
        return null;
    }

    public static String subirCertificadoSIAF(File archivo, Connection objConnection, String usuario) throws ParseException {
        InputStream excelStream = null;
        try {
            excelStream = new FileInputStream(location + archivo);
            // Representación del más alto nivel de la hoja excel.
            HSSFWorkbook hssfWorkbook = new HSSFWorkbook(excelStream);
            // Elegimos la hoja que se pasa por parámetro.
            HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(0);
            // Objeto que nos permite leer un fila de la hoja excel, y de aquí extraer el contenido de las celdas.
            HSSFRow hssfRow;
            // Obtengo el número de filas ocupadas en la hoja
            int rows = hssfSheet.getLastRowNum();
            objDsArchivos = new ArchivosSIAFDAOImpl(objConnection);
            // Para este ejemplo vamos a recorrer las filas obteniendo los datos que queremos
            for (int r = 1; r <= rows; r++) {
                hssfRow = hssfSheet.getRow(r);
                if (hssfRow == null) {
                    break;
                } else {
                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
                    sdf.setLenient(false); //No Complaciente en Fecha        
                    java.util.Date fechaDocumento = sdf.parse(hssfRow.getCell(8).toString());
                    archivosSIAF = new BeanArchivosSIAF();
                    archivosSIAF.setMode("I");
                    archivosSIAF.setPeriodo(hssfRow.getCell(0).getStringCellValue());
                    archivosSIAF.setEjecutora(hssfRow.getCell(1).getStringCellValue());
                    archivosSIAF.setCertificado(hssfRow.getCell(2).getStringCellValue());
                    archivosSIAF.setSecuencia(hssfRow.getCell(3).getStringCellValue());
                    archivosSIAF.setCorrelativo(hssfRow.getCell(4).getStringCellValue());
                    archivosSIAF.setPresupuesto(hssfRow.getCell(5).getStringCellValue());
                    archivosSIAF.setDocumento(hssfRow.getCell(6).getStringCellValue());
                    archivosSIAF.setNumeroDocumento(hssfRow.getCell(7).getStringCellValue());
                    archivosSIAF.setFechaDocumento(new java.sql.Date(fechaDocumento.getTime()));
                    archivosSIAF.setRUC(hssfRow.getCell(9).toString());
                    archivosSIAF.setCadenaGasto(hssfRow.getCell(10).getStringCellValue());
                    archivosSIAF.setSecuenciaFuncional(hssfRow.getCell(11).getStringCellValue());
                    archivosSIAF.setMoneda(hssfRow.getCell(12).getStringCellValue());
                    archivosSIAF.setTipoCambio(hssfRow.getCell(13).getNumericCellValue());
                    archivosSIAF.setMonto(hssfRow.getCell(14).getNumericCellValue());
                    archivosSIAF.setMontoNacional(hssfRow.getCell(15).getNumericCellValue());
                    archivosSIAF.setEstado(hssfRow.getCell(18).getStringCellValue());
                    archivosSIAF.setRegistroTipo(hssfRow.getCell(19).getStringCellValue());
                    archivosSIAF.setTipoRegistro(hssfRow.getCell(20).getStringCellValue());
                    archivosSIAF.setEstadoRegistro(hssfRow.getCell(21).getStringCellValue());
                    archivosSIAF.setEstadoEnvio(hssfRow.getCell(22).getStringCellValue());
                    archivosSIAF.setTipoTransaccion(hssfRow.getCell(10).getStringCellValue().substring(0, 1));
                    archivosSIAF.setGenericaGasto(hssfRow.getCell(10).getStringCellValue().substring(2, 3));
                    archivosSIAF.setSubGenericaGasto(hssfRow.getCell(10).getStringCellValue().substring(4, 6));
                    archivosSIAF.setSubGenericaDetalleGasto(hssfRow.getCell(10).getStringCellValue().substring(6, 8));
                    archivosSIAF.setEspecificaGasto(hssfRow.getCell(10).getStringCellValue().substring(9, 11));
                    archivosSIAF.setEspecificaDetalleGasto(hssfRow.getCell(10).getStringCellValue().substring(11, 13));
                    objDsArchivos.iduCertificadoSIAF(archivosSIAF, usuario);
                }
            }
        } catch (FileNotFoundException fileNotFoundException) {
            return "No se encontró el fichero: " + fileNotFoundException;
        } catch (IOException ex) {
            return "Error al procesar el fichero: " + ex.getMessage();
        } finally {
            try {
                excelStream.close();
            } catch (IOException ex) {
                return "Error al procesar el fichero después de cerrarlo: " + ex.getMessage();
            }
        }
        return null;
    }

    public static String subirPriorizacionSIAF(File archivo, Connection objConnection, String usuario) throws ParseException {
        InputStream excelStream = null;
        try {
            excelStream = new FileInputStream(location + archivo);
            // Representación del más alto nivel de la hoja excel.
            HSSFWorkbook hssfWorkbook = new HSSFWorkbook(excelStream);
            // Elegimos la hoja que se pasa por parámetro.
            HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(0);
            // Objeto que nos permite leer un fila de la hoja excel, y de aquí extraer el contenido de las celdas.
            HSSFRow hssfRow;
            // Obtengo el número de filas ocupadas en la hoja
            int rows = hssfSheet.getLastRowNum();
            objDsArchivos = new ArchivosSIAFDAOImpl(objConnection);
            // Para este ejemplo vamos a recorrer las filas obteniendo los datos que queremos
            for (int r = 1; r <= rows; r++) {
                hssfRow = hssfSheet.getRow(r);
                if (hssfRow == null) {
                    break;
                } else {
                    archivosSIAF = new BeanArchivosSIAF();
                    archivosSIAF.setMode("I");
                    archivosSIAF.setPeriodo(hssfRow.getCell(0).getStringCellValue());
                    archivosSIAF.setPresupuesto(hssfRow.getCell(5).getStringCellValue());
                    archivosSIAF.setTipoTransaccion(hssfRow.getCell(9).getStringCellValue());
                    archivosSIAF.setGenericaGasto(hssfRow.getCell(10).getStringCellValue());
                    archivosSIAF.setSubGenericaGasto(hssfRow.getCell(11).getStringCellValue());
                    archivosSIAF.setSubGenericaDetalleGasto(hssfRow.getCell(12).getStringCellValue());
                    archivosSIAF.setEspecificaGasto(hssfRow.getCell(13).getStringCellValue());
                    archivosSIAF.setEspecificaDetalleGasto(hssfRow.getCell(14).getStringCellValue());
                    archivosSIAF.setMonto(hssfRow.getCell(15).getNumericCellValue());
                    archivosSIAF.setPIM(hssfRow.getCell(16).getNumericCellValue());
                    archivosSIAF.setEnero(hssfRow.getCell(17).getNumericCellValue());
                    archivosSIAF.setFebrero(hssfRow.getCell(18).getNumericCellValue());
                    archivosSIAF.setMarzo(hssfRow.getCell(19).getNumericCellValue());
                    objDsArchivos.iduPriorizacionSIAF(archivosSIAF, usuario);
                }
            }
        } catch (FileNotFoundException fileNotFoundException) {
            return "No se encontró el fichero: " + fileNotFoundException;
        } catch (IOException ex) {
            return "Error al procesar el fichero: " + ex.getMessage();
        } finally {
            try {
                excelStream.close();
            } catch (IOException ex) {
                return "Error al procesar el fichero después de cerrarlo: " + ex.getMessage();
            }
        }
        return null;
    }

    public static String subirNotasModificatoriasSIAF(File archivo, Connection objConnection, String usuario) throws ParseException {
        InputStream excelStream = null;
        try {
            excelStream = new FileInputStream(location + archivo);
            // Representación del más alto nivel de la hoja excel.
            HSSFWorkbook hssfWorkbook = new HSSFWorkbook(excelStream);
            // Elegimos la hoja que se pasa por parámetro.
            HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(0);
            // Objeto que nos permite leer un fila de la hoja excel, y de aquí extraer el contenido de las celdas.
            HSSFRow hssfRow;
            // Obtengo el número de filas ocupadas en la hoja
            int rows = hssfSheet.getLastRowNum();
            objDsArchivos = new ArchivosSIAFDAOImpl(objConnection);
            // Para este ejemplo vamos a recorrer las filas obteniendo los datos que queremos
            for (int r = 1; r <= rows; r++) {
                hssfRow = hssfSheet.getRow(r);
                if (hssfRow == null) {
                    break;
                } else {
                    archivosSIAF = new BeanArchivosSIAF();
                    archivosSIAF.setMode("I");
                    archivosSIAF.setPeriodo(hssfRow.getCell(0).getStringCellValue());
                    archivosSIAF.setCorrelativo(hssfRow.getCell(3).getStringCellValue());
                    archivosSIAF.setEjecutora(hssfRow.getCell(5).getStringCellValue());
                    archivosSIAF.setTipoRegistro(hssfRow.getCell(7).getStringCellValue());
                    archivosSIAF.setDocumento(hssfRow.getCell(9).getStringCellValue());
                    archivosSIAF.setEstado(hssfRow.getCell(16).getStringCellValue());
                    archivosSIAF.setPresupuesto(hssfRow.getCell(20).getStringCellValue());
                    archivosSIAF.setSecuenciaFuncional(hssfRow.getCell(24).getStringCellValue());
                    archivosSIAF.setTipoTransaccion(hssfRow.getCell(25).getStringCellValue());
                    archivosSIAF.setGenericaGasto(hssfRow.getCell(27).getStringCellValue());
                    archivosSIAF.setSubGenericaGasto(hssfRow.getCell(28).getStringCellValue());
                    archivosSIAF.setSubGenericaDetalleGasto(hssfRow.getCell(29).getStringCellValue());
                    archivosSIAF.setEspecificaGasto(hssfRow.getCell(30).getStringCellValue());
                    archivosSIAF.setEspecificaDetalleGasto(hssfRow.getCell(31).getStringCellValue());
                    archivosSIAF.setCategoriaPresupuestal(hssfRow.getCell(32).getStringCellValue());
                    archivosSIAF.setProducto(hssfRow.getCell(33).getStringCellValue());
                    archivosSIAF.setActividad(hssfRow.getCell(34).getStringCellValue());
                    archivosSIAF.setFuncion(hssfRow.getCell(35).getStringCellValue());
                    archivosSIAF.setDivisionFuncional(hssfRow.getCell(36).getStringCellValue());
                    archivosSIAF.setGrupoFuncional(hssfRow.getCell(37).getStringCellValue());
                    archivosSIAF.setMeta(hssfRow.getCell(38).getStringCellValue());
                    archivosSIAF.setFinalidad(hssfRow.getCell(39).getStringCellValue());
                    archivosSIAF.setMonto(hssfRow.getCell(40).getNumericCellValue());
                    archivosSIAF.setPIM(hssfRow.getCell(41).getNumericCellValue());
                    objDsArchivos.iduNotasModificatoriasSIAF(archivosSIAF, usuario);
                }
            }
        } catch (FileNotFoundException fileNotFoundException) {
            return "No se encontró el fichero: " + fileNotFoundException;
        } catch (IOException ex) {
            return "Error al procesar el fichero: " + ex.getMessage();
        } finally {
            try {
                excelStream.close();
            } catch (IOException ex) {
                return "Error al procesar el fichero después de cerrarlo: " + ex.getMessage();
            }
        }
        return null;
    }

}
