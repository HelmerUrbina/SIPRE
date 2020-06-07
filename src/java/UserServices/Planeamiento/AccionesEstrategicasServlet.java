/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Planeamiento;

import BusinessServices.Beans.BeanPlaneamiento;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.AccionesEstrategicasDAOImpl;
import DataService.Despachadores.AccionesEstrategicasDAO;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
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
@WebServlet(name = "AccionesEstrategicasServlet", urlPatterns = {"/AccionesEstrategicas"})
public class AccionesEstrategicasServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objAcciones;
    private BeanPlaneamiento objBnAcciones;
    private Connection objConnection;
    private AccionesEstrategicasDAO objDsAcciones;

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
        objBnAcciones = new BeanPlaneamiento();
        objBnAcciones.setMode(request.getParameter("mode"));
        objBnAcciones.setPeriodo(request.getParameter("periodo"));
        objBnAcciones.setObjetivo(Utiles.Utiles.checkNum(request.getParameter("objetivo")));
        objBnAcciones.setCodigo(request.getParameter("codigo"));
        objDsAcciones = new AccionesEstrategicasDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnAcciones.getMode().equals("G")) {
            CombosDAO combos = new CombosDAOImpl(objConnection);
            objAcciones = objDsAcciones.getListaAccionesEstrategicas(objBnAcciones, objUsuario.getUsuario());
            if (request.getAttribute("objAccionesEstrategicas") != null) {
                request.removeAttribute("objAccionesEstrategicas");
            }
            request.setAttribute("objAccionesEstrategicas", objAcciones);
            if (request.getAttribute("objDirecciones") != null) {
                request.removeAttribute("objDirecciones");
            }
            request.setAttribute("objDirecciones", combos.getDirecciones());
        }
        if (objBnAcciones.getMode().equals("I")) {
            result = "" + objDsAcciones.getPrioridadAccionesEstrategicas(objBnAcciones, objUsuario.getUsuario());
        }
        if (objBnAcciones.getMode().equals("U")) {
            objBnAcciones = objDsAcciones.getAccionesEstrategicas(objBnAcciones, objUsuario.getUsuario());
            result = objBnAcciones.getDescripcion() + "+++"
                    + objBnAcciones.getAbreviatura() + "+++"
                    + objBnAcciones.getPrioridad() + "+++"
                    + objBnAcciones.getFechaInicio() + "+++"
                    + objBnAcciones.getFechaFinal() + "+++"
                    + objBnAcciones.getDireccion() + "+++"
                    + objBnAcciones.getUnidadMedida() + "+++"
                    + objBnAcciones.getEstado();
        }
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "accionesEstrategicas":
                dispatcher = request.getRequestDispatcher("Planeamiento/AccionesEstrategicas.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Planeamiento/ListaAccionesEstrategicas.jsp");
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
