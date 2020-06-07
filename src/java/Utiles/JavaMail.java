package Utiles;

import BusinessServices.Beans.BeanMesaParte;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class JavaMail {

    private String TO = "";
    static String BODY = "";

    public JavaMail() {
    }

    public JavaMail(BeanMesaParte objBnMesaPartes) {
        TO = objBnMesaPartes.getCorreo();
        BODY = String.join(
                System.getProperty("line.separator"),
                "<h5>Recepción de Documentos</h5>",
                "<br>Mediante el presente se deja constancia que su documento ha sido recibido en la Oficina de Presupuesto del Ejercito y registrado en el Sistema de Trámite Documentario como se detallan en la siguiente imágen:",
                "<br>Institución : " + objBnMesaPartes.getInstitucion(),
                "<br>Documento : " + objBnMesaPartes.getTipoDocumento(),
                "<br>Asunto : " + objBnMesaPartes.getAsunto(),
                "<br>Observación : " + objBnMesaPartes.getObservacion(),
                "<br>Post Firma : " + objBnMesaPartes.getUsuario(),
                "<br>Fecha Documento : " + objBnMesaPartes.getFecha(),
                "<br>Fecha Recepción : " + Utiles.fechaServidor(),
                "<br>Legajos : " + objBnMesaPartes.getLegajo(),
                "<br>Folios : " + objBnMesaPartes.getFolio(),
                "<br>Archivo : " + objBnMesaPartes.getArchivo(),
                "<p><strong>Sistema Integrado Presupuestal del Ejercito</strong>",
                "<br>Sistema Enviado bajo la Plataforma Java."
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
            msg.setContent(BODY, "text/html");
            Transport transport = session.getTransport();
            transport.connect(properties.getProperty("mail.smtp.host"), properties.getProperty("mail.user"), properties.getProperty("mail.password"));
            transport.sendMessage(msg, msg.getAllRecipients());
            return "VCorreo Enviado con Exito";
        } catch (MessagingException | UnsupportedEncodingException e) {
            return "F" + e.getMessage();
        }
    }
}
