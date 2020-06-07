/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Consultas;

import BusinessServices.Beans.BeanDependencia;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.DependenciaDAO;
import DataService.Despachadores.Impl.DependenciaDAOImpl;
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
@WebServlet(name = "DependenciaServlet", urlPatterns = {"/Dependencia"})
public class DependenciaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objDependencia;
    private BeanDependencia objBnDependencia;
    private Connection objConnection;
    private DependenciaDAO ObjDsDependencia;

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
        objBnDependencia = new BeanDependencia();
        objBnDependencia.setMode(request.getParameter("mode"));
        objBnDependencia.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnDependencia.setCodigo(request.getParameter("codigo"));
        ObjDsDependencia = new DependenciaDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnDependencia.getMode().equals("G")) {
            objDependencia = ObjDsDependencia.getListaDependencia(objBnDependencia, objUsuario.getUsuario());
        }
        if (objBnDependencia.getMode().equals("U")) {
            objBnDependencia = ObjDsDependencia.getDependencia(objBnDependencia, objUsuario.getUsuario());
            result = objBnDependencia.getNombre() + "+++"
                    + objBnDependencia.getAbreviatura() + "+++"
                    + objBnDependencia.getEstado();
        }
        if (request.getAttribute("objBnTarea") != null) {
            request.removeAttribute("objBnTarea");
        }
        if (request.getAttribute("objTareas") != null) {
            request.removeAttribute("objTareas");
        }
        request.setAttribute("objBnDependencia", objBnDependencia);
        request.setAttribute("objDependencia", objDependencia);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "dependencia":
                dispatcher = request.getRequestDispatcher("Consultas/Dependencia.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Consultas/ListaDependencia.jsp");
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
