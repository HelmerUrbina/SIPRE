/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanEjecucionPresupuestal;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CompromisoAnualDAO;
import DataService.Despachadores.Impl.CompromisoAnualDAOImpl;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import Utiles.Utiles;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author H-URBINA-M
 */
@WebServlet(name = "IduCompromisoAnualServlet", urlPatterns = {"/IduCompromisoAnual"})
@MultipartConfig(location = "D:/SIPRE/EJECUCION/CompromisoAnual")
public class IduCompromisoAnualServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanEjecucionPresupuestal objBnCompromisoAnual;
    private Connection objConnection;
    private CompromisoAnualDAO objDsCompromisoAnual;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;
    private static final long serialVersionUID = 1L;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * @throws java.text.ParseException
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession(true);
        String result = null;
        String resulDetalle = null;
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        sdf.setLenient(false); //No Complaciente en Fecha
        java.util.Date fecha_util = sdf.parse(Utiles.checkFecha(request.getParameter("fecha")));
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnCompromisoAnual = new BeanEjecucionPresupuestal();
        objBnCompromisoAnual.setMode(request.getParameter("mode"));
        objBnCompromisoAnual.setPeriodo(request.getParameter("periodo"));
        objBnCompromisoAnual.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnCompromisoAnual.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnCompromisoAnual.setCompromisoAnual(request.getParameter("nroCompromisoAnual"));
        objBnCompromisoAnual.setSolicitudCredito(request.getParameter("solicitudCredito"));
        objBnCompromisoAnual.setTipoCalendario(request.getParameter("tipoCalendario"));
        objBnCompromisoAnual.setSubTipoCalendario(request.getParameter("subTipoCalendario"));
        objBnCompromisoAnual.setCertificado(request.getParameter("solicitudCompromiso"));
        objBnCompromisoAnual.setDocumentoReferencia(request.getParameter("documentoReferencia"));
        objBnCompromisoAnual.setOficio(request.getParameter("observacion"));
        objBnCompromisoAnual.setDetalle(request.getParameter("detalle"));
        objBnCompromisoAnual.setFecha(new java.sql.Date(fecha_util.getTime()));
        objBnCompromisoAnual.setImporte(Utiles.checkDouble(request.getParameter("importe")));
        objBnCompromisoAnual.setTipoMoneda(request.getParameter("tipoMoneda"));
        objBnCompromisoAnual.setTipoCambio(Utiles.checkDouble(request.getParameter("tipoCambio")));
        objBnCompromisoAnual.setMonedaExtranjera(Utiles.checkDouble(request.getParameter("monedaExtranjera")));
        objBnCompromisoAnual.setTipo(request.getParameter("tipoCompromiso"));
        objDsCompromisoAnual = new CompromisoAnualDAOImpl(objConnection);
        int k = 0;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        switch (objBnCompromisoAnual.getMode()) {
            case "D":
                k = objDsCompromisoAnual.iduCompromisoAnual(objBnCompromisoAnual, objUsuario.getUsuario());
                break;
            case "A":
                k = objDsCompromisoAnual.iduCompromisoAnual(objBnCompromisoAnual, objUsuario.getUsuario());
                break;
            case "R":
                k = objDsCompromisoAnual.iduCompromisoAnual(objBnCompromisoAnual, objUsuario.getUsuario());
                break;
            case "T":
                k = objDsCompromisoAnual.iduTransferirCompromisoAnual(objBnCompromisoAnual, objUsuario.getUsuario());
                break;
            case "C": {
                response.setContentType("text/html;charset=UTF-8");
                Collection<Part> parts = request.getParts();
                for (Part part : parts) {
                    if (null != Utiles.getFileName(part)) {
                        objBnCompromisoAnual.setDocumentoReferencia(Utiles.getFileName(part));
                        part.write(objBnCompromisoAnual.getPeriodo() + "-" + objBnCompromisoAnual.getUnidadOperativa() + "-" + objBnCompromisoAnual.getPresupuesto() + "-" + objBnCompromisoAnual.getCompromisoAnual() + "-" + objBnCompromisoAnual.getDocumentoReferencia());
                    }
                }
                k = objDsCompromisoAnual.iduCompromisoAnual(objBnCompromisoAnual, objUsuario.getUsuario());
                break;
            }
            default:
                k = objDsCompromisoAnual.iduCompromisoAnual(objBnCompromisoAnual, objUsuario.getUsuario());
                if (k != 0) {
                    String lista[][] = Utiles.generaLista(request.getParameter("lista"), 9);
                    objBnCompromisoAnual.setMode("D");
                    objBnCompromisoAnual.setCorrelativo(0);
                    objBnCompromisoAnual.setResolucion(0);
                    k = objDsCompromisoAnual.iduCompromisoAnualDetalle(objBnCompromisoAnual, objUsuario.getUsuario());
                    for (String[] item : lista) {
                        objBnCompromisoAnual.setMode("I");
                        objBnCompromisoAnual.setCorrelativo(Integer.valueOf(item[0].trim() + 1));
                        objBnCompromisoAnual.setUnidad(item[1]);
                        objBnCompromisoAnual.setDependencia(item[2]);
                        objBnCompromisoAnual.setSecuenciaFuncional(item[3]);
                        objBnCompromisoAnual.setTareaPresupuestal(item[4]);
                        objBnCompromisoAnual.setCadenaGasto(item[5]);
                        objBnCompromisoAnual.setImporte(Utiles.checkDouble(item[6]));
                        objBnCompromisoAnual.setMonedaExtranjera(Utiles.checkDouble(item[7]));
                        objBnCompromisoAnual.setResolucion(Integer.valueOf(item[8].trim()));
                        k = objDsCompromisoAnual.iduCompromisoAnualDetalle(objBnCompromisoAnual, objUsuario.getUsuario());
                    }
                    if (k == 0) {
                        result = "ERROR";
                        objBnMsgerr = new BeanMsgerr();
                        objBnMsgerr.setUsuario(objUsuario.getUsuario());
                        objBnMsgerr.setTabla("DESOCP_CA");
                        objBnMsgerr.setTipo(objBnCompromisoAnual.getMode());
                        objDsMsgerr = new MsgerrDAOImpl(objConnection);
                        objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
                        resulDetalle = objBnMsgerr.getDescripcion();
                    }
                }
                break;
        }
        // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
        if (k == 0) {
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("TASOCP_CA");
            objBnMsgerr.setTipo(objBnCompromisoAnual.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            resulDetalle = objBnMsgerr.getDescripcion();
        }
        // EN CASO DE NO HABER PROBLEMAS RETORNAMOS UNA NUEVA CONSULTA CON TODOS LOS DATOS.
        response.setContentType("text/html;charset=UTF-8");
        if (result == null) {
            try (PrintWriter out = response.getWriter()) {
                out.print("GUARDO");
            }
        } else {
            //PROCEDEMOS A ELIMINAR TODO;
            try (PrintWriter out = response.getWriter()) {
                out.print(resulDetalle);
            }
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(IduCompromisoAnualServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(IduCompromisoAnualServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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
