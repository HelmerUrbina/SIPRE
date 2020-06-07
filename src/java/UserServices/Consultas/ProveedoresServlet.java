/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Consultas;

import BusinessServices.Beans.BeanProveedores;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.ProveedoresDAOImpl;
import DataService.Despachadores.ProveedoresDAO;
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
@WebServlet(name = "ProveedoresServlet", urlPatterns = {"/Proveedores"})
public class ProveedoresServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objProveedor;
    private BeanProveedores objBnProveedor;
    private Connection objConnection;
    private ProveedoresDAO objDsProveedor;

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
        objBnProveedor = new BeanProveedores();
        objBnProveedor.setMode(request.getParameter("mode"));
        objBnProveedor.setRUC(request.getParameter("ruc"));
        objDsProveedor = new ProveedoresDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnProveedor.getMode().equals("G")) {
            objProveedor = objDsProveedor.getListaProveedores(objUsuario.getUsuario());
        }
        if (objBnProveedor.getMode().equals("U")) {
            objBnProveedor = objDsProveedor.getProveedor(objBnProveedor, objUsuario.getUsuario());
            result = objBnProveedor.getTipo() + "+++"
                    + objBnProveedor.getRUC() + "+++"
                    + objBnProveedor.getRazonSocial() + "+++"
                    + objBnProveedor.getRepresentante() + "+++"
                    + objBnProveedor.getDNI() + "+++"
                    + objBnProveedor.getDireccion() + "+++"
                    + objBnProveedor.getTelefono() + "+++"
                    + objBnProveedor.getEstado();
        }
        if (request.getAttribute("objBnProveedor") != null) {
            request.removeAttribute("objBnProveedor");
        }
        if (request.getAttribute("objProveedor") != null) {
            request.removeAttribute("objProveedor");
        }
        request.setAttribute("objBnProveedor", objBnProveedor);
        request.setAttribute("objProveedor", objProveedor);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "proveedores":
                dispatcher = request.getRequestDispatcher("Consultas/Proveedores.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Consultas/ListaProveedores.jsp");
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
