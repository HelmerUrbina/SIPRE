/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanEjecucionPresupuestal;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.CertificadoPresupuestalDAO;
import DataService.Despachadores.Impl.CertificadoPresupuestalDAOImpl;
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
@WebServlet(name = "IduCertificadoPresupuestalServlet", urlPatterns = {"/IduCertificadoPresupuestal"})
@MultipartConfig(location = "D:/SIPRE/EJECUCION/CertificadoPresupuestal")
public class IduCertificadoPresupuestalServlet extends HttpServlet {
    
    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanEjecucionPresupuestal objBnSolicitud;
    private Connection objConnection;
    private CertificadoPresupuestalDAO objDsSolicitud;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;

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
        objBnSolicitud = new BeanEjecucionPresupuestal();
        objBnSolicitud.setMode(request.getParameter("mode"));
        objBnSolicitud.setPeriodo(request.getParameter("periodo"));
        objBnSolicitud.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnSolicitud.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnSolicitud.setSolicitudCredito(request.getParameter("nroCertificado"));
        objBnSolicitud.setTipoCalendario(request.getParameter("tipoCalendario"));
        objBnSolicitud.setSubTipoCalendario(request.getParameter("subTipoCalendario"));
        objBnSolicitud.setCertificado(request.getParameter("solicitudCredito"));
        objBnSolicitud.setDocumentoReferencia(request.getParameter("documentoReferencia"));
        objBnSolicitud.setOficio(request.getParameter("observacion"));
        objBnSolicitud.setDetalle(request.getParameter("detalle"));
        objBnSolicitud.setFecha(new java.sql.Date(fecha_util.getTime()));
        objBnSolicitud.setImporte(Utiles.checkDouble(request.getParameter("importe")));
        objBnSolicitud.setTipoMoneda(request.getParameter("tipoMoneda"));
        objBnSolicitud.setTipoCambio(Utiles.checkDouble(request.getParameter("tipoCambio")));
        objBnSolicitud.setMonedaExtranjera(Utiles.checkDouble(request.getParameter("monedaExtranjera")));
        objBnSolicitud.setTipo(request.getParameter("tipoSolicitud"));
        objBnSolicitud.setDisponibilidadPresupuestal(request.getParameter("informeDisponibilidad"));
        objBnSolicitud.setProcesoSeleccion(request.getParameter("paac"));
        objDsSolicitud = new CertificadoPresupuestalDAOImpl(objConnection);
        String k = "0";
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        switch (objBnSolicitud.getMode()) {
            case "D":
                k = objDsSolicitud.iduCertificado(objBnSolicitud, objUsuario.getUsuario());
                break;
            case "A":
                k = ""+objDsSolicitud.iduGenerarSolicitud(objBnSolicitud, objUsuario.getUsuario());
                break;
            case "C": {
                response.setContentType("text/html;charset=UTF-8");
                Collection<Part> parts = request.getParts();
                for (Part part : parts) {
                    if (null != Utiles.getFileName(part)) {
                        objBnSolicitud.setDocumentoReferencia(Utiles.stripAccents(Utiles.getFileName(part)));
                        part.write(objBnSolicitud.getPeriodo() + "-" + objBnSolicitud.getUnidadOperativa() + "-" + objBnSolicitud.getPresupuesto() + "-" + objBnSolicitud.getSolicitudCredito() + "-" + objBnSolicitud.getDocumentoReferencia());
                    }
                }
                k = objDsSolicitud.iduCertificado(objBnSolicitud, objUsuario.getUsuario());
                break;
            }
            case "S":
                k = ""+objDsSolicitud.iduCertificadoSIAF(objBnSolicitud, objUsuario.getUsuario());
                break;
            case "R":
                k = objDsSolicitud.iduCertificado(objBnSolicitud, objUsuario.getUsuario());
                break;
            default:
                k = objDsSolicitud.iduCertificado(objBnSolicitud, objUsuario.getUsuario());
                if(objBnSolicitud.getMode().equals("I")){
                    objBnSolicitud.setSolicitudCredito(k);
                }
                if (!k.equals("0")) {
                    objBnSolicitud.setCorrelativo(0);
                    objBnSolicitud.setResolucion(0);
                    objBnSolicitud.setMode("D");
                    k = ""+objDsSolicitud.iduCertificadoDetalle(objBnSolicitud, objUsuario.getUsuario());
                    String lista[][] = Utiles.generaLista(request.getParameter("lista"), 8);
                    for (String[] item : lista) {
                        objBnSolicitud.setMode("I");
                        objBnSolicitud.setCorrelativo(Integer.valueOf(item[0].trim() + 1));
                        objBnSolicitud.setDependencia(item[1]);
                        objBnSolicitud.setSecuenciaFuncional(item[2]);
                        objBnSolicitud.setTareaPresupuestal(item[3]);
                        objBnSolicitud.setCadenaGasto(item[4]);
                        objBnSolicitud.setImporte(Utiles.checkDouble(item[5]));
                        objBnSolicitud.setMonedaExtranjera(Utiles.checkDouble(item[6]));
                        objBnSolicitud.setResolucion(Integer.valueOf(item[7].trim()));
                        k = ""+objDsSolicitud.iduCertificadoDetalle(objBnSolicitud, objUsuario.getUsuario());
                    }
                    if (k.equals("0")) {
                        result = "ERROR";
                        objBnMsgerr = new BeanMsgerr();
                        objBnMsgerr.setUsuario(objUsuario.getUsuario());
                        objBnMsgerr.setTabla("TASOCP");
                        objBnMsgerr.setTipo(objBnSolicitud.getMode());
                        objDsMsgerr = new MsgerrDAOImpl(objConnection);
                        objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
                        resulDetalle = objBnMsgerr.getDescripcion();
                    }
                }
                break;
        }
        // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
        if (k.equals("0")) {
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("TASOCP");
            objBnMsgerr.setTipo(objBnSolicitud.getMode());
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
            Logger.getLogger(IduCertificadoPresupuestalServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(IduCertificadoPresupuestalServlet.class.getName()).log(Level.SEVERE, null, ex);
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
