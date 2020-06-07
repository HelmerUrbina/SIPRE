/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Logistica;

import BusinessServices.Beans.BeanPAACProcesos;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CombosDAO;
import DataService.Despachadores.Impl.CombosDAOImpl;
import DataService.Despachadores.Impl.PAACProcesosDAOImpl;
import DataService.Despachadores.PAACProcesosDAO;
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
@WebServlet(name = "PAACProcesosServlet", urlPatterns = {"/PAACProcesos"})
public class PAACProcesosServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanPAACProcesos objBnPAACProcesos;
    private Connection objConnection;
    private PAACProcesosDAO objDsPAACProcesos;

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
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnPAACProcesos = new BeanPAACProcesos();
        objBnPAACProcesos.setMode(request.getParameter("mode"));
        objBnPAACProcesos.setPeriodo(request.getParameter("periodo"));
        objBnPAACProcesos.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnPAACProcesos.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnPAACProcesos.setCodigo(Utiles.Utiles.checkNum(request.getParameter("codigo")));
        objBnPAACProcesos.setDetalle(Utiles.Utiles.checkNum(request.getParameter("detalle")));
        objDsPAACProcesos = new PAACProcesosDAOImpl(objConnection);
        // DE ACUERO AL MODO, OBTENEMOS LOS DATOS NECESARIOS.          
        if (objBnPAACProcesos.getMode().equals("G")) {
            if (request.getAttribute("objPAACProcesos") != null) {
                request.removeAttribute("objPAACProcesos");
            }
            request.setAttribute("objPAACProcesos", objDsPAACProcesos.getListaPAACProcesos(objBnPAACProcesos, objUsuario.getUsuario()));
            CombosDAO objCombos = new CombosDAOImpl(objConnection);
            if (request.getAttribute("objTipoProcesoContratacion") != null) {
                request.removeAttribute("objTipoProcesoContratacion");
            }
            request.setAttribute("objTipoProcesoContratacion", objCombos.getTipoProcesoContratacion());
            if (request.getAttribute("objProcesoDocumento") != null) {
                request.removeAttribute("objProcesoDocumento");
            }
            request.setAttribute("objProcesoDocumento", objCombos.getProcesoDocumento());
        }
        if (objBnPAACProcesos.getMode().equals("U")) {
            objBnPAACProcesos = objDsPAACProcesos.getPAACProceso(objBnPAACProcesos, objUsuario.getUsuario());
            result = objBnPAACProcesos.getNumeroPAAC() + "+++"
                    + objBnPAACProcesos.getTipoProcesoContratacion() + "+++"
                    + objBnPAACProcesos.getProcesoEtapa() + "+++"
                    + objBnPAACProcesos.getProcesoDocumento() + "+++"
                    + objBnPAACProcesos.getTipoProcedimiento() + "+++"
                    + objBnPAACProcesos.getNumeroProceso() + "+++"
                    + objBnPAACProcesos.getDescripcion() + "+++"
                    + objBnPAACProcesos.getMontoProceso() + "+++"
                    + objBnPAACProcesos.getConvocatoria() + "+++"
                    + objBnPAACProcesos.getParticipantes() + "+++"
                    + objBnPAACProcesos.getObservaciones() + "+++"
                    + objBnPAACProcesos.getAbsolucion() + "+++"
                    + objBnPAACProcesos.getIntegracion() + "+++"
                    + objBnPAACProcesos.getOfertas() + "+++"
                    + objBnPAACProcesos.getEvaluacion() + "+++"
                    + objBnPAACProcesos.getBuenaPro() + "+++"
                    + objBnPAACProcesos.getConsentimiento() + "+++"
                    + objBnPAACProcesos.getContrato() + "+++"
                    + objBnPAACProcesos.getMontoContrato() + "+++"
                    + objBnPAACProcesos.getCompras();
        }
        if (objBnPAACProcesos.getMode().equals("M")) {
            objBnPAACProcesos = objDsPAACProcesos.getPAACProcesoDetalle(objBnPAACProcesos, objUsuario.getUsuario());
            result = objBnPAACProcesos.getCertificado() + "+++"
                    + objBnPAACProcesos.getNumeroContrato() + "+++"
                    + objBnPAACProcesos.getMontoContrato() + "+++"
                    + objBnPAACProcesos.getFechaInicio() + "+++"
                    + objBnPAACProcesos.getFechaFin() + "+++"
                    + objBnPAACProcesos.getAcumulado() + "+++"
                    + objBnPAACProcesos.getPendiente() + "+++"
                    + objBnPAACProcesos.getEnero() + "+++"
                    + objBnPAACProcesos.getFebrero() + "+++"
                    + objBnPAACProcesos.getMarzo() + "+++"
                    + objBnPAACProcesos.getAbril() + "+++"
                    + objBnPAACProcesos.getMayo() + "+++"
                    + objBnPAACProcesos.getJunio() + "+++"
                    + objBnPAACProcesos.getJulio() + "+++"
                    + objBnPAACProcesos.getAgosto() + "+++"
                    + objBnPAACProcesos.getSetiembre() + "+++"
                    + objBnPAACProcesos.getOctubre() + "+++"
                    + objBnPAACProcesos.getNoviembre() + "+++"
                    + objBnPAACProcesos.getDiciembre();            
        }
        if (objBnPAACProcesos.getMode().equals("B")) {
            result = "" + objDsPAACProcesos.getListaPAACProcesosDetalle(objBnPAACProcesos, objUsuario.getUsuario());
        }
        if (objBnPAACProcesos.getMode().equals("C")) {
            result = "" + objDsPAACProcesos.getListaPAACProcesosAfectacion(objBnPAACProcesos, objUsuario.getUsuario());
        }
        //SE ENVIA DE ACUERDO AL MODO SELECCIONADO
        switch (request.getParameter("mode")) {
            case "paacProcesos":
                dispatcher = request.getRequestDispatcher("Logistica/PAACProcesos.jsp");
                break;
            case "G":
                dispatcher = request.getRequestDispatcher("Logistica/ListaPAACProcesos.jsp");
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
