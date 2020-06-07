/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Personal;

import BusinessServices.Beans.BeanRegistroVacaciones;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.RegistroVacacionesDAOImpl;
import DataService.Despachadores.RegistroVacacionesDAO;
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
 * @author H-TECCSI-V
 */
@WebServlet(name = "ConsolidadoVacacionesServlet", urlPatterns = {"/ConsolidadoVacaciones"})
public class ConsolidadoVacacionesServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objConsolidadoVacaciones;
    private BeanRegistroVacaciones objBnConsolidadoVacaciones;
    private Connection objConnection;
    private RegistroVacacionesDAO ObjDsConsolidadoVacaciones;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession(false);
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnConsolidadoVacaciones = new BeanRegistroVacaciones();
        objBnConsolidadoVacaciones.setMode(request.getParameter("mode"));
        objBnConsolidadoVacaciones.setPeriodo(request.getParameter("periodo"));
        objBnConsolidadoVacaciones.setCodigoPersonal(request.getParameter("codigoPersonal"));
        ObjDsConsolidadoVacaciones = new RegistroVacacionesDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.
        if (objBnConsolidadoVacaciones.getMode().equals("G")) {
            objConsolidadoVacaciones = ObjDsConsolidadoVacaciones.getListaConsolidadoVacaciones(objBnConsolidadoVacaciones, objUsuario.getUsuario());
        }
        if (objBnConsolidadoVacaciones.getMode().equals("B")) {
            result = "" + ObjDsConsolidadoVacaciones.getListaVacacionesPersonal(objBnConsolidadoVacaciones, objUsuario.getUsuario());
        }
        if (request.getAttribute("objBnConsolidadoVacaciones") != null) {
            request.removeAttribute("objBnConsolidadoVacaciones");
        }
        if (request.getAttribute("objConsolidadoVacaciones") != null) {
            request.removeAttribute("objConsolidadoVacaciones");
        }
        request.setAttribute("objBnConsolidadoVacaciones", objBnConsolidadoVacaciones);
        request.setAttribute("objConsolidadoVacaciones", objConsolidadoVacaciones);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "consolidadoVA":
                dispatcher = request.getRequestDispatcher("Personal/ConsolidadoVacaciones.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Personal/ListaConsolidadoVacaciones.jsp");
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
