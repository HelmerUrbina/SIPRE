/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.MesaPartes;

import BusinessServices.Beans.BeanMesaParte;
import BusinessServices.Beans.BeanUsuario;
import Utiles.Utiles;
import java.awt.print.PrinterException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;

/**
 *
 * @author H-TECCSI-V
 */
@WebServlet(name = "ImprimirTicketServlet", urlPatterns = {"/ImprimirTicket"})
public class ImprimirTicketServlet extends HttpServlet {

    private HttpSession session = null;
    private ServletConfig config = null;
    private ServletContext context = null;
    private RequestDispatcher dispatcher;
    private Connection objConnection;
    private BeanMesaParte objBnMesaParte;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, JRException, PrinterException {
        String result = null;
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession();
        //VERIFICAMOS QUE LA SESSION SEA VALIDA        
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("../FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnMesaParte = new BeanMesaParte();
        objBnMesaParte.setMode(request.getParameter("mode"));
        objBnMesaParte.setPeriodo(request.getParameter("periodo"));
        objBnMesaParte.setTipo(request.getParameter("tipo"));
        objBnMesaParte.setNumero(request.getParameter("numero"));
        try {
            InputStream stream = context.getResourceAsStream("/Reportes/MesaParte/MPA0003.jasper");
            Map parameters = new HashMap();
            parameters.put("REPORT_LOCALE", new Locale("en", "US"));
            parameters.put("PERIODO", objBnMesaParte.getPeriodo());
            parameters.put("CODIGO", objBnMesaParte.getNumero());
            parameters.put("TIPO", objBnMesaParte.getTipo());
            parameters.put("USUARIO", objUsuario.getUsuario());
            parameters.put("SUBREPORT_DIR", "D:\\SIPRE\\Reportes");
            JasperPrint jasperPrint = JasperFillManager.fillReport(stream, parameters, objConnection);            
            Utiles u = new Utiles();
            result = u.printTicket(jasperPrint);
        } catch (JRException | PrinterException ex) {
            result = ex.getMessage();
        }
        response.setContentType("text/html;charset=UTF-8");
        if (result == null) {
            try (PrintWriter out = response.getWriter()) {
                out.print("OK");
            }
        } else {
            //PROCEDEMOS A ELIMINAR TODO;
            try (PrintWriter out = response.getWriter()) {
                out.print(result);
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JRException ex) {
            Logger.getLogger(ImprimirTicketServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (PrinterException ex) {
            Logger.getLogger(ImprimirTicketServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JRException ex) {
            Logger.getLogger(ImprimirTicketServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (PrinterException ex) {
            Logger.getLogger(ImprimirTicketServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
