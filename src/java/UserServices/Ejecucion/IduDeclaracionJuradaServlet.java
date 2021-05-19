/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Ejecucion;

import BusinessServices.Beans.BeanEjecucionPresupuestal;
import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.DeclaracionJuradaDAO;
import DataService.Despachadores.Impl.DeclaracionJuradaDAOImpl;
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
@WebServlet(name = "IduDeclaracionJuradaServlet", urlPatterns = {"/IduDeclaracionJurada"})
@MultipartConfig(location = "D:/SIPRE/EJECUCION/DeclaracionJurada",
        fileSizeThreshold = 1024 * 1024 * 10,       // 10 MB 
        maxFileSize = 1024 * 1024 * 500,            // 500 MB
        maxRequestSize = 1024 * 1024 * 1000)        // 1000 MB
public class IduDeclaracionJuradaServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanEjecucionPresupuestal objBnDeclaracionJurada;
    private Connection objConnection;
    private DeclaracionJuradaDAO objDsDeclaracionJurada;
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
        session = request.getSession(false);
        if (session == null) {
            dispatcher = request.getRequestDispatcher("FinSession.jsp");
            dispatcher.forward(request, response);
        }
        String result = null;
        String resulDetalle = null;
        // VERIFICAMOS LA SESSION DE LA SOLICITUD DE CREDITO
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        sdf.setLenient(false); //No Complaciente en Fecha
        java.util.Date fecha_util = sdf.parse(Utiles.checkFecha(request.getParameter("fecha")));
        objConnection = (Connection) context.getAttribute("objConnection");
        objBnDeclaracionJurada = new BeanEjecucionPresupuestal();
        objBnDeclaracionJurada.setMode(request.getParameter("mode"));
        objBnDeclaracionJurada.setPeriodo(request.getParameter("periodo"));
        objBnDeclaracionJurada.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnDeclaracionJurada.setPresupuesto(Utiles.checkNum(request.getParameter("presupuesto")));
        objBnDeclaracionJurada.setMes(request.getParameter("mes"));
        objBnDeclaracionJurada.setDeclaracionJurada(request.getParameter("declaracionJurada"));
        objBnDeclaracionJurada.setCompromisoAnual(request.getParameter("compromisoAnual"));
        objBnDeclaracionJurada.setTipoCalendario(request.getParameter("tipoCalendario"));
        objBnDeclaracionJurada.setSubTipoCalendario(request.getParameter("subTipoCalendario"));
        objBnDeclaracionJurada.setTipo(request.getParameter("idp"));
        objBnDeclaracionJurada.setDocumentoReferencia(request.getParameter("documentoReferencia"));
        objBnDeclaracionJurada.setOficio(request.getParameter("observacion"));
        objBnDeclaracionJurada.setDetalle(request.getParameter("detalle"));
        objBnDeclaracionJurada.setFecha(new java.sql.Date(fecha_util.getTime()));
        objBnDeclaracionJurada.setImporte(Utiles.checkDouble(request.getParameter("importe")));
        objBnDeclaracionJurada.setTipoMoneda(request.getParameter("tipoMoneda"));
        objBnDeclaracionJurada.setTipoCambio(Utiles.checkDouble(request.getParameter("tipoCambio")));
        objBnDeclaracionJurada.setMonedaExtranjera(Utiles.checkDouble(request.getParameter("monedaExtranjera")));
        objDsDeclaracionJurada = new DeclaracionJuradaDAOImpl(objConnection);
        int k = 0;
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        switch (objBnDeclaracionJurada.getMode()) {
            case "D":
                k = objDsDeclaracionJurada.iduDeclaracionJurada(objBnDeclaracionJurada, objUsuario.getUsuario());
                break;
            case "V":
                k = objDsDeclaracionJurada.iduDeclaracionJurada(objBnDeclaracionJurada, objUsuario.getUsuario());
                break;
            case "A":
                k = objDsDeclaracionJurada.iduGenerarCoberturaMensual(objBnDeclaracionJurada, objUsuario.getUsuario());
                break;
            case "C": {
                response.setContentType("text/html;charset=UTF-8");
                Collection<Part> parts = request.getParts();
                for (Part part : parts) {
                    if (null != Utiles.getFileName(part)) {
                        objBnDeclaracionJurada.setDetalle(Utiles.getFileName(part));
                        part.write(objBnDeclaracionJurada.getPeriodo() + "-" + objBnDeclaracionJurada.getUnidadOperativa() + "-" + objBnDeclaracionJurada.getPresupuesto() + "-" + objBnDeclaracionJurada.getDeclaracionJurada() + "-" + objBnDeclaracionJurada.getDetalle());
                    }
                }
                k = objDsDeclaracionJurada.iduDeclaracionJurada(objBnDeclaracionJurada, objUsuario.getUsuario());
                break;
            }
            case "T":
                k = objDsDeclaracionJurada.iduTransferirCobertura(objBnDeclaracionJurada, objUsuario.getUsuario());
                break;
            default:
                k = objDsDeclaracionJurada.iduDeclaracionJurada(objBnDeclaracionJurada, objUsuario.getUsuario());
                if (k != 0) {
                    String lista[][] = Utiles.generaLista(request.getParameter("lista"), 9);
                    objBnDeclaracionJurada.setMode("D");
                    objBnDeclaracionJurada.setCorrelativo(0);
                    objBnDeclaracionJurada.setResolucion(0);
                    k = objDsDeclaracionJurada.iduDeclaracionJuradaDetalle(objBnDeclaracionJurada, objUsuario.getUsuario());
                    for (String[] item : lista) {
                        objBnDeclaracionJurada.setMode("I");
                        objBnDeclaracionJurada.setCorrelativo(Integer.valueOf(item[0].trim() + 1));
                        objBnDeclaracionJurada.setUnidad(item[1]);
                        objBnDeclaracionJurada.setDependencia(item[2]);
                        objBnDeclaracionJurada.setSecuenciaFuncional(item[3]);
                        objBnDeclaracionJurada.setTareaPresupuestal(item[4]);
                        objBnDeclaracionJurada.setCadenaGasto(item[5]);
                        objBnDeclaracionJurada.setImporte(Utiles.checkDouble(item[6]));
                        objBnDeclaracionJurada.setMonedaExtranjera(Utiles.checkDouble(item[7]));
                        objBnDeclaracionJurada.setResolucion(Integer.valueOf(item[8].trim()));
                        k = objDsDeclaracionJurada.iduDeclaracionJuradaDetalle(objBnDeclaracionJurada, objUsuario.getUsuario());
                    }
                    if (k == 0) {
                        result = "ERROR";
                        objBnMsgerr = new BeanMsgerr();
                        objBnMsgerr.setUsuario(objUsuario.getUsuario());
                        objBnMsgerr.setTabla("DEPECO");
                        objBnMsgerr.setTipo("I");
                        objDsMsgerr = new MsgerrDAOImpl(objConnection);
                        objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
                        resulDetalle = objBnMsgerr.getDescripcion();
                    }
                }
                break;
        }
        // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
        if (k == 0 || result != null) {
            result = "ERROR";
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("TAPECO");
            objBnMsgerr.setTipo(objBnDeclaracionJurada.getMode());
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
            Logger.getLogger(IduDeclaracionJuradaServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(IduDeclaracionJuradaServlet.class.getName()).log(Level.SEVERE, null, ex);
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
