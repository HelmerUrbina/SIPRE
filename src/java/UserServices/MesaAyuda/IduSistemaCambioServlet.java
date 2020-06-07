/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package UserServices.MesaAyuda;

import BusinessServices.Beans.BeanMsgerr;
import BusinessServices.Beans.BeanSistemaCambio;
import BusinessServices.Beans.BeanUsuario;
import DataService.Despachadores.Impl.MsgerrDAOImpl;
import DataService.Despachadores.Impl.SistemaCambioDAOImpl;
import DataService.Despachadores.MsgerrDAO;
import DataService.Despachadores.SistemaCambioDAO;
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
@WebServlet(name = "IduSistemaCambioServlet", urlPatterns = {"/IduSistemaCambio"})
public class IduSistemaCambioServlet extends HttpServlet {

    private ServletConfig config = null;
    private ServletContext context = null;
    private HttpSession session = null;
    private RequestDispatcher dispatcher = null;
    private BeanSistemaCambio objBnSistemaCambio;
    private Connection objConnection;
    private SistemaCambioDAO objDsSistemaCambio;
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
        java.util.Date fecha_util = sdf.parse(Utiles.Utiles.checkFecha(request.getParameter("fecha")));
        sdf.setLenient(false); //No Complaciente en Fecha  
        java.util.Date fechaSolucion_util = sdf.parse(Utiles.Utiles.checkFecha(request.getParameter("fechaSolucion")));
        objBnSistemaCambio = new BeanSistemaCambio();
        objBnSistemaCambio.setMode(request.getParameter("mode"));
        objBnSistemaCambio.setPeriodo(request.getParameter("periodo"));
        objBnSistemaCambio.setUsuario(request.getParameter("usuario"));
        objBnSistemaCambio.setCodigo(request.getParameter("codigo"));
        objBnSistemaCambio.setFecha(new java.sql.Date(fecha_util.getTime()));
        objBnSistemaCambio.setUnidadOperativa(request.getParameter("unidadOperativa"));
        objBnSistemaCambio.setFase(request.getParameter("fase"));
        objBnSistemaCambio.setAsunto(request.getParameter("asunto"));
        objBnSistemaCambio.setDescripcion(request.getParameter("descripcion"));
        objBnSistemaCambio.setObservacion(request.getParameter("observacion"));
        objBnSistemaCambio.setFechaSolucion(new java.sql.Date(fechaSolucion_util.getTime()));
        objBnSistemaCambio.setAccion(request.getParameter("solucion"));
        objDsSistemaCambio = new SistemaCambioDAOImpl(objConnection);
        // EJECUTAMOS EL PROCEDIMIENTO SEGUN EL MODO QUE SE ESTA TRABAJANDO
        int k = objDsSistemaCambio.iduSistemaCambio(objBnSistemaCambio, objUsuario.getUsuario());
        if (k != 0) {
        } else {
            // EN CASO DE HABER PROBLEMAS DESPACHAMOS UNA VENTANA DE ERROR, MOSTRANDO EL ERROR OCURRIDO.
            objBnMsgerr = new BeanMsgerr();
            objBnMsgerr.setUsuario(objUsuario.getUsuario());
            objBnMsgerr.setTabla("SIPE_SISTEMA_CAMBIO");
            objBnMsgerr.setTipo(objBnSistemaCambio.getMode());
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
            Logger.getLogger(IduSistemaCambioServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(IduSistemaCambioServlet.class.getName()).log(Level.SEVERE, null, ex);
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
