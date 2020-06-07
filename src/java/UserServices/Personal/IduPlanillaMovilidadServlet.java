/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.Personal;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanPlanillaMovilidad;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.PlanillaMovilidadDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.PlanillaMovilidadDAO;
import Utiles.Utiles;
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
 * @author hateccsiv
 */
@WebServlet(name = "IduPlanillaMovilidadServlet", urlPatterns = {"/IduPlanillaMovilidad"})
public class IduPlanillaMovilidadServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanPlanillaMovilidad objBnPlanillaMovilidad;
    private Connection objConnection;
    private PlanillaMovilidadDAO objDsPlanillaMovilidad;
    private BeanMsgerr objBnMsgerr = null;
    private MsgerrDAO objDsMsgerr;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        config = this.getServletConfig();
        context = config.getServletContext();
        session = request.getSession();
        BeanUsuario objUsuario = (BeanUsuario) session.getAttribute("objUsuario" + session.getId());
        //VERIFICAMOS QUE LA SESSION SEA VALIDA
        if (objUsuario == null) {
            dispatcher = request.getRequestDispatcher("/FinSession.jsp");
            dispatcher.forward(request, response);
        }
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        sdf.setLenient(false); //No Complaciente en Fecha        
        java.util.Date fecha = sdf.parse(request.getParameter("fechaMovilidad"));
        objConnection = (Connection) context.getAttribute("objConnection");
        String result = null;
        objBnPlanillaMovilidad = new BeanPlanillaMovilidad();
        objBnPlanillaMovilidad.setMode(request.getParameter("mode"));
        objBnPlanillaMovilidad.setPeriodo(request.getParameter("periodo"));
        objBnPlanillaMovilidad.setMes(request.getParameter("mes"));
        objBnPlanillaMovilidad.setCorrelativo(Utiles.checkNum(request.getParameter("correlativo")));
        objBnPlanillaMovilidad.setLugarOrigen(request.getParameter("origen"));
        objBnPlanillaMovilidad.setLugarDestino(request.getParameter("destino"));
        objBnPlanillaMovilidad.setJustificacion(request.getParameter("justificacion"));
        objBnPlanillaMovilidad.setImporte(Utiles.checkDouble(request.getParameter("importe")));
        objBnPlanillaMovilidad.setFechaMovilidad(new java.sql.Date(fecha.getTime()));
        objBnPlanillaMovilidad.setUsuarioPlanilla(objUsuario.getUsuario());
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        objDsPlanillaMovilidad = new PlanillaMovilidadDAOImpl(objConnection);
        int k = objDsPlanillaMovilidad.iduPlanillaMovilidad(objBnPlanillaMovilidad, objUsuario.getUsuario());
        if (k == 0) {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_PLANILLA_MOVILIDAD");
            objBnMsgerr.setTipo(objBnPlanillaMovilidad.getMode());
            objDsMsgerr = new MsgerrDAOImpl(objConnection);
            objBnMsgerr = objDsMsgerr.getMsgerr(objBnMsgerr);
            result = objBnMsgerr.getDescripcion();
        }
        // EN CASO DE NO HABER PROBLEMAS RETORNAMOS UNA NUEVA CONSULTA CON TODOS LOS DATOS.
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            if (result == null) {
                out.print("GUARDO");
            } else {
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
            Logger.getLogger(IduPlanillaMovilidadServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(IduPlanillaMovilidadServlet.class.getName()).log(Level.SEVERE, null, ex);
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
