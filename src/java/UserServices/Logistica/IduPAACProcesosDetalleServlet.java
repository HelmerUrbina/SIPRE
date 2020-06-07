/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Logistica;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPAACProcesos;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.PAACProcesosDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PAACProcesosDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
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
@WebServlet(name = "IduPAACProcesosDetalleServlet", urlPatterns = {"/IduPAACProcesosDetalle"})
public class IduPAACProcesosDetalleServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanPAACProcesos objBnPAACProcesos;
    private Connection objConnection;
    private PAACProcesosDAO objDsPAACProcesos;
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
        session = request.getSession();
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        sdf.setLenient(false); //No Complaciente en Fecha  
        java.util.Date fechaInicio = sdf.parse(Utiles.Utiles.checkFecha(request.getParameter("fechaInicio")));        
        sdf.setLenient(false); //No Complaciente en Fecha  
        java.util.Date fechaFin = sdf.parse(Utiles.Utiles.checkFecha(request.getParameter("fechaFin")));
        objBnPAACProcesos = new BeanPAACProcesos();
        objBnPAACProcesos.setMode(request.getParameter("mode"));
        objBnPAACProcesos.setPeriodo(request.getParameter("periodo"));
        objBnPAACProcesos.setPresupuesto(Utiles.Utiles.checkNum(request.getParameter("presupuesto")));
        objBnPAACProcesos.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnPAACProcesos.setCodigo(Utiles.Utiles.checkNum(request.getParameter("codigo")));
        objBnPAACProcesos.setDetalle(Utiles.Utiles.checkNum(request.getParameter("detalle")));
        objBnPAACProcesos.setCertificado(request.getParameter("compromisoAnual"));
        objBnPAACProcesos.setNumeroContrato(request.getParameter("numeroContrato"));
        objBnPAACProcesos.setMontoContrato(Utiles.Utiles.checkDouble(request.getParameter("montoContrato")));
        objBnPAACProcesos.setAcumulado(Utiles.Utiles.checkDouble(request.getParameter("acumulado")));
        objBnPAACProcesos.setPendiente(Utiles.Utiles.checkDouble(request.getParameter("pendiente")));
        objBnPAACProcesos.setEnero(Utiles.Utiles.checkDouble(request.getParameter("enero")));
        objBnPAACProcesos.setFebrero(Utiles.Utiles.checkDouble(request.getParameter("febrero")));
        objBnPAACProcesos.setMarzo(Utiles.Utiles.checkDouble(request.getParameter("marzo")));
        objBnPAACProcesos.setAbril(Utiles.Utiles.checkDouble(request.getParameter("abril")));
        objBnPAACProcesos.setMayo(Utiles.Utiles.checkDouble(request.getParameter("mayo")));
        objBnPAACProcesos.setJunio(Utiles.Utiles.checkDouble(request.getParameter("junio")));
        objBnPAACProcesos.setJulio(Utiles.Utiles.checkDouble(request.getParameter("julio")));
        objBnPAACProcesos.setAgosto(Utiles.Utiles.checkDouble(request.getParameter("agosto")));
        objBnPAACProcesos.setSetiembre(Utiles.Utiles.checkDouble(request.getParameter("setiembre")));
        objBnPAACProcesos.setOctubre(Utiles.Utiles.checkDouble(request.getParameter("octubre")));
        objBnPAACProcesos.setNoviembre(Utiles.Utiles.checkDouble(request.getParameter("noviembre")));
        objBnPAACProcesos.setDiciembre(Utiles.Utiles.checkDouble(request.getParameter("diciembre")));
        objBnPAACProcesos.setFechaInicio(new java.sql.Date(fechaInicio.getTime()));
        objBnPAACProcesos.setFechaFin(new java.sql.Date(fechaFin.getTime()));
        objDsPAACProcesos = new PAACProcesosDAOImpl(objConnection);
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        int k = objDsPAACProcesos.iduPAACProcesosDetalle(objBnPAACProcesos, objUsuario.getUsuario());
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPRE_PAAC_PROCESOS_DETALLE");
            objBnMsgerr.setTipo(objBnPAACProcesos.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            result = objBnMsgerr.getDescripcion();
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
                out.print(result);
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
            Logger.getLogger(IduPAACProcesosDetalleServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(IduPAACProcesosDetalleServlet.class.getName()).log(Level.SEVERE, null, ex);
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
