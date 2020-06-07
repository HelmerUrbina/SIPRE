/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.SIAF;

import BusinessServices.Beans.BeanDiferenciasSIAF;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.DiferenciasSIAFDAO;
import DataService.Despachadores.Impl.DiferenciasSIAFDAOImpl;
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
@WebServlet(name = "DiferenciasSIAFServlet", urlPatterns = {"/DiferenciasSIAF"})
public class DiferenciasSIAFServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objDiferencia;
    private BeanDiferenciasSIAF objBnDiferencia;
    private Connection objConnection;
    private DiferenciasSIAFDAO objDsDiferencia;

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
        //VERIFICAMOS LA SESSION DEL USUARIO
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnDiferencia = new BeanDiferenciasSIAF();
        objBnDiferencia.setMode(request.getParameter("mode"));
        objBnDiferencia.setPeriodo(request.getParameter("periodo"));
        objBnDiferencia.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objDsDiferencia = new DiferenciasSIAFDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnDiferencia.getMode().equals("Certificado")) {
            objDiferencia = objDsDiferencia.getListaDiferenciaCertificado(objBnDiferencia, objUsuario.getUsuario());
        }
        if (objBnDiferencia.getMode().equals("CompromisoAnual")) {
            objDiferencia = objDsDiferencia.getListaDiferenciaCompromisoAnual(objBnDiferencia, objUsuario.getUsuario());
        }
        if (request.getAttribute("objDiferencia") != null) {
            request.removeAttribute("objDiferencia");
        }
        request.setAttribute("objDiferencia", objDiferencia);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (objBnDiferencia.getMode()) {
            case "diferenciasSIAF":
                dispatcher = request.getRequestDispatcher("SIAF/DiferenciaSIAF.jsp");
                break;
            case "Certificado":
                dispatcher = request.getRequestDispatcher("SIAF/ListaDiferenciaSIAF.jsp");
                break;
            case "CompromisoAnual":
                dispatcher = request.getRequestDispatcher("SIAF/ListaDiferenciaSIAF.jsp");
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
