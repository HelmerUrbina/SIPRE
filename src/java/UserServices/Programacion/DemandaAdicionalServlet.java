/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanDemandaAdicional;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.DemandaAdicionalDAO;
import DataService.Despachadores.Impl.DemandaAdicionalDAOImpl;
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
@WebServlet(name = "DemandaAdicionalServlet", urlPatterns = {"/DemandaAdicional"})
public class DemandaAdicionalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objDemandaAdicional;
    private BeanDemandaAdicional objBnDemandaAdicional;
    private Connection objConnection;
    private DemandaAdicionalDAO objDsDemandaAdicional;

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
        String result = null;
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnDemandaAdicional = new BeanDemandaAdicional();
        objBnDemandaAdicional.setMode(request.getParameter("mode"));
        objBnDemandaAdicional.setPeriodo(request.getParameter("periodo"));
        objBnDemandaAdicional.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnDemandaAdicional.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnDemandaAdicional.setCodigo(Utiles.Utiles.checkNum(request.getParameter("codigo")));
        objDsDemandaAdicional = new DemandaAdicionalDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnDemandaAdicional.getMode().equals("G")) {
            objDemandaAdicional = objDsDemandaAdicional.getListaDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
        }
        if (objBnDemandaAdicional.getMode().equals("U")) {
            objBnDemandaAdicional = objDsDemandaAdicional.getDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
            result = objBnDemandaAdicional.getDescripcion();
        }
        if (objBnDemandaAdicional.getMode().equals("B")) {
            result = "" + objDsDemandaAdicional.getListaDetalleDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
        }
        if (objBnDemandaAdicional.getMode().equals("M")) {
            result = "" + objDsDemandaAdicional.getListaMetaFisicaDemandaAdicional(objBnDemandaAdicional, objUsuario.getUsuario());
        }
        if (request.getAttribute("objBnDemandaAdicional") != null) {
            request.removeAttribute("objBnDemandaAdicional");
        }
        if (request.getAttribute("objDemandaAdicional") != null) {
            request.removeAttribute("objDemandaAdicional");
        }
        request.setAttribute("objBnDemandaAdicional", objBnDemandaAdicional);
        request.setAttribute("objDemandaAdicional", objDemandaAdicional);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "demandaAdicional":
                dispatcher = request.getRequestDispatcher("Programacion/DemandaAdicional.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Programacion/ListaDemandaAdicional.jsp");
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
