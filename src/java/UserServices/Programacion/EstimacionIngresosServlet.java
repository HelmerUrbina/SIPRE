/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanEstimacionIngresos;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.EstimacionIngresosDAO;
import DataService.Despachadores.Impl.EstimacionIngresosDAOImpl;
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
@WebServlet(name = "EstimacionIngresosServlet", urlPatterns = {"/EstimacionIngresos"})
public class EstimacionIngresosServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objEstimacionIngresos;
    private BeanEstimacionIngresos objBnEstimacionIngresos;
    private Connection objConnection;
    private EstimacionIngresosDAO objDsEstimacionIngresos;

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
        objBnEstimacionIngresos = new BeanEstimacionIngresos();
        objBnEstimacionIngresos.setMode(request.getParameter("mode"));
        objBnEstimacionIngresos.setPeriodo(request.getParameter("periodo"));
        objBnEstimacionIngresos.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnEstimacionIngresos.setCodigo(Utiles.Utiles.checkNum(request.getParameter("codigo")));
        objDsEstimacionIngresos = new EstimacionIngresosDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnEstimacionIngresos.getMode().equals("G")) {
            objEstimacionIngresos = objDsEstimacionIngresos.getListaEstimacionIngresos(objBnEstimacionIngresos, objUsuario.getUsuario());
        }
        if (objBnEstimacionIngresos.getMode().equals("U")) {
            objBnEstimacionIngresos = objDsEstimacionIngresos.getEstimacionIngresos(objBnEstimacionIngresos, objUsuario.getUsuario());
            result = objBnEstimacionIngresos.getCadenaIngreso() + "+++"
                    + objBnEstimacionIngresos.getDescripcion() + "+++"
                    + objBnEstimacionIngresos.getImpuesto() + "+++"
                    + objBnEstimacionIngresos.getImporteUnidadEjecutora() + "+++"
                    + objBnEstimacionIngresos.getImporteUnidadOperativa();
        }
        if (request.getAttribute("objEstimacionIngresos") != null) {
            request.removeAttribute("objEstimacionIngresos");
        }
        if (request.getAttribute("objBnEstimacionIngresos") != null) {
            request.removeAttribute("objBnEstimacionIngresos");
        }
        request.setAttribute("objEstimacionIngresos", objEstimacionIngresos);
        request.setAttribute("objBnEstimacionIngresos", objBnEstimacionIngresos);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "estimacionIngresos":
                dispatcher = request.getRequestDispatcher("Programacion/EstimacionIngresos.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Programacion/ListaEstimacionIngresos.jsp");
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
