/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanEjecucionEstado;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.EjecucionEstadoDAOImpl;
import DataService.Despachadores.EjecucionEstadoDAO;
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
@WebServlet(name = "EjecucionEstadoServlet", urlPatterns = {"/EjecucionEstado"})
public class EjecucionEstadoServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objEjecucionEstado;
    private BeanEjecucionEstado objBnEjecucionEstado;
    private Connection objConnection;
    private EjecucionEstadoDAO objDsEjecucionEstado;

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
        String result = null;
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnEjecucionEstado = new BeanEjecucionEstado();
        objBnEjecucionEstado.setMode(request.getParameter("mode"));
        objBnEjecucionEstado.setPeriodo(request.getParameter("periodo"));
        objBnEjecucionEstado.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnEjecucionEstado.setOpcion(request.getParameter("opcion"));
        objDsEjecucionEstado = new EjecucionEstadoDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnEjecucionEstado.getMode().equals("G")) {
            objEjecucionEstado = objDsEjecucionEstado.getListaEjecucionEstado(objBnEjecucionEstado, objUsuario.getUsuario());
        }
        if (request.getAttribute("objEjecucionEstado") != null) {
            request.removeAttribute("objEjecucionEstado");
        }
        request.setAttribute("objEjecucionEstado", objEjecucionEstado);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (objBnEjecucionEstado.getMode()) {
            case "ejecucionEstado":
                dispatcher = request.getRequestDispatcher("Ejecucion/EjecucionEstado.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaEjecucionEstado.jsp");
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
