/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanFirmaElectronica;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.FirmaElectronicaDAO;
import DataService.Despachadores.Impl.FirmaElectronicaDAOImpl;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
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
 * @author H-URBINA-M
 */
@WebServlet(name = "FirmaElectronicaServlet", urlPatterns = {"/FirmaElectronica"})
public class FirmaElectronicaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objFirmaElectronica;
    private BeanFirmaElectronica objBnFirma;
    private Connection objConnection;
    private FirmaElectronicaDAO objDsFirma;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession();
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnFirma = new BeanFirmaElectronica();
        objBnFirma.setMode(request.getParameter("mode"));
        objBnFirma.setPeriodo(request.getParameter("periodo"));
        objBnFirma.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnFirma.setCodigo(request.getParameter("codigo"));
        objBnFirma.setEstado(request.getParameter("estado"));
        objDsFirma = new FirmaElectronicaDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnFirma.getMode().equals("CP")) {
            objFirmaElectronica = objDsFirma.getListaCertificadosPresupuestales(objBnFirma, objUsuario.getUsuario());
        }
        if (objBnFirma.getMode().equals("CA")) {
            objFirmaElectronica = objDsFirma.getListaCompromisosAnuales(objBnFirma, objUsuario.getUsuario());
        }
        if (objBnFirma.getMode().equals("DJ")) {
            objFirmaElectronica = objDsFirma.getListaCompromisosMensuales(objBnFirma, objUsuario.getUsuario());
        }
        if (request.getAttribute("objFirmaElectronica") != null) {
            request.removeAttribute("objFirmaElectronica");
        }
        request.setAttribute("objFirmaElectronica", objFirmaElectronica);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "firmaElectronica":
                dispatcher = request.getRequestDispatcher("Ejecucion/FirmaElectronica.jsp");
                break;
            case "CP":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaFirmaElectronica.jsp");
                break;
            case "CA":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaFirmaElectronica.jsp");
                break;
            case "DJ":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaFirmaElectronica.jsp");
                break;
            case "DP":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaFirmaElectronica.jsp");
                break;
            default:
                dispatcher = request.getRequestDispatcher("error.jsp");
                break;
        }
        dispatcher.forward(request, response);
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
        processRequest(request, response);
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
        processRequest(request, response);
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
