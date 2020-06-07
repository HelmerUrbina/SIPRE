/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Programacion;

import BusinessServices.Beans.BeanHojaTrabajo;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.HojaTrabajoDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.HojaTrabajoDAOImpl;
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
@WebServlet(name = "HojaTrabajoServlet", urlPatterns = {"/HojaTrabajo"})
public class HojaTrabajoServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objHojaTrabajo;
    private BeanHojaTrabajo objBnHojaTrabajo;
    private Connection objConnection;
    private HojaTrabajoDAO objDsHojaTrabajo;
    private CombosDAO objDsCombo;

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
        objBnHojaTrabajo = new BeanHojaTrabajo();
        objBnHojaTrabajo.setMode(request.getParameter("mode"));
        objBnHojaTrabajo.setPeriodo(request.getParameter("periodo"));
        objBnHojaTrabajo.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnHojaTrabajo.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnHojaTrabajo.setTarea(request.getParameter("tarea"));
        objBnHojaTrabajo.setEventoPrincipal(request.getParameter("eventoPrincipal"));
        objBnHojaTrabajo.setEventoFinal(request.getParameter("eventoFinal"));
        objBnHojaTrabajo.setCorrelativo(Utiles.Utiles.checkNum(request.getParameter("correlativo")));
        objBnHojaTrabajo.setNivel(Utiles.Utiles.checkNum(request.getParameter("nivel")));
        objBnHojaTrabajo.setDependencia(request.getParameter("dependencia"));
        objBnHojaTrabajo.setCadenaGasto(request.getParameter("cadenaGasto"));
        objDsHojaTrabajo = new HojaTrabajoDAOImpl(objConnection);
        objDsCombo = new CombosDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.  
        if (objBnHojaTrabajo.getMode().equals("G")) {
            objHojaTrabajo = objDsHojaTrabajo.getListaHojaTrabajo(objBnHojaTrabajo, objUsuario.getUsuario());
            if (request.getAttribute("objCadenaGasto") != null) {
                request.removeAttribute("objCadenaGasto");
            }
            request.setAttribute("objCadenaGasto", objDsCombo.getCadenaGastoProgramacionMultianual(objBnHojaTrabajo.getPeriodo(), objBnHojaTrabajo.getPresupuesto(),
                    objBnHojaTrabajo.getUnidadOperativa(), objBnHojaTrabajo.getTarea(), objBnHojaTrabajo.getDependencia()));
            if (request.getAttribute("objUnidadMedida") != null) {
                request.removeAttribute("objUnidadMedida");
            }
            request.setAttribute("objUnidadMedida", objDsCombo.getUnidadMedida());
        }
        if (objBnHojaTrabajo.getMode().equals("U")) {
            objBnHojaTrabajo = objDsHojaTrabajo.getHojaTrabajo(objBnHojaTrabajo, objUsuario.getUsuario());
            result = objBnHojaTrabajo.getCadenaGasto() + "+++"
                    + objBnHojaTrabajo.getCodigo() + "+++"
                    + objBnHojaTrabajo.getItem() + "+++"
                    + objBnHojaTrabajo.getUnidadMedida() + "+++"
                    + objBnHojaTrabajo.getCantidad() + "+++"
                    + objBnHojaTrabajo.getPrecio();
        }
        if (objBnHojaTrabajo.getMode().equals("S")) {
            result = "" + objDsHojaTrabajo.getSaldoHojaTrabajo(objBnHojaTrabajo, objUsuario.getUsuario());
        }
        if (request.getAttribute("objBnHojaTrabajo") != null) {
            request.removeAttribute("objBnHojaTrabajo");
        }
        if (request.getAttribute("objHojaTrabajo") != null) {
            request.removeAttribute("objHojaTrabajo");
        }
        request.setAttribute("objBnHojaTrabajo", objBnHojaTrabajo);
        request.setAttribute("objHojaTrabajo", objHojaTrabajo);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "G":
                dispatcher = request.getRequestDispatcher("Programacion/ListaHojaTrabajo.jsp");
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
