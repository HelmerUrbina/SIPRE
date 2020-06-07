/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanDisponibilidadPresupuestal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.DisponibilidadPresupuestalDAOImpl;
import DataService.Despachadores.DisponibilidadPresupuestalDAO;
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
@WebServlet(name = "DisponibilidadPresupuestalServlet", urlPatterns = {"/DisponibilidadPresupuestal"})
public class DisponibilidadPresupuestalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanDisponibilidadPresupuestal objBnDisponibilidadPresupuestal;
    private Connection objConnection;
    private DisponibilidadPresupuestalDAO objDsDisponibilidadPresupuestal;

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
        String result = null;
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnDisponibilidadPresupuestal = new BeanDisponibilidadPresupuestal();
        objBnDisponibilidadPresupuestal.setMode(request.getParameter("mode"));
        objBnDisponibilidadPresupuestal.setPeriodo(request.getParameter("periodo"));
        objBnDisponibilidadPresupuestal.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnDisponibilidadPresupuestal.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnDisponibilidadPresupuestal.setMes(request.getParameter("mes"));
        objBnDisponibilidadPresupuestal.setCodigo(request.getParameter("codigo"));
        objDsDisponibilidadPresupuestal = new DisponibilidadPresupuestalDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.        
        if (objBnDisponibilidadPresupuestal.getMode().equals("G")) {
            if (request.getAttribute("objDisponibilidadPresupuestal") != null) {
                request.removeAttribute("objDisponibilidadPresupuestal");
            }
            request.setAttribute("objDisponibilidadPresupuestal", objDsDisponibilidadPresupuestal.getListaDisponibilidadPresupuestal(objBnDisponibilidadPresupuestal, objUsuario.getUsuario()));
            if (request.getAttribute("objDisponibilidadPresupuestalDetalle") != null) {
                request.removeAttribute("objDisponibilidadPresupuestalDetalle");
            }
            request.setAttribute("objDisponibilidadPresupuestalDetalle", objDsDisponibilidadPresupuestal.getListaDisponibilidadPresupuestalDetalle(objBnDisponibilidadPresupuestal, objUsuario.getUsuario()));
        }
        if (objBnDisponibilidadPresupuestal.getMode().equals("U")) {
            objBnDisponibilidadPresupuestal = objDsDisponibilidadPresupuestal.getDisponibilidadPresupuestal(objBnDisponibilidadPresupuestal, objUsuario.getUsuario());
            result = objBnDisponibilidadPresupuestal.getTipo() + "+++"
                    + objBnDisponibilidadPresupuestal.getOficio() + "+++"
                    + objBnDisponibilidadPresupuestal.getConcepto() + "+++"
                    + objBnDisponibilidadPresupuestal.getFecha();
        }
        if (objBnDisponibilidadPresupuestal.getMode().equals("B")) {
            result = "" + objDsDisponibilidadPresupuestal.getListaDetalleDisponibilidadPresupuestal(objBnDisponibilidadPresupuestal, objUsuario.getUsuario());
        }
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (objBnDisponibilidadPresupuestal.getMode()) {
            case "disponibilidadPresupuestal":
                dispatcher = request.getRequestDispatcher("Ejecucion/DisponibilidadPresupuestal.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaDisponibilidadPresupuestal.jsp");
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
