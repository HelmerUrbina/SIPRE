/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Configuracion;

import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.UsuarioDAOImpl;
import DataService.Despachadores.UsuarioDAO;
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
@WebServlet(name = "UsuarioServlet", urlPatterns = {"/Usuario"})
public class UsuarioServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objUsuario;
    private BeanUsuario objBnUsuario;
    private Connection objConnection;
    private UsuarioDAO objDsUsuario;

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
        BeanUsuario objSession = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        //VERIFICAMOS LA SESSION DEL USUARIO
        if (objSession == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        String result = null;
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnUsuario = new BeanUsuario();
        objBnUsuario.setMode(request.getParameter("mode"));
        objBnUsuario.setUsuario(request.getParameter("usuario"));
        objDsUsuario = new UsuarioDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnUsuario.getMode().equals("G")) {
            objUsuario = objDsUsuario.getListaUsuarios(objSession.getUsuario());
        }
        if (objBnUsuario.getMode().equals("U")) {
            objBnUsuario = objDsUsuario.getUsuario(objBnUsuario, objSession.getUsuario());
            result = objBnUsuario.getUnidadOperativa() + "+++"
                    + objBnUsuario.getApellido() + "+++"
                    + objBnUsuario.getNombre() + "+++"
                    + objBnUsuario.getIniciales() + "+++"
                    + objBnUsuario.getAreaLaboral() + "+++"
                    + objBnUsuario.getEstado() + "+++"
                    + objBnUsuario.getOpre() + "+++"
                    + objBnUsuario.getActa();
        }
        if (objBnUsuario.getMode().equals("M")) {
            result = "" + objDsUsuario.getMenu();
        }
        if (objBnUsuario.getMode().equals("O")) {
            result = "" + objDsUsuario.getOpciones(objBnUsuario, objSession.getUsuario());
        }
        if (request.getAttribute("objBnUsuario") != null) {
            request.removeAttribute("objBnUsuario");
        }
        if (request.getAttribute("objUsuario") != null) {
            request.removeAttribute("objUsuario");
        }
        request.setAttribute("objBnUsuario", objBnUsuario);
        request.setAttribute("objUsuario", objUsuario);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "usuario":
                dispatcher = request.getRequestDispatcher("Configuracion/Usuario.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Configuracion/ListaUsuario.jsp");
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
