/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Personal;

import BusinessServices.Beans.BeanPlanillaMovilidad;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.PlanillaMovilidadDAOImpl;
import DataService.Despachadores.PlanillaMovilidadDAO;
import Utiles.Utiles;
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
 * @author hateccsiv
 */
@WebServlet(name = "PlanillaMovilidadServlet", urlPatterns = {"/PlanillaMovilidad"})
public class PlanillaMovilidadServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objPlanillaMovilidad;
    private BeanPlanillaMovilidad objBnPlanillaMovilidad;
    private Connection objConnection;
    private PlanillaMovilidadDAO ObjDsPlanillaMovilidad;
    private CombosDAO objDsCombo;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession(false);
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnPlanillaMovilidad = new BeanPlanillaMovilidad();
        objBnPlanillaMovilidad.setMode(request.getParameter("mode"));
        objBnPlanillaMovilidad.setPeriodo(request.getParameter("periodo"));
        objBnPlanillaMovilidad.setMes(request.getParameter("mes"));
        objBnPlanillaMovilidad.setCorrelativo(Utiles.checkNum(request.getParameter("correlativo")));
        objBnPlanillaMovilidad.setUsuarioPlanilla(objUsuario.getUsuario());
        ObjDsPlanillaMovilidad = new PlanillaMovilidadDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnPlanillaMovilidad.getMode().equals("G")) {
            objPlanillaMovilidad = ObjDsPlanillaMovilidad.getListaPlanillaMovilidad(objBnPlanillaMovilidad, objUsuario.getUsuario());
            objDsCombo = new CombosDAOImpl(objConnection);
            if (request.getAttribute("objOrigen") != null) {
                request.removeAttribute("objOrigen");
            }
            request.setAttribute("objOrigen", objDsCombo.getDistritoMovilidad());
        }
        if (objBnPlanillaMovilidad.getMode().equals("U")) {
            objBnPlanillaMovilidad = ObjDsPlanillaMovilidad.getPlanillaMovilidad(objBnPlanillaMovilidad, objUsuario.getUsuario());
            result = objBnPlanillaMovilidad.getLugarOrigen() + "+++"
                    + objBnPlanillaMovilidad.getLugarDestino() + "+++"
                    + objBnPlanillaMovilidad.getFechaMovilidad() + "+++"
                    + objBnPlanillaMovilidad.getJustificacion() + "+++"
                    + objBnPlanillaMovilidad.getImporte();
        }
        if (request.getAttribute("objBnPlanillaMovilidad") != null) {
            request.removeAttribute("objBnPlanillaMovilidad");
        }
        if (request.getAttribute("objPlanillaMovilidad") != null) {
            request.removeAttribute("objPlanillaMovilidad");
        }

        request.setAttribute("objBnPlanillaMovilidad", objBnPlanillaMovilidad);
        request.setAttribute("objPlanillaMovilidad", objPlanillaMovilidad);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "movilidad":
                dispatcher = request.getRequestDispatcher("Personal/PlanillaMovilidad.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Personal/ListaPlanillaMovilidad.jsp");
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
