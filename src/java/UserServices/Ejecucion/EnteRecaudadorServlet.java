/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanEnteRecaudador;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.EnteRecaudadorDAOImpl;
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
import DataService.Despachadores.EnteRecaudadorDAO;

/**
 *
 * @author H-URBINA-M
 */
@WebServlet(name = "EnteRecaudadorServlet", urlPatterns = {"/EnteRecaudador"})
public class EnteRecaudadorServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanEnteRecaudador objBnEnteGenerador;
    private Connection objConnection;
    private EnteRecaudadorDAO objDsEnteGenerador;

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
        objBnEnteGenerador = new BeanEnteRecaudador();
        objBnEnteGenerador.setMode(request.getParameter("mode"));
        objBnEnteGenerador.setPeriodo(request.getParameter("periodo"));
        objBnEnteGenerador.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnEnteGenerador.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnEnteGenerador.setMes(request.getParameter("mes"));
        objBnEnteGenerador.setCodigo(Utiles.Utiles.checkNum(request.getParameter("codigo")));
        objDsEnteGenerador = new EnteRecaudadorDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.
        if (objBnEnteGenerador.getMode().equals("G")) {
            if (request.getAttribute("objEnteRecaudador") != null) {
                request.removeAttribute("objEnteRecaudador");
            }
            request.setAttribute("objEnteRecaudador", objDsEnteGenerador.getListaEnteRecaudador(objBnEnteGenerador));
        }
        if (objBnEnteGenerador.getMode().equals("U")) {
            objBnEnteGenerador = objDsEnteGenerador.getEnteRecaudador(objBnEnteGenerador);
            result = objBnEnteGenerador.getEstimacionIngreso() + "+++"
                    + objBnEnteGenerador.getDescripcion() + "+++"
                    + objBnEnteGenerador.getImporte() + "+++"
                    + objBnEnteGenerador.getCostoOperativo();
        }
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "enteRecaudador":
                dispatcher = request.getRequestDispatcher("Ejecucion/EnteRecaudador.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaEnteRecaudador.jsp");
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
