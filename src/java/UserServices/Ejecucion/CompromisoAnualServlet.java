/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanEjecucionPresupuestal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.CompromisoAnualDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.CompromisoAnualDAOImpl;
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
@WebServlet(name = "CompromisoAnualServlet", urlPatterns = {"/CompromisoAnual"})
public class CompromisoAnualServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objCompromisoAnual;
    private List objCompromisoAnualDetalle;
    private BeanEjecucionPresupuestal objBnCompromisoAnual;
    private Connection objConnection;
    private CompromisoAnualDAO objDsCompromisoAnual;
    private CombosDAO objDsCombos;

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
        objBnCompromisoAnual = new BeanEjecucionPresupuestal();
        objBnCompromisoAnual.setMode(request.getParameter("mode"));
        objBnCompromisoAnual.setPeriodo(request.getParameter("periodo"));
        objBnCompromisoAnual.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnCompromisoAnual.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnCompromisoAnual.setCompromisoAnual(request.getParameter("codigo"));
        objDsCompromisoAnual = new CompromisoAnualDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.
        if (objBnCompromisoAnual.getMode().equals("G") || objBnCompromisoAnual.getMode().equals("GC")) {
            objDsCombos = new CombosDAOImpl(objConnection);
            objCompromisoAnual = objDsCompromisoAnual.getListaCompromisosAnuales(objBnCompromisoAnual, objUsuario.getUsuario());
            objCompromisoAnualDetalle = objDsCompromisoAnual.getListaCompromisosAnualesDetalle(objBnCompromisoAnual, objUsuario.getUsuario());
            if (request.getAttribute("objSolicitudCredito") != null) {
                request.removeAttribute("objSolicitudCredito");
            }
            request.setAttribute("objSolicitudCredito", objDsCombos.getSolicitudCreditoUnidad(objBnCompromisoAnual.getPeriodo(), objBnCompromisoAnual.getPresupuesto(), objBnCompromisoAnual.getUnidadOperativa()));
        }
        if (objBnCompromisoAnual.getMode().equals("I") || objBnCompromisoAnual.getMode().equals("AM") || objBnCompromisoAnual.getMode().equals("RE")) {
            result = objDsCompromisoAnual.getNumeroCompromisoAnual(objBnCompromisoAnual, objUsuario.getUsuario());
        }
        if (objBnCompromisoAnual.getMode().equals("U")) {
            objBnCompromisoAnual = objDsCompromisoAnual.getCompromisoAnual(objBnCompromisoAnual, objUsuario.getUsuario());
            result = objBnCompromisoAnual.getSolicitudCredito() + "+++"
                    + objBnCompromisoAnual.getFecha() + "+++"
                    + objBnCompromisoAnual.getDocumentoReferencia() + "+++"
                    + objBnCompromisoAnual.getDetalle() + "+++"
                    + objBnCompromisoAnual.getOficio() + "+++"
                    + objBnCompromisoAnual.getImporte() + "+++"
                    + objBnCompromisoAnual.getTipoMoneda() + "+++"
                    + objBnCompromisoAnual.getTipoCambio() + "+++"
                    + objBnCompromisoAnual.getMonedaExtranjera() + "+++"
                    + objBnCompromisoAnual.getTipo() + "+++"
                    + objBnCompromisoAnual.getSectorista();
        }
        if (objBnCompromisoAnual.getMode().equals("B")) {
            result = "" + objDsCompromisoAnual.getListaCompromisoAnualDetalle(objBnCompromisoAnual, objUsuario.getUsuario());
        }
        if (objBnCompromisoAnual.getMode().equals("CAL")) {
            result = "" + objDsCompromisoAnual.getTipoCalendarioSolicitud(objBnCompromisoAnual, objUsuario.getUsuario());
        }
        if (request.getAttribute("objCompromisoAnual") != null) {
            request.removeAttribute("objCompromisoAnual");
        }
        if (request.getAttribute("objCompromisoAnualDetalle") != null) {
            request.removeAttribute("objCompromisoAnualDetalle");
        }
        request.setAttribute("objCompromisoAnual", objCompromisoAnual);
        request.setAttribute("objCompromisoAnualDetalle", objCompromisoAnualDetalle);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (objBnCompromisoAnual.getMode()) {
            case "G":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaCompromisoAnual.jsp");
                break;
            case "GC":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaCompromisoAnualConsulta.jsp");
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
