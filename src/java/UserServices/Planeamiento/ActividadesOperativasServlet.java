/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Planeamiento;

import BusinessServices.Beans.BeanPlaneamiento;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.ActividadesOperativasDAO;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.ActividadesOperativasDAOImpl;
import DataService.Despachadores.Impl.CombosDAOImpl;
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
@WebServlet(name = "ActividadesOperativasServlet", urlPatterns = {"/ActividadesOperativas"})
public class ActividadesOperativasServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanPlaneamiento objBnActividades;
    private Connection objConnection;
    private ActividadesOperativasDAO objDsActividades;

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
        objBnActividades = new BeanPlaneamiento();
        objBnActividades.setMode(request.getParameter("mode"));
        objBnActividades.setPeriodo(request.getParameter("periodo"));
        objBnActividades.setObjetivo(Utiles.Utiles.checkNum(request.getParameter("objetivo")));
        objBnActividades.setAcciones(Utiles.Utiles.checkNum(request.getParameter("accion")));
        objBnActividades.setActividades(Utiles.Utiles.checkNum(request.getParameter("actividades")));
        objBnActividades.setCodigo(request.getParameter("codigo"));
        objDsActividades = new ActividadesOperativasDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnActividades.getMode().equals("G")) {
            CombosDAO combos = new CombosDAOImpl(objConnection);
            if (request.getAttribute("objActividadesOperativas") != null) {
                request.removeAttribute("objActividadesOperativas");
            }
            request.setAttribute("objActividadesOperativas", objDsActividades.getListaActividadesOperativas(objBnActividades, objUsuario.getUsuario()));
            if (request.getAttribute("objCategoriaPresupuestal") != null) {
                request.removeAttribute("objCategoriaPresupuestal");
            }
            request.setAttribute("objCategoriaPresupuestal", combos.getCategoriaPresupuestalProgramacion(objBnActividades.getPeriodo()));
        }
        if (objBnActividades.getMode().equals("I")) {
            result = "" + objDsActividades.getPrioridadActividadesOperativas(objBnActividades, objUsuario.getUsuario());
        }
        if (objBnActividades.getMode().equals("U")) {
            objBnActividades = objDsActividades.getActividadesOperativas(objBnActividades, objUsuario.getUsuario());
            result = objBnActividades.getDescripcion() + "+++"
                    + objBnActividades.getPrioridad() + "+++"
                    + objBnActividades.getCategoriaPresupuestal() + "+++"
                    + objBnActividades.getProducto() + "+++"
                    + objBnActividades.getActividad() + "+++"
                    + objBnActividades.getUnidadMedida() + "+++"
                    + objBnActividades.getEstado();
        }
        if (objBnActividades.getMode().equals("B")) {
            result = "" + objDsActividades.getListaActividadesOperativasDetalleDetalle(objBnActividades, objUsuario.getUsuario());
        }
        if (objBnActividades.getMode().equals("M")) {
            result = "" + objDsActividades.getActividadesOperativasDetalleDetalle(objBnActividades, objUsuario.getUsuario());
        }
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "actividadesOperativas":
                dispatcher = request.getRequestDispatcher("Planeamiento/ActividadesOperativas.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Planeamiento/ListaActividadesOperativas.jsp");
                break;
            default:
                dispatcher = request.getRequestDispatcher("../error.jsp");
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
