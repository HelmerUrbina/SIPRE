/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Consultas;

import BusinessServices.Beans.BeanTareas;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.TareasDAOImpl;
import DataService.Despachadores.TareasDAO;
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
@WebServlet(name = "TareasServlet", urlPatterns = {"/Tareas"})
public class TareasServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objTareas;
    private BeanTareas objBnTarea;
    private Connection objConnection;
    private TareasDAO objDsTarea;

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
        objBnTarea = new BeanTareas();
        objBnTarea.setMode(request.getParameter("mode"));
        objBnTarea.setCodigo(request.getParameter("codigo"));
        objDsTarea = new TareasDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnTarea.getMode().equals("G")) {
            objTareas = objDsTarea.getListaTareas(objUsuario.getUsuario());
        }
        if (objBnTarea.getMode().equals("U")) {
            objBnTarea = objDsTarea.getTareas(objBnTarea, objUsuario.getUsuario());
            result = objBnTarea.getTarea() + "+++"
                    + objBnTarea.getAbreviatura() + "+++"
                    + objBnTarea.getDescripcion() + "+++"
                    + objBnTarea.getUnidadMedida() + "+++"
                    + objBnTarea.getTipo();
        }
        if (request.getAttribute("objTareas") != null) {
            request.removeAttribute("objTareas");
        }
        request.setAttribute("objTareas", objTareas);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "tareas":
                dispatcher = request.getRequestDispatcher("Consultas/Tareas.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Consultas/ListaTareas.jsp");
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
