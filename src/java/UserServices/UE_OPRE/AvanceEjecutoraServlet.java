/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.UE_OPRE;

import BusinessServices.Beans.BeanConsultaAmigable;
import BusinessServices.Beans.BeanPIMInforme;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.ConsultaAmigableDAO;
import DataService.Despachadores.Impl.ConsultaAmigableDAOImpl;
import DataService.Despachadores.Impl.PIMInformeDAOImpl;
import DataService.Despachadores.PIMInformeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
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
@WebServlet(name = "AvanceEjecutoraServlet", urlPatterns = {"/AvanceEjecutora"})
public class AvanceEjecutoraServlet extends HttpServlet {
    
    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanConsultaAmigable objBnAmigable;
    private Connection objConnection;
    private ConsultaAmigableDAO objDsAmigable;

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
        System.out.println(request.getParameter("mode"));
        objBnAmigable = new BeanConsultaAmigable();
        objBnAmigable.setMode(request.getParameter("mode"));
        objBnAmigable.setPeriodo(request.getParameter("periodo"));
        objBnAmigable.setPresupuesto(request.getParameter("presupuesto"));
        objDsAmigable = new ConsultaAmigableDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnAmigable.getMode().equals("G")) {
            if (request.getAttribute("objAvanceEjecutora") != null) {
                request.removeAttribute("objAvanceEjecutora");
            }
            request.setAttribute("objPIMInforme", objDsAmigable.getListaEjecutora(objBnAmigable, objUsuario.getUsuario()));
        }
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "consultaAmigable":
                dispatcher = request.getRequestDispatcher("UE-OPRE/AvanceEjecutora.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("UE-OPRE/ListaAvanceEjecutora.jsp");
                break;
            default:
                dispatcher = request.getRequestDispatcher("error.jsp");
                break;
        }
        System.out.println(result);
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
