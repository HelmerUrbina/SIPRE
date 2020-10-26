/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utiles;

import BusinessServices.Beans.BeanPIMInforme;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author H-URBINA-M
 */
public class ExportarExcel {

    public void ConsultaEjecucion(String nombreArchivo, List objConsulta) {
        // Creamos el archivo donde almacenaremos la hoja
        // de calculo, recuerde usar la extension correcta,
        // en este caso .xlsx
        File archivo = new File("D:\\SIPRE\\Temporal\\" + nombreArchivo + ".xlsx");
        // Creamos el libro de trabajo de Excel formato OOXML
        Workbook workbook = new XSSFWorkbook();
        // La hoja donde pondremos los datos
        Sheet pagina = workbook.createSheet("Consulta de Ejecucion");
        // Creamos el estilo paga las celdas del encabezado
        CellStyle style = workbook.createCellStyle();
        // Indicamos que tendra un fondo azul aqua con patron solido del color indicado
        style.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
      //  style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font cellFont = workbook.createFont();
       // cellFont.setBold(true);
        style.setFont(cellFont);
      //  style.setAlignment(HorizontalAlignment.CENTER);
      //  style.setVerticalAlignment(VerticalAlignment.CENTER);

        String[] titulos = {"Periodo", "Fuente Financiamiento", "UU/OO", "Categoria Presupuestal","Producto", "Actividad", "Sec. Funcional", "Finalidad","Tarea", "Cadena Gasto",
            "P.I.A.", "P.I.M.", "Certificado", "Saldo Certificado", "Compromiso", "Saldo Compromiso", "Ejecutado", "Saldo Ejecutado", "Generica de Gasto", "Sub Generica de Gasto", "Sub Generica Detalle"};

        // Creamos una fila en la hoja en la posicion 0
        Row fila = pagina.createRow(0);
        // Creamos el encabezado
        for (int i = 0; i < titulos.length; i++) {
            // Creamos una celda en esa fila, en la posicion indicada por el contador del ciclo
            Cell celda = fila.createCell(i);
            // Indicamos el estilo que deseamos usar en la celda, en este caso el unico que hemos creado
            celda.setCellStyle(style);
            celda.setCellValue(titulos[i]);
        }
        CellStyle style2 = workbook.createCellStyle();
        style2.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
       // style2.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        for (int i = 0; i < objConsulta.size(); i++) {
            BeanPIMInforme ejecucion = (BeanPIMInforme) objConsulta.get(i);
            // Creamos una celda en esa fila, en la posicion indicada por el contador del ciclo
            // Ahora creamos una fila en la posicion 1 y colocamos los datos en esa fila
            fila = pagina.createRow(1 + i);
            fila.createCell(0).setCellValue(ejecucion.getPeriodo());
            fila.createCell(1).setCellValue(ejecucion.getPresupuesto());
            fila.createCell(2).setCellValue(ejecucion.getUnidadOperativa());
            fila.createCell(3).setCellValue(ejecucion.getCategoriaPresupuestal());
            fila.createCell(4).setCellValue(ejecucion.getProducto());
            fila.createCell(5).setCellValue(ejecucion.getActividad());
            fila.createCell(6).setCellValue(ejecucion.getSecuencia());
            fila.createCell(7).setCellValue(ejecucion.getFuncion());
            fila.createCell(8).setCellValue(ejecucion.getTarea());
            fila.createCell(9).setCellValue(ejecucion.getCadenaGasto());
            fila.createCell(10).setCellValue(ejecucion.getPIA());
            fila.createCell(11).setCellValue(ejecucion.getPIM());
            fila.createCell(12).setCellValue(ejecucion.getCertificado());
            fila.createCell(13).setCellValue(ejecucion.getPIM() - ejecucion.getCertificado());
            fila.createCell(14).setCellValue(ejecucion.getNotaModificatoria());
            fila.createCell(15).setCellValue(ejecucion.getPIM() - ejecucion.getNotaModificatoria());
            fila.createCell(16).setCellValue(ejecucion.getInforme());
            fila.createCell(17).setCellValue(ejecucion.getPIM() - ejecucion.getInforme());
            fila.createCell(18).setCellValue(ejecucion.getGenericaGasto());
            fila.createCell(19).setCellValue(ejecucion.getSubGenerica());
            fila.createCell(20).setCellValue(ejecucion.getSubGenericaDetalle());            
        }
        for (int colNum = 0; colNum < fila.getLastCellNum(); colNum++) {
            workbook.getSheetAt(0).autoSizeColumn(colNum);
        }
        // Ahora guardaremos el archivo
        try {
            // Creamos el flujo de salida de datos,
            // apuntando al archivo donde queremos 
            // almacenar el libro de Excel
            FileOutputStream salida = new FileOutputStream(archivo);
            // Almacenamos el libro de 
            // Excel via ese 
            // flujo de datos
            workbook.write(salida);
            // Cerramos el libro para concluir operaciones
     //       workbook.close();
        } catch (FileNotFoundException ex) {
            System.out.println(ex.getMessage());
        } catch (IOException ex) {
            System.out.println(ex.getMessage());
        }

    }

}
