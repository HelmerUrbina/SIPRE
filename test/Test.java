/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author helme
 */

//import com.opre.javamail.MailMail;
import org.springframework.beans.factory.*;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.*;

public class Test {

    public static void main(String[] args) {

        Resource r = new ClassPathResource("applicationContext.xml");
        BeanFactory b = new XmlBeanFactory(r);
       // MailMail m = (MailMail) b.getBean("mailMail");
        String sender = "kcanoh@ejercito.mil.pe";//write here sender gmail id  
        String receiver = "helmer_urbina@hotmail.com";//write here receiver id  
     //   m.sendMail(sender, receiver, "hi", "welcome");

        System.out.println("success");
    }

}
