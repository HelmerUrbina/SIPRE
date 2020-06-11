package Utiles;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class JavaMail {

    private String TO = "";
    private String BODY = "";
    private String imagen = "";

    public JavaMail() {
    }

    public JavaMail(String correo, String archivo) {
        System.out.println(correo + " " + archivo);
        imagen = archivo;
        TO = correo;
        BODY = String.join(
                System.getProperty("line.separator"),
                "<html><body>",
                "<h3>Recepción de Documentos</h3>",
                "<br>Mediante el presente se deja constancia que su documento ha sido registrado en la Mesa de Partes Digital en la Oficina de Presupuesto del Ejercito y registrado en el Sistema de Trámite Documentario como se detallan en la siguiente imágen: ",
                "<br><br> <img src=\"cid:myimg\" width=\"600\" height=\"90\" alt=\"myimg\" />",
                "<br><br>Fecha Registro : " + Utiles.fechaServidor(),
                "<p><strong>Sistema Integrado Presupuestal del Ejercito</strong>",
                "<br>Sistema Enviado bajo la Plataforma Java.",
                "<br>",
                "</body></html>"
        );
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
            System.out.println("Correo enviado");
            return "VCorreo Enviado con Exito";
        } catch (MessagingException | UnsupportedEncodingException e) {
            System.out.println(e.getMessage());
            return "F" + e.getMessage();
        }
    }
}
