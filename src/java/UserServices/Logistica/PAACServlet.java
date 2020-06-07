/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Logistica;

import BusinessServices.Beans.BeanPAAC;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.PAACDAO;
import DataService.Despachadores.Impl.PAACDAOImpl;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "PAACServlet", urlPatterns = {"/PAAC"})
public class PAACServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objPAAC;
    private BeanPAAC objBnPAAC;
    private Connection objConnection;
    private PAACDAO objDsPAAC;

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
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnPAAC = new BeanPAAC();
        objBnPAAC.setMode(request.getParameter("mode"));
        objBnPAAC.setPeriodo(request.getParameter("periodo"));
        objBnPAAC.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnPAAC.setCodigo(Utiles.Utiles.checkNum(request.getParameter("codigo")));
        objDsPAAC = new PAACDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnPAAC.getMode().equals("G")) {
            objPAAC = objDsPAAC.getListaPAAC(objBnPAAC, objUsuario.getUsuario());
        }
        if (objBnPAAC.getMode().equals("U")) {
            objBnPAAC = objDsPAAC.getPAAC(objBnPAAC, objUsuario.getUsuario());
            result = objBnPAAC.getTipo() + "+++"
                    + objBnPAAC.getNumero() + "+++"
                    + objBnPAAC.getObjeto() + "+++"
                    + objBnPAAC.getFecha() + "+++"
                    + objBnPAAC.getCertificado() + "+++"
                    + objBnPAAC.getValorReferencial() + "+++"
                    + objBnPAAC.getCompra();
        }
        if (objBnPAAC.getMode().equals("M")) {
            objBnPAAC = objDsPAAC.getPAACMensualizar(objBnPAAC, objUsuario.getUsuario());
            result = objBnPAAC.getTipo() + "+++"
                    + objBnPAAC.getValorReferencial() + "+++"
                    + objBnPAAC.getEnero() + "+++"
                    + objBnPAAC.getFebrero() + "+++"
                    + objBnPAAC.getMarzo() + "+++"
                    + objBnPAAC.getAbril() + "+++"
                    + objBnPAAC.getMayo() + "+++"
                    + objBnPAAC.getJunio() + "+++"
                    + objBnPAAC.getJulio() + "+++"
                    + objBnPAAC.getAgosto() + "+++"
                    + objBnPAAC.getSetiembre() + "+++"
                    + objBnPAAC.getOctubre() + "+++"
                    + objBnPAAC.getNoviembre() + "+++"
                    + objBnPAAC.getDiciembre();
        }
        if (request.getAttribute("objBnPAAC") != null) {
            request.removeAttribute("objBnPAAC");
        }
        if (request.getAttribute("objPAAC") != null) {
            request.removeAttribute("objPAAC");
        }
        request.setAttribute("objBnPAAC", objBnPAAC);
        request.setAttribute("objPAAC", objPAAC);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "paac":
                dispatcher = request.getRequestDispatcher("Logistica/PAAC.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Logistica/ListaPAAC.jsp");
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
