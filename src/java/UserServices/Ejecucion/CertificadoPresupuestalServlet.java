/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanEjecucionPresupuestal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.CertificadoPresupuestalDAOImpl;
import DataService.Despachadores.CertificadoPresupuestalDAO;
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
@WebServlet(name = "CertificadoPresupuestalServlet", urlPatterns = {"/CertificadoPresupuestal"})
public class CertificadoPresupuestalServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objCertificado;
    private List objCertificadoDetalle;
    private BeanEjecucionPresupuestal objBnCertificado;
    private Connection objConnection;
    private CertificadoPresupuestalDAO objDsCertificado;
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
        String result = null;
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnCertificado = new BeanEjecucionPresupuestal();
        objBnCertificado.setMode(request.getParameter("mode"));
        objBnCertificado.setPeriodo(request.getParameter("periodo"));
        objBnCertificado.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnCertificado.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnCertificado.setSolicitudCredito(request.getParameter("codigo"));
        objDsCertificado = new CertificadoPresupuestalDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.    
        if (objBnCertificado.getMode().equals("G")) {
            objCertificado = objDsCertificado.getListaCertificados(objBnCertificado, objUsuario.getUsuario());
            objCertificadoDetalle = objDsCertificado.getListaCertificadosDetalle(objBnCertificado, objUsuario.getUsuario());
            objDsCombo = new CombosDAOImpl(objConnection);
            if (request.getAttribute("objTipoCalendario") != null) {
                request.removeAttribute("objTipoCalendario");
            }
            request.setAttribute("objTipoCalendario", objDsCombo.getTipoCalendarioUnidad(objBnCertificado.getPeriodo(), objBnCertificado.getPresupuesto(), objBnCertificado.getUnidadOperativa()));
        }
        if (objBnCertificado.getMode().equals("I") || objBnCertificado.getMode().equals("AM") || objBnCertificado.getMode().equals("RE")) {
            result = objDsCertificado.getNumeroCertificado(objBnCertificado, objUsuario.getUsuario());
        }
        if (objBnCertificado.getMode().equals("U")) {
            objBnCertificado = objDsCertificado.getCertificado(objBnCertificado, objUsuario.getUsuario());
            result = objBnCertificado.getSolicitudCredito() + "+++"
                    + objBnCertificado.getFecha() + "+++"
                    + objBnCertificado.getTipoCalendario() + "+++"
                    + objBnCertificado.getSubTipoCalendario() + "+++"
                    + objBnCertificado.getDocumentoReferencia() + "+++"
                    + objBnCertificado.getDetalle() + "+++"
                    + objBnCertificado.getOficio() + "+++"
                    + objBnCertificado.getProcesoSeleccion() + "+++"
                    + objBnCertificado.getCertificado() + "+++"
                    + objBnCertificado.getTipoMoneda() + "+++"
                    + objBnCertificado.getTipoCambio() + "+++"
                    + objBnCertificado.getMonedaExtranjera() + "+++"
                    + objBnCertificado.getDependencia();
        }
        if (objBnCertificado.getMode().equals("B")) {
            result = "" + objDsCertificado.getListaCertificadoDetalle(objBnCertificado, objUsuario.getUsuario());
        }
        if (request.getAttribute("objCertificado") != null) {
            request.removeAttribute("objCertificado");
        }
        if (request.getAttribute("objCertificadoDetalle") != null) {
            request.removeAttribute("objCertificadoDetalle");
        }
        request.setAttribute("objCertificado", objCertificado);
        request.setAttribute("objCertificadoDetalle", objCertificadoDetalle);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (objBnCertificado.getMode()) {
            case "G":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaCertificadoPresupuestal.jsp");
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
