/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanEjecucionPresupuestal;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.DeclaracionJuradaDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.DeclaracionJuradaDAOImpl;
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
@WebServlet(name = "DeclaracionJuradaServlet", urlPatterns = {"/DeclaracionJurada"})
public class DeclaracionJuradaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private List objDeclaracionJurada;
    private List objDeclaracionJuradaDetalle;
    private BeanEjecucionPresupuestal objBnDeclaracionJurada;
    private Connection objConnection;
    private DeclaracionJuradaDAO objDsDeclaracionJurada;
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
        objBnDeclaracionJurada = new BeanEjecucionPresupuestal();
        objBnDeclaracionJurada.setMode(request.getParameter("mode"));
        objBnDeclaracionJurada.setPeriodo(request.getParameter("periodo"));
        objBnDeclaracionJurada.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnDeclaracionJurada.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnDeclaracionJurada.setMes(request.getParameter("mes"));
        objBnDeclaracionJurada.setDeclaracionJurada(request.getParameter("codigo"));
        objBnDeclaracionJurada.setCompromisoAnual(request.getParameter("compromisoAnual"));
        objDsDeclaracionJurada = new DeclaracionJuradaDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.
        if (objBnDeclaracionJurada.getMode().equals("G")) {
            objDeclaracionJurada = objDsDeclaracionJurada.getListaDeclaracionJurada(objBnDeclaracionJurada, objUsuario.getUsuario());
            objDeclaracionJuradaDetalle = objDsDeclaracionJurada.getListaDeclaracionJuradaDetalle(objBnDeclaracionJurada, objUsuario.getUsuario());
            objDsCombos = new CombosDAOImpl(objConnection);
            if (request.getAttribute("objCompromisosAnuales") != null) {
                request.removeAttribute("objCompromisosAnuales");
            }
            request.setAttribute("objCompromisosAnuales", objDsCombos.getCompromisoAnualUnidad(objBnDeclaracionJurada.getPeriodo(), objBnDeclaracionJurada.getPresupuesto(), objBnDeclaracionJurada.getUnidadOperativa()));
        }
        if (objBnDeclaracionJurada.getMode().equals("I")) {
            result = objDsDeclaracionJurada.getNumeroDeclaracionJurada(objBnDeclaracionJurada, objUsuario.getUsuario());
        }
        if (objBnDeclaracionJurada.getMode().equals("U")) {
            objBnDeclaracionJurada = objDsDeclaracionJurada.getDeclaracionJurada(objBnDeclaracionJurada, objUsuario.getUsuario());
            result = objBnDeclaracionJurada.getCompromisoAnual() + "+++"
                    + objBnDeclaracionJurada.getDocumentoReferencia() + "+++"
                    + objBnDeclaracionJurada.getDetalle() + "+++"
                    + objBnDeclaracionJurada.getOficio() + "+++"
                    + objBnDeclaracionJurada.getTipoCalendario() + "+++"
                    + objBnDeclaracionJurada.getFecha() + "+++"
                    + objBnDeclaracionJurada.getTipo() + "+++"
                    + objBnDeclaracionJurada.getTipoCambio() + "+++"
                    + objBnDeclaracionJurada.getSubTipoCalendario();
        }
        if (objBnDeclaracionJurada.getMode().equals("B")) {
            result = "" + objDsDeclaracionJurada.getListaDetalleDeclaracionJurada(objBnDeclaracionJurada, objUsuario.getUsuario());
        }
        if (objBnDeclaracionJurada.getMode().equals("CAL")) {
            objBnDeclaracionJurada = objDsDeclaracionJurada.getTipoCalendarioCompromiso(objBnDeclaracionJurada, objUsuario.getUsuario());
            result = objBnDeclaracionJurada.getTipoCalendario() + "+++"
                    + objBnDeclaracionJurada.getDocumentoReferencia();
        }
        if (objBnDeclaracionJurada.getMode().equals("R")) {
            objBnDeclaracionJurada = objDsDeclaracionJurada.getDeclaracionJurada(objBnDeclaracionJurada, objUsuario.getUsuario());
            result = objDsDeclaracionJurada.getNumeroDeclaracionJurada(objBnDeclaracionJurada, objUsuario.getUsuario()) + "+++"
                    + objBnDeclaracionJurada.getCompromisoAnual() + "+++"
                    + objBnDeclaracionJurada.getDocumentoReferencia()+ "+++"
                    + objBnDeclaracionJurada.getTipoCambio();
        }
        if (request.getAttribute("objDeclaracionJurada") != null) {
            request.removeAttribute("objDeclaracionJurada");
        }
        if (request.getAttribute("objDeclaracionJuradaDetalle") != null) {
            request.removeAttribute("objDeclaracionJuradaDetalle");
        }
        request.setAttribute("objDeclaracionJurada", objDeclaracionJurada);
        request.setAttribute("objDeclaracionJuradaDetalle", objDeclaracionJuradaDetalle);
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (objBnDeclaracionJurada.getMode()) {
            case "G":
                dispatcher = request.getRequestDispatcher("Ejecucion/ListaDeclaracionJurada.jsp");
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
