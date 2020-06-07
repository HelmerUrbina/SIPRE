/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Personal;

import BusinessServices.Beans.BeanConsultaIngresoSalida;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.ConsultaIngresoSalidaDAO;
import DataService.Despachadores.Impl.ConsultaIngresoSalidaDAOImpl;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
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
 
/**
 *
 *
 * @author H-TECCSI-V
 */
@WebServlet(name = "ConsultaIngresoSalidaServlet", urlPatterns = {"/ConsultaIngresoSalida"})
public class ConsultaIngresoSalidaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private ConsultaIngresoSalidaDAO objDsConsulta;
    private List objConsultaIngresoSalida;
    private BeanConsultaIngresoSalida objBnIngresoSalida;
    private Connection objConnection;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession(false);
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnectionMySQL");
        String result = null;
        objBnIngresoSalida = new BeanConsultaIngresoSalida();
        objBnIngresoSalida.setMode(request.getParameter("mode"));
        objDsConsulta = new ConsultaIngresoSalidaDAOImpl(objConnection);
        if (objBnIngresoSalida.getMode().equals("G")) {
            objConsultaIngresoSalida = objDsConsulta.getListaIngresoSalida(objBnIngresoSalida, objUsuario.getUsuario());
        }
        request.setAttribute("objConsultaIngresoSalida", objConsultaIngresoSalida);
        request.setAttribute("objBnIngresoSalida", objBnIngresoSalida);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "consultaIS":
                dispatcher = request.getRequestDispatcher("Personal/ConsultaIngresoSalida.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Personal/ListaIngresoSalida.jsp");
                break;
            default:
                dispatcher = request.getRequestDispatcher("error.jsp");
                break;
        }
        if (result != null) {
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print(result);
            }
        } else {
            dispatcher.forward(request, response);
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
        } catch (SQLException ex) {
            Logger.getLogger(ConsultaIngresoSalidaServlet.class.getName()).log(Level.SEVERE, null, ex);
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
        } catch (SQLException ex) {
            Logger.getLogger(ConsultaIngresoSalidaServlet.class.getName()).log(Level.SEVERE, null, ex);
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
