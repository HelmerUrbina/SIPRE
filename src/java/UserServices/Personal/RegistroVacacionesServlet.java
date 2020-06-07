/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Personal;

import BusinessServices.Beans.BeanRegistroVacaciones;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.RegistroVacacionesDAOImpl;
import DataService.Despachadores.RegistroVacacionesDAO;
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
 * @author H-TECCSI-V
 */
@WebServlet(name = "RegistroVacacionesServlet", urlPatterns = {"/RegistroVacaciones"})
public class RegistroVacacionesServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objRegistroVacaciones;
    private BeanRegistroVacaciones objBnRegistroVacaciones;
    private Connection objConnection;
    private RegistroVacacionesDAO ObjDsRegistroVacaciones;

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
        objBnRegistroVacaciones = new BeanRegistroVacaciones();
        objBnRegistroVacaciones.setMode(request.getParameter("mode"));
        objBnRegistroVacaciones.setPeriodo(request.getParameter("periodo"));
        objBnRegistroVacaciones.setCorrelativo(Utiles.checkNum(request.getParameter("correlativo")));
        objBnRegistroVacaciones.setCodigoPersonal(objUsuario.getUsuario());
        ObjDsRegistroVacaciones = new RegistroVacacionesDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnRegistroVacaciones.getMode().equals("G")) {
            objRegistroVacaciones = ObjDsRegistroVacaciones.getListaVacaciones(objBnRegistroVacaciones, objUsuario.getUsuario());
            objBnRegistroVacaciones.setDiasDisponible(ObjDsRegistroVacaciones.getDiasDisponibles(objBnRegistroVacaciones, objUsuario.getUsuario()));
        }
        if (objBnRegistroVacaciones.getMode().equals("U")) {
            objBnRegistroVacaciones = ObjDsRegistroVacaciones.getVacacionesPersonal(objBnRegistroVacaciones, objUsuario.getUsuario());
            result = objBnRegistroVacaciones.getFechaInicio() + "+++"
                    + objBnRegistroVacaciones.getFechaFin() + "+++"
                    + objBnRegistroVacaciones.getDiasDisponible() + "+++"
                    + objBnRegistroVacaciones.getDiasSolicitado() + "+++"
                    + objBnRegistroVacaciones.getDiasRestantes() + "+++"
                    + objBnRegistroVacaciones.getMotivo();
        }
        if (request.getAttribute("objBnRegistroVacaciones") != null) {
            request.removeAttribute("objBnRegistroVacaciones");
        }
        if (request.getAttribute("objRegistroVacaciones") != null) {
            request.removeAttribute("objRegistroVacaciones");
        }
        request.setAttribute("objBnRegistroVacaciones", objBnRegistroVacaciones);
        request.setAttribute("objRegistroVacaciones", objRegistroVacaciones);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "vacaciones":
                dispatcher = request.getRequestDispatcher("Personal/RegistroVacaciones.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Personal/ListaRegistroVacaciones.jsp");
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
