package Utiles;

import BusinessServices.Beans.BeanMesaParte;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.imageio.ImageIO;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;
import net.sf.jasperreports.engine.DefaultJasperReportsContext;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperPrintManager;

public class JavaMail {

    private String TO = "";
    private String BODY = "";
    private String imagen = "";

    public JavaMail() {
    }

    public JavaMail(BeanMesaParte objBnMesaPartes, HttpServletRequest request, Connection objConnection) throws IOException {
        InputStream stream = request.getServletContext().getResourceAsStream("/Reportes/MesaParte/MPA0004.jasper");
        if (stream == null) {
            throw new IllegalArgumentException("No se encuentra el reporte");
        }
        Map parameters = new HashMap();
        parameters.put("REPORT_LOCALE", new Locale("en", "US"));
        parameters.put("PERIODO", objBnMesaPartes.getPeriodo());
        parameters.put("TIPO", objBnMesaPartes.getTipo());
        parameters.put("CODIGO", objBnMesaPartes.getNumero());
        parameters.put("SUBREPORT_DIR", request.getServletContext().getResource("/Reportes/").toString().substring(6));
        try {
            JasperPrint jasperPrint = JasperFillManager.fillReport(stream, parameters, objConnection);
            imagen = extractPrintImage("D:\\SIPRE\\Reportes\\" + objBnMesaPartes.getPeriodo() + "-" + objBnMesaPartes.getNumero() + ".jpg", jasperPrint);
        } catch (JRException ex) {
            System.out.println(ex.getMessage());
            Logger.getLogger(JavaMail.class.getName()).log(Level.SEVERE, null, ex);
        }
        TO = objBnMesaPartes.getCorreo();
        BODY = String.join(
                System.getProperty("line.separator"),
                "<html><body>",
                "<h3>Recepción de Documentos</h3>",
                "<br>Mediante el presente se deja constancia que su documento ha sido registrado en la Mesa de Partes Digital en la Oficina de Presupuesto del Ejercito y registrado en el Sistema de Trámite Documentario como se detallan en la siguiente imágen: ",
                "<br><br> <img src=\"cid:myimg\" width=\"600\" height=\"90\" alt=\"myimg\" />",
                "<br><br>Fecha Registro : " + Utiles.fechaServidor(),
                "<p><strong>Sistema Integrado Presupuestal del Ejercito</strong>",
                "<br>Sistema Enviado bajo la Plataforma Java.",
                "</body></html>"
        );
    }

    private String extractPrintImage(String filePath, JasperPrint print) {
        File file = new File(filePath);
        OutputStream ouputStream = null;
        try {
            ouputStream = new FileOutputStream(file);
            DefaultJasperReportsContext.getInstance();
            JasperPrintManager printManager = JasperPrintManager.getInstance(DefaultJasperReportsContext.getInstance());
            BufferedImage rendered_image = null;
            rendered_image = (BufferedImage) printManager.printPageToImage(print, 0, 1.6f);
            ImageIO.write(rendered_image, "jpg", ouputStream);
        } catch (IOException | JRException e) {
            System.out.println(e.getMessage());
        }
        return "" + file;
    }

    public String SendMail() throws IOException {
        Properties properties = System.getProperties();
        //cargamos el archivo de configuracion
        properties.load(new JavaMail().getClass().getResourceAsStream("gmail.properties"));
        Session session = Session.getInstance(properties,
                new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(properties.getProperty("mail.user"), properties.getProperty("mail.password"));
            }
        });
        try {
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(properties.getProperty("mail.user"), properties.getProperty("mail.from")));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(TO));
            msg.setSubject(properties.getProperty("mail.subject"));
            // Handle attachment 1
            MimeBodyPart messageBodyPart1 = new MimeBodyPart();
            messageBodyPart1.attachFile(imagen);
            FileDataSource fileDs = new FileDataSource(imagen);
            MimeBodyPart imageBodypart = new MimeBodyPart();
            imageBodypart.setDataHandler(new DataHandler(fileDs));
            imageBodypart.setHeader("Content-ID", "<myimg>");
            imageBodypart.setDisposition(MimeBodyPart.INLINE);
            // Handle text
            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setHeader("Content-Type", "text/plain; charset=\"utf-8\"");
            textPart.setContent(BODY, "text/html; charset=utf-8");
            MimeMultipart multipart = new MimeMultipart("mixed");
            multipart.addBodyPart(textPart);
            multipart.addBodyPart(imageBodypart);
            multipart.addBodyPart(messageBodyPart1);
            msg.setContent(multipart);
            Transport transport = session.getTransport();
            transport.connect(properties.getProperty("mail.smtp.host"), properties.getProperty("mail.user"), properties.getProperty("mail.password"));
            transport.sendMessage(msg, msg.getAllRecipients());
            return "VCorreo Enviado con Exito";
        } catch (MessagingException | UnsupportedEncodingException e) {
            return "F" + e.getMessage();
        }
    }
}
