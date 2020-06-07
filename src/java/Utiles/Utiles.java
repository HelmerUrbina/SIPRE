package Utiles;

import java.awt.print.PrinterException;
import java.awt.print.PrinterJob;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.print.DocFlavor;
import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.print.attribute.HashPrintRequestAttributeSet;
import javax.print.attribute.PrintRequestAttributeSet;
import javax.print.attribute.PrintServiceAttributeSet;
import javax.print.attribute.standard.Copies;
import javax.print.attribute.standard.PrinterState;
import javax.print.attribute.standard.PrinterStateReason;
import javax.servlet.http.Part;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JRPrintServiceExporter;
import net.sf.jasperreports.engine.export.JRPrintServiceExporterParameter;

public class Utiles {

    public static String checkStr(String dato) {
        if (dato == null) {
            return "";
        }
        return dato;
    }

    public static Integer checkNum(String dato) {
        if (dato == null) {
            return 0;
        }
        if (dato.equals("")) {
            return 0;
        }
        dato = dato.replace((char) 127, (char) 48);
        return Integer.valueOf(dato.trim());
    }

    public static String CompletarCeros(String dato, int tamaño) {
        for (int i = tamaño; i > dato.length(); i--) {
            dato = '0' + dato;
        }
        return dato;
    }

    public static double checkDouble(String dato) {
        if (dato == null) {
            return 0.00;
        }
        if (dato.equals("")) {
            return 0.00;
        }
        return Double.parseDouble(dato);
    }

    public static String checkFecha(String dato) {
        if (dato == "" || dato == null) {
            return fechaServidor();
        }
        return dato;
    }

    public static String fechaServidor() {
        java.util.Date fechaSistema = new java.util.Date();
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        return df.format(fechaSistema);
    }

    public static String[][] generaLista(String cadena, int tamaño) {
        String[][] matriz;
        String datos;
        cadena = cadena.replace("[", "");
        cadena = cadena.replace("]", "");
        List<String> vector = new ArrayList<>(Arrays.asList(cadena.split("\",\"")));
        matriz = new String[vector.size()][tamaño];
        for (int i = 0; i < vector.size(); i++) {
            datos = vector.get(i);
            datos = datos.replace((char) 34, (char) 0);
            List<String> arreglo = new ArrayList<>(Arrays.asList(datos.split("---")));
            for (int j = 0; j < tamaño; j++) {
                matriz[i][j] = arreglo.get(j);
            }
        }
        return matriz;
    }

    public static Boolean checkBoolean(String dato) {
        if (dato == null) {
            return false;
        }
        return dato.equals("true");
    }

    public static String getFileName(Part part) {
        String contentHeader = part.getHeader("content-disposition");
        String[] subHeaders = contentHeader.split(";");
        for (String current : subHeaders) {
            if (current.trim().startsWith("filename")) {
                int pos = current.indexOf('=');
                String fileName = current.substring(pos + 1);
                return fileName.replace("\"", "");
            }
        }
        return null;
    }

    public static String stripAccents(String str) {
        String ORIGINAL = "ÁáÉéÍíÓóÚúÑñÜü";
        String REPLACEMENT = "AaEeIiOoUuNnUu";
        if (str == null) {
            return null;
        }
        char[] array = str.toCharArray();
        for (int index = 0; index < array.length; index++) {
            int pos = ORIGINAL.indexOf(array[index]);
            if (pos > -1) {
                array[index] = REPLACEMENT.charAt(pos);
            }
        }
        str = new String(array).replaceAll("[^\\p{ASCII}]", "");
        str = str.replaceAll("['+^:,$]", "");
        return str.toUpperCase();
    }

    public String printTicket(JasperPrint reporte) throws PrinterException, JRException {
        String result = null;
        try {
            PrinterJob job = PrinterJob.getPrinterJob();
            PrintService[] service = PrintServiceLookup.lookupPrintServices(null, null);
            int selectService = 0;
            for (int i = 0; i < service.length; i++) {
                if (service[i].getName().equals("Brother QL-700") || service[i].getName().contains("Brother QL-700")) {
                    selectService = i;
                }
            }
            job.setPrintService(service[selectService]);
            PrintRequestAttributeSet aset = new HashPrintRequestAttributeSet();
            aset.add(new Copies(2));
            JRPrintServiceExporter exporter;
            exporter = new JRPrintServiceExporter();
            exporter.setParameter(JRPrintServiceExporterParameter.PRINT_SERVICE, service[selectService]);
            exporter.setParameter(JRPrintServiceExporterParameter.PRINT_SERVICE_ATTRIBUTE_SET, service[selectService].getAttributes());
            exporter.setParameter(JRPrintServiceExporterParameter.PRINT_REQUEST_ATTRIBUTE_SET, aset);
            exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PAGE_DIALOG, Boolean.FALSE);
            exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PRINT_DIALOG, Boolean.FALSE);
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, reporte);
            exporter.exportReport();
        } catch (PrinterException | JRException ep) {
            result = ep.getMessage();
        }
        return result;
    }

    public Boolean verificarImpresora(String nombreImpresora) {
        Boolean result = false;
        DocFlavor myFormat = DocFlavor.SERVICE_FORMATTED.PRINTABLE;
        PrintRequestAttributeSet aset = new HashPrintRequestAttributeSet();
        PrintService[] service = PrintServiceLookup.lookupPrintServices(myFormat, aset);
        for (PrintService printService : service) {
            PrintServiceAttributeSet attributes = printService.getAttributes();
            String printerState = attributes.get(PrinterState.class).getName();
            String printerStateReason = attributes.get(PrinterStateReason.class).getName();
            System.out.println("estado: " + printerState);
            System.out.println("estado reason: " + printerStateReason);
        }
        return result;
    }
}
