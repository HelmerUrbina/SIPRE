/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import net.sourceforge.barbecue.Barcode;
import net.sourceforge.barbecue.BarcodeException;
import net.sourceforge.barbecue.BarcodeFactory;
import net.sourceforge.barbecue.BarcodeImageHandler;
import net.sourceforge.barbecue.output.OutputException;
/**
 *
 * @author helme
 */
public class BarCodeExample {

    public static void main(String[] args) {
        // Guardar Codigo de barras como imagen
        Barcode barcode = null;
        String strCode = "42134";
        try {
            barcode = BarcodeFactory.createCode39(strCode, true);//Reemplazar esto por el valor que deseen
        } catch (BarcodeException e) {
        }
        barcode.setDrawingText(true);//determina si se agrega o no el número codificado debajo del código de barras
        //tamaño de la barra
        barcode.setToolTipText("TEXTO");
        barcode.setLabel("asdfasd");
        barcode.setDrawingText(true);
        barcode.setBarWidth(2);
        barcode.setBarHeight(60);
        try {
            //Ruta y nombre del archivo PNG a crear
            String strFileName = "D:\\SIPRE\\BarCode_" + strCode + ".PNG";
            File file = new File(strFileName);
            FileOutputStream fos = new FileOutputStream(file);
            BarcodeImageHandler.writePNG(barcode, fos);//formato de ejemplo PNG
            System.out.println("Archivo creado: " + strFileName);
        } catch (FileNotFoundException | OutputException ex) {
            System.out.println("Error: " + ex.getMessage());
        }
    }
}
